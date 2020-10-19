//
//  FYContactGroupViewController.m
//  ProjectCSHB
//
//  Created by fangyuan on 2020/5/15.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "FYContactGroupViewController.h"
#import "FYGroupLabelTableViewCell.h"
#import "FYGroupTableSectionFooter.h"
#import "FYHTTPResponseModel.h"
//
#import "FYSearchViewController.h"
#import "FYSearchBarView.h"


@interface FYContactGroupViewController () <UITableViewDelegate, UITableViewDataSource, FYSearchViewControllerDelegate>

@property (nonatomic, strong) EnterPwdBoxView *pwdBoxView;

@property (nonatomic, strong) FYSearchViewController *searchViewController;
@property (nonatomic, strong) FYGroupTableSectionFooter *tableSectionFooter;
@property (nonatomic, strong) FYSearchBarView *tableHeaderView;

@end

@implementation FYContactGroupViewController


#pragma mark - Actions

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
    [tableView registerClass:[FYGroupLabelTableViewCell class] forCellReuseIdentifier:[FYGroupLabelTableViewCell reuseIdentifier]];
}


#pragma mark - Network

- (Act)getRequestInfoAct
{
    return ActJoinSelfGroupList;
}

- (NSMutableDictionary *)getRequestParamerter
{
    return @{@"size":@(999),
             @"sort": @"id",
             @"isAsc": @(false),
             @"current": @(1),
             @"officeFlag":@(NO)}.mutableCopy;
}

- (NSMutableArray *)loadNetworkDataOrCacheData:(id)responseDataOrCacheData isCacheData:(BOOL)isCacheData
{
    FYLog(NSLocalizedString(@"我的群组 => \n%@", nil), responseDataOrCacheData);
    
    // 请求成功，解析数据
    if (!NET_REQUEST_SUCCESS(responseDataOrCacheData)) {
        self.tableDataRefresh = @[].mutableCopy;
        return self.tableDataRefresh;
    }
    
    // 组装数据
    NSDictionary *data = NET_REQUEST_DATA(responseDataOrCacheData);
    NSArray<NSDictionary *> *arrayOfDicts = [data arrayForKey:@"records"];
    NSMutableArray<MessageItem *> *allItemModels = [MessageItem mj_objectArrayWithKeyValuesArray:arrayOfDicts];
    
    // 我的群组
    NSMutableArray<MessageItem *> *allGroupArray = [NSMutableArray new];
    for (MessageItem *model in allItemModels) {
        [allGroupArray addObject:model];
        if (model.officeFlag == NO) {
            [[IMGroupModule sharedInstance] updateGroupWithGroupId:model];
            FYContacts *tempSession = [[IMSessionModule sharedInstance] getSessionWithUserId:model.groupId];
            tempSession.name = model.chatgName;
            [[IMSessionModule sharedInstance] updateSeesion:tempSession];
        }
    }

    // 配置数据源
    if (0 == self.offset) {
        self.tableDataRefresh = [NSMutableArray array];
        if (allGroupArray && 0 < allGroupArray.count) {
            [self.tableDataRefresh addObjectsFromArray:allGroupArray];
        }
    } else {
        if (allItemModels && 0 < allItemModels.count) {
            [self.tableDataRefresh addObjectsFromArray:allItemModels];
        }
    }
    
    return self.tableDataRefresh;
}

- (void)viewDidLoadAfterLoadNetworkDataOrCacheData
{
    NSString *titleString = [NSString stringWithFormat:NSLocalizedString(@"%ld个群聊", nil), self.tableDataRefresh.count];;
    [self.tableSectionFooter setTitleString:titleString];
}


#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.tableDataRefresh.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FYGroupLabelTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[FYGroupLabelTableViewCell reuseIdentifier]];
    return [self tableCllForRowAtIndexPath:indexPath dataSource:self.tableDataRefresh cell:cell];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [FYGroupLabelTableViewCell height];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return self.tableSectionFooter;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return [FYGroupTableSectionFooter height];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MessageItem *msgItem = [self.tableDataRefresh objectAtIndex:indexPath.row];
    [self doSelectRowAtObjectModel:msgItem];
}


#pragma mark - FYSearchViewControllerDelegate

/// 输入关键字搜索Action
- (void)fySearchResultByKeyword:(NSString *)searchText isSearch:(BOOL)isSeach
{
    if (!isSeach) {
        return;
    }
    
    NSMutableArray *searchResultData = @[].mutableCopy;
    for (MessageItem *tempModel in self.tableDataRefresh) {
        if ([tempModel.chatgName containsString:searchText]) {
            [searchResultData addObject:tempModel];
        }
    }
    [self.searchViewController reloadSearchTableWithDataSource:searchResultData];
}

/// 搜索结果展示 Cell
- (UITableViewCell *)fySearchTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath dataSource:(NSMutableArray *)dataSource cellIdentifier:(NSString *)reusableCellIdentifier
{
    FYGroupLabelTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reusableCellIdentifier];
    return [self tableCllForRowAtIndexPath:indexPath dataSource:dataSource cell:cell];
}

/// 搜索结果展示 CellHeight
- (CGFloat)fySearchTableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath dataSource:(NSMutableArray *)dataSource
{
    return [FYGroupLabelTableViewCell height];
}

/// 点击搜索结果详情
- (void)fySearchTableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath dataSource:(NSMutableArray *)dataSource
{
    MessageItem *msgItem = [dataSource objectAtIndex:indexPath.row];
    [self doSelectRowAtObjectModel:msgItem];
}


#pragma mark - Navigation

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}

- (NSString *)prefersNavigationBarTitleViewTitle
{
    return STR_NAVIGATION_BAR_TITLE_CONTACT_GROUP;
}

- (CGFloat)prefersNavigationBarHairlineHeight
{
    return NAVIGATION_BAR_HAIR_LINE_HEIGHT_ZERO;
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

- (FYGroupTableSectionFooter *)tableSectionFooter
{
    if (!_tableSectionFooter) {
        NSString *title = [NSString stringWithFormat:NSLocalizedString(@"%ld个群聊", nil), self.tableDataRefresh.count];
        _tableSectionFooter = [[FYGroupTableSectionFooter alloc] initWithFrame:CGRectMake(0, 0, self.tableViewRefresh.frame.size.width, [FYGroupTableSectionFooter height]) title:title];
    }
    return _tableSectionFooter;
}

- (FYSearchViewController *)searchViewController
{
    if (!_searchViewController) {
        NSArray<NSString *> *cellClassNames = @[ NSStringFromClass([FYGroupLabelTableViewCell class]) ];
        _searchViewController = [FYSearchViewController alertSearchController:NSLocalizedString(@"请输入群名称", nil) delegate:self cellClass:cellClassNames];
    }
    return _searchViewController;
}


#pragma mark - Private

- (UITableViewCell *)tableCllForRowAtIndexPath:(NSIndexPath *)indexPath dataSource:(NSMutableArray *)dataSource cell:(FYGroupLabelTableViewCell *)cell
{
    MessageItem *model = [dataSource objectAtIndex:indexPath.row];
    [cell isSectionLastRow:(indexPath.row == dataSource.count-1 ? YES : NO)];
    
    cell.labelName.text = model.chatgName;
    if (model.officeFlag == YES) {
        [cell updateLabel:NSLocalizedString(@"官方", nil)];
    } else {
        [cell updateLabel:NSLocalizedString(@"自建", nil)];
    }
    [cell updateRedNumber:0];
    
    // 群组头像
    if (VALIDATE_STRING_HTTP_URL(model.img)) {
        __block UIActivityIndicatorView *activityIndicator = nil;
        UIImage *placeholderImage = [UIImage imageNamed:ICON_MESSAGE_USER_AVATAR_PLACEHOLDER];
        [cell.imageAvatar sd_setImageWithURL:[NSURL URLWithString:model.img] placeholderImage:placeholderImage options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                if (!activityIndicator) {
                    [cell.contentView addSubview:activityIndicator = [UIActivityIndicatorView.alloc initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite]];
                    [activityIndicator setColor:COLOR_ACTIVITY_INDICATOR_BACKGROUND];
                    [activityIndicator setCenter:cell.imageAvatar.center];
                    [activityIndicator startAnimating];
                    [activityIndicator mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.centerX.equalTo(cell.imageAvatar.mas_centerX);
                        make.centerY.equalTo(cell.imageAvatar.mas_centerY);
                    }];
                }
            }];
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            [activityIndicator removeFromSuperview];
            activityIndicator = nil;
        }];
    } else if ([UIImage imageNamed:model.img]) {
        [cell.imageAvatar setImage:[UIImage imageNamed:model.img]];
    } else {
        [cell.imageAvatar setImage:[UIImage imageNamed:ICON_MESSAGE_USER_AVATAR_PLACEHOLDER]];
    }
    
    return cell;
}

- (void)doSelectRowAtObjectModel:(MessageItem *)msgItem
{
    if (msgItem.tryPlayFlag != YES) {
        if ([[AppModel shareInstance] isGuest]) {
            return;
        }
    }
    
    if (msgItem.officeFlag == YES) {
        [self doTryToJoinGroupOfficeYes:msgItem];
    } else {
        [self doTryToJoinGroupOfficeNo:msgItem];
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

