//
//  FYContactMainViewController.m
//  ProjectCSHB
//
//  Created by fangyuan on 2020/6/15.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "FYContactMainViewController.h"
#import "FYContactTableSectionFooter.h"
#import "FYContactTableHeaderView.h"
#import "FYContactMainTableViewCell.h"
#import "FYContactSectionModel.h"
#import "FYContactDataHelper.h"
#import "FYContactsModel.h"
#import "FYContacts.h"
//
#import "UITableView+SCIndexView.h"
#import "FYIndexViewHeaderView.h"
//
#import "FYContactSearchViewController.h"
#import "FYShowNewsFriendViewController.h"
#import "FYContactGroupViewController.h"
#import "FYContactAddViewController.h"


CGFloat const TABLEVIEW_HEADER_HEIGHT_FOR_CONTACTS_SEARCH = 58.0; // 搜索
CGFloat const TABLEVIEW_HEADER_HEIGHT_FOR_CONTACTS_SPLINE = 0.6f; // 间隔


@interface FYContactMainViewController () <FYContactTableHeaderViewDelegate, FYContactSearchViewControllerDelegate>
@property (nonatomic, assign) CGFloat tableViewHeaderHeight;
@property (nonatomic, strong) FYContactTableHeaderView *tableHeaderView;

@end


@implementation FYContactMainViewController


#pragma mark - Actions

- (void)pressNavigationBarLeftButtonItem:(id)sender
{
    NSString *urlString = [AppModel shareInstance].commonInfo[@"pop"];
    FYWebViewController *viewController = [[FYWebViewController alloc] initWithUrl:urlString];
    [viewController setTitle:NSLocalizedString(@"在线客服", nil)];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)pressNavigationBarRightButtonItem:(id)sender
{
    if ([APPINFORMATION isGuest]) {
        return;
    }
    FYContactAddViewController *viewController = [[FYContactAddViewController alloc] init];
    [self.navigationController pushViewController:viewController animated:YES];
}


#pragma mark - Life Cycle

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.hasRefreshHeader = NO;
        self.hasRefreshFooter = NO;
        _tableViewHeaderHeight = TABLEVIEW_HEADER_HEIGHT_FOR_CONTACTS_SEARCH + TABLEVIEW_HEADER_HEIGHT_FOR_CONTACTS_SPLINE; // 空白间隔
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 添加监听通知
    [self addNotifications];
    
    // 联系人是否已初始化
    if ([[IMContactsModule sharedInstance] getAllContacts].count > 0) {
        // 刷新通讯录数据
        [self doRefreshContacts];
    } else {
        // 加载一次数据
        PROGRESS_HUD_SHOW
        [[IMContactsModule sharedInstance] handleUpdateAllContactEntitys:^(BOOL success) {
            PROGRESS_HUD_DISMISS
            // 刷新通讯录数据
            [self doRefreshContacts];
        }];
    }
}

- (void)tableViewRefreshSetting:(UITableView *)tableView
{
    [self.tableViewRefresh setShowsVerticalScrollIndicator:NO];
    [self.tableViewRefresh setTableHeaderView:self.tableHeaderView];
    
    CGFloat margin = CFC_AUTOSIZING_MARGIN(MARGIN);
    SCIndexViewConfiguration *configuration = [SCIndexViewConfiguration configuration];
    configuration.indexItemHeight = 13.0f;
    configuration.indexItemsSpace = margin * 0.25f;
    configuration.indexItemRightMargin = margin * 0.5f;
    configuration.indexItemTextColor = COLOR_HEXSTRING(@"#555555");
    configuration.indexItemSelectedTextColor = COLOR_HEXSTRING(@"#FFFFFF");
    configuration.indexItemSelectedBackgroundColor = COLOR_SYSTEM_MAIN_UI_THEME_DEFAULT;
    //
    self.tableViewRefresh.sc_indexViewConfiguration = configuration;
    self.tableViewRefresh.sc_translucentForTableViewInNavigationBar = NO;
}

- (void)tableViewRefreshRegisterClass:(UITableView *)tableView
{
    [self.tableViewRefresh registerClass:[FYContactMainTableViewCell class] forCellReuseIdentifier:[FYContactMainTableViewCell reuseIdentifier]];
    [self.tableViewRefresh registerClass:FYIndexViewHeaderView.class forHeaderFooterViewReuseIdentifier:FYIndexViewHeaderView.reuseID];
}


#pragma mark - UITableViewDelegate & UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.tableDataRefresh.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (!self.tableDataRefresh || self.tableDataRefresh.count <= section) {
        return 0;
    }
    FYContactSectionModel *sectionItem = self.tableDataRefresh[section];
    return sectionItem.contacts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!self.tableDataRefresh || self.tableDataRefresh.count <= indexPath.section) {
        return nil;
    }
    
    FYContactSectionModel *sectionItem = self.tableDataRefresh[indexPath.section];
    FYContactsModel *contactModel = [sectionItem.contacts objectAtIndex:indexPath.row];

    FYContactMainTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:[FYContactMainTableViewCell reuseIdentifier]];
    if (cell == nil) {
        cell = [[FYContactMainTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[FYContactMainTableViewCell reuseIdentifier]];
    }
    cell.model = contactModel;
    cell.indexPath = indexPath;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    // 新的朋友
    if (FYContactsLocalTypeMyNewFriends == contactModel.localType) {
        cell.badge = [IMContactsModule sharedInstance].allVerifyFriendEntities.count;
    }
    // 我的群组
    else if (FYContactsLocalTypeMyJoinGroups == contactModel.localType) {
        cell.badge = [IMContactsModule sharedInstance].allVerifyGroupEntities.count;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!self.tableDataRefresh || self.tableDataRefresh.count <= 0) {
        return FLOAT_MIN;
    }
    return TABLEVIEW_CELL_HEIGHT_FOR_CONTACT_MAIN;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return nil;
    }
    
    FYIndexViewHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:FYIndexViewHeaderView.reuseID];
    FYContactSectionModel *sectionItem = self.tableDataRefresh[section];
    [headerView configWithTitle:sectionItem.title];
    return headerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section < (self.tableDataRefresh.count-1)) {
        return nil;
    }
    
    CGFloat tabFooterHeight = CFC_AUTOSIZING_WIDTH(60.0f);
    FYContactTableSectionFooter *footerView = [[FYContactTableSectionFooter alloc] initWithFrame:CGRectMake(0, 0, self.tableViewRefresh.frame.size.width, tabFooterHeight) footerHeight:tabFooterHeight];
    return footerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return FLOAT_MIN;
    }
    return FYIndexViewHeaderView.headerViewHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section < (self.tableDataRefresh.count-1)) {
        return FLOAT_MIN;
    }
    return CFC_AUTOSIZING_WIDTH(60.0f);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    FYContactSectionModel *sectionItem = self.tableDataRefresh[indexPath.section];
    FYContactsModel *contactModel = [sectionItem.contacts objectAtIndex:indexPath.row];
    [self doTableSelectRowAtContactObject:contactModel];
}


#pragma mark - FYContactTableHeaderViewDelegate

- (void)didSearchActionFromContactTableHeaderView
{
    // 搜索消息
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    //
    FYContactSearchViewController *alterVC = [FYContactSearchViewController alertSearchController:self.tableDataRefresh delegate:self];
    [alterVC setCancleActionBlock:^{
        [self.navigationController setNavigationBarHidden:NO animated:YES];
    }];
    [self presentViewController:alterVC animated:YES completion:^{
        
    }];
}


#pragma mark - FYContactSearchViewControllerDelegate

- (void)didContactSearchResultAtObjectModel:(id)objModel
{
    if (![objModel isKindOfClass:[FYContactsModel class]]) {
        return;
    }
    
    [self doTableSelectRowAtContactObject:objModel];
}


#pragma mark - Notification

- (void)addNotifications
{
    // 通知 - 新好友申请
    [NOTIF_CENTER addObserver:self selector:@selector(doNotifiNewFriendInvitation:) name:kNotificationNewFriendInvitation object:nil];
    
    // 通知 - 添加或删除好友
    [NOTIF_CENTER addObserver:self selector:@selector(doNotifiAddOrDeleteFriend:) name:kNotificationAddOrDeleteFriend object:nil];
    
    // 通知 - 修改更新好友信息
    [NOTIF_CENTER addObserver:self selector:@selector(doNotifiModifyFriendInfo:) name:kNotificationModifyFriendInfo object:nil];
    
    // 通知 - 好友或者客服的离线或上线消息
    [NOTIF_CENTER addObserver:self selector:@selector(doNotifiUserOnOffStatusChange:) name:kNotificationUserOnOffStatusChange object:nil];
}

/// 新好友申请
- (void)doNotifiNewFriendInvitation:(NSNotification *)notification
{
    FYLog(NSLocalizedString(@"通知：新好友申请", nil));
    
    // 刷新联系人数据
    WEAKSELF(weakSelf)
    NSArray<NSIndexPath *> *indexPaths = @[[NSIndexPath indexPathForRow:0 inSection:0]];
    dispatch_main_async_safe(^{
        [weakSelf.tableViewRefresh reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
    });
}

/// 添加或删除好友
- (void)doNotifiAddOrDeleteFriend:(NSNotification *)notification
{
    FYLog(NSLocalizedString(@"通知：添加或删除好友", nil));
    
    // 刷新联系人数据
    [self doRefreshContacts];
}

/// 修改更新好友信息
- (void)doNotifiModifyFriendInfo:(NSNotification *)notification
{
    FYLog(NSLocalizedString(@"通知：修改更新好友信息", nil));
    
    // 刷新联系人数据
    [self doRefreshContacts];
}

/// 好友或者客服的离线或上线消息
- (void)doNotifiUserOnOffStatusChange:(NSNotification *)notification
{
    FYLog(NSLocalizedString(@"通知：好友或者客服的离线或上线消息", nil));
    
    // 刷新联系人数据
    [self doRefreshContacts];
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

- (CGFloat)prefersNavigationBarHairlineHeight
{
    return NAVIGATION_BAR_HAIR_LINE_HEIGHT_ZERO;
}

- (CFCNavBarButtonItemType)prefersNavigationBarLeftButtonItemType
{
    return CFCNavBarButtonItemTypeCustom;
}

- (NSString *)prefersNavigationBarLeftButtonItemImageNormal
{
    return ICON_NAV_BAR_BUTTON_CUSTOMER_SERVICE;
}

- (CFCNavBarButtonItemType)prefersNavigationBarRightButtonItemType
{
    return CFCNavBarButtonItemTypeCustom;
}

- (NSString *)prefersNavigationBarRightButtonItemImageNormal
{
    return ICON_NAV_BAR_BUTTON_ADD_FRIEND;
}


#pragma mark - Getter & Setter

- (FYContactTableHeaderView *)tableHeaderView
{
    if (!_tableHeaderView) {
        _tableHeaderView = [[FYContactTableHeaderView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.tableViewHeaderHeight) headerHeight:self.tableViewHeaderHeight delegate:self parentViewController:self];
    }
    return _tableHeaderView;
}


#pragma mark - Private

/// 刷新通讯录数据
- (void)doRefreshContacts
{    
    // 数据处理
    NSMutableArray<FYContactSectionModel *> *allSectionModels = [FYContactDataHelper getContactDataSource];
    NSMutableArray<NSString *> *sectionIndexTitle = [FYContactDataHelper getContactSectionTitles:allSectionModels];
    
    // 所有数据
    [self setTableDataRefresh:allSectionModels];
    
    // 刷新表格
    dispatch_main_async_safe(^{
        // 刷新表格
        if (self.tableDataRefresh.count > 0) {
            [self.tableViewRefresh reloadData];
        } else {
            [self.tableViewRefresh reloadData];
            [self setIsEmptyDataSetShouldDisplay:YES];
            [self.tableViewRefresh reloadEmptyDataSet];
        }
        
        // 右边索引
        [self.tableViewRefresh setSc_indexViewDataSource:sectionIndexTitle.copy];
        [self.tableViewRefresh setSc_startSection:1];
    });
}


#pragma mark -

/// 联系人详情
- (void)doTableSelectRowAtContactObject:(FYContactsModel *)model
{
    if (model.isLocal) { // 本地功能 + 在线客服
        [self doTableSelectRowAtContactModelOfLocal:model];
    } else { // 客服 + 朋友
        if (0 == model.type) {
            [self doTableSelectRowAtContactModelOfService:model];
        } else if (1 == model.type) {
            [self doTableSelectRowAtContactModelOfFriends:model];
        }
    }
}

/// 本地功能 + 在线客服
- (void)doTableSelectRowAtContactModelOfLocal:(FYContactsModel *)model
{
    if (!model.isLocal) {
        return;
    }
    
    if (FYContactsLocalTypeServices == model.localType) {
        [self pressNavigationBarLeftButtonItem:nil];
    } else if (FYContactsLocalTypeMyNewFriends == model.localType) {
        FYShowNewsFriendViewController *VC = [FYShowNewsFriendViewController new];
        [VC setTitle:model.nick];
        [self.navigationController pushViewController:VC animated:YES];
        //
        [[IMContactsModule sharedInstance] deleteAllFriendVerification];
    } else if (FYContactsLocalTypeMyJoinGroups == model.localType) {
        FYContactGroupViewController *VC = [FYContactGroupViewController new];
        [VC setTitle:model.nick];
        [self.navigationController pushViewController:VC animated:YES];
    }
}

/// 客服
- (void)doTableSelectRowAtContactModelOfService:(FYContactsModel *)model
{
    if (!model) {
        ALTER_INFO_MESSAGE(NSLocalizedString(@"联系人数据错误", nil))
        return;
    }
    
    if (VALIDATE_STRING_EMPTY(model.chatId)) {
        NSString *urlString = [AppModel shareInstance].commonInfo[@"pop"];
        FYWebViewController *viewController = [[FYWebViewController alloc] initWithUrl:urlString];
        [viewController setTitle:NSLocalizedString(@"在线客服", nil)];
        [self.navigationController pushViewController:viewController animated:YES];
    } else {
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

/// 朋友
- (void)doTableSelectRowAtContactModelOfFriends:(FYContactsModel *)model
{
    if (!model) {
        ALTER_INFO_MESSAGE(NSLocalizedString(@"联系人数据错误", nil))
        return;
    }
    
    FYContacts *session = [[IMSessionModule sharedInstance] getSessionWithSessionId:model.chatId];
    if (session == nil) {
        session = [[FYContacts alloc] initWithPropertiesDictionary:[model mj_keyValues]];
    }
    [PersonalSignatureVC pushFromVC:self requestParams:session success:^(id data) {
        
    }];
}


@end

