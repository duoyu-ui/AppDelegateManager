//
//  FYAgentOpenAccountViewController.m
//  ProjectCSHB
//
//  Created by fangyuan on 2020/5/27.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "FYAgentOpenAccountViewController.h"
#import "FYAgentRegisterAlertView.h"
#import "TPKeyboardAvoidingScrollView.h"
#import "NSData+AES.h"
#import "GTMBase64.h"
#import "RSA.h"

@interface FYAgentOpenAccountViewController () <UITextFieldDelegate>
//
@property (nonatomic, strong) UIView *userNameTextFieldView;
@property (nonatomic, strong) UIView *passwordTextFieldView;
@property (nonatomic, strong) UITextField *userNameTextField;
@property (nonatomic, strong) UITextField *passwordTextField;
//
@property (nonatomic, strong) UIButton *confirmButton;

@end

@implementation FYAgentOpenAccountViewController

#pragma mark - Actions

- (void)pressConfirmButtonAction:(UIButton *)button
{
    [self resignFirstResponderOfTextField];
    
    if ([APPINFORMATION isGuest]) {
        return;
    }
    
    NSString *userName = STR_TRI_WHITE_SPACE(self.userNameTextField.text);
    if (VALIDATE_STRING_EMPTY(userName)) {
        ALTER_INFO_MESSAGE(NSLocalizedString(@"用户名不能为空", nil))
        return;
    }

    NSString *password = STR_TRI_WHITE_SPACE(self.passwordTextField.text);
    if (VALIDATE_STRING_EMPTY(password)) {
        ALTER_INFO_MESSAGE(NSLocalizedString(@"密码不能为空", nil))
        return;
    } else if (password.length < 6 || password.length > 16) {
        ALTER_INFO_MESSAGE(NSLocalizedString(@"请输入6~16位密码", nil))
        return;
    }

    [self doRegisterAgentWithUserName:userName password:password then:^(BOOL success) {
        if (success) {
            [[IMContactsModule sharedInstance] handleUpdateAllContactEntitys:^(BOOL success) {
                [NOTIF_CENTER postNotificationName:kNotificationAddOrDeleteFriend object:nil];
            }];
            [FYAgentRegisterAlertView alertWithTitle:NSLocalizedString(@"注册成功", nil) userName:userName password:password confirmBlock:^{
                [self.navigationController popViewControllerAnimated:YES];
            }];
        }
    }];
}

- (void)pressTouchActionOfContainerView:(UITapGestureRecognizer *)gesture
{
    [self resignFirstResponderOfTextField];
}


#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self createMainUIView];
}

- (void)createMainUIView
{
    CGFloat margin = CFC_AUTOSIZING_MARGIN(MARGIN);
    //
    CGFloat textFieldContainerHeight = CFC_AUTOSIZING_WIDTH(45.0f);
    UIColor *textFieldContainerHeightColor = COLOR_HEXSTRING(@"#F7F7F7");
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
            if (CFC_IS_IPHONE_X_OR_GREATER) {
                make.height.mas_greaterThanOrEqualTo(SCREEN_HEIGHT-STATUS_NAVIGATION_BAR_HEIGHT-TAB_BAR_DANGER_HEIGHT+1.0);
            } else {
                make.height.mas_greaterThanOrEqualTo(SCREEN_HEIGHT-STATUS_NAVIGATION_BAR_HEIGHT+1.0);
            }
        }];
        view;
    });
    containerView.mas_key = @"containerView";
    
    // 提示信息
    UILabel *lastTipLabel = nil;
    {
        UILabel *tipInfoLabel1 = [UILabel new];
        [containerView addSubview:tipInfoLabel1];
        [tipInfoLabel1 setText:NSLocalizedString(@"此账号将注册为", nil)];
        [tipInfoLabel1 setFont:[UIFont systemFontOfSize:15.0f]];
        [tipInfoLabel1 setTextColor:COLOR_HEXSTRING(@"#5E6C84")];
        [tipInfoLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(containerView.mas_top).offset(margin*4.0f);
            make.centerX.equalTo(containerView.mas_centerX);
        }];
        tipInfoLabel1.mas_key = @"tipInfoLabel1";
        
        UILabel *tipInfoLabel2 = [UILabel new];
        [containerView addSubview:tipInfoLabel2];
        [tipInfoLabel2 setText:NSLocalizedString(@"您的线下会员", nil)];
        [tipInfoLabel2 setFont:[UIFont boldSystemFontOfSize:14.0f]];
        [tipInfoLabel2 setTextColor:COLOR_HEXSTRING(@"#5E6C84")];
        [tipInfoLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(tipInfoLabel1.mas_bottom).offset(margin*1.0f);
            make.centerX.equalTo(containerView.mas_centerX);
        }];
        tipInfoLabel2.mas_key = @"tipInfoLabel2";
        
        lastTipLabel = tipInfoLabel2;
    }
    
    // 用户名
    UIView *_userNameTextFieldView = ({
        // 容器
        UIView *view = [UIView new];
        [containerView addSubview:view];
        [view setBackgroundColor:textFieldContainerHeightColor];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(lastTipLabel.mas_bottom).offset(margin*5.0f);
            make.left.equalTo(containerView.mas_left).offset(margin*3.0f);
            make.right.equalTo(containerView.mas_right).offset(-margin*3.0f);
            make.height.equalTo(@(textFieldContainerHeight));
        }];
        
        // 输入框
        UITextField *textField = [UITextField new];
        [view addSubview:textField];
        [textField setTag:80001];
        [textField setDelegate:self];
        [textField setFont:textFieldFont];
        [textField setTextColor:textFieldColor];
        [textField setBorderStyle:UITextBorderStyleNone];
        [textField setClearButtonMode:UITextFieldViewModeWhileEditing];
        [textField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
        [textField setAttributedPlaceholder:[[NSAttributedString alloc] initWithString:NSLocalizedString(@"请输入6~18位字母和数字组合", nil) attributes:@{ NSForegroundColorAttributeName : textFieldPlaceholderColor }]];
        [textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(view.mas_top).offset(margin*0.5f);
            make.left.equalTo(view.mas_left).offset(margin);
            make.right.equalTo(view.mas_right).offset(-margin);
            make.bottom.equalTo(view.mas_bottom).offset(-margin*0.5f);
        }];
        self.userNameTextField = textField;
        self.userNameTextField.mas_key = @"userNameTextField";
        
        view;
    });
    self.userNameTextFieldView = _userNameTextFieldView;
    self.userNameTextFieldView.mas_key = @"_userNameTextFieldView";

    // 密码
    UIView *passwordTextFieldView = ({
        // 容器
        UIView *view = [UIView new];
        [containerView addSubview:view];
        [view setBackgroundColor:textFieldContainerHeightColor];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_userNameTextFieldView.mas_bottom).offset(margin*2.0f);
            make.left.equalTo(containerView.mas_left).offset(margin*3.0f);
            make.right.equalTo(containerView.mas_right).offset(-margin*3.0f);
            make.height.equalTo(@(textFieldContainerHeight));
        }];
        
        // 输入框
        UITextField *textField = [UITextField new];
        [view addSubview:textField];
        [textField setTag:80002];
        [textField setDelegate:self];
        [textField setFont:textFieldFont];
        [textField setSecureTextEntry:YES];
        [textField setTextColor:textFieldColor];
        [textField setBorderStyle:UITextBorderStyleNone];
        [textField setClearButtonMode:UITextFieldViewModeWhileEditing];
        [textField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
        [textField setAttributedPlaceholder:[[NSAttributedString alloc] initWithString:NSLocalizedString(@"请输入6~16位密码", nil) attributes:@{ NSForegroundColorAttributeName : textFieldPlaceholderColor }]];
        [textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(view.mas_top).offset(margin*0.5f);
            make.left.equalTo(view.mas_left).offset(margin);
            make.right.equalTo(view.mas_right).offset(-margin);
            make.bottom.equalTo(view.mas_bottom).offset(-margin*0.5f);
        }];
        self.passwordTextField = textField;
        self.passwordTextField.mas_key = @"passwordTextField";
        
        view;
    });
    self.passwordTextFieldView = passwordTextFieldView;
    self.passwordTextFieldView.mas_key = @"passwordTextFieldView";
    
    // 确认按钮
    UIButton *confirmButton = ({
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button defaultStyleButton];
        [containerView addSubview:button];
        [button.layer setBorderWidth:0.0f];
        [button setTitle:NSLocalizedString(@"注册", nil) forState:UIControlStateNormal];
        [button addTarget:self action:@selector(pressConfirmButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(passwordTextFieldView.mas_bottom).offset(margin*5.0f);
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
    [self.passwordTextField resignFirstResponder];
    [self.userNameTextFieldView addBorderWithColor:COLOR_SYSTEM_MAIN_UI_THEME_DEFAULT cornerRadius:5.0f andWidth:0.0f];
    [self.passwordTextFieldView addBorderWithColor:COLOR_SYSTEM_MAIN_UI_THEME_DEFAULT cornerRadius:5.0f andWidth:0.0f];
}

#pragma mark - Network

- (void)doRegisterAgentWithUserName:(NSString *)regUserName password:(NSString *)regPassword then:(void (^)(BOOL success))then
{
#if 0
    /// 备注：暂时不加密
    NSData *data = [regPassword dataUsingEncoding:NSUTF8StringEncoding];
    data = [data AES128EncryptWithKey:kAccountPasswordKey gIv:kAccountPasswordKey];
    data = [GTMBase64 encodeData:data];
    NSString *aesPassword = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
#endif
    
    PROGRESS_HUD_SHOW
    [NET_REQUEST_MANAGER requestAgentRegisterUserId:APPINFORMATION.userInfo.userId userName:regUserName passwrod:regPassword success:^(id response) {
        PROGRESS_HUD_DISMISS
        FYLog(NSLocalizedString(@"注册代理 => \n%@", nil), response);
        if (!NET_REQUEST_SUCCESS(response)) {
            ALTER_HTTP_MESSAGE(response)
            !then ?: then(NO);
        } else {
            !then ?: then(YES);
        }
    } failure:^(id error) {
        PROGRESS_HUD_DISMISS
        ALTER_HTTP_ERROR_MESSAGE(error)
        FYLog(NSLocalizedString(@"注册代理出错 => \n%@", nil), error);
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
    if (80001 == textField.tag) {
        [self.userNameTextFieldView addBorderWithColor:COLOR_SYSTEM_MAIN_UI_THEME_DEFAULT cornerRadius:5.0f andWidth:1.5f];
        [self.passwordTextFieldView addBorderWithColor:COLOR_SYSTEM_MAIN_UI_THEME_DEFAULT cornerRadius:5.0f andWidth:0.0f];
    } else if (80002 == textField.tag) {
        [self.userNameTextFieldView addBorderWithColor:COLOR_SYSTEM_MAIN_UI_THEME_DEFAULT cornerRadius:5.0f andWidth:0.0f];
        [self.passwordTextFieldView addBorderWithColor:COLOR_SYSTEM_MAIN_UI_THEME_DEFAULT cornerRadius:5.0f andWidth:1.5f];
    } else {
        [self.userNameTextFieldView addBorderWithColor:COLOR_SYSTEM_MAIN_UI_THEME_DEFAULT cornerRadius:5.0f andWidth:0.0f];
        [self.passwordTextFieldView addBorderWithColor:COLOR_SYSTEM_MAIN_UI_THEME_DEFAULT cornerRadius:5.0f andWidth:0.0f];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    
}


#pragma mark - Navigation

- (NSString *)prefersNavigationBarTitleViewTitle
{
    return STR_NAVIGATION_BAR_TITLE_AGENT_OPEN_ACCOUNT;
}

- (CGFloat)prefersNavigationBarHairlineHeight
{
    return NAVIGATION_BAR_HAIR_LINE_HEIGHT_ZERO;
}


@end

