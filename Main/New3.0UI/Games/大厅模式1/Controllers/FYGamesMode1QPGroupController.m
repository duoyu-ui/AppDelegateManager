//
//  FYGamesMode1QPGroupController.m
//  ProjectCSHB
//
//  Created by fangyuan on 2020/7/31.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "FYGamesMode1QPGroupController.h"
#import "FYGamesMode1QPGroupSectionHeader.h"
#import "FYGamesMode1QPGroupSubController.h"
#import "FYGamesMode1ClassModel.h"
#import "FYGamesMode1TypesModel.h"
#import "ZJScrollPageView.h"

static NSString * const CELL_IDENTIFIER_GAMES_MODE1_QP_TABLEVIEW_CLASS_CONTENT = @"FYGamesMode1QPGroupControllerContentCellIdentifier";

@interface FYGamesMode1QPGroupCustomTableView : UITableView
@end
@implementation FYGamesMode1QPGroupCustomTableView
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return [gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]] && [otherGestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]];
}
@end

@interface FYGamesMode1QPGroupController () <ZJScrollPageViewDelegate, FYGamesMode1QPGroupSubControllerDelegate, UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource>

@property (assign, nonatomic) CGFloat tableHeaderHeight;
@property (assign, nonatomic) CGFloat tableSectionHeaderHeight;
@property (assign, nonatomic) CGFloat tableSectionSegmentHeight;

@property (strong, nonatomic) UIScrollView *childScrollView;
@property (strong, nonatomic) ZJContentView *contentView;
@property (strong, nonatomic) ZJScrollSegmentView *segmentView;
@property (strong, nonatomic) FYGamesMode1QPGroupCustomTableView *tableView;
@property (strong, nonatomic) FYGamesMode1QPGroupSectionHeader *tableSectionHeaderView;

@property (assign, nonatomic) NSInteger segmentSelectedIndex; // 当前选中菜单下标
@property (strong, nonatomic) NSMutableArray<NSString *> *tabTitles; // 菜单标题
@property (strong, nonatomic) NSMutableArray<NSString *> *tabTitleCodes; // 菜单标识
@property (nonatomic, strong) NSMutableArray<NSNumber *> *tabRefreshValues;

@property (nonatomic, strong) FYGamesMode1ClassModel *selectedGroupModel;
@property (nonatomic, strong) FYGamesMode1TypesModel *currentGamesTypesModel;
@property (nonatomic, strong) NSMutableArray<FYGamesMode1ClassModel *> *tabTypeModels;
@property (nonatomic, strong) NSMutableArray<FYGamesMode1ClassModel *> *groupDataSource;

@end

@implementation FYGamesMode1QPGroupController

#pragma mark - Actions

/// 玩法规则
//- (void)pressNavigationBarRightButtonItem:(id)sender
//{
//    FYWebViewController *webViewController = [[FYWebViewController alloc] initWithUrl:[AppModel shareInstance].ruleString];
//    [webViewController setTitle:NSLocalizedString(@"玩法规则", nil)];
//    [self.navigationController pushViewController:webViewController animated:YES];
//}


#pragma mark - ClassMethod

/// 间隔
+ (CGFloat)heightOfHeaderSpline
{
    return 3.3f;
}

/// 菜单
+ (CGFloat)heightOfHeaderSegment
{
    return 50.0f;
}


#pragma mark - Life Cycle

- (instancetype)initWithGroupDataSource:(NSMutableArray<FYGamesMode1ClassModel *> *)groupDataSource selectedGroupModel:(FYGamesMode1ClassModel *)selectedGroupModel gamesTypesModel:(FYGamesMode1TypesModel *)gamesTypesModel
{
    self = [super init];
    if (self) {
        _groupDataSource = groupDataSource;
        _selectedGroupModel = selectedGroupModel;
        _currentGamesTypesModel = gamesTypesModel;
        //
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
    
    // 添加监听通知
    [self addNotifications];
    
    // 必须代码
    [self setAutomaticallyAdjustsScrollViewInsets:NO];

    // 创建菜单
    WEAKSELF(weakSelf);
    [self loadRequestMenuData:self.groupDataSource then:^(BOOL success, NSMutableArray<FYGamesMode1ClassModel *> *itemTabTypeModels) {
        // 菜单列表
        {
            __block NSString *tabTitleCodeOfSelected = @"";
            __block NSMutableArray<NSString *> *tabTitles = [[NSMutableArray<NSString *> alloc] init];
            __block NSMutableArray<NSString *> *tabTitleCodes = [[NSMutableArray<NSString *> alloc] init];
            __block NSMutableArray<NSNumber *> *tabRefreshValues = [[NSMutableArray<NSNumber *> alloc] init];
            [itemTabTypeModels enumerateObjectsUsingBlock:^(FYGamesMode1ClassModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [tabTitles addObj:obj.showName];
                [tabTitleCodes addObj:[NSString stringWithFormat:@"%@", obj.uuid.stringValue]];
                if (obj.uuid.integerValue == weakSelf.selectedGroupModel.uuid.integerValue) {
                    tabTitleCodeOfSelected = obj.uuid.stringValue;
                }
                [tabRefreshValues addObj:[NSNumber numberWithBool:NO]];
            }];
            [weakSelf setTabTitles:tabTitles];
            [weakSelf setTabTitleCodes:tabTitleCodes];
            [weakSelf setTabRefreshValues:tabRefreshValues];
            [weakSelf setTabTypeModels:itemTabTypeModels];
            //
            NSInteger selectedTabIndex = [tabTitleCodes indexOfObject:tabTitleCodeOfSelected];
            if (selectedTabIndex == NSNotFound) {
                [weakSelf setSegmentSelectedIndex:0];
            } else {
                [weakSelf setSegmentSelectedIndex:selectedTabIndex];
            }
            [weakSelf.segmentView setSelectedIndex:weakSelf.segmentSelectedIndex animated:NO];
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
    WEAKSELF(weakSelf)
    [self loadRequestGamesMode1TypesModelDataThen:^(BOOL success, NSMutableArray<FYGamesMode1TypesModel *> *itemGamesTypeModels) {
        // 重置原始数据
        [itemGamesTypeModels enumerateObjectsUsingBlock:^(FYGamesMode1TypesModel *gamesTypeModel, NSUInteger idx, BOOL * _Nonnull stop) {
            if (weakSelf.currentGamesTypesModel.uuid.integerValue == gamesTypeModel.uuid.integerValue) {
                [weakSelf setCurrentGamesTypesModel:gamesTypeModel];
                [weakSelf setGroupDataSource:[NSMutableArray arrayWithArray:gamesTypeModel.list]];
                *stop = YES;
            }
        }];
        // 重置滚动标题
        [self loadRequestMenuData:weakSelf.groupDataSource then:^(BOOL success, NSMutableArray<FYGamesMode1ClassModel *> *itemTabTypeModels) {
            __block NSMutableArray<NSString *> *tabTitles = [[NSMutableArray<NSString *> alloc] init];
            __block NSMutableArray<NSString *> *tabTitleCodes = [[NSMutableArray<NSString *> alloc] init];
            __block NSMutableArray<NSNumber *> *tabRefreshValues = [[NSMutableArray<NSNumber *> alloc] init];
            [itemTabTypeModels enumerateObjectsUsingBlock:^(FYGamesMode1ClassModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [tabTitles addObj:obj.showName];
                [tabTitleCodes addObj:[NSString stringWithFormat:@"%@", obj.uuid.stringValue]];
            }];
            // 滚动标题是否改变（显示、隐藏）
            if (![CFCSysUtil validateStrArray:weakSelf.tabTitleCodes isEqualToStrArray:tabTitleCodes]) {
                //
                [weakSelf.tabTitleCodes enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    [tabRefreshValues addObj:[NSNumber numberWithBool:NO]];
                }];
                //
                NSString *selecedTabCode = [weakSelf.tabTitleCodes objectAtIndex:weakSelf.segmentSelectedIndex];
                NSInteger selectedTabIndex = [tabTitleCodes indexOfObject:selecedTabCode];
                if (selectedTabIndex == NSNotFound) {
                    [weakSelf setSegmentSelectedIndex:0];
                } else {
                    [weakSelf setSegmentSelectedIndex:selectedTabIndex];
                }
                //
                [weakSelf setTabTitles:tabTitles];
                [weakSelf setTabTitleCodes:tabTitleCodes];
                [weakSelf setTabTypeModels:itemTabTypeModels];
                [weakSelf setTabRefreshValues:tabRefreshValues];
                //
                [weakSelf.segmentView reloadTitlesWithNewTitles:tabTitles];
                [weakSelf.contentView reload]; // 删除所有子页面并重新创建
                [weakSelf.segmentView setSelectedIndex:weakSelf.segmentSelectedIndex animated:NO];
            } else {
                //
                [weakSelf.tabTitleCodes enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if (weakSelf.segmentSelectedIndex == idx) {
                        [tabRefreshValues addObj:[NSNumber numberWithBool:NO]];
                    } else {
                        [tabRefreshValues addObj:[NSNumber numberWithBool:YES]];
                    }
                }];
                //
                [weakSelf setTabTitles:tabTitles];
                [weakSelf setTabTitleCodes:tabTitleCodes];
                [weakSelf setTabTypeModels:itemTabTypeModels];
                [weakSelf setTabRefreshValues:tabRefreshValues];
                // 刷新下级数据
                [self doRefreshForAgentReportSubTable];
            }
        }];
    }];
    
}

- (void)loadRequestMenuData:(NSMutableArray<FYGamesMode1ClassModel *> *)dataSource then:(void (^)(BOOL success, NSMutableArray<FYGamesMode1ClassModel *> *itemTabTypeModels))then
{
    if (!dataSource || dataSource.count <= 0) {
       !then ?: then(NO,nil);
    } else {
        NSMutableArray<FYGamesMode1ClassModel *> *itemTabTypeModels = [NSMutableArray array];
        for (FYGamesMode1ClassModel *classModel in dataSource) {
            if (STR_GAMES_CENTER_CLASS_TYPE_DIANZI_SHUIGUOYXJ == classModel.uuid.integerValue
                || STR_GAMES_CENTER_CLASS_TYPE_DIANZI_XINGYUNDZP == classModel.uuid.integerValue
                || STR_GAMES_CENTER_CLASS_TYPE_DIANZI_BENCHIBAOMA == classModel.uuid.integerValue) {
                // 电子游戏直接进入，不会显示此页面
            } else {
                [itemTabTypeModels addObj:classModel];
            }
        }
        !then ?: then(YES,itemTabTypeModels);
    }
}

- (void)loadRequestGamesMode1TypesModelDataThen:(void (^)(BOOL success, NSMutableArray<FYGamesMode1TypesModel *> *itemGamesTypeModels))then
{
    [NET_REQUEST_MANAGER requestGameTypesSuccess:^(id response) {
        FYLog(NSLocalizedString(@"游戏大厅数据 => \n%@", nil), response);
        if (!NET_REQUEST_SUCCESS(response)) {
           !then ?: then(YES,nil);
        } else {
            NSArray *arrayOfDicts = NET_REQUEST_DATA(response);
            if ([arrayOfDicts isKindOfClass:[NSArray class]]) {
                NSMutableArray<FYGamesMode1TypesModel *> *itemGamesTypeModels = [FYGamesMode1TypesModel mj_objectArrayWithKeyValuesArray:arrayOfDicts];
                !then ?: then(YES,itemGamesTypeModels);
            } else {
                !then ?: then(NO,nil);
            }
        }
    } fail:^(id error) {
        ALTER_HTTP_ERROR_MESSAGE(error)
        FYLog(NSLocalizedString(@"获取游戏大厅数据出错 => \n%@", nil), error);
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
        FYGamesMode1ClassModel *tabTypeModel = self.tabTypeModels[index];
        childViewController = [[FYGamesMode1QPGroupSubController alloc] initWithTabTitleCode:tabTitleCode tabTypeModel:tabTypeModel];
        if ([childViewController isKindOfClass:[FYScrollPageViewController class]]) {
            FYScrollPageViewController *viewController = (FYScrollPageViewController *)childViewController;
            [viewController setDelegate:self];
            [viewController resetSubScrollViewSize:CGSizeMake(self.view.bounds.size.width, self.view.bounds.size.height-self.tableSectionHeaderHeight)];
        } else {
            NSString *message = [NSString stringWithFormat:NSLocalizedString(@"[%@]基类必须是[FYScrollPageViewController]，请进行修改。", nil), self.tabTitles[index]];
            NSAssert(NO, message);
        }
    }

    FYGamesMode1QPGroupSubController<FYGamesMode1QPGroupControllerProtocol> *viewController = (FYGamesMode1QPGroupSubController<FYGamesMode1QPGroupControllerProtocol> *)childViewController;
    self.delegate_subclass = viewController;
    
    [self setSegmentSelectedIndex:index];
    [self setSelectedGroupModel:[self.tabTypeModels objectAtIndex:index]];
    
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
        if (self.segmentSelectedIndex < self.tabRefreshValues.count) {
            [self.tabRefreshValues replaceObjectAtIndex:self.segmentSelectedIndex withObject:@(NO)];
        }
    } else if (FYScrollPageForSuperViewTypeTableStartRefresh == type) {
        [self doRefreshForAgentReportTable];
    }
}

- (BOOL)doIsNeedRefreshFromSuperViewController
{
    if (self.segmentSelectedIndex < self.tabRefreshValues.count) {
        return [self.tabRefreshValues objectAtIndex:self.segmentSelectedIndex].boolValue;
    }
    return NO;
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
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFIER_GAMES_MODE1_QP_TABLEVIEW_CLASS_CONTENT];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELL_IDENTIFIER_GAMES_MODE1_QP_TABLEVIEW_CLASS_CONTENT];
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

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}

- (CGFloat)prefersNavigationBarHairlineHeight
{
    return NAVIGATION_BAR_HAIR_LINE_HEIGHT_ZERO;
}

- (NSString *)prefersNavigationBarTitleViewTitle
{
    return [NSString stringWithFormat:NSLocalizedString(@"%@游戏", nil), self.selectedGroupModel.showName];
}

- (CFCNavBarButtonItemType)prefersNavigationBarRightButtonItemType
{
    return CFCNavBarButtonItemTypeCustom;
}

//- (NSString *)prefersNavigationBarRightButtonItemTitle
//{
//    return NSLocalizedString(@"玩法规则", nil);
//}


#pragma mark - Notification

- (void)dealloc
{
    [self removeObservers];
}

- (void)removeObservers
{
    [NOTIF_CENTER removeObserver:self name:kNotificationReloadGamesMallList object:nil];
    [NOTIF_CENTER removeObserver:self name:kReloadMyMessageGroupList object:nil];
    [NOTIF_CENTER removeObserver:self];
}

- (void)addNotifications
{
    // 通知 - 刷新游戏大厅
    [NOTIF_CENTER addObserver:self selector:@selector(doNotifiReloadGamesMallData:) name:kNotificationReloadGamesMallList object:nil];
    
    // 通知 - 刷新群组信息（显示、隐藏、维护）
    [NOTIF_CENTER addObserver:self selector:@selector(doNotifiRefreshGamesGroupInfo:) name:kReloadMyMessageGroupList object:nil];
}


/// 刷新游戏大厅
- (void)doNotifiReloadGamesMallData:(NSNotification *)notification
{
    [self doRefreshForAgentReportTable];
}

/// 刷新群组信息（显示、隐藏、维护）
- (void)doNotifiRefreshGamesGroupInfo:(NSNotification *)notification
{
    [self doRefreshForAgentReportTable];
}


#pragma mark - Getter & Setter

- (FYGamesMode1QPGroupCustomTableView *)tableView
{
    if (!_tableView) {
        CGRect frame = CGRectMake(0.0f, 0.0f, self.view.bounds.size.width, self.view.bounds.size.height);
        FYGamesMode1QPGroupCustomTableView *tableView = [[FYGamesMode1QPGroupCustomTableView alloc] initWithFrame:frame style:UITableViewStylePlain];
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

- (FYGamesMode1QPGroupSectionHeader *)tableSectionHeaderView
{
    if (!_tableSectionHeaderView) {
        _tableSectionHeaderView = [[FYGamesMode1QPGroupSectionHeader alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.tableSectionHeaderHeight) headerViewHeight:self.tableSectionHeaderHeight parentViewController:self segmentView:self.segmentView];
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
        NSInteger titleCount = 4; // 默认显示4个【self.tabTitles.count】
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

- (void)doRefreshForAgentReportTable
{
    WEAKSELF(weakSelf)
    dispatch_main_async_safe(^{
        if (weakSelf.delegate_subclass && [weakSelf.delegate_subclass respondsToSelector:@selector(doRefreshForQPGroupSubContentTableScrollToTopAnimated:)]) {
            [weakSelf.delegate_subclass doRefreshForQPGroupSubContentTableScrollToTopAnimated:NO];
        }
        [weakSelf.tableView scrollTableToTopAnimated:NO];
        [weakSelf.tableView.mj_header beginRefreshing];
    });
}

- (void)doRefreshForAgentReportSubTable
{
    if (self.delegate_subclass && [self.delegate_subclass respondsToSelector:@selector(doRefreshForQPGroupSubController:)]) {
        NSString *tabTitleCode = @"";
        if (self.segmentSelectedIndex < self.tabTitleCodes.count) {
            tabTitleCode = self.tabTitleCodes[self.segmentSelectedIndex];
        }
        [self.delegate_subclass doRefreshForQPGroupSubController:tabTitleCode];
    }
}


@end

