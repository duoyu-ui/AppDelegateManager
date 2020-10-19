//
//  FYAgentSearchTableViewController.m
//  ProjectCSHB
//
//  Created by fangyuan on 2020/6/28.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "FYAgentSearchTableViewController.h"
//
#import "BecomeAgentViewController.h"
#import "FYAgentRuleViewController.h"
@interface FYAgentSearchTableViewController () <FYAgentSearchHeaderViewDelegate>

@end

@implementation FYAgentSearchTableViewController

#pragma mark - Actions

/// 规则
- (void)pressNavigationBarRightButtonItem:(id)sender
{
    FYAgentRuleViewController *VC = [[FYAgentRuleViewController alloc] init];
    [self.navigationController pushViewController:VC animated:YES];
}

/// 搜索
- (void)didAgentHeaderSearchByKeyword:(NSString *)keyword isSearch:(BOOL)isSeach
{
    // 刷新输入框占位符
    [self setSearchTextPlaceHolder:keyword];
    
    // 搜索userId为空，则默认登录用户userId
    if (!VALIDATE_STRING_EMPTY(keyword)) {
        [self setSearchMemberKey:keyword];
    } else {
        isSeach = YES;
        [self setSearchMemberKey:APPINFORMATION.userInfo.userId];
    }
    
    // 点击搜索按钮操作
    if (isSeach) {
        [self scrollTableToTopAnimated:NO];
        [self.tableViewRefresh.mj_header beginRefreshing];
    }
}


#pragma mark - Life Cycle

- (instancetype)initWithSearchMemberKey:(NSString *)searchMemberKey isInitSearchText:(BOOL)isInitSearchText
{
    self = [super init];
    if (self) {
        self.searchMemberKey = searchMemberKey; // 搜索关键字
        if (isInitSearchText) {
            self.searchTextPlaceHolder = searchMemberKey;
        }
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view addSubview:self.searchHeaderView];
    [self.searchHeaderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navigationBarCustomView.mas_bottom);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo([FYAgentSearchHeaderView headerViewHeight]);
    }];
    
    [self.tableViewRefresh mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.searchHeaderView.mas_bottom);
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    // 隐藏导航栏底线
    [self.navigationBarHairlineImageView setHidden:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.searchHeaderView endEditing];
}


#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.searchHeaderView endEditing];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.searchHeaderView endEditing];
}


#pragma mark - Navigation

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (CFCNavBarType)preferredNavigationBarType
{
    return CFCNavBarTypeCustom;
}

- (UIColor *)prefersNavigationBarColor
{
    return COLOR_AGENT_HEADER_NAVBAR_BACKGROUND;
}

- (UIColor *)prefersNavigationBarTitleColor
{
    return COLOR_AGENT_HEADER_NAVBAR_TITLE;
}

- (NSString *)prefersNavigationBarLeftButtonItemImageNormal
{
    return ICON_NAVIGATION_BAR_BUTTON_WHITE_ARROW;
}

- (NSString *)prefersNavigationBarLeftButtonItemImageSelect
{
    return ICON_NAVIGATION_BAR_BUTTON_WHITE_ARROW;
}

- (CFCNavBarButtonItemType)prefersNavigationBarRightButtonItemType
{
    return CFCNavBarButtonItemTypeCustom;
}

- (NSString *)prefersNavigationBarRightButtonItemTitle
{
    return NSLocalizedString(@"规则", nil);
}

- (UIColor *)prefersNavigationBarRightButtonItemTitleColorNormal
{
    return COLOR_AGENT_HEADER_NAVBAR_BUTTON_TITLE;
}

- (UIColor *)prefersNavigationBarRightButtonItemTitleColorSelect
{
    return COLOR_AGENT_HEADER_NAVBAR_BUTTON_TITLE;
}


#pragma mark - Getter & Setter

- (FYAgentSearchHeaderView *)searchHeaderView
{
    if (!_searchHeaderView) {
        CGRect frame = CGRectMake(0, 0, self.view.frame.size.width, [FYAgentSearchHeaderView headerViewHeight]);
        _searchHeaderView = [[FYAgentSearchHeaderView alloc] initWithFrame:frame searchMemberKey:self.searchMemberKey delegate:self];
    }
    return _searchHeaderView;
}


@end
