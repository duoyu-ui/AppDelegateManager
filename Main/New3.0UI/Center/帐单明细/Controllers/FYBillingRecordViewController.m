//
//  FYBillingRecordViewController.m
//  ProjectCSHB
//
//  Created by fangyuan on 2020/6/21.
//  Copyright © 2020 Fangyuan. All rights reserved.
//
// 账单
//

#import "FYBillingRecordViewController+EmptyDataSet.h"
#import "FYBillingRecordViewController.h"
#import "FYBillingRecordSectionHeader.h"
#import "FYBillingRecordTableViewCell.h"
#import "FYBillingProfitLossModel.h"
#import "FYBillingRecordModel.h"
//
#import "FYBillingQueryModle.h"
#import "FYBillingSearchClassModel.h"
#import "FYBillingSearchFilterModel.h"
#import "FYBillingDetailsViewController.h"
#import "FYDatePickerViewController.h"


@interface FYBillingRecordViewController () <FYBillingRecordSectionHeaderDelegate, FYBillingRecordTableViewCellDelegate>
//
@property (nonatomic, strong) FYBillingRecordSectionHeader *tableSectionHeader; // 头部控件
@property (nonatomic, strong) NSMutableArray<FYBillingQueryModle *> *arrayOfBillingQueryModels; // 分类和筛选原始数据
@property (nonatomic, strong) FYBillingProfitLossModel *billingProfitLossModel; // 收入盈亏
//
@property (nonatomic, strong) NSArray<NSString *> *currentClassIds; // 当前选中的分类Ids
@property (nonatomic, strong) NSArray<NSString *> *currentFilterIds; // 当前选中的筛选Ids
// 查询接口参数
@property (nonatomic, assign) FYDatePickerTimeType datePickerTimeType; // 时间选择类型（按月选择 or 按日选择）
@property (nonatomic, copy) NSString *datePickerYearMonthTitleFormat; // 按月选择，日期格式 - 标题
@property (nonatomic, copy) NSString *datePickerYearMonthContentFormat; // 按月选择，日期格式 - 内容
@property (nonatomic, copy) NSString *datePickerStartEndTimeTitleFormat; // 按日选择，日期格式 - 标题
@property (nonatomic, copy) NSString *datePickerStartEndTimeContentFormat; // 按日选择，日期格式 - 内容
//
@property (nonatomic, strong) NSArray<NSString *> *queryInfoIds; // 查询ID数据
@property (nonatomic, copy) NSString *queryStartTime; // 按日查询 - 开始时间
@property (nonatomic, copy) NSString *queryEndTime; // 按日查询 - 结束时间
@property (nonatomic, copy) NSString *queryTime; // 按月查询
@property (nonatomic, copy) NSString *queryMinMoney; // 查询最小金额
@property (nonatomic, copy) NSString *queryMaxMoney; // 查询最大金额
//
@property (nonatomic, assign) BOOL isFirstLoading; // 是否是第一次加载

@end


@implementation FYBillingRecordViewController


#pragma mark - Actions

- (void)didSelectRowAtBillingRecordModel:(FYBillingRecordModel *)model indexPath:(NSIndexPath *)indexPath
{
    /*
      FYBillingDetailsViewController *VC = [[FYBillingDetailsViewController alloc] init];
      [self.navigationController pushViewController:VC animated:YES];
    */
}


#pragma mark - Life Cycle

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.datePickerTimeType = FYDatePickerTimeTypeYearMonth;
        self.datePickerYearMonthTitleFormat = kFYDatePickerFormatYearMonth;
        self.datePickerYearMonthContentFormat = kFYDatePickerFormatYearMonth;
        self.datePickerStartEndTimeTitleFormat = kFYDatePickerFormatYearMonthDay;
        self.datePickerStartEndTimeContentFormat = kFYDatePickerFormatYearMonthDay;
        //
        self.queryInfoIds = @[];
        self.queryMinMoney = STR_BILLING_FILTER_MONEY_MIN_VALUE;
        self.queryMaxMoney = STR_BILLING_FILTER_MONEY_MAX_VALUE;
        self.queryStartTime = @""; // 按日查询 - 开始时间
        self.queryEndTime = @"";  // 按日查询 - 结束时间
        self.queryTime = [[NSDate today] stringFromDateWithFormat:self.datePickerYearMonthContentFormat];
        //
        self.currentClassIds = @[]; // 当前选中的分类Id
        self.currentFilterIds = @[]; // 当前选中的筛选Id
        //
        self.hasPage = YES;
        self.isFirstLoading = YES;
        self.isAutoLayoutSafeAreaBottom = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    // 隐藏导航栏底线
    [self.navigationBarHairlineImageView setHidden:YES];
}

- (UITableViewStyle)tableViewRefreshStyle
{
    return UITableViewStylePlain;
}

- (void)tableViewRefreshRegisterClass:(UITableView *)tableView
{
    [self.tableViewRefresh registerClass:[FYBillingRecordTableViewCell class] forCellReuseIdentifier:[FYBillingRecordTableViewCell reuseIdentifier]];
}


#pragma mark - Network

- (void)loadData
{
    [self loadRequestDataThen:^{
        [super loadData];
    }];
}

- (Act)getRequestInfoAct
{
    return ActRequestBillingRecordQuery;
}

- (NSMutableDictionary *)getRequestParamerter
{
    NSMutableDictionary *queryParam = [self getRequestQueryParamerter];
    return @{ @"queryParam" : queryParam }.mutableCopy;
}

- (NSMutableDictionary *)getRequestQueryParamerter
{
    NSMutableDictionary *queryParam = [NSMutableDictionary dictionary];
    
    // 调账记录（特殊处理）
    if ([self.currentClassIds containsObject:STR_BILLING_FILTER_CLASS_ID_TRANSFER]) {
        // 调账记录，只选一个时，处理 adjustmentFlag 参数
        if (self.currentFilterIds.count == 1) {
            [queryParam setObject:self.currentFilterIds.firstObject forKey:@"adjustmentFlag"];
        }
        self.queryInfoIds = @[ self.queryInfoIds.firstObject ];
    }
    
    // 请求参数处理
    if (FYDatePickerTimeTypeStartEndTime == self.datePickerTimeType) {
        // 按开始结束时间查询
        [queryParam setObject:self.queryInfoIds forKey:@"infoIdList"];
        [queryParam setObject:@"" forKey:@"time"];
        [queryParam setObject:self.queryStartTime forKey:@"startTime"];
        [queryParam setObject:self.queryEndTime forKey:@"endTime"];
        [queryParam setObject:self.queryMinMoney forKey:@"minMoeny"];
        [queryParam setObject:self.queryMaxMoney forKey:@"maxMoeny"];
    } else {
        // 按年月日期时间查询
        [queryParam setObject:self.queryInfoIds forKey:@"infoIdList"];
        [queryParam setObject:self.queryTime forKey:@"time"];
        [queryParam setObject:@"" forKey:@"startTime"];
        [queryParam setObject:@"" forKey:@"endTime"];
        [queryParam setObject:self.queryMinMoney forKey:@"minMoeny"];
        [queryParam setObject:self.queryMaxMoney forKey:@"maxMoeny"];
    }
    return queryParam;
}

- (void)loadRequestDataThen:(void (^)(void))then
{
    if (self.isShowLoadingHUD) {
        PROGRESS_HUD_SHOW
    }
    
    // 分类 + 筛选
    [self loadRequestQueryDataThen:^(BOOL success, NSMutableArray<FYBillingQueryModle *> *itemArrayOfBillingQueryModels) {
        // 分类 + 筛选 => 默认选择项
        [self loadRequestQueryParamInitThen:^(BOOL success, NSMutableArray<FYBillingQueryModle *> *itemArrayOfBillingQueryModels) {
            // 收入盈亏
            [self loadRequestProfitLossMoneyThen:^(BOOL success, FYBillingProfitLossModel *billingProfitLossModel) {
                if (self.isShowLoadingHUD) {
                    PROGRESS_HUD_DISMISS
                }
                !then ?: then();
            }];
        }];
    }];
}

- (void)loadRequestQueryDataThen:(void (^)(BOOL success, NSMutableArray<FYBillingQueryModle *> *itemArrayOfBillingQueryModels))then
{
    WEAKSELF(weakSelf)
    [NET_REQUEST_MANAGER requestBillingTypeQueryConditionDataSuccess:^(id response) {
        FYLog(NSLocalizedString(@"筛选条件 => \n%@", nil), response);
        if (!NET_REQUEST_SUCCESS(response)) {
            !then ?: then(NO,nil);
        } else {
            NSArray *arrayOfDicts = NET_REQUEST_DATA(response);
            NSMutableArray<FYBillingQueryModle *> *arrayOfBillingQueryModels = [FYBillingQueryModle mj_objectArrayWithKeyValuesArray:arrayOfDicts];
            weakSelf.arrayOfBillingQueryModels = [NSMutableArray array];
            [weakSelf.arrayOfBillingQueryModels addObjectsFromArray:arrayOfBillingQueryModels];
            [weakSelf.tableSectionHeader setArrayOfBillQueryModels:arrayOfBillingQueryModels];
            !then ?: then(YES,arrayOfBillingQueryModels);
        }
    } failure:^(id error) {
        ALTER_HTTP_ERROR_MESSAGE(error)
        FYLog(NSLocalizedString(@"获取筛选条件异常！ => \n%@", nil), error);
        !then ?: then(NO,nil);
    }];
}

- (void)loadRequestQueryParamInitThen:(void (^)(BOOL success, NSMutableArray<FYBillingQueryModle *> *itemArrayOfBillingQueryModels))then
{
    // 初始化默认选中的分类（查询参数）
    if (self.isFirstLoading && !VALIDATE_STRING_EMPTY(self.selectClassId)) {
        NSArray<NSString *> *classIds = @[ self.selectClassId ];
        NSArray<NSString *> *classTitles = [FYBillingSearchClassModel getClassTitlesByClassIds:classIds dataModles:self.arrayOfBillingQueryModels];
        NSArray<NSString *> *queryInfoIds = [FYBillingSearchClassModel getQueryInfoIdsByClassIds:classIds dataModles:self.arrayOfBillingQueryModels];
        //
        [self setIsFirstLoading:NO];
        [self setCurrentClassIds:classIds];
        [self setQueryInfoIds:queryInfoIds];
        if (classTitles && classTitles.count > 0) {
            if (self.delegate_header && [self.delegate_header respondsToSelector:@selector(doRefreshSectionHeaderBillingClassButtonTitle:)]) {
                [self.delegate_header doRefreshSectionHeaderBillingClassButtonTitle:classTitles.firstObject];
            }
        }
    }
    
    !then ?: then(YES,self.arrayOfBillingQueryModels);
}

- (void)loadRequestProfitLossMoneyThen:(void (^)(BOOL success, FYBillingProfitLossModel *billingProfitLossModel))then
{
    WEAKSELF(weakSelf)
    NSMutableDictionary *queryParam = [self getRequestQueryParamerter];
    [NET_REQUEST_MANAGER requestBillingProfitLossMoney:queryParam success:^(id response) {
        FYLog(NSLocalizedString(@"账单盈亏 => \n%@", nil), response);
        if (!NET_REQUEST_SUCCESS(response)) {
            !then ?: then(NO,nil);
        } else {
            NSDictionary *dict = NET_REQUEST_DATA(response);
            FYBillingProfitLossModel *billingProfitLossModel = [FYBillingProfitLossModel mj_objectWithKeyValues:dict];
            [weakSelf setBillingProfitLossModel:billingProfitLossModel];
            !then ?: then(YES,billingProfitLossModel);
        }
    } failure:^(id error) {
        FYLog(NSLocalizedString(@"获取账单盈亏异常！ => \n%@", nil), error);
        !then ?: then(NO,nil);
    }];
}

- (NSMutableArray *)loadNetworkDataOrCacheData:(id)responseDataOrCacheData isCacheData:(BOOL)isCacheData
{
    FYLog(NSLocalizedString(@"账单明细 => \n%@", nil), responseDataOrCacheData);
    
    // 请求成功，解析数据
    if (!NET_REQUEST_SUCCESS(responseDataOrCacheData)) {
        self.tableDataRefresh = @[].mutableCopy;
        return self.tableDataRefresh;
    }

    // 组装数据
    NSDictionary *data = NET_REQUEST_DATA(responseDataOrCacheData);
    NSArray<NSDictionary *> *arrayOfDicts = [data arrayForKey:@"records"];
    NSMutableArray<FYBillingRecordModel *> *allItemModels = [FYBillingRecordModel mj_objectArrayWithKeyValuesArray:arrayOfDicts];

    // 配置数据源
    if (0 == self.offset) {
        self.tableDataRefresh = [NSMutableArray array];
        if (allItemModels && 0 < allItemModels.count) {
            [self.tableDataRefresh addObjectsFromArray:allItemModels];
        }
    } else {
        if (allItemModels && 0 < allItemModels.count) {
            [self.tableDataRefresh addObjectsFromArray:allItemModels];
        }
    }
    
    return self.tableDataRefresh;
}

- (void)viewDidLoadAfterLoadNetworkDataOrCacheData
{
    if (self.delegate_header && [self.delegate_header respondsToSelector:@selector(doRefreshSectionHeaderBillingProfitLossModel:)]) {
        [self.delegate_header doRefreshSectionHeaderBillingProfitLossModel:self.billingProfitLossModel];
    }
}


#pragma mark - UITableViewDelegate, UITableViewDataSource

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
    FYBillingRecordTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:[FYBillingRecordTableViewCell reuseIdentifier]];
    if (cell == nil) {
        cell = [[FYBillingRecordTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[FYBillingRecordTableViewCell reuseIdentifier]];
    }
    cell.delegate = self;
    cell.indexPath = indexPath;
    cell.model = self.tableDataRefresh[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.tableViewRefresh fd_heightForCellWithIdentifier:[FYBillingRecordTableViewCell reuseIdentifier] cacheByIndexPath:indexPath configuration:^(FYBillingRecordTableViewCell *cell) {
        cell.model = self.tableDataRefresh[indexPath.row];
    }];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return self.tableSectionHeader;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableViewRefresh.frame.size.width, CFC_AUTOSIZING_MARGIN(MARGIN))];
    [footerView setBackgroundColor:COLOR_TABLEVIEW_FOOTER_VIEW_BACKGROUND_DEFAULT];
    return footerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return [FYBillingRecordSectionHeader headerViewHeight];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return FLOAT_MIN;
}


#pragma mark - FYBillingRecordSectionHeaderDelegate

- (void)doRefreshBillingRecordWithClassIds:(NSArray<NSString *> *)classIds filterIds:(NSArray<NSString *> *)filterIds queryInfoIds:(NSArray<NSString *> *)queryInfoIds
{
    [self setCurrentClassIds:classIds];
    [self setCurrentFilterIds:filterIds];
    [self setQueryInfoIds:queryInfoIds];
    //
    [self scrollTableToTopAnimated:NO];
    [self.tableViewRefresh.mj_header beginRefreshing];
}

- (void)doRefreshBillingRecordWithFilterIds:(NSArray<NSString *> *)filterIds queryInfoIds:(NSArray<NSString *> *)queryInfoIds queryMinMoney:(NSString *)queryMinMoney queryMaxMoney:(NSString *)queryMaxMoney
{
    [self setCurrentFilterIds:filterIds];
    [self setQueryInfoIds:queryInfoIds];
    [self setQueryMinMoney:queryMinMoney];
    [self setQueryMaxMoney:queryMaxMoney];
    //
    [self scrollTableToTopAnimated:NO];
    [self.tableViewRefresh.mj_header beginRefreshing];
}

- (void)doRefreshBillingRecordWithDatePickerTimeType:(FYDatePickerTimeType)datePickerTimeType queryTime:(NSString *)queryTime queryStartTime:(NSString *)queryStartTime queryEndTime:(NSString *)queryEndTime isNeedRefresh:(BOOL)isNeedRefresh
{
    if (!isNeedRefresh) {
        return;
    }
    
    [self setDatePickerTimeType:datePickerTimeType];
    [self setQueryTime:queryTime];
    [self setQueryStartTime:queryStartTime];
    [self setQueryEndTime:queryEndTime];
    //
    [self scrollTableToTopAnimated:NO];
    [self.tableViewRefresh.mj_header beginRefreshing];
}

- (NSArray<NSString *> *)getClassDropDownMenuOfCurrentClassIds
{
    return self.currentClassIds;
}

- (NSArray<NSString *> *)getFilterDropDownMenuOfCurrentFilterIds
{
    return self.currentFilterIds;
}

- (NSString *)getFilterDropDownMenuOfCurrentQueryMinMoney
{
    return self.queryMinMoney;
}

- (NSString *)getFilterDropDownMenuOfCurrentQueryMaxMoney
{
    return self.queryMaxMoney;
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

- (NSString *)getCurrentQueryStartTime
{
    return self.queryStartTime;
}

- (NSString *)getCurrentQueryEndTime
{
    return self.queryEndTime;
}

- (NSString *)getCurrentQueryTime
{
    return self.queryTime;
}


#pragma mark - Navigation

- (NSString *)prefersNavigationBarTitleViewTitle
{
    return STR_NAVIGATION_BAR_TITLE_BILLING_RECORD;
}

- (CGFloat)prefersNavigationBarHairlineHeight
{
    return NAVIGATION_BAR_HAIR_LINE_HEIGHT_ZERO;
}


#pragma mark - Getter & Setter

- (FYBillingRecordSectionHeader *)tableSectionHeader
{
    if (!_tableSectionHeader) {
        CGRect frame = CGRectMake(0, 0, self.tableViewRefresh.frame.size.width, [FYBillingRecordSectionHeader headerViewHeight]);
        _tableSectionHeader = [[FYBillingRecordSectionHeader alloc] initWithFrame:frame delegate:self parentVC:self arrayOfBillQueryModels:self.arrayOfBillingQueryModels];
        self.delegate_header = _tableSectionHeader;
    }
    return _tableSectionHeader;
}


@end

