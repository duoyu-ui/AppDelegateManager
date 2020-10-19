//
//  FriendChatInfoController.m
//  Project
//
//  Created by Mike on 2019/6/25.
//  Copyright © 2019 CDJay. All rights reserved.
//  群成员详情页

#import "FriendChatInfoController.h"
#import "RCDBaseSettingTableViewCell.h"
#import "FriendChatInfoHeadCell.h"
#import "PersonalSignatureModel.h"
#import "WHC_ModelSqlite.h"


@interface FriendChatInfoController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong)  UITableView *tableView;

/// 聊天会话
@property (nonatomic,strong) FYContacts *contactsModel;

/// 个人信息
@property (nonatomic, strong) PersonalSignatureModel *personalModel;

/// 成功操作
@property (nonatomic, copy) DataBlock successBlock;

@end


@implementation FriendChatInfoController

+ (instancetype)pushFromNavVC:(UIViewController *)rootVC contacts:(FYContacts *)contacts success:(DataBlock)block
{
    FriendChatInfoController *VC = [[FriendChatInfoController alloc] init];
    [VC setSuccessBlock:block];
    [VC setContactsModel:contacts];
    [rootVC.navigationController pushViewController:VC animated:true];
    return VC;
}

#pragma mark - Life cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = NSLocalizedString(@"聊天详情", nil);
    
    [self setupSubview];
}

- (void)setupSubview
{
    self.view.backgroundColor = BaseColor;
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self requestDataThen:^{
        [self.tableView reloadData];
    }];
}


#pragma mark - Request

- (void)requestDataThen:(void (^)(void))then
{
    if (self.contactsModel.userId) {
        PROGRESS_HUD_SHOW
        WEAKSELF(weakSelf)
        [NET_REQUEST_MANAGER getFindFriendWithID:self.contactsModel.userId success:^(id response) {
            PROGRESS_HUD_DISMISS
            FYLog(@"%@", response);
            //
            PersonalSignatureModel *model = [PersonalSignatureModel mj_objectWithKeyValues:response];
            [weakSelf setPersonalModel:model];
            [weakSelf.contactsModel setSessionId:model.data.chatId];
            [weakSelf.contactsModel setIsFriend:model.data.isFriend];
            [weakSelf.contactsModel setFriendNick:model.data.friendNick];
            //
            !then ?: then();
        } fail:^(id object) {
            PROGRESS_HUD_DISMISS
            !then ?: then();
            [[FunctionManager sharedInstance] handleFailResponse:object];
        }];
    } else {
        !then ?: then();
        ALTER_INFO_MESSAGE(NSLocalizedString(@"用户ID不能为空", nil))
    }
}


#pragma mark - UITableViewDelegate & UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (1 == section) {
        return 2;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        
        FriendChatInfoHeadCell *cell = [FriendChatInfoHeadCell cellWithTableView:tableView];
        [cell setContacts:self.contactsModel personalModel:self.personalModel];
        return cell;
        
    } else {
        
        RCDBaseSettingTableViewCell *cell = [RCDBaseSettingTableViewCell cellWithTableView:tableView];
        cell.leftLabel.font = [UIFont systemFontOfSize2:15];
        
        if (1 == indexPath.section) {
            if (indexPath.row == 0) {
                [cell setCellStyle:SwitchStyle];
                [cell.switchButton setHidden:NO];
                [cell.leftLabel setText:NSLocalizedString(@"消息免打扰", nil)];
                [cell.switchButton setOn:[self getNotiSwitch]];
                [cell.switchButton addTarget:self
                                      action:@selector(doActionOnSwitchNotDisturb:)
                            forControlEvents:UIControlEventValueChanged];
            } else if (indexPath.row == 1) {
                [cell setCellStyle:SwitchStyle];
                [cell.switchButton setHidden:NO];
                [cell.leftLabel setText:NSLocalizedString(@"置顶聊天", nil)];
                [cell.switchButton setOn:[FYMSG_PRECISION_MANAGER doTryGetChatSessionStickForSwitch:self.contactsModel.sessionId]];
                [cell.switchButton addTarget:self
                                      action:@selector(doActionOnMsgStickSwitchTop:)
                            forControlEvents:UIControlEventValueChanged];
            }
        } else if (indexPath.section == 2) {
            [cell setCellStyle:DefaultStyle];
            [cell.leftLabel setText:NSLocalizedString(@"清空聊天记录", nil)];
        }
        
        return cell;
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return [FriendChatInfoHeadCell cellHeightOfTableView];
    } else {
        return [RCDBaseSettingTableViewCell cellHeightOfTableView];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, CFC_AUTOSIZING_MARGIN(MARGIN))];
    [headerView setBackgroundColor:COLOR_TABLEVIEW_HEADER_VIEW_BACKGROUND_DEFAULT];
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (0 == section) {
        return CGFLOAT_MIN;
    }
    return CFC_AUTOSIZING_MARGIN(MARGIN);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 2) {
        [self doActionClearChatRecords];
    }
}


#pragma mark - Action

// 消息免打扰
- (void)doActionOnSwitchNotDisturb:(id)sender
{
    UISwitch *curSwitch = sender;
    NSString *key = MESSAGE_NOTICE_SWITCH_KEY(APPINFORMATION.userInfo.userId, self.contactsModel.sessionId);
    // 保存
    [[NSUserDefaults standardUserDefaults] setBool:curSwitch.on forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

// 置顶聊天
- (void)doActionOnMsgStickSwitchTop:(id)sender
{
    UISwitch *curSwitch = sender;
    if (curSwitch.on) {
        [FYMSG_PRECISION_MANAGER doTryChatSessionForStickYes:self.contactsModel.sessionId then:^(BOOL success) {
            
        }];
    } else {
        [FYMSG_PRECISION_MANAGER doTryChatSessionForStickNO:self.contactsModel.sessionId then:^(BOOL success) {
            
        }];
    }
}

// 清空聊天记录
- (void)doActionClearChatRecords
{
    // 说明：清空聊天记录，一般只会清空聊天内容，不会删除会话，参考微信等。
    // 此处根据需求设置条件，进行相关操作：0-清空聊天记录  1-删除聊天会话
#if 0
    // 清空聊天记录
    [FYMSG_PRECISION_MANAGER doTryChatSessionForRecordsClear:self.contactsModel.sessionId then:^(BOOL success) {
        if (success) {
            ALTER_INFO_MESSAGE(NSLocalizedString(@"已清空聊天记录", nil))
        } else {
            ALTER_INFO_MESSAGE(NSLocalizedString(@"清空聊天记录失败", nil))
        }
    }];
#else
    // 删除聊天会话
    [FYMSG_PRECISION_MANAGER doTryChatSessionForRecordsDelete:self.contactsModel.sessionId then:^(BOOL success) {
        if (success) {
            ALTER_INFO_MESSAGE(NSLocalizedString(@"已清空聊天记录", nil))
        } else {
            ALTER_INFO_MESSAGE(NSLocalizedString(@"清空聊天记录失败", nil))
        }
    }];
#endif
}


#pragma mark - Getter & Setter

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [UITableView groupTable];
        [_tableView setDelegate:self];
        [_tableView setDataSource:self];
        [_tableView setEstimatedRowHeight:80.0f];
        [_tableView setTableHeaderView:[UIView new]];
        [_tableView setTableFooterView:[UIView new]];
        [_tableView setSectionHeaderHeight:FLOAT_MIN];
        [_tableView setSectionFooterHeight:FLOAT_MIN];
        [_tableView setShowsVerticalScrollIndicator:NO];
        [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [_tableView setTableHeaderView:[[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, FLOAT_MIN)]];
        [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, FLOAT_MIN)]];
        //
        UIView *backgroundView = [[UIView alloc] init];
        [backgroundView setBackgroundColor:COLOR_TABLEVIEW_BACK_VIEW_BACKGROUND_DEFAULT];
        [_tableView setBackgroundView:backgroundView];
        [_tableView setBackgroundColor:COLOR_TABLEVIEW_BACK_VIEW_BACKGROUND_DEFAULT];
        //
        [_tableView registerClass:[FriendChatInfoHeadCell class] forCellReuseIdentifier:kFriendChatInfoHeaderCellId];
        [_tableView registerClass:[RCDBaseSettingTableViewCell class] forCellReuseIdentifier:kRCDBaseSettingTableViewCellIdentifier];
    }
    return _tableView;
}

/// 获取当前免打扰状态
- (BOOL)getNotiSwitch
{
    NSString *key = MESSAGE_NOTICE_SWITCH_KEY(APPINFORMATION.userInfo.userId, self.contactsModel.sessionId);
    BOOL isOn = [[NSUserDefaults standardUserDefaults] boolForKey:key];
    return isOn;
}


@end

