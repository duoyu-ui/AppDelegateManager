//
//  FYGamesBaseViewController.m
//  ProjectCSHB
//
//  Created by fangyuan on 2020/7/27.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "FYGamesBaseViewController.h"
#import "FYGamesClassViewController.h"
#import "FYGamesBannerNoticeView.h"
#import "FYGamesBannerModel.h"
#import "FYGamesNoticeModel.h"
#import "ZJScrollPageView.h"
#import "FYGamesErrorView.h"

// Cell Identifier
static NSString * const CELL_IDENTIFIER_GAMES_MAIN_TABLEVIEW_CLASS_CONTENT = @"FYGamesBaseViewControllerContentCellIdentifier";

@implementation FYGamesCustomTableView
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return [gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]] && [otherGestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]];
}
@end

@interface FYGamesBaseViewController () <FYGamesClassViewControllerDelegate, UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UIScrollView *childScrollView;
@property (nonatomic, strong) FYGamesErrorView *errorView;
@property (nonatomic, strong) DGActivityIndicatorView *activityView;
@end

@implementation FYGamesBaseViewController

#pragma mark - Actions

/// 在线客服
- (void)pressNavigationBarLeftButtonItem:(id)sender
{
    NSString *urlString = [AppModel shareInstance].commonInfo[@"pop"];
    FYWebViewController *viewController = [[FYWebViewController alloc] initWithUrl:urlString];
    [viewController setTitle:NSLocalizedString(@"在线客服", nil)];
    [self.navigationController pushViewController:viewController animated:YES];
}

/// 刷新大厅
- (void)pressNavigationBarRightButtonItem:(id)sender
{
    if (!self.isLoadingSuccess) {
        [self pressReloadErrorViewAction];
    }
}

/// 刷新错误
- (void)pressReloadErrorViewAction
{
    [self setDeleteErrorView];
    
    // 验证数据是否请求成功
    WEAKSELF(weakSelf)
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        FYLog(NSLocalizedString(@"验证游戏大厅数据", nil));
        if (weakSelf.activityView.animating) {
            [weakSelf setInsertErrorView];
            [weakSelf setActivityStopAnimating];
            [weakSelf setIsLoadingSuccess:NO];
        } else {
            [weakSelf setIsLoadingSuccess:YES];
        }
    });
}


#pragma mark - ClassMethod

/// 广告（5+90）
+ (CGFloat)heightOfHeaderBanner
{
    CGFloat margin = CFC_AUTOSIZING_MARGIN(MARGIN);
    CGFloat height = (SCREEN_MIN_LENGTH-margin) * 0.275f;  // 图片 1040 * 286
    return 5.0f + height;
}

/// 通知（5+45）
+ (CGFloat)heightOfHeaderNotice
{
    return 5.0f + 45.0f;
}

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

- (instancetype)init
{
    self = [super init];
    if (self) {
        _isLoadingSuccess = NO;
        _segmentSelectedIndex = 0;
        _tableHeaderHeight = 0.0f;
        _tableSectionSegmentHeight = [[self class] heightOfHeaderSegment];
        _tableSectionHeaderHeight = [[self class] heightOfHeaderBanner] + [[self class] heightOfHeaderNotice] + [[self class] heightOfHeaderSpline] + [[self class] heightOfHeaderSegment]; // 广告+公告+间隔+菜单
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 添加监听通知
    [self addNotifications];
    
    // 必须的代码
    [self setAutomaticallyAdjustsScrollViewInsets:NO];

    // 设置背景色
    [self.view setBackgroundColor:COLOR_TABLEVIEW_BACK_VIEW_BACKGROUND_DEFAULT];
    
    // 验证数据是否请求成功
    WEAKSELF(weakSelf)
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        FYLog(NSLocalizedString(@"验证游戏大厅数据", nil));
        if (weakSelf.activityView.animating) {
            [weakSelf setInsertErrorView];
            [weakSelf setActivityStopAnimating];
            [weakSelf setIsLoadingSuccess:NO];
        } else {
            [weakSelf setIsLoadingSuccess:YES];
        }
    });
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // 解决 viewWillAppear 时出现时轮播图卡在一半的问题
    [_tableSectionHeaderView adjustWhenControllerViewWillAppera];
}

- (BOOL)shouldAutomaticallyForwardAppearanceMethods
{
    return NO;
}


#pragma mark - ErrorView

/// 加载错误提示页面
- (void)setInsertErrorView
{
    [self setDeleteErrorView];
    
    WEAKSELF(weakSelf);
    CGRect frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-STATUS_NAVIGATION_BAR_HEIGHT-TAB_BAR_AND_DANGER_HEIGHT);
    FYGamesErrorView *errorView = [[FYGamesErrorView alloc] initWithFrame:frame];
    [errorView setRefreshBlock:^{
        [weakSelf pressReloadErrorViewAction];
    }];
    [self setErrorView:errorView];
    [self.view insertSubview:errorView atIndex:0];
}

/// 删除错误提示页面
- (void)setDeleteErrorView
{
    [self.errorView removeFromSuperview];
    [self setErrorView:nil];
}

/// 开始加载菊花动画 - 开始
- (void)setActivityStartAnimating
{
    [self.activityView startAnimating];
}

/// 开始加载菊花动画 - 结束
- (void)setActivityStopAnimating
{
    [self.activityView stopAnimating];
    [self.activityView removeFromSuperview];
    [self setActivityView:nil];
}


#pragma mark - Network

- (void)loadData
{
    // TODO: 在子类中处理
    
}

- (void)loadRequestDataBannersThen:(void (^)(BOOL success, NSMutableArray<FYGamesBannerModel *> *itemBannerModels))then
{
    [NET_REQUEST_MANAGER requestMsgBannerWithId:OccurBannerAdsTypeGroup WithPictureSpe:OccurBannerAdsPictureTypeNormal success:^(id response) {
        FYLog(NSLocalizedString(@"广告数据 => \n%@", nil), response);
        if (!NET_REQUEST_SUCCESS(response)) {
           !then ?: then(NO,nil);
        } else {
            NSDictionary *data = NET_REQUEST_DATA(response);
            NSMutableArray<FYGamesBannerModel *> *itemBannerModels = [NSMutableArray array];
            [data[@"skAdvDetailList"] enumerateObjectsUsingBlock:^(NSDictionary *  _Nonnull dict, NSUInteger idx, BOOL * _Nonnull stop) {
                FYGamesBannerModel *model = [FYGamesBannerModel mj_objectWithKeyValues:dict];
                [itemBannerModels addObj:model];
            }];
            !then ?: then(YES,itemBannerModels);
        }
    } fail:^(id error) {
        FYLog(NSLocalizedString(@"获取广告数据出错 => \n%@", nil), error);
        !then ?: then(NO,nil);
    }];
}

- (void)loadRequestDataNoticesThen:(void (^)(BOOL success, NSMutableArray<FYGamesNoticeModel *> *itemNoticeModels))then
{
    [NET_REQUEST_MANAGER allSystemMessagesWithrTime:@"" page:1 success:^(id response) {
        FYLog(NSLocalizedString(@"通知公告 => \n%@", nil), response);
        if (!NET_REQUEST_SUCCESS(response)) {
           !then ?: then(NO,[FYGamesNoticeModel buildingDataModles]);
        } else {
            NSDictionary *data = NET_REQUEST_DATA(response);
            NSMutableArray<FYGamesNoticeModel *> *itemNoticeModels = [NSMutableArray array];
            [data[@"records"] enumerateObjectsUsingBlock:^(NSDictionary *  _Nonnull dict, NSUInteger idx, BOOL * _Nonnull stop) {
                FYGamesNoticeModel *model = [FYGamesNoticeModel mj_objectWithKeyValues:dict];
                [itemNoticeModels addObj:model];
            }];
            if (itemNoticeModels.count <= 0) {
                itemNoticeModels = [FYGamesNoticeModel buildingDataModles];
            }
            !then ?: then(YES,itemNoticeModels);
        }
    } fail:^(id error) {
        FYLog(NSLocalizedString(@"获取通知公告出错 => \n%@", nil), error);
        !then ?: then(NO,[FYGamesNoticeModel buildingDataModles]);
    }];
}


#pragma mark - ZJScrollPageViewDelegate

- (NSInteger)numberOfChildViewControllers
{
    return self.tabTitles.count;
}

- (UIViewController<ZJScrollPageViewChildVcDelegate> *)childViewController:(UIViewController<ZJScrollPageViewChildVcDelegate> *)reuseViewController forIndex:(NSInteger)index
{
    // TODO: 在子类中处理
    
    UIViewController<ZJScrollPageViewChildVcDelegate> *childViewController = reuseViewController;
    if (!childViewController) {
        childViewController = [[FYGamesClassViewController alloc] init];
        if ([childViewController isKindOfClass:[FYGamesClassViewController class]]) {
            FYGamesClassViewController *viewController = (FYGamesClassViewController *)childViewController;
            [viewController setDelegate:self];
            [viewController resetSubScrollViewSize:CGSizeMake(self.view.bounds.size.width, self.view.bounds.size.height-self.tableSectionHeaderHeight)];
        } else {
            NSString *message = [NSString stringWithFormat:NSLocalizedString(@"[%@]基类必须是[FYGamesClassViewController]，请进行修改。", nil), self.tabTitles[index]];
            NSAssert(NO, message);
        }
    }
    // 保存当前选中的游戏分类下标
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
        [[NSNotificationCenter defaultCenter] postNotificationName:FYGamesClassParentTableViewDidLeaveFromTopNotification object:nil];
    } else {
        self.tableView.contentOffset = CGPointMake(0.0f, self.tableHeaderHeight);
    }
}


#pragma mark - FYGamesClassViewControllerDelegate

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


#pragma mark - UITableViewDelegate, UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFIER_GAMES_MAIN_TABLEVIEW_CLASS_CONTENT];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELL_IDENTIFIER_GAMES_MAIN_TABLEVIEW_CLASS_CONTENT];
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

- (NSString *)prefersNavigationBarTitleViewTitle
{
    return STR_NAVIGATION_BAR_TITLE_GAMES;
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
    return ICON_NAV_BAR_BUTTON_REFRESH;
}


#pragma mark - Notification

- (void)dealloc
{
    [self removeObservers];
}

- (void)removeObservers
{
    [NOTIF_CENTER removeObserver:self name:kNotificationGamesMallSDShowHide object:nil];
    [NOTIF_CENTER removeObserver:self name:kNotificationReloadGamesMallList object:nil];
    [NOTIF_CENTER removeObserver:self name:kReloadMyMessageGroupList object:nil];
    [NOTIF_CENTER removeObserver:self name:kNotificationSysMsgOrPlatformNoticeChange object:nil];
    [NOTIF_CENTER removeObserver:self name:kNotificationAppConfigStyleModeChange object:nil];
    [NOTIF_CENTER removeObserver:self];
}

- (void)addNotifications
{
    // 通知 - 游戏大厅广告
    [NOTIF_CENTER addObserver:self selector:@selector(doNotifiGamesMallSdShowHide:) name:kNotificationGamesMallSDShowHide object:nil];
    
    // 通知 - 刷新游戏大厅
    [NOTIF_CENTER addObserver:self selector:@selector(doNotifiReloadGamesMallData:) name:kNotificationReloadGamesMallList object:nil];
    
    // 通知 - 刷新群组信息（显示、隐藏、维护）
    [NOTIF_CENTER addObserver:self selector:@selector(doNotifiRefreshGamesGroupInfo:) name:kReloadMyMessageGroupList object:nil];
    
    // 通知 - 系统消息或通知公告（添加、删除、修改）
    [NOTIF_CENTER addObserver:self selector:@selector(doNotifiRefreshSysMsgOrNotice:) name:kNotificationSysMsgOrPlatformNoticeChange object:nil];
    
    // 通知 - 游戏大厅显示模式切换
    [NOTIF_CENTER addObserver:self selector:@selector(doNotifiGamesMallShowStyleChange:) name:kNotificationAppConfigStyleModeChange object:nil];
}

/// 游戏大厅广告
- (void)doNotifiGamesMallSdShowHide:(NSNotification *)notification
{
    // TODO: 在子类中处理
}

/// 刷新游戏大厅
- (void)doNotifiReloadGamesMallData:(NSNotification *)notification
{
    // TODO: 在子类中处理
}

/// 刷新群组信息（显示、隐藏、维护）
- (void)doNotifiRefreshGamesGroupInfo:(NSNotification *)notification
{
    // TODO: 在子类中处理
}

/// 系统消息或通知公告
- (void)doNotifiRefreshSysMsgOrNotice:(NSNotification *)notification
{
    // TODO: 在子类中处理
}

/// 游戏大厅显示模式切换
- (void)doNotifiGamesMallShowStyleChange:(NSNotification *)notification
{
    // TODO: 在子类中处理
    FY_APPLICAION_MANAGER.isShowSystemNoticeAlterView = NO;
    [APPINFORMATION restRootAnimation:YES];
}


#pragma mark - Getter & Setter

- (FYGamesCustomTableView *)tableView
{
    if (!_tableView) {
        CGRect frame = CGRectMake(0.0f, 0.0f, self.view.bounds.size.width, self.view.bounds.size.height);
        FYGamesCustomTableView *tableView = [[FYGamesCustomTableView alloc] initWithFrame:frame style:UITableViewStylePlain];
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

- (FYGamesBannerNoticeView *)tableSectionHeaderView
{
    if (!_tableSectionHeaderView) {
        _tableSectionHeaderView = [[FYGamesBannerNoticeView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.tableSectionHeaderHeight) headerViewHeight:self.tableSectionHeaderHeight parentViewController:self segmentView:self.segmentView bannerModels:self.arrayOfBannerModels noticeModels:self.arrayOfNoticeModels];
        self.delegate_header = _tableSectionHeaderView;
    }
    return _tableSectionHeaderView;
}

- (ZJScrollSegmentView *)segmentView
{
    if (_segmentView == nil) {
        CGFloat margin = CFC_AUTOSIZING_MARGIN(MARGIN);
        CGFloat left_right_gap = margin*1.5f;
        CGFloat titleMargin = 2.5f;
        CGFloat titleHeight = self.tableSectionSegmentHeight * 0.58f;
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
        style.coverGradualColors = @[ COLOR_HEXSTRING(@"#DF5E43"), COLOR_HEXSTRING(@"#CD3224")];
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
        
        // 游戏菜单小于2时隐藏
        if (!self.tabTitles || self.tabTitles.count < 2) {
            [segment setHidden:YES];
        }
        
        // 分割线
        {
            CGRect frameOfLine = CGRectMake(0,self.tableSectionSegmentHeight-HEIGHT_GAME_MENU_SEPARATOR_LINE, self.view.bounds.size.width, HEIGHT_GAME_MENU_SEPARATOR_LINE);
            UIView *separatorLineView = [[UIView alloc] initWithFrame:frameOfLine];
            [separatorLineView setBackgroundColor:COLOR_GAME_MENU_SEPARATOR_LINE];
            [segment addSubview:separatorLineView];
        }
        
        _segmentView = segment;
    }
    return _segmentView;
}

- (ZJContentView *)contentView
{
    if (_contentView == nil) {
        // CGRect frame = CGRectMake(0.0f, 0.0f, self.view.bounds.size.width, self.view.bounds.size.height - STATUS_NAVIGATION_BAR_HEIGHT - self.tableHeaderHeight - TAB_BAR_AND_DANGER_HEIGHT - self.tableSectionHeaderHeight);
        ZJContentView *content = [[ZJContentView alloc] initWithFrame:self.view.bounds segmentView:self.segmentView parentViewController:self delegate:self];
        _contentView = content;
    }
    return _contentView;
}

- (DGActivityIndicatorView *)activityView
{
    if (!_activityView) {
        CGFloat activityIndicatorSize = CFC_AUTOSIZING_WIDTH(60.0f);
        _activityView = [[DGActivityIndicatorView alloc]
                                  initWithType:DGActivityIndicatorAnimationTypeBallSpinFadeLoader
                                  tintColor:COLOR_UIWEBVIEW_ACTIVITY_INDICATOR_BACKGROUND
                                  size:activityIndicatorSize];
        [self.view insertSubview:_activityView atIndex:0];
        [_activityView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view.mas_centerX);
            make.centerY.equalTo(self.view.mas_centerY);
        }];
    }
    return _activityView;
}


#pragma mark - Private

- (void)doToShowSystemNoticeAlterView:(NSMutableArray<FYGamesNoticeModel *> *)noticeModels
{
    // 只有一条本地创建的数据
    if (noticeModels.count == 1) {
        FYGamesNoticeModel *modle = noticeModels.firstObject;
        if (modle.isLoacl.boolValue) {
            if (FYLoginTypeWeChat == [APPINFORMATION loginType]
                && !APPINFORMATION.userInfo.isBindMobile) {
                [self doToShowBindPhoneViewController];
            }
            return;
        }
    }
    
    // 后台没有一条通知信息 => 此处代码永远不会执行，当后台没有数据，会自动创建一条本地数据，所以 noticeModels.count >= 1。
    if (!noticeModels || noticeModels.count == 0) {
        if (FYLoginTypeWeChat == [APPINFORMATION loginType]
            && !APPINFORMATION.userInfo.isBindMobile) {
            [self doToShowBindPhoneViewController];
        }
        return;
    }
    
    // 弹出通知公告信息框
    __block NSMutableArray<VVAlertModel *> *itemAlertModels = [NSMutableArray<VVAlertModel *> array];
    [noticeModels enumerateObjectsUsingBlock:^(FYGamesNoticeModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        VVAlertModel *alertModel = [VVAlertModel new];
        [alertModel setName:obj.title];
        if (VALIDATE_STRING_EMPTY(obj.content)) {
            [alertModel setFriends:@[@""]];
        } else {
            [alertModel setFriends:@[obj.content]]; // nil 会闪退，需要处理
        }
        [itemAlertModels addObj:alertModel];
    }];
    SystemAlertViewController *alterVC = [SystemAlertViewController alertControllerWithTitle:@"" dataArray:itemAlertModels];
    [alterVC setTitleStr:NSLocalizedString(@"通知公告", nil)];
    [alterVC setCloseCallBack:^(NSInteger index) {
        if (FYLoginTypeWeChat == [APPINFORMATION loginType]
            && !APPINFORMATION.userInfo.isBindMobile) {
            [self doToShowBindPhoneViewController];
        }
    }];
    [[FunctionManager getAppRootViewController] presentViewController:alterVC animated:YES completion:nil];
}

- (void)doToShowBindPhoneViewController
{
    FYPresentAlertViewController *alterVC = [FYPresentAlertViewController alertControllerWithContent:NSLocalizedString(@"检测到您暂未绑定手机号，存在风险，\n请及时设置。", nil)];
    [alterVC setConfirmActionBlock:^{
        // 去绑定
        FY2020ForgetController *viewController = [[FY2020ForgetController alloc] init];
        [viewController setTitle:NSLocalizedString(@"绑定手机", nil)];
        [viewController setIsNeedChangeNavigation:YES];
        [self.navigationController pushViewController:viewController animated:YES];
    }];
    [[FunctionManager getAppRootViewController] presentViewController:alterVC animated:YES completion:nil];
}


@end

