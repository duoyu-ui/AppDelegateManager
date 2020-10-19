//
//  FYPersonStaticViewController.m
//  ProjectCSHB
//
//  Created by fangyuan on 2020/6/26.
//  Copyright © 2020 Fangyuan. All rights reserved.
//
// 个人汇总
//

#import "FYPersonStaticViewController.h"
#import "FYPersonStaticSectionHeader.h"
#import "FYPersonStaticAllTableViewCell.h"
#import "FYPersonStaticItemTableViewCell.h"
#import "FYPersonStaticAllModel.h"
#import "FYPersonStaticItemModel.h"

@interface FYPersonStaticViewController () <FYPersonStaticSectionHeaderDelegate>
//
@property (nonatomic, strong) FYPersonStaticSectionHeader *tableSectionHeader; // 头部控件
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


@implementation FYPersonStaticViewController

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
        self.hasRefreshFooter = NO;
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
    [self.tableViewRefresh registerClass:[FYPersonStaticAllTableViewCell class] forCellReuseIdentifier:[FYPersonStaticAllTableViewCell reuseIdentifier]];
    [self.tableViewRefresh registerClass:[FYPersonStaticItemTableViewCell class] forCellReuseIdentifier:[FYPersonStaticItemTableViewCell reuseIdentifier]];
}


#pragma mark - Network

- (Act)getRequestInfoAct
{
    return ActRequestMyCenterPersonalStatistics;
}

- (NSMutableDictionary *)getRequestParamerter
{
    NSMutableDictionary *paramerter = [NSMutableDictionary dictionary];
    NSString *dateOfStartString = [[FYDateUtil returnDate00Clock:[NSDate today]] stringFromDateWithFormat:kFYDatePickerFormatDate];
    NSString *dateOfEndString = [[FYDateUtil returnDate24Clock:[NSDate today]] stringFromDateWithFormat:kFYDatePickerFormatDate];
    if (FYDatePickerTimeTypeYearMonth == self.datePickerTimeType) { // 按月选择
        NSDate *yearMonth = [NSDate dateWithString:self.datePickerYearMonth formatString:self.datePickerYearMonthContentFormat];
        NSDate *dateOfStart = [FYDateUtil getFirstDateOfMonthFromDate:yearMonth];
        NSDate *dateOfEnd = [FYDateUtil getLastDateOfMonthFromDate:yearMonth];
        // 日期格式转换成 => yyyy-MM-dd HH:mm:ss
        dateOfStartString = [[FYDateUtil returnDate00Clock:dateOfStart] stringFromDateWithFormat:kFYDatePickerFormatDate];
        dateOfEndString = [[FYDateUtil returnDate24Clock:dateOfEnd] stringFromDateWithFormat:kFYDatePickerFormatDate];
    } else if (FYDatePickerTimeTypeStartEndTime == self.datePickerTimeType) { // 按日选择
        NSDate *dateOfStart = [NSDate dateWithString:self.datePickerStartTime formatString:self.datePickerStartEndTimeContentFormat];
        NSDate *dateOfEnd = [NSDate dateWithString:self.datePickerEndTime formatString:self.datePickerStartEndTimeContentFormat];
        // 日期格式转换成 => yyyy-MM-dd HH:mm:ss
        dateOfStartString = [[FYDateUtil returnDate00Clock:dateOfStart] stringFromDateWithFormat:kFYDatePickerFormatDate];
        dateOfEndString = [[FYDateUtil returnDate24Clock:dateOfEnd] stringFromDateWithFormat:kFYDatePickerFormatDate];
    }
    [paramerter setObject:dateOfStartString forKey:@"startTime"];
    [paramerter setObject:dateOfEndString forKey:@"endTime"];
    return paramerter;
}

- (NSMutableArray *)loadNetworkDataOrCacheData:(id)responseDataOrCacheData isCacheData:(BOOL)isCacheData
{
    FYLog(NSLocalizedString(@"个人汇总 => \n%@", nil), responseDataOrCacheData);
    
    // 请求成功，解析数据
    if (!NET_REQUEST_SUCCESS(responseDataOrCacheData)) {
        self.tableDataRefresh = @[].mutableCopy;
        return self.tableDataRefresh;
    }

    // 组装数据
    NSDictionary *data = NET_REQUEST_DATA(responseDataOrCacheData);
    NSMutableArray *allItemModels = [NSMutableArray array];
    // 个人总览
    NSMutableArray<NSDictionary *> *arrayOfAllDicts = [NSMutableArray arrayWithObject:data];
    NSMutableArray *ItemAllModels = [FYPersonStaticAllModel buildingDataModles:arrayOfAllDicts];
    [allItemModels addObjectsFromArray:ItemAllModels];
    // 其它汇总
    NSArray<NSDictionary *> *arrayOfOtherDicts = [data arrayForKey:@"dts"];
    NSMutableArray *itemOtherModels = [FYPersonStaticItemModel mj_objectArrayWithKeyValuesArray:arrayOfOtherDicts];
    [allItemModels addObjectsFromArray:itemOtherModels];

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
    id model = self.tableDataRefresh[indexPath.row];
    
    if ([model isKindOfClass:[FYPersonStaticAllModel class]]) {
        FYPersonStaticAllTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:[FYPersonStaticAllTableViewCell reuseIdentifier]];
        if (cell == nil) {
            cell = [[FYPersonStaticAllTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[FYPersonStaticAllTableViewCell reuseIdentifier]];
        }
        cell.model = self.tableDataRefresh[indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    } else {
        FYPersonStaticItemTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:[FYPersonStaticItemTableViewCell reuseIdentifier]];
        if (cell == nil) {
            cell = [[FYPersonStaticItemTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[FYPersonStaticItemTableViewCell reuseIdentifier]];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setModel:model isLastIndexRow:(indexPath.row==self.tableDataRefresh.count-1)];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    id model = self.tableDataRefresh[indexPath.row];
    
    if ([model isKindOfClass:[FYPersonStaticAllModel class]]) {
        return [self.tableViewRefresh fd_heightForCellWithIdentifier:[FYPersonStaticAllTableViewCell reuseIdentifier] cacheByIndexPath:indexPath configuration:^(FYPersonStaticAllTableViewCell *cell) {
            cell.model = self.tableDataRefresh[indexPath.row];
        }];
    } else {
        return [self.tableViewRefresh fd_heightForCellWithIdentifier:[FYPersonStaticItemTableViewCell reuseIdentifier] cacheByIndexPath:indexPath configuration:^(FYPersonStaticItemTableViewCell *cell) {
            [cell setModel:model isLastIndexRow:(indexPath.row==self.tableDataRefresh.count-1)];
        }];
    }
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
    return [FYPersonStaticSectionHeader headerViewHeight];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return FLOAT_MIN;
}


#pragma mark - FYPersonStaticSectionHeaderDelegate

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

- (NSString *)prefersNavigationBarTitleViewTitle
{
    return STR_NAVIGATION_BAR_TITLE_PERSON_STATIC;
}

- (CGFloat)prefersNavigationBarHairlineHeight
{
    return NAVIGATION_BAR_HAIR_LINE_HEIGHT_ZERO;
}


#pragma mark - Getter & Setter

- (FYPersonStaticSectionHeader *)tableSectionHeader
{
    if (!_tableSectionHeader) {
        CGRect frame = CGRectMake(0, 0, self.tableViewRefresh.frame.size.width, [FYPersonStaticSectionHeader headerViewHeight]);
        _tableSectionHeader = [[FYPersonStaticSectionHeader alloc] initWithFrame:frame delegate:self parentVC:self];
    }
    return _tableSectionHeader;
}


@end

