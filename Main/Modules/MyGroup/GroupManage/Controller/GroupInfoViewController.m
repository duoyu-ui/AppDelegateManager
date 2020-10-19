//
//  GroupInfoViewController.m
//  Project
//
//  Created by mini on 2018/8/9.
//  Copyright © 2018年 CDJay. All rights reserved.
//

#import "GroupInfoViewController.h"
#import "ModifyGroupController.h"
#import "AddGroupContactController.h"
#import "MessageItem.h"
#import "GroupNet.h"
#import "GroupHeadView.h"
#import "AllUserViewController.h"
#import "AddMemberController.h"
#import "NSString+Size.h"
#import "SqliteManage.h"
#import "ImageDetailViewController.h"
#import "GroupSettingRedPaperVC.h"

#import "CreateGroupInfoCell.h"
#import "FYCreateGroupModel.h"
#import "GroupInfoUserModel.h"
#import "FYCreateRequest.h"

static NSString *const kGroupInfoCellIdentifier = @"kGroupInfoCellIdentifier";

@interface GroupInfoViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) GroupHeadView *headView;
@property (nonatomic, strong) GroupNet *netModel;
@property (nonatomic, strong) MessageItem *groupInfo;
/// 红包设置
@property (nonatomic, strong) FYCreateRequest *packetModel;

@property (nonatomic, strong) NSArray *dataSource;

@end


@implementation GroupInfoViewController

+ (GroupInfoViewController *)groupVc:(MessageItem *)obj {
    GroupInfoViewController *vc = [[GroupInfoViewController alloc] init];
    vc.groupInfo = obj;
    return vc;
}

#pragma mark - Getter private

- (GroupNet *)netModel {
    
    if (!_netModel) {
        _netModel = [GroupNet new];
        _netModel.groupNum = self.groupInfo.groupNum;
    }
    return _netModel;
}

- (FYCreateRequest *)packetModel {
    
    if (!_packetModel) {
        
        _packetModel = [[FYCreateRequest alloc] init];
    }
    return _packetModel;
}

- (NSArray *)dataSource {
    
    if (!_dataSource) {
        
        NSString *notice = self.groupInfo.notice ? self.groupInfo.notice : @"-";
        NSString *chatgId = self.groupInfo.groupId ? self.groupInfo.groupId : @"-";
        NSString *chatgName = self.groupInfo.chatgName ? self.groupInfo.chatgName : @"-";
        NSString *noticeIsOn = [self getNotiSwitch] ? NSLocalizedString(@"已开启", nil) : NSLocalizedString(@"已关闭", nil);
        NSString *packetSeted = [self packetSetedInfo:self.packetModel];
        
        NSArray *lastTableSectionArr = nil;
        if (self.groupInfo.officeFlag) {
            lastTableSectionArr =
            @[[FYCreateGroupModel createModelWithTitle:NSLocalizedString(@"消息免打扰", nil) subtitle:noticeIsOn style:CreateAllTitleAndSwitch]];
        } else {
            lastTableSectionArr =
            @[[FYCreateGroupModel createModelWithTitle:NSLocalizedString(@"消息免打扰", nil) subtitle:noticeIsOn style:CreateAllTitleAndSwitch],
              [FYCreateGroupModel createModelWithTitle:NSLocalizedString(@"清空聊天记录", nil) subtitle:@"" style:CreateAllTitleAndArrow]];
        }
        
        if ([self isGroupOwner]) { //群主
            NSArray *sectionArr = nil;
            if (self.groupInfo.type == GroupTemplate_N00_FuLi ||
                self.groupInfo.type == GroupTemplate_N07_JieLong ||
                self.groupInfo.type == GroupTemplate_N03_JingQiang) {
                sectionArr =
                @[[FYCreateGroupModel createModelWithTitle:NSLocalizedString(@"是否禁言", nil) subtitle:NSLocalizedString(@"不禁言", nil) style:CreateAllTitleAndSwitch],
                [FYCreateGroupModel createModelWithTitle:NSLocalizedString(@"是否禁图", nil) subtitle:NSLocalizedString(@"不禁图", nil) style:CreateAllTitleAndSwitch]];
            } else {
                sectionArr =
                @[[FYCreateGroupModel createModelWithTitle:NSLocalizedString(@"红包设置", nil) subtitle:packetSeted style:CreateAllTitleAndArrow],
                [FYCreateGroupModel createModelWithTitle:NSLocalizedString(@"是否禁言", nil) subtitle:NSLocalizedString(@"不禁言", nil) style:CreateAllTitleAndSwitch],
                  [FYCreateGroupModel createModelWithTitle:NSLocalizedString(@"是否禁图", nil) subtitle:NSLocalizedString(@"不禁图", nil) style:CreateAllTitleAndSwitch]];
            }
            _dataSource = @[
           @[[FYCreateGroupModel createModelWithTitle:NSLocalizedString(@"群ID", nil) subtitle:chatgId style:CreateTitleAndSubtitle],
             [FYCreateGroupModel createModelWithTitle:NSLocalizedString(@"群名称", nil) subtitle:chatgName style:CreateAllTitleAndArrow],
             [FYCreateGroupModel createModelWithTitle:NSLocalizedString(@"群公告", nil) subtitle:notice style:CreateNoticeInfoOrArrow]],
           sectionArr, lastTableSectionArr];
        } else {
            _dataSource = @[
            @[[FYCreateGroupModel createModelWithTitle:NSLocalizedString(@"群ID", nil) subtitle:chatgId style:CreateTitleAndSubtitle],
              [FYCreateGroupModel createModelWithTitle:NSLocalizedString(@"群名称", nil) subtitle:chatgName style:CreateTitleAndSubtitle],
              [FYCreateGroupModel createModelWithTitle:NSLocalizedString(@"群公告", nil) subtitle:notice style:CreateNoticeInfoOrArrow]],
            lastTableSectionArr];
        }
    }
    return _dataSource;
}

- (UITableView *)tableView {
    
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.estimatedRowHeight = 52;
        _tableView.separatorInset = UIEdgeInsetsMake(0, -15, 0, 0);
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.backgroundColor = [UIColor clearColor];
        [_tableView registerClass:[CreateGroupInfoCell class] forCellReuseIdentifier:kGroupInfoCellIdentifier];
    }
    return _tableView;
}


/// 获取当前免打扰状态
- (BOOL)getNotiSwitch {
    NSString *key = MESSAGE_NOTICE_SWITCH_KEY(APPINFORMATION.userInfo.userId, self.groupInfo.groupId);
    BOOL isOn = [[NSUserDefaults standardUserDefaults] boolForKey:key];
    return isOn;
}

/// 当前红包设置
- (NSString *)packetSetedInfo:(FYCreateRequest *)packet {
    if (self.groupInfo.type == GroupTemplate_N01_Bomb) {
        if (packet.maxCount && packet.minMoney && packet.maxMoney) {
            return [NSString stringWithFormat:@"%@%@, %@-%@%@",packet.maxCount,NSLocalizedString(@"包",nil),packet.minMoney,packet.maxMoney,NSLocalizedString(@"元",nil)];
        }
        return @"-";
    }else if (self.groupInfo.type == GroupTemplate_N02_NiuNiu) {
        if (packet.minCount && packet.maxCount && packet.minMoney && packet.maxMoney) {
            return [NSString stringWithFormat:@"%@-%@%@, %@-%@%@",packet.minCount, packet.maxCount,NSLocalizedString(@"包",nil),packet.minMoney, packet.maxMoney,NSLocalizedString(@"元",nil)];
        }
        return @"-";
    }else if (self.groupInfo.type == GroupTemplate_N08_ErRenNiuNiu) {
        if (packet.minCount && packet.maxCount && packet.minMoney && packet.maxMoney) {
            return [NSString stringWithFormat:@"%@-%@%@",packet.minMoney, packet.maxMoney,NSLocalizedString(@"元",nil)];
        }
        return @"-";
    }else {
        return [NSString stringWithFormat:@"%ld%@，%ld%%",packet.amount,NSLocalizedString(@"元",nil),packet.payRatio];
    }
}

/// 判断是否是群主,是否自建群
- (BOOL)isGroupOwner {
    
    return [AppModel shareInstance].isGroupOwner;
}

#pragma mark - Life cycle

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self loadGroupUsersData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = BaseColor;
    self.navigationItem.title = NSLocalizedString(@"群信息", nil);
    
    [self initTableView];
    [self reloadSelfGroupInfo];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addGroupContact) name:@"addGroupContact" object:nil];
}

// 新增用户后(重新获取)
- (void)addGroupContact {
    
    [self loadGroupUsersData];
}

- (void)updateGroupUser {
    __weak __typeof(self)weakSelf = self;
    if ([self.groupInfo.userId isEqualToString:[AppModel shareInstance].userInfo.userId]) { //群主
        _headView = [GroupHeadView headViewWithModel:self.netModel item:(MessageItem *)self.groupInfo isGroupLord:YES];
    } else {//非群主
        _headView = [GroupHeadView headViewWithModel:self.netModel item:(MessageItem *)self.groupInfo isGroupLord:NO];
    }
    
    _headView.didHeaderBlock = ^(id model) {
         __strong __typeof(weakSelf)strongSelf = weakSelf;
        if ([model isKindOfClass:[GroupInfoUserModel class]]) {
            GroupInfoUserModel *infoModel = model;
            if ([infoModel.userId isEqualToString:[AppModel shareInstance].userInfo.userId]) {
                return;
            }
            
            FYContacts *contact = [[IMSessionModule sharedInstance] getSessionWithUserId:infoModel.userId];
            if (contact.sessionId != nil) {
                infoModel.sessionId = contact.sessionId;
            }
            
            [PersonalSignatureVC pushFromVC:strongSelf requestParams:infoModel success:^(id data) {
                
            }];
            
        } else {
            NSInteger index = [model integerValue];
            if (index >= 100000) {
                if (strongSelf.groupInfo.officeFlag) {
                    if (index == 100000) {
                        // 添加群员
                        [strongSelf addGroupMember];
                    } else {
                        // 删减群员
                        [strongSelf deleteGroupMember];
                    }
                } else { //自建群
                    if (index == 100000) {
                        [strongSelf addGroupMemberOfficeFlag];
                    } else {
                        [strongSelf deleteGroupMemberOfficeFlag];
                    }
                }
            } else if (index == 0) {
                
                 [strongSelf gotoAllGroupUsers];
            }
        }
    };
    
    self.tableView.tableHeaderView = _headView;
}

#pragma mark - Action

/**
 自建群添加群成员
 */
- (void)addGroupMemberOfficeFlag {
    AddGroupContactController *add = [[AddGroupContactController alloc]init];
    add.groupId = self.groupInfo.groupId;
    add.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:add animated:YES];
}

/**
 自建群,群主删减群员
 */
- (void)deleteGroupMemberOfficeFlag {
    AddGroupContactController *vc = [[AddGroupContactController alloc]init];
    vc.groupId = self.groupInfo.groupId;
    vc.type = ControllerType_delete;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)addGroupMember {
    AddMemberController *vc = [[AddMemberController alloc] init];
    vc.title = NSLocalizedString(@"添加群成员", nil);
    vc.groupId = self.groupInfo.groupId;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}
    
- (void)deleteGroupMember {
    AllUserViewController *vc = [AllUserViewController allUser:self.netModel];
    vc.title = NSLocalizedString(@"删除成员", nil);
    vc.groupId = self.groupInfo.groupId;
    vc.isDelete = YES;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

/**
 退出群组确认
 */
-(void)exitChatGroup {
    WeakSelf
    NSString *message = [self.groupInfo.userId isEqualToString:AppModel.shareInstance.userInfo.userId] ? NSLocalizedString(@"是否解散该群？", nil) : NSLocalizedString(@"是否退出该群？", nil);
    NSString *title2 = [self.groupInfo.userId isEqualToString:AppModel.shareInstance.userInfo.userId] ? NSLocalizedString(@"解散", nil) : NSLocalizedString(@"退出", nil);
    [[AlertViewCus createInstanceWithView:nil] showWithText:message button1:NSLocalizedString(@"取消", nil) button2:title2 callBack:^(id object) {
        NSInteger tag = [object integerValue];
        if (tag == 1) {
            [weakSelf confirmExitGroup];
        }
    }];
}

/**
 * 确认退出群组请求
 */
- (void)confirmExitGroup
{
    //是否是自建群
    BOOL isOfficeFlag = self.groupInfo.officeFlag;
    //是否是群主
    BOOL isGroupManager = [self.groupInfo.userId isEqualToString:[AppModel shareInstance].userInfo.userId];
    
    [SVProgressHUD show];
    [[GroupNet alloc] dissolveGroupWithID:self.groupInfo.groupId isOfficeFlag:isOfficeFlag isGroupManager:isGroupManager successBlock:^(NSDictionary *response) {
        [SVProgressHUD dismiss];
        if ([response objectForKey:@"code"] && [[response objectForKey:@"code"] integerValue] == 0) {
            [SqliteManage removeGroupSql:self.groupInfo.groupId];
            [[IMGroupModule sharedInstance] removeGroupEntityWithGroupId:self.groupInfo.groupId];
            [[IMContactsModule sharedInstance] deleteGroupVerification:(FYGroupVerifiEntity *)self.groupInfo];
            // clear
            FYContacts *session = [[IMSessionModule sharedInstance] getSessionWithUserId:self.groupInfo.userId];
            if (session != nil) {
                [IMSessionModule.sharedInstance removeSession:session.sessionId];
                [IMGroupModule.sharedInstance removeGroupEntityWithGroupId:session.sessionId];
            }
            [self sendExitNoti];
            NSString *alterMsg = [NSString stringWithFormat:@"%@", [response objectForKey:@"alterMsg"]];
            [SVProgressHUD showSuccessWithStatus:alterMsg];
            [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:0] animated:YES];
        } else {
            
            [[FunctionManager sharedInstance] handleFailResponse:response];
        }
    } failureBlock:^(NSError *error) {
        
        [SVProgressHUD dismiss];
        [[FunctionManager sharedInstance] handleFailResponse:error];
    }];
}

// 退出群（发送通知）
- (void)sendExitNoti {
    [[NSNotificationCenter defaultCenter] postNotificationName:kReloadMyMessageGroupList object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:kUserExitGroupNotification object:nil];
    // 更新自己的群组信息
    [[IMGroupModule sharedInstance] handleUpdateAllGroupEntitys:^(BOOL success) {
        [NOTIF_CENTER postNotificationName:kNotificationCreateOrDeleteSelfGroup object:nil];
    }];
}

#pragma mark - Add Subview

- (void)initTableView {
    
    self.tableView.tableFooterView = [self createFooterView];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.top.left.right.equalTo(self.view);
            make.bottom.equalTo(self.view);
        } else {
            make.edges.equalTo(self.view);
        }
    }];
}

- (UIView *)createFooterView {
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 100)];
    UIButton *exitButton = [UIButton buttonWithType:UIButtonTypeSystem];
    exitButton.frame = CGRectMake(42, 21, SCREEN_WIDTH - 84, 42);
    exitButton.layer.cornerRadius = 8;
    exitButton.layer.masksToBounds = YES;
    exitButton.backgroundColor = COLOR_SYSTEM_MAIN_BUTTON_BACKGROUND_SELECT_DEFAULT;
    exitButton.titleLabel.font = [UIFont boldSystemFontOfSize2:17];
    // Configuration
    if ([self isGroupOwner]) {
        [exitButton setTitle:NSLocalizedString(@"解散群", nil) forState:UIControlStateNormal];
    } else {
        [exitButton setTitle:NSLocalizedString(@"退出群", nil) forState:UIControlStateNormal];
    }
    [exitButton addTarget:self action:@selector(exitChatGroup) forControlEvents:UIControlEventTouchUpInside];
    [exitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [footerView addSubview:exitButton];
    
    return footerView;
}

#pragma mark - Request
/// 获取群成员
- (void)loadGroupUsersData {
    
    PROGRESS_HUD_SHOW
    __weak __typeof(self)weakSelf = self;
    [self.netModel queryGroupUserGroupId:self.groupInfo.groupId successBlock:^(NSDictionary *info) {
        PROGRESS_HUD_DISMISS
         __strong __typeof(weakSelf)strongSelf = weakSelf;
        if ([info objectForKey:@"code"] && [[info objectForKey:@"code"] integerValue] == 0) {
            [strongSelf updateGroupUser];
        } else {
            [[FunctionManager sharedInstance] handleFailResponse:info];
        }
    } failureBlock:^(NSError *error) {
        PROGRESS_HUD_DISMISS
        [[FunctionManager sharedInstance] handleFailResponse:error];
    }];
}

/// 群禁言
- (void)requestStopSpeak:(void(^)(BOOL isOn))block {
    
    if (self.groupInfo.groupId.length > 0) {
        [[NetRequestManager sharedInstance] requestGroupStopSpeakWithGroupId:self.groupInfo.groupId
                                                                     Success:^(id object) {
            if ([object isKindOfClass:[NSDictionary class]]) {
                if ([object objectForKey:@"code"] && [[object objectForKey:@"code"] integerValue] == 0) {
                    NSString *message = [NSString stringWithFormat:NSLocalizedString(@"操作%@", nil), object[@"msg"]];
                    BOOL isOn = [object[@"data"] boolValue];
                    [SVProgressHUD showSuccessWithStatus:message];
                    !block?:block(isOn);
                } else {
                    
                    !block?:block(self.groupInfo.shutPicFlag ? YES : NO);
                }
            }
        } fail:^(id object) {
            !block?:block(self.groupInfo.shutPicFlag ? YES : NO);
            [[FunctionManager sharedInstance] handleFailResponse:object];
        }];
    }
}

/// 群禁图
- (void)requestStopPic:(void(^)(BOOL isOn))block {
    
    if (self.groupInfo.groupId.length > 0) {
        [[NetRequestManager sharedInstance] requestGroupStopPicWithGroupId:self.groupInfo.groupId
                                                                   Success:^(id object) {
            if ([object isKindOfClass:[NSDictionary class]]) {
                if ([object objectForKey:@"code"] && [[object objectForKey:@"code"] integerValue] == 0) {
                    NSString *message = [NSString stringWithFormat:NSLocalizedString(@"操作%@", nil), object[@"msg"]];
                    BOOL isOn = [object[@"data"] boolValue];
                    [SVProgressHUD showSuccessWithStatus:message];
                    !block?:block(isOn);
                } else {
                    
                    !block?:block(self.groupInfo.shutPicFlag ? YES : NO);
                }
            }
        } fail:^(id object) {
            !block?:block(self.groupInfo.shutPicFlag ? YES : NO);
            [[FunctionManager sharedInstance] handleFailResponse:object];
        }];
    }
}

/// 重新获取群列表信息
- (void)reloadSelfGroupInfo {
    
    if ([self isGroupOwner] && self.groupInfo.groupId) {
        [[NetRequestManager sharedInstance] getGroupInfoWithGroupId:self.groupInfo.groupId success:^(id object) {
            if (object && [object isKindOfClass:[NSDictionary class]]) {
                if ([object[@"code"] integerValue] == 0) {
                    NSDictionary *JSONData = [object[@"data"] mj_JSONObject];
                    MessageItem *model = [MessageItem mj_objectWithKeyValues:JSONData];
                    self.packetModel.amount = model.robNiuniu.rabBankerMoney;
                    self.packetModel.payRatio = model.robNiuniu.continueBankerPercent;
                    self.packetModel.minMoney = model.minMoney;
                    self.packetModel.maxMoney = model.maxMoney;
                    self.packetModel.minCount = model.minCount;
                    self.packetModel.maxCount = model.maxCount;
                    //禁言&禁图
                    self.groupInfo.shutupFlag = model.shutupFlag;
                    self.groupInfo.shutPicFlag = model.shutPicFlag;
                }
            }
            
            [self.tableView reloadData];
            
        } fail:^(id object) {
            
            [[FunctionManager sharedInstance] handleFailResponse:object];
        }];
    }
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.dataSource[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CreateGroupInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:kGroupInfoCellIdentifier];
    if (self.dataSource.count > indexPath.section) {
        FYCreateGroupModel *dataModel = self.dataSource[indexPath.section][indexPath.row];
        if (dataModel.style == CreateAllTitleAndSwitch ||
            dataModel.style == CreateAllTitleAndArrow) {
            [self handySwitchWithCell:cell model:dataModel indexPath:indexPath];
        }
        cell.model = dataModel;
    }
    return cell;
}

- (void)handySwitchWithCell:(CreateGroupInfoCell *)cell model:(FYCreateGroupModel *)model indexPath:(NSIndexPath *)indexPath {
    WeakSelf
    if ([self isGroupOwner]) { //我是群主
        if (indexPath.section == 1) {
            if (self.groupInfo.type == GroupTemplate_N00_FuLi ||
                self.groupInfo.type == GroupTemplate_N07_JieLong ||
                self.groupInfo.type == GroupTemplate_N03_JingQiang) {
                if (indexPath.row == 0) { //禁言
                    [cell.switchView setOn:self.groupInfo.shutupFlag];
                    model.subtitle = self.groupInfo.shutupFlag ? NSLocalizedString(@"已禁言", nil) : NSLocalizedString(@"不禁言", nil);
                    cell.switchChangedBlock = ^{
                        [weakSelf requestStopSpeak:^(BOOL isOn) {
                            weakSelf.groupInfo.shutupFlag = isOn;
                            [weakSelf.tableView reloadData];
                        }];
                    };
                }else if (indexPath.row == 1) {//禁图
                    [cell.switchView setOn:self.groupInfo.shutPicFlag];
                    model.subtitle = self.groupInfo.shutPicFlag ? NSLocalizedString(@"已禁图", nil) : NSLocalizedString(@"不禁图", nil);
                    cell.switchChangedBlock = ^{
                        [weakSelf requestStopPic:^(BOOL isOn) {
                            weakSelf.groupInfo.shutPicFlag = isOn;
                            [weakSelf.tableView reloadData];
                        }];
                    };
                }
            }else {
               if (indexPath.row == 0) {
                   model.subtitle = [self packetSetedInfo:self.packetModel];
               }else if (indexPath.row == 1) { //禁言
                    [cell.switchView setOn:self.groupInfo.shutupFlag];
                    model.subtitle = self.groupInfo.shutupFlag ? NSLocalizedString(@"已禁言", nil) : NSLocalizedString(@"不禁言", nil);
                    cell.switchChangedBlock = ^{
                        [weakSelf requestStopSpeak:^(BOOL isOn) {
                            weakSelf.groupInfo.shutupFlag = isOn;
                            [weakSelf.tableView reloadData];
                        }];
                    };
                }else if (indexPath.row == 2) {//禁图
                    [cell.switchView setOn:self.groupInfo.shutPicFlag];
                    model.subtitle = self.groupInfo.shutPicFlag ? NSLocalizedString(@"已禁图", nil) : NSLocalizedString(@"不禁图", nil);
                    cell.switchChangedBlock = ^{
                        [weakSelf requestStopPic:^(BOOL isOn) {
                            weakSelf.groupInfo.shutPicFlag = isOn;
                            [weakSelf.tableView reloadData];
                        }];
                    };
               }
            }
        }else if (indexPath.section == 2) {
            if (indexPath.row == 0) {
                [cell.switchView setOn:[self getNotiSwitch]];
                cell.switchChangedIsOnBlock = ^(BOOL isOn) {
                    model.subtitle = isOn ? NSLocalizedString(@"已开启", nil) : NSLocalizedString(@"已关闭", nil);
                    [weakSelf switchNotiClick:isOn];
                    [self.tableView reloadData];
                };
            }
        }
    }else {
        if (indexPath.section == 1) {
            if (indexPath.row == 0) {
                [cell.switchView setOn:[self getNotiSwitch]];
                cell.switchChangedIsOnBlock = ^(BOOL isOn) {
                    model.subtitle = isOn ? NSLocalizedString(@"已开启", nil) : NSLocalizedString(@"已关闭", nil);
                    [weakSelf switchNotiClick:isOn];
                    [self.tableView reloadData];
                };
            }
        }
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [UIView new];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [UIView new];
}

#pragma mark - UITableViewDataDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.dataSource.count > indexPath.section) {
        FYCreateGroupModel *dataModel = self.dataSource[indexPath.section][indexPath.row];
        if (dataModel.style == CreateNoticeInfoOrArrow) {
            return 74;
        }
    }
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.dataSource.count > indexPath.section) {
        WeakSelf
        FYCreateGroupModel *dataModel = self.dataSource[indexPath.section][indexPath.row];
        if ([self isGroupOwner]) {
            if (indexPath.section == 0) {
                if (indexPath.row == 1) {
                    [self changeGroupInfoWithModel:dataModel type:ModifyGroupTypeName];
                }else if (indexPath.row == 2) {
                    [self changeGroupInfoWithModel:dataModel type:ModifyGroupTypeMent];
                }
            } else if (indexPath.section == 1 && self.groupInfo.type != GroupTemplate_N00_FuLi && self.groupInfo.type != GroupTemplate_N07_JieLong && self.groupInfo.type != GroupTemplate_N03_JingQiang) {
                if (indexPath.row == 0) {
                    [self setupRedPaperComplete:^(FYCreateRequest *setedModel) {
                        dataModel.subtitle = [weakSelf packetSetedInfo:setedModel];
                        [self.tableView reloadData];
                    }];
                }
            } else if (indexPath.section == 2 && indexPath.row == 1) {
                [self clearChatfRecords];
            }
        } else {
            if (indexPath.section == 0 && indexPath.row == 2) {
                [self changeGroupInfoWithModel:dataModel type:ModifyGroupTypeMent];
            } else if (indexPath.section == 1 && indexPath.row == 1) {
                [self clearChatfRecords];
            }
        }
    }
}


#pragma mark - Action
/// 修改群信息
/// @param type 修改类型
- (void)changeGroupInfoWithModel:(FYCreateGroupModel *)model type:(ModifyGroupType)type {
    WeakSelf
    ModifyGroupController *modifyVC = [[ModifyGroupController alloc] init];
    modifyVC.type = type;
    modifyVC.groupID = self.groupInfo.groupId;
    if (type == ModifyGroupTypeName) {
        modifyVC.navigationItem.title = NSLocalizedString(@"修改群名称", nil);
        modifyVC.groupInfo = self.groupInfo;
        modifyVC.content = self.groupInfo.chatgName;
        modifyVC.modifyGroupBlock = ^(NSString * _Nonnull text) {
            NSLog(@"%@", text);
            weakSelf.groupInfo.chatgName = text;
            model.subtitle = text;
            [weakSelf.tableView reloadData];
        };
    }else {
        modifyVC.navigationItem.title = NSLocalizedString(@"修改群公告", nil);
        modifyVC.content = self.groupInfo.notice;
        modifyVC.modifyGroupBlock = ^(NSString * _Nonnull text) {
            NSLog(@"%@", text);
            weakSelf.groupInfo.notice = text;
            model.subtitle = text;
            [weakSelf.tableView reloadData];
        };
    }
    
    [self.navigationController pushViewController:modifyVC animated:YES];
}

/// 更新红包设置
- (void)setupRedPaperComplete:(void(^)(FYCreateRequest *setedModel))block {
    if (self.groupInfo.type) {
        GroupSettingRedPaperVC *redPaperVC = [[GroupSettingRedPaperVC alloc] init];
        redPaperVC.groupType = self.groupInfo.type;
        redPaperVC.isUpdate = YES;
        if (self.packetModel) {
            self.packetModel.groupId = self.groupInfo.groupId;
            redPaperVC.packetModel = self.packetModel;
        }
        [self.navigationController pushViewController:redPaperVC animated:YES];
        // 拿到红包配置
        redPaperVC.didSetedBlock = ^(FYCreateRequest * _Nullable result) {
            self.packetModel = result;
            !block?:block(result);
            
            if (self.changedInfoBlock) {
                self.changedInfoBlock(result);
            }
        };
    }
}

- (void)clearChatfRecords
{
    // 说明：清空聊天记录，一般只会清空聊天内容，不会删除会话，参考微信等。
    // 此处根据需求设置条件，进行相关操作：0-清空聊天记录  1-删除聊天会话
#if 0
    // 清空聊天记录
    [FYMSG_PRECISION_MANAGER doTryChatSessionForRecordsClear:self.groupInfo.groupId then:^(BOOL success) {
        if (success) {
            ALTER_INFO_MESSAGE(NSLocalizedString(@"已清空聊天记录", nil))
        } else {
            ALTER_INFO_MESSAGE(NSLocalizedString(@"清空聊天记录失败", nil))
        }
    }];
#else
    // 删除聊天会话
    [FYMSG_PRECISION_MANAGER doTryChatSessionForRecordsDelete:self.groupInfo.groupId then:^(BOOL success) {
        if (success) {
            ALTER_INFO_MESSAGE(NSLocalizedString(@"已清空聊天记录", nil))
        } else {
            ALTER_INFO_MESSAGE(NSLocalizedString(@"清空聊天记录失败", nil))
        }
    }];
#endif
}


#pragma mark - AllGroupUsers

- (void)gotoAllGroupUsers {
    AllUserViewController *vc = [AllUserViewController allUser:self.netModel];
    vc.title = NSLocalizedString(@"所有成员", nil);
    vc.groupId = self.groupInfo.groupId;
    [self.navigationController pushViewController:vc animated:YES];
}

// 消息免打扰
- (void)switchNotiClick:(BOOL)isState
{
    NSString *key = MESSAGE_NOTICE_SWITCH_KEY(APPINFORMATION.userInfo.userId, self.groupInfo.groupId);
    // 保存
    [[NSUserDefaults standardUserDefaults] setBool:isState forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
