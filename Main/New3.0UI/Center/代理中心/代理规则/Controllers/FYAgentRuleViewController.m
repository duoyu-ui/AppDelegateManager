//
//  FYAgentRuleViewController.m
//  ProjectCSHB
//
//  Created by fangyuan on 2020/7/29.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "FYAgentRuleViewController.h"
#import "FYAgentRuleSectionHeader.h"
#import "FYAgentRuleSubViewController.h"
#import "FYAgentRuleSub1ViewController.h"
#import "FYAgentRuleSub2ViewController.h"
#import "FYAgentRuleSub3ViewController.h"
#import "ZJScrollPageView.h"

static NSString * const CELL_IDENTIFIER_AGENT_RULE_TABLEVIEW_CLASS_CONTENT = @"FYAgentRuleViewControllerContentCellIdentifier";

@interface FYAgentRuleCustomTableView : UITableView
@end
@implementation FYAgentRuleCustomTableView
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return [gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]] && [otherGestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]];
}
@end

@interface FYAgentRuleViewController () <ZJScrollPageViewDelegate, FYScrollPageViewControllerDelegate, UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource>

@property (assign, nonatomic) CGFloat tableHeaderHeight;
@property (assign, nonatomic) CGFloat tableSectionHeaderHeight;
@property (assign, nonatomic) CGFloat tableSectionSegmentHeight;

@property (strong, nonatomic) UIScrollView *childScrollView;
@property (strong, nonatomic) ZJContentView *contentView;
@property (strong, nonatomic) ZJScrollSegmentView *segmentView;
@property (strong, nonatomic) FYAgentRuleCustomTableView *tableView;
@property (strong, nonatomic) FYAgentRuleSectionHeader *tableSectionHeaderView;

@property (assign, nonatomic) NSInteger segmentSelectedIndex; // 当前选中菜单下标
@property (strong, nonatomic) NSMutableArray<NSString *> *tabTitles; // 菜单标题
@property (strong, nonatomic) NSMutableArray<NSString *> *tabTitleCodes; // 菜单标识

@end

@implementation FYAgentRuleViewController

#pragma mark - ClassMethod

/// 间隔
+ (CGFloat)heightOfHeaderSpline
{
    return SEPARATOR_LINE_HEIGHT * 2.0f;
}

/// 菜单
+ (CGFloat)heightOfHeaderSegment
{
    return 50.0f;
}


#pragma mark - Life Cycle

- (instancetype)init
{
    self = [super init];
    if (self) {
        _segmentSelectedIndex = 0;
        _tableHeaderHeight = 0.0f;
        _tableSectionSegmentHeight = [[self class] heightOfHeaderSegment];
        _tableSectionHeaderHeight = [[self class] heightOfHeaderSpline] + [[self class] heightOfHeaderSegment] + [[self class] heightOfHeaderSpline]; // 间隔+菜单+间隔
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 必须代码
    [self setAutomaticallyAdjustsScrollViewInsets:NO];

    // 创建菜单
    WEAKSELF(weakSelf);
    [self loadRequestMenuDataThen:^(BOOL success, NSMutableArray<NSDictionary *> *itemDictModels) {
        // 菜单列表
        {
            __block NSMutableArray<NSString *> *tabTitles = [[NSMutableArray<NSString *> alloc] init];
            __block NSMutableArray<NSString *> *tabTitleCodes = [[NSMutableArray<NSString *> alloc] init];
            [itemDictModels enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [tabTitles addObj:[obj stringForKey:@"title"]];
                [tabTitleCodes addObj:[obj stringForKey:@"code"]];
            }];
            [weakSelf setTabTitles:tabTitles];
            [weakSelf setTabTitleCodes:tabTitleCodes];
        }
        // 根据数据创建表格（必须在拿到数据后才能操作）
        [weakSelf.view addSubview:weakSelf.tableView];
    }];
}

- (BOOL)shouldAutomaticallyForwardAppearanceMethods
{
    return NO;
}


#pragma mark - Network

- (void)loadData
{
    // 刷新下级数据
    [self doRefreshForAgentReportSubTable];
}

- (void)loadRequestMenuDataThen:(void (^)(BOOL success, NSMutableArray<NSDictionary *> *itemDictModels))then
{
    NSMutableArray<NSDictionary *> *itemDictModels = @[
        @{ @"title":NSLocalizedString(@"代理说明", nil), @"code":@"agent_info" },
        @{ @"title":NSLocalizedString(@"代理层级", nil), @"code":@"agent_level" },
        @{ @"title":NSLocalizedString(@"返水比例", nil), @"code":@"agent_backwater" }
    ].mutableCopy;
    !then ?: then(YES,itemDictModels);
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
        NSString *tabTitleCode = self.tabTitleCodes[index];
        NSString *className = [NSString stringWithFormat:@"FYAgentRuleSub%ldViewController", index+1];
        childViewController = [[NSClassFromString(className) alloc] initWithTabTitleCode:tabTitleCode];
        if ([childViewController isKindOfClass:[FYScrollPageViewController class]]) {
            FYScrollPageViewController *viewController = (FYScrollPageViewController *)childViewController;
            [viewController setDelegate:self];
            [viewController resetSubScrollViewSize:CGSizeMake(self.view.bounds.size.width, self.view.bounds.size.height-self.tableSectionHeaderHeight)];
        } else {
            NSString *message = [NSString stringWithFormat:NSLocalizedString(@"[%@]基类必须是[FYScrollPageViewController]，请进行修改。", nil), self.tabTitles[index]];
            NSAssert(NO, message);
        }
    }

    FYAgentRuleSubViewController<FYAgentRuleViewControllerProtocol> *viewController = (FYAgentRuleSubViewController<FYAgentRuleViewControllerProtocol> *)childViewController;
    self.delegate_subclass = viewController;
    
    [self setSegmentSelectedIndex:index];
    
    return childViewController;
}


#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // 此处 scrollView 是 FYGamesCustomTableView
    if (self.childScrollView && self.childScrollView.contentOffset.y > 0) {
        self.tableView.contentOffset = CGPointMake(0.0f, self.tableHeaderHeight);
    }
    CGFloat offsetY = scrollView.contentOffset.y;
    if(offsetY < self.tableHeaderHeight) {
        [[NSNotificationCenter defaultCenter] postNotificationName:FYScrollPageTableViewDidLeaveFromTopNotification object:nil];
    } else {
        self.tableView.contentOffset = CGPointMake(0.0f, self.tableHeaderHeight);
    }
}


#pragma mark - FYScrollPageViewControllerDelegate

- (void)scrollViewIsScrolling:(UIScrollView *)scrollView
{
    // 此处 scrollView 是 tableViewMenu、tableViewContent
    _childScrollView = scrollView;
    if (self.tableView.contentOffset.y < self.tableHeaderHeight) {
        scrollView.contentOffset = CGPointZero;
        scrollView.showsVerticalScrollIndicator = NO;
    } else {
        self.tableView.contentOffset = CGPointMake(0.0f, self.tableHeaderHeight);
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFIER_AGENT_RULE_TABLEVIEW_CLASS_CONTENT];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELL_IDENTIFIER_AGENT_RULE_TABLEVIEW_CLASS_CONTENT];
    }
    [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [cell.contentView addSubview:self.contentView];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return self.tableSectionHeaderView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return self.tableSectionHeaderHeight;
}


#pragma mark - Navigation

- (NSString *)prefersNavigationBarTitleViewTitle
{
    return NSLocalizedString(@"代理规则", nil);
}

- (CGFloat)prefersNavigationBarHairlineHeight
{
    return NAVIGATION_BAR_HAIR_LINE_HEIGHT_ZERO;
}


#pragma mark - Getter & Setter

- (FYAgentRuleCustomTableView *)tableView
{
    if (!_tableView) {
        CGRect frame = CGRectMake(0.0f, 0.0f, self.view.bounds.size.width, self.view.bounds.size.height);
        FYAgentRuleCustomTableView *tableView = [[FYAgentRuleCustomTableView alloc] initWithFrame:frame style:UITableViewStylePlain];
        tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.tableHeaderHeight)];
        tableView.tableFooterView = [UIView new];
        // 设置 tableView 的 sectionHeadHeight
        tableView.sectionHeaderHeight = self.tableSectionHeaderHeight;
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
        
        // 下拉刷新
        CFCRefreshHeader *refreshHeader = [CFCRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
        [refreshHeader setTitle:CFCRefreshAutoHeaderIdleText forState:MJRefreshStateIdle];
        [refreshHeader setTitle:CFCRefreshAutoHeaderPullingText forState:MJRefreshStatePulling];
        [refreshHeader setTitle:CFCRefreshAutoHeaderRefreshingText forState:MJRefreshStateRefreshing];
        [refreshHeader.stateLabel setTextColor:COLOR_HEXSTRING(CFCRefreshAutoHeaderColor)];
        [refreshHeader.stateLabel setFont:[UIFont systemFontOfSize:CFC_AUTOSIZING_FONT(CFCRefreshAutoFooterFontSize)]];
        [refreshHeader setBackgroundColor:COLOR_TABLEVIEW_BACK_VIEW_BACKGROUND_DEFAULT];
        [tableView setMj_header:refreshHeader];
        
        // 设置 tableView 实例
        _tableView = tableView;
    }
    return _tableView;
}

- (FYAgentRuleSectionHeader *)tableSectionHeaderView
{
    if (!_tableSectionHeaderView) {
        _tableSectionHeaderView = [[FYAgentRuleSectionHeader alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.tableSectionHeaderHeight) headerViewHeight:self.tableSectionHeaderHeight parentViewController:self segmentView:self.segmentView];
    }
    return _tableSectionHeaderView;
}

- (ZJScrollSegmentView *)segmentView
{
    if (_segmentView == nil) {
        CGFloat margin = CFC_AUTOSIZING_MARGIN(MARGIN);
        CGFloat left_right_gap = margin*1.5f;
        CGFloat titleMargin = 2.5f;
        CGFloat titleHeight = self.tableSectionSegmentHeight * 0.645f;
        UIFont *titleFont = FONT_PINGFANG_SEMI_BOLD(16);
        NSInteger titleCount = 3; // 默认显示4个【self.tabTitles.count】
        NSString *maxString = [CFCSysUtil getMaxLengthItemString:self.tabTitles];
        CGFloat itemMinWith = [maxString widthWithFont:titleFont constrainedToHeight:CGFLOAT_MAX];
        CGFloat itemWidth = (self.view.bounds.size.width-(titleMargin)*(titleCount-1)-left_right_gap*2.0f)/titleCount;
        if (itemMinWith < itemWidth) {
            itemMinWith = itemWidth;
        }
        //
        ZJSegmentStyle *style = [[ZJSegmentStyle alloc] init];
        style.scrollContentView = YES;
        style.contentViewBounces = NO;
        style.segmentViewBounces = YES;
        style.gradualChangeTitleColor = YES;
        style.animatedContentViewWhenTitleClicked = NO;
        style.itemWidth = itemMinWith;
        style.titleMargin = titleMargin;
        style.titleEdgetMargin = left_right_gap;
        style.titleFont = titleFont;
        style.showCover = YES;
        style.coverHeight = titleHeight;
        style.coverCornerRadius = titleHeight * 0.5f;
        style.coverGradualChangeColor = YES;
        style.coverGradualColors = @[ COLOR_HEXSTRING(@"#DF5E43"), COLOR_HEXSTRING(@"#D54733"), COLOR_HEXSTRING(@"#CD3224")];
        style.scrollLineHeight = 0.0f;
        style.coverBackgroundColor = [UIColor colorWithRed:205.0/255.0 green:50.0/255.0 blue:36.0/255.0 alpha:1.0];
        style.normalTitleColor = [UIColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:1.0];
        style.selectedTitleColor = [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0];
        
        __weak __typeof(&*self)weakSelf = self;
        CGRect frame = CGRectMake(0, 0, self.view.bounds.size.width, self.tableSectionSegmentHeight);
        ZJScrollSegmentView *segment = [[ZJScrollSegmentView alloc] initWithFrame:frame segmentStyle:style delegate:self titles:self.tabTitles titleDidClick:^(ZJTitleView *titleView, NSInteger index) {
            [weakSelf.contentView setContentOffSet:CGPointMake(weakSelf.contentView.bounds.size.width * index, 0.0) animated:NO];
        }];
        [segment setBackgroundColor:[UIColor whiteColor]];
        
        _segmentView = segment;
    }
    return _segmentView;
}

- (ZJContentView *)contentView
{
    if (_contentView == nil) {
        CGRect frame = frame = CGRectMake(0.0f, 0.0f, self.view.bounds.size.width, SCREEN_MAX_LENGTH - STATUS_NAVIGATION_BAR_HEIGHT - self.tableHeaderHeight - self.tableSectionHeaderHeight);
        ZJContentView *content = [[ZJContentView alloc] initWithFrame:frame segmentView:self.segmentView parentViewController:self delegate:self];
        _contentView = content;
    }
    return _contentView;
}


#pragma mark - Priavte

- (void)doRefreshForAgentReportSubTable
{
    if (self.delegate_subclass && [self.delegate_subclass respondsToSelector:@selector(doRefreshForAgentRuleSubController:)]) {
        NSString *tabTitleCode = @"";
        if (self.segmentSelectedIndex < self.tabTitleCodes.count) {
            tabTitleCode = self.tabTitleCodes[self.segmentSelectedIndex];
        }
        [self.delegate_subclass doRefreshForAgentRuleSubController:tabTitleCode];
    }
}


@end

