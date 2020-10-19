//
//  FYJSSLGameTrendViewController.m
//  ProjectCSHB
//
//  Created by fangyuan on 2020/8/28.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "FYJSSLGameTrendViewController.h"
#import "FYJSSLGameTrendSectionHeader.h"
#import "FYJSSLGameTrendTableViewCell.h"
#import "FYJSSLGameTrendModel.h"
#import "FYTrendCoundDownView.h"
#import "RobNiuNiuQunModel.h"

@interface FYJSSLGameTrendViewController ()
@property(nonatomic, strong) MessageItem *messageItem;
@property(nonatomic, strong) FYJSSLGameTrendSectionHeader *tableSectionHeader;
//
@property(nonatomic, strong) UIView *trendChartTopAreaView;
@property(nonatomic, strong) UILabel *trendChartTipTitleLabel;
@property(nonatomic, strong) FYTrendCoundDownView *trendCountDownView; // 当前期倒计时
@property(nonatomic, strong) RobNiuNiuQunModel *gameGroupInfoModel;

@end

@implementation FYJSSLGameTrendViewController

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
    
    // 列表
    [self.tableViewRefresh mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.trendChartTopAreaView.mas_bottom);
        make.left.right.bottom.equalTo(self.view);
    }];
}

- (UITableViewStyle)tableViewRefreshStyle
{
    return UITableViewStylePlain;
}

- (void)tableViewRefreshRegisterClass:(UITableView *)tableView
{
    [self.tableViewRefresh registerClass:[FYJSSLGameTrendTableViewCell class] forCellReuseIdentifier:[FYJSSLGameTrendTableViewCell reuseIdentifier]];
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
    return ActRequestJsslGameTrendsChart;
}

- (NSMutableDictionary *)getRequestParamerter
{
    return @{
        @"chatId":self.messageItem.groupId,
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
        @"chatId":self.messageItem.groupId,
        @"userId":APPINFORMATION.userInfo.userId
    };
    [NET_REQUEST_MANAGER requestWithAct:ActRequestJsslInfo parameters:parameters success:^(id resonse) {
        FYLog(NSLocalizedString(@"极速扫雷群信息 => %@", nil), resonse);
        if (!NET_REQUEST_SUCCESS(resonse)) {
            !then ?: then(NO,nil);
        } else {
            NSDictionary *dicts = NET_REQUEST_DATA(resonse);
            RobNiuNiuQunModel *robNNModel = [RobNiuNiuQunModel mj_objectWithKeyValues:dicts];
            [weakSelf setGameGroupInfoModel:robNNModel];
            [weakSelf.trendCountDownView setModelOfRobNiuNiu:robNNModel];
            !then ?: then(YES,robNNModel);
        }
    } failure:^(id error) {
        !then ?: then(NO,nil);
        [[FunctionManager sharedInstance] handleFailResponse:error];
    }];
}

- (NSMutableArray *)loadNetworkDataOrCacheData:(id)responseDataOrCacheData isCacheData:(BOOL)isCacheData
{
    FYLog(NSLocalizedString(@"极速扫雷走势 => \n%@", nil), responseDataOrCacheData);
    
    // 请求成功，解析数据
    if (!NET_REQUEST_SUCCESS(responseDataOrCacheData)) {
        self.tableDataRefresh = @[].mutableCopy;
        return self.tableDataRefresh;
    }

    // 数据解析
    NSArray<NSDictionary *> *arrayOfDicts = NET_REQUEST_DATA(responseDataOrCacheData);
    NSMutableArray<FYJSSLGameTrendModel *> *allItemModels = [FYJSSLGameTrendModel mj_objectArrayWithKeyValuesArray:arrayOfDicts];
    
    // 未开奖期
    if (self.gameGroupInfoModel) {
        if (allItemModels.count > 0) {
            FYJSSLGameTrendModel *lastIssueModel = allItemModels.firstObject;
            if (self.gameGroupInfoModel.gameNumber > lastIssueModel.gameNumber.integerValue) {
                FYJSSLGameTrendModel *lastNewModel = [FYJSSLGameTrendModel new];
                [lastNewModel setIsIssuePlaying:YES];
                [lastNewModel setGameNumber:[NSString stringWithFormat:@"%ld", self.gameGroupInfoModel.gameNumber]];
                [allItemModels insertObject:lastNewModel atIndex:0];
            }
        } else {
            FYJSSLGameTrendModel *lastNewModel = [FYJSSLGameTrendModel new];
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
    __block NSInteger count = 0;
    for (FYJSSLGameTrendModel *model in self.tableDataRefresh) {
        if (!model.isIssuePlaying) {
            count ++;
        }
    }
    [self.trendChartTipTitleLabel setText:[NSString stringWithFormat:STR_GAME_TREND_CHART_TIP_TITLE_VALUE, count]];
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
    FYJSSLGameTrendTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:[FYJSSLGameTrendTableViewCell reuseIdentifier]];
    if (cell == nil) {
        cell = [[FYJSSLGameTrendTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[FYJSSLGameTrendTableViewCell reuseIdentifier]];
    }
    cell.indexPath = indexPath;
    cell.model = self.tableDataRefresh[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [FYJSSLGameTrendTableViewCell headerViewHeight];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return self.tableSectionHeader;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return [FYJSSLGameTrendSectionHeader headerViewHeight];
}


#pragma mark - FYGameJSSLViewControllerDelegate

- (void)didUpdateJSSLGameGroupInfoModel:(RobNiuNiuQunModel *)groupInfoModel
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

- (FYJSSLGameTrendSectionHeader *)tableSectionHeader
{
    if (!_tableSectionHeader) {
        CGRect frame = CGRectMake(0, 0, self.tableViewRefresh.width, [FYJSSLGameTrendSectionHeader headerViewHeight]);
        _tableSectionHeader = [[FYJSSLGameTrendSectionHeader alloc] initWithFrame:frame];
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
