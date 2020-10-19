//
//  FYRechargeOfficialViewController.m
//  ProjectCSHB
//
//  Created by fangyuan on 2020/5/24.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "FYRechargeOfficialViewController.h"
#import "FYPayModeModel.h"

@interface FYRechargeOfficialViewController ()
//
@property (nonatomic, copy) NSString *money;
@property (nonatomic, copy) NSString *userRealName;
@property (nonatomic, strong) FYPayModeModel *payModeModel;
//
@property (nonatomic, strong) UIButton *confirmButton;
//
@property (nonatomic, strong) UIImageView *thirdPayImageView;

@end

@implementation FYRechargeOfficialViewController

#pragma mark - Actions

- (void)pressConfirmButtonAction:(UIButton *)button
{
    [self doRequestGamesOfficialRechargeOrderThen:^(BOOL success) {
        if (success) {
            [self doAfterSubmitRechargeOrderSuccessThen];
        }
    }];
}

- (void)pressItemCopyButtonView:(UITapGestureRecognizer *)gesture
{
    UILabel *itemView = (UILabel *)gesture.view;
    
    NSUInteger index = itemView.tag - 8000;
    
    if (index < 1 || index >4) {
        return;
    }
    
    NSString *content = @"";
    if (1 == index) { // 复制->收款银行
        content = self.payModeModel.bank.name;
    } else if (2 == index) { // 复制->收款人
        content = self.payModeModel.payeeName;
    } else if (3 == index) { // 复制->收款开户行
        content = self.payModeModel.bankAddress;
    } else if (4 == index) { // 复制->收款账号
        content = self.payModeModel.bankNum;
    }
    
    if (!VALIDATE_STRING_EMPTY(content)) {
        UIPasteboard *pastboard = [UIPasteboard generalPasteboard];
        pastboard.string = content;
        ALTER_INFO_MESSAGE(NSLocalizedString(@"复制成功", nil))
    }
}


#pragma mark - Life Cycle

- (instancetype)initWithUserRealName:(NSString *)userRealName money:(NSString *)money payModeModel:(FYPayModeModel *)payModeModel
{
    self = [super init];
    if (self) {
        _money = money;
        _userRealName = userRealName;
        _payModeModel = payModeModel;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self createMainUIView];
}

- (void)createMainUIView
{
    CGFloat margin = CFC_AUTOSIZING_MARGIN(MARGIN);
    
    UIScrollView *rootScrollView = ({
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
        [scrollView setShowsVerticalScrollIndicator:YES];
        [self.view addSubview:scrollView];
        
        [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view);
            make.right.equalTo(self.view);
            if (IS_IPHONE_X) {
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
        
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(rootScrollView);
            make.width.equalTo(rootScrollView);
            if (IS_IPHONE_X) {
                make.height.mas_greaterThanOrEqualTo(SCREEN_HEIGHT-STATUS_NAVIGATION_BAR_HEIGHT-TAB_BAR_DANGER_HEIGHT+1.0);
            } else {
                make.height.mas_greaterThanOrEqualTo(SCREEN_HEIGHT-STATUS_NAVIGATION_BAR_HEIGHT+1.0);
            }
        }];
        view;
    });
    containerView.mas_key = @"containerView";
    
    UIView *lastItemView = nil;
    if (STR_RECHARGE_CHANNELPAY_MODE_KEY_BANKCARD == self.payModeModel.type.value.integerValue) {
        lastItemView = [self createMainUIViewOfBankCard:containerView];
    } else {
        lastItemView = [self createMainUIViewOfOtherPayMode:containerView];
    }
    
    UIButton *confirmButton = ({
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button defaultStyleButton];
        [containerView addSubview:button];
        [button.layer setBorderWidth:0.0f];
        [button setTitle:NSLocalizedString(@"提交信息", nil) forState:UIControlStateNormal];
        [button addTarget:self action:@selector(pressConfirmButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            if (lastItemView) {
                make.top.greaterThanOrEqualTo(lastItemView.mas_bottom).offset(margin*2.0f);
            }
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

- (UIView *)createMainUIViewOfBankCard:(UIView *)containerView
{
    CGFloat margin = CFC_AUTOSIZING_MARGIN(MARGIN);
    //
    UIFont *textContentFont = [UIFont systemFontOfSize:CFC_AUTOSIZING_FONT(14.0f)];
    UIColor *textContentColor = COLOR_SYSTEM_MAIN_FONT_DEFAULT;
    CGFloat textContainerHeight = CFC_AUTOSIZING_WIDTH(60.0f);
    
    UIImageView *iconImageView = ({
        NSString *imageUrl = [NSString stringWithFormat:@"recharget%@", self.payModeModel.type.value];
        //
        UIImageView *imageView = [[UIImageView alloc] init];
        [containerView addSubview:imageView];
        [imageView setImage:[UIImage imageNamed:imageUrl]];
        [imageView setContentMode:UIViewContentModeScaleAspectFit];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(containerView.mas_top).offset(margin*1.5f);
            make.right.equalTo(containerView.mas_right).offset(-margin*1.5f);
            make.width.equalTo(containerView.mas_width).multipliedBy(0.4f);
            make.height.equalTo(containerView.mas_width).multipliedBy(0.1f);
        }];
        
        imageView;
    });
    iconImageView.mas_key = @"iconImageView";
    
    UILabel *contentLabel = ({
        NSString *descrInfoString = NSLocalizedString(@"尊敬的客户您好，您的存款订单已生成，请记录以下官方账户信息以及存款金额，请尽快登录您的网上银行/手机银行/支付宝进行转账，转账完成以后请保留银行回执，以便确认转账信息。", nil);
        UILabel *label = [UILabel new];
        [containerView addSubview:label];
        [label setNumberOfLines:0];
        [label setText:descrInfoString];
        [label setFont:textContentFont];
        [label setTextColor:textContentColor];
        [label setTextAlignment:NSTextAlignmentLeft];
        [label setTextColor:COLOR_SYSTEM_MAIN_FONT_ASSIST_DEFAULT];

        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(iconImageView.mas_bottom).offset(margin*1.0f);
            make.left.equalTo(containerView.mas_left).offset(margin*1.5f);
            make.right.equalTo(containerView.mas_right).offset(-margin*1.5f);
        }];
        
        label;
    });
    contentLabel.mas_key = @"contentLabel";
    
    // 存款金额
    UIView *bankMoneyAreaView = ({
        UIView *view = [self createMainUIViewOfBankCardCell:containerView tilte:NSLocalizedString(@"存款金额：", nil) content:self.money tag:0];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(contentLabel.mas_bottom).offset(margin*2.5f);
            make.left.equalTo(containerView.mas_left);
            make.right.equalTo(containerView.mas_right);
            make.height.equalTo(@(textContainerHeight));
        }];
        
        view;
    });
    
    // 收款银行
    UIView *bankNameAreaView = ({
        UIView *view = [self createMainUIViewOfBankCardCell:containerView tilte:NSLocalizedString(@"收款银行：", nil) content:self.payModeModel.bank.name tag:8001];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(bankMoneyAreaView.mas_bottom);
            make.left.equalTo(containerView.mas_left);
            make.right.equalTo(containerView.mas_right);
            make.height.equalTo(@(textContainerHeight));
        }];
        
        view;
    });
    
    // 收款人
    UIView *bankUserNameAreaView = ({
        UIView *view = [self createMainUIViewOfBankCardCell:containerView tilte:NSLocalizedString(@"收款人：", nil) content:self.payModeModel.payeeName tag:8002];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(bankNameAreaView.mas_bottom);
            make.left.equalTo(containerView.mas_left);
            make.right.equalTo(containerView.mas_right);
            make.height.equalTo(@(textContainerHeight));
        }];
        
        view;
    });
    
    // 开户银行
    UIView *bankAddressAreaView = ({
        UIView *view = [self createMainUIViewOfBankCardCell:containerView tilte:NSLocalizedString(@"收款开户行：", nil) content:self.payModeModel.bankAddress tag:8003];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(bankUserNameAreaView.mas_bottom);
            make.left.equalTo(containerView.mas_left);
            make.right.equalTo(containerView.mas_right);
            make.height.equalTo(@(textContainerHeight));
        }];
        
        view;
    });
    
    // 银行账号
    UIView *bankAccountreaView = ({
        UIView *view = [self createMainUIViewOfBankCardCell:containerView tilte:NSLocalizedString(@"收款账号：", nil) content:self.payModeModel.bankNum tag:8004];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(bankAddressAreaView.mas_bottom);
            make.left.equalTo(containerView.mas_left);
            make.right.equalTo(containerView.mas_right);
            make.height.equalTo(@(textContainerHeight));
        }];
        
        view;
    });
    
    return bankAccountreaView;
}

- (UIView *)createMainUIViewOfOtherPayMode:(UIView *)containerView
{
    CGFloat margin = CFC_AUTOSIZING_MARGIN(MARGIN);
    
    UIImageView *thirdPayImageView = ({
        UIImageView *imageView = [[UIImageView alloc] init];
        [containerView addSubview:imageView];
        [imageView setContentMode:UIViewContentModeScaleAspectFit];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(containerView.mas_centerX);
            make.top.equalTo(containerView.mas_top).offset(margin*5.0f);
            make.width.equalTo(containerView.mas_width).multipliedBy(0.88f);
            make.height.equalTo(containerView.mas_width).multipliedBy(1.2f);
        }];
        
        imageView;
    });
    self.thirdPayImageView = thirdPayImageView;
    self.thirdPayImageView.mas_key = @"thirdPayImageView";
    
    if ([CFCSysUtil validateStringUrl:self.payModeModel.bankNum]) {
        __block UIActivityIndicatorView *activityIndicator = nil;
        UIImage *placeholderImage = [UIImage imageNamed:ICON_COMMON_PLACEHOLDER];
        [self.thirdPayImageView sd_setImageWithURL:[NSURL URLWithString:self.payModeModel.bankNum] placeholderImage:placeholderImage options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                if (!activityIndicator) {
                    [self.thirdPayImageView addSubview:activityIndicator = [UIActivityIndicatorView.alloc initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite]];
                    [activityIndicator setColor:COLOR_ACTIVITY_INDICATOR_BACKGROUND];
                    [activityIndicator startAnimating];
                    [activityIndicator mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.centerX.equalTo(containerView.mas_right);
                        make.centerY.equalTo(containerView.mas_centerY);
                    }];
                }
            }];
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            [activityIndicator removeFromSuperview];
            activityIndicator = nil;
        }];
    } else {
        UILabel *tipInfoLabel = ({
            UILabel *label = [UILabel new];
            [containerView addSubview:label];
            [label setText:NSLocalizedString(@"提示：充值信息返回错误，请返回重试", nil)];
            [label setTextAlignment:NSTextAlignmentCenter];
            [label setTextColor:COLOR_SYSTEM_MAIN_UI_THEME_DEFAULT];
            [label setFont:[UIFont systemFontOfSize:CFC_AUTOSIZING_FONT(13)]];

            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(containerView.mas_centerX);
                make.top.equalTo(thirdPayImageView.mas_bottom).offset(margin*2.0f);
            }];

            label;
        });
        tipInfoLabel.mas_key = @"tipInfoLabel";
        [thirdPayImageView setImage:[UIImage imageNamed:ICON_COMMON_PLACEHOLDER]];
        return tipInfoLabel;
    }
    
    return thirdPayImageView;
}

- (UIView *)createMainUIViewOfBankCardCell:(UIView *)containerView tilte:(NSString *)title content:(NSString *)content tag:(NSInteger)tag
{
    CGFloat margin = CFC_AUTOSIZING_MARGIN(MARGIN);
    //
    CGFloat textFieldHeight = CFC_AUTOSIZING_WIDTH(40.0f);
    //
    UIFont *textTitleFont = [UIFont systemFontOfSize:CFC_AUTOSIZING_FONT(14.0f)];
    UIColor *textTitleColor = COLOR_SYSTEM_MAIN_FONT_DEFAULT;
    //
    UIFont *textFieldFont = [UIFont boldSystemFontOfSize:CFC_AUTOSIZING_FONT(15.0f)];
    UIColor *textFieldColor = COLOR_SYSTEM_MAIN_FONT_DEFAULT;
    CGFloat titleLableWidth = [NSLocalizedString(@"四字的标题：", nil) widthWithFont:textTitleFont constrainedToHeight:textFieldHeight];

    // 银行名称
    UIView *areaView = ({
        // 容器
        UIView *view = [UIView new];
        [containerView addSubview:view];
        [view setBackgroundColor:[UIColor whiteColor]];
        
        // 标题
        UILabel *label = [UILabel new];
        [view addSubview:label];
        [label setText:title];
        [label setFont:textTitleFont];
        [label setTextColor:textTitleColor];
        [label setTextAlignment:NSTextAlignmentRight];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(view.mas_centerY).offset(0.0);
            make.left.equalTo(view.mas_left).offset(margin*1.5);
            make.size.mas_equalTo(CGSizeMake(titleLableWidth, textFieldHeight));
        }];
        
        // 复制
        UILabel *copyLabel = [UILabel new];
        [containerView addSubview:copyLabel];
        [copyLabel setTag:tag];
        [copyLabel setText:NSLocalizedString(@"复制", nil)];
        [copyLabel setHidden:0==tag];
        [copyLabel setFont:textTitleFont];
        [copyLabel setUserInteractionEnabled:YES];
        [copyLabel setTextAlignment:NSTextAlignmentCenter];
        [copyLabel setBackgroundColor:[UIColor whiteColor]];
        [copyLabel setTextColor:COLOR_SYSTEM_MAIN_UI_THEME_DEFAULT];
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pressItemCopyButtonView:)];
        [copyLabel addGestureRecognizer:tapGesture];
        [copyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(view.mas_centerY);
            make.right.equalTo(view.mas_right).offset(-margin*1.5f);
            make.size.mas_equalTo(CGSizeMake(35, textFieldHeight));
        }];
        
        // 输入框
        {
            UIView *textContainer = [[UIView alloc] init];
            [view addSubview:textContainer];
            [textContainer addBorderWithColor:[UIColor lightGrayColor] cornerRadius:5.0f andWidth:1.0f];
            [textContainer mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(view.mas_centerY);
                make.left.equalTo(label.mas_right);
                make.right.equalTo(copyLabel.mas_left).with.offset(-margin*0.5f);
                make.height.equalTo(@(textFieldHeight));
            }];
            
            NSString *text = VALIDATE_STRING_EMPTY(content) ? @"" : content;
            UILabel *textField = [UILabel new];
            [textContainer addSubview:textField];
            [textField setText:text];
            [textField setNumberOfLines:0];
            [textField setFont:textFieldFont];
            [textField setTextColor:textFieldColor];
            [textField setTextAlignment:NSTextAlignmentLeft];
            [textField mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(textContainer.mas_left).offset(margin*0.5f);
                make.top.right.bottom.equalTo(textContainer);
            }];
        }
        
        // 底部横线
        UIView *separatorLineView = [[UIView alloc] init];
        [view addSubview:separatorLineView];
        [separatorLineView setBackgroundColor:COLOR_TABLEVIEW_SEPARATOR_LINE_DEFAULT];
        [separatorLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(view.mas_bottom).offset(-SEPARATOR_LINE_HEIGHT);
            make.left.equalTo(view.mas_left).offset(0.0);
            make.right.equalTo(view.mas_right).offset(0.0);
            make.height.mas_equalTo(SEPARATOR_LINE_HEIGHT);
        }];
        
        view;
    });
    
    return areaView;
}



#pragma mark - Navigation

- (NSString *)prefersNavigationBarTitleViewTitle
{
    if (STR_RECHARGE_CHANNELPAY_MODE_KEY_WECHAT == self.payModeModel.type.value.integerValue) {
        return NSLocalizedString(@"微信支付", nil);
    } else if (STR_RECHARGE_CHANNELPAY_MODE_KEY_ALIPAY == self.payModeModel.type.value.integerValue) {
       return NSLocalizedString(@"支付宝支付", nil);
    } else if (STR_RECHARGE_CHANNELPAY_MODE_KEY_BANKCARD == self.payModeModel.type.value.integerValue) {
        return NSLocalizedString(@"银行卡支付", nil);
    } else if (STR_RECHARGE_CHANNELPAY_MODE_KEY_QQPAY == self.payModeModel.type.value.integerValue) {
        return NSLocalizedString(@"QQ支付", nil);
    } else if (STR_RECHARGE_CHANNELPAY_MODE_KEY_JDPAY == self.payModeModel.type.value.integerValue) {
        return NSLocalizedString(@"京东支付", nil);
    } else {
        return NSLocalizedString(@"官方支付", nil);
    }
}


#pragma mark - Private

- (void)doAfterSubmitRechargeOrderSuccessThen
{
    WEAKSELF(weakSelf)
    
    AlertViewCus *alertView = [AlertViewCus createInstanceWithView:self.view];
    [alertView showWithText:NSLocalizedString(@"信息已提交，记得赶紧完成存款哦", nil) button1:NSLocalizedString(@"继续存款", nil) button2:NSLocalizedString(@"返回主页", nil) callBack:^(id object) {
        NSInteger tag = [object integerValue];
        NSArray *arr = weakSelf.navigationController.viewControllers;
        if(tag == 1) { // 返回主页
            if(arr.count >= 5) {
                [weakSelf.navigationController popToViewController:arr[arr.count - 5] animated:YES];
            } else {
                [weakSelf.navigationController popToRootViewControllerAnimated:YES];
            }
        } else { // 继续存款
            if(arr.count >= 4) {
                [weakSelf.navigationController popToViewController:arr[arr.count - 4] animated:YES];
            } else {
                [weakSelf.navigationController popToRootViewControllerAnimated:YES];
            }
        }
    }];
}

- (void)doRequestGamesOfficialRechargeOrderThen:(void (^)(BOOL success))then
{
    PROGRESS_HUD_SHOW
    [NET_REQUEST_MANAGER requestUserOfficialRechargeOrderWithPayModeId:self.payModeModel.uuid money:self.money remark:self.userRealName success:^(id response) {
        PROGRESS_HUD_DISMISS
        FYLog(NSLocalizedString(@"提交官方充值订单 => \n%@", nil), response);
        if (!NET_REQUEST_SUCCESS(response)) {
           ALTER_HTTP_MESSAGE(response)
            !then ?: then(NO);
        } else {
            !then ?: then(YES);
        }
    } failure:^(id error) {
        PROGRESS_HUD_DISMISS
        ALTER_HTTP_ERROR_MESSAGE(error)
        FYLog(NSLocalizedString(@"提交官方充值订单出错 => \n%@", nil), error);
        !then ?: then(NO);
    }];
}


@end

