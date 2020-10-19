//
//  FYBagLotteryTrendController.m
//  ProjectCSHB
//
//  Created by fangyuan on 2020/7/25.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "FYBagLotteryTrendController.h"
#import "FYBagLotteryTrendSectionHeader.h"
#import "FYBagLotteryTrendTableViewCell.h"
#import "FYBagLotteryTrendChartView.h"
#import "FYBagLotteryGroupInfoModel.h"
#import "FYBagLotteryTrendModel.h"
#import "FYTrendCoundDownView.h"
#import "RobNiuNiuQunModel.h"

@interface FYBagLotteryTrendController ()
@property(nonatomic, strong) MessageItem *messageItem;
@property(nonatomic, strong) FYBagLotteryTrendChartView *trendChartView;
@property(nonatomic, strong) FYBagLotteryTrendSectionHeader *tableSectionHeader;
@property(nonatomic, strong) FYBagLotteryTrendResponse *trendChartResponse;
//
@property(nonatomic, strong) UIView *trendChartTopAreaView;
@property(nonatomic, strong) UILabel *trendChartTipTitleLabel;
@property(nonatomic, strong) FYTrendCoundDownView *trendCountDownView; // 当前期倒计时
@property(nonatomic, strong) FYBagLotteryGroupInfoModel *groupInfoModel;
@property(nonatomic, strong) RobNiuNiuQunModel *gameGroupInfoModel;
@end

@implementation FYBagLotteryTrendController

#pragma mark - Life Cycle

- (instancetype)initWithMessageItem:(MessageItem *)messageItem
{
    self = [super init];
    if (self) {
        _messageItem = messageItem;
        self.hasRefreshFooter = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self viewDidLoadMainUI];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [self.trendCountDownView stopTimer];
}

- (void)viewDidLoadMainUI
{
    CGFloat margin = CFC_AUTOSIZING_MARGIN(MARGIN);
    CGFloat trendTopAreaHeight = 37.0f;
    
    // 头部
    {
        [self.view addSubview:self.trendChartTopAreaView];
        [self.trendChartTopAreaView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(self.view);
            make.height.mas_equalTo(trendTopAreaHeight);
        }];
        
        [self.trendChartTopAreaView addSubview:self.trendChartTipTitleLabel];
        [self.trendChartTipTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.trendChartTopAreaView.mas_left).offset(margin*1.5f);
            make.top.bottom.equalTo(self.trendChartTopAreaView);
        }];
        
        // 倒计时
        [self.trendChartTopAreaView addSubview:self.trendCountDownView];
        [self.trendCountDownView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.trendChartTopAreaView).offset(-margin*1.5f);
            make.top.bottom.equalTo(self.trendChartTopAreaView);
        }];
    }
    
    // 走势
    [self.view addSubview:self.trendChartView];
    [self.trendChartView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo([FYBagLotteryTrendChartView headerViewHeight]);
        make.top.equalTo(self.trendChartTopAreaView.mas_bottom);
        make.left.right.equalTo(self.view);
    }];
    
    // 列表
    [self.tableViewRefresh mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.trendChartView.mas_bottom);
        make.left.right.bottom.equalTo(self.view);
    }];
}

- (UITableViewStyle)tableViewRefreshStyle
{
    return UITableViewStylePlain;
}

- (void)tableViewRefreshRegisterClass:(UITableView *)tableView
{
    [self.tableViewRefresh registerClass:[FYBagLotteryTrendTableViewCell class] forCellReuseIdentifier:[FYBagLotteryTrendTableViewCell reuseIdentifier]];
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
    return ActRequestBagBagLotteryTrendsChart;
}

- (NSMutableDictionary *)getRequestParamerter
{
    return @{
        @"oddVersion":self.groupInfoModel.oddsVerion,
        @"gameNumber":self.groupInfoModel.gameNumber,
        @"groupId":self.messageItem.groupId,
        @"userId":APPINFORMATION.userInfo.userId
    }.mutableCopy;
}

- (void)loadRequestDataThen:(void (^)(void))then
{
    if (self.isShowLoadingHUD) {
        PROGRESS_HUD_SHOW
    }
    WEAKSELF(weakSelf)
    [self loadRequestOtherDataThen:^(BOOL success, RobNiuNiuQunModel *model) {
        if (weakSelf.isShowLoadingHUD) {
            PROGRESS_HUD_DISMISS
            [weakSelf setIsShowLoadingHUD:NO];
        }
        !then ?: then();
    }];
}

- (void)loadRequestOtherDataThen:(void (^)(BOOL success, RobNiuNiuQunModel *model))then
{
    WEAKSELF(weakSelf)
    NSDictionary *parameters = @{
        @"groupId":self.messageItem.groupId,
        @"userId":APPINFORMATION.userInfo.userId
    };
    [NET_REQUEST_MANAGER requestWithAct:ActRequestBagBagLotteryInfo parameters:parameters success:^(id response) {
        FYLog(NSLocalizedString(@"包包牛群信息 => %@", nil), response);
        if (!NET_REQUEST_SUCCESS(response)) {
            !then ?: then(NO,nil);
        } else {
            NSDictionary *dicts = NET_REQUEST_DATA(response);
            FYBagLotteryGroupInfoModel *groupInfoModel = [FYBagLotteryGroupInfoModel mj_objectWithKeyValues:dicts];
            RobNiuNiuQunModel *robNiuNiuQunModel = [RobNiuNiuQunModel mj_objectWithKeyValues:dicts];
            [weakSelf setGroupInfoModel:groupInfoModel];
            [weakSelf setGameGroupInfoModel:robNiuNiuQunModel];
            [weakSelf.trendCountDownView setModelOfRobNiuNiu:robNiuNiuQunModel];
            !then ?: then(YES,robNiuNiuQunModel);
        }
    } failure:^(id error) {
        !then ?: then(NO,nil);
        [[FunctionManager sharedInstance] handleFailResponse:error];
    }];
}

- (NSMutableArray *)loadNetworkDataOrCacheData:(id)responseDataOrCacheData isCacheData:(BOOL)isCacheData
{
    FYLog(NSLocalizedString(@"包包彩走势 => \n%@", nil), responseDataOrCacheData);
    
    // 请求成功，解析数据
    if (!NET_REQUEST_SUCCESS(responseDataOrCacheData)) {
        self.tableDataRefresh = @[].mutableCopy;
        return self.tableDataRefresh;
    }

    // 数据解析
    self.trendChartResponse = [FYBagLotteryTrendResponse mj_objectWithKeyValues:responseDataOrCacheData];
    
    // 组装数据
    NSMutableArray<FYBagLotteryTrendModel *> *allItemModels = [NSMutableArray arrayWithArray:self.trendChartResponse.data.threes];
    
    // 未开奖期
    if (self.gameGroupInfoModel) {
        if (allItemModels.count > 0) {
            FYBagLotteryTrendModel *lastIssueModel = allItemModels.firstObject;
            if (self.gameGroupInfoModel.gameNumber > lastIssueModel.gameNumber.integerValue) {
                FYBagLotteryTrendModel *lastNewModel = [FYBagLotteryTrendModel new];
                [lastNewModel setIsIssuePlaying:YES];
                [lastNewModel setGameNumber:[NSString stringWithFormat:@"%ld", self.gameGroupInfoModel.gameNumber]];
                [allItemModels insertObject:lastNewModel atIndex:0];
            }
        } else {
            FYBagLotteryTrendModel *lastNewModel = [FYBagLotteryTrendModel new];
            [lastNewModel setIsIssuePlaying:YES];
            [lastNewModel setGameNumber:[NSString stringWithFormat:@"%ld", self.gameGroupInfoModel.gameNumber]];
            allItemModels = [NSMutableArray arrayWithObject:lastNewModel];
        }
    }
    
    // 配置数据源
    self.tableDataRefresh = [NSMutableArray array];
    if (allItemModels && 0 < allItemModels.count) {
        [self.tableDataRefresh addObjectsFromArray:allItemModels];
    }
    return self.tableDataRefresh;
}

- (void)viewDidLoadAfterLoadNetworkDataOrCacheData
{
    // 提示信息
    [self.trendChartTipTitleLabel setText:[NSString stringWithFormat:STR_GAME_TREND_CHART_TIP_TITLE_VALUE, self.trendChartResponse.data.threes.count]];
    
    // 刷新走势图
    [self.trendChartView refreshTrendChart:self.trendChartResponse];
}


#pragma mark - UITableViewDelegate & UITableViewDataSource

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
    FYBagLotteryTrendTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:[FYBagLotteryTrendTableViewCell reuseIdentifier]];
    if (cell == nil) {
        cell = [[FYBagLotteryTrendTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[FYBagLotteryTrendTableViewCell reuseIdentifier]];
    }
    cell.indexPath = indexPath;
    cell.model = self.tableDataRefresh[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [FYBagLotteryTrendTableViewCell height];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return self.tableSectionHeader;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return [FYBagLotteryTrendSectionHeader headerViewHeight];
}


#pragma mark - FYIMSessionViewControllerLotteryGameGroupInfoDelegate

- (void)didUpdateLotteryGameGroupInfoModel:(RobNiuNiuQunModel *)groupInfoModel
{
    if (self.gameGroupInfoModel.gameNumber == groupInfoModel.gameNumber) {
        [self.trendCountDownView setModelOfRobNiuNiu:groupInfoModel];
        return;
    }
    
    [self setGameGroupInfoModel:groupInfoModel];
    [self.trendCountDownView setModelOfRobNiuNiu:groupInfoModel];
    //
    [self loadData];
}


#pragma mark - Navigation

- (NSString *)prefersNavigationBarTitleViewTitle
{
    return STR_NAVIGATION_BAR_TITLE_BAGBAGLOTTERY_TRENDS;
}


#pragma mark - Getter & Setter

- (FYBagLotteryTrendChartView *)trendChartView
{
    if (!_trendChartView) {
        CGRect frame = CGRectMake(0, 0, self.tableViewRefresh.width, [FYBagLotteryTrendChartView headerViewHeight]);
        _trendChartView = [[FYBagLotteryTrendChartView alloc] initWithFrame:frame];
    }
    return _trendChartView;
}

- (FYBagLotteryTrendSectionHeader *)tableSectionHeader
{
    if (!_tableSectionHeader) {
        CGRect frame = CGRectMake(0, 0, self.tableViewRefresh.width, [FYBagLotteryTrendSectionHeader headerViewHeight]);
        _tableSectionHeader = [[FYBagLotteryTrendSectionHeader alloc] initWithFrame:frame];
    }
    return _tableSectionHeader;
}

- (UIView *)trendChartTopAreaView {
    if (!_trendChartTopAreaView) {
        _trendChartTopAreaView = [[UIView alloc] init];
    }
    return _trendChartTopAreaView;
}

- (UILabel *)trendChartTipTitleLabel
{
    if (!_trendChartTipTitleLabel) {
        _trendChartTipTitleLabel = [[UILabel alloc] init];
        [_trendChartTipTitleLabel setUserInteractionEnabled:YES];
        [_trendChartTipTitleLabel setFont:FONT_PINGFANG_REGULAR(15)];
        [_trendChartTipTitleLabel setTextAlignment:NSTextAlignmentLeft];
        [_trendChartTipTitleLabel setTextColor:COLOR_SYSTEM_MAIN_UI_THEME_DEFAULT];
        [_trendChartTipTitleLabel setText:STR_GAME_TREND_CHART_TIP_TITLE_DEFAULF];
    }
    return _trendChartTipTitleLabel;
}

- (FYTrendCoundDownView *)trendCountDownView {
    if (!_trendCountDownView) {
        _trendCountDownView = [[FYTrendCoundDownView alloc] init];
    }
    return _trendCountDownView;
}



@end
