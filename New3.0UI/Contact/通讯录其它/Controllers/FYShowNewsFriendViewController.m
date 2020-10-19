//
//  FYShowNewsFriendViewController.m
//  ProjectCSHB
//
//  Created by Tom on 2020/5/20.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "FYShowNewsFriendViewController.h"
#import "FYMobileContactInformation.h"
#import "FYAvatarNameContactCell.h"
#import "FYHTTPResponseModel.h"
//
#import "FYSearchViewController.h"
#import "FYSearchBarView.h"
//
#import "FYContactAddViewController.h"


@interface FYShowNewsFriendViewController () <UITableViewDelegate, UITableViewDataSource, FYSearchViewControllerDelegate>
//
@property (nonatomic, strong) FYSearchViewController *searchViewController;
@property (nonatomic, strong) FYSearchBarView *tableHeaderView;
//
@property (nonatomic, strong) NSMutableArray *expiredDatas;

@end

@implementation FYShowNewsFriendViewController

#pragma mark - Actions

/// 添加朋友
- (void)pressNavigationBarRightButtonItem:(id)sender
{
    FYContactAddViewController *viewController = [[FYContactAddViewController alloc] init];
    [self.navigationController pushViewController:viewController animated:YES];
}

/// 搜索
- (void)pressSearchButtonAction
{
    WEAKSELF(weakSelf)
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self.searchViewController setCloseActionBlock:^(UIViewController * _Nonnull fromViewController) {
        [weakSelf.navigationController setNavigationBarHidden:NO animated:YES];
        [fromViewController dismissViewControllerAnimated:NO completion:nil];
    }];
    [self presentViewController:self.searchViewController animated:YES completion:^{}];
}


#pragma mark - Life Cycle

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.hasRefreshFooter = NO;
        self.isAutoLayoutSafeAreaBottom = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
}

- (void)tableViewRefreshSetting:(UITableView *)tableView
{
    [tableView setTableHeaderView:self.tableHeaderView];
    [tableView registerClass:[FYUserAddCell class] forCellReuseIdentifier:@"FYUserAddCell"];
    [tableView registerClass:[FYContactSectionHeaderView class] forHeaderFooterViewReuseIdentifier:@"FYContactSectionHeaderView"];
}


#pragma mark - Network

- (Act)getRequestInfoAct
{
    return ActRequestContactsInviteFriends;
}

- (NSMutableDictionary *)getRequestParamerter
{
    return @{}.mutableCopy;
}

- (NSMutableArray *)loadNetworkDataOrCacheData:(id)responseDataOrCacheData isCacheData:(BOOL)isCacheData
{
    FYLog(NSLocalizedString(@"添加朋友 => \n%@", nil), responseDataOrCacheData);
    
    // 请求成功，解析数据
    if (!NET_REQUEST_SUCCESS(responseDataOrCacheData)) {
        self.tableDataRefresh = @[].mutableCopy;
        return self.tableDataRefresh;
    }
    
    // 组装数据
    self.tableDataRefresh = [NSMutableArray array];
    FYHTTPResponseModel *response = [FYHTTPResponseModel mj_objectWithKeyValues:responseDataOrCacheData];
    if (response.data) {
        NSArray *unExpiredData = [response.data valueForKey:@"unExpired"];
        NSArray *tempUnExpiredData = [FYInviteFriendModel mj_objectArrayWithKeyValuesArray:unExpiredData];
        if (self.tableDataRefresh.count > 0) {
            [self.tableDataRefresh removeAllObjects];
        }
        [self.tableDataRefresh addObjectsFromArray:tempUnExpiredData];
        
        NSArray *expiredData = [response.data valueForKey:@"expired"];
        NSArray *tempExpiredData = [FYInviteFriendModel mj_objectArrayWithKeyValuesArray:expiredData];
        if (self.expiredDatas.count > 0) {
            [self.expiredDatas removeAllObjects];
        }
        [self.expiredDatas addObjectsFromArray:tempExpiredData];
        [self.tableViewRefresh reloadData];
        /*
         {
         "avatar": "dsasa",
         "createTime": "2020-05-25 10:41:25",
         "id": 1,
         "inviteUserId": 6192,
         "message": "撒大大",
         "nick": "哇大师",
         "opFlag": 0,
         "updateTime": "2020-05-25 10:41:25",
         "userId": 6169
         }
         */
    }
    
    return self.tableDataRefresh;
}


#pragma mark - UITableViewDelegate & UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return self.tableDataRefresh.count;
    } else if (section == 1){
        return self.expiredDatas.count;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return self.tableDataRefresh.count > 0 ? 20 : 0.0;
    } else if (section == 1){
        return self.expiredDatas.count > 0 ? 20 : 0.0;
    }
    return 0.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    FYContactSectionHeaderView *header=[tableView dequeueReusableHeaderFooterViewWithIdentifier:@"FYContactSectionHeaderView"];
    NSString *htitle=@"";
    if (section == 0){
        if (self.tableDataRefresh.count > 0) {
            htitle=NSLocalizedString(@"最近3天", nil);
        }
    } else if (section == 1){
        if (self.expiredDatas.count > 0) {
            htitle=NSLocalizedString(@"3天前", nil);
        }
    }
    header.labelName.text=htitle;
    return header;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FYUserAddCell *cell=[tableView dequeueReusableCellWithIdentifier:@"FYUserAddCell"];
    FYInviteFriendModel *model;
    NSString *buttonString=NSLocalizedString(@"已过期", nil);
    if (indexPath.section == 0) {
        model = [self.tableDataRefresh objectAtIndex:indexPath.row];
        [cell isSectionLastRow:(indexPath.row == self.tableDataRefresh.count-1 ? YES : NO)];
    }else{
        model = [self.expiredDatas objectAtIndex:indexPath.row];
        if (model.opFlag == 1) {
            buttonString = NSLocalizedString(@"已同意", nil);
        }
        [cell isSectionLastRow:(indexPath.row == self.expiredDatas.count-1 ? YES : NO)];
    }
    
    if (model.opFlag == 1) {
        buttonString = NSLocalizedString(@"已同意", nil);
    }else{
        buttonString = NSLocalizedString(@"同意", nil);
    }
    [cell buttonTitleWith:buttonString];
    if ([buttonString isEqualToString:NSLocalizedString(@"同意", nil)]) {
        cell.button.enabled = YES;
    }else{
        cell.button.enabled = NO;
    }
    
    WEAKSELF(weakSelf)
    [cell setButtonClickAction:^(UIButton * _Nonnull btn) {
        [weakSelf toAcceptFriend:model];
    }];
    cell.labelName.text=model.nick;
    cell.labelDetail.text = model.message;
    [cell.imageAvatar sd_setImageWithURL:[NSURL URLWithString:model.avatar]];
    return cell;
}


#pragma mark - FYSearchViewControllerDelegate

/// 输入关键字搜索Action
- (void)fySearchResultByKeyword:(NSString *)searchText isSearch:(BOOL)isSeach
{
    if (!isSeach) {
        return;
    }
    
    NSMutableArray *searchResultData = @[].mutableCopy;
    
    for (FYInviteFriendModel *model in self.tableDataRefresh) {
        if ([model.nick containsString:searchText]) {
            [searchResultData addObject:model];
        }
    }
    
    for (FYInviteFriendModel *model in self.expiredDatas) {
        if ([model.nick containsString:searchText]) {
            [searchResultData addObject:model];
        }
    }

    [self.searchViewController reloadSearchTableWithDataSource:searchResultData];
}

/// 搜索结果展示 Cell
- (UITableViewCell *)fySearchTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath dataSource:(NSMutableArray *)dataSource cellIdentifier:(NSString *)cellIdentifier
{
    FYUserAddCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    FYInviteFriendModel *model = [dataSource objectAtIndex:indexPath.row];
    [cell isSectionLastRow:(indexPath.row == dataSource.count-1 ? YES : NO)];
    
    NSString *buttonString = NSLocalizedString(@"已过期", nil);
    if (model.opFlag == 1) {
        buttonString = NSLocalizedString(@"已同意", nil);
    } else {
        buttonString = NSLocalizedString(@"同意", nil);
    }
    [cell buttonTitleWith:buttonString];
    
    if ([buttonString isEqualToString:NSLocalizedString(@"同意", nil)]) {
        cell.button.enabled = YES;
    } else {
        cell.button.enabled = NO;
    }
    
    WEAKSELF(weakSelf)
    [cell setButtonClickAction:^(UIButton * _Nonnull btn) {
        [weakSelf toAcceptFriend:model];
        weakSelf.searchViewController.closeActionBlock(weakSelf.searchViewController);
    }];
    
    cell.labelName.text=model.nick;
    cell.labelDetail.text = model.message;
    [cell.imageAvatar sd_setImageWithURL:[NSURL URLWithString:model.avatar]];
    
    return cell;
}

/// 搜索结果展示 CellHeight
- (CGFloat)fySearchTableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath dataSource:(NSMutableArray *)dataSource
{
    return 60.0f;
}

/// 点击搜索结果详情
- (void)fySearchTableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath dataSource:(NSMutableArray *)dataSource
{

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

- (CFCNavBarButtonItemType)prefersNavigationBarRightButtonItemType
{
    return CFCNavBarButtonItemTypeCustom;
}

- (NSString *)prefersNavigationBarRightButtonItemTitle
{
    return NSLocalizedString(@"添加朋友", nil);
}


#pragma mark - Getter & Setter

- (FYSearchBarView *)tableHeaderView
{
    if (!_tableHeaderView) {
        WEAKSELF(weakSelf)
        CGRect frame = CGRectMake(0, 0, SCREEN_MIN_LENGTH, [FYSearchBarView heightOfSearchBar]);
        _tableHeaderView = [[FYSearchBarView alloc] initWithFrame:frame searchPlaceholder:NSLocalizedString(@"搜索", nil)];
        [_tableHeaderView setSearchActionBlock:^{
            [weakSelf pressSearchButtonAction];
        }];
    }
    return _tableHeaderView;
}

- (FYSearchViewController *)searchViewController
{
    if (!_searchViewController) {
        NSArray<NSString *> *cellClassNames = @[ NSStringFromClass([FYUserAddCell class]) ];
        _searchViewController = [FYSearchViewController alertSearchController:NSLocalizedString(@"请输入用户昵称", nil) delegate:self cellClass:cellClassNames];
    }
    return _searchViewController;
}

- (NSMutableArray *)expiredDatas
{
    if (!_expiredDatas) {
        _expiredDatas=[NSMutableArray new];
    }
    return _expiredDatas;
}


#pragma mark - Private

- (void)toAcceptFriend:(FYInviteFriendModel *)model
{
    WEAKSELF(weakSelf)
    
    // 此处代码不合规范
    /*
     id:邀请记录id
     opFlag :标识 0 发起邀请，1，同意邀请
     */
    NSDictionary *senderDict=@{@"id":model.ID,
                               @"opFlag":@"1"};
    RequestInfo *info=[[RequestInfo alloc] initWithType:RequestType_post];
    info.act = ActRequestInviteAcceptFriend;
    NSString *urlString=@"social/skUserInviteFriends/updateInvite";
    info.url = [NSString stringWithFormat:@"%@%@",[AppModel shareInstance].serverUrl,urlString];
    
    PROGRESS_HUD_SHOW
    [NET_REQUEST_MANAGER requestWithData:senderDict requestInfo:info success:^(id object) {
        PROGRESS_HUD_DISMISS
        
        [[AppModel shareInstance] updateTabBarIndex:TABBAR_INDEX_CONTACTS];
        
        NSDictionary *senderDict=@{@"userId":model.userId,
                                   @"avatar":model.avatar,
                                   @"nick":model.nick,
                                   @"opFlag":@"1",
                                   @"message":model.message,
                                   @"remarks":@""};
        [self invitedFriendAction:senderDict];
        
        [weakSelf.navigationController popToRootViewControllerAnimated:YES];
        
        // 添加好友成功，刷新通讯录联系人
        [[IMContactsModule sharedInstance] handleUpdateAllContactEntitys:^(BOOL success) {
            [NOTIF_CENTER postNotificationName:kNotificationAddOrDeleteFriend object:nil];
        }];
        
    } fail:^(id object) {
        PROGRESS_HUD_DISMISS
        [[FunctionManager sharedInstance] handleFailResponse:object];
    }];
}

- (void)invitedFriendAction:(NSDictionary *)friendInformation
{
    NSString *jsonString = [friendInformation JSONString];
    NSDictionary *parameters = @{
                                 @"command":@"49",
                                 @"code":@"10042",
                                 @"data":jsonString
                                 };
    NSLog(@"invitedFriendAction IM:%@", parameters);
    [[FYIMMessageManager shareInstance] sendMessageServer:parameters];
}


@end
