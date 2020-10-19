//
//  FYAgentReferralsViewController.m
//  ProjectCSHB
//
//  Created by fangyuan on 2020/6/27.
//  Copyright © 2020 Fangyuan. All rights reserved.
//
// 我的下线
//

#import "FYAgentReferralsViewController.h"
#import "FYAgentReferralsSectionHeader.h"
#import "FYAgentReferralsAllTableViewCell.h"
#import "FYAgentReferralsItemTableViewCell.h"
#import "FYAgentReferralsAllModel.h"
#import "FYAgentReferralsItemModel.h"
// 跳转
#import "FYAgentReportViewController.h"


@interface FYAgentReferralsViewController () <FYAgentReferralsSectionHeaderDelegate, FYAgentReferralsAllTableViewCellDelegate, FYAgentReferralsItemTableViewCellDelegate>
//
@property (nonatomic, assign) BOOL isFromMineCenter; // 是否来自个人中心
@property (nonatomic, strong) FYAgentReferralsSectionHeader *tableSectionHeader; // 头部控件
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

@implementation FYAgentReferralsViewController

#pragma mark - Actions

/// 会员详情
- (void)didSelectRowAtAgentReferralsItemModel:(FYAgentReferralsItemModel *)model indexPath:(NSIndexPath *)indexPath
{
    if (VALIDATE_STRING_EMPTY(model.userId.stringValue)) {
        ALTER_INFO_MESSAGE(NSLocalizedString(@"用户ID不能为空", nil))
        return;
    }
    
    [self didPushToPushViewController:model.userId.stringValue];
}

- (void)didAgentHeaderSearchUserHeaderPicture
{
    [self didPushToPushViewController:self.searchMemberKey];
}

- (void)didPushToPushViewController:(NSString *)userId
{
    NSArray<UIViewController *> *viewControllers = self.navigationController.viewControllers;
    NSString *searchMemberKey =  STR_TRI_WHITE_SPACE(userId);
    FYAgentReportViewController *VC = [[FYAgentReportViewController alloc] initWithSearchMemberKey:searchMemberKey isFromMineCenter:NO];
    if (viewControllers.count < 10) {
        [self.navigationController pushViewController:VC animated:YES];
    } else {
        [self.navigationController pushViewController:VC removeViewControllerAtIndex:viewControllers.count-1];
    }
}


#pragma mark - Life Cycle

- (instancetype)initWithSearchMemberKey:(NSString *)searchMemberKey isFromMineCenter:(BOOL)isFromMineCenter
{
    self = [super initWithSearchMemberKey:searchMemberKey isInitSearchText:!isFromMineCenter];
    if (self) {
        self.isFromMineCenter = isFromMineCenter;
        //
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    
}

- (UITableViewStyle)tableViewRefreshStyle
{
    return UITableViewStylePlain;
}

- (void)tableViewRefreshRegisterClass:(UITableView *)tableView
{
    [self.tableViewRefresh registerClass:[FYAgentReferralsAllTableViewCell class] forCellReuseIdentifier:[FYAgentReferralsAllTableViewCell reuseIdentifier]];
    [self.tableViewRefresh registerClass:[FYAgentReferralsItemTableViewCell class] forCellReuseIdentifier:[FYAgentReferralsItemTableViewCell reuseIdentifier]];
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
    return ActRequestAgentCenterProxyReferrals;
}

- (NSMutableDictionary *)getRequestParamerter
{
    NSMutableDictionary *queryParam = [NSMutableDictionary dictionary];
    NSString *dateOfStartString = [[FYDateUtil returnDate00Clock:[NSDate today]] stringFromDateWithFormat:kFYDatePickerFormatDate];
    NSString *dateOfEndString = [[FYDateUtil returnDate24Clock:[NSDate today]] stringFromDateWithFormat:kFYDatePickerFormatDate];
    if (FYDatePickerTimeTypeYearMonth == self.datePickerTimeType) { // 按月选择
        NSDate *yearMonth = [NSDate dateWithString:self.datePickerYearMonth formatString:self.datePickerYearMonthContentFormat];
        NSDate *dateOfStart = [FYDateUtil getFirstDateOfMonthFromDate:yearMonth];
        NSDate *dateOfEnd = [FYDateUtil getLastDateOfMonthFromDate:yearMonth];
        // 日期格式转换成 => yyyy-MM-dd
        dateOfStartString = [[FYDateUtil returnDate00Clock:dateOfStart] stringFromDateWithFormat:kFYDatePickerFormatDate];
        dateOfEndString = [[FYDateUtil returnDate24Clock:dateOfEnd] stringFromDateWithFormat:kFYDatePickerFormatDate];
    } else if (FYDatePickerTimeTypeStartEndTime == self.datePickerTimeType) { // 按日选择
        NSDate *dateOfStart = [NSDate dateWithString:self.datePickerStartTime formatString:self.datePickerStartEndTimeContentFormat];
        NSDate *dateOfEnd = [NSDate dateWithString:self.datePickerEndTime formatString:self.datePickerStartEndTimeContentFormat];
        // 日期格式转换成 => yyyy-MM-dd
        dateOfStartString = [[FYDateUtil returnDate00Clock:dateOfStart] stringFromDateWithFormat:kFYDatePickerFormatDate];
        dateOfEndString = [[FYDateUtil returnDate24Clock:dateOfEnd] stringFromDateWithFormat:kFYDatePickerFormatDate];
    }
    [queryParam setObject:dateOfStartString forKey:@"startTime"];
    [queryParam setObject:dateOfEndString forKey:@"endTime"];
    [queryParam setObject:self.searchMemberKey forKey:@"subUserId"];
    if (self.hasPage) {
        [queryParam setObject:[NSNumber numberWithInteger:self.page].stringValue forKey:@"pageNum"];
        [queryParam setObject:[NSNumber numberWithInteger:self.limit].stringValue forKey:@"pageSize"];
    }
    return queryParam;
}

- (void)loadRequestDataThen:(void (^)(void))then
{
    if (self.isShowLoadingHUD) {
        PROGRESS_HUD_SHOW
    }
    [self loadRequestOtherDataThen:^(BOOL success, id *model) {
        if (self.isShowLoadingHUD) {
            PROGRESS_HUD_DISMISS
        }
        !then ?: then();
    }];
}

- (void)loadRequestOtherDataThen:(void (^)(BOOL success, id *model))then
{
    !then ?: then(NO,nil);
}

- (NSMutableArray *)loadNetworkDataOrCacheData:(id)responseDataOrCacheData isCacheData:(BOOL)isCacheData
{
    FYLog(NSLocalizedString(@"我的下线 => \n%@", nil), responseDataOrCacheData);
    
    // 请求成功，解析数据
    if (!NET_REQUEST_SUCCESS(responseDataOrCacheData)) {
        self.tableDataRefresh = @[].mutableCopy;
        return self.tableDataRefresh;
    }

    // 组装数据
    NSDictionary *data = NET_REQUEST_DATA(responseDataOrCacheData);
    // 汇总数据
    NSMutableArray<FYAgentReferralsAllModel *> *itemAllTotalModels = [FYAgentReferralsAllModel buildingDataModles:data];
    // 会员下线
    NSArray<NSDictionary *> *arrayOfDicts = [data arrayForKey:@"list"];
    NSMutableArray *itemMyReferralsModels = [FYAgentReferralsItemModel mj_objectArrayWithKeyValuesArray:arrayOfDicts];
    
    // 配置数据源
    if (0 == self.offset) {
        self.tableDataRefresh = [NSMutableArray array];
        if (itemAllTotalModels && 0 < itemAllTotalModels.count) {
            [self.tableDataRefresh addObjectsFromArray:itemAllTotalModels];
        }
        if (itemMyReferralsModels && 0 < itemMyReferralsModels.count) {
            [self.tableDataRefresh addObjectsFromArray:itemMyReferralsModels];
        }
    } else {
        if (itemMyReferralsModels && 0 < itemMyReferralsModels.count) {
            [self.tableDataRefresh addObjectsFromArray:itemMyReferralsModels];
        }
    }
    return self.tableDataRefresh;
}

- (void)viewDidLoadAfterLoadNetworkDataOrCacheData
{
    if (self.tableDataRefresh.count > 0) {
        FYAgentReferralsAllModel *userInfoModel = self.tableDataRefresh.firstObject;
        NSString *userId = [NSString stringWithFormat:@"%ld", (long)userInfoModel.subUserId.integerValue];
        [self.searchHeaderView doRefreshSearchKey:userId userName:userInfoModel.nick usertype:userInfoModel.userType headIcon:userInfoModel.headIco searchText:self.searchTextPlaceHolder];
    } else {
        [self.searchHeaderView doRefreshSearchKey:@"" userName:@"" usertype:@(54088) headIcon:@"" searchText:self.searchTextPlaceHolder];
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
    id model = self.tableDataRefresh[indexPath.row];
    
    if ([model isKindOfClass:[FYAgentReferralsAllModel class]]) {
        FYAgentReferralsAllTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:[FYAgentReferralsAllTableViewCell reuseIdentifier]];
        if (cell == nil) {
            cell = [[FYAgentReferralsAllTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[FYAgentReferralsAllTableViewCell reuseIdentifier]];
        }
        cell.delegate = self;
        cell.indexPath = indexPath;
        cell.model = self.tableDataRefresh[indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    } else {
        FYAgentReferralsItemTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:[FYAgentReferralsItemTableViewCell reuseIdentifier]];
        if (cell == nil) {
            cell = [[FYAgentReferralsItemTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[FYAgentReferralsItemTableViewCell reuseIdentifier]];
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
    
    if ([model isKindOfClass:[FYAgentReferralsAllModel class]]) {
        return [self.tableViewRefresh fd_heightForCellWithIdentifier:[FYAgentReferralsAllTableViewCell reuseIdentifier] cacheByIndexPath:indexPath configuration:^(FYAgentReferralsAllTableViewCell *cell) {
            cell.model = self.tableDataRefresh[indexPath.row];
        }];
    } else {
        return [self.tableViewRefresh fd_heightForCellWithIdentifier:[FYAgentReferralsItemTableViewCell reuseIdentifier] cacheByIndexPath:indexPath configuration:^(FYAgentReferralsItemTableViewCell *cell) {
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
    return [FYAgentReferralsSectionHeader headerViewHeight];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return FLOAT_MIN;
}


#pragma mark - FYAgentReferralsSectionHeaderDelegate

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
    return NSLocalizedString(@"代理下线", nil);
}


#pragma mark - Getter & Setter

- (FYAgentReferralsSectionHeader *)tableSectionHeader
{
    if (!_tableSectionHeader) {
        CGRect frame = CGRectMake(0, 0, self.tableViewRefresh.frame.size.width, [FYAgentReferralsSectionHeader headerViewHeight]);
        _tableSectionHeader = [[FYAgentReferralsSectionHeader alloc] initWithFrame:frame delegate:self parentVC:self];
    }
    return _tableSectionHeader;
}


@end

