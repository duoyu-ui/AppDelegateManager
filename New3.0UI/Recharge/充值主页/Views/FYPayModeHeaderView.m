//
//  FYPayModeHeaderView.m
//  ProjectCSHB
//
//  Created by fangyuan on 2020/5/17.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "FYRechargeMainViewController.h"
#import "FYPayModeHeaderView.h"
#import "FYPayModeScrollTab.h"
#import "FYPayModel.h"
#import "ZJScrollSegmentView.h"

@interface FYPayModeHeaderView ()
//
@property (nonatomic, strong) UILabel *userIdLabel;
@property (nonatomic, strong) UILabel *userNameLabel;
@property (nonatomic, strong) UILabel *userBalanceLabel;
@property (nonatomic, strong) UIImageView *headerImageView;
@property (nonatomic, strong) UIImageView *balanceImageView;
//
@property (nonatomic, weak) UIViewController *parentViewController;
@property (nonatomic, weak) ZJScrollSegmentView *segmentView;
@property (nonatomic, strong) FYPayModeScrollTab *payModelScrollTab;
@property (nonatomic, strong) NSArray<NSString *> *tabTitles;
@property (nonatomic, strong) NSArray<FYPayModel *> *tabPayModels;
@property (nonatomic, assign) CGFloat headerViewHeight;

@end

@implementation FYPayModeHeaderView

#pragma mark - Life Cycle

- (instancetype)initWithFrame:(CGRect)frame
             headerViewHeight:(CGFloat)headerViewHeight
                    tabTitles:(NSArray<NSString *> *)tabTitles
                 tabPayModels:(NSArray<FYPayModel *> *)tabPayModels
                  segmentView:(ZJScrollSegmentView *)segmentView
         parentViewController:(UIViewController *)parentViewController
{
    self = [super initWithFrame:frame];
    if (self) {
        _tabTitles = tabTitles;
        _tabPayModels = tabPayModels;
        _headerViewHeight = headerViewHeight;
        _segmentView = segmentView;
        _parentViewController = parentViewController;
        [self createViewAtuoLayout];
    }
    return self;
}

- (void)createViewAtuoLayout
{
    [self viewDidAddTopUserInfoView];
    [self viewDidAddBottomScrollTabView];
    [self setBackgroundColor:COLOR_TABLEVIEW_SEPARATOR_LINE_DEFAULT];
    
    // 加载数据
    [self doLoadDataAndRefreshMainUI];
    
    // 添加监听通知
    [self addNotifications];
}

- (void)viewDidAddTopUserInfoView
{
    CGFloat margin = CFC_AUTOSIZING_MARGIN(MARGIN);
    CGFloat userAreaHeight = TABLEVIEW_HEADER_HEIGHT_FOR_RECHARGE_USERINFO;
    
    UIView *userAreaView = ({
        UIView *view = [UIView new];
        [self addSubview:view];
        [view setBackgroundColor:[UIColor whiteColor]];

        [view mas_makeConstraints:^(MASConstraintMaker *make) {
             make.left.right.top.equalTo(self);
            make.height.mas_equalTo(userAreaHeight);
        }];
        
        view;
    });
    userAreaView.mas_key = @"userAreaView";
    
    UIImageView *headerImageView = ({
        CGFloat imageSize = userAreaHeight * 0.7f;
        UIImageView *imageView = [[UIImageView alloc] init];
        [userAreaView addSubview:imageView];
        [imageView setClipsToBounds:YES];
        [imageView addCornerRadius:imageSize*0.5f];
        [imageView setContentMode:UIViewContentModeScaleAspectFill];
        [imageView setImage:[UIImage imageNamed:@"icon_avatar_default"]];

        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(userAreaView.mas_centerY);
            make.left.equalTo(userAreaView.mas_left).offset(margin*1.5f);
            make.size.mas_equalTo(CGSizeMake(imageSize, imageSize));
        }];
        
        imageView;
    });
    self.headerImageView = headerImageView;
    self.headerImageView.mas_key = @"headerImageView";
    
    UILabel *userNameLabel = ({
        UILabel *label = [UILabel new];
        [userAreaView addSubview:label];
        [label setText:APPINFORMATION.userInfo.nick];
        [label setFont:[UIFont systemFontOfSize:CFC_AUTOSIZING_FONT(15)]];
        [label setTextColor:COLOR_SYSTEM_MAIN_FONT_DEFAULT];
        [label setTextAlignment:NSTextAlignmentLeft];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(headerImageView.mas_centerY);
            make.left.equalTo(headerImageView.mas_right).offset(margin*0.5f);
        }];
        
        label;
    });
    self.userNameLabel = userNameLabel;
    self.userNameLabel.mas_key = @"userNameLabel";
    
    if (!VALIDATE_STRING_EMPTY(APPINFORMATION.userInfo.userId)) {
        NSString *userIdString = [NSString stringWithFormat:@"ID:%@", APPINFORMATION.userInfo.userId];
        UIFont *font = FONT_PINGFANG_REGULAR(11);
        CGFloat width = [userIdString widthWithFont:font constrainedToHeight:CGFLOAT_MAX] + margin;
        CGFloat height = [userIdString heightWithFont:font constrainedToWidth:CGFLOAT_MAX] + margin*0.15f;
        
        UILabel *userIdLabel = ({
            UILabel *label = [UILabel new];
            [userAreaView addSubview:label];
            [label setFont:font];
            [label setText:userIdString];
            [label setTextColor:COLOR_HEXSTRING(@"#FFFFFF")];
            [label setTextAlignment:NSTextAlignmentCenter];
            [label setBackgroundColor:COLOR_SYSTEM_MAIN_UI_THEME_DEFAULT];
            [label addCornerRadius:margin*0.25f];
            
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(userNameLabel.mas_centerY);
                make.left.equalTo(userNameLabel.mas_right).offset(margin*0.5f);
                make.width.mas_equalTo(width);
                make.height.mas_equalTo(height);
            }];
            
            label;
        });
        self.userIdLabel = userIdLabel;
        self.userIdLabel.mas_key = @"userIdLabel";
    }
    
    UILabel *userBalanceLabel = ({
        UILabel *label = [UILabel new];
        [userAreaView addSubview:label];
        [label setText:APPINFORMATION.userInfo.balance];
        [label setFont:[UIFont systemFontOfSize:CFC_AUTOSIZING_FONT(14)]];
        [label setTextColor:COLOR_SYSTEM_MAIN_FONT_DEFAULT];
        [label setTextAlignment:NSTextAlignmentLeft];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(headerImageView.mas_centerY);
            make.width.mas_greaterThanOrEqualTo(50.0f);
        }];
        
        label;
    });
    self.userBalanceLabel = userBalanceLabel;
    self.userBalanceLabel.mas_key = @"userBalanceLabel";
    
    UIImageView *balanceImageView = ({
        CGFloat imageSize = userAreaHeight * 0.45f;
        UIImageView *imageView = [[UIImageView alloc] init];
        [userAreaView addSubview:imageView];
        [imageView setImage:[UIImage imageNamed:@"icon_balance_black"]];
        [imageView setContentMode:UIViewContentModeScaleAspectFill];

        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(userBalanceLabel.mas_centerY).offset(0.7f);
            make.right.equalTo(userBalanceLabel.mas_left);
            make.size.mas_equalTo(CGSizeMake(imageSize, imageSize));
        }];
        
        imageView;
    });
    self.balanceImageView = balanceImageView;
    self.balanceImageView.mas_key = @"balanceImageView";
    
    UIView *userBalanceBackView = ({
        CGFloat balanceAreaHeight = CFC_AUTOSIZING_WIDTH(55.0f)*0.57f; // 与个人中心保持一致
        UIView *view = [UIView new];
        [userAreaView insertSubview:view belowSubview:userBalanceLabel];
        [view addCornerRadius:balanceAreaHeight*0.5f];
        [view setBackgroundColor:COLOR_HEXSTRING(@"#EEEEEE")];

        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(headerImageView.mas_centerY);
            make.left.equalTo(balanceImageView.mas_left).offset(-margin*0.5f);
            make.right.equalTo(userAreaView.mas_right).offset(-margin*1.5f);
            make.height.mas_equalTo(balanceAreaHeight);
        }];

        view;
    });
    userBalanceBackView.mas_key = @"userBalanceBackView";
    
    [self.userBalanceLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(userBalanceBackView.mas_right).offset(-margin*1.0f);
    }];
}

- (void)viewDidAddBottomScrollTabView
{
    CGFloat payModeTabHeight = TABLEVIEW_HEADER_HEIGHT_FOR_RECHARGE_SEGMENT;
    if (!self.tabTitles || self.tabTitles.count < 2) {
        payModeTabHeight = 0.0f;
    }
    
    __block NSMutableArray<NSString *> *itemNormalImages = [[NSMutableArray<NSString *> alloc] init];
    __block NSMutableArray<NSString *> *itemSelectedImages = [[NSMutableArray<NSString *> alloc] init];
    [self.tabPayModels enumerateObjectsUsingBlock:^(FYPayModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [itemNormalImages addObj:obj.normalImages];
        [itemSelectedImages addObj:obj.selectedImages];
    }];
    
    CGFloat itemWidth = (SCREEN_MIN_LENGTH - 60) / 3.0f;//60是左右2边按钮的宽度
    if (self.tabTitles.count < 3) {
        itemWidth = (SCREEN_MIN_LENGTH - 60) / self.tabTitles.count;
    }
    
    FYPayModeScrollTabConfig *config = [[FYPayModeScrollTabConfig alloc] init];
    config.itemWidth = itemWidth;
    config.selectedTextColor = [UIColor whiteColor];
    config.unselectedTextColor = COLOR_SYSTEM_MAIN_FONT_DEFAULT;
    config.selectedBackgroundColor = [UIColor whiteColor];
    config.unselectedBackgroundColor = [UIColor whiteColor];
    config.font = FONT_PINGFANG_SEMI_BOLD(13);
    config.showCover = YES;
    config.coverHeight = payModeTabHeight * 0.56f;
    config.coverBorder = 0.0f;
    config.coverBorderColor = COLOR_TABLEVIEW_SEPARATOR_LINE_DEFAULT;
    config.coverCornerRadius = config.coverHeight * 0.5f;
    config.coverBackgroundColor = [UIColor colorWithRed:205.0/255.0 green:50.0/255.0 blue:36.0/255.0 alpha:1.0];
    //
    config.coverGradualChangeColor = YES;
    config.coverGradualColors = @[ COLOR_HEXSTRING(@"#DF5E43"), COLOR_HEXSTRING(@"#CD3224")];
    //
    config.items = self.tabTitles;
    config.itemNormalImages = itemNormalImages;
    config.itemSelectedImages = itemSelectedImages;
    //
    __weak __typeof(&*self)weakSelf = self;
    FYPayModeScrollTab *payModeScrollTab = [[FYPayModeScrollTab alloc] init];
    [self addSubview:payModeScrollTab];
    [self setPayModelScrollTab:payModeScrollTab];
    [payModeScrollTab setConfig:config];
    [payModeScrollTab setSelected:^(NSString * _Nonnull selection, NSInteger index) {
        [weakSelf.segmentView setSelectedIndex:index animated:YES];
    }];
    [payModeScrollTab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.height.mas_equalTo(payModeTabHeight);
    }];
    
    // 分割线
    {
        CGRect frameOfLine = CGRectMake(0,self.height-SEPARATOR_LINE_HEIGHT, self.width, SEPARATOR_LINE_HEIGHT);
        UIView *separatorLineView = [[UIView alloc] initWithFrame:frameOfLine];
        [separatorLineView setBackgroundColor:COLOR_GAME_MENU_SEPARATOR_LINE];
        [self addSubview:separatorLineView];
    }
}

- (void)setSelectedIndex:(NSInteger)index animated:(BOOL)animated
{
    NSAssert(index >= 0 && index < self.tabTitles.count, NSLocalizedString(@"设置的下标不合法!!", nil));

    if (index < 0 || index >= self.tabTitles.count) {
        return;
    }
    
    [self.payModelScrollTab setIndex:index];
    // [self.payModelScrollTab setIndex:index animated:animated];
}


#pragma mark - Network

- (void)loadRequestUserInfoThen:(void (^)(void))then
{
    [NET_REQUEST_MANAGER requestUpdateUserInfoWithSuccess:^(id response) {
        FYLog(NSLocalizedString(@"用户数据 => \n%@", nil), response);
        !then ?: then();
    } failure:^(id error) {
        FYLog(NSLocalizedString(@"获取用户信息异常！ => \n%@", nil), error);
        !then ?: then();
    }];
}


#pragma mark - FYRechargeMainViewControllerProtocol

- (void)doAnyThingForPayModeHeaderView:(FYRechargeMainProtocolFuncType)type
{
    if (FYRechargeMainProtocolFuncTypeRefreshHeaderData == type) {
        [self doLoadDataAndRefreshMainUI];
    }
}


#pragma mark - Notification

/// 添加监听通知
- (void)addNotifications
{
    // 余额变动通知
    [NOTIF_CENTER addObserver:self selector:@selector(doNotificationUpdateUserInfoBalance:) name:kNotificationUserInfoBalanceChange object:nil];
}

/// 通知事件处理 - 余额实时变动
- (void)doNotificationUpdateUserInfoBalance:(NSNotification *)notification
{
    NSDictionary *object = (NSDictionary *)notification.object;
    NSString *balance = [object stringForKey:@"balance"];
    if (VALIDATE_STRING_EMPTY(balance)) {
        return;
    }
    
    WEAKSELF(weakSelf);
    dispatch_main_async_safe((^{
        NSString *formatBalacne = [NSString stringWithFormat:@"%0.2f", balance.floatValue];
        [weakSelf.userBalanceLabel setText:formatBalacne];
    }));
}

/// 释放资源
- (void)dealloc
{
    [NOTIF_CENTER removeObserver:self];
}


#pragma mark - Private

- (void)doLoadDataAndRefreshMainUI
{
    // 赋值
    WEAKSELF(weakSelf);
    [self loadRequestUserInfoThen:^{
        [weakSelf.userIdLabel setText:[NSString stringWithFormat:@"ID:%@", APPINFORMATION.userInfo.userId]];
        [weakSelf.userNameLabel setText:STR_TRI_WHITE_SPACE(APPINFORMATION.userInfo.nick)];
        [weakSelf.userBalanceLabel setText:STR_TRI_WHITE_SPACE(APPINFORMATION.userInfo.balance)];
        if ([CFCSysUtil validateStringUrl:APPINFORMATION.userInfo.avatar]) {
            __block UIActivityIndicatorView *activityIndicator = nil;
            UIImage *placeholderImage = [UIImage imageNamed:@"icon_avatar_default_big"];
            [weakSelf.headerImageView sd_setImageWithURL:[NSURL URLWithString:APPINFORMATION.userInfo.avatar] placeholderImage:placeholderImage options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    if (!activityIndicator) {
                        [self.headerImageView addSubview:activityIndicator = [UIActivityIndicatorView.alloc initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite]];
                        [activityIndicator setColor:COLOR_ACTIVITY_INDICATOR_BACKGROUND];
                        [activityIndicator setCenter:self.headerImageView.center];
                        [activityIndicator startAnimating];
                        [activityIndicator mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.centerX.equalTo(self.headerImageView.mas_centerX);
                            make.centerY.equalTo(self.headerImageView.mas_centerY);
                        }];
                    }
                }];
            } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                [activityIndicator removeFromSuperview];
                activityIndicator = nil;
            }];
        } else {
            [weakSelf.headerImageView setImage:[UIImage imageNamed:@"icon_avatar_default"]];
        }
    }];
}



@end


