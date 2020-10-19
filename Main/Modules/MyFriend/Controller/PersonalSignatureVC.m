//
//  PersonalSignatureVC.m
//  Project
//
//  Created by Mike on 2019/6/25.
//  Copyright © 2019 CDJay. All rights reserved.
//  好友详情

#import "PersonalSignatureVC.h"
#import "UserTableViewCell.h"
#import "GroupNet.h"
#import "RCDBaseSettingTableViewCell.h"
#import "PersonalSignatureHeadCell.h"
#import "WHC_ModelSqlite.h"
#import "PersonalSignatureSettingVC.h"
#import "ChatViewController.h"
#import "GroupInfoUserModel.h"
#import "PersonalSignatureModel.h"
#import "GroupNet.h"

@interface PersonalSignatureVC ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) id requestParams;

@property (nonatomic, strong) UIButton *sendBtn;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) FYContacts *contactModel;

@property (nonatomic, strong) PersonalSignatureModel *personalModel;

@property (nonatomic, copy) DataBlock successBlock;

@property (nonatomic, assign) BOOL isShowSectionTwo;

@end

@implementation PersonalSignatureVC

+ (instancetype)pushFromVC:(UIViewController *)rootVC requestParams:(id)requestParams success:(DataBlock)block
{
    PersonalSignatureVC *vc = [[PersonalSignatureVC alloc] init];
    vc.requestParams = requestParams;
    vc.successBlock = block;
    
    [rootVC.navigationController pushViewController:vc animated:true];
    return vc;
}


#pragma mark - Life cycle

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.navigationItem.title = NSLocalizedString(@"个人信息", nil);
    self.view.backgroundColor = BaseColor;
    
    [self setupSubview];
    
    [self requestData];
}

- (UIView *)createFooterView {
    
    UIView *footerView = [[UIView alloc] init];
    footerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 135);
    footerView.backgroundColor = [UIColor clearColor];
    
    UIButton *sendBtn = [[UIButton alloc] init];
    sendBtn.frame = CGRectMake(0, 0, SCREEN_WIDTH, 135);
    sendBtn.backgroundColor = COLOR_SYSTEM_MAIN_BUTTON_BACKGROUND_SELECT_DEFAULT;
    [sendBtn setTitle:NSLocalizedString(@"发消息", nil) forState:UIControlStateNormal];
    [sendBtn setTitleColor:HEXCOLOR(0xffffff) forState:UIControlStateNormal];
    [sendBtn addTarget:self action:@selector(doActionSendMessage:) forControlEvents:UIControlEventTouchUpInside];
    sendBtn.hidden = YES; //默认隐藏
    [footerView addSubview:sendBtn];
    _sendBtn = sendBtn;
    
    sendBtn.layer.cornerRadius = 8;
    sendBtn.layer.masksToBounds = true;
    [sendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(footerView).offset(40);
        make.centerX.equalTo(footerView);
        make.bottom.equalTo(footerView);
        make.height.equalTo(@42);
    }];
    
    return footerView;
}

- (void)setupSubview {
    
    self.tableView.tableFooterView = [self createFooterView];
    [self.tableView layoutIfNeeded];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    if ([self.requestParams isKindOfClass:[FYContacts class]]) {
        FYContacts *contact = self.requestParams;
        self.contactModel = contact;
        
    } else if ([self.requestParams isKindOfClass:[GroupInfoUserModel class]]) {
        GroupInfoUserModel *message = self.requestParams;
        FYContacts *contact = [[FYContacts alloc]init];
        contact.sessionId = [NSString stringWithFormat:@"%@",message.sessionId];
        contact.nick = [NSString stringWithFormat:@"%@",message.nick];
        contact.avatar = [NSString stringWithFormat:@"%@",message.avatar];
        contact.lastTimestamp = message.timestamp;
        contact.userId = [NSString stringWithFormat:@"%@",message.userId];
        contact.accountUserId = [NSString stringWithFormat:@"%@",message.toUserId];
        contact.name = [NSString stringWithFormat:@"%@",message.nick] ;
        contact.friendNick = [NSString stringWithFormat:@"%@",message.friendNick] ;
        if ([AppModel shareInstance].userInfo.innerNumFlag) {
            self.isShowSectionTwo = YES;
        }
        self.contactModel = contact;
        
    } else if ([self.requestParams isKindOfClass:[FYMessage class]]) {
        FYMessage *message = self.requestParams;
        FYContacts *contact = [[FYContacts alloc] init];
        contact.sessionId = [NSString stringWithFormat:@"%@",message.sessionId];
        contact.nick = [NSString stringWithFormat:@"%@",message.user.nick];
        contact.avatar = [NSString stringWithFormat:@"%@",message.user.avatar];
        contact.lastTimestamp = message.timestamp;
        contact.userId = [NSString stringWithFormat:@"%@",message.user.userId];
        contact.accountUserId = [NSString stringWithFormat:@"%@",message.toUserId];
        contact.name = [NSString stringWithFormat:@"%@",message.user.nick];
        contact.friendNick = [NSString stringWithFormat:@"%@",message.user.friendNick];
        if ([AppModel shareInstance].userInfo.innerNumFlag || message.user.groupowenFlag) {
            self.isShowSectionTwo = YES;
        }
        self.contactModel = contact;
    }
    
    [self.tableView reloadData];
}


#pragma mark - Request

- (void)requestData
{
    if (self.contactModel.userId) {
        PROGRESS_HUD_SHOW
        WEAK_OBJ(weakSelf, self);
        [NET_REQUEST_MANAGER getFindFriendWithID:self.contactModel.userId success:^(id response) {
            PROGRESS_HUD_DISMISS
            FYLog(@"%@", response);
            
            PersonalSignatureModel *model = [PersonalSignatureModel mj_objectWithKeyValues:response];
            [weakSelf setPersonalModel:model];
            [weakSelf.contactModel setSessionId:model.data.chatId];
            [weakSelf.contactModel setIsFriend:model.data.isFriend];
            [weakSelf.contactModel setFriendNick:[NSString stringWithFormat:@"%@", model.data.friendNick]];
            
            // 如果是好友
            if (weakSelf.contactModel.isFriend) {
                if (weakSelf.contactModel.sessionId.length > 0) {
                    weakSelf.sendBtn.hidden = NO;
                }
            }
            
            [weakSelf.tableView reloadData];
            
        } fail:^(id object) {
            PROGRESS_HUD_DISMISS
            [[FunctionManager sharedInstance] handleFailResponse:object];
        }];
    } else {
        ALTER_INFO_MESSAGE(NSLocalizedString(@"用户ID不能为空", nil))
    }
}


#pragma mark - UITableViewDelegate & UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 头部
    if (indexPath.section == 0) {
        
        PersonalSignatureHeadCell *cell = [PersonalSignatureHeadCell cellWithTableView:tableView];
        [cell setIsShowID:self.isShowSectionTwo];
        [cell setContacts:self.contactModel personalModel:self.personalModel];
        return cell;
        
    } else if (indexPath.section == 1) {
    
        // 关系
        if (indexPath.row == 0) {
            RCDBaseSettingTableViewCell *cell = [RCDBaseSettingTableViewCell cellWithTableView:tableView];
            [cell.leftLabel setFont:[UIFont systemFontOfSize2:15]];
            [cell setCellStyle:DefaultStyle_RightLabel_WithoutRightArrow];
            [cell.leftLabel setText:NSLocalizedString(@"我的关系", nil)];
            [cell.rightLabel setText:[self getFriendRelation:self.personalModel.data.relation]];
            return cell;
        }
        // 好友、群主、内部号
        else if (indexPath.row == 1) {
            RCDBaseSettingTableViewCell *cell = [RCDBaseSettingTableViewCell cellWithTableView:tableView];
            [cell.leftLabel setFont:[UIFont systemFontOfSize2:15]];
            [cell setCellStyle:DefaultStyle];
            if (self.isShowSectionTwo || self.contactModel.isFriend ) {
                [cell.leftLabel setText:NSLocalizedString(@"设置备注名", nil)];
                return cell;
            }
        }
    
    }
    
    return [UITableViewCell new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return [PersonalSignatureHeadCell cellHeightOfTableView];
    } else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            return [RCDBaseSettingTableViewCell cellHeightOfTableView];
        }
        if (self.isShowSectionTwo || self.contactModel.isFriend) {
            return [RCDBaseSettingTableViewCell cellHeightOfTableView];
        }
    }
    return CGFLOAT_MIN;
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
    if (indexPath.section == 1 && indexPath.row == 1) {
        [PersonalSignatureSettingVC pushFromVC:self requestParams:self.contactModel success:^(id data) {
            self.contactModel = data;
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
            PersonalSignatureHeadCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            [cell setContacts:self.contactModel personalModel:self.personalModel];
            //
            [[IMContactsModule sharedInstance] handleUpdateAllContactEntitys:^(BOOL success) {
                [NOTIF_CENTER postNotificationName:kNotificationModifyFriendInfo object:nil];
            }];
            //
            if (self.successBlock) {
                self.successBlock(self.requestParams);
            }
        }];
    }
}


#pragma mark - Action

/// 聊天 - 发送消息
- (void)doActionSendMessage:(UIButton *)sender
{
    if (self.contactModel.sessionId.length > 0) {
        ChatViewController *chatVC = [[ChatViewController alloc] initWithConversationType:FYConversationType_PRIVATE targetId:self.contactModel.sessionId];
        chatVC.toContactsModel = self.contactModel;
        if ([NSString isBlankString:self.contactModel.friendNick]) {
            chatVC.title = self.contactModel.nick.length ? self.contactModel.nick : self.contactModel.name;
        } else {
            chatVC.title = self.contactModel.friendNick;
        }
        [self.navigationController pushViewController:chatVC animated:YES];
    } else {
        ALTER_INFO_MESSAGE(NSLocalizedString(@"会话sessionid不能为空！", nil))
    }
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
        [_tableView registerClass:[PersonalSignatureHeadCell class] forCellReuseIdentifier:kPersonalSignatureHeadCellId];
        [_tableView registerClass:[RCDBaseSettingTableViewCell class] forCellReuseIdentifier:kRCDBaseSettingTableViewCellIdentifier];
    }
    
    return _tableView;
}


#pragma mark - Private

- (NSString *)getFriendRelation:(NSInteger)relation
{
    switch (relation) {
        case 0:
            return NSLocalizedString(@"未知关系", nil);
        case 1:
            return NSLocalizedString(@"我的上级", nil);
        case 2:
            return NSLocalizedString(@"我的下级", nil);
        case 3:
            return NSLocalizedString(@"普通朋友", nil);
        default:
            return NSLocalizedString(@"未知关系", nil);
    }
}


@end

