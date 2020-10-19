//
//  FYGameReportViewController.m
//  ProjectCSHB
//
//  Created by fangyuan on 2020/6/25.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "FYGameReportViewController.h"
#import "FYGameReportSectionHeader.h"
#import "FYGameReportTableViewCell.h"
#import "FYGameReportStatisticsModel.h"
#import "FYGameReportModel.h"


@interface FYGameReportViewController () <FYGameReportSectionHeaderDelegate, FYGameReportTableViewCellDelegate>
//
@property (nonatomic, strong) FYGameReportSectionHeader *tableSectionHeader; // 头部控件
@property (nonatomic, strong) FYGameReportStatisticsModel *gameReportStatisticsModel; // 统计收入盈亏
// 查询接口参数
@property (nonatomic, assign) FYDatePickerTimeType datePickerTimeType; // 时间选择类型（按月选择 or 按日选择）
@property (nonatomic, copy) NSString *datePickerYearMonthTitleFormat; // 按月选择，日期格式 - 标题
@property (nonatomic, copy) NSString *datePickerYearMonthContentFormat; // 按月选择，日期格式 - 内容
@property (nonatomic, copy) NSString *datePickerStartEndTimeTitleFormat; // 按日选择，日期格式 - 标题
@property (nonatomic, copy) NSString *datePickerStartEndTimeContentFormat; // 按日选择，日期格式 - 内容
@property (nonatomic, copy) NSString *datePickerYearMonth; // 按月选择 - 年月时间
@property (nonatomic, copy) NSString *datePickerStartTime; // 按日选择 - 开始时间
@property (nonatomic, copy) NSString *datePickerEndTime; // 按日选择 - 结束时间

@end


@implementation FYGameReportViewController

#pragma mark - Actions

- (void)didSelectRowAtGameReportModel:(FYGameReportModel *)model indexPath:(NSIndexPath *)indexPath
{
    // TODO: 点击游戏报表 Cell 事件处理
    
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
        self.datePickerYearMonth = [[NSDate today] stringFromDateWithFormat:self.datePickerYearMonthContentFormat];
        self.datePickerStartTime = @"";
        self.datePickerEndTime = @"";
        //
        self.hasPage = YES;
        self.isAutoLayoutSafeAreaBottom = NO;
    }
    return self;
}

- (instancetype)initWithGameType:(NSNumber *)gameType gameSubType:(NSNumber *)gameSubType
{
    self = [self init];
    if (self) {
        _gameType = gameType;
        _gameSubType = gameSubType;
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
    [self.tableViewRefresh registerClass:[FYGameReportTableViewCell class] forCellReuseIdentifier:[FYGameReportTableViewCell reuseIdentifier]];
}


#pragma mark - Network

- (Act)getRequestInfoAct
{
    return ActRequestGameReportRecordProfitLoss;
}

- (NSMutableDictionary *)getRequestParamerter
{
    NSMutableDictionary *queryParam = [NSMutableDictionary dictionary];
    NSString *dateOfStartString = [[FYDateUtil returnDate00Clock:[NSDate today]] stringFromDateWithFormat:kFYDatePickerFormatDateFull];
    NSString *dateOfEndString = [[FYDateUtil returnDate24Clock:[NSDate today]] stringFromDateWithFormat:kFYDatePickerFormatDateFull];
    if (FYDatePickerTimeTypeYearMonth == self.datePickerTimeType) { // 按月选择
        NSDate *yearMonth = [NSDate dateWithString:self.datePickerYearMonth formatString:self.datePickerYearMonthContentFormat];
        NSDate *dateOfStart = [FYDateUtil getFirstDateOfMonthFromDate:yearMonth];
        NSDate *dateOfEnd = [FYDateUtil getLastDateOfMonthFromDate:yearMonth];
        // 日期格式转换成 => yyyy-MM-dd HH:mm:ss
        dateOfStartString = [[FYDateUtil returnDate00Clock:dateOfStart] stringFromDateWithFormat:kFYDatePickerFormatDateFull];
        dateOfEndString = [[FYDateUtil returnDate24Clock:dateOfEnd] stringFromDateWithFormat:kFYDatePickerFormatDateFull];
    } else if (FYDatePickerTimeTypeStartEndTime == self.datePickerTimeType) { // 按日选择
        NSDate *dateOfStart = [NSDate dateWithString:self.datePickerStartTime formatString:self.datePickerStartEndTimeContentFormat];
        NSDate *dateOfEnd = [NSDate dateWithString:self.datePickerEndTime formatString:self.datePickerStartEndTimeContentFormat];
        // 日期格式转换成 => yyyy-MM-dd HH:mm:ss
        dateOfStartString = [[FYDateUtil returnDate00Clock:dateOfStart] stringFromDateWithFormat:kFYDatePickerFormatDateFull];
        dateOfEndString = [[FYDateUtil returnDate24Clock:dateOfEnd] stringFromDateWithFormat:kFYDatePickerFormatDateFull];
    }
    [queryParam setObject:dateOfStartString forKey:@"startTime"];
    [queryParam setObject:dateOfEndString forKey:@"endTime"];
    [queryParam setObject:self.gameType forKey:@"parentType"];
    [queryParam setObject:self.gameSubType forKey:@"type"];
    return @{ @"queryParam" : queryParam }.mutableCopy;
}

- (NSMutableArray *)loadNetworkDataOrCacheData:(id)responseDataOrCacheData isCacheData:(BOOL)isCacheData
{
    FYLog(NSLocalizedString(@"游戏统计 => \n%@", nil), responseDataOrCacheData);
    
    // 请求成功，解析数据
    if (!NET_REQUEST_SUCCESS(responseDataOrCacheData)) {
        self.tableDataRefresh = @[].mutableCopy;
        return self.tableDataRefresh;
    }

    // 组装数据
    NSDictionary *data = NET_REQUEST_DATA(responseDataOrCacheData);
    NSArray<NSDictionary *> *arrayOfDicts = [data arrayForKey:@"records"];
    NSMutableArray<FYGameReportModel *> *allItemModels = [FYGameReportModel mj_objectArrayWithKeyValuesArray:arrayOfDicts];

    // 统计数据
    NSDictionary *dictOfStatic = [data dictionaryForKey:@"summaryData"];
    FYGameReportStatisticsModel *gameReportStatisticsModel = [FYGameReportStatisticsModel mj_objectWithKeyValues:dictOfStatic];
    [self setGameReportStatisticsModel:gameReportStatisticsModel];
    
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
    if (self.delegate_header && [self.delegate_header respondsToSelector:@selector(doRefreshSectionHeaderGameReportStatisticsModel:)]) {
        [self.delegate_header doRefreshSectionHeaderGameReportStatisticsModel:self.gameReportStatisticsModel];
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
    FYGameReportTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:[FYGameReportTableViewCell reuseIdentifier]];
    if (cell == nil) {
        cell = [[FYGameReportTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[FYGameReportTableViewCell reuseIdentifier]];
    }
    cell.delegate = self;
    cell.indexPath = indexPath;
    cell.model = self.tableDataRefresh[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.tableViewRefresh fd_heightForCellWithIdentifier:[FYGameReportTableViewCell reuseIdentifier] cacheByIndexPath:indexPath configuration:^(FYGameReportTableViewCell *cell) {
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
    return [FYGameReportSectionHeader headerViewHeight];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return FLOAT_MIN;
}


#pragma mark - FYGameReportSectionHeaderDelegate

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
    [self scrollTableToTopAnimated:NO];
    [self.tableViewRefresh.mj_header beginRefreshing];
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


#pragma mark - Navigation

- (CGFloat)prefersNavigationBarHairlineHeight
{
    return NAVIGATION_BAR_HAIR_LINE_HEIGHT_ZERO;
}


#pragma mark - Getter & Setter

- (FYGameReportSectionHeader *)tableSectionHeader
{
    if (!_tableSectionHeader) {
        CGRect frame = CGRectMake(0, 0, self.tableViewRefresh.frame.size.width, [FYGameReportSectionHeader headerViewHeight]);
        _tableSectionHeader = [[FYGameReportSectionHeader alloc] initWithFrame:frame delegate:self parentVC:self];
        self.delegate_header = _tableSectionHeader;
    }
    return _tableSectionHeader;
}


@end

