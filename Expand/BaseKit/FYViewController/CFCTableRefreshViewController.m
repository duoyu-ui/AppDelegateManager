
#import "CFCTableRefreshViewController.h"
#import "CFCTableRefreshViewController+EmptyDataSet.h"

@interface CFCTableRefreshViewController () <UITableViewDelegate, UITableViewDataSource>

@end

@implementation CFCTableRefreshViewController

#pragma mark -
#pragma mark 视图生命周期（初始化）
- (instancetype)init
{
    self = [super init];
    if (self) {
        _page = 0;
        _limit = 20;
        _offset = 0;
        
        _isShowLoadingHUD = YES; // 是否显示加载菊花

        _hasTableViewRefresh = YES; // 是否创建表格（默认YES）
        _hasRefreshHeader = YES; // 是否可下拉刷新（默认YES）
        _hasRefreshFooter = YES; // 是否可上拉加载（默认YES）
        _hasRefreshOnce = NO; // 是否只可下拉刷新1次（默认NO）(数据固定的页面使用，如：我的、设置)
        _hasCacheData = NO; // 是否需要加载缓存（默认NO）
        _hasPage = NO; // 是否需要分页（默认NO）
        
        _requestMethod = RequestType_post; // 默认POST请求
        _isRequestNetwork = YES; // 是否需要请求网络数据（默认YES）
        
        _isEmptyDataSetShouldDisplay = NO; // 是否显示EmptyDataSet空白页（默认NO）
        _isEmptyDataSetShouldAllowScroll = YES; // 是否允许滚动（默认YES）
        _isEmptyDataSetShouldAllowImageViewAnimate = YES; // 图片是否要动画效果（默认YES）
        
        _isAutoLayoutSafeAreaTop = YES; // 是否自动适配安全区域（iOS11安全区域）
        _isAutoLayoutSafeAreaBottom = NO; // 是否自动适配安全区域（iOS11安全区域）
    }
    return self;
}

#pragma mark 视图生命周期（加载视图）
- (void)viewDidLoad
{
    [super viewDidLoad];
    
}

#pragma mark 监听网络变化后执行 - 有网络
- (void)viewDidLoadWithNetworkingStatus
{
    // 配置UI界面
    [self createUIRefreshTable:YES];
    
    // 请求网络数据
    if (self.isRequestNetwork) {
        if (self.isShowLoadingHUD) {
            [self loadData];
        } else {
            [self.tableViewRefresh.mj_header beginRefreshing];
        }
    }
}

#pragma mark 监听网络变化后执行 - 无网络
- (void)viewDidLoadWithNoNetworkingStatus
{
    // 配置UI界面
    [self createUIRefreshTable:YES];
    
    // 重新设置可刷新数据
    [self.tableViewRefresh setMj_header:self.tableViewRefreshHeader];
    [self.tableViewRefresh setMj_footer:self.tableViewRefreshFooter];
    
    // 请求网络数据
    if (self.isRequestNetwork) {
        if (self.isShowLoadingHUD) {
            [self loadData];
        } else {
            [self.tableViewRefresh.mj_header beginRefreshing];
        }
    }
}


#pragma mark -
#pragma mark 请求数据 - 下拉刷新数据
- (void)loadData
{
    // 每次刷新时重置
    self.offset = 0;
    self.page = self.offset/self.limit + 1;
    
    // 加载更多数据
    [self loadMoreData];
}

#pragma mark 请求数据 - 上拉加载数据
- (void)loadMoreData
{
    WEAKSELF(weakSelf);
    
    // 加载完数据前，其它操作
    [self viewDidLoadBeforeLoadNetworkDataOrCacheData];
    
    // 验证网络状态，无网则直接返回
    if (![CFCNetworkReachabilityUtil isNetworkAvailable]) {
        
        // 下拉刷新控件，结束刷新状态
        [self.tableViewRefresh.mj_header endRefreshing];
        
        // 上拉刷新控件，结束刷新状态
        [self.tableViewRefresh.mj_footer endRefreshing];
        
        // 没有数据显示空白页面
        [self.tableViewRefresh setMj_footer:nil];
        
        // 刷新表格
        [self.tableViewRefresh reloadData];
        
        // 是否显示EmptyDataSet空白页（默认NO）
        [self setIsEmptyDataSetShouldDisplay:YES];
        
        // 刷新加载EmptyDataSet空白页
        [self.tableViewRefresh reloadEmptyDataSet];
        
       
        
        // 加载完数据后，其它操作
        [self viewDidLoadAfterLoadNetworkDataOrCacheData];
    
    } else {
        
        // 请求数据
        [self loadNetworkDataThen:^(BOOL success, BOOL isCache, NSUInteger count){
            
            if (isCache) {
                
                // 加载成功
                if (success && count > 0) {
                    
                    // 刷新表格
                    [weakSelf.tableViewRefresh reloadData];
                    
                } else {
                    
                    // 刷新表格
                    [weakSelf.tableViewRefresh reloadData];
                    
                    // 是否显示EmptyDataSet空白页（默认NO）
                    [weakSelf setIsEmptyDataSetShouldDisplay:YES];
                    
                    // 刷新加载EmptyDataSet空白页
                    [weakSelf.tableViewRefresh reloadEmptyDataSet];
                    
                }
                
            } else {
                
                // 没有数据显示空白页面
                if (count > 0 || (count == 0 && weakSelf.offset > 0)) {
                    [weakSelf.tableViewRefresh setMj_footer:weakSelf.tableViewRefreshFooter];
                } else {
                    [weakSelf.tableViewRefresh setMj_footer:nil];
                }
                
                if (count < weakSelf.limit) {
                    
                    // 下拉刷新控件，没有更多数据
                    [weakSelf.tableViewRefresh.mj_header endRefreshing];
                    
                    // 上拉刷新控件，没有更多数据
                    [weakSelf.tableViewRefresh.mj_footer endRefreshingWithNoMoreData];
                    
                    // 上拉刷新控件，置空（不显示已加载完成数据）
                    // weakSelf.tableViewRefresh.mj_footer = nil;
                    
                } else {
                    
                    // 下拉刷新控件，结束刷新状态
                    [weakSelf.tableViewRefresh.mj_header endRefreshing];
                    
                    // 上拉刷新控件，结束刷新状态
                    [weakSelf.tableViewRefresh.mj_footer endRefreshing];
                    
                    // 上拉刷新控件，重新赋值
                    [weakSelf.tableViewRefreshFooter setState:MJRefreshStateIdle];
                    [weakSelf.tableViewRefresh setMj_footer:weakSelf.tableViewRefreshFooter];
                    
                }
                
                // 加载成功
                if (success && count > 0) {
                    
                    // 刷新表格
                    [weakSelf.tableViewRefresh reloadData];
                    
                    // 增加偏移量
                    if (count < weakSelf.limit) {
                        weakSelf.offset += count;
                    } else {
                        weakSelf.offset += weakSelf.limit;
                    }
                    weakSelf.page = weakSelf.offset/weakSelf.limit + 1;
                    
                    // 是否只可下拉刷新1次（默认NO）
                    if (weakSelf.hasRefreshOnce) {
                        [weakSelf.tableViewRefresh setMj_header:nil];
                        [weakSelf.tableViewRefresh setMj_footer:nil];
                    }
                    
                } else {
                    
                    // 刷新表格
                    [weakSelf.tableViewRefresh reloadData];
                    
                    // 是否显示EmptyDataSet空白页（默认NO）
                    [weakSelf setIsEmptyDataSetShouldDisplay:YES];
                    
                    // 刷新加载EmptyDataSet空白页
                    [weakSelf.tableViewRefresh reloadEmptyDataSet];
                    
                }
            }
            
    
            
            // 加载完数据后，其它操作
            [weakSelf viewDidLoadAfterLoadNetworkDataOrCacheData];
            
        }];
        
    }
}

#pragma mark 请求数据 - 请求地址（子类继承实现）
- (Act)getRequestInfoAct
{
    return ActNil;
}

#pragma mark 请求数据 - 请求参数（子类继承实现）
- (NSMutableDictionary *)getRequestParamerter
{
    return [NSMutableDictionary dictionary];
}

#pragma mark 请求数据 - 请求网络数据（请求逻辑处理）
- (void)loadNetworkDataThen:(void (^)(BOOL success, BOOL isCache, NSUInteger count))then
{
    WEAKSELF(weakSelf);
    
    // 请求数据是否成功
    __block BOOL isCache = NO;
    __block BOOL isSuccess = NO;
    __block NSUInteger listCount = 0; // 请求到的数据数量
    __block NSString *showMessage = self.isShowLoadingHUD ? self.showLoadingMessage : nil;
    
    // 请求地址与参数
    Act actInfo = [weakSelf getRequestInfoAct];
    NSMutableDictionary *params = [weakSelf getRequestParamerter];
    
    // 验证请求连接的正确性
    if (ActNil == actInfo) {
        // 刷新界面
        !then ?: then(isSuccess, isCache, listCount);
        return ;
    }
    
    // 数据分页处理
    if (self.hasPage) {
        [params setObject:[NSNumber numberWithInteger:_page].stringValue forKey:@"current"];
        [params setObject:[NSNumber numberWithInteger:_limit].stringValue forKey:@"size"];
        [params setObject:[NSNumber numberWithInteger:_offset].stringValue forKey:@"offset"];
    }

    // 显示加载菊花
    if (self.isShowLoadingHUD) {
        if ([CFCSysUtil validateStringEmpty:showMessage]) {
            PROGRESS_HUD_SHOW
        } else {
            PROGRESS_HUD_SHOW_STATUS(showMessage)
        }
    }
    
    // 请求网络数据
    [NET_REQUEST_MANAGER requestWithAct:actInfo requestType:self.requestMethod parameters:params success:^(id responseObject) {
        
        // 设置缓存标识
        isCache = NO;
        
        // 加载解析网络数据
        NSMutableArray *responseTableData = [weakSelf loadNetworkDataOrCacheData:responseObject isCacheData:NO];
        
        // 更新请求数据状态
        listCount = responseTableData.count - (weakSelf.page-1)*weakSelf.limit;
        if (listCount > 0) {
            isSuccess = YES;
          
        } else {
            isSuccess = YES;
           
        }
        
        // 刷新界面
        !then ?: then(isSuccess, isCache, listCount);
        
        // 关闭停止菊花
        if (self.isShowLoadingHUD) {
            PROGRESS_HUD_DISMISS
        }
        
        // 第一次加载数据后禁止显示菊花
        self.isShowLoadingHUD = NO;

    } failure:^(id error) {
        
       
        
        // 加载解析网络数据
        [weakSelf loadNetworkDataOrCacheData:error isCacheData:NO];
        
        // 设置缓存标识
        isCache = NO;
        
        // 刷新界面
        !then ?: then(isSuccess, isCache, listCount);
        
        // 关闭停止菊花
        if (self.isShowLoadingHUD) {
            PROGRESS_HUD_DISMISS
        }
        
        // 第一次加载数据后禁止显示菊花
        self.isShowLoadingHUD = NO;
        
        // 弹出提示信息
        ALTER_HTTP_ERROR_MESSAGE(error);
    }];

}

#pragma mark 请求数据 - 请求网络数据或加载缓存（子类继承实现处理过程）
- (NSMutableArray *)loadNetworkDataOrCacheData:(id)responseDataOrCacheData isCacheData:(BOOL)isCacheData
{
    
    return nil;
}


#pragma mark 请求数据 - 加载完数据前，其它操作，每次刷新加载数据前都会执行
- (void)viewDidLoadBeforeLoadNetworkDataOrCacheData
{
    
}

#pragma mark 请求数据 - 加载完数据后，其它操作，每次刷新加载数据后都会执行
- (void)viewDidLoadAfterLoadNetworkDataOrCacheData
{
    
}


#pragma mark -
#pragma mark 创建界面表格
- (void)createUIRefreshTable:(BOOL)force
{
    // 是否创建表格
    if (!_hasTableViewRefresh) {
        return;
    }
    
    // 表格已经存在则无需创建，直接返回；否则强制创建表格
    if (self.tableViewRefresh && !force) {
        return;
    }
    
    // 强制创建表格
    if (force && self.tableViewRefresh) {
        [self.tableViewRefresh removeFromSuperview];
        [self setTableViewRefresh:nil];
    }
    
    // 表格已经存在则无需创建，直接返回；否则强制创建表格
    if (self.tableViewRefresh && !force) {
        return;
    }
    
    // 创建表格
    {
        // 设置表格
        self.tableViewRefresh = [[UITableView alloc] initWithFrame:CGRectZero style:[self tableViewRefreshStyle]];
        self.tableViewRefresh.delegate = self;
        self.tableViewRefresh.dataSource = self;
        self.tableViewRefresh.estimatedRowHeight = 200;
        // 设置后在 iPhone5 上报错
        self.tableViewRefresh.sectionHeaderHeight = FLOAT_MIN;
        self.tableViewRefresh.sectionFooterHeight = FLOAT_MIN;
        self.tableViewRefresh.fd_debugLogEnabled = YES;
        self.tableViewRefresh.showsVerticalScrollIndicator = YES;
        self.tableViewRefresh.backgroundColor = [UIColor whiteColor];
        self.tableViewRefresh.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:self.tableViewRefresh];
        
        // 空白页展示
        self.tableViewRefresh.emptyDataSetSource = self;
        self.tableViewRefresh.emptyDataSetDelegate = self;
        
        // 计算表格位置
        switch ([self preferredNavigationBarType]) {
                // 系统导航栏
            case CFCNavBarTypeDefault: {
                if ([self prefersNavigationBarHidden]) {
                    // 系统导航栏已隐藏-自定义导航栏UINavigationBar
                    [self.tableViewRefresh setFrame:CGRectMake(0, STATUS_BAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT-STATUS_BAR_HEIGHT)];
                    if (CFC_IS_IPHONE_X_OR_GREATER) {
                        [self.tableViewRefresh mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.left.equalTo(self.view.mas_left);
                            make.right.equalTo(self.view.mas_right);
                            if (@available(iOS 11.0, *)) {
                                if (self.isAutoLayoutSafeAreaTop) {
                                    make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
                                } else {
                                    make.top.equalTo(self.view.mas_top).with.offset(0.0);
                                }
                                if (self.isAutoLayoutSafeAreaBottom) {
                                    make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
                                } else {
                                    make.bottom.equalTo(self.view.mas_bottom).with.offset(0.0);
                                }
                            } else {
                                make.top.equalTo(self.view.mas_top).with.offset(0.0);
                                make.bottom.equalTo(self.view.mas_bottom).with.offset(0.0);
                            }
                        }];
                    } else {
                        [self.tableViewRefresh mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.left.equalTo(self.view.mas_left);
                            make.right.equalTo(self.view.mas_right);
                            make.top.equalTo(self.mas_topLayoutGuide).with.offset(0.0);
                            make.bottom.equalTo(self.mas_bottomLayoutGuide).with.offset(0.0);
                        }];
                    }
                } else {
                    // 系统导航栏未隐藏-自定义导航栏TitleView
                    [self.tableViewRefresh setFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-STATUS_NAVIGATION_BAR_HEIGHT)];
                    if (CFC_IS_IPHONE_X_OR_GREATER) {
                        [self.tableViewRefresh mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.left.equalTo(self.view.mas_left);
                            make.right.equalTo(self.view.mas_right);
                            if (@available(iOS 11.0, *)) {
                                if (self.isAutoLayoutSafeAreaTop) {
                                    make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
                                } else {
                                    make.top.equalTo(self.view.mas_top).with.offset(0.0);
                                }
                                if (self.isAutoLayoutSafeAreaBottom) {
                                    make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
                                } else {
                                    make.bottom.equalTo(self.view.mas_bottom).with.offset(0.0);
                                }
                            } else {
                                make.top.equalTo(self.view.mas_top).with.offset(0.0);
                                make.bottom.equalTo(self.view.mas_bottom).with.offset(0.0);
                            }
                        }];
                    } else {
                        [self.tableViewRefresh mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.left.equalTo(self.view.mas_left);
                            make.right.equalTo(self.view.mas_right);
                            make.top.equalTo(self.mas_topLayoutGuide).with.offset(0.0);
                            make.bottom.equalTo(self.mas_bottomLayoutGuide).with.offset(0.0);
                        }];
                    }
                }
                break;
            }
                // 自定义导航栏
            case CFCNavBarTypeCustom: {
                if ([self prefersNavigationBarHidden]) {
                    // 系统导航栏已隐藏-自定义导航栏UINavigationBar
                    [self.tableViewRefresh setFrame:CGRectMake(0, STATUS_BAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT-STATUS_BAR_HEIGHT)];
                    if (CFC_IS_IPHONE_X_OR_GREATER) {
                        [self.tableViewRefresh mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.left.equalTo(self.view.mas_left);
                            make.right.equalTo(self.view.mas_right);
                            if (@available(iOS 11.0, *)) {
                                if (self.isAutoLayoutSafeAreaTop) {
                                    make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
                                } else {
                                    make.top.equalTo(self.view.mas_top).with.offset(0.0);
                                }
                                if (self.isAutoLayoutSafeAreaBottom) {
                                    make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
                                } else {
                                    make.bottom.equalTo(self.view.mas_bottom).with.offset(0.0);
                                }
                            } else {
                                make.top.equalTo(self.view.mas_top).with.offset(0.0);
                                make.bottom.equalTo(self.view.mas_bottom).with.offset(0.0);
                            }
                        }];
                    } else {
                        [self.tableViewRefresh mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.left.equalTo(self.view.mas_left);
                            make.right.equalTo(self.view.mas_right);
                            make.top.equalTo(self.mas_topLayoutGuide).with.offset(0.0);
                            make.bottom.equalTo(self.mas_bottomLayoutGuide).with.offset(0.0);
                        }];
                    }
                } else {
                    // 系统导航栏未隐藏-自定义导航栏TitleView
                    [self.tableViewRefresh setFrame:CGRectMake(0, STATUS_NAVIGATION_BAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT-STATUS_NAVIGATION_BAR_HEIGHT)];
                    if (CFC_IS_IPHONE_X_OR_GREATER) {
                        [self.tableViewRefresh mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.left.equalTo(self.view.mas_left);
                            make.right.equalTo(self.view.mas_right);
                            if (@available(iOS 11.0, *)) {
                                if (self.isAutoLayoutSafeAreaTop) {
                                    make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop).offset(NAVIGATION_BAR_HEIGHT);
                                } else {
                                    make.top.equalTo(self.view.mas_top).with.offset(NAVIGATION_BAR_HEIGHT);
                                }
                                if (self.isAutoLayoutSafeAreaBottom) {
                                    make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
                                } else {
                                    make.bottom.equalTo(self.view.mas_bottom).with.offset(0.0);
                                }
                            } else {
                                make.top.equalTo(self.view.mas_top).with.offset(0.0);
                                make.bottom.equalTo(self.view.mas_bottom).with.offset(0.0);
                            }
                        }];
                    } else {
                        [self.tableViewRefresh mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.left.equalTo(self.view.mas_left);
                            make.right.equalTo(self.view.mas_right);
                            make.top.equalTo(self.mas_topLayoutGuide).with.offset(NAVIGATION_BAR_HEIGHT);
                            make.bottom.equalTo(self.mas_bottomLayoutGuide).with.offset(0.0);
                        }];
                    }
                }
                break;
            }
            default: {
                break;
            }
        }
        
        // 设置背景
        UIView *backgroundView = [[UIView alloc] init];
        [backgroundView setBackgroundColor:COLOR_TABLEVIEW_BACK_VIEW_BACKGROUND_DEFAULT];
        [self.tableViewRefresh setBackgroundView:backgroundView];
        [self.tableViewRefresh setBackgroundColor:COLOR_TABLEVIEW_BACK_VIEW_BACKGROUND_DEFAULT];
        
        // 表头表尾
        [self.tableViewRefresh setTableHeaderView:[[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, FLOAT_MIN)]];
        [self.tableViewRefresh setTableFooterView:[[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, FLOAT_MIN)]];
        
        // 下拉刷新
        if (self.hasRefreshHeader) {
            CFCRefreshHeader *refreshHeader = [CFCRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
            [refreshHeader setTitle:CFCRefreshAutoHeaderIdleText forState:MJRefreshStateIdle];
            [refreshHeader setTitle:CFCRefreshAutoHeaderPullingText forState:MJRefreshStatePulling];
            [refreshHeader setTitle:CFCRefreshAutoHeaderRefreshingText forState:MJRefreshStateRefreshing];
            [refreshHeader.stateLabel setTextColor:COLOR_HEXSTRING(CFCRefreshAutoHeaderColor)];
            [refreshHeader.stateLabel setFont:[UIFont systemFontOfSize:CFC_AUTOSIZING_FONT(CFCRefreshAutoFooterFontSize)]];
            [refreshHeader setBackgroundColor:COLOR_TABLEVIEW_BACK_VIEW_BACKGROUND_DEFAULT];
            [self setTableViewRefreshHeader:refreshHeader];
            [self.tableViewRefresh setMj_header:refreshHeader];
        }
        
        // 上拉加载
        if (self.hasRefreshFooter) {
            CFCRefreshFooter *refreshFooter = [CFCRefreshFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
            [refreshFooter setTitle:CFCRefreshAutoFooterIdleText forState:MJRefreshStateIdle];
            [refreshFooter setTitle:CFCRefreshAutoFooterRefreshingText forState:MJRefreshStateRefreshing];
            [refreshFooter setTitle:CFCRefreshAutoFooterNoMoreDataText forState:MJRefreshStateNoMoreData];
            [refreshFooter.stateLabel setTextColor:COLOR_HEXSTRING(CFCRefreshAutoFooterColor)];
            [refreshFooter.stateLabel setFont:[UIFont systemFontOfSize:CFC_AUTOSIZING_FONT(CFCRefreshAutoFooterFontSize)]];
            [refreshFooter setBackgroundColor:COLOR_TABLEVIEW_BACK_VIEW_BACKGROUND_DEFAULT];
            [self setTableViewRefreshFooter:refreshFooter];
        }
        
        // 设置 UITableView
        [self tableViewRefreshSetting:self.tableViewRefresh];
        
        // 必须被注册到 UITableView 中
        [self tableViewRefreshRegisterClass:self.tableViewRefresh];
    }
}

#pragma mark 设置 UITableView（子类继承实现）
- (void)tableViewRefreshSetting:(UITableView *)tableView
{
    
}

#pragma mark 注册 UITableViewCell（子类继承实现）
- (void)tableViewRefreshRegisterClass:(UITableView *)tableView
{
    
}

#pragma mark 设置 UITableView 表格类型
- (UITableViewStyle)tableViewRefreshStyle
{
    return UITableViewStyleGrouped;
}

#pragma mark 数据模型
- (NSMutableArray *)tableDataRefresh
{
    if (!_tableDataRefresh) {
        _tableDataRefresh = [NSMutableArray array];
    }
    return _tableDataRefresh;
}


#pragma mark -
#pragma mark 销毁释放资源
- (void)dealloc
{
    
}


#pragma mark -
#pragma mark 设置导航条样式类型
- (CFCNavBarType)preferredNavigationBarType
{
    return CFCNavBarTypeDefault;
}


#pragma mark -
#pragma mark UITableViewDelegate UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 0.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return FLOAT_MIN;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    CGFloat height = 0.01f;
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableViewRefresh.frame.size.width, height)];
    [headerView setBackgroundColor:COLOR_TABLEVIEW_HEADER_VIEW_BACKGROUND_DEFAULT];
    
    return headerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    CGFloat height = 0.01f;
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableViewRefresh.frame.size.width, height)];
    [footerView setBackgroundColor:COLOR_TABLEVIEW_FOOTER_VIEW_BACKGROUND_DEFAULT];
    
    return footerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return FLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return FLOAT_MIN;
}


#pragma mark - Helper Method

- (void)scrollTableToTopAnimated:(BOOL)animated
{
    if (!self.tableDataRefresh || self.tableDataRefresh.count <= 0) {
        return;
    }
    
    [self.tableViewRefresh scrollTableToTopAnimated:animated];
}

- (void)scrollTableToBottomAnimated:(BOOL)animated
{
    if (!self.tableDataRefresh || self.tableDataRefresh.count <= 0) {
        return;
    }
    
    [self.tableViewRefresh scrollTableToBottomAnimated:animated];
}


@end




