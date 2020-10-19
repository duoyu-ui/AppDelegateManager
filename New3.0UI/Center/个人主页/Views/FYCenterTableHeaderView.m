//
//  FYCenterTableHeaderView.m
//  ProjectCSHB
//
//  Created by fangyuan on 2020/5/19.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "FYCenterMainViewController.h"
#import "FYCenterTableHeaderView.h"
#import "FYCenterMoneyLabel.h"

@interface FYCenterTableHeaderView ()
//
@property (nonatomic, weak) CFCNavBarViewController *parentViewController;
@property (nonatomic, assign) CGFloat headerHeight;
//
@property (nonatomic, strong) UIImageView *backgroundImageView;
//
@property (nonatomic, strong) UIView *navBarAreaContainer;
//
@property (nonatomic, strong) UIView *userAreaContainer;
@property (nonatomic, strong) UILabel *userVipLabel;
@property (nonatomic, strong) UILabel *userIdLabel;
@property (nonatomic, strong) UILabel *userNameLabel;
@property (nonatomic, strong) UILabel *userBalanceLabel;
@property (nonatomic, strong) UILabel *appVersionLabel;
@property (nonatomic, strong) UIView *userBalanceBackView;
@property (nonatomic, strong) UIImageView *headerImageView;
@property (nonatomic, strong) UIImageView *balanceImageView;
//
@property (nonatomic, strong) UIImageView *balanceAreaContainer;
@property (nonatomic, strong) FYCenterMoneyLabel *todayRechargeLabel;
@property (nonatomic, strong) FYCenterMoneyLabel *todayWithdrawLabel;
@property (nonatomic, strong) FYCenterMoneyLabel *todayProfitLabel;
@property (nonnull, nonatomic, strong) NSMutableArray<NSString *> *btnTitleArray;
@property (nonnull, nonatomic, strong) NSMutableArray<UILabel *> *btnTitleLabelArray;
@property (nonnull, nonatomic, strong) NSMutableArray<UIImageView *> *btnPictureImageArray;

@end

@implementation FYCenterTableHeaderView

#pragma mark - Actions

- (void)pressNavBarButtonActionSetting:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(pressNavBarButtonActionSetting:)]) {
        [self.delegate pressNavBarButtonActionSetting:sender];
    }
}

- (void)pressNavBarButtonActionCustomer:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(pressNavBarButtonActionCustomer:)]) {
        [self.delegate pressNavBarButtonActionCustomer:sender];
    }
}

- (void)pressNavBarButtonActionMyQRCode:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(pressNavBarButtonActionMyQRCode:)]) {
        [self.delegate pressNavBarButtonActionMyQRCode:sender];
    }
}

- (void)pressNavBarButtonActionVersion:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(pressNavBarButtonActionVersion:)]) {
        [self.delegate pressNavBarButtonActionVersion:sender];
    }
}

- (void)pressNavBarButtonActionUserHeader:(UITapGestureRecognizer *)gesture
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(pressNavBarButtonActionUserHeader)]) {
        [self.delegate pressNavBarButtonActionUserHeader];
    }
}

- (void)pressNavBarButtonActionVIPRule:(UITapGestureRecognizer *)gesture
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(pressNavBarButtonActionUserVIP)]) {
        [self.delegate pressNavBarButtonActionUserVIP];
    }
}


#pragma mark - Life Cycle

- (instancetype)initWithFrame:(CGRect)frame headerHeight:(CGFloat)headerHeight parentViewController:(CFCNavBarViewController *)parentViewController
{
    self = [super initWithFrame:frame];
    if (self) {
        _headerHeight = headerHeight;
        _parentViewController = parentViewController;
        [self createViewAtuoLayout];
    }
    return self;
}

- (void)createViewAtuoLayout
{
    // 背景
    [self addSubview:self.backgroundImageView];
    [self.backgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self);
    }];
    
    // 余额区域
    [self addSubview:self.balanceAreaContainer];
    [self.balanceAreaContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.height.equalTo(self.mas_width).multipliedBy(0.1753086419f);
    }];
    
    // 导航区域
    [self addSubview:self.navBarAreaContainer];
    [self.navBarAreaContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self);
        make.height.mas_equalTo(STATUS_NAVIGATION_BAR_HEIGHT);
    }];
    
    // 用户区域
    [self addSubview:self.userAreaContainer];
    [self.userAreaContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(self.navBarAreaContainer.mas_bottom);
        make.height.equalTo(self.mas_height).multipliedBy(0.33f);

    }];
    
    [self createNavBarAreaAtuoLayout];
    [self createUserAreaAtuoLayout];
    [self createBalanceAreaAtuoLayout];
    
    // 添加监听通知
    [self addNotifications];
}

- (void)createNavBarAreaAtuoLayout
{
    CGFloat margin = CFC_AUTOSIZING_MARGIN(MARGIN);
        
    // 设置按钮
    UIButton *btnOfSetting = ({
        UIButton *btnOfSetting = [self.parentViewController createButtonWithImage:@"icon_setting"
                                                                          target:self
                                                                          action:@selector(pressNavBarButtonActionSetting:)
                                                                      offsetType:CFCNavBarButtonOffsetTypeNone
                                                                       imageSize:NAVIGATION_BAR_BUTTON_IMAGE_SIZE*0.95f];
        [self.navBarAreaContainer addSubview:btnOfSetting];
        [btnOfSetting mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.navBarAreaContainer);
            make.right.equalTo(self.navBarAreaContainer).offset(-margin*0.5f);
            make.size.mas_equalTo(CGSizeMake(NAVIGATION_BAR_BUTTON_MAX_WIDTH*0.8f, NAVIGATION_BAR_HEIGHT));
        }];
        
        btnOfSetting;
    });
    btnOfSetting.mas_key = @"btnOfSetting";

    // 客服按钮
    UIButton *btnOfCustomer = ({
        UIButton *btnOfCustomer = [self.parentViewController createButtonWithImage:@"icon_customer_service_white"
                                                                          target:self
                                                                          action:@selector(pressNavBarButtonActionCustomer:)
                                                                      offsetType:CFCNavBarButtonOffsetTypeNone
                                                                       imageSize:NAVIGATION_BAR_BUTTON_IMAGE_SIZE];
        [self.navBarAreaContainer addSubview:btnOfCustomer];
        [btnOfCustomer mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.navBarAreaContainer);
            make.right.equalTo(btnOfSetting.mas_left);
            make.size.mas_equalTo(CGSizeMake(NAVIGATION_BAR_BUTTON_MAX_WIDTH*0.8, NAVIGATION_BAR_HEIGHT));
        }];
        
        btnOfCustomer;
    });
    btnOfCustomer.mas_key = @"btnOfCustomer";
    
    // 二维码
    UIButton *btnOfQRCode = ({
        UIButton *btnOfQRCode = [self.parentViewController createButtonWithImage:@"icon_myqrcode"
                                                                          target:self
                                                                          action:@selector(pressNavBarButtonActionMyQRCode:)
                                                                      offsetType:CFCNavBarButtonOffsetTypeNone
                                                                       imageSize:NAVIGATION_BAR_BUTTON_IMAGE_SIZE*0.95f];
        [self.navBarAreaContainer addSubview:btnOfQRCode];
        [btnOfQRCode mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.navBarAreaContainer);
            make.right.equalTo(btnOfCustomer.mas_left);
            make.size.mas_equalTo(CGSizeMake(NAVIGATION_BAR_BUTTON_MAX_WIDTH*0.8, NAVIGATION_BAR_HEIGHT));
        }];
        
        btnOfQRCode;
    });
    btnOfQRCode.mas_key = @"btnOfQRCode";
    
    // 版本号
    UIButton *btnOfVersion = ({
        UIButton *btnOfVersion = [self.parentViewController createButtonWithImage:@""
                                                                          target:self
                                                                          action:@selector(pressNavBarButtonActionVersion:)
                                                                      offsetType:CFCNavBarButtonOffsetTypeNone
                                                                       imageSize:NAVIGATION_BAR_BUTTON_IMAGE_SIZE];
        [self.navBarAreaContainer addSubview:btnOfVersion];
        [btnOfVersion mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.navBarAreaContainer);
            make.left.equalTo(self.navBarAreaContainer.mas_left).offset(margin*1.0f);
            make.size.mas_equalTo(CGSizeMake(NAVIGATION_BAR_BUTTON_MAX_WIDTH*2.5f, NAVIGATION_BAR_HEIGHT));
        }];
        
        UIImageView *iconImageView = ({
            UIImageView *imageView = [UIImageView new];
            [btnOfVersion addSubview:imageView];
            [imageView setImage:[UIImage imageNamed:@"systemVIcon"]];
            [imageView setContentMode:UIViewContentModeScaleAspectFit];
            
            [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(btnOfVersion.mas_centerY);
                make.left.equalTo(btnOfVersion.mas_left);
                make.width.height.mas_equalTo(btnOfVersion.mas_height).multipliedBy(0.25f);
            }];
            
            imageView;
        });
        iconImageView.mas_key = @"iconImageView";
        
        UILabel *contentLabel = ({
            NSString *version = [FUNCTION_MANAGER getApplicationVersion];
            NSString *versionString = [NSString stringWithFormat:@"%@：QG%@",NSLocalizedString(@"版本", nil), version];
            UILabel *label = [UILabel new];
            [btnOfVersion addSubview:label];
            [label setText:versionString];
            [label setTextAlignment:NSTextAlignmentLeft];
            [label setTextColor:COLOR_RGBA(255, 255, 255, 0.95)];
            [label setFont:[UIFont systemFontOfSize:CFC_AUTOSIZING_FONT(12)]];
            
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(iconImageView.mas_centerY);
                make.left.equalTo(iconImageView.mas_right).offset(margin*0.5f);
            }];
            
            label;
        });
        self.appVersionLabel = contentLabel;
        self.appVersionLabel.mas_key = @"appVersionLabel";
        
        btnOfVersion;
    });
    btnOfVersion.mas_key = @"btnOfVersion";
}

- (void)createUserAreaAtuoLayout
{
    CGFloat margin = CFC_AUTOSIZING_MARGIN(MARGIN);
    CGFloat headerImageSize = CFC_AUTOSIZING_WIDTH(55.0f);
    CGFloat balanceAreaHeight = headerImageSize * 0.57f;
    
    UIImageView *headerImageView = ({
        UIImageView *imageView = [[UIImageView alloc] init];
        [self.userAreaContainer addSubview:imageView];
        [imageView setClipsToBounds:YES];
        [imageView setUserInteractionEnabled:YES];
        [imageView addCornerRadius:headerImageSize*0.5f];
        [imageView setContentMode:UIViewContentModeScaleAspectFill];
        [imageView setImage:[UIImage imageNamed:@"icon_avatar_default_big"]];

        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pressNavBarButtonActionUserHeader:)];
        [imageView addGestureRecognizer:tapGesture];
        
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.userAreaContainer).offset(margin*0.5f);
            make.left.equalTo(self.userAreaContainer.mas_left).offset(margin*1.5f);
            make.size.mas_equalTo(CGSizeMake(headerImageSize, headerImageSize));
        }];
        
        imageView;
    });
    self.headerImageView = headerImageView;
    self.headerImageView.mas_key = @"headerImageView";
    
    UILabel *userIdLabel = ({
        NSString *userIdString = [NSString stringWithFormat:@"ID:%@", APPINFORMATION.userInfo.userId];
        UIFont *font = FONT_PINGFANG_REGULAR(11);
        CGFloat width = [userIdString widthWithFont:font constrainedToHeight:CGFLOAT_MAX] + margin;
        CGFloat height = [userIdString heightWithFont:font constrainedToWidth:CGFLOAT_MAX] + margin*0.2f;
        
        UILabel *label = [UILabel new];
        [self.userAreaContainer addSubview:label];
        [label setFont:font];
        [label setText:userIdString];
        [label setTextColor:COLOR_RGBA(255, 255, 255, 0.85)];
        [label setTextAlignment:NSTextAlignmentCenter];
        [label setBackgroundColor:COLOR_HEXSTRING(@"#A73531")];
        [label addCornerRadius:margin*0.25f];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(headerImageView.mas_right).offset(margin*1.5f);
            make.bottom.equalTo(headerImageView.mas_centerY).offset(-margin*0.2f);
            make.width.mas_equalTo(width);
            make.height.mas_lessThanOrEqualTo(height);
        }];
        
        label;
    });
    self.userIdLabel = userIdLabel;
    self.userIdLabel.mas_key = @"userIdLabel";
    
    UILabel *userVipLabel = ({
        UIView *userVipButton = [UIView new];
        [self.userAreaContainer addSubview:userVipButton];
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pressNavBarButtonActionVIPRule:)];
        [userVipButton addGestureRecognizer:tapGesture];
        [userVipButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(userIdLabel.mas_right);
            make.centerY.equalTo(userIdLabel.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(50, headerImageSize*0.4f));
        }];
        
        UIImageView *imageView = ({
            UIImageView *imageView = [[UIImageView alloc] init];
            [self.userAreaContainer addSubview:imageView];
            [imageView setClipsToBounds:YES];
            [imageView setContentMode:UIViewContentModeScaleAspectFill];
            [imageView setImage:[UIImage imageNamed:@"icon_center_bg_vip"]];
            [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(userIdLabel.mas_centerY);
                make.left.equalTo(userIdLabel.mas_right).offset(margin*0.5f);
                make.size.mas_equalTo(CGSizeMake(headerImageSize*0.71f, headerImageSize*0.27f));
            }];
            
            imageView;
        });
        imageView.mas_key = @"vipImageView";
        
        // VIP
        UILabel *label = [UILabel new];
        [imageView addSubview:label];
        [label setText:@"VIP -"];
        [label setFont:FONT_PINGFANG_SEMI_BOLD(12)];
        [label setTextColor:COLOR_HEXSTRING(@"#EB5E58")];
        [label setTextAlignment:NSTextAlignmentCenter];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(imageView);
        }];
        
        label;
    });
    self.userVipLabel = userVipLabel;
    self.userVipLabel.mas_key = @"userVipLabel";
    
    UILabel *userNameLabel = ({
        UILabel *label = [UILabel new];
        [self.userAreaContainer addSubview:label];
        [label setText:STR_APP_TEXT_PLACEHOLDER];
        [label setFont:FONT_PINGFANG_SEMI_BOLD(16)];
        [label setTextColor:COLOR_RGBA(255, 255, 255, 0.85)];
        [label setTextAlignment:NSTextAlignmentLeft];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(headerImageView.mas_centerY);
            make.left.equalTo(headerImageView.mas_right).offset(margin*1.5f);
            make.width.mas_lessThanOrEqualTo(SCREEN_MIN_LENGTH*0.25f);
        }];
        
        label;
    });
    self.userNameLabel = userNameLabel;
    self.userNameLabel.mas_key = @"userNameLabel";
    
    UIView *userBalanceBackView = ({
        UIView *view = [UIView new];
        [self.userAreaContainer addSubview:view];
        [view addCornerRadius:balanceAreaHeight*0.5f];
        [view setBackgroundColor:COLOR_HEXSTRING(@"#A73531")];

        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.userAreaContainer.mas_right).offset(-margin*1.5f);
            make.height.mas_equalTo(balanceAreaHeight);
        }];

        view;
    });
    self.userBalanceBackView = userBalanceBackView;
    self.userBalanceBackView.mas_key = @"userBalanceBackView";

    UILabel *userBalanceLabel = ({
        UILabel *label = [UILabel new];
        [self.userAreaContainer addSubview:label];
        [label setText:STR_APP_TEXT_PLACEHOLDER];
        [label setFont:FONT_PINGFANG_REGULAR(14)];
        [label setTextColor:COLOR_RGBA(255, 255, 255, 0.85)];
        [label setTextAlignment:NSTextAlignmentLeft];

        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(headerImageView.mas_centerY);
            make.right.equalTo(userBalanceBackView.mas_right).offset(-margin*1.0f);
            make.width.mas_greaterThanOrEqualTo(60.0f);
        }];

        label;
    });
    self.userBalanceLabel = userBalanceLabel;
    self.userBalanceLabel.mas_key = @"userBalanceLabel";

    UIImageView *balanceImageView = ({
        CGFloat imageSize = balanceAreaHeight * 0.85f;
        UIImageView *imageView = [[UIImageView alloc] init];
        [self.userAreaContainer addSubview:imageView];
        [imageView setImage:[UIImage imageNamed:@"icon_balance_white"]];
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

    [self.userBalanceBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(userBalanceLabel.mas_centerY);
        make.left.equalTo(balanceImageView.mas_left).offset(-margin*0.5f);
    }];
}

- (void)createBalanceAreaAtuoLayout
{
    CGFloat margin = CFC_AUTOSIZING_MARGIN(MARGIN);
    CGFloat heightOfBalanceArea = SCREEN_MIN_LENGTH * 0.33f;
    //
    CGFloat todayLabelWidth = (SCREEN_MIN_LENGTH - margin*3.0) * 0.33f;
    CGFloat todayLabelHeight = heightOfBalanceArea * 0.45f;
    [self setTodayRechargeLabel:[self createCenterMoneyLabel:NSLocalizedString(@"今日充值", nil)]];
    [self.balanceAreaContainer addSubview:self.todayRechargeLabel];
    [self.todayRechargeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.balanceAreaContainer.mas_top);
        make.left.equalTo(self.balanceAreaContainer.mas_left).offset(margin*1.5f);
        make.size.mas_equalTo(CGSizeMake(todayLabelWidth, todayLabelHeight));
    }];
        
    [self setTodayWithdrawLabel:[self createCenterMoneyLabel:NSLocalizedString(@"今日提现", nil)]];
    [self.balanceAreaContainer addSubview:self.todayWithdrawLabel];
    [self.todayWithdrawLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.balanceAreaContainer.mas_top);
        make.centerX.equalTo(self.balanceAreaContainer.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(todayLabelWidth, todayLabelHeight));
    }];
    
    [self setTodayProfitLabel:[self createCenterMoneyLabel:NSLocalizedString(@"今日盈利", nil)]];
    [self.balanceAreaContainer addSubview:self.todayProfitLabel];
    [self.todayProfitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.balanceAreaContainer.mas_top);
        make.right.equalTo(self.balanceAreaContainer.mas_right).offset(-margin*1.5f);
        make.size.mas_equalTo(CGSizeMake(todayLabelWidth, todayLabelHeight));
    }];
}


#pragma mark - Getter/Setter

- (UIImageView *)backgroundImageView
{
    if(!_backgroundImageView) {
        _backgroundImageView = [[UIImageView alloc] init];
        [_backgroundImageView setClipsToBounds:YES];
        [_backgroundImageView setUserInteractionEnabled:YES];
        [_backgroundImageView setContentMode:UIViewContentModeScaleAspectFill];
        [_backgroundImageView setImage:[UIImage imageNamed:@"icon_center_bg_top"]];
    }
    return _backgroundImageView;
}

- (UIView *)navBarAreaContainer
{
    if(!_navBarAreaContainer) {
        _navBarAreaContainer= [[UIView alloc] init];
    }
    return _navBarAreaContainer;
}

- (UIView *)userAreaContainer
{
    if(!_userAreaContainer) {
        _userAreaContainer= [[UIView alloc] init];
    }
    return _userAreaContainer;
}

- (UIImageView *)balanceAreaContainer
{
    if(!_balanceAreaContainer) {
        _balanceAreaContainer = [[UIImageView alloc] init];
        [_balanceAreaContainer setClipsToBounds:YES];
        [_balanceAreaContainer setUserInteractionEnabled:YES];
        [_balanceAreaContainer setContentMode:UIViewContentModeScaleAspectFill];
        [_balanceAreaContainer setImage:[UIImage imageNamed:@"icon_center_header"]];
    }
    return _balanceAreaContainer;
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


#pragma mark - FYCenterMainViewControllerProtocol

- (void)doAnyThingForCenterTableHeaderView:(FYCenterMainProtocolFuncType)type
{
    if (FYCenterMainProtocolFuncTypeRefreshHeaderData == type) {
        [self doLoadDataAndRefreshMainUI];
    }
}


#pragma mark - Private

- (FYCenterMoneyLabel *)createCenterMoneyLabel:(NSString *)title
{
    UIColor *todayTitleColor = COLOR_SYSTEM_MAIN_FONT_DEFAULT;
    UIFont *todayTitleFont = FONT_COMMON_BUTTON_TITLE;
    UIColor *todayMoneyColor = COLOR_SYSTEM_MAIN_FONT_DEFAULT;
    UIFont *todayMoneyFont = [UIFont boldSystemFontOfSize:CFC_AUTOSIZING_FONT(17)];
    
    FYCenterMoneyLabel *label = [[FYCenterMoneyLabel alloc] init];
    // 标题
    [label setTitle:title];
    [label setTitleFont:todayTitleFont];
    [label setTitleColor:todayTitleColor];
    [label setTitleTextAlignment:NSTextAlignmentCenter];
    // 金额
    [label setMoney:@"0.0"];
    [label setMoneyFont:todayMoneyFont];
    [label setMoneyColor:todayMoneyColor];
    [label setMoneyTextAlignment:NSTextAlignmentCenter];
           
    return label;
}

- (void)doLoadDataAndRefreshMainUI
{
    // 版本
    {
        NSString *version = [FUNCTION_MANAGER getApplicationVersion];
#if DEBUG
        NSString *versionString = [NSString stringWithFormat:@"[DEBUG]%@：QG%@",NSLocalizedString(@"版本", nil), version];
#else
        NSString *versionString = [NSString stringWithFormat:@"%@：QG%@", NSLocalizedString(@"版本", nil),version];
#endif
        [self.appVersionLabel setText:versionString];
    }
    // 用户
    {
        NSString *levelString = APPINFORMATION.userInfo.levelName;
        NSCharacterSet *characterSet = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] invertedSet];
        NSString *levelNum = [[levelString componentsSeparatedByCharactersInSet:characterSet] componentsJoinedByString:@""];
        NSString *VIPNUM = VALIDATE_STRING_EMPTY(levelNum) ? @"-" : levelNum;
        //
        [self.userNameLabel setText:STR_TRI_WHITE_SPACE(APPINFORMATION.userInfo.nick)];
        [self.userVipLabel setText:[NSString stringWithFormat:@"VIP %@", VIPNUM]];
        [self.userIdLabel setText:[NSString stringWithFormat:@"ID:%@", APPINFORMATION.userInfo.userId]];
        [self.userBalanceLabel setText:STR_TRI_WHITE_SPACE(APPINFORMATION.userInfo.balance)];
        if ([CFCSysUtil validateStringUrl:APPINFORMATION.userInfo.avatar]) {
            __block UIActivityIndicatorView *activityIndicator = nil;
            UIImage *placeholderImage = [UIImage imageNamed:@"icon_avatar_default_big"];
            [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:APPINFORMATION.userInfo.avatar] placeholderImage:placeholderImage options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
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
            [self.headerImageView setImage:[UIImage imageNamed:@"icon_avatar_default"]];
        }
    }
    // 今日
    {
        [self.todayRechargeLabel setMoney:APPINFORMATION.userInfo.recharge];
        [self.todayWithdrawLabel setMoney:APPINFORMATION.userInfo.cashDraw];
        [self.todayProfitLabel setMoney:APPINFORMATION.userInfo.profit];
    }
}


@end

