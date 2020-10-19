//
//  FYContactSelectViewController.m
//  ProjectCSHB
//
//  Created by Tom on 2020/5/28.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "FYContactSelectViewController.h"
#import "FYAvatarNameContactCell.h"
//
#import "FYSearchViewController.h"
#import "FYSearchBarView.h"


@interface FYContactSelectViewController () <UITableViewDelegate, UITableViewDataSource, FYSearchViewControllerDelegate>
//
@property (nonatomic, strong) FYSearchViewController *searchViewController;
@property (nonatomic, strong) FYSearchBarView *tableHeaderView;

@end


@implementation FYContactSelectViewController

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
    [tableView registerClass:[FYUserAddCell class] forCellReuseIdentifier:[FYUserAddCell reuseIdentifier]];
}


#pragma mark - Network

- (Act)getRequestInfoAct
{
    return OnlineCustomerService;
}

- (NSMutableDictionary *)getRequestParamerter
{
    return @{}.mutableCopy;
}

- (NSMutableArray *)loadNetworkDataOrCacheData:(id)responseDataOrCacheData isCacheData:(BOOL)isCacheData
{
    FYLog(NSLocalizedString(@"选择联系人 => \n%@", nil), responseDataOrCacheData);
    
    // 请求成功，解析数据
    if (!NET_REQUEST_SUCCESS(responseDataOrCacheData)) {
        self.tableDataRefresh = @[].mutableCopy;
        return self.tableDataRefresh;
    }
    
    // 组装数据
    NSDictionary *data = NET_REQUEST_DATA(responseDataOrCacheData);
    
    // 邀请我的好友(superior)
    NSArray *tempsuperior = [data valueForKey:@"superior"];
    NSArray<FYContactMainModel *> *superiorList = [FYContactMainModel mj_objectArrayWithKeyValuesArray:tempsuperior];
    
    // 我邀请的好友(subordinate)
    NSArray *tempsubordinate = [data valueForKey:@"subordinate"];
    NSArray<FYContactMainModel *> *subordinateList=[FYContactMainModel mj_objectArrayWithKeyValuesArray:tempsubordinate];
    
    // 普通朋友(userFriends)
    NSArray *tempFriend = [data valueForKey:@"userFriends"];
    NSArray<FYContactMainModel *> *userFriendsList = [FYContactMainModel mj_objectArrayWithKeyValuesArray:tempFriend];
    
    [self setTableDataRefresh:@[].mutableCopy];
    [self.tableDataRefresh addObjectsFromArray:superiorList];
    [self.tableDataRefresh addObjectsFromArray:subordinateList];
    [self.tableDataRefresh addObjectsFromArray:userFriendsList];
    
    return self.tableDataRefresh;
}


#pragma mark - UITableViewDelegate & UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.tableDataRefresh.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row >= self.tableDataRefresh.count) {
        ALTER_INFO_MESSAGE(NSLocalizedString(@"数据错误", nil))
        return nil;
    }
    
    FYUserAddCell *cell=[tableView dequeueReusableCellWithIdentifier:[FYUserAddCell reuseIdentifier]];
    FYContactMainModel *model = [self.tableDataRefresh objectAtIndex:indexPath.row];
    
    cell.button.hidden = YES;
    cell.labelName.text = APP_USER_REMARK_NAME(model.userId);
    cell.labelDetail.text = [NSString stringWithFormat:@"ID:%@", model.userId];
    [cell isSectionLastRow:(indexPath.row == self.tableDataRefresh.count-1 ? YES: NO)];
    [cell.imageAvatar sd_setImageWithURL:[NSURL URLWithString:model.avatar]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row >= self.tableDataRefresh.count) {
        ALTER_INFO_MESSAGE(NSLocalizedString(@"数据错误", nil))
        return;
    }
    
    FYContactMainModel *model=[self.tableDataRefresh objectAtIndex:indexPath.row];
    if (self.selectViewResult != nil) {
        self.selectViewResult(model);
    }
}


#pragma mark - FYSearchViewControllerDelegate

/// 输入关键字搜索Action
- (void)fySearchResultByKeyword:(NSString *)searchText isSearch:(BOOL)isSeach
{
    if (!isSeach) {
        return;
    }

    NSMutableArray *searchResultData = @[].mutableCopy;
    for (FYContactMainModel *model in self.tableDataRefresh) {
        if ([model.nick containsString:searchText]) {
            [searchResultData addObject:model];
        }
    }
    [self.searchViewController reloadSearchTableWithDataSource:searchResultData];
}

/// 搜索结果展示 Cell
- (UITableViewCell *)fySearchTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath dataSource:(NSMutableArray *)dataSource cellIdentifier:(NSString *)cellIdentifier
{
    if (indexPath.row >= dataSource.count) {
        ALTER_INFO_MESSAGE(NSLocalizedString(@"数据错误", nil))
        return nil;
    }
    
    FYUserAddCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    FYContactMainModel *model = [dataSource objectAtIndex:indexPath.row];
   
    cell.button.hidden = YES;
    cell.labelName.text = APP_USER_REMARK_NAME(model.userId);
    cell.labelDetail.text = [NSString stringWithFormat:@"ID:%@",model.userId];
    [cell isSectionLastRow:(indexPath.row == dataSource.count-1 ? YES: NO)];
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
    if (indexPath.row >= dataSource.count) {
        ALTER_INFO_MESSAGE(NSLocalizedString(@"数据错误", nil))
        return;
    }
    
    FYContactMainModel *model = [dataSource objectAtIndex:indexPath.row];
    if (self.selectViewResult != nil) {
        self.selectViewResult(model);
    }
}


#pragma mark - Navigation

- (NSString *)prefersNavigationBarTitleViewTitle
{
    return NSLocalizedString(@"通讯录联系人", nil);
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

- (FYSearchViewController *)searchViewController
{
    if (!_searchViewController) {
        NSArray<NSString *> *cellClassNames = @[ NSStringFromClass([FYUserAddCell class]) ];
        _searchViewController = [FYSearchViewController alertSearchController:NSLocalizedString(@"请输入用户昵称", nil) delegate:self cellClass:cellClassNames];
    }
    return _searchViewController;
}


#pragma mark - Private




@end
