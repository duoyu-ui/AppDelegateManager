//
//  FYBagBagCowTrendViewController.m
//  ProjectCSHB
//
//  Created by fangyuan on 2020/7/22.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "FYBagBagCowTrendViewController.h"
#import "FYBagBagCowTrendSectionHeader.h"
#import "FYBagBagCowTrendTableViewCell.h"
#import "FYBagBagCowTrendChartView.h"
#import "FYBagBagCowTrendModel.h"
#import "FYTrendCoundDownView.h"
#import "RobNiuNiuQunModel.h"

#define STR_TRENDCHARTTYPE_TITLE_BANKER      NSLocalizedString(@"庄家走势", nil)
#define STR_TRENDCHARTTYPE_TITLE_PLAYER      NSLocalizedString(@"闲家走势", nil)

@interface FYBagBagCowTrendViewController ()
@property(nonatomic, strong) MessageItem *messageItem;
@property(nonatomic, strong) FYBagBagCowTrendChartView *trendChartView;
@property(nonatomic, strong) FYBagBagCowTrendSectionHeader *tableSectionHeader;
//
@property(nonatomic, strong) UIView *trendChartTopAreaView;
// 庄/闲类型切换
@property(nonatomic, strong) UILabel *trendChartTypeTitleLabel;
@property(nonatomic, assign) BOOL isTrendChartTypeBankerNumber;
// 当前期倒计时
@property(nonatomic, strong) FYTrendCoundDownView *trendCountDownView;
@property(nonatomic, strong) RobNiuNiuQunModel *gameGroupInfoModel;

@end

@implementation FYBagBagCowTrendViewController

#pragma mark - Life Cycle

- (instancetype)initWithMessageItem:(MessageItem *)messageItem
{
    self = [super init];
    if (self) {
        _messageItem = messageItem;
        _isTrendChartTypeBankerNumber = YES;
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
    CGFloat trendChartTypeButtonHeight = 28.0f;
    CGFloat imageHeight = trendChartTypeButtonHeight * 0.5f;
    CGFloat imageWidth = imageHeight * 1.176470588235f;

    // 头部
    {
        [self.view addSubview:self.trendChartTopAreaView];
        [self.trendChartTopAreaView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(self.view);
            make.height.mas_equalTo(trendTopAreaHeight);
        }];
        
        // 切换按钮
        UIView *trendChartTypeButton = [UIView new];
        {
            [self.trendChartTopAreaView addSubview:trendChartTypeButton];
            UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pressTrendChartTypeChangeView:)];
            [trendChartTypeButton addGestureRecognizer:tapGesture];
            [trendChartTypeButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self.trendChartTopAreaView.mas_centerY);
                make.left.equalTo(self.trendChartTopAreaView.mas_left);
                make.height.mas_equalTo(trendChartTypeButtonHeight);
            }];
            
            // 按钮 - 图标
            UIImageView *imageView = [[UIImageView alloc] init];
            [trendChartTypeButton addSubview:imageView];
            [imageView setUserInteractionEnabled:YES];
            [imageView setContentMode:UIViewContentModeScaleAspectFit];
            [imageView setImage:[UIImage imageNamed:@"icon_game_change"]];
            [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(trendChartTypeButton.mas_left).offset(margin*1.5f);
                make.centerY.equalTo(trendChartTypeButton.mas_centerY);
                make.size.mas_equalTo(CGSizeMake(imageHeight, imageWidth));
            }];
            
            // 按钮 - 标题
            [trendChartTypeButton addSubview:self.trendChartTypeTitleLabel];
            [self.trendChartTypeTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(imageView.mas_right).offset(margin*0.7f);
                make.top.bottom.equalTo(trendChartTypeButton);
            }];
            
            // 按钮宽度
            [trendChartTypeButton mas_updateConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.trendChartTypeTitleLabel.mas_right).offset(margin*1.5f);
            }];
        }
        
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
        make.height.mas_equalTo([FYBagBagCowTrendChartView headerViewHeight]);
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
    [self.tableViewRefresh registerClass:[FYBagBagCowTrendTableViewCell class] forCellReuseIdentifier:[FYBagBagCowTrendTableViewCell reuseIdentifier]];
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
    return ActRequestBagBagCowTrendsChart;
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
        }
        !then ?: then();
    }];
}

- (void)loadRequestOtherDataThen:(void (^)(BOOL success, RobNiuNiuQunModel *model))then
{
    WEAKSELF(weakSelf)
    NSDictionary *parameters = @{ @"chatId":self.messageItem.groupId };
    [NET_REQUEST_MANAGER requestWithAct:ActRequestBagBagCowGetBBNInfo parameters:parameters success:^(id resonse) {
        FYLog(NSLocalizedString(@"包包牛群信息 => %@", nil), resonse);
        if (!NET_REQUEST_SUCCESS(resonse)) {
            !then ?: then(NO,nil);
        } else {
            NSDictionary *dicts = NET_REQUEST_DATA(resonse);
            RobNiuNiuQunModel *model = [RobNiuNiuQunModel mj_objectWithKeyValues:dicts];
            [weakSelf setGameGroupInfoModel:model];
            [weakSelf.trendCountDownView setModelOfRobNiuNiu:model];
            !then ?: then(YES,model);
        }
    } failure:^(id error) {
        !then ?: then(NO,nil);
        [[FunctionManager sharedInstance] handleFailResponse:error];
    }];
}

- (NSMutableArray *)loadNetworkDataOrCacheData:(id)responseDataOrCacheData isCacheData:(BOOL)isCacheData
{
    FYLog(NSLocalizedString(@"包包牛走势 => \n%@", nil), responseDataOrCacheData);
    
    // 请求成功，解析数据
    if (!NET_REQUEST_SUCCESS(responseDataOrCacheData)) {
        self.tableDataRefresh = @[].mutableCopy;
        return self.tableDataRefresh;
    }

    // 组装数据
    NSArray<NSDictionary *> *arrayOfDicts = NET_REQUEST_DATA(responseDataOrCacheData);
    NSMutableArray<FYBagBagCowTrendModel *> *allItemModels = [FYBagBagCowTrendModel mj_objectArrayWithKeyValuesArray:arrayOfDicts];
    
    // 未开奖期
    if (self.gameGroupInfoModel) {
        if (allItemModels.count > 0) {
            FYBagBagCowTrendModel *lastIssueModel = allItemModels.firstObject;
            if (self.gameGroupInfoModel.gameNumber > lastIssueModel.gameNumber.integerValue) {
                FYBagBagCowTrendModel *lastNewModel = [FYBagBagCowTrendModel new];
                [lastNewModel setIsIssuePlaying:YES];
                [lastNewModel setGameNumber:[NSString stringWithFormat:@"%ld", self.gameGroupInfoModel.gameNumber]];
                [allItemModels insertObject:lastNewModel atIndex:0];
            }
        } else {
            FYBagBagCowTrendModel *lastNewModel = [FYBagBagCowTrendModel new];
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
    // 刷新走势图
    [self.trendChartView refreshTrendChart:self.tableDataRefresh isBankerNumberTrendChart:self.isTrendChartTypeBankerNumber];
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
    FYBagBagCowTrendTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:[FYBagBagCowTrendTableViewCell reuseIdentifier]];
    if (cell == nil) {
        cell = [[FYBagBagCowTrendTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[FYBagBagCowTrendTableViewCell reuseIdentifier]];
    }
    cell.indexPath = indexPath;
    cell.model = self.tableDataRefresh[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [FYBagBagCowTrendTableViewCell height];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return self.tableSectionHeader;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return [FYBagBagCowTrendSectionHeader headerViewHeight];
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
    
#if 1
    [self loadData];
#else
    if ([self.tableViewRefresh.mj_header isRefreshing]) {
        [self.tableViewRefresh.mj_header endRefreshing];
    }
    [self scrollTableToTopAnimated:NO];
    [self.tableViewRefresh.mj_header beginRefreshing];
#endif
}


#pragma mark - Navigation

- (NSString *)prefersNavigationBarTitleViewTitle
{
    return STR_NAVIGATION_BAR_TITLE_BAGBAGCOW_TRENDS;
}


#pragma mark - Getter & Setter

- (FYBagBagCowTrendChartView *)trendChartView
{
    if (!_trendChartView) {
        CGRect frame = CGRectMake(0, 0, self.tableViewRefresh.width, [FYBagBagCowTrendChartView headerViewHeight]);
        _trendChartView = [[FYBagBagCowTrendChartView alloc] initWithFrame:frame];
    }
    return _trendChartView;
}

- (FYBagBagCowTrendSectionHeader *)tableSectionHeader
{
    if (!_tableSectionHeader) {
        CGRect frame = CGRectMake(0, 0, self.tableViewRefresh.width, [FYBagBagCowTrendSectionHeader headerViewHeight]);
        _tableSectionHeader = [[FYBagBagCowTrendSectionHeader alloc] initWithFrame:frame];
    }
    return _tableSectionHeader;
}

- (UIView *)trendChartTopAreaView {
    if (!_trendChartTopAreaView) {
        _trendChartTopAreaView = [[UIView alloc] init];
    }
    return _trendChartTopAreaView;
}

- (UILabel *)trendChartTypeTitleLabel
{
    if (!_trendChartTypeTitleLabel) {
        _trendChartTypeTitleLabel = [[UILabel alloc] init];
        [_trendChartTypeTitleLabel setUserInteractionEnabled:YES];
        [_trendChartTypeTitleLabel setFont:FONT_PINGFANG_REGULAR(15)];
        [_trendChartTypeTitleLabel setTextAlignment:NSTextAlignmentLeft];
        [_trendChartTypeTitleLabel setTextColor:COLOR_SYSTEM_MAIN_UI_THEME_DEFAULT];
        [_trendChartTypeTitleLabel setText:STR_TRENDCHARTTYPE_TITLE_BANKER];
    }
    return _trendChartTypeTitleLabel;
}

- (FYTrendCoundDownView *)trendCountDownView {
    if (!_trendCountDownView) {
        _trendCountDownView = [[FYTrendCoundDownView alloc] init];
    }
    return _trendCountDownView;
}


#pragma mark - Priavte

/// 切换图表类型
- (void)pressTrendChartTypeChangeView:(UITapGestureRecognizer *)gesture
{
    self.isTrendChartTypeBankerNumber = !self.isTrendChartTypeBankerNumber;
    
    // 按钮标题
    NSString *titleString = self.isTrendChartTypeBankerNumber ? STR_TRENDCHARTTYPE_TITLE_BANKER : STR_TRENDCHARTTYPE_TITLE_PLAYER;
    [self.trendChartTypeTitleLabel setText:titleString];
    
    // 刷新走势
    [self.trendChartView refreshTrendChart:self.tableDataRefresh isBankerNumberTrendChart:self.isTrendChartTypeBankerNumber];
}


@end

