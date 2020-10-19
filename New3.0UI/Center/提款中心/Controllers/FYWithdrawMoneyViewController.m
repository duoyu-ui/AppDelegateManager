//
//  FYWithdrawMoneyViewController.m
//  ProjectCSHB
//
//  Created by fangyuan on 2020/6/4.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "FYWithdrawMoneyViewController.h"
#import "TPKeyboardAvoidingScrollView.h"
#import "FYMyWithdrawModel.h"
#import "FYMyBankCardModel.h"
//
#import "FYBindBankcardViewController.h"
#import "FYBankcardSelectViewController.h"
#import "FYAddBankcardViewController.h"
#import "FYBillingRecordViewController.h"


@interface FYWithdrawMoneyViewController () <UITextFieldDelegate>
//
@property (nonatomic, strong) FYMyWithdrawModel *myWithdrawModel;
@property (nonatomic, strong) FYMyBankCardModel *currentBankCardModel;
//
@property (nonatomic, strong) UILabel *bankTitleLabel;
@property (nonatomic, strong) UILabel *bankNumberLabel;
@property (nonatomic, strong) UILabel *bankBalanceLabel;
@property (nonatomic, strong) UIImageView *bankImageView;
@property (nonatomic, strong) UIButton *allWithdrawButton;
//
@property (nonatomic, strong) UILabel *tipInfoLabel;
@property (nonatomic, strong) UITextField *moneyTextField;
@property (nonatomic, strong) UIButton *confirmButton;

@end


@implementation FYWithdrawMoneyViewController

#pragma mark - Actions

/// 提现记录
- (void)pressNavigationBarRightButtonItem:(id)sender
{
    [self resignFirstResponderOfTextField];
    
    FYBillingRecordViewController *VC = [[FYBillingRecordViewController alloc] init];
    [VC setSelectClassId:@"withdraw"];
    [self.navigationController pushViewController:VC animated:YES];
}

/// 全部提现
- (void)pressAllWithdrawButtonAction:(UIButton *)button
{
    [self.moneyTextField setText:APPINFORMATION.userInfo.balance];
    [self doChangeTipInfoByTextFieldMoney:APPINFORMATION.userInfo.balance];
}

/// 提现操作
- (void)pressConfirmButtonAction:(UIButton *)button
{
    [self resignFirstResponderOfTextField];
    
    if ([APPINFORMATION isGuest]) {
        return;
    }
    
    NSString *money = STR_TRI_WHITE_SPACE(self.moneyTextField.text);
    if (VALIDATE_STRING_EMPTY(money)) {
        ALTER_INFO_MESSAGE(NSLocalizedString(@"提现金额不能为空！", nil))
        return;
    }

    if (self.myWithdrawModel.brokerageMinMoney.floatValue > 0
        && money.floatValue < self.myWithdrawModel.brokerageMinMoney.floatValue) {
        NSString *message = [NSString stringWithFormat:NSLocalizedString(@"提现金额不能小于%.2f元！", nil), self.myWithdrawModel.brokerageMinMoney.floatValue];
        ALTER_INFO_MESSAGE(message)
        return;
    }
    
    if (self.myWithdrawModel.brokerageMaxMoney.floatValue > 0
        && money.floatValue > self.myWithdrawModel.brokerageMaxMoney.floatValue) {
        NSString *message = [NSString stringWithFormat:NSLocalizedString(@"提现金额不能大于%.2f元！", nil), self.myWithdrawModel.brokerageMaxMoney.floatValue];
        ALTER_INFO_MESSAGE(message)
        return;
    }
    
    if (APPINFORMATION.userInfo.balance.floatValue < money.floatValue) {
        ALTER_INFO_MESSAGE(NSLocalizedString(@"账户余额不足", nil))
        return;
    }
    
    if (!self.currentBankCardModel) {
        ALTER_INFO_MESSAGE(NSLocalizedString(@"请选择银行卡", nil))
    }
    
    // 提现
    [self doWhitdrawWithMoney:money then:^(BOOL success) {
        if (success) {
            ALTER_INFO_MESSAGE(NSLocalizedString(@"提现成功", nil))
        }
    }];
}

/// 点击事件
- (void)pressTouchActionOfContainerView:(UITapGestureRecognizer *)gesture
{
    [self resignFirstResponderOfTextField];
}

/// 选银行卡
- (void)pressTouchActionOfSelectBankCard:(UITapGestureRecognizer *)gesture
{
    [self resignFirstResponderOfTextField];
    
#if 1
    if (!self.currentBankCardModel) {
        FYAddBankcardViewController *VC = [[FYAddBankcardViewController alloc] init];
        [VC setFinishAddBankItemModelBlock:^FYAddBankCardResType(FYBankItemModel * _Nullable bankCardModel) {
            [APPINFORMATION.userInfo setIsTiedCard:YES];
            return FYAddBankCardResMyCenterToWithdraw; // 个人中心 -> 添加银行卡 -> 提现页面
        }];
        [self.navigationController pushViewController:VC removeViewController:self];
    } else {
        WEAKSELF(weakSelf)
        FYBankcardSelectViewController *VC = [[FYBankcardSelectViewController alloc] initWithBankCardModel:self.currentBankCardModel];
        [VC setSelectedMyBankCardBlock:^(FYMyBankCardModel * __nullable bankCardModel, BOOL isNeedRequest) {
            [weakSelf setCurrentBankCardModel:bankCardModel];
            [weakSelf updateMainUIWithMyWithdrawModel:weakSelf.myWithdrawModel myBankCardModels:bankCardModel];
            if (isNeedRequest) {
                [weakSelf loadRequestDataBank:NO then:^(FYMyWithdrawModel *myWithdrawModel, FYMyBankCardModel *currentBankCardModel) {
                    [weakSelf updateMainUIWithMyWithdrawModel:myWithdrawModel myBankCardModels:currentBankCardModel];
                }];
            }
        }];
        [self.navigationController pushViewController:VC animated:YES];
    }
#else
    if (!self.currentBankCardModel) {
        FYAddBankcardViewController *VC = [[FYAddBankcardViewController alloc] init];
        [VC setFinishAddBankItemModelBlock:^FYAddBankCardResType(FYBankItemModel * _Nullable bankCardModel) {
            [APPINFORMATION.userInfo setIsTiedCard:YES];
            return FYAddBankCardResMyCenterToWithdraw; // 个人中心 -> 添加银行卡 -> 提现页面
        }];
        [self.navigationController pushViewController:VC removeViewController:self];
    } else {
        WEAKSELF(weakSelf)
        FYBindBankcardViewController *VC = [[FYBindBankcardViewController alloc] initWithBankCardModel:self.currentBankCardModel];
        [VC setSelectedMyBankCardBlock:^(FYMyBankCardModel * __nullable bankCardModel, BOOL isNeedRequest) {
            [weakSelf setCurrentBankCardModel:bankCardModel];
            [weakSelf updateMainUIWithMyWithdrawModel:weakSelf.myWithdrawModel myBankCardModels:bankCardModel];
            if (isNeedRequest) {
                [weakSelf loadRequestDataBank:NO then:^(FYMyWithdrawModel *myWithdrawModel, FYMyBankCardModel *currentBankCardModel) {
                    [weakSelf updateMainUIWithMyWithdrawModel:myWithdrawModel myBankCardModels:currentBankCardModel];
                }];
            }
        }];
        [self.navigationController pushViewController:VC animated:YES];
    }
#endif
}


#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view setBackgroundColor:COLOR_TABLEVIEW_BACK_VIEW_BACKGROUND_DEFAULT];
    
    [self createMainUIView];
    
    [self loadRequestDataBank:YES then:^(FYMyWithdrawModel *myWithdrawModel, FYMyBankCardModel *currentBankCardModel) {
        [self updateMainUIWithMyWithdrawModel:myWithdrawModel myBankCardModels:currentBankCardModel];
    }];
    
    // 添加监听通知
    [self addNotifications];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // 隐藏导航栏底线
    [self.navigationBarHairlineImageView setHidden:YES];
}

- (void)createMainUIView
{
    CGFloat margin = CFC_AUTOSIZING_MARGIN(MARGIN);
    NSAttributedString *tipInfoString = [self tipInfoAttributedString:COLOR_HEXSTRING(@"#C7A876")];

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
            if (IS_IPHONE_X) {
                make.height.mas_greaterThanOrEqualTo(SCREEN_HEIGHT-STATUS_NAVIGATION_BAR_HEIGHT-TAB_BAR_DANGER_HEIGHT+1.0);
            } else {
                make.height.mas_greaterThanOrEqualTo(SCREEN_HEIGHT-STATUS_NAVIGATION_BAR_HEIGHT+1.0);
            }
        }];
        view;
    });
    containerView.mas_key = @"containerView";
    
    UIView *bankCardContainer = ({
        CGFloat bankCardContainerHeight = CFC_AUTOSIZING_WIDTH(100.0f);
        CGFloat bankViewHieght = bankCardContainerHeight * 0.65;
        CGFloat imageSize = bankViewHieght * 0.6f;
        
        // 容器
        UIView *view = [UIView new];
        [containerView addSubview:view];
        [view setBackgroundColor:[UIColor whiteColor]];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(containerView.mas_top).offset(SEPARTOR_MARGIN_HEIGHT);
            make.left.equalTo(containerView.mas_left);
            make.right.equalTo(containerView.mas_right);
            make.height.equalTo(@(bankCardContainerHeight));
        }];
        
        // 容器(卡)
        UIView *bankView = [UIView new];
        [view addSubview:bankView];
        [bankView setBackgroundColor:[UIColor whiteColor]];
        [bankView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(view);
            make.height.equalTo(@(bankViewHieght));
        }];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pressTouchActionOfSelectBankCard:)];
        [bankView addGestureRecognizer:tapGesture];
        
        // 图标
        UIImageView *bankImageView = ({
            UIImageView *imageView = [[UIImageView alloc] init];
            [bankView addSubview:imageView];
            [imageView addCornerRadius:imageSize*0.5f];
            [imageView setImage:[UIImage imageNamed:ICON_COMMON_PLACEHOLDER]];
            [imageView setContentMode:UIViewContentModeScaleAspectFit];
            [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(bankView.mas_centerY);
                make.left.equalTo(view.mas_left).offset(margin*1.0f);
                make.size.mas_equalTo(CGSizeMake(imageSize, imageSize));
            }];
            
            imageView;
        });
        self.bankImageView = bankImageView;
        self.bankImageView.mas_key = @"bankImageView";
        
        // 箭头
        UIImageView *arrowImageView = ({
            CGSize imageSize = CGSizeMake(CFC_AUTOSIZING_WIDTH(25.0f), CFC_AUTOSIZING_WIDTH(25.0f));
            UIImageView *imageView = [[UIImageView alloc] init];
            [bankView addSubview:imageView];
            [imageView.layer setMasksToBounds:YES];
            [imageView setContentMode:UIViewContentModeScaleAspectFit];
            [imageView setImage:[[UIImage imageNamed:ICON_TABLEVIEW_CELL_ARROW] imageByScalingProportionallyToSize:imageSize]];
            [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(bankImageView.mas_centerY);
                make.right.equalTo(bankView.mas_right).offset(-margin*1.0f);
                make.size.mas_equalTo(imageSize);
            }];
            
            imageView;
        });
        arrowImageView.mas_key = @"arrowImageView";
        
        // 银行名称
        UILabel *bankTitleLabel = ({
            UILabel *label = [UILabel new];
            [bankView addSubview:label];
            [label setFont:FONT_PINGFANG_SEMI_BOLD(16)];
            [label setTextColor:COLOR_SYSTEM_MAIN_FONT_DEFAULT];
            [label setTextAlignment:NSTextAlignmentLeft];
            
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(bankImageView.mas_centerY);
                make.left.equalTo(bankImageView.mas_right).offset(margin*1.0f);
                make.right.equalTo(arrowImageView.mas_left).offset(-margin*0.5f);
            }];
            
            label;
        });
        self.bankTitleLabel = bankTitleLabel;
        self.bankTitleLabel.mas_key = @"bankTitleLabel";
        
        // 银行卡号
        UILabel *bankNumberLabel = ({
            UILabel *label = [UILabel new];
            [bankView addSubview:label];
            [label setFont:FONT_PINGFANG_LIGHT(15)];
            [label setTextColor:COLOR_SYSTEM_MAIN_FONT_ASSIST_DEFAULT];
            [label setTextAlignment:NSTextAlignmentLeft];

            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(bankTitleLabel.mas_bottom).offset(margin*0.5f);
                make.left.equalTo(bankTitleLabel.mas_left);
                make.right.equalTo(bankTitleLabel.mas_right);
            }];
            
            label;
        });
        self.bankNumberLabel = bankNumberLabel;
        self.bankNumberLabel.mas_key = @"bankNumberLabel";
        
        // 全部提现
        UIButton *allWithdrawButton = ({
            UIFont *titleFont = FONT_PINGFANG_REGULAR(14);
            CGFloat width = [NSLocalizedString(@"全部提现", nil) widthWithFont:titleFont constrainedToHeight:CGFLOAT_MAX]+margin*2.0f;
            CGFloat height = width * 0.33f;
            //
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [view addSubview:button];
            [button.titleLabel setFont:titleFont];
            [button setTitle:NSLocalizedString(@"全部提现", nil) forState:UIControlStateNormal];
            [button setTitleColor:COLOR_HEXSTRING(@"#1296DB") forState:UIControlStateNormal];
            [button addTarget:self action:@selector(pressAllWithdrawButtonAction:) forControlEvents:UIControlEventTouchUpInside];
            //
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(view.mas_right).offset(-margin*0.5f);
                make.size.mas_equalTo(CGSizeMake(width, height));
            }];
            
            button;
        });
        self.allWithdrawButton = allWithdrawButton;
        self.allWithdrawButton.mas_key = @"allWithdrawButton";
        
        // 余额
        UILabel *bankBalanceLabel = ({
            UILabel *label = [UILabel new];
            [view addSubview:label];
            [label setText:NSLocalizedString(@"可提余额：0.00元", nil)];
            [label setFont:FONT_PINGFANG_SEMI_BOLD(15)];
            [label setTextColor:COLOR_SYSTEM_MAIN_FONT_DEFAULT];
            [label setTextAlignment:NSTextAlignmentLeft];
            
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(bankView.mas_bottom);
                make.bottom.equalTo(view.mas_bottom);
                make.left.equalTo(view.mas_left).offset(margin*1.0f);
                make.right.equalTo(allWithdrawButton.mas_left).offset(-margin*0.5f);
            }];
            
            label;
        });
        self.bankBalanceLabel = bankBalanceLabel;
        self.bankBalanceLabel.mas_key = @"bankBalanceLabel";
        
        // 全部提现
        [allWithdrawButton mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(bankBalanceLabel.mas_centerY);
        }];
        
        view;
    });
    bankCardContainer.mas_key = @"bankCardContainer";
    
    UIView *widthdrawMoneyContainer = ({
        CGFloat textFieldHeight = CFC_AUTOSIZING_WIDTH(60.0f);
        CGFloat widthdrawContainerHeight = CFC_AUTOSIZING_WIDTH(140.0f);
        
        UIFont *textTitleFont = FONT_PINGFANG_SEMI_BOLD(17);
        UIColor *textTitleColor = COLOR_SYSTEM_MAIN_FONT_DEFAULT;
        //
        UIFont *textFieldFont = FONT_PINGFANG_SEMI_BOLD(25);
        UIColor *textFieldColor = COLOR_SYSTEM_MAIN_FONT_DEFAULT;
        UIColor *textFieldPlaceholderColor = [UIColor colorWithRed:0.68 green:0.68 blue:0.68 alpha:1.00];
        //
        UIFont *textContentFont = FONT_PINGFANG_LIGHT(14);
        UIColor *textContentColor = COLOR_SYSTEM_MAIN_FONT_ASSIST_DEFAULT;
        
        // 容器
        UIView *view = [UIView new];
        [containerView addSubview:view];
        [view setBackgroundColor:[UIColor whiteColor]];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(bankCardContainer.mas_bottom).offset(SEPARTOR_MARGIN_HEIGHT);
            make.left.equalTo(containerView.mas_left);
            make.right.equalTo(containerView.mas_right);
            make.height.equalTo(@(widthdrawContainerHeight));
        }];
        
        // 标题
        UILabel *titleLabel = [UILabel new];
        [view addSubview:titleLabel];
        [titleLabel setFont:textTitleFont];
        [titleLabel setTextColor:textTitleColor];
        [titleLabel setText:NSLocalizedString(@"提现金额", nil)];
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
        [moneyLabel setFont:FONT_PINGFANG_SEMI_BOLD(23)];
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
    widthdrawMoneyContainer.mas_key = @"headerAreaView";
    
    // 确认按钮
    UIButton *confirmButton = ({
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button defaultStyleButton];
        [containerView addSubview:button];
        [button.layer setBorderWidth:0.0f];
        [button setTitle:NSLocalizedString(@"提交", nil) forState:UIControlStateNormal];
        [button addTarget:self action:@selector(pressConfirmButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(widthdrawMoneyContainer.mas_bottom).offset(margin*5.0f);
            make.left.equalTo(containerView.mas_left).offset(margin*2.0f);
            make.right.equalTo(containerView.mas_right).with.offset(-margin*2.0f);
            make.height.equalTo(@(CFC_AUTOSIZING_WIDTH(SYSTEM_GLOBAL_BUTTON_HEIGHT)));
        }];
        
        button;
    });
    self.confirmButton = confirmButton;
    self.confirmButton.mas_key = @"confirmButton";

    [containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.greaterThanOrEqualTo(confirmButton.mas_bottom).offset(margin*5.0f).priority(749);
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
    
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    [self doChangeTipInfoByTextFieldMoney:@""];
    
    return YES;
}


#pragma mark - Network

- (void)loadRequestDataBank:(BOOL)isShowHUD then:(void (^)(FYMyWithdrawModel *myWithdrawModel, FYMyBankCardModel *currentBankCardModel))then
{
    WEAKSELF(weakSelf)
    if (isShowHUD) {
        PROGRESS_HUD_SHOW
    }
    [NET_REQUEST_MANAGER getMyBankCardListWithSuccess:^(id response) {
        if (isShowHUD) {
            PROGRESS_HUD_DISMISS
        }
        FYLog(NSLocalizedString(@"银行卡数据 => \n%@", nil), response);
        if (!NET_REQUEST_SUCCESS(response)) {
           !then ?: then(nil,nil);
        } else {
            NSDictionary *data = NET_REQUEST_DATA(response);
            //
            NSDictionary *cashInfo = [data dictionaryForKey:@"cashInfo"];
            FYMyWithdrawModel *myWithdrawModel = [FYMyWithdrawModel mj_objectWithKeyValues:cashInfo];
            [weakSelf setMyWithdrawModel:myWithdrawModel];
            //
            __block NSMutableArray<FYMyBankCardModel *> *bankCardModels = [NSMutableArray<FYMyBankCardModel *> array];
            [[data arrayForKey:@"paymentList"] enumerateObjectsUsingBlock:^(NSDictionary *dict, NSUInteger idx, BOOL * _Nonnull stop) {
                FYMyBankCardModel *model = [FYMyBankCardModel mj_objectWithKeyValues:dict];
                [bankCardModels addObj:model];
            }];
            // 当前选中银行卡是否为空
            if (!weakSelf.currentBankCardModel) {
                [weakSelf setCurrentBankCardModel:bankCardModels.lastObject];
            }
            //
            !then ?: then(weakSelf.myWithdrawModel, weakSelf.currentBankCardModel);
        }
    } fail:^(id error) {
        if (isShowHUD) {
            PROGRESS_HUD_DISMISS
        }
        ALTER_HTTP_ERROR_MESSAGE(error)
        FYLog(NSLocalizedString(@"银行卡数据 => \n%@", nil), error);
        !then ?: then(nil,nil);
    }];
}

- (void)doWhitdrawWithMoney:(NSString *)money then:(void (^)(BOOL success))then
{
    NSString *userPaymentId = self.currentBankCardModel.uuid.stringValue;
    NSString *uppPayName = self.currentBankCardModel.user;
    NSString *uppayBank = self.currentBankCardModel.bankName;
    NSString *uppayAddress = self.currentBankCardModel.bankRegion;
    NSString *uppayNo = self.currentBankCardModel.upayNo.stringValue;
    [NET_REQUEST_MANAGER getWithdrawWhitAmount:money userPaymentId:userPaymentId uppPayName:uppPayName uppayBank:uppayBank uppayAddress:uppayAddress uppayNo:uppayNo success:^(id response) {
        FYLog(NSLocalizedString(@"提现成功 => \n%@", nil), response);
        if (!NET_REQUEST_SUCCESS(response)) {
            ALTER_HTTP_MESSAGE(response)
            !then ?: then(NO);
        } else {
            !then ?: then(YES);
        }
    } fail:^(id error) {
        PROGRESS_HUD_DISMISS
        ALTER_HTTP_ERROR_MESSAGE(error)
        FYLog(NSLocalizedString(@"提现出错 => \n%@", nil), error);
        !then ?: then(NO);
    }];
}


#pragma mark - Navigation

- (NSString *)prefersNavigationBarTitleViewTitle
{
    return STR_NAVIGATION_BAR_TITLE_WITHDRAW_CENTER;
}

- (CGFloat)prefersNavigationBarHairlineHeight
{
    return NAVIGATION_BAR_HAIR_LINE_HEIGHT_ZERO;
}

- (CFCNavBarButtonItemType)prefersNavigationBarRightButtonItemType
{
    return CFCNavBarButtonItemTypeCustom;
}

- (NSString *)prefersNavigationBarRightButtonItemTitle
{
    return STR_NAV_BUTTON_TITLE_WITHDRAW_RECORD;
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
        [weakSelf.bankBalanceLabel setText:[NSString stringWithFormat:NSLocalizedString(@"可提现余额：%@元", nil), formatBalacne]];
    }));
}

/// 释放资源
- (void)dealloc
{
    [NOTIF_CENTER removeObserver:self];
}


#pragma mark - Private

- (void)updateMainUIWithMyWithdrawModel:(FYMyWithdrawModel *)myWithdrawModel myBankCardModels:(FYMyBankCardModel *)myBankCardModel
{
    if (myBankCardModel) {
        [self.bankTitleLabel setText:myBankCardModel.bankName];
        [self.bankNumberLabel setText:myBankCardModel.upayNoHideStr];
        [self.bankImageView setImage:myBankCardModel.bankCardImage];
    } else {
        [self.bankTitleLabel setText:@""];
        [self.bankNumberLabel setText:@""];
        [self.bankImageView setImage:[UIImage imageNamed:ICON_COMMON_PLACEHOLDER]];
    }
    
    [self.bankBalanceLabel setText:[NSString stringWithFormat:NSLocalizedString(@"可提现余额：%@元", nil), APPINFORMATION.userInfo.balance]];
    [self.tipInfoLabel setAttributedText:[self tipInfoAttributedString:COLOR_HEXSTRING(@"#C7A876")]];
    //
    NSString *textPlaceholder = [NSString stringWithFormat:NSLocalizedString(@"最低提现金额为%.2f元", nil), myWithdrawModel.brokerageMinMoney.floatValue];
    UIColor *textFieldPlaceholderColor = [UIColor colorWithRed:0.68 green:0.68 blue:0.68 alpha:1.00];
    [self.moneyTextField setAttributedPlaceholder:[[NSAttributedString alloc] initWithString:textPlaceholder attributes:@{ NSForegroundColorAttributeName : textFieldPlaceholderColor }]];
}

- (void)doChangeTipInfoByTextFieldMoney:(NSString *)money
{
    if (VALIDATE_STRING_EMPTY(money)) {
        NSAttributedString *tipInfoAttributeString = [self tipInfoAttributedString:COLOR_HEXSTRING(@"#C7A876")];
        [self.tipInfoLabel setAttributedText:tipInfoAttributeString];
        return;
    }
    
    if (self.myWithdrawModel.brokerageMinMoney.floatValue > 0
        && money.floatValue < self.myWithdrawModel.brokerageMinMoney.floatValue) {
        NSString *message = [NSString stringWithFormat:NSLocalizedString(@"提现金额不能小于%.2f元", nil), self.myWithdrawModel.brokerageMinMoney.floatValue];
        [self.tipInfoLabel setText:message];
        [self.tipInfoLabel setTextColor:COLOR_SYSTEM_MAIN_UI_THEME_DEFAULT];
        return;
    }
    
    if (self.myWithdrawModel.brokerageMaxMoney.floatValue > 0
        && money.floatValue > self.myWithdrawModel.brokerageMaxMoney.floatValue) {
        NSString *message = [NSString stringWithFormat:NSLocalizedString(@"提现金额不能大于%.2f元", nil), self.myWithdrawModel.brokerageMaxMoney.floatValue];
        [self.tipInfoLabel setText:message];
        [self.tipInfoLabel setTextColor:COLOR_SYSTEM_MAIN_UI_THEME_DEFAULT];
        return;
    }
    
    NSAttributedString *tipInfoAttributeString = [self tipInfoAttributedString:COLOR_HEXSTRING(@"#C7A876")];
    [self.tipInfoLabel setAttributedText:tipInfoAttributeString];
}

- (NSAttributedString *)tipInfoAttributedString:(UIColor *)moneyColor
{
    UIFont *textFont = [UIFont systemFontOfSize:CFC_AUTOSIZING_FONT(14)];
    NSDictionary *attributesText = @{ NSFontAttributeName:textFont, NSForegroundColorAttributeName:COLOR_SYSTEM_MAIN_FONT_ASSIST_DEFAULT};
    NSDictionary *attributesMoney = @{ NSFontAttributeName:textFont, NSForegroundColorAttributeName:moneyColor};
    NSString *withdrawcout = NSLocalizedString(@"每天最多提现 5 次", nil);
    if (self.myWithdrawModel.dayCashNum.integerValue > 0) {
        withdrawcout = [NSString stringWithFormat:NSLocalizedString(@"每天最多提现 %ld 次", nil), self.myWithdrawModel.dayCashNum.integerValue];
    }
    if (self.myWithdrawModel.brokerageMaxMoney.floatValue > 0
        && self.myWithdrawModel.brokerageMaxMoney.floatValue >= self.myWithdrawModel.brokerageMinMoney.floatValue) {
        NSString *moeny = [NSString stringWithFormat:@" %.2f~%.2f ", self.myWithdrawModel.brokerageMinMoney.floatValue, self.myWithdrawModel.brokerageMaxMoney.floatValue];
        NSArray<NSString *> *stringArray = @[NSLocalizedString(@"单笔限额", nil), moeny, NSLocalizedString(@"元，", nil), withdrawcout];
        NSArray *attributeArray = @[attributesText, attributesMoney, attributesText, attributesText];
        return [CFCSysUtil attributedString:stringArray attributeArray:attributeArray];
    } else {
        NSArray<NSString *> *stringArray = @[withdrawcout];
        NSArray *attributeArray = @[attributesText];
        return [CFCSysUtil attributedString:stringArray attributeArray:attributeArray];
    }
    return nil;
}




@end

