//
//  FYAgentReportViewController.m
//  ProjectCSHB
//
//  Created by fangyuan on 2020/6/27.
//  Copyright © 2020 Fangyuan. All rights reserved.
//
//  代理报表
//

#import "FYAgentReportViewController.h"
#import "FYAgentReportSectionHeader.h"
#import "FYAgentReportSubViewController.h"
#import "FYAgentReportMenuModel.h"
#import "ZJScrollPageView.h"

CGFloat const TABLEVIEW_HEADER_HEIGHT_FOR_AGENT_REPORT_MAIN = 0.0f; // 隐藏
CGFloat const TABLEVIEW_SECTION_HEADER_HEIGHT_FOR_AGENT_REPORT_SEGMENT = 45.0f;

static NSString * const CELL_IDENTIFIER_AGENT_REPORT_TABLEVIEW_CLASS_CONTENT = @"FYAgentReportViewControllerContentCellIdentifier";

@interface FYAgentReportCustomTableView : UITableView
@end
@implementation FYAgentReportCustomTableView
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return [gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]] && [otherGestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]];
}
@end

@interface FYAgentReportViewController () <ZJScrollPageViewDelegate, FYAgentReportSubViewControllerDelegate, UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource>

@property (assign, nonatomic) CGFloat tableHeaderHeight;
@property (assign, nonatomic) CGFloat tableSectionHeaderHeight;
@property (assign, nonatomic) CGFloat tableSectionSegmentHeight;

@property (strong, nonatomic) UIScrollView *childScrollView;
@property (strong, nonatomic) ZJContentView *contentView;
@property (strong, nonatomic) ZJScrollSegmentView *segmentView;
@property (strong, nonatomic) FYAgentReportCustomTableView *tableView;
@property (strong, nonatomic) FYAgentReportSectionHeader *tableSectionHeaderView;

@property (assign, nonatomic) NSInteger segmentSelectedIndex; // 当前选中菜单下标
@property (strong, nonatomic) NSMutableArray<NSString *> *tabTitles; // 菜单标题
@property (strong, nonatomic) NSMutableArray<NSString *> *tabTitleCodes; // 菜单标识

@property (nonatomic, copy) NSString *datePickerButtonTitle; // 时间按钮标题
@property (nonatomic, assign) FYDatePickerTimeType datePickerTimeType; // 时间选择类型（按月选择 or 按日选择）
@property (nonatomic, copy) NSString *datePickerYearMonthTitleFormat; // 按月选择，日期格式 - 标题
@property (nonatomic, copy) NSString *datePickerYearMonthContentFormat; // 按月选择，日期格式 - 内容
@property (nonatomic, copy) NSString *datePickerStartEndTimeTitleFormat; // 按日选择，日期格式 - 标题
@property (nonatomic, copy) NSString *datePickerStartEndTimeContentFormat; // 按日选择，日期格式 - 内容
@property (nonatomic, copy) NSString *datePickerYearMonth; // 按月选择 - 年月时间
@property (nonatomic, copy) NSString *datePickerStartTime; // 按日选择 - 开始时间
@property (nonatomic, copy) NSString *datePickerEndTime; // 按日选择 - 结束时间

@end

@implementation FYAgentReportViewController

#pragma mark - Actions

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
        [self doRefreshForAgentReportTable];
    }
}


#pragma mark - Life Cycle

- (instancetype)initWithSearchMemberKey:(NSString *)searchMemberKey isFromMineCenter:(BOOL)isFromMineCenter
{
    self = [super initWithSearchMemberKey:searchMemberKey isInitSearchText:!isFromMineCenter];
    if (self) {
        _segmentSelectedIndex = 0;
        _tableHeaderHeight = TABLEVIEW_HEADER_HEIGHT_FOR_AGENT_REPORT_MAIN;
        _tableSectionSegmentHeight = TABLEVIEW_SECTION_HEADER_HEIGHT_FOR_AGENT_REPORT_SEGMENT;
        _tableSectionHeaderHeight = TABLEVIEW_SECTION_HEADER_HEIGHT_FOR_AGENT_REPORT_SEGMENT;
        //
        _datePickerButtonTitle = @"";
        _datePickerTimeType = FYDatePickerTimeTypeYearMonth;
        _datePickerYearMonthTitleFormat = kFYDatePickerFormatYearMonth;
        _datePickerYearMonthContentFormat = kFYDatePickerFormatYearMonth;
        _datePickerStartEndTimeTitleFormat = kFYDatePickerFormatYearMonthDay;
        _datePickerStartEndTimeContentFormat = kFYDatePickerFormatYearMonthDay;
        _datePickerYearMonth = [[NSDate today] stringFromDateWithFormat:_datePickerYearMonthContentFormat];
        _datePickerStartTime = @"";
        _datePickerEndTime = @"";
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
    [self loadRequestMenuDataThen:^(BOOL success, NSMutableArray<FYAgentReportMenuModel *> *itemMenuModels) {
        // 菜单列表
        {
            __block NSMutableArray<NSString *> *tabTitles = [[NSMutableArray<NSString *> alloc] init];
            __block NSMutableArray<NSString *> *tabTitleCodes = [[NSMutableArray<NSString *> alloc] init];
            [itemMenuModels enumerateObjectsUsingBlock:^(FYAgentReportMenuModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [tabTitles addObj:obj.title];
                [tabTitleCodes addObj:[NSString stringWithFormat:@"%@", obj.uuid]];
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

- (void)loadRequestMenuDataThen:(void (^)(BOOL success, NSMutableArray<FYAgentReportMenuModel *> *itemMenuModels))then
{
    PROGRESS_HUD_SHOW
    [NET_REQUEST_MANAGER requestAgentReportMenuDataSuccess:^(id response) {
        PROGRESS_HUD_DISMISS
        FYLog(NSLocalizedString(@"代理报表菜单 => \n%@", nil), [response mj_JSONString]);
        if (!NET_REQUEST_SUCCESS(response)) {
           !then ?: then(NO,nil);
        } else {
            NSArray<NSDictionary *> *data = NET_REQUEST_DATA(response);
            NSMutableArray<FYAgentReportMenuModel *> *itemMenuModels = [FYAgentReportMenuModel buildingDataModles:data];
            !then ?: then(YES,itemMenuModels);
        }
    } failure:^(id error) {
        PROGRESS_HUD_DISMISS
        ALTER_HTTP_ERROR_MESSAGE(error)
        FYLog(NSLocalizedString(@"获取代理报表菜单异常 => \n%@", nil), error);
        !then ?: then(NO,nil);
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
        NSString *tabTitleCode = self.tabTitleCodes[index];
        childViewController = [[FYAgentReportSubViewController alloc] initWithTabTitleCode:tabTitleCode searchMemberKey:self.searchMemberKey];
        if ([childViewController isKindOfClass:[FYScrollPageViewController class]]) {
            FYScrollPageViewController *viewController = (FYScrollPageViewController *)childViewController;
            [viewController setDelegate:self];
            [viewController resetSubScrollViewSize:CGSizeMake(self.view.bounds.size.width, self.view.bounds.size.height-self.tableSectionHeaderHeight-[FYAgentSearchHeaderView headerViewHeight])];
        } else {
            NSString *message = [NSString stringWithFormat:NSLocalizedString(@"[%@]基类必须是[FYScrollPageViewController]，请进行修改。", nil), self.tabTitles[index]];
            NSAssert(NO, message);
        }
    }

    // 当前的下级代理
    FYAgentReportSubViewController<FYAgentReportViewControllerProtocol> *viewController = (FYAgentReportSubViewController<FYAgentReportViewControllerProtocol> *)childViewController;
    self.delegate_subclass = viewController;
    
    // 当前选中项下标
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
    
    // 键盘收起
    [self.searchHeaderView endEditing];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    // 键盘收起
    [self.searchHeaderView endEditing];
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
    } else if (FYScrollPageForSuperViewTypeTableStartRefresh == type) {
        [self doRefreshForAgentReportTable];
    }
}


#pragma mark - FYAgentReportSubViewControllerDelegate

- (void)doRefreshSearchKey:(NSString *)userId userName:(NSString *)username headIcon:(NSString *)headIcon
{
    [self.searchHeaderView doRefreshSearchKey:@"" userName:@"" usertype:@(54088) headIcon:@"" searchText:self.searchTextPlaceHolder];
}

- (void)doRefreshDatePickerTimeType:(FYDatePickerTimeType)datePickerTimeType datePickerYearMonth:(NSString *)datePickerYearMonth datePickerStartTime:(NSString *)datePickerStartTime datePickerEndTime:(NSString *)datePickerEndTime isNeedRefresh:(BOOL)isNeedRefresh
{
    if (!isNeedRefresh) {
        return;
    }
    
    [self setDatePickerTimeType:datePickerTimeType];
    [self setDatePickerYearMonth:datePickerYearMonth];
    [self setDatePickerStartTime:datePickerStartTime];
    [self setDatePickerEndTime:datePickerEndTime];
    //
    [self doRefreshForAgentReportTable];
}

- (void)doDatePickerDateTimeButtonTitle:(NSString *)titleString
{
    [self setDatePickerButtonTitle:titleString];
}

- (NSString *)getCurrentDatePickerrButtonTitle
{
    return self.datePickerButtonTitle;
}

- (FYDatePickerTimeType)getCurrentDatePickerTimeType
{
    return self.datePickerTimeType;
}

- (NSString *)getCurrentDatePickerYearMonthTitleFormat
{
    return self.datePickerYearMonthTitleFormat;
}

- (NSString *)getCurrentDatePickerYearMonthContentFormat
{
    return self.datePickerYearMonthContentFormat;
}

- (NSString *)getCurrentDatePickerStartEndTimeTitleFormat
{
    return self.datePickerStartEndTimeTitleFormat;
}

- (NSString *)getCurrentDatePickerStartEndTimeContentFormat
{
    return self.datePickerStartEndTimeContentFormat;
}

- (NSString *)getCurrentDatePickerYearMonth
{
    return self.datePickerYearMonth;
}

- (NSString *)getCurrentDatePickerStartTime
{
    return self.datePickerStartTime;
}

- (NSString *)getCurrentDatePickerEndTime
{
    return self.datePickerEndTime;
}

- (NSString *)getCurrentSearchMemberKey
{
    return self.searchMemberKey;
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
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFIER_AGENT_REPORT_TABLEVIEW_CLASS_CONTENT];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELL_IDENTIFIER_AGENT_REPORT_TABLEVIEW_CLASS_CONTENT];
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
    return NSLocalizedString(@"代理报表", nil);
}


#pragma mark - Getter & Setter

- (FYAgentReportCustomTableView *)tableView
{
    if (!_tableView) {
        CGFloat frameY = STATUS_NAVIGATION_BAR_HEIGHT + [FYAgentSearchHeaderView headerViewHeight];
        CGRect frame = CGRectMake(0.0f, frameY, self.view.bounds.size.width, self.view.bounds.size.height-frameY);
        FYAgentReportCustomTableView *tableView = [[FYAgentReportCustomTableView alloc] initWithFrame:frame style:UITableViewStylePlain];
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

- (FYAgentReportSectionHeader *)tableSectionHeaderView
{
    if (!_tableSectionHeaderView) {
        _tableSectionHeaderView = [[FYAgentReportSectionHeader alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.tableSectionHeaderHeight) headerViewHeight:self.tableSectionHeaderHeight parentViewController:self segmentView:self.segmentView];
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
        NSInteger titleCount = 5; // 默认显示5个【self.tabTitles.count】
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
            [weakSelf setSegmentSelectedIndex:index];
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
        CGRect frame = frame = CGRectMake(0.0f, 0.0f, self.view.bounds.size.width, SCREEN_MAX_LENGTH - STATUS_NAVIGATION_BAR_HEIGHT - self.tableHeaderHeight - self.tableSectionHeaderHeight - [FYAgentSearchHeaderView headerViewHeight]);
        ZJContentView *content = [[ZJContentView alloc] initWithFrame:frame segmentView:self.segmentView parentViewController:self delegate:self];
        _contentView = content;
    }
    return _contentView;
}


#pragma mark - Priavte

- (void)doRefreshForAgentReportTable
{
    if (self.delegate_subclass && [self.delegate_subclass respondsToSelector:@selector(doScrollAgentReportSubTableToTopAnimated:)]) {
        [self.delegate_subclass doScrollAgentReportSubTableToTopAnimated:NO];
    }
    [self.tableView scrollTableToTopAnimated:NO];
    [self.tableView.mj_header beginRefreshing];
}

- (void)doRefreshForAgentReportSubTable
{
    if (self.delegate_subclass && [self.delegate_subclass respondsToSelector:@selector(doRefreshForAgentReportSubViewController:searchMemberKey:)]) {
        NSString *tabTitleCode = @"";
        if (self.segmentSelectedIndex < self.tabTitleCodes.count) {
            tabTitleCode = self.tabTitleCodes[self.segmentSelectedIndex];
        }
        [self.delegate_subclass doRefreshForAgentReportSubViewController:tabTitleCode searchMemberKey:self.searchMemberKey];
    }
}


@end

