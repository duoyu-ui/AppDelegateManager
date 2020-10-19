//
//  FYRechargeVerifyViewController.m
//  ProjectCSHB
//
//  Created by fangyuan on 2020/5/23.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "FYRechargeVerifyViewController.h"
#import "TPKeyboardAvoidingScrollView.h"
#import "FYRechargeMoneyViewController.h"
#import "FYPayModeModel.h"

@interface FYRechargeVerifyViewController () <UITextFieldDelegate>
//
@property (nonatomic, strong) FYPayModeModel *payModeModel;
//
@property (nonatomic, strong) UITextField *nameTextField;
@property (nonatomic, strong) UIButton *confirmButton;

@end

@implementation FYRechargeVerifyViewController

#pragma mark - Actions

- (void)pressConfirmButtonAction:(UIButton *)button
{
    [self resignFirstResponderOfTextField];
    
    if ([APPINFORMATION isGuest]) {
        return;
    }
    
    NSString *userName = STR_TRI_WHITE_SPACE(self.nameTextField.text);
    if (VALIDATE_STRING_EMPTY(userName)) {
        if (STR_RECHARGE_CHANNELPAY_MODE_KEY_WECHAT == self.payModeModel.type.value.integerValue) {
            ALTER_INFO_MESSAGE(NSLocalizedString(@"微信昵称不能为空！", nil))
        } else if (STR_RECHARGE_CHANNELPAY_MODE_KEY_ALIPAY == self.payModeModel.type.value.integerValue) {
            ALTER_INFO_MESSAGE(NSLocalizedString(@"支付宝真实姓名不能为空！", nil))
        } else if (STR_RECHARGE_CHANNELPAY_MODE_KEY_BANKCARD == self.payModeModel.type.value.integerValue) {
            ALTER_INFO_MESSAGE(NSLocalizedString(@"银行卡真实姓名不能为空！", nil))
        } else if (STR_RECHARGE_CHANNELPAY_MODE_KEY_QQPAY == self.payModeModel.type.value.integerValue) {
            ALTER_INFO_MESSAGE(NSLocalizedString(@"QQ账号不能为空！", nil))
        } else if (STR_RECHARGE_CHANNELPAY_MODE_KEY_JDPAY == self.payModeModel.type.value.integerValue) {
            ALTER_INFO_MESSAGE(NSLocalizedString(@"京东真实姓名不能为空！", nil))
        }
        return;
    }

    FYRechargeMoneyViewController *viewController = [[FYRechargeMoneyViewController alloc] initWithUserRealName:userName payModeModel:self.payModeModel];
    [self.navigationController pushViewController:viewController animated:YES];
}


- (void)pressTouchActionOfContainerView:(UITapGestureRecognizer *)gesture
{
    [self resignFirstResponderOfTextField];
    
}


#pragma mark - Life Cycle

- (instancetype)initWithPayModeModel:(FYPayModeModel *)payModeModel
{
    self = [super init];
    if (self) {
        _payModeModel = payModeModel;
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
    NSString *tipInfoString = @"";
    NSString *payTitleString = @"";
    NSString *iconImageUrl = @"";
    NSString *descrInfoString = @"";
    if (STR_RECHARGE_CHANNELPAY_MODE_KEY_WECHAT == self.payModeModel.type.value.integerValue) {
        payTitleString = NSLocalizedString(@"微信支付", nil);
        tipInfoString = NSLocalizedString(@"请输入微信昵称", nil);
        iconImageUrl = @"icon_wechatpay_unselect";
        descrInfoString = NSLocalizedString(@"微信充值需要您提供微信昵称", nil);
        if (STR_RECHARGE_CHANNELPAY_TYPE_OFFICIAL == self.payModeModel.chanelType.integerValue) {
            descrInfoString = NSLocalizedString(@"官方微信充值需要您提供微信昵称", nil);
        } else if (STR_RECHARGE_CHANNELPAY_TYPE_VIP == self.payModeModel.chanelType.integerValue) {
            descrInfoString = NSLocalizedString(@"微信充值需要您提供微信昵称", nil);
        } else if (STR_RECHARGE_CHANNELPAY_TYPE_THIRD == self.payModeModel.chanelType.integerValue) {
            descrInfoString = NSLocalizedString(@"微信充值需要您提供微信昵称", nil);
        }
    } else if (STR_RECHARGE_CHANNELPAY_MODE_KEY_ALIPAY == self.payModeModel.type.value.integerValue) {
        payTitleString = NSLocalizedString(@"支付宝", nil);
        tipInfoString = NSLocalizedString(@"请输入支付宝真实姓名", nil);
        iconImageUrl = @"icon_alipay_unselect";
        descrInfoString = NSLocalizedString(@"支付宝充值需要您提供支付宝真实姓名", nil);
        if (STR_RECHARGE_CHANNELPAY_TYPE_OFFICIAL == self.payModeModel.chanelType.integerValue) {
            descrInfoString = NSLocalizedString(@"官方支付宝充值需要您提供支付宝真实姓名", nil);
        } else if (STR_RECHARGE_CHANNELPAY_TYPE_VIP == self.payModeModel.chanelType.integerValue) {
            descrInfoString = NSLocalizedString(@"支付宝充值需要您提供支付宝真实姓名", nil);
        } else if (STR_RECHARGE_CHANNELPAY_TYPE_THIRD == self.payModeModel.chanelType.integerValue) {
            descrInfoString = NSLocalizedString(@"支付宝充值需要您提供支付宝真实姓名", nil);
        }
    } else if (STR_RECHARGE_CHANNELPAY_MODE_KEY_BANKCARD == self.payModeModel.type.value.integerValue) {
        payTitleString = NSLocalizedString(@"银行卡", nil);
        tipInfoString = NSLocalizedString(@"请输入持卡人真实姓名", nil);
        iconImageUrl = @"icon_bankcard_unselect";
        descrInfoString = NSLocalizedString(@"银行卡充值需要您提供持卡人真实姓名", nil);
        if (STR_RECHARGE_CHANNELPAY_TYPE_OFFICIAL == self.payModeModel.chanelType.integerValue) {
            descrInfoString = NSLocalizedString(@"官方银行卡充值需要您提供持卡人真实姓名", nil);
        } else if (STR_RECHARGE_CHANNELPAY_TYPE_VIP == self.payModeModel.chanelType.integerValue) {
            descrInfoString = NSLocalizedString(@"银行卡充值需要您提供持卡人真实姓名", nil);
        } else if (STR_RECHARGE_CHANNELPAY_TYPE_THIRD == self.payModeModel.chanelType.integerValue) {
            descrInfoString = NSLocalizedString(@"银行卡充值需要您提供持卡人真实姓名", nil);
        }
    } else if (STR_RECHARGE_CHANNELPAY_MODE_KEY_QQPAY == self.payModeModel.type.value.integerValue) {
        payTitleString = NSLocalizedString(@"QQ支付", nil);
        tipInfoString = NSLocalizedString(@"请输入QQ号码", nil);
        iconImageUrl = @"icon_qqpay_unselect";
        descrInfoString = NSLocalizedString(@"QQ充值需要您提供QQ号码", nil);
        if (STR_RECHARGE_CHANNELPAY_TYPE_OFFICIAL == self.payModeModel.chanelType.integerValue) {
            descrInfoString = NSLocalizedString(@"官方QQ充值需要您提供QQ号码", nil);
        } else if (STR_RECHARGE_CHANNELPAY_TYPE_VIP == self.payModeModel.chanelType.integerValue) {
            descrInfoString = NSLocalizedString(@"QQ充值需要您提供QQ号码", nil);
        } else if (STR_RECHARGE_CHANNELPAY_TYPE_THIRD == self.payModeModel.chanelType.integerValue) {
            descrInfoString = NSLocalizedString(@"QQ充值需要您提供QQ号码", nil);
        }
    } else if (STR_RECHARGE_CHANNELPAY_MODE_KEY_JDPAY == self.payModeModel.type.value.integerValue) {
        payTitleString = NSLocalizedString(@"京东支付", nil);
        tipInfoString = NSLocalizedString(@"请输入京东账号", nil);
        iconImageUrl = @"icon_jdpay_unselect";
        descrInfoString = NSLocalizedString(@"京东充值需要您提供京东账号", nil);
        if (STR_RECHARGE_CHANNELPAY_TYPE_OFFICIAL == self.payModeModel.chanelType.integerValue) {
            descrInfoString = NSLocalizedString(@"官方京东充值需要您提供京东账号", nil);
        } else if (STR_RECHARGE_CHANNELPAY_TYPE_VIP == self.payModeModel.chanelType.integerValue) {
            descrInfoString = NSLocalizedString(@"京东充值需要您提供京东账号", nil);
        } else if (STR_RECHARGE_CHANNELPAY_TYPE_THIRD == self.payModeModel.chanelType.integerValue) {
            descrInfoString = NSLocalizedString(@"京东充值需要您提供京东账号", nil);
        }
    } else {
        payTitleString = NSLocalizedString(@"银行卡", nil);
        tipInfoString = NSLocalizedString(@"请输入持卡人真实姓名", nil);
        iconImageUrl = @"icon_bankcard_unselect";
        descrInfoString = NSLocalizedString(@"银行卡充值需要您提供持卡人真实姓名", nil);
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
        UIFont *textFieldFont = [UIFont boldSystemFontOfSize:CFC_AUTOSIZING_FONT(16.0f)];
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
        [titleLabel setText:tipInfoString];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(view.mas_top).offset(margin*1.5f);
            make.left.equalTo(view.mas_left).offset(margin*1.5f);
            make.right.equalTo(view.mas_right).offset(-margin*1.5f);
        }];
        titleLabel.mas_key = @"titleLabel";
        
        // 输入框
        UITextField *nameTextField = [UITextField new];
        [view addSubview:nameTextField];
        [nameTextField setDelegate:self];
        [nameTextField setFont:textFieldFont];
        [nameTextField setTextColor:textFieldColor];
        [nameTextField setBorderStyle:UITextBorderStyleNone];
        [nameTextField setClearButtonMode:UITextFieldViewModeWhileEditing];
        [nameTextField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
        [nameTextField setAttributedPlaceholder:[[NSAttributedString alloc] initWithString:tipInfoString attributes:@{ NSForegroundColorAttributeName : textFieldPlaceholderColor }]];
        [nameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(view.mas_centerY);
            make.left.equalTo(titleLabel.mas_left);
            make.right.equalTo(titleLabel.mas_right);
            make.height.equalTo(@(textFieldHeight));
        }];
        self.nameTextField = nameTextField;
        self.nameTextField.mas_key = @"nameTextField";
        
        // 描述
        UILabel *contentLabel = [UILabel new];
        [view addSubview:contentLabel];
        [contentLabel setFont:textContentFont];
        [contentLabel setTextColor:textContentColor];
        [contentLabel setText:descrInfoString];
        [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(view.mas_bottom).offset(-margin);
            make.left.equalTo(titleLabel.mas_left);
            make.right.equalTo(titleLabel.mas_right);
        }];
        contentLabel.mas_key = @"contentLabel";
        
        view;
    });
    headerAreaView.mas_key = @"headerAreaView";

    UIView *payInfoAreaView = ({
        UIColor *titleColor = COLOR_SYSTEM_MAIN_FONT_DEFAULT;
        UIFont *titleFont = [UIFont boldSystemFontOfSize:CFC_AUTOSIZING_FONT(16.0f)];
        
        // 容器
        UIView *view = [UIView new];
        [containerView addSubview:view];
        [view setBackgroundColor:[UIColor whiteColor]];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(headerAreaView.mas_bottom).offset(margin);
            make.left.equalTo(containerView.mas_left);
            make.right.equalTo(containerView.mas_right);
            make.height.mas_equalTo(CFC_AUTOSIZING_WIDTH(120));
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
                            [activityIndicator mas_makeConstraints:^(MASConstraintMaker *make) {
                                make.centerX.equalTo(detailImageView.mas_centerX);
                                make.centerY.equalTo(detailImageView.mas_centerY);
                            }];
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
        [button setTitle:NSLocalizedString(@"下一步", nil) forState:UIControlStateNormal];
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
    [self.nameTextField resignFirstResponder];
}


#pragma mark - Navigation

- (NSString *)prefersNavigationBarTitleViewTitle
{
    return STR_NAVIGATION_BAR_TITLE_RECHARGE_PAY_VERIFY;
}


@end

