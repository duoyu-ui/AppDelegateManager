//
//  FYAddBankcardViewController.m
//  ProjectCSHB
//
//  Created by fangyuan on 2020/6/9.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "FYAddBankcardViewController.h"
#import "FYBankSearchViewController.h"
#import "TPKeyboardAvoidingScrollView.h"
#import "FYBankItemModel.h"
//
#import "FYWithdrawMoneyViewController.h"

@interface FYAddBankcardViewController () <UITextFieldDelegate, FYBankSearchViewControllerDelegate>
//
@property (nonatomic, strong) FYBankItemModel *currentBankItemModel;
@property (nonatomic, strong) NSMutableArray<FYBankItemModel *> *bankListDataSource;
//
@property (nonatomic, strong) UIView *userNameTextFieldView;
@property (nonatomic, strong) UIView *bankCardNumberTextFieldView;
@property (nonatomic, strong) UIView *bankNameTextFieldView;
@property (nonatomic, strong) UIView *bankAddressTextFieldView;
@property (nonatomic, strong) UITextField *userNameTextField;
@property (nonatomic, strong) UITextField *bankCardNumberTextField;
@property (nonatomic, strong) UITextField *bankNameTextField;
@property (nonatomic, strong) UITextField *bankAddressTextField;
//
@property (nonatomic, strong) UIButton *confirmButton;

@end

@implementation FYAddBankcardViewController

#pragma mark - Actions

- (void)pressConfirmButtonAction:(UIButton *)button
{
    [self resignFirstResponderOfTextField];
    
    if ([APPINFORMATION isGuest]) {
        return;
    }
    
    NSString *userName = STR_TRI_WHITE_SPACE(self.userNameTextField.text);
    if (VALIDATE_STRING_EMPTY(userName)) {
        ALTER_INFO_MESSAGE(NSLocalizedString(@"持卡人姓名不能为空", nil))
        return;
    }

    NSString *bankCardNumber = STR_TRI_WHITE_SPACE(self.bankCardNumberTextField.text);
    if (VALIDATE_STRING_EMPTY(bankCardNumber)) {
        ALTER_INFO_MESSAGE(NSLocalizedString(@"银行卡号不能为空", nil))
        return;
    }

    NSString *bankName = STR_TRI_WHITE_SPACE(self.bankNameTextField.text);
    if (VALIDATE_STRING_EMPTY(bankName)) {
        ALTER_INFO_MESSAGE(NSLocalizedString(@"开户不能为空", nil))
        return;
    }
    
    NSString *bankAddress = STR_TRI_WHITE_SPACE(self.bankAddressTextField.text);
    if (VALIDATE_STRING_EMPTY(bankAddress)) {
        ALTER_INFO_MESSAGE(NSLocalizedString(@"开户行地址不能为空", nil))
        return;
    }

    NSString *bankId = STR_TRI_WHITE_SPACE(self.currentBankItemModel.uuid.stringValue);
    if (VALIDATE_STRING_EMPTY(bankId)) {
        ALTER_INFO_MESSAGE(NSLocalizedString(@"银行标识不能为空", nil))
        return;
    }
    
    NSString *bankCode = STR_TRI_WHITE_SPACE(self.currentBankItemModel.code);
    if (VALIDATE_STRING_EMPTY(bankCode)) {
        ALTER_INFO_MESSAGE(NSLocalizedString(@"银行代号不能为空", nil))
        return;
    }
    
    WEAKSELF(weakSelf)
    [self doAddBankcardWhitUserName:userName bankId:bankId cardNum:bankCardNumber bankCode:bankCode address:bankAddress then:^(BOOL success) {
        if (success) {
            APPINFORMATION.userInfo.isTiedCard = YES;
            [APPINFORMATION saveAppModel];
            //
            ALTER_INFO_MESSAGE(NSLocalizedString(@"添加银行卡成功", nil))
            FYAddBankCardResType resType = !weakSelf.finishAddBankItemModelBlock ?: weakSelf.finishAddBankItemModelBlock(weakSelf.currentBankItemModel);
            // 设置中心 -> 添加银行卡 -> 选择银行卡
            if (self.isFromPersonSetting) {
                [self.navigationController popViewControllerAnimated:YES];
            }
            // 选择银行卡 -> 添加银行卡 -> 选择银行卡
            else if (FYAddBankCardResSelectBankCardToBackSelf == resType) {
                [self.navigationController popViewControllerAnimated:YES];
            }
            // 解绑银行卡 -> 添加银行卡 -> 解绑银行卡
            else if (FYAddBankCardResUnBindBankCardToBackSelf == resType) {
                [self.navigationController popViewControllerAnimated:YES];
            }
            // 个人中心 -> 添加银行卡 -> 提现页面
            else if (FYAddBankCardResMyCenterToWithdraw == resType) {
                NSInteger index = self.navigationController.viewControllers.count-1;
                NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(index, 1)];
                FYWithdrawMoneyViewController *viewController = [[FYWithdrawMoneyViewController alloc] init];
                [self.navigationController pushViewController:viewController removeViewControllersAtIndexes:indexSet animated:YES];
            }
            // 选择银行卡 -> 添加银行卡 -> 提现页面
            else if (FYAddBankCardResSelectBankCardToWithdraw == resType) {
                NSInteger index = self.navigationController.viewControllers.count-2;
                NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(index, 2)];
                FYWithdrawMoneyViewController *viewController = [[FYWithdrawMoneyViewController alloc] init];
                [self.navigationController pushViewController:viewController removeViewControllersAtIndexes:indexSet animated:YES];
            }
            // 默认处理
            else {
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
    }];
}

- (void)pressTouchActionOfContainerView:(UITapGestureRecognizer *)gesture
{
    [self resignFirstResponderOfTextField];
}

- (void)pressTouchActionOfBankNameView:(UITapGestureRecognizer *)gesture
{
    [self resignFirstResponderOfTextField];

    FYBankSearchViewController *alterVC = [FYBankSearchViewController alertSearchController:self.bankListDataSource selected:self.currentBankItemModel delegate:self];
    [self presentViewController:alterVC animated:NO completion:^{

    }];
}


#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self createMainUIView];
    
    [self loadRequestBankDataListThen:^(NSMutableArray<FYBankItemModel *> *itemBankModels) {
        [self setBankListDataSource:itemBankModels];
    }];
}

- (void)createMainUIView
{
    CGFloat margin = CFC_AUTOSIZING_MARGIN(MARGIN);
    //
    CGFloat textFieldContainerHeight = CFC_AUTOSIZING_WIDTH(45.0f);
    UIColor *textFieldContainerHeightColor = COLOR_HEXSTRING(@"#FFFFFF");
    //
    UIFont *textTitleFont = [UIFont systemFontOfSize:CFC_AUTOSIZING_FONT(16.0f)];
    UIColor *textTitleColor = COLOR_SYSTEM_MAIN_FONT_DEFAULT;
    CGFloat textTitleWidth = [NSLocalizedString(@"标题占位符", nil) widthWithFont:textTitleFont constrainedToHeight:CGFLOAT_MAX];
    //
    UIFont *textFieldFont = [UIFont systemFontOfSize:CFC_AUTOSIZING_FONT(16.0f)];
    UIColor *textFieldColor = COLOR_SYSTEM_MAIN_FONT_DEFAULT;
    UIColor *textFieldPlaceholderColor = [UIColor colorWithRed:0.68 green:0.68 blue:0.68 alpha:1.00];
    

    UIScrollView *rootScrollView = ({
        TPKeyboardAvoidingScrollView *scrollView = [[TPKeyboardAvoidingScrollView alloc] initWithFrame:self.view.bounds];
        [scrollView setShowsVerticalScrollIndicator:NO];
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
    
    // 提示信息
    UILabel *tipInfoLabel = ({
        UILabel *tipInfoLabel = [UILabel new];
        [containerView addSubview:tipInfoLabel];
        [tipInfoLabel setText:NSLocalizedString(@"请绑定持卡人本人银行卡", nil)];
        [tipInfoLabel setFont:[UIFont boldSystemFontOfSize:CFC_AUTOSIZING_FONT(16.0f)]];
        [tipInfoLabel setTextColor:COLOR_SYSTEM_MAIN_FONT_DEFAULT];
        [tipInfoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(containerView.mas_top).offset(margin*4.0f);
            make.centerX.equalTo(containerView.mas_centerX);
        }];
        
        tipInfoLabel;
    });
    tipInfoLabel.mas_key = @"tipInfoLabel";
    
    // 持卡人真实姓名
    UIView *userNameTextFieldView = ({
        // 容器
        UIView *view = [UIView new];
        [containerView addSubview:view];
        [view setBackgroundColor:textFieldContainerHeightColor];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(tipInfoLabel.mas_bottom).offset(margin*3.0f);
            make.left.equalTo(containerView.mas_left);
            make.right.equalTo(containerView.mas_right);
            make.height.equalTo(@(textFieldContainerHeight));
        }];
        
        // 标题
        UILabel *titleLabel = [UILabel new];
        [view addSubview:titleLabel];
        [titleLabel setText:NSLocalizedString(@"持卡人", nil)];
        [titleLabel setFont:textTitleFont];
        [titleLabel setTextColor:textTitleColor];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(view.mas_centerY);
            make.left.equalTo(view.mas_left).offset(margin*1.5f);
            make.width.mas_equalTo(textTitleWidth);
        }];
        
        // 输入框
        UITextField *textField = [UITextField new];
        [view addSubview:textField];
        [textField setDelegate:self];
        [textField setFont:textFieldFont];
        [textField setTextColor:textFieldColor];
        [textField setBorderStyle:UITextBorderStyleNone];
        [textField setClearButtonMode:UITextFieldViewModeWhileEditing];
        [textField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
        [textField setAttributedPlaceholder:[[NSAttributedString alloc] initWithString:NSLocalizedString(@"持卡人真实姓名", nil) attributes:@{ NSForegroundColorAttributeName : textFieldPlaceholderColor }]];
        [textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(view.mas_top).offset(margin*0.5f);
            make.left.equalTo(titleLabel.mas_right).offset(margin);
            make.right.equalTo(view.mas_right).offset(-margin*1.5f);
            make.bottom.equalTo(view.mas_bottom).offset(-margin*0.5f);
        }];
        self.userNameTextField = textField;
        self.userNameTextField.mas_key = @"userNameTextField";
        
        view;
    });
    self.userNameTextFieldView = userNameTextFieldView;
    self.userNameTextFieldView.mas_key = @"userNameTextFieldView";

    // 银行卡号
    UIView *bankCardNumberTextFieldView = ({
        // 容器
        UIView *view = [UIView new];
        [containerView addSubview:view];
        [view setBackgroundColor:textFieldContainerHeightColor];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(userNameTextFieldView.mas_bottom).offset(margin*0.5f);
            make.left.equalTo(containerView.mas_left);
            make.right.equalTo(containerView.mas_right);
            make.height.equalTo(@(textFieldContainerHeight));
        }];
        
        // 标题
        UILabel *titleLabel = [UILabel new];
        [view addSubview:titleLabel];
        [titleLabel setText:NSLocalizedString(@"卡号", nil)];
        [titleLabel setFont:textTitleFont];
        [titleLabel setTextColor:textTitleColor];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(view.mas_centerY);
            make.left.equalTo(view.mas_left).offset(margin*1.5f);
            make.width.mas_equalTo(textTitleWidth);
        }];
        
        // 输入框
        UITextField *textField = [UITextField new];
        [view addSubview:textField];
        [textField setDelegate:self];
        [textField setFont:textFieldFont];
        [textField setTextColor:textFieldColor];
        [textField setBorderStyle:UITextBorderStyleNone];
        [textField setKeyboardType:UIKeyboardTypeNumberPad];
        [textField setClearButtonMode:UITextFieldViewModeWhileEditing];
        [textField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
        [textField setAttributedPlaceholder:[[NSAttributedString alloc] initWithString:NSLocalizedString(@"持卡人本人银行卡卡号", nil) attributes:@{ NSForegroundColorAttributeName : textFieldPlaceholderColor }]];
        [textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(view.mas_top).offset(margin*0.5f);
            make.left.equalTo(titleLabel.mas_right).offset(margin);
            make.right.equalTo(view.mas_right).offset(-margin*1.5f);
            make.bottom.equalTo(view.mas_bottom).offset(-margin*0.5f);
        }];
        self.bankCardNumberTextField = textField;
        self.bankCardNumberTextField.mas_key = @"passwordTextField";
        
        view;
    });
    self.bankCardNumberTextFieldView = bankCardNumberTextFieldView;
    self.bankCardNumberTextFieldView.mas_key = @"passwordTextFieldView";
    
    // 开户行
    UIView *bankNameTextFieldView = ({
        // 容器
        UIView *view = [UIView new];
        [containerView addSubview:view];
        [view setBackgroundColor:textFieldContainerHeightColor];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(bankCardNumberTextFieldView.mas_bottom).offset(margin*0.5f);
            make.left.equalTo(containerView.mas_left);
            make.right.equalTo(containerView.mas_right);
            make.height.equalTo(@(textFieldContainerHeight));
        }];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pressTouchActionOfBankNameView:)];
        [view addGestureRecognizer:tapGesture];
        
        // 标题
        UILabel *titleLabel = [UILabel new];
        [view addSubview:titleLabel];
        [titleLabel setText:NSLocalizedString(@"开户行", nil)];
        [titleLabel setFont:textTitleFont];
        [titleLabel setTextColor:textTitleColor];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(view.mas_centerY);
            make.left.equalTo(view.mas_left).offset(margin*1.5f);
            make.width.mas_equalTo(textTitleWidth);
        }];
        
        // 箭头
        CGSize imageSize = CGSizeMake(CFC_AUTOSIZING_WIDTH(25.0f), CFC_AUTOSIZING_WIDTH(25.0f));
        UIImageView *imageView = [[UIImageView alloc] init];
        [view addSubview:imageView];
        [imageView setUserInteractionEnabled:YES];
        [imageView setContentMode:UIViewContentModeScaleAspectFit];
        [imageView setImage:[[UIImage imageNamed:ICON_TABLEVIEW_CELL_ARROW] imageByScalingProportionallyToSize:imageSize]];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(view.mas_centerY);
            make.right.equalTo(view.mas_right).offset(-margin*1.5f);
            make.size.mas_equalTo(imageSize);
        }];
        
        // 输入框
        UITextField *textField = [UITextField new];
        [view addSubview:textField];
        [textField setEnabled:NO];
        [textField setDelegate:self];
        [textField setFont:textFieldFont];
        [textField setTextColor:textFieldColor];
        [textField setBorderStyle:UITextBorderStyleNone];
        [textField setClearButtonMode:UITextFieldViewModeWhileEditing];
        [textField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
        [textField setAttributedPlaceholder:[[NSAttributedString alloc] initWithString:NSLocalizedString(@"请选择开户行", nil) attributes:@{ NSForegroundColorAttributeName : textFieldPlaceholderColor }]];
        [textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(view.mas_top).offset(margin*0.5f);
            make.left.equalTo(titleLabel.mas_right).offset(margin);
            make.right.equalTo(imageView.mas_left).offset(-margin*0.5f);
            make.bottom.equalTo(view.mas_bottom).offset(-margin*0.5f);
        }];
        self.bankNameTextField = textField;
        self.bankNameTextField.mas_key = @"bankNameTextField";
        
        view;
    });
    self.bankNameTextFieldView = bankNameTextFieldView;
    self.bankNameTextFieldView.mas_key = @"bankNameTextFieldView";
    
    // 开户行地址
    UIView *bankAddressTextFieldView = ({
        // 容器
        UIView *view = [UIView new];
        [containerView addSubview:view];
        [view setBackgroundColor:textFieldContainerHeightColor];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(bankNameTextFieldView.mas_bottom).offset(margin*0.5f);
            make.left.equalTo(containerView.mas_left);
            make.right.equalTo(containerView.mas_right);
            make.height.equalTo(@(textFieldContainerHeight));
        }];
        
        // 标题
        UILabel *titleLabel = [UILabel new];
        [view addSubview:titleLabel];
        [titleLabel setText:NSLocalizedString(@"开户行地址", nil)];
        [titleLabel setFont:textTitleFont];
        [titleLabel setTextColor:textTitleColor];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(view.mas_centerY);
            make.left.equalTo(view.mas_left).offset(margin*1.5f);
            make.width.mas_equalTo(textTitleWidth);
        }];
        
        // 输入框
        UITextField *textField = [UITextField new];
        [view addSubview:textField];
        [textField setDelegate:self];
        [textField setFont:textFieldFont];
        [textField setTextColor:textFieldColor];
        [textField setBorderStyle:UITextBorderStyleNone];
        [textField setClearButtonMode:UITextFieldViewModeWhileEditing];
        [textField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
        [textField setAttributedPlaceholder:[[NSAttributedString alloc] initWithString:NSLocalizedString(@"请输入开户行地址", nil) attributes:@{ NSForegroundColorAttributeName : textFieldPlaceholderColor }]];
        [textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(view.mas_top).offset(margin*0.5f);
            make.left.equalTo(titleLabel.mas_right).offset(margin);
            make.right.equalTo(view.mas_right).offset(-margin*1.5f);
            make.bottom.equalTo(view.mas_bottom).offset(-margin*0.5f);
        }];
        self.bankAddressTextField = textField;
        self.bankAddressTextField.mas_key = @"bankAddressTextField";
        
        view;
    });
    self.bankAddressTextFieldView = bankAddressTextFieldView;
    self.bankAddressTextFieldView.mas_key = @"bankAddressTextFieldView";
    
    // 确认按钮
    UIButton *confirmButton = ({
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button defaultStyleButton];
        [containerView addSubview:button];
        [button.layer setBorderWidth:0.0f];
        [button setTitle:NSLocalizedString(@"提交", nil) forState:UIControlStateNormal];
        [button addTarget:self action:@selector(pressConfirmButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(bankAddressTextFieldView.mas_bottom).offset(margin*4.0f);
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
    
    [self.userNameTextField resignFirstResponder];
    [self.bankCardNumberTextField resignFirstResponder];
    [self.userNameTextFieldView addBorderWithColor:COLOR_SYSTEM_MAIN_UI_THEME_DEFAULT cornerRadius:5.0f andWidth:0.0f];
    [self.bankCardNumberTextFieldView addBorderWithColor:COLOR_SYSTEM_MAIN_UI_THEME_DEFAULT cornerRadius:5.0f andWidth:0.0f];
}

#pragma mark - Network

- (void)loadRequestBankDataListThen:(void (^)(NSMutableArray<FYBankItemModel *> *itemBankModels))then
{
    PROGRESS_HUD_SHOW
    [NET_REQUEST_MANAGER requestBankListWithSuccess:^(id response) {
        PROGRESS_HUD_DISMISS
        FYLog(NSLocalizedString(@"银行卡列表 => \n%@", nil), response);
        if (!NET_REQUEST_SUCCESS(response)) {
           !then ?: then(nil);
        } else {
            NSArray *data = NET_REQUEST_DATA(response);
            __block NSMutableArray<FYBankItemModel *> *bankCardModels = [NSMutableArray<FYBankItemModel *> array];
            [data enumerateObjectsUsingBlock:^(NSDictionary *dict, NSUInteger idx, BOOL * _Nonnull stop) {
                FYBankItemModel *model = [FYBankItemModel mj_objectWithKeyValues:dict];
                [bankCardModels addObj:model];
            }];
            !then ?: then(bankCardModels);
        }
    } fail:^(id error) {
        PROGRESS_HUD_DISMISS
        ALTER_HTTP_ERROR_MESSAGE(error)
        FYLog(NSLocalizedString(@"银行卡列表 => \n%@", nil), error);
        !then ?: then(nil);
    }];
}

- (void)doAddBankcardWhitUserName:(NSString *)userName bankId:(NSString *)bankId cardNum:(NSString *)cardNum bankCode:(NSString *)bankCode address:(NSString *)address then:(void (^)(BOOL success))then
{
    PROGRESS_HUD_SHOW
    [NET_REQUEST_MANAGER setAddBankcardWhitUserName:userName bankID:bankId cardNO:cardNum bankCode:bankCode address:address success:^(id response) {
        PROGRESS_HUD_DISMISS
        FYLog(NSLocalizedString(@"添加银行卡成功 => \n%@", nil), response);
        if (!NET_REQUEST_SUCCESS(response)) {
            ALTER_HTTP_MESSAGE(response)
            !then ?: then(NO);
        } else {
            !then ?: then(YES);
        }
    } fail:^(id error) {
        PROGRESS_HUD_DISMISS
        ALTER_HTTP_ERROR_MESSAGE(error)
        FYLog(NSLocalizedString(@"添加银行卡出错 => \n%@", nil), error);
        !then ?: then(NO);
    } ];
}


#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField*)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{

}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    
}


#pragma mark - FYBankSearchViewControllerDelegate

- (void)didBankModelSearchResultAtObjectModel:(FYBankItemModel *)objModel
{
    [self setCurrentBankItemModel:objModel];
    [self.bankNameTextField setText:objModel.title];
}


#pragma mark - Navigation

- (NSString *)prefersNavigationBarTitleViewTitle
{
    return STR_NAVIGATION_BAR_TITLE_ADD_BINDBANKCARD;
}


@end

