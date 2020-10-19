//
//  FYAgentReportSubViewController.m
//  ProjectCSHB
//
//  Created by fangyuan on 2020/6/28.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "FYAgentReportViewController.h"
#import "FYAgentReportSubViewController.h"
#import "FYAgentReportSubSectionHeader.h"
//
#import "FYAgentReportAllTableViewCell.h"
#import "FYAgentReportUserTableViewCell.h"
#import "FYAgentReportItem1TableViewCell.h"
#import "FYAgentReportItem2TableViewCell.h"
#import "FYAgentReportItem1Model.h"
#import "FYAgentReportItem2Model.h"
#import "FYAgentReportUserModel.h"
#import "FYAgentReportAllModel.h"
#import "FYAgentReportHelper.h"
// 跳转
#import "FYAgentReferralsViewController.h"


@interface FYAgentReportSubViewController ()  <FYAgentReportSubSectionHeaderDelegate, FYAgentReportAllTableViewCellDelegate, FYAgentReportUserTableViewCellDelegate, FYAgentReportItem1TableViewCellDelegate, FYAgentReportItem2TableViewCellDelegate>
//
@property (nonatomic, strong) FYAgentReportSubSectionHeader *tableSectionHeader;
//
@property (nonatomic, copy) NSString *tabTitleCode;
//
@property (nonatomic, assign) FYDatePickerTimeType datePickerTimeType; // 时间选择类型（按月选择 or 按日选择）
@property (nonatomic, copy) NSString *datePickerYearMonthContentFormat; // 按月选择，日期格式 - 内容
@property (nonatomic, copy) NSString *datePickerStartEndTimeContentFormat; // 按日选择，日期格式 - 内容
@property (nonatomic, copy) NSString *datePickerYearMonth; // 按月选择 - 年月时间
@property (nonatomic, copy) NSString *datePickerStartTime; // 按日选择 - 开始时间
@property (nonatomic, copy) NSString *datePickerEndTime; // 按日选择 - 结束时间
//
@property (nonatomic, copy) NSString *searchMemberKey; // 搜索会员ID

@end


@implementation FYAgentReportSubViewController

#pragma mark - Actions

/// 团队下线 - 查看直属下级
- (void)didSelectRowAtAgentReportItem1Model:(FYAgentReportItem1Model *)model indexPath:(NSIndexPath *)indexPath
{
    NSArray<UIViewController *> *viewControllers = self.navigationController.viewControllers;
    NSString *userId = VALIDATE_STRING_EMPTY(self.searchMemberKey) ? APPINFORMATION.userInfo.userId : self.searchMemberKey;
    FYAgentReferralsViewController *VC = [[FYAgentReferralsViewController alloc] initWithSearchMemberKey:userId isFromMineCenter:NO];
    if (viewControllers.count < 10) {
        [self.navigationController pushViewController:VC animated:YES];
    } else {
        [self.navigationController pushViewController:VC removeViewControllerAtIndex:viewControllers.count-1];
    }
}


#pragma mark - Life Cycle

- (instancetype)initWithTabTitleCode:(NSString *)tabTitleCode searchMemberKey:(NSString *)searchMemberKey
{
    self = [super init];
    if (self) {
        _tabTitleCode = tabTitleCode;
        _searchMemberKey = searchMemberKey;
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
    
    // 页面是否已经生成显示过
    if (!self.isShowLoadingHUD) {
        // 页面已经生成显示过，判断查询条件是否已改变（时间、搜索关键词）
        if ([self verifyIsQueryConditionChange]) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(doAnyThingForSuperViewController:)]) {
                [self.delegate doAnyThingForSuperViewController:FYScrollPageForSuperViewTypeTableStartRefresh];
            }
        }
    }
}

- (void)resetSubScrollViewSize:(CGSize)size
{
    [super resetSubScrollViewSize:size];
    
    CGRect frame = CGRectMake(0, 0, size.width, size.height);
    [self.tableViewRefresh setFrame:frame];
    [self.tableViewRefresh setContentSize:frame.size];
}

- (UITableViewStyle)tableViewRefreshStyle
{
    return UITableViewStylePlain;
}

- (void)tableViewRefreshRegisterClass:(UITableView *)tableView
{
    [self.tableViewRefresh registerClass:[FYAgentReportAllTableViewCell class] forCellReuseIdentifier:[FYAgentReportAllTableViewCell reuseIdentifier]];
    [self.tableViewRefresh registerClass:[FYAgentReportUserTableViewCell class] forCellReuseIdentifier:[FYAgentReportUserTableViewCell reuseIdentifier]];
    [self.tableViewRefresh registerClass:[FYAgentReportItem1TableViewCell class] forCellReuseIdentifier:[FYAgentReportItem1TableViewCell reuseIdentifier]];
    [self.tableViewRefresh registerClass:[FYAgentReportItem2TableViewCell class] forCellReuseIdentifier:[FYAgentReportItem2TableViewCell reuseIdentifier]];
}


#pragma mark - Network

- (Act)getRequestInfoAct
{
    return ActRequestAgentCenterProxyGameReportRecord;
}

- (NSMutableDictionary *)getRequestParamerter
{
    id<FYAgentReportSubViewControllerDelegate> delegate_original = (id<FYAgentReportSubViewControllerDelegate>)self.delegate;
    
    NSString *datePickerYearMonthContentFormat = kFYDatePickerFormatYearMonth;
    if (delegate_original && [delegate_original respondsToSelector:@selector(getCurrentDatePickerYearMonthContentFormat)]) {
        datePickerYearMonthContentFormat = [delegate_original getCurrentDatePickerYearMonthContentFormat];
    }
    
    NSString *datePickerStartEndTimeContentFormat = kFYDatePickerFormatYearMonthDay;
    if (delegate_original && [delegate_original respondsToSelector:@selector(getCurrentDatePickerStartEndTimeContentFormat)]) {
        datePickerStartEndTimeContentFormat = [delegate_original getCurrentDatePickerStartEndTimeContentFormat];
    }
    
    FYDatePickerTimeType currentDatePickerTimeType = FYDatePickerTimeTypeNone;
    if (delegate_original && [delegate_original respondsToSelector:@selector(getCurrentDatePickerTimeType)]) {
        currentDatePickerTimeType = [delegate_original getCurrentDatePickerTimeType];
        [self setDatePickerTimeType:currentDatePickerTimeType];
    }
    
    NSString *currentDatePickerYearMonth = [[FYDateUtil returnToDay00Clock] stringFromDateWithFormat:datePickerYearMonthContentFormat];
    if (delegate_original && [delegate_original respondsToSelector:@selector(getCurrentDatePickerYearMonth)]) {
        currentDatePickerYearMonth = [delegate_original getCurrentDatePickerYearMonth];
        [self setDatePickerYearMonth:currentDatePickerYearMonth];
    }
    
    NSString *currentDatePickerStartTime = [[FYDateUtil returnToDay00Clock] stringFromDateWithFormat:datePickerStartEndTimeContentFormat];
    if (delegate_original && [delegate_original respondsToSelector:@selector(getCurrentDatePickerStartTime)]) {
        currentDatePickerStartTime = [delegate_original getCurrentDatePickerStartTime];
        [self setDatePickerStartTime:currentDatePickerStartTime];
    }
    
    NSString *currentDatePickerEndTime = [[FYDateUtil returnToDay24Clock] stringFromDateWithFormat:datePickerStartEndTimeContentFormat];
    if (delegate_original && [delegate_original respondsToSelector:@selector(getCurrentDatePickerEndTime)]) {
        currentDatePickerEndTime = [delegate_original getCurrentDatePickerEndTime];
        [self setDatePickerEndTime:currentDatePickerEndTime];
    }
    
    NSString *currentSearchMemberKey = self.searchMemberKey;
    if (delegate_original && [delegate_original respondsToSelector:@selector(getCurrentSearchMemberKey)]) {
        currentSearchMemberKey = [delegate_original getCurrentSearchMemberKey];
        [self setSearchMemberKey:currentSearchMemberKey];
    }
    
    NSMutableDictionary *paramerter = [NSMutableDictionary dictionary];
    NSString *dateOfStartString = [[FYDateUtil returnDate00Clock:[NSDate today]] stringFromDateWithFormat:kFYDatePickerFormatDate];
    NSString *dateOfEndString = [[FYDateUtil returnDate24Clock:[NSDate today]] stringFromDateWithFormat:kFYDatePickerFormatDate];
    if (FYDatePickerTimeTypeYearMonth == currentDatePickerTimeType) { // 按月选择
        NSDate *yearMonth = [NSDate dateWithString:currentDatePickerYearMonth formatString:datePickerYearMonthContentFormat];
        NSDate *dateOfStart = [FYDateUtil getFirstDateOfMonthFromDate:yearMonth];
        NSDate *dateOfEnd = [FYDateUtil getLastDateOfMonthFromDate:yearMonth];
        // 日期格式转换成 => yyyy-MM-dd
        dateOfStartString = [[FYDateUtil returnDate00Clock:dateOfStart] stringFromDateWithFormat:kFYDatePickerFormatDate];
        dateOfEndString = [[FYDateUtil returnDate24Clock:dateOfEnd] stringFromDateWithFormat:kFYDatePickerFormatDate];
    } else if (FYDatePickerTimeTypeStartEndTime == currentDatePickerTimeType) { // 按日选择
        NSDate *dateOfStart = [NSDate dateWithString:currentDatePickerStartTime formatString:datePickerStartEndTimeContentFormat];
        NSDate *dateOfEnd = [NSDate dateWithString:currentDatePickerEndTime formatString:datePickerStartEndTimeContentFormat];
        // 日期格式转换成 => yyyy-MM-dd
        dateOfStartString = [[FYDateUtil returnDate00Clock:dateOfStart] stringFromDateWithFormat:kFYDatePickerFormatDate];
        dateOfEndString = [[FYDateUtil returnDate24Clock:dateOfEnd] stringFromDateWithFormat:kFYDatePickerFormatDate];
    }
    [paramerter setObject:dateOfStartString forKey:@"startTime"];
    [paramerter setObject:dateOfEndString forKey:@"endTime"];
    [paramerter setObject:currentSearchMemberKey forKey:@"userId"];
    [paramerter setObject:self.tabTitleCode forKey:@"parentItemCode"];
    //
    return paramerter;
}

- (NSMutableArray *)loadNetworkDataOrCacheData:(id)responseDataOrCacheData isCacheData:(BOOL)isCacheData
{
    FYLog(NSLocalizedString(@"代理报表 => \n%@", nil), responseDataOrCacheData);
    
    // 请求成功，解析数据
    if (!NET_REQUEST_SUCCESS(responseDataOrCacheData)) {
        self.tableDataRefresh = @[].mutableCopy;
        return self.tableDataRefresh;
    }

    // 组装数据
    NSDictionary *data = NET_REQUEST_DATA(responseDataOrCacheData);
    NSMutableArray *allItemModels = [FYAgentReportHelper buildingDataModles:self.tabTitleCode data:data];
    
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
    id<FYAgentReportSubViewControllerDelegate> delegate_original = (id<FYAgentReportSubViewControllerDelegate>)self.delegate;
    if (delegate_original && [delegate_original respondsToSelector:@selector(doAnyThingForSuperViewController:)]) {
        [delegate_original doAnyThingForSuperViewController:FYScrollPageForSuperViewTypeTableEndRefresh];
    }

    if (delegate_original && [delegate_original respondsToSelector:@selector(doRefreshSearchKey:userName:headIcon:)]) {
        if (self.tableDataRefresh.count > 0) {
            FYAgentReportUserModel *userInfoModel = self.tableDataRefresh.firstObject;
            NSString *userId = [NSString stringWithFormat:@"%ld", (long)userInfoModel.userId.integerValue];
            [delegate_original doRefreshSearchKey:userId userName:userInfoModel.nick headIcon:userInfoModel.imageUrl];
        } else {
            [delegate_original doRefreshSearchKey:@"" userName:@"" headIcon:@""];
        }
    }
}


#pragma mark - FYAgentReportViewControllerProtocol

- (void)doScrollAgentReportSubTableToTopAnimated:(BOOL)animated
{
   [self scrollTableToTopAnimated:animated];
}

- (void)doRefreshForAgentReportSubViewController:(NSString *)tabTitleCode searchMemberKey:(NSString *)searchMemberKey
{
    [self setTabTitleCode:tabTitleCode];
    [self setSearchMemberKey:searchMemberKey];
    //
    [self loadData];
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
    
    if ([model isKindOfClass:[FYAgentReportAllModel class]]) {
        FYAgentReportAllTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:[FYAgentReportAllTableViewCell reuseIdentifier]];
        if (cell == nil) {
            cell = [[FYAgentReportAllTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[FYAgentReportAllTableViewCell reuseIdentifier]];
        }
        cell.delegate = self;
        cell.indexPath = indexPath;
        cell.model = self.tableDataRefresh[indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    } else if ([model isKindOfClass:[FYAgentReportUserModel class]]) {
        FYAgentReportUserTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:[FYAgentReportUserTableViewCell reuseIdentifier]];
        if (cell == nil) {
            cell = [[FYAgentReportUserTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[FYAgentReportUserTableViewCell reuseIdentifier]];
        }
        cell.delegate = self;
        cell.indexPath = indexPath;
        cell.model = self.tableDataRefresh[indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    } else if ([model isKindOfClass:[FYAgentReportItem1Model class]]) {
        FYAgentReportItem1TableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:[FYAgentReportItem1TableViewCell reuseIdentifier]];
        if (cell == nil) {
            cell = [[FYAgentReportItem1TableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[FYAgentReportItem1TableViewCell reuseIdentifier]];
        }
        cell.delegate = self;
        cell.indexPath = indexPath;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setModel:model isLastIndexRow:(indexPath.row==self.tableDataRefresh.count-1)];
        return cell;
    } else {
        FYAgentReportItem2TableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:[FYAgentReportItem2TableViewCell reuseIdentifier]];
        if (cell == nil) {
            cell = [[FYAgentReportItem2TableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[FYAgentReportItem2TableViewCell reuseIdentifier]];
        }
        cell.delegate = self;
        cell.indexPath = indexPath;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setModel:model isLastIndexRow:(indexPath.row==self.tableDataRefresh.count-1)];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    id model = self.tableDataRefresh[indexPath.row];
    
    if ([model isKindOfClass:[FYAgentReportAllModel class]]) {
        return [self.tableViewRefresh fd_heightForCellWithIdentifier:[FYAgentReportAllTableViewCell reuseIdentifier] cacheByIndexPath:indexPath configuration:^(FYAgentReportAllTableViewCell *cell) {
            cell.model = self.tableDataRefresh[indexPath.row];
        }];
    } else if ([model isKindOfClass:[FYAgentReportUserModel class]]) {
        return [self.tableViewRefresh fd_heightForCellWithIdentifier:[FYAgentReportUserTableViewCell reuseIdentifier] cacheByIndexPath:indexPath configuration:^(FYAgentReportUserTableViewCell *cell) {
            cell.model = self.tableDataRefresh[indexPath.row];
        }];
    } else if ([model isKindOfClass:[FYAgentReportItem1Model class]]) {
        return [self.tableViewRefresh fd_heightForCellWithIdentifier:[FYAgentReportItem1TableViewCell reuseIdentifier] cacheByIndexPath:indexPath configuration:^(FYAgentReportItem1TableViewCell *cell) {
            [cell setModel:model isLastIndexRow:(indexPath.row==self.tableDataRefresh.count-1)];
        }];
    } else {
        return [self.tableViewRefresh fd_heightForCellWithIdentifier:[FYAgentReportItem2TableViewCell reuseIdentifier] cacheByIndexPath:indexPath configuration:^(FYAgentReportItem2TableViewCell *cell) {
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
    return [FYAgentReportSubSectionHeader headerViewHeight];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return FLOAT_MIN;
}


#pragma mark - FYAgentReportSubSectionHeaderDelegate

- (void)doRefreshDatePickerTimeType:(FYDatePickerTimeType)datePickerTimeType datePickerYearMonth:(NSString *)datePickerYearMonth datePickerStartTime:(NSString *)datePickerStartTime datePickerEndTime:(NSString *)datePickerEndTime isNeedRefresh:(BOOL)isNeedRefresh
{
    id<FYAgentReportSubViewControllerDelegate> delegate_original = (id<FYAgentReportSubViewControllerDelegate>)self.delegate;
    if (delegate_original && [delegate_original respondsToSelector:@selector(doRefreshDatePickerTimeType:datePickerYearMonth:datePickerStartTime:datePickerEndTime:isNeedRefresh:)]) {
        [delegate_original doRefreshDatePickerTimeType:datePickerTimeType datePickerYearMonth:datePickerYearMonth datePickerStartTime:datePickerStartTime datePickerEndTime:datePickerEndTime isNeedRefresh:isNeedRefresh];
    }
}

- (void)doDatePickerDateTimeButtonTitle:(NSString *)titleString
{
   id<FYAgentReportSubViewControllerDelegate> delegate_original = (id<FYAgentReportSubViewControllerDelegate>)self.delegate;
    if (delegate_original && [delegate_original respondsToSelector:@selector(doDatePickerDateTimeButtonTitle:)]) {
        [delegate_original doDatePickerDateTimeButtonTitle:titleString];
    }
}

- (NSString *)getCurrentDatePickerrButtonTitle
{
    id<FYAgentReportSubViewControllerDelegate> delegate_original = (id<FYAgentReportSubViewControllerDelegate>)self.delegate;
    if (delegate_original && [delegate_original respondsToSelector:@selector(getCurrentDatePickerrButtonTitle)]) {
        return [delegate_original getCurrentDatePickerrButtonTitle];
    }
    return @"";
}

- (FYDatePickerTimeType)getCurrentDatePickerTimeType
{
    id<FYAgentReportSubViewControllerDelegate> delegate_original = (id<FYAgentReportSubViewControllerDelegate>)self.delegate;
    if (delegate_original && [delegate_original respondsToSelector:@selector(getCurrentDatePickerTimeType)]) {
        return [delegate_original getCurrentDatePickerTimeType];
    }
    return FYDatePickerTimeTypeYearMonth;
}

- (NSString *)getCurrentDatePickerYearMonthTitleFormat
{
    id<FYAgentReportSubViewControllerDelegate> delegate_original = (id<FYAgentReportSubViewControllerDelegate>)self.delegate;
    if (delegate_original && [delegate_original respondsToSelector:@selector(getCurrentDatePickerYearMonthTitleFormat)]) {
        return [delegate_original getCurrentDatePickerYearMonthTitleFormat];
    }
    return @"";
}

- (NSString *)getCurrentDatePickerYearMonthContentFormat
{
    id<FYAgentReportSubViewControllerDelegate> delegate_original = (id<FYAgentReportSubViewControllerDelegate>)self.delegate;
    if (delegate_original && [delegate_original respondsToSelector:@selector(getCurrentDatePickerYearMonthContentFormat)]) {
        return [delegate_original getCurrentDatePickerYearMonthContentFormat];
    }
    return @"";
}

- (NSString *)getCurrentDatePickerStartEndTimeTitleFormat
{
    id<FYAgentReportSubViewControllerDelegate> delegate_original = (id<FYAgentReportSubViewControllerDelegate>)self.delegate;
    if (delegate_original && [delegate_original respondsToSelector:@selector(getCurrentDatePickerStartEndTimeTitleFormat)]) {
        return [delegate_original getCurrentDatePickerStartEndTimeTitleFormat];
    }
    return @"";
}

- (NSString *)getCurrentDatePickerStartEndTimeContentFormat
{
    id<FYAgentReportSubViewControllerDelegate> delegate_original = (id<FYAgentReportSubViewControllerDelegate>)self.delegate;
    if (delegate_original && [delegate_original respondsToSelector:@selector(getCurrentDatePickerStartEndTimeContentFormat)]) {
        return [delegate_original getCurrentDatePickerStartEndTimeContentFormat];
    }
    return @"";
}

- (NSString *)getCurrentDatePickerYearMonth
{
    id<FYAgentReportSubViewControllerDelegate> delegate_original = (id<FYAgentReportSubViewControllerDelegate>)self.delegate;
    if (delegate_original && [delegate_original respondsToSelector:@selector(getCurrentDatePickerYearMonth)]) {
        return [delegate_original getCurrentDatePickerYearMonth];
    }
    return @"";
}

- (NSString *)getCurrentDatePickerStartTime
{
    id<FYAgentReportSubViewControllerDelegate> delegate_original = (id<FYAgentReportSubViewControllerDelegate>)self.delegate;
    if (delegate_original && [delegate_original respondsToSelector:@selector(getCurrentDatePickerStartTime)]) {
        return [delegate_original getCurrentDatePickerStartTime];
    }
    return @"";
}

- (NSString *)getCurrentDatePickerEndTime
{
    id<FYAgentReportSubViewControllerDelegate> delegate_original = (id<FYAgentReportSubViewControllerDelegate>)self.delegate;
    if (delegate_original && [delegate_original respondsToSelector:@selector(getCurrentDatePickerEndTime)]) {
        return [delegate_original getCurrentDatePickerEndTime];
    }
    return @"";
}


#pragma mark - Getter & Setter

- (FYAgentReportSubSectionHeader *)tableSectionHeader
{
    if (!_tableSectionHeader) {
        CGRect frame = CGRectMake(0, 0, self.tableViewRefresh.frame.size.width, [FYAgentReportSubSectionHeader headerViewHeight]);
        _tableSectionHeader = [[FYAgentReportSubSectionHeader alloc] initWithFrame:frame delegate:self parentVC:self];
    }
    return _tableSectionHeader;
}


#pragma mark - Priavte

- (BOOL)verifyIsQueryConditionChange
{
    id<FYAgentReportSubViewControllerDelegate> delegate_original = (id<FYAgentReportSubViewControllerDelegate>)self.delegate;
    
    NSString *datePickerYearMonthContentFormat = kFYDatePickerFormatYearMonth;
    if (delegate_original && [delegate_original respondsToSelector:@selector(getCurrentDatePickerYearMonthContentFormat)]) {
        datePickerYearMonthContentFormat = [delegate_original getCurrentDatePickerYearMonthContentFormat];
    }
    
    NSString *datePickerStartEndTimeContentFormat = kFYDatePickerFormatYearMonthDay;
    if (delegate_original && [delegate_original respondsToSelector:@selector(getCurrentDatePickerStartEndTimeContentFormat)]) {
        datePickerStartEndTimeContentFormat = [delegate_original getCurrentDatePickerStartEndTimeContentFormat];
    }
    
    FYDatePickerTimeType currentDatePickerTimeType = FYDatePickerTimeTypeNone;
    if (delegate_original && [delegate_original respondsToSelector:@selector(getCurrentDatePickerTimeType)]) {
        currentDatePickerTimeType = [delegate_original getCurrentDatePickerTimeType];
    }
    
    NSString *currentDatePickerYearMonth = [[FYDateUtil returnToDay00Clock] stringFromDateWithFormat:datePickerYearMonthContentFormat];
    if (delegate_original && [delegate_original respondsToSelector:@selector(getCurrentDatePickerYearMonth)]) {
        currentDatePickerYearMonth = [delegate_original getCurrentDatePickerYearMonth];
    }
    
    NSString *currentDatePickerStartTime = [[FYDateUtil returnToDay00Clock] stringFromDateWithFormat:datePickerStartEndTimeContentFormat];
    if (delegate_original && [delegate_original respondsToSelector:@selector(getCurrentDatePickerStartTime)]) {
        currentDatePickerStartTime = [delegate_original getCurrentDatePickerStartTime];
    }
    
    NSString *currentDatePickerEndTime = [[FYDateUtil returnToDay24Clock] stringFromDateWithFormat:datePickerStartEndTimeContentFormat];
    if (delegate_original && [delegate_original respondsToSelector:@selector(getCurrentDatePickerEndTime)]) {
        currentDatePickerEndTime = [delegate_original getCurrentDatePickerEndTime];
    }
    
    NSString *currentSearchMemberKey = self.searchMemberKey;
    if (delegate_original && [delegate_original respondsToSelector:@selector(getCurrentSearchMemberKey)]) {
        currentSearchMemberKey = [delegate_original getCurrentSearchMemberKey];
    }
    
    if (currentDatePickerTimeType != self.datePickerTimeType
        || ![currentDatePickerYearMonth isEqualToString:self.datePickerYearMonth]
        || ![currentDatePickerStartTime isEqualToString:self.datePickerStartTime]
        || ![currentDatePickerEndTime isEqualToString:self.datePickerEndTime]
        || ![currentSearchMemberKey isEqualToString:self.searchMemberKey]) {
        return YES;
    }
    
    return NO;
}

@end

