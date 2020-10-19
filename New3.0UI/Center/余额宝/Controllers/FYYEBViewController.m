//
//  FYYEBViewController.m
//  ProjectCSHB
//
//  Created by fangyuan on 2020/5/26.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "FYYEBViewController.h"
#import "FYYEBIconMarkView.h"
#import "YEBAccountInfoModel.h"
#import "YEBTransferVC.h"
#import "YEBInfoVC.h"
#import "DYWebViewVC.h"

@interface FYYEBViewController ()
//
@property (nonatomic, assign) BOOL isShowMoneyInfo;
@property (nonatomic, strong) UIImageView *imageViewOfEye;
@property (nonatomic, strong) UILabel *totalBalanceLabel;
@property (nonatomic, strong) UILabel *totalEarningsLabel;
@property (nonatomic, strong) UILabel *day30EarningsLabel;
@property (nonatomic, strong) UILabel *rateOfEarningLabel;
@property (nonatomic, strong) UIButton *buttonTransferredIn;
@property (nonatomic, strong) UIButton *buttonTransferredOut;
//
@property (nonatomic, strong) YEBAccountInfoModel *yebInfoModel;

@end

@implementation FYYEBViewController

#pragma mark - Actions

- (void)pressNavBarButtonActionNavBack:(id)sender
{
    [super pressNavigationBarLeftButtonItem:sender];
}

- (void)pressNavBarButtonActionMoreSquare:(id)sender
{
    NSString *urlString = [NSString stringWithFormat:@"%@dist/#/help/?accesstoken=%@&tenant=%@", [AppModel shareInstance].address, [AppModel shareInstance].userInfo.token,kNewTenant];
    FYWebViewController *webVC = [[FYWebViewController alloc] initWithUrl:urlString];
    [webVC setTitle:NSLocalizedString(@"新手帮助", nil)];
    
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    NSDictionary *dict = @{NSLocalizedString(@"资金明细", nil) : [YEBInfoVC finalcialInfoVC:self.yebInfoModel],
                           NSLocalizedString(@"收益详情", nil) : [YEBInfoVC profitInfoVC:self.yebInfoModel],
                           NSLocalizedString(@"新手帮助", nil) : webVC};
    [dict.allKeys enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIAlertAction *action = [UIAlertAction actionWithTitle:obj style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            UIViewController *vc = dict[action.title];
            [self.navigationController pushViewController:vc animated:YES];
        }];
        [alertVC addAction:action];
    }];
    
    UIAlertAction *action = [UIAlertAction actionWithTitle:NSLocalizedString(@"取消", nil) style:UIAlertActionStyleCancel handler:nil];
    [alertVC addAction:action];
    [self presentViewController:alertVC animated:YES completion:nil];
}

- (void)pressButtonActionTransferredIn:(id)sender
{
    YEBTransferVC *VC = [YEBTransferVC transferInVC];
    [VC setModel:self.yebInfoModel];
    [self.navigationController pushViewController:VC animated:YES];
}

- (void)pressButtonActionTransferredOut:(id)sender
{
    YEBTransferVC *VC = [YEBTransferVC transferOutVC];
    [VC setModel:self.yebInfoModel];
    [self.navigationController pushViewController:VC animated:YES];
}

- (void)pressButtonActionOfEyeImageView:(UITapGestureRecognizer *)gesture
{
    self.isShowMoneyInfo = !self.isShowMoneyInfo;
    [self updateMainUIMoneyInfo:self.isShowMoneyInfo];
}


#pragma mark - Life Cycle

- (instancetype)init
{
    self = [super init];
    if (self) {
        _isShowMoneyInfo = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self createMainUIView];
    
    [self loadDataAndUpdateMainUI];
    
    [self addNotification];
}

- (void)createMainUIView
{
    CGFloat margin = CFC_AUTOSIZING_MARGIN(MARGIN);
    
    // 背景区域
    {
        UIImageView *backgroundImageView = [[UIImageView alloc] init];
        [backgroundImageView setContentMode:UIViewContentModeScaleAspectFill];
        [backgroundImageView setImage:[UIImage imageNamed:@"icon_yeb_bg"]];
        [self.view addSubview:backgroundImageView];
        [backgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }
    
    // 导航区域
    UIView *navBarAreaContainer = [UIView new];
    {
        [self.view addSubview:navBarAreaContainer];
        [navBarAreaContainer mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.equalTo(self.view);
            make.height.mas_equalTo(STATUS_NAVIGATION_BAR_HEIGHT);
        }];
        [self createMainUIViewOfNavBar:navBarAreaContainer];
    }
    
    
    // 内容区域
    {
        UIScrollView *rootScrollView = ({
            UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
            [scrollView setShowsVerticalScrollIndicator:NO];
            [self.view addSubview:scrollView];
            
            [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.view);
                make.right.equalTo(self.view);
                make.top.equalTo(navBarAreaContainer.mas_bottom);
                make.bottom.equalTo(self.view);
            }];
            
            scrollView;
        });
        rootScrollView.mas_key = @"rootScrollView";
        
        // 容器
        UIView *containerView = ({
            UIView *view = [[UIView alloc] init];
            [rootScrollView addSubview:view];
            
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(rootScrollView);
                make.width.equalTo(rootScrollView);
                make.height.mas_greaterThanOrEqualTo(SCREEN_HEIGHT-STATUS_NAVIGATION_BAR_HEIGHT+1.0);
            }];
            view;
        });
        containerView.mas_key = @"containerView";
        
        // 余额理财的小能手
        UILabel *headerTitleLabel = ({
            UILabel *label = [UILabel new];
            [containerView addSubview:label];
            [label setNumberOfLines:1];
            [label setText:NSLocalizedString(@"余额理财的小能手", nil)];
            [label setFont:[UIFont systemFontOfSize:CFC_AUTOSIZING_FONT(14)]];
            [label setTextColor:COLOR_RGBA(255, 255, 255, 0.9f)];
            [label setTextAlignment:NSTextAlignmentCenter];
            
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(containerView.mas_top).offset(margin);
                make.left.equalTo(containerView.mas_left).offset(margin);
                make.right.equalTo(containerView.mas_right).offset(-margin);
            }];
            
            label;
        });
        headerTitleLabel.mas_key = @"headerTitleLabel";
        
        // 收益天天算 - 能取又能存 - 账户有保障
        UIView *lastMarkView = nil;
        {
            CGFloat todayLabelWidth = (SCREEN_MIN_LENGTH - margin*3.0) * 0.33f;
            CGFloat todayLabelHeight = todayLabelWidth * 0.5f;
            NSArray<NSString *> *titles = @[ NSLocalizedString(@"收益天天算", nil), NSLocalizedString(@"能取又能存", nil), NSLocalizedString(@"账户有保障", nil) ];
            NSArray<NSString *> *imageUrls = @[ @"icon_yeb_bag", @"icon_yeb_backcard", @"icon_yeb_safety" ];
            for (NSInteger idx = 0; idx < titles.count; idx ++) {
                FYYEBIconMarkView *markView = [self createIconMarkView:titles[idx] imageUrl:imageUrls[idx]];
                [containerView addSubview:markView];
                [markView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.size.mas_equalTo(CGSizeMake(todayLabelWidth, todayLabelHeight));
                    if (!lastMarkView) {
                        make.top.equalTo(headerTitleLabel.mas_bottom).offset(margin*2.0f);
                        make.left.equalTo(containerView.mas_left).offset(margin*1.5f);
                    } else {
                        make.top.equalTo(lastMarkView.mas_top);
                        make.left.equalTo(lastMarkView.mas_right);
                    }
                }];
                lastMarkView = markView;
            }
        }
        
        // 余额区域
        UIView *balanceAreaContainer = [UIView new];
        {
            [containerView addSubview:balanceAreaContainer];
            [balanceAreaContainer setBackgroundColor:[UIColor whiteColor]];
            [balanceAreaContainer addCornerRadius:margin*0.5f];
            [balanceAreaContainer mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(containerView.mas_centerX);
                make.top.equalTo(lastMarkView.mas_bottom).offset(margin*2.0f);
                make.width.equalTo(containerView.mas_width).multipliedBy(0.9f);
                make.height.equalTo(containerView.mas_width).multipliedBy(0.95f);
            }];
            [self createMainUIViewOfBalance:balanceAreaContainer];
        }
        
        // 提示信息
        UILabel *tipInfoLabel = ({
            NSString *content = NSLocalizedString(@"温馨提示：\n\n余额宝的收益会在每天下午15:00左右到账，每日结算前一天的收益。若您使用余额宝消费或转出了部分资金，则这部分转出资金当天没有任何收效。", nil);
            //
            UILabel *label = [UILabel new];
            [containerView addSubview:label];
            [label setText:content];
            [label setNumberOfLines:0];
            [label setTextAlignment:NSTextAlignmentLeft];
            [label setTextColor:COLOR_SYSTEM_MAIN_FONT_ASSIST_DEFAULT];
            [label setFont:[UIFont systemFontOfSize:CFC_AUTOSIZING_FONT(13)]];
            
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(balanceAreaContainer.mas_bottom).offset(margin*2.5f);
                make.left.equalTo(containerView.mas_left).offset(margin*3.0f);
                make.right.equalTo(containerView.mas_right).with.offset(-margin*3.0f);
            }];
            
            label;
        });
        tipInfoLabel.mas_key = @"tipInfoLabel";
        
        [containerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.greaterThanOrEqualTo(tipInfoLabel.mas_bottom).offset(margin*5.0f).priority(749);
        }];
    }
}

- (void)createMainUIViewOfNavBar:(UIView *)navBarAreaContainer
{
    CGFloat margin = CFC_AUTOSIZING_MARGIN(MARGIN);
    
    // 返回
    UIButton *btnOfBack= ({
        UIFont *titleFont = [self prefersNavigationBarRightButtonItemTitleFont];
        UIColor *titleNormalColor = [self prefersNavigationBarRightButtonItemTitleColorNormal];
        UIColor *titleSelectColor = [self prefersNavigationBarRightButtonItemTitleColorSelect];
        NSString *iconNameNormal = ICON_NAVIGATION_BAR_BUTTON_WHITE_ARROW;
        NSString *iconNameSelect = ICON_NAVIGATION_BAR_BUTTON_WHITE_ARROW;
        UIButton *button = (UIButton *)[self createNavigationBarButtonItemTypeDefaultTitle:@""
                                                                                 titleFont:titleFont
                                                                          titleNormalColor:titleNormalColor
                                                                          titleSelectColor:titleSelectColor
                                                                            iconNameNormal:iconNameNormal
                                                                            iconNameSelect:iconNameSelect
                                                                                    action:@selector(pressNavBarButtonActionNavBack:)
                                                                                    target:self];
        [navBarAreaContainer addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(navBarAreaContainer);
            make.left.equalTo(navBarAreaContainer.mas_left).offset(margin*1.0f);
            make.size.mas_equalTo(CGSizeMake(CFC_AUTOSIZING_WIDTH(NAVIGATION_BAR_BUTTON_MAX_WIDTH), NAVIGATION_BAR_HEIGHT));
        }];
        
        button;
    });
    btnOfBack.mas_key = @"btnOfBack";
    
    // 更多
    UIButton *btnOfMoreSqure = ({
        UIButton *button = [self createButtonWithImage:@"icon_more_square_white"
                                                target:self
                                                action:@selector(pressNavBarButtonActionMoreSquare:)
                                            offsetType:CFCNavBarButtonOffsetTypeRight
                                             imageSize:NAVIGATION_BAR_BUTTON_IMAGE_SIZE];
        [navBarAreaContainer addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(navBarAreaContainer);
            make.right.equalTo(navBarAreaContainer).offset(-margin*1.0f);
            make.size.mas_equalTo(CGSizeMake(NAVIGATION_BAR_BUTTON_MAX_WIDTH, NAVIGATION_BAR_HEIGHT));
        }];
        
        button;
    });
    btnOfMoreSqure.mas_key = @"btnOfMoreSqure";
    
    // 标题
    {
        UILabel *label = [[UILabel alloc] init];
        [label setText:STR_NAVIGATION_BAR_TITLE_YUEBAO];
        [label setTextColor:[UIColor whiteColor]];
        [label setTextAlignment:NSTextAlignmentCenter];
        [label setFont:[self prefersNavigationBarTitleFont]];
        [navBarAreaContainer addSubview:label];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(btnOfMoreSqure.mas_centerY);
            make.centerX.equalTo(navBarAreaContainer.mas_centerX);
        }];
    }
}

- (void)createMainUIViewOfBalance:(UIView *)containerView
{
    CGFloat margin = CFC_AUTOSIZING_MARGIN(MARGIN);
    
    // 总金额
    [containerView addSubview:self.totalBalanceLabel];
    [self.totalBalanceLabel setText:@"****"];
    [self.totalBalanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(containerView.mas_bottom).multipliedBy(0.27f);
        make.left.right.equalTo(containerView);
    }];
    
    // 总金额 + 图标
    {
        UILabel *label = [[UILabel alloc] init];
        [label setText:NSLocalizedString(@"总金额(元)", nil)];
        [label setTextColor:COLOR_HEXSTRING(@"#373737")];
        [label setTextAlignment:NSTextAlignmentCenter];
        [label setFont:[UIFont systemFontOfSize:CFC_AUTOSIZING_FONT(15.0f)]];
        [containerView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(containerView.mas_centerX);
            make.bottom.equalTo(self.totalBalanceLabel.mas_top).offset(-margin*0.5f);
        }];
        
        UIView *eyeBgView = ({
            //
            CGFloat imageSize = CFC_AUTOSIZING_WIDTH(8.0);
            UIView *view = [[UIView alloc] init];
            [containerView addSubview:view];
            UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pressButtonActionOfEyeImageView:)];
            [view addGestureRecognizer:tapGesture];
            [view mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(label.mas_centerY);
                make.left.equalTo(label.mas_right);
                make.size.mas_equalTo(CGSizeMake(imageSize*4.0f, imageSize*4.0f));
            }];
            //
            [view addSubview:self.imageViewOfEye];
            [self.imageViewOfEye mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(view.mas_centerY);
                make.left.equalTo(view.mas_left).offset(margin);
                make.size.mas_equalTo(CGSizeMake(imageSize, imageSize));
            }];
            
            view;
        });
        eyeBgView.mas_key = @"eyeBgView";
    }
    
    // 30天收益
    [containerView addSubview:self.day30EarningsLabel];
    [self.day30EarningsLabel setAttributedText:[self createDay30EarningsString:NO]];
    [self.day30EarningsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(containerView.mas_centerX);
        make.top.equalTo(self.totalBalanceLabel.mas_bottom).offset(margin*1.5f);
    }];
 
    // 转出 + 转入
    {
        [containerView addSubview:self.buttonTransferredOut];
        [self.buttonTransferredOut mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(containerView.mas_right).multipliedBy(0.27f);
            make.bottom.equalTo(containerView.mas_bottom).offset(-margin*1.5f);
            make.width.equalTo(containerView.mas_width).multipliedBy(0.43f);
            make.height.equalTo(self.buttonTransferredOut.mas_width).multipliedBy(0.33f);
        }];
        
        [containerView addSubview:self.buttonTransferredIn];
        [self.buttonTransferredIn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(containerView.mas_right).multipliedBy(0.73f);
            make.bottom.equalTo(self.buttonTransferredOut.mas_bottom);
            make.width.equalTo(self.buttonTransferredOut.mas_width);
            make.height.equalTo(self.buttonTransferredOut.mas_height);
        }];
    }
    
    // 累计收益
    {
        [containerView addSubview:self.totalEarningsLabel];
        [self.totalEarningsLabel setText:@"****"];
        [self.totalEarningsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.buttonTransferredOut.mas_centerX);
            make.bottom.equalTo(self.buttonTransferredOut.mas_top).offset(-margin*2.5f);
        }];
     
        UILabel *label = [[UILabel alloc] init];
        [label setText:NSLocalizedString(@"累计收益(元)", nil)];
        [label setTextColor:COLOR_HEXSTRING(@"#B4B4B4")];
        [label setTextAlignment:NSTextAlignmentCenter];
        [label setFont:[UIFont systemFontOfSize:CFC_AUTOSIZING_FONT(14.0f)]];
        [containerView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.totalEarningsLabel.mas_centerX);
            make.bottom.equalTo(self.totalEarningsLabel.mas_top).offset(-margin*1.0f);
        }];
    }
    
    
    // 七日年化
    {
        [containerView addSubview:self.rateOfEarningLabel];
        [self.rateOfEarningLabel setText:@"****"];
        [self.rateOfEarningLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.buttonTransferredIn.mas_centerX);
            make.bottom.equalTo(self.buttonTransferredIn.mas_top).offset(-margin*2.5f);
        }];
        
        UILabel *label = [[UILabel alloc] init];
        [label setText:NSLocalizedString(@"七日年化(%)", nil)];
        [label setTextColor:COLOR_HEXSTRING(@"#B4B4B4")];
        [label setTextAlignment:NSTextAlignmentCenter];
        [label setFont:[UIFont systemFontOfSize:CFC_AUTOSIZING_FONT(14.0f)]];
        [containerView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.rateOfEarningLabel.mas_centerX);
            make.bottom.equalTo(self.rateOfEarningLabel.mas_top).offset(-margin*1.0f);
        }];
    }
}


#pragma mark - Network

- (void)loadDataAndUpdateMainUI
{
    WEAKSELF(weakSelf)
    [self loadRequestDataYEBThen:^(BOOL success, YEBAccountInfoModel *yebInfoModel) {
        if (success) {
            [weakSelf updateMainUIMoneyInfo:weakSelf.isShowMoneyInfo];
        }
    }];
}

- (void)loadRequestDataYEBThen:(void (^)(BOOL success, YEBAccountInfoModel *yebInfoModel))then
{
    WEAKSELF(weakSelf)
    PROGRESS_HUD_SHOW
    [NET_REQUEST_MANAGER getBalanceDetailsSuccess:^(id response) {
        PROGRESS_HUD_DISMISS
        FYLog(NSLocalizedString(@"余额宝数据 => \n%@", nil), response);
        if (!NET_REQUEST_SUCCESS(response)) {
            !then ?: then(NO,nil);
        } else {
            NSDictionary *data = NET_REQUEST_DATA(response);
            if ([data isKindOfClass:[NSDictionary class]]) {
                YEBAccountInfoModel *model = [YEBAccountInfoModel mj_objectWithKeyValues:data];
                [weakSelf setYebInfoModel:model];
                !then ?: then(YES,model);
            } else {
                ALTER_HTTP_MESSAGE(NSLocalizedString(@"请求数据出错", nil))
                !then ?: then(NO,nil);
            }
        }
    } fail:^(id error) {
        PROGRESS_HUD_DISMISS
        ALTER_HTTP_ERROR_MESSAGE(error)
        FYLog(NSLocalizedString(@"获取余额宝数据出错 => \n%@", nil), error);
        !then ?: then(NO,nil);
    }];
}


#pragma mark - Navigation

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (BOOL)prefersNavigationBarHidden
{
    return YES;
}



#pragma mark - Getter/Setter

- (UIImageView *)imageViewOfEye
{
    if(!_imageViewOfEye) {
        _imageViewOfEye = [[UIImageView alloc] init];
        [_imageViewOfEye setUserInteractionEnabled:YES];
        [_imageViewOfEye setContentMode:UIViewContentModeScaleAspectFill];
        [_imageViewOfEye setImage:[UIImage imageNamed:@"icon_yeb_eye_close"]];
    }
    return _imageViewOfEye;
}

- (UILabel *)totalBalanceLabel
{
    // 总金额
    if(!_totalBalanceLabel) {
        _totalBalanceLabel = [[UILabel alloc] init];
        [_totalBalanceLabel setTextAlignment:NSTextAlignmentCenter];
        [_totalBalanceLabel setTextColor:COLOR_SYSTEM_MAIN_FONT_DEFAULT];
        [_totalBalanceLabel setFont:[UIFont boldSystemFontOfSize:CFC_AUTOSIZING_FONT(36.0f)]];
    }
    return _totalBalanceLabel;
}

- (UILabel *)day30EarningsLabel
{
    // 30天收益
    if(!_day30EarningsLabel) {
        _day30EarningsLabel = [[UILabel alloc] init];
        [_day30EarningsLabel setTextAlignment:NSTextAlignmentCenter];
        [_day30EarningsLabel setTextColor:COLOR_SYSTEM_MAIN_FONT_DEFAULT];
        [_day30EarningsLabel setFont:[UIFont systemFontOfSize:CFC_AUTOSIZING_FONT(15.0f)]];
    }
    return _day30EarningsLabel;
}

- (UILabel *)totalEarningsLabel
{
    // 累计收益
    if(!_totalEarningsLabel) {
        _totalEarningsLabel = [[UILabel alloc] init];
        [_totalEarningsLabel setTextAlignment:NSTextAlignmentCenter];
        [_totalEarningsLabel setTextColor:COLOR_SYSTEM_MAIN_FONT_DEFAULT];
        [_totalEarningsLabel setFont:[UIFont boldSystemFontOfSize:CFC_AUTOSIZING_FONT(20.0f)]];
    }
    return _totalEarningsLabel;
}

- (UILabel *)rateOfEarningLabel
{
    // 七日收益率
    if(!_rateOfEarningLabel) {
        _rateOfEarningLabel = [[UILabel alloc] init];
        [_rateOfEarningLabel setTextAlignment:NSTextAlignmentCenter];
        [_rateOfEarningLabel setTextColor:COLOR_SYSTEM_MAIN_FONT_DEFAULT];
        [_rateOfEarningLabel setFont:[UIFont boldSystemFontOfSize:CFC_AUTOSIZING_FONT(20.0f)]];
    }
    return _rateOfEarningLabel;
}

- (UIButton *)buttonTransferredIn
{
    if(!_buttonTransferredIn) {
        UIColor *color = COLOR_HEXSTRING(@"#EC702D");
        _buttonTransferredIn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_buttonTransferredIn defaultCommonButtonWithTitleColor:[UIColor whiteColor]
                                                backgroundColor:color
                                           backgroundImageColor:color
                                                    borderColor:color
                                                    borderWidth:0.0
                                                   cornerRadius:2.0f];
        [_buttonTransferredIn setTitle:NSLocalizedString(@"转入", nil) forState:UIControlStateNormal];
        [_buttonTransferredIn addTarget:self action:@selector(pressButtonActionTransferredIn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _buttonTransferredIn;
}

- (UIButton *)buttonTransferredOut
{
    if(!_buttonTransferredOut) {
        UIColor *color = COLOR_HEXSTRING(@"#FCF6EE");
        _buttonTransferredOut = [UIButton buttonWithType:UIButtonTypeCustom];
        [_buttonTransferredOut defaultCommonButtonWithTitleColor:COLOR_HEXSTRING(@"#EC702D")
                                                backgroundColor:color
                                           backgroundImageColor:color
                                                    borderColor:color
                                                    borderWidth:0.0
                                                   cornerRadius:2.0f];
        [_buttonTransferredOut setTitle:NSLocalizedString(@"转出", nil) forState:UIControlStateNormal];
        [_buttonTransferredOut addTarget:self action:@selector(pressButtonActionTransferredOut:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _buttonTransferredOut;
}


#pragma mark - Private

- (void)updateMainUIMoneyInfo:(BOOL)isShowMoneyInfo
{
    if (isShowMoneyInfo) {
        [self.imageViewOfEye setImage:[UIImage imageNamed:@"icon_yeb_eye_open"]];
        [self.imageViewOfEye mas_updateConstraints:^(MASConstraintMaker *make) {
            CGFloat imageSize = CFC_AUTOSIZING_WIDTH(12.0f);
            make.size.mas_equalTo(CGSizeMake(imageSize, imageSize));
        }];
    } else {
        [self.imageViewOfEye setImage:[UIImage imageNamed:@"icon_yeb_eye_close"]];
        [self.imageViewOfEye mas_updateConstraints:^(MASConstraintMaker *make) {
            CGFloat imageSize = CFC_AUTOSIZING_WIDTH(8.0f);
            make.size.mas_equalTo(CGSizeMake(imageSize, imageSize));
        }];
    }
    
    if (!isShowMoneyInfo) {
        [self.totalBalanceLabel setText:@"****"];
        [self.totalEarningsLabel setText:@"****"];
        [self.rateOfEarningLabel setText:@"****"];
    } else {
        if (!self.yebInfoModel) {
            return;
        }
        [self.totalBalanceLabel setText:[NSString stringWithFormat:@"%.2f",self.yebInfoModel.m_totalMoney]];
        [self.totalEarningsLabel setText: [NSString stringWithFormat:@"%.2f", self.yebInfoModel.m_totalEarnings]];
        [self.rateOfEarningLabel setText:[NSString stringWithFormat:@"%.2f",self.yebInfoModel.m_sevenDyr]];
    }
    
    [self.day30EarningsLabel setAttributedText:[self createDay30EarningsString:isShowMoneyInfo]];
}

- (NSAttributedString *)createDay30EarningsString:(BOOL)isShowMoneyInfo
{
    NSString *money = @"****";
    if (isShowMoneyInfo && self.yebInfoModel) {
        money = [NSString stringWithFormat:@"%.2f",self.yebInfoModel.m_thirtyEarnings];
    }
    UIFont *textFont = [UIFont systemFontOfSize:CFC_AUTOSIZING_FONT(13.0f)];
    UIFont *moneyFont = [UIFont boldSystemFontOfSize:CFC_AUTOSIZING_FONT(16.0f)];
    NSDictionary *attributesText = @{ NSFontAttributeName:textFont,
                                       NSForegroundColorAttributeName:COLOR_SYSTEM_MAIN_FONT_DEFAULT};
    NSDictionary *attributesMoney = @{ NSFontAttributeName:moneyFont,
                                         NSForegroundColorAttributeName:COLOR_HEXSTRING(@"#EC702D")};
    NSArray<NSString *> *stringArray = @[ NSLocalizedString(@"转入一万元，30天收益约 ", nil), money, NSLocalizedString(@" 元", nil)];
    NSArray *attributeArray = @[attributesText, attributesMoney, attributesText];
    NSAttributedString *attributedString = [CFCSysUtil attributedString:stringArray attributeArray:attributeArray];
    return attributedString;
}

- (FYYEBIconMarkView *)createIconMarkView:(NSString *)title imageUrl:(NSString *)imageUrl
{
    UIColor *todayTitleColor = [UIColor whiteColor];
    UIFont *todayTitleFont = [UIFont systemFontOfSize:CFC_AUTOSIZING_FONT(14)];
    
    FYYEBIconMarkView *view = [[FYYEBIconMarkView alloc] init];
    // 标题
    [view setTitle:title];
    [view setTitleFont:todayTitleFont];
    [view setTitleColor:todayTitleColor];
    [view setTitleTextAlignment:NSTextAlignmentCenter];
    // 图标
    [view setImageUrl:imageUrl];
    
    return view;
}

- (void)addNotification
{
    [NOTIF_CENTER addObserver:self selector:@selector(loadDataAndUpdateMainUI) name:kNotificationYuEBaoTransferBalanceChange object:nil];
}

- (void)dealloc
{
    [NOTIF_CENTER removeObserver:self];
}


@end

