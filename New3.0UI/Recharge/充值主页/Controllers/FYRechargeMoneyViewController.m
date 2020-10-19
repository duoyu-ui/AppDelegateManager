//
//  FYRechargeMoneyViewController.m
//  ProjectCSHB
//
//  Created by fangyuan on 2020/5/23.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "FYRechargeMoneyViewController.h"
#import "TPKeyboardAvoidingScrollView.h"
#import "FYPayModeModel.h"
//
#import "FYRechargeOfficialViewController.h"
#import "FYRechargeThirdPartyViewController.h"

@interface FYRechargeMoneyViewController () <UITextFieldDelegate>
//
@property (nonatomic, copy) NSString *userRealName;
@property (nonatomic, strong) FYPayModeModel *payModeModel;
//
@property (nonatomic, strong) UILabel *tipInfoLabel;
@property (nonatomic, strong) UITextField *moneyTextField;
@property (nonatomic, strong) UIButton *confirmButton;
@property (nonatomic, strong) NSMutableArray<UILabel *> *moneyButtton;
@property (nonatomic, strong) NSArray<NSString *> *moneyAllocationArray;

@end

@implementation FYRechargeMoneyViewController

#pragma mark - Actions

- (void)pressConfirmButtonAction:(UIButton *)button
{
    [self resignFirstResponderOfTextField];
    
    if ([APPINFORMATION isGuest]) {
        return;
    }
    
    NSString *money = STR_TRI_WHITE_SPACE(self.moneyTextField.text);
    if (VALIDATE_STRING_EMPTY(money)) {
        ALTER_INFO_MESSAGE(NSLocalizedString(@"金额不能为空！", nil))
        return;
    }

    if (self.payModeModel.minAmount.floatValue > 0
        && money.floatValue < self.payModeModel.minAmount.floatValue) {
        NSString *message = [NSString stringWithFormat:NSLocalizedString(@"充值金额不能小于%@元！", nil), self.payModeModel.minAmount.stringValue];
        ALTER_INFO_MESSAGE(message)
        return;
    }
    
    if (self.payModeModel.maxAmount.floatValue > 0
        && money.floatValue > self.payModeModel.maxAmount.floatValue) {
        NSString *message = [NSString stringWithFormat:NSLocalizedString(@"充值金额不能大于%@元！", nil), self.payModeModel.maxAmount.stringValue];
        ALTER_INFO_MESSAGE(message)
        return;
    }
    
    /* 可以允许用户自己输入
    if (self.moneyAllocationArray.count > 0 && ![self.moneyAllocationArray containsObject:money]) {
        NSString *money = [self.moneyAllocationArray componentsJoinedByString:@","];
        NSString *message = [NSString stringWithFormat:NSLocalizedString(@"只允许充值以下固定金额:\n%@", nil),money];
        ALTER_INFO_MESSAGE(message)
        return;
    }
    */
    
    [self doRequestGamesRechargeVerifyThen:^(BOOL isPassFlag, NSString *remark) {
        if (isPassFlag) {
            if (STR_RECHARGE_CHANNELPAY_TYPE_OFFICIAL == self.payModeModel.chanelType.integerValue) {
                FYRechargeOfficialViewController *viewController = [[FYRechargeOfficialViewController alloc] initWithUserRealName:self.userRealName money:money payModeModel:self.payModeModel];
                // 官方充值
                [self.navigationController pushViewController:viewController animated:YES];
            } else {
                // VIP充值
                // 三方充值
                [self doNoOfficialRechargeWithMoney:money];
            }
        } else {
            if (!VALIDATE_STRING_EMPTY(remark)) {
                AlertTipPopUpView* popupView = [[AlertTipPopUpView alloc]init];
                [popupView showInApplicationKeyWindow];
                [popupView richElementsInViewWithModel:remark actionBlock:^(id data) {
                    
                }];
            }
        }
    }];
}

- (void)pressItemMoneyButtonView:(UITapGestureRecognizer *)gesture
{
    UILabel *itemView = (UILabel *)gesture.view;
    
    NSUInteger index = itemView.tag - 8000;
    
    if (index >= self.moneyButtton.count || index >= self.moneyAllocationArray.count) {
        FYLog(NSLocalizedString(@"数组越界，请检测代码。", nil));
        return;
    }
    
    NSString *money = [self.moneyAllocationArray objectAtIndex:index];
    [self.moneyTextField setText:money];
    [self doChangeTipInfoByTextFieldMoney:money];
    
    [self.moneyButtton enumerateObjectsUsingBlock:^(UILabel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (index == idx) {
            dispatch_main_async_safe(^{
                [obj setTextColor:COLOR_SYSTEM_MAIN_UI_THEME_DEFAULT];
                [obj addBorderWithColor:COLOR_SYSTEM_MAIN_UI_THEME_DEFAULT cornerRadius:2.0f andWidth:1.0f];
            });
        } else {
            dispatch_main_async_safe(^{
                [obj setTextColor:COLOR_SYSTEM_MAIN_FONT_DEFAULT];
                [obj addBorderWithColor:COLOR_SYSTEM_MAIN_UI_THEME_DEFAULT cornerRadius:2.0f andWidth:0.0f];
            });
        }
    }];
}


- (void)pressTouchActionOfContainerView:(UITapGestureRecognizer *)gesture
{
    [self resignFirstResponderOfTextField];
}


#pragma mark - Life Cycle

- (instancetype)initWithPayModeModel:(FYPayModeModel *)payModeModel
{
    return [self initWithUserRealName:@"" payModeModel:payModeModel];
}

- (instancetype)initWithUserRealName:(NSString *)userRealName payModeModel:(FYPayModeModel *)payModeModel
{
    self = [super init];
    if (self) {
        _userRealName = userRealName;
        _payModeModel = payModeModel;
        //
        if (!VALIDATE_STRING_EMPTY(payModeModel.allocationAmount)) {
            NSArray<NSString *> *splitArr = [payModeModel.allocationAmount componentsSeparatedByString:@","];
            _moneyAllocationArray = [splitArr filteredArray:^BOOL(NSString *object) {
                return !VALIDATE_STRING_EMPTY(object);
            }];
        }
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view setBackgroundColor:COLOR_TABLEVIEW_BACK_VIEW_BACKGROUND_DEFAULT];
    
    [self createMainUIView];
}

- (void)createMainUIView
{
    CGFloat margin = CFC_AUTOSIZING_MARGIN(MARGIN);
    NSString *payTitleString = @"";
    NSString *iconImageUrl = @"";
    NSAttributedString *tipInfoString = [self tipInfoAttributedString:COLOR_HEXSTRING(@"#C7A876")];
    
    // 支付方式
    if (STR_RECHARGE_CHANNELPAY_MODE_KEY_WECHAT == self.payModeModel.type.value.integerValue) {
        payTitleString = NSLocalizedString(@"微信支付", nil);
        iconImageUrl = @"icon_wechatpay_unselect";
    } else if (STR_RECHARGE_CHANNELPAY_MODE_KEY_ALIPAY == self.payModeModel.type.value.integerValue) {
        payTitleString = NSLocalizedString(@"支付宝", nil);
        iconImageUrl = @"icon_alipay_unselect";
    } else if (STR_RECHARGE_CHANNELPAY_MODE_KEY_BANKCARD == self.payModeModel.type.value.integerValue) {
        payTitleString = NSLocalizedString(@"银行卡", nil);
        iconImageUrl = @"icon_bankcard_unselect";
    } else if (STR_RECHARGE_CHANNELPAY_MODE_KEY_QQPAY == self.payModeModel.type.value.integerValue) {
        payTitleString = NSLocalizedString(@"QQ支付", nil);
        iconImageUrl = @"icon_qqpay_unselect";
    } else if (STR_RECHARGE_CHANNELPAY_MODE_KEY_JDPAY == self.payModeModel.type.value.integerValue) {
        payTitleString = NSLocalizedString(@"京东支付", nil);
        iconImageUrl = @"icon_jdpay_unselect";
    } else {
        payTitleString = NSLocalizedString(@"银行卡", nil);
        iconImageUrl = @"icon_bankcard_unselect";
    }
    
    UIScrollView *rootScrollView = ({
        TPKeyboardAvoidingScrollView *scrollView = [[TPKeyboardAvoidingScrollView alloc] initWithFrame:self.view.bounds];
        [scrollView setShowsVerticalScrollIndicator:YES];
        [self.view addSubview:scrollView];
        
        [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view);
            make.right.equalTo(self.view);
            if (CFC_IS_IPHONE_X_OR_GREATER) {
                if (@available(iOS 11.0, *)) {
                    make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
                    make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
                } else {
                    make.top.equalTo(self.view.mas_top);
                    make.bottom.equalTo(self.view.mas_bottom);
                }
            } else {
                make.top.equalTo(self.view.mas_top);
                make.bottom.equalTo(self.view.mas_bottom);
            }
        }];
        
        scrollView;
    });
    rootScrollView.mas_key = @"rootScrollView";
    
    UIView *containerView = ({
        UIView *view = [[UIView alloc] init];
        [rootScrollView addSubview:view];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pressTouchActionOfContainerView:)];
        [view addGestureRecognizer:tapGesture];
        
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(rootScrollView);
            make.width.equalTo(rootScrollView);
            if (CFC_IS_IPHONE_X_OR_GREATER) {
                make.height.mas_greaterThanOrEqualTo(SCREEN_HEIGHT-STATUS_NAVIGATION_BAR_HEIGHT-TAB_BAR_DANGER_HEIGHT+1.0);
            } else {
                make.height.mas_greaterThanOrEqualTo(SCREEN_HEIGHT-STATUS_NAVIGATION_BAR_HEIGHT+1.0);
            }
        }];
        view;
    });
    containerView.mas_key = @"containerView";
    
    UIView *headerAreaView = ({
        CGFloat textFieldHeight = CFC_AUTOSIZING_WIDTH(60.0f);
        CGFloat headerContainerHeight = CFC_AUTOSIZING_WIDTH(140.0f);
        
        UIFont *textTitleFont = [UIFont boldSystemFontOfSize:CFC_AUTOSIZING_FONT(17.0f)];
        UIColor *textTitleColor = COLOR_SYSTEM_MAIN_FONT_DEFAULT;
        //
        UIFont *textFieldFont = [UIFont boldSystemFontOfSize:CFC_AUTOSIZING_FONT(20.0f)];
        UIColor *textFieldColor = COLOR_SYSTEM_MAIN_FONT_DEFAULT;
        UIColor *textFieldPlaceholderColor = [UIColor colorWithRed:0.68 green:0.68 blue:0.68 alpha:1.00];
        //
        UIFont *textContentFont = [UIFont systemFontOfSize:CFC_AUTOSIZING_FONT(14.0f)];
        UIColor *textContentColor = COLOR_SYSTEM_MAIN_FONT_ASSIST_DEFAULT;
        
        // 容器
        UIView *view = [UIView new];
        [containerView addSubview:view];
        [view setBackgroundColor:[UIColor whiteColor]];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(containerView.mas_top);
            make.left.equalTo(containerView.mas_left);
            make.right.equalTo(containerView.mas_right);
            make.height.equalTo(@(headerContainerHeight));
        }];
        
        // 标题
        UILabel *titleLabel = [UILabel new];
        [view addSubview:titleLabel];
        [titleLabel setFont:textTitleFont];
        [titleLabel setTextColor:textTitleColor];
        [titleLabel setText:NSLocalizedString(@"输入金额", nil)];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(view.mas_top).offset(margin*1.5f);
            make.left.equalTo(view.mas_left).offset(margin*1.5f);
            make.right.equalTo(view.mas_right).offset(-margin*1.5f);
        }];
        titleLabel.mas_key = @"titleLabel";
        
        // 人民币¥
        UILabel *moneyLabel = [UILabel new];
        [view addSubview:moneyLabel];
        [moneyLabel setText:@"¥"];
        [moneyLabel setTextColor:textTitleColor];
        [moneyLabel setFont:[UIFont boldSystemFontOfSize:CFC_AUTOSIZING_FONT(23.0f)]];
        [moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(view.mas_centerY);
            make.left.equalTo(titleLabel.mas_left);
            make.width.equalTo(@(25));
            make.height.equalTo(@(textFieldHeight));
        }];
        moneyLabel.mas_key = @"moneyLabel";
        
        // 输入框
        UITextField *moneyTextField = [UITextField new];
        [view addSubview:moneyTextField];
        [moneyTextField setDelegate:self];
        [moneyTextField setFont:textFieldFont];
        [moneyTextField setTextColor:textFieldColor];
        [moneyTextField setBorderStyle:UITextBorderStyleNone];
        [moneyTextField setKeyboardType:UIKeyboardTypeNumberPad];
        [moneyTextField setClearButtonMode:UITextFieldViewModeWhileEditing];
        [moneyTextField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
        [moneyTextField setAttributedPlaceholder:[[NSAttributedString alloc] initWithString:NSLocalizedString(@"请输入金额", nil) attributes:@{ NSForegroundColorAttributeName : textFieldPlaceholderColor }]];
        [moneyTextField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(view.mas_centerY);
            make.left.equalTo(moneyLabel.mas_right);
            make.right.equalTo(titleLabel.mas_right);
            make.height.equalTo(@(textFieldHeight));
        }];
        self.moneyTextField = moneyTextField;
        self.moneyTextField.mas_key = @"moneyTextField";
        
        // 描述
        UILabel *tipInfoLabel = [UILabel new];
        [view addSubview:tipInfoLabel];
        [tipInfoLabel setFont:textContentFont];
        [tipInfoLabel setTextColor:textContentColor];
        [tipInfoLabel setAttributedText:tipInfoString];
        [tipInfoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(view.mas_bottom).offset(-margin);
            make.left.equalTo(titleLabel.mas_left);
            make.right.equalTo(titleLabel.mas_right);
        }];
        self.tipInfoLabel = tipInfoLabel;
        self.tipInfoLabel.mas_key = @"contentLabel";
        
        view;
    });
    headerAreaView.mas_key = @"headerAreaView";

    // 金额选择区域
    UIView *lastItemLabel = nil;
    if (self.moneyAllocationArray.count > 0) {
        int colum = 3; // 列数
        CGFloat margin = CFC_AUTOSIZING_MARGIN(MARGIN);
        CGFloat left_right_gap = margin * 1.0f;
        CGFloat item_gap = margin;
        CGFloat itemWidth = (SCREEN_WIDTH - left_right_gap*2.0f - item_gap*(colum-1)) / colum;
        CGFloat itemHeight = itemWidth * 0.4f;
        CGFloat autoNameFontSize = CFC_AUTOSIZING_FONT(16.0f);
        
        _moneyButtton = [NSMutableArray<UILabel *> array];
        for (int idx = 0; idx < self.moneyAllocationArray.count; idx ++) {
            NSString *money = [self.moneyAllocationArray objectAtIndex:idx];
            if (VALIDATE_STRING_EMPTY(money)) {
                continue;
            }
            UILabel *itemLabel = ({
                UILabel *label = [UILabel new];
                [containerView addSubview:label];
                [label setTag:8000+idx];
                [label setText:[NSString stringWithFormat:@"%@%@",money,NSLocalizedString(@"元", nil)]];
                [label setUserInteractionEnabled:YES];
                [label setTextAlignment:NSTextAlignmentCenter];
                [label setBackgroundColor:[UIColor whiteColor]];
                [label setTextColor:COLOR_SYSTEM_MAIN_FONT_DEFAULT];
                [label setFont:[UIFont systemFontOfSize:autoNameFontSize]];
                
                UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pressItemMoneyButtonView:)];
                [label addGestureRecognizer:tapGesture];
                
                [label mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.width.equalTo(@(itemWidth));
                    make.height.equalTo(@(itemHeight));
                    if (!lastItemLabel) {
                        make.top.equalTo(headerAreaView.mas_bottom).offset(margin);
                        make.left.equalTo(containerView.mas_left).offset(left_right_gap);
                    } else {
                        if (idx % colum == 0) {
                            make.top.equalTo(lastItemLabel.mas_bottom).offset(item_gap);
                            make.left.equalTo(containerView.mas_left).offset(left_right_gap);
                        } else {
                            make.top.equalTo(lastItemLabel.mas_top);
                            make.left.equalTo(lastItemLabel.mas_right).offset(item_gap);
                        }
                    }
                }];

                label;
            });
            itemLabel.mas_key = [NSString stringWithFormat:@"itemLabel%d", idx];
            
            [_moneyButtton addObject:itemLabel];
            
            lastItemLabel = itemLabel;
        }
    }
    
    UIView *payInfoAreaView = ({
        UIColor *titleColor = COLOR_SYSTEM_MAIN_FONT_DEFAULT;
        UIFont *titleFont = [UIFont boldSystemFontOfSize:CFC_AUTOSIZING_FONT(14.0f)];
        
        // 容器
        UIView *view = [UIView new];
        [containerView addSubview:view];
        [view setBackgroundColor:[UIColor whiteColor]];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(containerView.mas_left);
            make.right.equalTo(containerView.mas_right);
            make.height.mas_equalTo(CFC_AUTOSIZING_WIDTH(120));
            if (lastItemLabel) {
                make.top.equalTo(lastItemLabel.mas_bottom).offset(margin);
            } else {
                make.top.equalTo(headerAreaView.mas_bottom).offset(margin);
            }
        }];
        
        // 标题 - 左
        UILabel *titleLabel = [UILabel new];
        [view addSubview:titleLabel];
        [titleLabel setFont:titleFont];
        [titleLabel setTextColor:titleColor];
        [titleLabel setText:NSLocalizedString(@"当前选择", nil)];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(view.mas_top).offset(margin*1.3f);
            make.left.equalTo(view.mas_left).offset(margin*1.5f);
        }];
        titleLabel.mas_key = @"titleLabel";
        
        // 标题 - 左
        UILabel *titlePayLabel = [UILabel new];
        [view addSubview:titlePayLabel];
        [titlePayLabel setFont:titleFont];
        [titlePayLabel setTextColor:titleColor];
        [titlePayLabel setText:payTitleString];
        [titlePayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(titleLabel.mas_centerY);
            make.right.equalTo(view.mas_right).offset(-margin*1.5f);
        }];
        titlePayLabel.mas_key = @"titlePayLabel";
        
        // 图标（支付）
        UIImageView *iconImageView = ({
            UIImageView *imageView = [[UIImageView alloc] init];
            [view addSubview:imageView];
            [imageView setImage:[UIImage imageNamed:iconImageUrl]];
            [imageView setContentMode:UIViewContentModeScaleAspectFit];
            [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(titleLabel.mas_centerY);
                make.right.equalTo(titlePayLabel.mas_left).offset(-margin*0.5f);
                make.size.mas_equalTo(CGSizeMake(27, 27));
            }];
            
            imageView;
        });
        iconImageView.mas_key = @"iconImageView";
        
        // 底部横线
        UIView *separatorLineView = [[UIView alloc] init];
        [view addSubview:separatorLineView];
        [separatorLineView setBackgroundColor:COLOR_TABLEVIEW_SEPARATOR_LINE_DEFAULT];
        [separatorLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(titleLabel.mas_bottom).offset(margin*1.3f);
            make.left.equalTo(view.mas_left);
            make.right.equalTo(view.mas_right);
            make.height.equalTo(@(SEPARATOR_LINE_HEIGHT));
        }];
        separatorLineView.mas_key = @"separatorLineView";
        
        // 图标（详情）
        UIImageView *detailImageView = ({
            UIImageView *imageView = [[UIImageView alloc] init];
            [view addSubview:imageView];
            [imageView setContentMode:UIViewContentModeScaleAspectFit];
            [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(separatorLineView.mas_bottom).offset(margin*1.5f);
                make.left.equalTo(view.mas_left).offset(margin*1.5f);
            }];

            imageView;
        });
        detailImageView.mas_key = @"detailImageView";

        // 标题（详情）
        UILabel *detailTitleLabel = ({
            UILabel *label = [UILabel new];
            [view addSubview:label];
            [label setText:STR_APP_TEXT_PLACEHOLDER];
            [label setFont:[UIFont boldSystemFontOfSize:CFC_AUTOSIZING_FONT(15)]];
            [label setTextColor:COLOR_SYSTEM_MAIN_FONT_DEFAULT];
            [label setTextAlignment:NSTextAlignmentLeft];

            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(detailImageView.mas_centerY);
                make.left.equalTo(detailImageView.mas_right).offset(margin*0.7f);
                make.right.equalTo(view.mas_right).offset(-margin*1.5f);
            }];

            label;
        });
        detailTitleLabel.mas_key = @"detailTitleLabel";
        
        // 内容（详情）
        UILabel *detailContentLabel = ({
            UILabel *label = [UILabel new];
            [view addSubview:label];
            [label setNumberOfLines:1];
            [label setText:STR_APP_TEXT_PLACEHOLDER];
            [label setTextColor:COLOR_SYSTEM_MAIN_FONT_ASSIST_DEFAULT];
            [label setTextAlignment:NSTextAlignmentLeft];

            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(detailTitleLabel.mas_bottom).offset(margin*0.5f);
                make.left.equalTo(detailTitleLabel.mas_left);
                make.right.equalTo(detailTitleLabel.mas_right);
            }];

            label;
        });
        detailContentLabel.mas_key = @"detailContentLabel";

        // 赋值
        {
            [detailTitleLabel setText:self.payModeModel.title];

            if (self.payModeModel.maxAmount.floatValue <= self.payModeModel.minAmount.floatValue) {
                UIFont *textRemarksFont = [UIFont systemFontOfSize:CFC_AUTOSIZING_FONT(14)];
                NSDictionary *attributesRemarks = @{ NSFontAttributeName:textRemarksFont,
                                                     NSForegroundColorAttributeName:COLOR_SYSTEM_MAIN_FONT_DEFAULT};
                NSAttributedString *attributedString = [CFCSysUtil attributedString:@[self.payModeModel.chanelRemarks] attributeArray:@[attributesRemarks]];
                [detailContentLabel setAttributedText:attributedString];
            } else {
                UIFont *textMoneyFont = [UIFont systemFontOfSize:CFC_AUTOSIZING_FONT(14)];
                UIFont *textRemarksFont = [UIFont systemFontOfSize:CFC_AUTOSIZING_FONT(14)];
                NSDictionary *attributesText = @{ NSFontAttributeName:textMoneyFont,
                                                   NSForegroundColorAttributeName:COLOR_SYSTEM_MAIN_FONT_ASSIST_DEFAULT};
                NSDictionary *attributesRemarks = @{ NSFontAttributeName:textRemarksFont,
                                                     NSForegroundColorAttributeName:COLOR_SYSTEM_MAIN_FONT_DEFAULT};

                NSString *moeny = [NSString stringWithFormat:NSLocalizedString(@"单笔限额%@~%@元  ", nil), self.payModeModel.minAmount.stringValue, self.payModeModel.maxAmount.stringValue];
                NSArray<NSString *> *stringArray = @[moeny, self.payModeModel.chanelRemarks];
                NSArray *attributeArray = @[attributesText, attributesRemarks];
                NSAttributedString *attributedString = [CFCSysUtil attributedString:stringArray attributeArray:attributeArray];
                [detailContentLabel setAttributedText:attributedString];
            }

            if ([CFCSysUtil validateStringUrl:self.payModeModel.imageUrl]) {
                CGFloat imageSize = CFC_AUTOSIZING_WIDTH(27.0f);
                [detailImageView addCornerRadius:imageSize*0.5f];
                [detailImageView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.size.mas_equalTo(CGSizeMake(imageSize, imageSize));
                }];

                __block UIActivityIndicatorView *activityIndicator = nil;
                UIImage *placeholderImage = [UIImage imageNamed:@"icon_commonpay"];
                [detailImageView sd_setImageWithURL:[NSURL URLWithString:self.payModeModel.imageUrl] placeholderImage:placeholderImage options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
                    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                        if (!activityIndicator) {
                            [detailImageView addSubview:activityIndicator = [UIActivityIndicatorView.alloc initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite]];
                            [activityIndicator setColor:COLOR_ACTIVITY_INDICATOR_BACKGROUND];
                            [activityIndicator setCenter:detailImageView.center];
                            [activityIndicator startAnimating];
                        }
                    }];
                } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                    [activityIndicator removeFromSuperview];
                    activityIndicator = nil;
                }];
            } else {
                CGFloat imageSize = CFC_AUTOSIZING_WIDTH(27.0f);
                [detailImageView addCornerRadius:imageSize*0.5f];
                [detailImageView setImage:[UIImage imageNamed:self.payModeModel.imageUrl]];
                [detailImageView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.size.mas_equalTo(CGSizeMake(imageSize, imageSize));
                }];
            }
        }
        
        view;
    });
    payInfoAreaView.mas_key = @"payInfoAreaView";
    
    // 充值提示信息
    UILabel *rechargeTipInfoLabel = ({
//        NSString *content = [APPINFORMATION.commonInfo stringForKey:@"pay_rule"];
        UILabel *label = [UILabel new];
        [containerView addSubview:label];
        [label setText:[NSString stringWithFormat:NSLocalizedString(@"温馨提示：为确保您的款项及时到账，请您留意以下内容：\n\n1.若在存款中提示二维码已过期或者存入金额已满，请返回重新发起支付。\n\n2.站点每日都会产生大量存款订单，为确保每一位玩家的存款能够及时到账，请填写实际存款金额，以便于平台快速处理您的业务。\n\n3.支付时，请务必按照页面显示的金额进行支付，否则可能将导致订单延误或掉单。", nil)]];
        [label setNumberOfLines:0];
        [label setTextAlignment:NSTextAlignmentLeft];
        [label setTextColor:COLOR_SYSTEM_MAIN_FONT_ASSIST_DEFAULT];
        [label setFont:[UIFont systemFontOfSize:CFC_AUTOSIZING_FONT(14)]];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(payInfoAreaView.mas_bottom).offset(margin*1.5f);
            make.left.equalTo(containerView.mas_left).offset(margin*1.5f);
            make.right.equalTo(containerView.mas_right).offset(-margin*1.5f);
        }];
        
        label;
    });
    rechargeTipInfoLabel.mas_key = @"rechargeTipInfoLabel";
    
    // 确认按钮
    UIButton *confirmButton = ({
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button defaultStyleButton];
        [containerView addSubview:button];
        [button.layer setBorderWidth:0.0f];
        [button setTitle:NSLocalizedString(@"提交", nil) forState:UIControlStateNormal];
        [button addTarget:self action:@selector(pressConfirmButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.greaterThanOrEqualTo(rechargeTipInfoLabel.mas_bottom).offset(margin*2.0f);
            make.left.equalTo(containerView.mas_left).offset(margin*2.0f);
            make.right.equalTo(containerView.mas_right).with.offset(-margin*2.0f);
            make.height.equalTo(@(CFC_AUTOSIZING_WIDTH(SYSTEM_GLOBAL_BUTTON_HEIGHT)));
        }];
        
        button;
    });
    self.confirmButton = confirmButton;
    self.confirmButton.mas_key = @"confirmButton";

    [containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(confirmButton.mas_bottom).offset(margin*5.0f).priority(749);
    }];
    
}

- (void)resignFirstResponderOfTextField
{
    [self.view endEditing:YES];
    [self.moneyTextField resignFirstResponder];
}


#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField*)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSCharacterSet *characterSet;
    NSUInteger indexDotLocation = [textField.text rangeOfString:@"."].location;
    if (NSNotFound == indexDotLocation && 0 != range.location) {
        characterSet = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789.\n"] invertedSet];
    } else {
        characterSet = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789\n"] invertedSet];
    }
    NSString *filtered = [[string componentsSeparatedByCharactersInSet:characterSet] componentsJoinedByString:@""];
    BOOL basicTest = [string isEqualToString:filtered];
    if (!basicTest) {
        ALTER_INFO_MESSAGE(NSLocalizedString(@"请输入正确的充值金额！", nil))
        return NO;
    }
    if (NSNotFound != indexDotLocation && range.location > indexDotLocation + 2) {
        ALTER_INFO_MESSAGE(NSLocalizedString(@"充值金额最多2位小数点！", nil))
        return NO;
    }

    NSString *textString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    [self doChangeTipInfoByTextFieldMoney:textString];
    [self doChangeMoneyAllocatonButtonStatus:textString];
    
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    [self doChangeTipInfoByTextFieldMoney:@""];
    [self doChangeMoneyAllocatonButtonStatus:@""];
    
    return YES;
}


#pragma mark - Navigation

- (NSString *)prefersNavigationBarTitleViewTitle
{
    return STR_NAVIGATION_BAR_TITLE_RECHARGE_PAY_MONEY_CONTENT;
}


#pragma mark - Private

- (NSAttributedString *)tipInfoAttributedString:(UIColor *)moneyColor
{
    UIFont *textFont = [UIFont systemFontOfSize:CFC_AUTOSIZING_FONT(14)];
    NSDictionary *attributesText = @{ NSFontAttributeName:textFont,
                                      NSForegroundColorAttributeName:COLOR_SYSTEM_MAIN_FONT_ASSIST_DEFAULT};
    NSDictionary *attributesMoney = @{ NSFontAttributeName:textFont,
                                       NSForegroundColorAttributeName:moneyColor};
    
    if (self.moneyAllocationArray.count > 0 && self.payModeModel.maxAmount.floatValue > 0 && self.payModeModel.maxAmount.floatValue >= self.payModeModel.minAmount.floatValue) {
        NSString *moeny = [NSString stringWithFormat:@" %@~%@ ", self.payModeModel.minAmount.stringValue, self.payModeModel.maxAmount.stringValue];
        NSArray<NSString *> *stringArray = @[NSLocalizedString(@"单笔限额", nil), moeny, NSLocalizedString(@"元，只允许以下固定金额存款", nil)];
        NSArray *attributeArray = @[attributesText,attributesMoney,attributesText];
        return [CFCSysUtil attributedString:stringArray attributeArray:attributeArray];
    } else if (self.payModeModel.maxAmount.floatValue > 0 && self.payModeModel.maxAmount.floatValue >= self.payModeModel.minAmount.floatValue) {
        NSString *moeny = [NSString stringWithFormat:@" %@~%@ ", self.payModeModel.minAmount.stringValue, self.payModeModel.maxAmount.stringValue];
        NSArray<NSString *> *stringArray = @[NSLocalizedString(@"单笔限额", nil), moeny, NSLocalizedString(@"元", nil)];
        NSArray *attributeArray = @[attributesText,attributesMoney,attributesText];
        return [CFCSysUtil attributedString:stringArray attributeArray:attributeArray];
    } else if (self.moneyAllocationArray.count > 0) {
        NSArray<NSString *> *stringArray = @[NSLocalizedString(@"只允许以下固定金额存款", nil)];
        NSArray *attributeArray = @[attributesText];
        return [CFCSysUtil attributedString:stringArray attributeArray:attributeArray];
    } else {
        NSArray<NSString *> *stringArray = @[NSLocalizedString(@"单笔充值无限额", nil)];
        NSArray *attributeArray = @[attributesText];
        return [CFCSysUtil attributedString:stringArray attributeArray:attributeArray];
    }
    return nil;
}

- (void)doChangeTipInfoByTextFieldMoney:(NSString *)money
{
    if (VALIDATE_STRING_EMPTY(money)) {
        NSAttributedString *tipInfoAttributeString = [self tipInfoAttributedString:COLOR_HEXSTRING(@"#C7A876")];
        [self.tipInfoLabel setAttributedText:tipInfoAttributeString];
        return;
    }
    
    if (self.payModeModel.minAmount.floatValue > 0
        && money.floatValue < self.payModeModel.minAmount.floatValue) {
        NSString *message = [NSString stringWithFormat:NSLocalizedString(@"充值金额不能小于%@元", nil), self.payModeModel.minAmount.stringValue];
        [self.tipInfoLabel setText:message];
        [self.tipInfoLabel setTextColor:COLOR_SYSTEM_MAIN_UI_THEME_DEFAULT];
        return;
    }
    
    if (self.payModeModel.maxAmount.floatValue > 0
        && money.floatValue > self.payModeModel.maxAmount.floatValue) {
        NSString *message = [NSString stringWithFormat:NSLocalizedString(@"充值金额不能大于%@元", nil), self.payModeModel.maxAmount.stringValue];
        [self.tipInfoLabel setText:message];
        [self.tipInfoLabel setTextColor:COLOR_SYSTEM_MAIN_UI_THEME_DEFAULT];
        return;
    }
    
    NSAttributedString *tipInfoAttributeString = [self tipInfoAttributedString:COLOR_HEXSTRING(@"#C7A876")];
    [self.tipInfoLabel setAttributedText:tipInfoAttributeString];
}

- (void)doChangeMoneyAllocatonButtonStatus:(NSString *)money
{
    [self.moneyAllocationArray enumerateObjectsUsingBlock:^(NSString * _Nonnull allocation, NSUInteger idx, BOOL * _Nonnull stop) {
        UILabel *obj = [self.moneyButtton objectAtIndex:idx];
        if ([allocation isEqualToString:money]) {
            dispatch_main_async_safe(^{
                [obj setTextColor:COLOR_SYSTEM_MAIN_UI_THEME_DEFAULT];
                [obj addBorderWithColor:COLOR_SYSTEM_MAIN_UI_THEME_DEFAULT cornerRadius:2.0f andWidth:1.0f];
            });
        } else {
            dispatch_main_async_safe(^{
                [obj setTextColor:COLOR_SYSTEM_MAIN_FONT_DEFAULT];
                [obj addBorderWithColor:COLOR_SYSTEM_MAIN_UI_THEME_DEFAULT cornerRadius:2.0f andWidth:0.0f];
            });
        }
    }];
}

- (void)doRequestGamesRechargeVerifyThen:(void (^)(BOOL isPassFlag, NSString *remark))then
{
    PROGRESS_HUD_SHOW
    [NET_REQUEST_MANAGER requestGamesAllRechargeCheckUserStatusVerify:^(id response) {
        PROGRESS_HUD_DISMISS
        FYLog(NSLocalizedString(@"获取用户可充值状态 => \n%@", nil), response);
        if (!NET_REQUEST_SUCCESS(response)) {
           ALTER_HTTP_MESSAGE(response)
        } else {
            NSDictionary *data = NET_REQUEST_DATA(response);
            BOOL isPassFlay = [data boolForKey:@"passFlag"];
            NSString *remark = [data stringForKey:@"remark"];
            !then ?: then(isPassFlay,remark);
        }
    } failure:^(id error) {
        PROGRESS_HUD_DISMISS
        ALTER_HTTP_ERROR_MESSAGE(error)
        FYLog(NSLocalizedString(@"获取用户可充值状态出错 => \n%@", nil), error);
    }];
}

- (void)doNoOfficialRechargeWithMoney:(NSString *)money
{
    NSString *title = NSLocalizedString(@"在线充值", nil);
    if (STR_RECHARGE_CHANNELPAY_MODE_KEY_WECHAT == self.payModeModel.type.value.integerValue) {
        title = NSLocalizedString(@"微信支付", nil);
    } else if (STR_RECHARGE_CHANNELPAY_MODE_KEY_ALIPAY == self.payModeModel.type.value.integerValue) {
       title = NSLocalizedString(@"支付宝支付", nil);
    } else if (STR_RECHARGE_CHANNELPAY_MODE_KEY_BANKCARD == self.payModeModel.type.value.integerValue) {
        title = NSLocalizedString(@"银行卡支付", nil);
    } else if (STR_RECHARGE_CHANNELPAY_MODE_KEY_QQPAY == self.payModeModel.type.value.integerValue) {
        title = NSLocalizedString(@"QQ支付", nil);
    } else if (STR_RECHARGE_CHANNELPAY_MODE_KEY_JDPAY == self.payModeModel.type.value.integerValue) {
        title = NSLocalizedString(@"京东支付", nil);
    } else {
        title = NSLocalizedString(@"官方支付", nil);
    }
    //
    NSString *url = [NSString stringWithFormat:@"%@?userId=%@&money=%@&chanelId=%@", self.payModeModel.url, APPINFORMATION.userInfo.userId, money, self.payModeModel.uuid];
    NSString *webUrl = NET_URL_APPENDING(url);
    FYLog(NSLocalizedString(@"充值地址 => %@", nil), webUrl);
    //
    FYRechargeThirdPartyViewController *viewController = [[FYRechargeThirdPartyViewController alloc] initWithUrl:webUrl];
    [viewController setTitle:title];
    [self.navigationController pushViewController:viewController removeViewController:self];
}


@end

