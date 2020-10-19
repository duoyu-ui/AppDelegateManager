
#import "CFCBaseCoreViewController.h"

@interface CFCTableRefreshViewController : CFCBaseCoreViewController

@property (nonatomic, strong) UITableView * _Nullable tableViewRefresh; // UITableView表格

@property (nonatomic, strong) NSMutableArray * _Nullable tableDataRefresh; // UITableView数据源

@property (nonatomic, strong) MJRefreshHeader * _Nullable tableViewRefreshHeader; // 下拉刷新控件

@property (nonatomic, strong) MJRefreshFooter * _Nullable tableViewRefreshFooter; // 上拉刷新控件

@property (nonatomic, strong) NSString * _Nullable showLoadingMessage; // 加载提示文字（默认空）

@property (nonatomic, assign) BOOL isShowLoadingHUD; // 是否显示加载菊花（默认YES）

@property (nonatomic, assign) BOOL hasTableViewRefresh; // 是否创建UITableView表格（默认创建）

@property (nonatomic, assign) BOOL hasRefreshHeader; // 是否可下拉刷新（默认YES）

@property (nonatomic, assign) BOOL hasRefreshFooter; // 是否可上拉刷新（默认YES）

@property (nonatomic, assign) BOOL hasRefreshOnce; // 是否只可下拉刷新1次（默认NO）(数据固定的页面使用，如：我的、设置)

@property (nonatomic, assign) BOOL hasCacheData; // 是否需要加载缓存（默认NO）

@property (nonatomic, assign) BOOL hasPage; // 是否需要分页（默认NO）

@property (nonatomic, assign) NSUInteger page; // 页数

@property (nonatomic, assign) NSUInteger limit; // 数量限制

@property (nonatomic, assign) NSUInteger offset; // 数据偏移量

@property (nonatomic, assign) RequestType requestMethod; // 请求方式

@property (nonatomic, assign) BOOL isRequestNetwork; // 是否需要请求网络数据（默认YES）

@property (nonatomic, assign) BOOL isEmptyDataSetShouldDisplay; // 是否显示EmptyDataSet空白页（默认NO）

@property (nonatomic, assign) BOOL isEmptyDataSetShouldAllowScroll; // 是否允许滚动（默认YES）

@property (nonatomic, assign) BOOL isEmptyDataSetShouldAllowImageViewAnimate; // 图片是否要动画效果（默认YES）

@property (nonatomic, assign) BOOL isAutoLayoutSafeAreaTop; // 是否自动适配安全区域（iOS11安全区域）

@property (nonatomic, assign) BOOL isAutoLayoutSafeAreaBottom; // 是否自动适配安全区域（iOS11安全区域）


#pragma mark -
#pragma mark 请求数据 - 下拉刷新数据
- (void)loadData;

#pragma mark 请求数据 - 上拉加载数据
- (void)loadMoreData;

#pragma mark 请求数据 - 请求地址（子类继承实现）
- (Act)getRequestInfoAct;

#pragma mark 请求数据 - 请求参数（子类继承实现）
- (NSMutableDictionary *_Nullable)getRequestParamerter;

#pragma mark 请求数据 - 请求网络数据（请求逻辑处理）
- (void)loadNetworkDataThen:(void (^_Nullable)(BOOL success, BOOL isCache, NSUInteger count))then;

#pragma mark 请求数据 - 请求网络数据或加载缓存（子类继承实现处理过程）
- (NSMutableArray *_Nullable)loadNetworkDataOrCacheData:(id _Nullable)responseDataOrCacheData isCacheData:(BOOL)isCacheData;

#pragma mark 请求数据 - 加载完数据前，其它操作，每次刷新加载数据前都会执行
- (void)viewDidLoadBeforeLoadNetworkDataOrCacheData;

#pragma mark 请求数据 - 加载完数据后，其它操作，每次刷新加载数据后都会执行
- (void)viewDidLoadAfterLoadNetworkDataOrCacheData;


#pragma mark -
#pragma mark 创建界面表格
- (void)createUIRefreshTable:(BOOL)force;

#pragma mark 设置 UITableView（子类继承实现）
- (void)tableViewRefreshSetting:(UITableView * _Nonnull)tableView;

#pragma mark 注册 UITableViewCell（子类继承实现）
- (void)tableViewRefreshRegisterClass:(UITableView * _Nonnull)tableView;

#pragma mark 设置 UITableView 表格类型
- (UITableViewStyle)tableViewRefreshStyle;


#pragma mark -
#pragma mark UITableViewDelegate UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView * _Nonnull)tableView;
- (NSInteger)tableView:(UITableView * _Nonnull)tableView numberOfRowsInSection:(NSInteger)section;
- (UITableViewCell * _Nullable)tableView:(UITableView * _Nonnull)tableView cellForRowAtIndexPath:(NSIndexPath * _Nonnull)indexPath;
- (CGFloat)tableView:(UITableView * _Nonnull)tableView heightForRowAtIndexPath:(NSIndexPath * _Nonnull)indexPath;
- (UIView * _Nullable)tableView:(UITableView * _Nonnull)tableView viewForHeaderInSection:(NSInteger)section;
- (UIView * _Nullable)tableView:(UITableView * _Nonnull)tableView viewForFooterInSection:(NSInteger)section;
- (CGFloat)tableView:(UITableView * _Nonnull)tableView heightForHeaderInSection:(NSInteger)section;
- (CGFloat)tableView:(UITableView * _Nonnull)tableView heightForFooterInSection:(NSInteger)section;


#pragma mark - Helper Method
- (void)scrollTableToTopAnimated:(BOOL)animated;
- (void)scrollTableToBottomAnimated:(BOOL)animated;


@end


