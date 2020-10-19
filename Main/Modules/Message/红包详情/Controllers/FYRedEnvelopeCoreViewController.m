//
//  FYRedEnvelopeCoreViewController.m
//  ProjectCSHB
//
//  Created by fangyuan on 2020/7/23.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "FYRedEnvelopeCoreViewController.h"
#import "FYRedEnvelopeCoreTableViewCell.h"
#import "FYRedEnvelopeCoreTableHeader.h"

@interface FYRedEnvelopeCoreViewController () <UITableViewDelegate, UITableViewDataSource, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>
@property (nonatomic, strong) FYRedEnvelopeCoreTableHeader *tableHeaderView;
@property (nonatomic, strong) UIImageView *navBackgroundImageView;
@property (nonatomic, strong) UIButton *navBarReturnButton;
@property (nonatomic, strong) UILabel *navBarTitleLabel;
@property (nonatomic, assign) BOOL isShowLoadingHUD;
@property (nonatomic, assign) BOOL isEmptyDataSetShouldDisplay;
@property (nonatomic, strong) NSTimer *timer;
@end

@implementation FYRedEnvelopeCoreViewController

#pragma mark - Life Cycle

- (instancetype)init
{
    self = [super init];
    if (self) {
        _isShowLoadingHUD = YES;
        _isEmptyDataSetShouldDisplay = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self viewDidOfMainUIView];
    
    [self loadNetworkData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.timer invalidate];
    [self.tableHeaderView.timer invalidate];
    [self cleanTimer];
    //
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)viewDidOfMainUIView
{
    [self viewDidOfNavBarView];
    
    [self.view addSubview:self.tableView];
    [self.view setBackgroundColor:COLOR_HEXSTRING(@"#FFFFFF")];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self.view);
        make.top.equalTo(self.navBackgroundImageView.mas_bottom);
    }];
    self.tableView.tableHeaderView = [self tableViewRefreshHeaderView];
    
    [self tableViewRefreshSetting:self.tableView];
}

- (void)viewDidOfNavBarView
{
    [self.view addSubview:self.navBackgroundImageView];
    [self.navBackgroundImageView addSubview:self.navBarReturnButton];
    [self.navBackgroundImageView addSubview:self.navBarTitleLabel];
    
    CGFloat navBackgroundImageViewHeight = SCREEN_WIDTH * (318.0 / 1080.0) + (CFC_IS_IPHONE_X_OR_GREATER?20.0f:0.0f);
    [self.navBackgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.height.mas_equalTo(navBackgroundImageViewHeight);
    }];
    
    [self.navBarReturnButton mas_makeConstraints:^(MASConstraintMaker *make) {
        CGFloat size = 25.0f;
        make.left.mas_equalTo(5);
        make.width.height.mas_equalTo(size);
        make.top.mas_equalTo(STATUS_BAR_HEIGHT + (NAVIGATION_BAR_HEIGHT-size)*0.5f);
    }];
    
    [self.navBarTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.navBackgroundImageView);
        make.centerY.equalTo(self.navBarReturnButton);
    }];
}

- (void)tableViewRefreshSetting:(UITableView * _Nonnull)tableView
{
    [tableView registerClass:[FYRedEnvelopeCoreTableViewCell class] forCellReuseIdentifier:[FYRedEnvelopeCoreTableViewCell reuseIdentifier]];
}

- (FYRedEnvelopeCoreTableHeader *)tableViewRefreshHeaderView
{
    return self.tableHeaderView;
}


#pragma mark - Network

- (Act)getRequestInfoAct
{
    return ActNil;
}

- (NSMutableDictionary *)getRequestParamerter
{
    return @{ @"packetId": self.packetId }.mutableCopy;
}

- (void)loadNetworkData
{
    WEAKSELF(weakSelf);
    [self loadNetworkDataThen:^(BOOL success, NSUInteger count) {
        [weakSelf.tableView.mj_header endRefreshing];
        if (success && count > 0) {
            [weakSelf.tableView reloadData];
        } else {
            [weakSelf.tableView reloadData];
            [weakSelf setIsEmptyDataSetShouldDisplay:YES];
            [weakSelf.tableView reloadEmptyDataSet];
        }
    }];
}

- (void)loadNetworkDataThen:(void (^)(BOOL success, NSUInteger count))then
{
    WEAKSELF(weakSelf);
    __block BOOL isSuccess = NO;
    __block NSUInteger listCount = 0;
    Act actInfo = [weakSelf getRequestInfoAct];
    NSMutableDictionary *params = [weakSelf getRequestParamerter];
    if (ActNil == actInfo) {
        !then ?: then(isSuccess, listCount);
        return ;
    }
    if (self.isShowLoadingHUD) {
        PROGRESS_HUD_SHOW
    }
    [NET_REQUEST_MANAGER requestWithAct:actInfo requestType:RequestType_post parameters:params success:^(id responseObject) {
        NSMutableArray *responseTableData = [weakSelf loadNetworkDataResponse:responseObject];
        listCount = responseTableData.count;
        !then ?: then(YES, listCount);
        if (weakSelf.isShowLoadingHUD) {
            PROGRESS_HUD_DISMISS
        }
        weakSelf.isShowLoadingHUD = NO;
    } failure:^(id error) {
        FYLog(NSLocalizedString(@"加载请求网络数据异常：%@", nil), error);
        [weakSelf loadNetworkDataResponse:error];
        !then ?: then(NO, listCount);
        if (weakSelf.isShowLoadingHUD) {
            PROGRESS_HUD_DISMISS
        }
        weakSelf.isShowLoadingHUD = NO;
        ALTER_HTTP_ERROR_MESSAGE(error);
    }];
}

- (NSMutableArray *)loadNetworkDataResponse:(id)response
{
    // TODO: 在具体子类中处理
    
    return nil;
}


#pragma mark - Timer

- (void)timerAction
{
    self.countDownTimes -= 1;
    if (self.countDownTimes <= -1) {
         [self.timer invalidate];
    } else {
        [self loadNetworkData];
    }
}

///倒计时
- (void)scheduledTimerCountDown
{
    [self.timer invalidate];
    if (self.countDownTimes < -1) {
        return;
    }
    self.timer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (void)timerCountDownClear
{
    [self.timer invalidate];
    self.timer = nil;
}


#pragma mark - UITableViewDelegate & UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.tableDataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FYRedEnvelopeCoreTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[FYRedEnvelopeCoreTableViewCell reuseIdentifier] forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[FYRedEnvelopeCoreTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[FYRedEnvelopeCoreTableViewCell reuseIdentifier]];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [FYRedEnvelopeCoreTableViewCell height];
}


#pragma mark - DZNEmptyDataSetSource & DZNEmptyDataSetDelegate

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = STR_SCROLL_EMPTY_DATASET_TITLE;
    NSDictionary *attributes = @{ NSFontAttributeName : [UIFont systemFontOfSize:CFC_AUTOSIZING_FONT(16.0f)],
                                  NSForegroundColorAttributeName : [UIColor colorWithRed:0.78 green:0.78 blue:0.78 alpha:1.00]};
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView
{
    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    paragraph.alignment = NSTextAlignmentCenter;
    
    NSString *text = STR_SCROLL_EMPTY_DATASET_TIPINFO;
    NSDictionary *attributes = @{ NSFontAttributeName: [UIFont systemFontOfSize:CFC_AUTOSIZING_FONT(13.0f)],
                                  NSForegroundColorAttributeName:[UIColor colorWithRed:0.78 green:0.78 blue:0.78 alpha:1.00],
                                  NSParagraphStyleAttributeName: paragraph};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    CGSize imageSize = CGSizeMake(SCREEN_WIDTH*SCROLL_EMPTY_DATASET_SCALE, SCREEN_WIDTH*SCROLL_EMPTY_DATASET_SCALE);
    return [[UIImage imageNamed:ICON_SCROLLVIEW_EMPTY_DATASET_MESSAGE] imageByScalingProportionallyToSize:imageSize];
}

- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView
{
    return CFC_AUTOSIZING_HEIGTH(0.0f);
}

- (UIColor *)backgroundColorForEmptyDataSet:(UIScrollView *)scrollView
{
    return COLOR_TABLEVIEW_BACK_VIEW_BACKGROUND_DEFAULT;
}

#pragma mark 是否显示空白页
- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView
{
    return self.isEmptyDataSetShouldDisplay;
}

- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView
{
    return YES;
}

- (BOOL)emptyDataSetShouldAllowImageViewAnimate:(UIScrollView *)scrollView
{
    return YES;
}


#pragma mark - Getter & Setter

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.emptyDataSetSource = self;
        _tableView.emptyDataSetDelegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            // Fallback on earlier versions
        }
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        //
        CFCRefreshHeader *refreshHeader = [CFCRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNetworkData)];
        [refreshHeader setBackgroundColor:COLOR_HEXSTRING(@"#FFFFFF")];
        [_tableView setMj_header:refreshHeader];
    }
    return _tableView;
}

- (FYRedEnvelopeCoreTableHeader *)tableHeaderView
{
    if (!_tableHeaderView) {
        CGRect frame = CGRectMake(0, 0, self.tableView.width, [FYRedEnvelopeCoreTableHeader headerHeight:self.type]);
        _tableHeaderView = [[FYRedEnvelopeCoreTableHeader alloc] initWithFrame:frame type:self.type];
    }
    return _tableHeaderView;
}

- (UIImageView *)navBackgroundImageView
{
    if (!_navBackgroundImageView) {
        _navBackgroundImageView = [[UIImageView alloc] init];
        [_navBackgroundImageView setImage:[UIImage imageNamed:@"navBgIcon"]];
        _navBackgroundImageView.userInteractionEnabled = YES;
    }
    return _navBackgroundImageView;
}

- (UIButton *)navBarReturnButton
{
    if (!_navBarReturnButton) {
        _navBarReturnButton = [[UIButton alloc] init];
        [_navBarReturnButton addTarget:self action:@selector(returnClick) forControlEvents:UIControlEventTouchUpInside];
        [_navBarReturnButton setBackgroundImage:[UIImage imageNamed:@"navReturnIcon"] forState:UIControlStateNormal];
    }
    return _navBarReturnButton;
}

- (UILabel *)navBarTitleLabel
{
    if (!_navBarTitleLabel) {
        _navBarTitleLabel = [[UILabel alloc] init];
        _navBarTitleLabel.font = [self prefersNavigationBarTitleFont];
        _navBarTitleLabel.textColor = [UIColor whiteColor];
        _navBarTitleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _navBarTitleLabel;
}

- (NSMutableArray *)tableDataSource
{
    if (!_tableDataSource) {
        _tableDataSource = [NSMutableArray arrayWithCapacity:0];
    }
    return _tableDataSource;
}

- (void)returnClick
{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - Navigation

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}


#pragma mark - Private

- (void)dealloc
{
    [self cleanTimer];
}

/// 释放定时器
- (void)cleanTimer
{
    if ( _timer ) {
        [_timer invalidate];
        _timer = nil;
    }
}

- (void)setType:(GroupTemplateType)type
{
    _type = type;
    self.navBarTitleLabel.text = [self titleWithType:type];
}

- (NSString *)titleWithType:(GroupTemplateType)type
{
    switch (type) {
        case GroupTemplate_N00_FuLi:
            return NSLocalizedString(@"福利红包", nil);
            break;
        case GroupTemplate_N01_Bomb:
            return NSLocalizedString(@"扫雷红包", nil);
            break;
        case GroupTemplate_N02_NiuNiu:
            return NSLocalizedString(@"牛牛红包", nil);
            break;
        case GroupTemplate_N03_JingQiang:
            return NSLocalizedString(@"禁抢红包", nil);
            break;
        case GroupTemplate_N04_RobNiuNiu:
            return NSLocalizedString(@"抢庄牛牛红包", nil);
            break;
        case GroupTemplate_N05_ErBaGang:
            return NSLocalizedString(@"二八杠红包", nil);
            break;
        case GroupTemplate_N06_LongHuDou:
            return NSLocalizedString(@"龙虎斗红包", nil);
            break;
        case GroupTemplate_N07_JieLong:
            return NSLocalizedString(@"接龙红包", nil);
            break;
        case GroupTemplate_N08_ErRenNiuNiu:
            return NSLocalizedString(@"二人牛牛红包", nil);
            break;
        case GroupTemplate_N09_SuperBobm:
            return NSLocalizedString(@"超级扫雷红包", nil);
            break;
        case GroupTemplate_N10_BagLottery:
            return NSLocalizedString(@"包包彩红包", nil);
            break;
        case GroupTemplate_N11_BagBagCow:
            return NSLocalizedString(@"包包牛红包", nil);
            break;
        case GroupTemplate_N14_BestNiuNiu:
            return NSLocalizedString(@"百人牛牛", nil);
            break;
        default:
            return @"";
            break;
    }
}

@end

