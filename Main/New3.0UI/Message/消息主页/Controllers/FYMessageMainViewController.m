//
//  FYMessageMainViewController.m
//  ProjectCSHB
//
//  Created by fangyuan on 2020/5/14.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "FYMessageMainViewController+EmptyDataSet.h"
#import "FYScannerQRCodeViewController.h"
#import "FYMessageSearchViewController.h"
#import "FYMessageMainViewController.h"
#import "FYMsgSessionTableViewCell.h"
#import "FYMsgTableSectionFooter.h"
#import "FYMsgTableHeaderView.h"
#import "FYMsgAlertView.h"
#import "FYMsgNoticeModel.h"
#import "FYContactsModel.h"
#import "MGSwipeButton.h"
#import "FYContacts.h"
#import "FYMenuItem.h"
#import "FYMenu.h"
#import "FYSystemMessageModel.h"
#import "FYSystemNewMessageController.h"
#import "FYContactAddViewController.h"
#import "FYCreateGroupViewController.h"

CGFloat const TABLEVIEW_HEADER_HEIGHT_FOR_MSG_SEARCH = 58.0; // 搜索
CGFloat const TABLEVIEW_HEADER_HEIGHT_FOR_MSG_NOTICE = 30.0f; // 通知
CGFloat const TABLEVIEW_HEADER_HEIGHT_FOR_MSG_SPLINE = 11.3f; // 间隔（8+3.3）

@interface FYMessageMainViewController () <MGSwipeTableCellDelegate, FYMsgTableHeaderViewDelegate, FYMessageSearchViewControllerDelegate>
@property (nonatomic, strong) FYMenu *navPopMenuView;
@property (nonatomic, assign) CGFloat tableViewHeaderHeight;
@property (nonatomic, strong) FYMsgTableHeaderView *tableHeaderView;
@property (nonatomic, strong) EnterPwdBoxView *pwdBoxView;
@property (nonatomic, strong) NSMutableArray<FYMsgNoticeModel *> *arrayOfNoticeModels;
@end

@implementation FYMessageMainViewController

#pragma mark - Actions

- (void)pressNavBarButtonActionService:(id)sender
{
    NSString *urlString = [AppModel shareInstance].commonInfo[@"pop"];
    FYWebViewController *viewController = [[FYWebViewController alloc] initWithUrl:urlString];
    [viewController setTitle:NSLocalizedString(@"在线客服", nil)];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)pressNavBarButtonActionMenuItems:(id)sender
{
    if ([[AppModel shareInstance] isGuest]) {
        return;
    }
    
    // 弹出菜单
    CGFloat offsetX = SCREEN_WIDTH-[UINavigationConfig shared].sx_defaultFixSpace-NAVIGATION_BAR_BUTTON_IMAGE_SIZE*0.5;
    CGRect rect = CGRectMake(offsetX, kNavBarAndStatusBarHeight, 1, 1);
    [self.navPopMenuView showFromRect:rect inView:self.tabBarController.view];
}

- (void)pressMenuItemActionGroupChat:(FYMenuItem *)item
{
    // 创建群组
    [[IMGroupModule sharedInstance] handleVerifyCreateGroupThen:^(BOOL success) {
        if (success) {
            FYCreateGroupViewController *VC = [[FYCreateGroupViewController alloc] init];
            [self.navigationController pushViewController:VC animated:YES];
        }
    }];
}

- (void)pressMenuItemActionAddFriend:(FYMenuItem *)item
{
    // 添加朋友
    FYContactAddViewController *VC = [[FYContactAddViewController alloc] init];
    [self.navigationController pushViewController:VC animated:YES];
}

- (void)pressMenuItemActionScanQrcode:(FYMenuItem *)item
{
    // 扫一扫
#if TARGET_IPHONE_SIMULATOR
    ALTER_INFO_MESSAGE(NSLocalizedString(@"模拟器不能使用此功能", nil))
#elif TARGET_OS_IPHONE
    FYScannerQRCodeViewController *VC = [[FYScannerQRCodeViewController alloc] initWithType:FYQRCodeTypeAddFriends];
    [self.navigationController pushViewController:VC animated:YES];
#endif
}


#pragma mark - Life Cycle

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.hasRefreshHeader = YES;
        self.hasRefreshFooter = NO;
        _tableViewHeaderHeight = TABLEVIEW_HEADER_HEIGHT_FOR_MSG_SEARCH + TABLEVIEW_HEADER_HEIGHT_FOR_MSG_NOTICE + TABLEVIEW_HEADER_HEIGHT_FOR_MSG_SPLINE; // 空白间隔
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 导航栏按钮
    {
        // 客服
        UIBarButtonItem *leftButtonItem = [self createBarButtonItemWithImage:ICON_NAV_BAR_BUTTON_CUSTOMER_SERVICE
                                                                      target:self
                                                                       action:@selector(pressNavBarButtonActionService:)
                                                                   offsetType:CFCNavBarButtonOffsetTypeLeft
                                                                   imageSize:NAVIGATION_BAR_BUTTON_IMAGE_SIZE];
        [self.navigationItem setLeftBarButtonItem:leftButtonItem];
        // 菜单
        UIBarButtonItem *rightButtonItem = [self createBarButtonItemWithImage:ICON_NAV_BAR_BUTTON_MSG_MENU
                                                                       target:self
                                                                       action:@selector(pressNavBarButtonActionMenuItems:)
                                                                   offsetType:CFCNavBarButtonOffsetTypeRight
                                                                    imageSize:NAVIGATION_BAR_BUTTON_IMAGE_SIZE];
        [self.navigationItem setRightBarButtonItem:rightButtonItem];
    }
    
    // 添加监听通知
    [self addNotifications];
    
    // 刷新消息数据
    [self doRefreshMessage];
}

- (void)tableViewRefreshSetting:(UITableView *)tableView
{
    [self.tableViewRefresh setTableHeaderView:self.tableHeaderView];
}

- (void)tableViewRefreshRegisterClass:(UITableView *)tableView
{
    [self.tableViewRefresh registerClass:[FYMsgSessionTableViewCell class] forCellReuseIdentifier:[FYMsgSessionTableViewCell reuseIdentifier]];
}


#pragma mark - Network

- (Act)getRequestInfoAct
{
    return ActRequestSystemNotice;
}

- (NSMutableDictionary *)getRequestParamerter
{
    return @{
        @"current":@"1",
        @"size":@"20",
        @"sort":@"id",
        @"isAsc":@"true",
        @"queryParam":@{}
    }.mutableCopy;
}

- (void)loadMoreData
{
    WEAKSELF(weakSelf);
    [self viewDidLoadBeforeLoadNetworkDataOrCacheData];
    if (self.isShowLoadingHUD) {
        PROGRESS_HUD_SHOW
    }
    // 联系人信息（可以不加，此处为防止后台变更用户信息没有通知）
    [[IMContactsModule sharedInstance] handleUpdateAllContactEntitys:^(BOOL success) {
        // 自建群信息（可以不加，此处为防止后台变更群组信息没有通知）
        [[IMGroupModule sharedInstance] handleUpdateAllGroupEntitys:^(BOOL success) {
            // 通知公告信息（只需刷新通知公告）
            [self loadNetworkDataThen:^(BOOL success, BOOL isCache, NSUInteger count) {
                if (self.isShowLoadingHUD) {
                    PROGRESS_HUD_DISMISS
                }
                [weakSelf.tableViewRefresh.mj_header endRefreshing];
                [weakSelf viewDidLoadAfterLoadNetworkDataOrCacheData];
            }];
        }];
    }];
}

- (NSMutableArray *)loadNetworkDataOrCacheData:(id)responseDataOrCacheData isCacheData:(BOOL)isCacheData
{
    FYLog(NSLocalizedString(@"通知公告 => \n%@", nil), responseDataOrCacheData);
    
    WEAKSELF(weakSelf)
    if (!NET_REQUEST_SUCCESS(responseDataOrCacheData)) {
        [weakSelf setArrayOfNoticeModels:[FYMsgNoticeModel buildingDataModles]];
    } else {
        NSDictionary *data = NET_REQUEST_DATA(responseDataOrCacheData);
        NSMutableArray<FYMsgNoticeModel *> *itemNoticeModels = [NSMutableArray array];
        [data[@"records"] enumerateObjectsUsingBlock:^(NSDictionary *  _Nonnull dict, NSUInteger idx, BOOL * _Nonnull stop) {
            FYMsgNoticeModel *model = [FYMsgNoticeModel mj_objectWithKeyValues:dict];
            [itemNoticeModels addObj:model];
        }];
        if (itemNoticeModels.count <= 0) {
            itemNoticeModels = [FYMsgNoticeModel buildingDataModles];
        }
        [weakSelf setArrayOfNoticeModels:itemNoticeModels];
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (weakSelf.delegate_header && [weakSelf.delegate_header respondsToSelector:@selector(doRefreshForMsgHeaderWithNoticeModels:)]) {
            [weakSelf.delegate_header doRefreshForMsgHeaderWithNoticeModels:weakSelf.arrayOfNoticeModels];
        }
    });
    
    return @[].mutableCopy;
}

- (void)viewDidLoadAfterLoadNetworkDataOrCacheData
{
    // 刷新消息数据
    [self doRefreshMessage];
}


#pragma mark - UITableViewDelegate & UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (!self.tableDataRefresh) {
        return 0;
    }
    return self.tableDataRefresh.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!self.tableDataRefresh || self.tableDataRefresh.count <= 0) {
        return nil;
    }

    FYMsgSessionTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:[FYMsgSessionTableViewCell reuseIdentifier]];
    if (cell == nil) {
        cell = [[FYMsgSessionTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[FYMsgSessionTableViewCell reuseIdentifier]];
    }
    cell.delegate = self;
    cell.model = self.tableDataRefresh[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!self.tableDataRefresh || self.tableDataRefresh.count <= 0) {
        return FLOAT_MIN;
    }
    return [FYMsgSessionTableViewCell height];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (!self.tableDataRefresh || self.tableDataRefresh.count <= 0) {
        return nil;
    }
    
    CGFloat tabFooterHeight = CFC_AUTOSIZING_WIDTH(60.0f);
    FYMsgTableSectionFooter *footerView = [[FYMsgTableSectionFooter alloc] initWithFrame:CGRectMake(0, 0, self.tableViewRefresh.frame.size.width, tabFooterHeight) title:NSLocalizedString(@"邀请朋友加入", nil) footerHeight:tabFooterHeight parentViewController:self];
    return footerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (!self.tableDataRefresh || self.tableDataRefresh.count <= 0) {
        return FLOAT_MIN;
    }
    
    return CFC_AUTOSIZING_WIDTH(60.0f);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row >= self.tableDataRefresh.count) {
        ALTER_INFO_MESSAGE(NSLocalizedString(@"数据错误", nil))
        return;
    }
    id objModel = self.tableDataRefresh[indexPath.row];
    [self doTableSelectRowAtContactObject:objModel];
}


#pragma mark - MGSwipeTableCellDelegate

- (BOOL)swipeTableCell:(MGSwipeTableCell *)cell canSwipe:(MGSwipeDirection)direction fromPoint:(CGPoint)point
{
    return YES;
}

- (NSArray *)swipeTableCell:(MGSwipeTableCell *)cell swipeButtonsForDirection:(MGSwipeDirection)direction
             swipeSettings:(MGSwipeSettings *)swipeSettings expansionSettings:(MGSwipeExpansionSettings *) expansionSettings
{
    [swipeSettings setTransition:MGSwipeTransitionDrag];
    
    WEAKSELF(weakSelf)
    NSIndexPath *indexPath = [self.tableViewRefresh indexPathForCell:cell];
    id model = self.tableDataRefresh[indexPath.row];
    
    // 删除
    MGSwipeButton *trash = [MGSwipeButton buttonWithTitle:NSLocalizedString(@"删除", nil) backgroundColor:[UIColor colorWithRed:1.0 green:59/255.0 blue:50/255.0 alpha:1.0] padding:15 callback:^BOOL(MGSwipeTableCell *sender) {
        [weakSelf doActionOfTableViewToDeleteCellAtRow:indexPath];
        [cell hideSwipeAnimated:YES];
        return NO;
    }];
    
    // 标记已读 & 标记未读
    MGSwipeButton *read = nil;
    {
        if ([FYMSG_PRECISION_MANAGER doTryGetChatSessionFinishRead:model]) {
            read = [MGSwipeButton buttonWithTitle:NSLocalizedString(@"标记未读", nil) backgroundColor:[UIColor colorWithRed:76.0/255.0 green:75.0/255.0 blue:76.0/255.0 alpha:1.0] padding:15 callback:^BOOL(MGSwipeTableCell *sender) {
                [weakSelf doActionOfTableViewToUnFinishReadCellAtRow:indexPath];
                [cell hideSwipeAnimated:YES];
                return NO;
            }];
        } else {
            read = [MGSwipeButton buttonWithTitle:NSLocalizedString(@"标记已读", nil) backgroundColor:[UIColor colorWithRed:76.0/255.0 green:75.0/255.0 blue:76.0/255.0 alpha:1.0] padding:15 callback:^BOOL(MGSwipeTableCell *sender) {
                [weakSelf doActionOfTableViewToFinishReadCellAtRow:indexPath];
                [cell hideSwipeAnimated:YES];
                return NO;
            }];
        }
    }
    
    // 置顶 & 取消置顶
    MGSwipeButton *stick = [MGSwipeButton buttonWithTitle:NSLocalizedString(@"置顶", nil) backgroundColor:[UIColor colorWithRed:0 green:122/255.0 blue:1.0 alpha:1.0] padding:15 callback:^BOOL(MGSwipeTableCell *sender) {
        [weakSelf doActionOfTableViewToStickYesCellAtRow:indexPath];
        [cell hideSwipeAnimated:YES];
        return NO;
    }];
    {
        MGSwipeButton *stickno = [MGSwipeButton buttonWithTitle:NSLocalizedString(@"取消置顶", nil) backgroundColor:[UIColor colorWithRed:0 green:122/255.0 blue:1.0 alpha:1.0] padding:15 callback:^BOOL(MGSwipeTableCell *sender) {
            [weakSelf doActionOfTableViewToStickNoCellAtRow:indexPath];
            [cell hideSwipeAnimated:YES];
            return NO;
        }];
        
        NSString *sessionId = @"";
        if ([model isKindOfClass:[FYContacts class]]) {
            sessionId = ((FYContacts *)model).sessionId;
        } else if ([model isKindOfClass:[FYContactsModel class]]) {
            sessionId = ((FYContactsModel *)model).userId;
        }
        if ([FYMSG_PRECISION_MANAGER doTryGetChatSessionStickForSwitch:sessionId]) {
            stick = stickno;
        }
    }
    
    // 操作按钮
    if (MGSwipeDirectionLeftToRight == direction) {
        [expansionSettings setFillOnTrigger:NO];
        if ([model isKindOfClass:[FYContactsModel class]]) { // 在线客服，系统消息
            FYContactsModel *realModel = (FYContactsModel *)model;
            if (realModel.isLocal) {
                return nil;
            }
        }
        return @[stick];
    } else {
        [expansionSettings setFillOnTrigger:NO];
        if ([model isKindOfClass:[FYContacts class]]) { // 消息对话
           return @[trash,read];
        } else if ([model isKindOfClass:[FYContactsModel class]]) { // 在线客服，系统消息
            FYContactsModel *realModel = (FYContactsModel *)model;
            if (realModel.isLocal && FYContactsLocalTypeServices == realModel.localType) {
                return @[];
            }
            FYContacts *session = [[IMSessionModule sharedInstance] getSessionWithSessionId:realModel.chatId];
            if (VALIDATE_STRING_EMPTY(session.lastMessage)) {
                return @[];
            }
            return @[read];
        }
    }
    return nil;
}


#pragma mark - MGSwipeTableCell Actions

/// 置顶
- (void)doActionOfTableViewToStickYesCellAtRow:(NSIndexPath *)indexPath
{
    // 会话标识
    NSString *sessionId = @"";
    id model = self.tableDataRefresh[indexPath.row];
    if ([model isKindOfClass:[FYContacts class]]) {
        sessionId = ((FYContacts *)model).sessionId;
    } else if ([model isKindOfClass:[FYContactsModel class]]) {
        sessionId = ((FYContactsModel *)model).userId;
    }
    if (VALIDATE_STRING_EMPTY(sessionId)) {
        [FYMsgAlertView alertWithTitle:NSLocalizedString(@"提示信息", nil) content:NSLocalizedString(@"消息置顶失败", nil) confirmBlock:^{} cancleBlock:^{}];
        return;
    }
    
    // 置顶
    WEAKSELF(weakSelf)
    [FYMSG_PRECISION_MANAGER doTryChatSessionForStickYes:sessionId then:^(BOOL success) {
        if (success) {
            [weakSelf.tableDataRefresh removeObjectAtIndex:indexPath.row];
            if (weakSelf.tableDataRefresh.count > 2) {
                [weakSelf.tableDataRefresh insertObject:model atIndex:2];
            } else {
                [weakSelf.tableDataRefresh addObj:model];
            }
            [weakSelf.tableViewRefresh reloadData];
        }
    }];
}

/// 取消置顶
- (void)doActionOfTableViewToStickNoCellAtRow:(NSIndexPath *)indexPath
{
    // 会话标识
    NSString *sessionId = @"";
    id model = self.tableDataRefresh[indexPath.row];
    if ([model isKindOfClass:[FYContacts class]]) {
        sessionId = ((FYContacts *)model).sessionId;
    } else if ([model isKindOfClass:[FYContactsModel class]]) {
        sessionId = ((FYContactsModel *)model).userId;
    }
    if (VALIDATE_STRING_EMPTY(sessionId)) {
        [FYMsgAlertView alertWithTitle:NSLocalizedString(@"提示信息", nil) content:NSLocalizedString(@"取消置顶失败", nil) confirmBlock:^{} cancleBlock:^{}];
        return;
    }
    
    // 取消置顶
    [FYMSG_PRECISION_MANAGER doTryChatSessionForStickNO:sessionId then:^(BOOL success) {
        if (success) {
            // 刷新数据
            [self doRefreshMessage];
        }
    }];
}

/// 标记已读
- (void)doActionOfTableViewToFinishReadCellAtRow:(NSIndexPath *)indexPath
{
    // 会话标识
    NSString *sessionId = @"";
    id model = self.tableDataRefresh[indexPath.row];
    if ([model isKindOfClass:[FYContacts class]]) {
        sessionId = ((FYContacts *)model).sessionId;
    } else if ([model isKindOfClass:[FYContactsModel class]]) {
        sessionId = ((FYContactsModel *)model).userId;
    }
    if (VALIDATE_STRING_EMPTY(sessionId)) {
        [FYMsgAlertView alertWithTitle:NSLocalizedString(@"提示信息", nil) content:NSLocalizedString(@"标记已读失败", nil) confirmBlock:^{} cancleBlock:^{}];
        return;
    }
    
    // 标记已读
    [FYMSG_PRECISION_MANAGER doTryChatSessionForFinishRead:model then:^(BOOL success) {

    }];
}

/// 标记未读
- (void)doActionOfTableViewToUnFinishReadCellAtRow:(NSIndexPath *)indexPath
{
    // 会话标识
    NSString *sessionId = @"";
    id model = self.tableDataRefresh[indexPath.row];
    if ([model isKindOfClass:[FYContacts class]]) {
        sessionId = ((FYContacts *)model).sessionId;
    } else if ([model isKindOfClass:[FYContactsModel class]]) {
        sessionId = ((FYContactsModel *)model).userId;
    }
    if (VALIDATE_STRING_EMPTY(sessionId)) {
        [FYMsgAlertView alertWithTitle:NSLocalizedString(@"提示信息", nil) content:NSLocalizedString(@"标记未读失败", nil) confirmBlock:^{} cancleBlock:^{}];
        return;
    }
    
    // 标记未读
    [FYMSG_PRECISION_MANAGER doTryChatSessionForUnFinishRead:model then:^(BOOL success) {

    }];
}

/// 删除
- (void)doActionOfTableViewToDeleteCellAtRow:(NSIndexPath *)indexPath
{
    id model = self.tableDataRefresh[indexPath.row];
    if (![model isKindOfClass:[FYContacts class]]) {
        ALTER_INFO_MESSAGE(NSLocalizedString(@"客服会话不能删除", nil))
        return;
    }

    WEAKSELF(weakSelf)
    FYContacts *deleteModel = (FYContacts *)model;
    [FYMSG_PRECISION_MANAGER doTryChatSessionForRecordsDelete:deleteModel.sessionId then:^(BOOL success) {
        if (success) {
            // 刷新表格
            if (indexPath.row < weakSelf.tableDataRefresh.count) {
                [weakSelf.tableDataRefresh removeObjectAtIndex:indexPath.row];
                [weakSelf.tableViewRefresh deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
            }
        } else {
            ALTER_INFO_MESSAGE(NSLocalizedString(@"删除聊天信息失败！", nil))
        }
    }];
}


#pragma mark - FYMsgTableHeaderViewDelegate

- (void)didSearchActionFromMsgTableHeaderView
{
    // 搜索消息
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    //
    FYMessageSearchViewController *alterVC = [FYMessageSearchViewController alertSearchController:self.tableDataRefresh delegate:self];
    [alterVC setCancleActionBlock:^{
        [self.navigationController setNavigationBarHidden:NO animated:YES];
    }];
    [self presentViewController:alterVC animated:YES completion:^{
        
    }];
}


#pragma mark - FYMessageSearchViewControllerDelegate

- (void)didMessageSearchResultAtObjectModel:(id)objModel
{
    [self doTableSelectRowAtContactObject:objModel];
}


#pragma mark - Notification

- (void)addNotifications
{
    // 通知 - 未读取消息数有变更
    [NOTIF_CENTER addObserver:self selector:@selector(doNotifiUnreadMsgNumberChange:) name:kNotificationMsgUnreadMessageNumberChange object:nil];
    
    // 通知 - 修改更新好友信息
    [NOTIF_CENTER addObserver:self selector:@selector(doNotifiModifyFriendInfo:) name:kNotificationModifyFriendInfo object:nil];
    
    // 通知 - 好友或者客服的离线或上线消息
    [NOTIF_CENTER addObserver:self selector:@selector(doNotifiUserOnOffStatusChange:) name:kNotificationUserOnOffStatusChange object:nil];
    
    // 通知 - 创建或删除自建群
    [NOTIF_CENTER addObserver:self selector:@selector(doNotifiCreateOrDeleteSelfGroup:) name:kNotificationCreateOrDeleteSelfGroup object:nil];
    
    // 通知 - 修改自建群的信息（如：群名称）
    [NOTIF_CENTER addObserver:self selector:@selector(doNotifiModifyUpdateSelfGroupInfo:) name:kNotificationModifyUpdateGroupInfo object:nil];
    
    // 通知 - 刷新系统消息或通知公告（添加、删除、修改）
    [NOTIF_CENTER addObserver:self selector:@selector(doNotifiRefreshSysMsgOrNotice:) name:kNotificationSysMsgOrPlatformNoticeChange object:nil];
    
    // 本地 - 已清空某会话的聊天记录
    [NOTIF_CENTER addObserver:self selector:@selector(doNotifiClearChatRecordsData:) name:kNotificationClearChatRecordsContent object:nil];
}

/// 未读取消息数有变更
- (void)doNotifiUnreadMsgNumberChange:(NSNotification *)notification
{
    FYLog(NSLocalizedString(@"通知：未读取消息数有变更", nil));
    // 刷新消息数据
    [self doRefreshMessage];
}

/// 修改更新好友信息
- (void)doNotifiModifyFriendInfo:(NSNotification *)notification
{
    FYLog(NSLocalizedString(@"通知：修改更新好友信息", nil));
    // 刷新消息数据
    [self doRefreshMessage];
}

/// 好友或者客服的离线或上线消息
- (void)doNotifiUserOnOffStatusChange:(NSNotification *)notification
{
    FYLog(NSLocalizedString(@"通知：好友或者客服的离线或上线消息", nil));
    // 刷新消息数据
    [self doRefreshMessage];
}

/// 创建或删除自建群
- (void)doNotifiCreateOrDeleteSelfGroup:(NSNotification *)notification
{
    FYLog(NSLocalizedString(@"通知：创建或删除自建群", nil));
    // 刷新消息数据
    [self doRefreshMessage];
}

/// 修改自建群的信息（如：群名称）
- (void)doNotifiModifyUpdateSelfGroupInfo:(NSNotification *)notification
{
    FYLog(NSLocalizedString(@"通知：修改自建群的信息", nil));
    // 刷新消息数据
    [self doRefreshMessage];
}

/// 刷新系统消息或通知公告
- (void)doNotifiRefreshSysMsgOrNotice:(NSNotification *)notification
{
    FYLog(NSLocalizedString(@"通知：刷新系统消息或通知公告", nil));
    // 刷新系统消息或通知公告
    [self doRefreshMessage];
    
    // 刷新系统消息或通知公告
    [self loadData];
}

/// 已清空某会话的聊天记录
- (void)doNotifiClearChatRecordsData:(NSNotification *)notification
{
    FYLog(NSLocalizedString(@"通知：已清空某会话的聊天记录", nil));
    // 刷新消息数据
    [self doRefreshMessage];
}

- (void)removeObservers
{
    [NOTIF_CENTER removeObserver:self];
}

- (void)dealloc
{
    [self removeObservers];
}


#pragma mark - Navigation

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}

- (NSString *)prefersNavigationBarTitleViewTitle
{
    return STR_NAVIGATION_BAR_TITLE_MESSAGE;
}

- (CGFloat)prefersNavigationBarHairlineHeight
{
    return NAVIGATION_BAR_HAIR_LINE_HEIGHT_ZERO;
}


#pragma mark - Getter & Setter

- (FYMenu *)navPopMenuView
{
    if (!_navPopMenuView) {
        NSArray<NSDictionary<NSString *, NSString *> *> *arrayOfMenus = @[
            @{ @"icon":ICON_MSG_MENU_GROUP_BUILD, @"title":STR_MSG_MENU_TITLE_GROUP_BUILD },
            @{ @"icon":ICON_MSG_MENU_ADD_FRIEND, @"title":STR_MSG_MENU_TITLE_ADD_FRIEND },
            @{ @"icon":ICON_MSG_MENU_SCAN_QRCODE, @"title":STR_MSG_MENU_TITLE_SCAN_QRCODE }
        ];
        CGFloat menuItemHeight = CFC_AUTOSIZING_HEIGTH(48);
        CGFloat menuItemImageSzie = menuItemHeight * 0.5f;
        NSMutableArray<FYMenuItem *> *menuItems = [NSMutableArray<FYMenuItem *> arrayWithCapacity:arrayOfMenus.count];
        for (NSDictionary<NSString *, NSString *> *elem in arrayOfMenus) {
            UIImage *itemImage = [[UIImage imageNamed:[elem stringForKey:@"icon"]] imageByScalingProportionallyToSize:CGSizeMake(menuItemImageSzie, menuItemImageSzie)];
            NSString *itemTitle = [elem stringForKey:@"title"];
            FYMenuItem *menuItem = [FYMenuItem itemWithImage:itemImage title:itemTitle action:^(FYMenuItem * _Nonnull item) {
                if ([STR_MSG_MENU_TITLE_GROUP_BUILD isEqualToString:item.title]) {
                    [self pressMenuItemActionGroupChat:item];
                } else if ([STR_MSG_MENU_TITLE_ADD_FRIEND isEqualToString:item.title]) {
                    [self pressMenuItemActionAddFriend:item];
                } else if ([STR_MSG_MENU_TITLE_SCAN_QRCODE isEqualToString:item.title]) {
                    [self pressMenuItemActionScanQrcode:item];
                } else {
                    [self alertPromptMessage:@""];
                }
            }];
            [menuItems addObj:menuItem];
        }
        _navPopMenuView = [[FYMenu alloc] initWithItems:menuItems BackgroundStyle:IFMMenuBackgroundStyleDark];
        _navPopMenuView.showShadow = true;
        _navPopMenuView.menuCornerRadiu = 5.0;
        _navPopMenuView.minMenuItemHeight = menuItemHeight;
        _navPopMenuView.titleColor = COLOR_HEXSTRING(@"#FFFFFF");
        _navPopMenuView.titleFont = [UIFont systemFontOfSize2:CFC_AUTOSIZING_FONT(13)];
        _navPopMenuView.menuBackGroundColor = COLOR_HEXSTRING(@"#464646");
        _navPopMenuView.segmenteLineColor = COLOR_HEXSTRING(@"#5E5E5E");
    }
    return _navPopMenuView;
}

- (FYMsgTableHeaderView *)tableHeaderView
{
    if (!_tableHeaderView) {
        _tableHeaderView = [[FYMsgTableHeaderView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.tableViewHeaderHeight) headerHeight:self.tableViewHeaderHeight delegate:self parentViewController:self];
        self.delegate_header = _tableHeaderView;
    }
    return _tableHeaderView;
}


#pragma mark - Private

/// 刷新消息数据
- (void)doRefreshMessage
{
    // 客服数据
    NSArray<IMUserEntity *> *serviceEntities = [[IMContactsModule sharedInstance] getAllServices];
    NSArray<NSDictionary *> *arrayOfDicts = [IMUserEntity mj_keyValuesArrayWithObjectArray:serviceEntities];
    NSArray<FYContactsModel *> *itemServiceModels = [FYContactsModel mj_objectArrayWithKeyValuesArray:arrayOfDicts];
    
    // 客服数据 + 会话数据 => 去重复数据
    __block NSMutableArray<FYContacts *> *filterOfContacts = [NSMutableArray<FYContacts *> array];
    [[IMSessionModule getAllSessions] enumerateObjectsUsingBlock:^(FYContacts * _Nonnull session, NSUInteger idx, BOOL * _Nonnull stop) {
        BOOL isContainer = NO;
        if ([[FYSysMsgNoticeEntity reuseChatSysMsgNoticeSessionId] isEqualToString:session.sessionId]) {
            isContainer = YES; // 系统消息，此处不处理，在最后处理
        } else {
            for (FYContactsModel *customer in itemServiceModels) {
                if ([session.userId isEqualToString:customer.userId]) {
                    isContainer = YES;
                    break;
                }
            }
        }
        
        if (!isContainer) {
            [filterOfContacts addObj:session];
        }
    }];
    
    // 合并数据【客服 + 会话】
    NSMutableArray * tableMergeModels = [NSMutableArray array];
    if (itemServiceModels && 0 < itemServiceModels.count) {
        [tableMergeModels addObjectsFromArray:itemServiceModels];
    }
    if (filterOfContacts && 0 < filterOfContacts.count) {
        [tableMergeModels addObjectsFromArray:filterOfContacts];
    }
    
    // 置顶处理
    __block NSMutableArray *tableFilterStickModels = [NSMutableArray array];
    {
        // 置顶数据
        NSMutableArray<NSString *> *hasAddUserArray = [NSMutableArray array];
        NSString *stringOfArr = NSUSERDEFAULTS_OBJ_KEY(FYMSG_CHAT_STICK_ARRAY_DEF_KEY);
        if (!VALIDATE_STRING_EMPTY(stringOfArr)) {
            NSArray<NSString *> *arrOfStickKey = [stringOfArr componentsSeparatedByString:FYMSG_CHAT_STICK_ARRAY_SPLIIT];
            if (arrOfStickKey.count > 0) {
                for (NSString *stickKey in arrOfStickKey) {
                    [tableMergeModels enumerateObjectsWithIndex:^(id object, NSUInteger index) {
                        NSString *objId = @"";
                        if ([object isKindOfClass:[FYContacts class]]) {
                            objId = CHAT_STICK_SWITCH_KEY(APPINFORMATION.userInfo.userId, ((FYContacts *)object).sessionId);
                        } else if ([object isKindOfClass:[FYContactsModel class]]) {
                            objId = CHAT_STICK_SWITCH_KEY(APPINFORMATION.userInfo.userId, ((FYContactsModel *)object).userId);
                        }
                        if (!VALIDATE_STRING_EMPTY(objId) && [stickKey isEqualToString:objId]) {
                            [hasAddUserArray addObj:stickKey];
                            [tableFilterStickModels addObj:object];
                        }
                    }];
                }
            }
        }
        // 其它数据
        [tableMergeModels enumerateObjectsWithIndex:^(id object, NSUInteger index) {
            NSString *objId = @"";
            if ([object isKindOfClass:[FYContacts class]]) {
                objId = CHAT_STICK_SWITCH_KEY(APPINFORMATION.userInfo.userId, ((FYContacts *)object).sessionId);
            } else if ([object isKindOfClass:[FYContactsModel class]]) {
                objId = CHAT_STICK_SWITCH_KEY(APPINFORMATION.userInfo.userId, ((FYContactsModel *)object).userId);
            }
            if (![hasAddUserArray containsObject:objId]) {
                [tableFilterStickModels addObj:object];
            }
        }];
    }
 
    // 系统消息
    __block BOOL isContainerSysMsgNotice = NO;
    [[IMSessionModule getAllSessions] enumerateObjectsUsingBlock:^(FYContacts * _Nonnull session, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([[FYSysMsgNoticeEntity reuseChatSysMsgNoticeSessionId] isEqualToString:session.sessionId]) {
            isContainerSysMsgNotice = YES;
            [tableFilterStickModels insertObject:[FYContactsModel buildingDataModleForSystemMessageWithSession:session] atIndex:0];
        }
    }];
    if (!isContainerSysMsgNotice) {
        [tableFilterStickModels insertObject:[FYContactsModel buildingDataModleForSystemMessage] atIndex:0];
    }
    
    // 本地客服
    [tableFilterStickModels insertObject:[FYContactsModel buildingDataModleForCustomerService] atIndex:1];
    
    // 全部消息
    [self.tableDataRefresh setArray:tableFilterStickModels];
    
    // 刷新表格
    dispatch_main_async_safe(^{
        if (self.tableDataRefresh.count > 0) {
            [self.tableViewRefresh reloadData];
        } else {
            [self.tableViewRefresh reloadData];
            [self setIsEmptyDataSetShouldDisplay:YES];
            [self.tableViewRefresh reloadEmptyDataSet];
        }
    });
}


#pragma mark -

/// 消息详情
- (void)doTableSelectRowAtContactObject:(id)model
{
    if ([model isKindOfClass:[FYContacts class]]) { // 消息对话
        [self doTableSelectRowAtContacts:model];
    } else if ([model isKindOfClass:[FYContactsModel class]]) { // 在线客服
        [self doTableSelectRowAtContactsModel:model];
    }
}

/// 消息详情 - 聊天
- (void)doTableSelectRowAtContacts:(FYContacts *)model
{
    if (!model) {
        ALTER_INFO_MESSAGE(NSLocalizedString(@"会话数据错误", nil))
        return;
    }
    
    if (FYConversationType_PRIVATE == model.sessionType) {
        FYChatConversationType chatType = FYConversationType_PRIVATE;
        if (3 == model.messageType) { // 官方群:1 自建群:2 客服:3 好友:4
            chatType = FYConversationType_CUSTOMERSERVICE;
        }
        ChatViewController *VC = [[ChatViewController alloc] initWithConversationType:chatType targetId:model.sessionId];
        [VC setToContactsModel:model];
        [VC setTitle:VALIDATE_STRING_EMPTY(model.friendNick)?model.nick:model.friendNick];
        [self.navigationController pushViewController:VC animated:YES];
    } else if (FYConversationType_GROUP == model.sessionType) {
        MessageItem *msgItem = [[IMGroupModule sharedInstance] getGroupWithGroupId:model.id];
        if (msgItem.officeFlag) {
            // 官方群
            [self doTryToJoinGroupOfficeYes:msgItem];
        } else {
            // 自建群
            [self doTryToJoinGroupOfficeNo:msgItem];
        }
    }
}

/// 消息详情 - 客服、系统消息
- (void)doTableSelectRowAtContactsModel:(FYContactsModel *)model
{
    if (!model) {
        ALTER_INFO_MESSAGE(NSLocalizedString(@"会话数据错误", nil))
        return;
    }
    
    if (VALIDATE_STRING_EMPTY(model.chatId)) {
        NSString *urlString = [AppModel shareInstance].commonInfo[@"pop"];
        FYWebViewController *viewController = [[FYWebViewController alloc] initWithUrl:urlString];
        [viewController setTitle:NSLocalizedString(@"在线客服", nil)];
        [self.navigationController pushViewController:viewController animated:YES];
    } else {
        // 系统消息或通知公告
        if (FYContactsLocalTypeSystemMessage == model.localType) {
            FYSystemNewMessageController *VC = [[FYSystemNewMessageController alloc] initWithSessionId:model.chatId];
            [self.navigationController pushViewController:VC animated:YES];
        }
        // 客服会话 + 私人会话 + 群组会话
        else {
            FYContacts *session = [[IMSessionModule sharedInstance] getSessionWithSessionId:model.chatId];
            if (VALIDATE_STRING_EMPTY(session.id)) {
                NSDictionary *dictionary = [model mj_keyValues];
                session = [[FYContacts alloc] initWithPropertiesDictionary:dictionary];
            }
            ChatViewController *VC = [[ChatViewController alloc] initWithConversationType:FYConversationType_CUSTOMERSERVICE targetId:model.chatId];
            [VC setToContactsModel:session];
            [VC setTitle:model.nick];
            [self.navigationController pushViewController:VC animated:YES];
        }
    }
}

/// 消息详情 - 自建群聊
- (void)doTryToJoinGroupOfficeNo:(MessageItem *)msgItem
{
    [FYMSG_PRECISION_MANAGER doTryToJoinGroupOfficeNo:msgItem from:self.navigationController];;
}

/// 消息详情 - 官方群聊
- (void)doTryToJoinGroupOfficeYes:(MessageItem *)msgItem
{
    if ([APPINFORMATION isGuest]) {
        return;
    }
    
    // 加入群组（无密码）
    [self.tableViewRefresh setAllowsSelection:NO];
    if (VALIDATE_STRING_EMPTY(msgItem.password)) {
        UINavigationController *navigationController = self.navigationController;
        [FYMSG_PRECISION_MANAGER doTryToJoinGroupOfficeYes:msgItem password:@"" from:navigationController];
        [self.tableViewRefresh setAllowsSelection:YES];
        return;
    }
    
    // 加入群组（有密码）
    WEAKSELF(weakSelf);
    self.pwdBoxView = [[EnterPwdBoxView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [self.pwdBoxView setJoinGroupBtnBlock:^(NSString * _Nonnull password) {
        UINavigationController *navigationController = weakSelf.navigationController;
        [FYMSG_PRECISION_MANAGER doTryToJoinGroupOfficeYes:msgItem password:password from:navigationController];
        [weakSelf.pwdBoxView remover];
    }];
    [self.pwdBoxView showInView:self.view];
    [self.tableViewRefresh setAllowsSelection:YES];
}


@end

