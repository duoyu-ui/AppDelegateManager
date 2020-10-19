//
//  FYRechargeMainViewController.m
//  ProjectCSHB
//
//  Created by fangyuan on 2020/5/17.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "FYRechargeMainViewController.h"
#import "FYRechargePayModeViewController.h"
#import "FYPayModeScrollTab.h"
#import "FYPayModeHeaderView.h"
#import "FYPayModel.h"
#import "ZJScrollPageView.h"
//
#import "FYBillingRecordViewController.h"

CGFloat const SEGMENT_VIEW_HEIGHT_FOR_RECHARGE_MAIN = 0.0f; // 菜单（隐藏）
CGFloat const TABLEVIEW_HEADER_HEIGHT_FOR_RECHARGE_USERINFO = 60.0; // 头部
CGFloat const TABLEVIEW_HEADER_HEIGHT_FOR_RECHARGE_SPLITVIEW = 3.3; // 空白
CGFloat const TABLEVIEW_HEADER_HEIGHT_FOR_RECHARGE_SEGMENT = 60.0f; // 滚动菜单

// Cell Identifier
static NSString * const CELL_IDENTIFIER_RECHARGE_MAIN_TABLEVIEW_PAYMODE = @"FFYRechargeMainViewControllerPayModelCellIdentifier";

@interface FYRechargeCustomTableView : UITableView
@end
@implementation FYRechargeCustomTableView
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    // 返回YES同时识别多个手势
    return [gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]] && [otherGestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]];
}
@end

@interface FYRechargeMainViewController () <ZJScrollPageViewDelegate, FYScrollPageViewControllerDelegate, UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource>

@property (assign, nonatomic) CGFloat segmentViewHeight;
@property (assign, nonatomic) CGFloat tableViewHeaderHeight;

@property (strong, nonatomic) ZJContentView *contentView;
@property (strong, nonatomic) ZJScrollSegmentView *segmentView;
@property (strong, nonatomic) FYRechargeCustomTableView *tableView;
@property (strong, nonatomic) UIScrollView *childScrollView;
@property (strong, nonatomic) FYPayModeHeaderView *tableHeaderView;

@property (strong, nonatomic) NSMutableArray<NSString *> *tabTitles;
@property (strong, nonatomic) NSMutableArray<NSNumber *> *tabTitleCodes;
@property (strong, nonatomic) NSMutableArray<FYPayModel *> *tabPayModels;

@end

@implementation FYRechargeMainViewController

#pragma mark - Actions

- (void)pressNavigationBarLeftButtonItem:(id)sender
{
    if (self.isPush) {
        return [super pressNavigationBarLeftButtonItem:sender];
    }
    return [self doPressCustomerServiceButtonAction:sender];
}

- (void)pressNavigationBarRightButtonItem:(id)sender
{
    if (self.isPush) {
        return [self doPressCustomerServiceButtonAction:sender];
    }
    
    // 账单明细
    FYBillingRecordViewController *viewController = [[FYBillingRecordViewController alloc] init];
    [viewController setSelectClassId:@"recharge"];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)doPressCustomerServiceButtonAction:(id)sender
{
    NSString *urlString = [AppModel shareInstance].commonInfo[@"pop"];
    FYWebViewController *viewController = [[FYWebViewController alloc] initWithUrl:urlString];
    [viewController setTitle:NSLocalizedString(@"在线客服", nil)];
    [self.navigationController pushViewController:viewController animated:YES];
}


#pragma mark - Life Cycle

- (instancetype)init
{
    self = [super init];
    if (self) {
        _isPush = NO;
        _segmentViewHeight = SEGMENT_VIEW_HEIGHT_FOR_RECHARGE_MAIN;
        _tableViewHeaderHeight = TABLEVIEW_HEADER_HEIGHT_FOR_RECHARGE_USERINFO + TABLEVIEW_HEADER_HEIGHT_FOR_RECHARGE_SPLITVIEW + TABLEVIEW_HEADER_HEIGHT_FOR_RECHARGE_SEGMENT;
    }
    return self;
}

- (instancetype)initWithIsPush:(BOOL)isPush
{
    self = [self init];
    if (self) {
        _isPush = isPush;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setAutomaticallyAdjustsScrollViewInsets:NO]; // 必须代码

    [self viewDidAddTableView]; // 创建表格
}

- (void)viewDidAddTableView
{
    // 获取充值通道数据
    WEAKSELF(weakSelf);
    [self loadRequestDataRechargeChannelThen:^(NSMutableArray<FYPayModel *> *itemPayModels) {
        __block NSMutableArray<NSString *> *tabTitles = [[NSMutableArray<NSString *> alloc] init];
        __block NSMutableArray<NSNumber *> *tabTitleCodes = [[NSMutableArray<NSNumber *> alloc] init];
        [itemPayModels enumerateObjectsUsingBlock:^(FYPayModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [tabTitles addObj:obj.title];
            [tabTitleCodes addObj:obj.type];
        }];
        [weakSelf setTabTitles:tabTitles];
        [weakSelf setTabTitleCodes:tabTitleCodes];
        [weakSelf setTabPayModels:itemPayModels];
        //
        if (!tabTitles || tabTitles.count < 2) {
            weakSelf.tableViewHeaderHeight -= TABLEVIEW_HEADER_HEIGHT_FOR_RECHARGE_SEGMENT;
        }
        //
        [weakSelf.view addSubview:weakSelf.tableView];
        //
        CFCRefreshHeader *refreshHeader = [CFCRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
        [refreshHeader setTitle:CFCRefreshAutoHeaderIdleText forState:MJRefreshStateIdle];
        [refreshHeader setTitle:CFCRefreshAutoHeaderPullingText forState:MJRefreshStatePulling];
        [refreshHeader setTitle:CFCRefreshAutoHeaderRefreshingText forState:MJRefreshStateRefreshing];
        [refreshHeader.stateLabel setTextColor:COLOR_HEXSTRING(CFCRefreshAutoHeaderColor)];
        [refreshHeader.stateLabel setFont:[UIFont systemFontOfSize:CFC_AUTOSIZING_FONT(CFCRefreshAutoFooterFontSize)]];
        [refreshHeader setBackgroundColor:COLOR_TABLEVIEW_BACK_VIEW_BACKGROUND_DEFAULT];
        [weakSelf.tableView setMj_header:refreshHeader];
    }];
}

- (BOOL)shouldAutomaticallyForwardAppearanceMethods
{
    return NO;
}


#pragma mark - Network

- (void)loadData
{
    if (self.delegate_paymode && [self.delegate_paymode respondsToSelector:@selector(doAnyThingForPayModeViewController:)]) {
        [self.delegate_paymode doAnyThingForPayModeViewController:FYRechargeMainProtocolFuncTypeRefreshPayModeData];
    }
    
    if (self.delegate_header && [self.delegate_header respondsToSelector:@selector(doAnyThingForPayModeHeaderView:)]) {
        [self.delegate_header doAnyThingForPayModeHeaderView:FYRechargeMainProtocolFuncTypeRefreshHeaderData];
    }
}

- (void)loadRequestDataRechargeChannelThen:(void (^)(NSMutableArray<FYPayModel *> *itemPayModels))then
{
    PROGRESS_HUD_SHOW
    [NET_REQUEST_MANAGER requestRechargePayModeChannel:@"" success:^(id response) {
        PROGRESS_HUD_DISMISS
        FYLog(NSLocalizedString(@"充值通道数据 => \n%@", nil), response);
        if (!NET_REQUEST_SUCCESS(response)) {
           !then ?: then(nil);
        } else {
            NSArray *data = NET_REQUEST_DATA(response);
            NSMutableArray<FYPayModel *> *itemModels = [NSMutableArray array];
            [data enumerateObjectsUsingBlock:^(NSDictionary *  _Nonnull dict, NSUInteger idx, BOOL * _Nonnull stop) {
                FYPayModel *model = [FYPayModel mj_objectWithKeyValues:dict];
                [itemModels addObj:model];
            }];
            itemModels = [FYPayModel buildingDataModles:itemModels];
            !then ?: then(itemModels);
        }
    } failure:^(id error) {
        PROGRESS_HUD_DISMISS
        ALTER_HTTP_ERROR_MESSAGE(error)
        FYLog(NSLocalizedString(@"获取充值通道异常 => \n%@", nil), error);
        !then ?: then(nil);
    }];
}

#pragma mark - ZJScrollPageViewDelegate

- (NSInteger)numberOfChildViewControllers
{
    return self.tabTitles.count;
}

- (UIViewController<ZJScrollPageViewChildVcDelegate> *)childViewController:(UIViewController<ZJScrollPageViewChildVcDelegate> *)reuseViewController forIndex:(NSInteger)index
{
    UIViewController<ZJScrollPageViewChildVcDelegate> *childViewController = reuseViewController;
    
    if (!childViewController) {
        NSNumber *tabTitleCode = self.tabTitleCodes[index];
        childViewController = [[FYRechargePayModeViewController alloc] initWithTabTitleCode:tabTitleCode.stringValue];
        if ([childViewController isKindOfClass:[FYScrollPageViewController class]]) {
            FYScrollPageViewController *viewController = (FYScrollPageViewController *)childViewController;
            [viewController setDelegate:self];
            [viewController resetSubScrollViewSize:CGSizeMake(self.view.bounds.size.width, self.view.bounds.size.height-self.tableViewHeaderHeight)];
        } else {
            NSString *message = [NSString stringWithFormat:NSLocalizedString(@"[%@]基类必须是[FYScrollPageViewController]，请进行修改。", nil), self.tabTitles[index]];
            NSAssert(NO, message);
        }
    }
    
    FYRechargePayModeViewController<FYRechargeMainViewControllerProtocol> *viewController = (FYRechargePayModeViewController<FYRechargeMainViewControllerProtocol> *)childViewController;
    self.delegate_paymode = viewController;
    
    return childViewController;
}

- (void)scrollPageController:(UIViewController *)scrollPageController childViewControllDidAppear:(UIViewController *)childViewController forIndex:(NSInteger)index
{
    [self.tableHeaderView setSelectedIndex:index animated:YES];
}


#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // 此处 scrollView 是 FYGamesCustomTableView
    if (self.childScrollView && self.childScrollView.contentOffset.y > 0) {
        self.tableView.contentOffset = CGPointMake(0.0f, self.segmentViewHeight);
    }
    CGFloat offsetY = scrollView.contentOffset.y;
    if(offsetY < self.segmentViewHeight) {
        [[NSNotificationCenter defaultCenter] postNotificationName:FYScrollPageTableViewDidLeaveFromTopNotification object:nil];
    } else {
        self.tableView.contentOffset = CGPointMake(0.0f, self.segmentViewHeight);
    }
}


#pragma mark - FYScrollPageViewControllerDelegate

- (void)scrollViewIsScrolling:(UIScrollView *)scrollView
{
    // 此处 scrollView 是 tableViewMenu、tableViewContent
    _childScrollView = scrollView;
    if (self.tableView.contentOffset.y < self.segmentViewHeight) {
        scrollView.contentOffset = CGPointZero;
        scrollView.showsVerticalScrollIndicator = NO;
    } else {
        self.tableView.contentOffset = CGPointMake(0.0f, self.segmentViewHeight);
        scrollView.showsVerticalScrollIndicator = YES;
    }
}

- (void)doAnyThingForSuperViewController:(FYScrollPageForSuperViewType)type
{
    if (FYScrollPageForSuperViewTypeTableEndRefresh == type) {
        [self.tableView.mj_header endRefreshing];
    }
}


#pragma mark - UITableViewDelegate, UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFIER_RECHARGE_MAIN_TABLEVIEW_PAYMODE];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELL_IDENTIFIER_RECHARGE_MAIN_TABLEVIEW_PAYMODE];
    }
    [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [cell.contentView addSubview:self.contentView];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return self.tableHeaderView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return self.tableViewHeaderHeight;
}


#pragma mark - Navigation

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}

- (NSString *)prefersNavigationBarTitleViewTitle
{
    return STR_NAVIGATION_BAR_TITLE_RECHARGE;
}

- (CFCNavBarButtonItemType)prefersNavigationBarRightButtonItemType
{
    return CFCNavBarButtonItemTypeCustom;
}

- (CFCNavBarButtonItemType)prefersNavigationBarLeftButtonItemType
{
    if (self.isPush) {
        return [super prefersNavigationBarLeftButtonItemType];
    }
    return CFCNavBarButtonItemTypeCustom;
}

- (NSString *)prefersNavigationBarLeftButtonItemImageNormal
{
    if (self.isPush) {
        return [super prefersNavigationBarLeftButtonItemImageNormal];
    }
    return ICON_NAV_BAR_BUTTON_CUSTOMER_SERVICE;
}

- (NSString *)prefersNavigationBarRightButtonItemTitle
{
    if (self.isPush) {
        return [super prefersNavigationBarRightButtonItemTitle];
    }
    return STR_NAV_BUTTON_TITLE_RECHARGE_RECORD;
}

- (NSString *)prefersNavigationBarRightButtonItemImageNormal
{
    if (self.isPush) {
        return ICON_NAV_BAR_BUTTON_CUSTOMER_SERVICE;
    }
    return [super prefersNavigationBarRightButtonItemImageNormal];
}


#pragma mark - Getter & Setter

- (FYRechargeCustomTableView *)tableView
{
    if (!_tableView) {
        CGRect frame = CGRectMake(0.0f, 0.0f, self.view.bounds.size.width, self.view.bounds.size.height);
        FYRechargeCustomTableView *tableView = [[FYRechargeCustomTableView alloc] initWithFrame:frame style:UITableViewStylePlain];
        tableView.tableHeaderView = self.segmentView;
        tableView.tableFooterView = [UIView new];
        // 设置 tableView 的 sectionHeadHeight
        tableView.sectionHeaderHeight = self.tableViewHeaderHeight;
        tableView.sectionFooterHeight = FLOAT_MIN;
        // 设置 tableView 的 Cell 行高为 contentView 的高度
        tableView.rowHeight = self.contentView.bounds.size.height;
        // 设置 tableView 的代理与数据源
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.showsVerticalScrollIndicator = NO;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.decelerationRate = UIScrollViewDecelerationRateFast;
        
        // 设置背景
        UIView *backgroundView = [[UIView alloc] init];
        [backgroundView setBackgroundColor:COLOR_TABLEVIEW_BACK_VIEW_BACKGROUND_DEFAULT];
        [tableView setBackgroundView:backgroundView];
        [tableView setBackgroundColor:COLOR_TABLEVIEW_BACK_VIEW_BACKGROUND_DEFAULT];
        
        // 设置 tableView 实例
        _tableView = tableView;
    }
    return _tableView;
}

- (FYPayModeHeaderView *)tableHeaderView
{
    if (!_tableHeaderView) {
        _tableHeaderView = [[FYPayModeHeaderView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.tableViewHeaderHeight) headerViewHeight:self.tableViewHeaderHeight tabTitles:self.tabTitles tabPayModels:self.tabPayModels segmentView:self.segmentView parentViewController:self];
        self.delegate_header = _tableHeaderView;
    }
    return _tableHeaderView;
}

- (ZJScrollSegmentView *)segmentView
{
    if (_segmentView == nil) {
        CGFloat titleHeight = self.segmentViewHeight * 0.65f;
        UIFont *titleFont = [UIFont boldSystemFontOfSize:CFC_AUTOSIZING_FONT(14)];
        CGFloat itemMinWith = [NSLocalizedString(@"菜单项目", nil) widthWithFont:titleFont constrainedToHeight:CGFLOAT_MAX];
        //
        ZJSegmentStyle *style = [[ZJSegmentStyle alloc] init];
        style.scrollContentView = YES;
        style.contentViewBounces = NO;
        style.segmentViewBounces = YES;
        style.gradualChangeTitleColor = YES;
        style.animatedContentViewWhenTitleClicked = NO;
        style.itemWidth = itemMinWith;
        style.showCover = YES;
        style.coverHeight = titleHeight;
        style.coverCornerRadius = titleHeight * 0.5f;
        style.scrollLineHeight = 0.0f;
        style.coverBackgroundColor = [UIColor colorWithRed:205.0/255.0 green:50.0/255.0 blue:36.0/255.0 alpha:1.0];
        style.titleFont = titleFont;
        style.normalTitleColor = [UIColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:1.0];
        style.selectedTitleColor = [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0];
        
        __weak __typeof(&*self)weakSelf = self;
        CGRect frame = CGRectMake(0, 0, self.view.bounds.size.width, self.segmentViewHeight);
        ZJScrollSegmentView *segment = [[ZJScrollSegmentView alloc] initWithFrame:frame segmentStyle:style delegate:self titles:self.tabTitles titleDidClick:^(ZJTitleView *titleView, NSInteger index) {
            [weakSelf.contentView setContentOffSet:CGPointMake(weakSelf.contentView.bounds.size.width * index, 0.0) animated:NO];
            [weakSelf.tableHeaderView setSelectedIndex:index animated:YES];
        }];
        [segment setBackgroundColor:[UIColor whiteColor]];
        [segment addBorderWithColor:COLOR_TABLEVIEW_SEPARATOR_LINE_DEFAULT cornerRadius:0.0f andWidth:1.0f];
        _segmentView = segment;
    }
    return _segmentView;
}

- (ZJContentView *)contentView
{
    if (_contentView == nil) {
        CGRect frame = CGRectMake(0.0f, 0.0f, self.view.bounds.size.width, SCREEN_MAX_LENGTH - STATUS_NAVIGATION_BAR_HEIGHT - self.tableViewHeaderHeight - self.segmentViewHeight - TAB_BAR_AND_DANGER_HEIGHT);
        if (self.isPush) {
            frame = CGRectMake(0.0f, 0.0f, self.view.bounds.size.width, SCREEN_MAX_LENGTH - STATUS_NAVIGATION_BAR_HEIGHT - self.tableViewHeaderHeight - self.segmentViewHeight);
        }
        ZJContentView *content = [[ZJContentView alloc] initWithFrame:frame segmentView:self.segmentView parentViewController:self delegate:self];
        _contentView = content;
    }
    return _contentView;
}

@end
