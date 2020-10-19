//
//  FYContactAddViewController.m
//  ProjectCSHB
//
//  Created by fangyuan on 2020/5/15.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "FYContactAddViewController.h"
#import "FYAvatarNameContactCell.h"
#import "FYUserCodeButtonView.h"
#import "FYHTTPResponseModel.h"
//
#import "FYSearchViewController.h"
#import "FYSearchBarView.h"
//
#import "FYUserQRCodeViewController.h"
#import "FYScannerQRCodeViewController.h"
#import "FYContactMobileViewController.h"
#import "FYAdddFriendInformationViewController.h"


@interface FYContactAddViewController () <UITableViewDelegate, UITableViewDataSource, FYSearchViewControllerDelegate>
//
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *tableDataSource;
@property (nonatomic, strong) FYUserCodeButtonView *tableSectionHeader;
//
@property (nonatomic, strong) FYSearchViewController *searchViewController;
@property (nonatomic, strong) FYSearchBarView *tableHeaderView;

@end


@implementation FYContactAddViewController

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

/// 我的二维码
- (void)pressUserCodeButtonAction
{
    FYUserQRCodeViewController *VC = [FYUserQRCodeViewController new];
    [self.navigationController pushViewController:VC animated:YES];
}


#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableDataSource = @[
        @{ @"name":NSLocalizedString(@"扫一扫", nil), @"detail":NSLocalizedString(@"扫一扫添加好友", nil), @"image":@"icon_scan", @"accessory":@(YES) },
        @{ @"name":NSLocalizedString(@"手机联系人", nil), @"detail":NSLocalizedString(@"添加通讯录中的朋友", nil), @"image":@"icon_contacts", @"accessory":@(YES) }
    ].mutableCopy;
    
    [self.view addSubview:self.tableView];
}


#pragma mark - UITableViewDelegate & UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.tableDataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return [FYUserCodeButtonView heightOfUserCodeView];
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return self.tableSectionHeader;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FYUserAddCell *cell = [tableView dequeueReusableCellWithIdentifier:[FYUserAddCell reuseIdentifier]];
    NSDictionary *dataOfDict = [self.tableDataSource objectAtIndex:indexPath.row];
    NSString *name = [dataOfDict stringForKey:@"name"];
    NSString *detail = [dataOfDict stringForKey:@"detail"];
    NSString *imageUrl = [dataOfDict stringForKey:@"image"];
    BOOL accessory = [dataOfDict boolForKey:@"accessory"];
    cell.button.hidden = YES;
    cell.imageAvatar.image = [UIImage imageNamed:imageUrl];
    cell.labelName.text = name;
    cell.labelDetail.text = detail;
    cell.arrowImageView.hidden = !accessory;
    [cell isSectionLastRow:(indexPath.row == self.tableDataSource.count-1 ? YES : NO)];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
#if TARGET_IPHONE_SIMULATOR
        ALTER_INFO_MESSAGE(NSLocalizedString(@"模拟器不能使用此功能", nil))
#elif TARGET_OS_IPHONE
        FYScannerQRCodeViewController *VC = [[FYScannerQRCodeViewController alloc] initWithType:FYQRCodeTypeAddFriends];
        [self.navigationController pushViewController:VC animated:YES];
#endif
    } else if (indexPath.row == 1) {
        FYContactMobileViewController *VC = [FYContactMobileViewController new];
        [self.navigationController pushViewController:VC animated:YES];
    }
}


#pragma mark - FYSearchViewControllerDelegate

/// 输入关键字搜索Action
- (void)fySearchResultByKeyword:(NSString *)searchText isSearch:(BOOL)isSeach
{
    if (!isSeach) {
        return;
    }
    
    [self doSearchUserWithTelephoneNumber:searchText click:NO];
}

/// 搜索结果展示 Cell
- (UITableViewCell *)fySearchTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath dataSource:(NSMutableArray *)dataSource cellIdentifier:(NSString *)cellIdentifier
{
    NSDictionary *model = [dataSource objectAtIndex:indexPath.row];
    NSString *nickName = [model valueForKey:@"nick"];
    NSString *avatar = [model valueForKey:@"avatar"];
    
    FYAvatarNameContactCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    [cell updateRedNumber:0];
    [cell.labelName setText:[NSString stringWithFormat:NSLocalizedString(@"昵称:%@", nil),nickName]];
    [cell.imageAvatar sd_setImageWithURL:[NSURL URLWithString:avatar]];
    [cell isSectionLastRow:(indexPath.row == dataSource.count-1 ? YES : NO)];
    
    return cell;
}

/// 搜索结果展示 CellHeight
- (CGFloat)fySearchTableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath dataSource:(NSMutableArray *)dataSource
{
    return 50.0f;
}

/// 点击搜索结果详情
- (void)fySearchTableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath dataSource:(NSMutableArray *)dataSource
{
    if (indexPath.row >= dataSource.count) {
        ALTER_INFO_MESSAGE(NSLocalizedString(@"数据错误", nil))
        return;
    }
    
    NSDictionary *userDcit = [dataSource objectAtIndex:indexPath.row];
    FYAdddFriendInformationViewController *viewController = [FYAdddFriendInformationViewController new];
    viewController.sourceString = NSLocalizedString(@"来自手机号搜索", nil);
    viewController.avatarString = [userDcit valueForKey:@"avatar"];
    viewController.userID = [NSString stringWithFormat:@"%@",[userDcit valueForKey:@"userId"]];
    viewController.nickString = [userDcit valueForKey:@"nick"];
    [self.navigationController pushViewController:viewController animated:YES];
}


#pragma mark - Navigation

- (NSString *)prefersNavigationBarTitleViewTitle
{
    return STR_NAVIGATION_BAR_TITLE_ADD_FRIEND;
}

- (CGFloat)prefersNavigationBarHairlineHeight
{
    return NAVIGATION_BAR_HAIR_LINE_HEIGHT_ZERO;
}


#pragma mark - Getter & Setter

- (UITableView *)tableView
{
    if (!_tableView) {
        CGRect frame = CGRectMake(0.0f, 0.0f, self.view.width, self.view.height);
        UITableView *tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStyleGrouped];
        [tableView setDelegate:self];
        [tableView setDataSource:self];
        [tableView setEstimatedRowHeight:80.0f];
        [tableView setSectionHeaderHeight:FLOAT_MIN];
        [tableView setSectionFooterHeight:FLOAT_MIN];
        [tableView setShowsVerticalScrollIndicator:NO];
        [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [tableView setTableHeaderView:self.tableHeaderView];
        [tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, FLOAT_MIN)]];
        
        // 设置背景
        UIView *backgroundView = [[UIView alloc] init];
        [backgroundView setBackgroundColor:COLOR_TABLEVIEW_BACK_VIEW_BACKGROUND_DEFAULT];
        [tableView setBackgroundView:backgroundView];
        [tableView setBackgroundColor:COLOR_TABLEVIEW_BACK_VIEW_BACKGROUND_DEFAULT];

        //
        [tableView registerClass:[FYUserAddCell class] forCellReuseIdentifier:[FYUserAddCell reuseIdentifier]];
        _tableView = tableView;
    }
    return _tableView;
}

- (FYSearchBarView *)tableHeaderView
{
    if (!_tableHeaderView) {
        WEAKSELF(weakSelf)
        CGRect frame = CGRectMake(0, 0, SCREEN_MIN_LENGTH, [FYSearchBarView heightOfSearchBar]);
        _tableHeaderView = [[FYSearchBarView alloc] initWithFrame:frame searchPlaceholder:NSLocalizedString(@"搜索手机号", nil)];
        [_tableHeaderView setSearchActionBlock:^{
            [weakSelf pressSearchButtonAction];
        }];
    }
    return _tableHeaderView;
}

- (FYUserCodeButtonView *)tableSectionHeader
{
    if (!_tableSectionHeader) {
        WEAKSELF(weakSelf)
        NSString *titleString = [NSString stringWithFormat:NSLocalizedString(@"我的昵称: %@", nil), APPINFORMATION.userInfo.nick];
        CGRect frame = CGRectMake(0, 0, SCREEN_MIN_LENGTH, [FYUserCodeButtonView heightOfUserCodeView]);
        _tableSectionHeader = [[FYUserCodeButtonView alloc] initWithFrame:frame username:titleString];
        [_tableSectionHeader setDoUserCodeActionBlock:^{
            [weakSelf pressUserCodeButtonAction];
        }];
    }
    return _tableSectionHeader;
}

- (FYSearchViewController *)searchViewController
{
    if (!_searchViewController) {
        NSArray<NSString *> *cellClassNames = @[ NSStringFromClass([FYAvatarNameContactCell class]) ];
        _searchViewController = [FYSearchViewController alertSearchController:NSLocalizedString(@"搜索手机号", nil) delegate:self cellClass:cellClassNames];
        _searchViewController.hasSearchButtonCell = YES;
    }
    return _searchViewController;
}

- (NSMutableArray *)tableDataSource
{
    if (!_tableDataSource) {
        _tableDataSource = [NSMutableArray new];
    }
    return _tableDataSource;
}


#pragma mark - Private

- (void)doSearchUserWithTelephoneNumber:(NSString *)telephone click:(BOOL)isClick
{
    WEAKSELF(weakSelf)
    PROGRESS_HUD_SHOW
    [NET_REQUEST_MANAGER requestWithAct:ActRequestSearchUserID parameters:@{ @"mobile":telephone } success:^(id resonse) {
        PROGRESS_HUD_DISMISS
        FYHTTPResponseModel *response = [FYHTTPResponseModel mj_objectWithKeyValues:resonse];
        [weakSelf doSearchResultResponseData:response];
    } failure:^(id error) {
        PROGRESS_HUD_DISMISS
        [weakSelf doSearchResultResponseData:nil];
        if (isClick) {
            [[FunctionManager sharedInstance] handleFailResponse:error];
        }
    }];
}

- (void)doSearchResultResponseData:(FYHTTPResponseModel *)response
{
    FYLog(@"response:%@", response.data);
    
    NSMutableArray *searchResultData = [NSMutableArray new];
    if (response.data.allKeys.count > 0) {
        [searchResultData addObject:response.data];
    }
    [self.searchViewController reloadSearchTableWithDataSource:searchResultData];
}


@end

