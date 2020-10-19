//
//  EnterPwdBoxView.m
//  Project
//
//  Created by Mike on 2019/4/29.
//  Copyright © 2019 CDJay. All rights reserved.
//

#import "EnterPwdBoxView.h"

CGFloat const kFyEnterPwdBoxViewHeight = 220.0f;

@interface EnterPwdBoxView()<CAAnimationDelegate, UITextFieldDelegate>

@property (nonatomic,strong) UIControl *backControl;
@property (nonatomic,strong) UIView *content;

@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UIImageView *backImageView;

@property (nonatomic,strong) UITextField *textField;
@end

@implementation EnterPwdBoxView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubviews];
    }
    return self;
}

#pragma mark - subView
- (void)initSubviews
{
    _backControl = [[UIControl alloc]initWithFrame:self.bounds];
    [self addSubview:_backControl];
    _backControl.backgroundColor = ApHexColor(@"#000000", 0.6);
    [_backControl addTarget:self action:@selector(onbackControl) forControlEvents:UIControlEventTouchUpInside];
    
    CGFloat left_right_margin = CD_WidthScal(35, 375);
    CGFloat width = SCREEN_WIDTH - left_right_margin * 2.0f;
    CGFloat height = kFyEnterPwdBoxViewHeight;
    CGFloat x = left_right_margin;
    CGFloat y = SCREEN_HEIGHT * 0.5f - height * 0.5f;
    
    UIView *content = [[UIView alloc] initWithFrame:CGRectMake(x, y, width, height)];
    [content setBackgroundColor:[UIColor whiteColor]];
    [content addCornerRadius:7.5f];
    _content = content;
    [self addSubview:content];
    
    UIView *passwordBackView = [[UIView alloc] init];
    [passwordBackView addBorderWithColor:COLOR_SYSTEM_MAIN_UI_THEME_DEFAULT cornerRadius:5.f andWidth:1.0f];
    [content addSubview:passwordBackView];
    [passwordBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(content.mas_left).offset(CD_WidthScal(25, 375));
        make.right.mas_equalTo(content.mas_right).offset(-CD_WidthScal(25, 375));
        make.centerY.equalTo(content.mas_bottom).multipliedBy(0.47f);
        make.height.mas_equalTo(CFC_AUTOSIZING_WIDTH(SYSTEM_GLOBAL_BUTTON_HEIGHT));
    }];
    
    UITextField *textField = [[UITextField alloc] init];
    textField.delegate = self;
    textField.secureTextEntry = YES;
    textField.borderStyle = UITextBorderStyleNone;
    textField.font = [UIFont boldSystemFontOfSize:18.0];
    textField.placeholder = NSLocalizedString(@"请输入密码", nil);
    textField.returnKeyType = UIReturnKeyDone;
    textField.keyboardType = UIKeyboardTypeDefault;
    textField.clearButtonMode = UITextFieldViewModeAlways;
    textField.textColor = [UIColor colorWithRed:0.835 green:0.655 blue:0.443 alpha:1.000];
    [passwordBackView addSubview:textField];
    _textField = textField;
    [textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(passwordBackView.mas_left).offset(10.0f);
        make.right.mas_equalTo(passwordBackView.mas_right);
        make.centerY.mas_equalTo(passwordBackView.mas_centerY);
        make.height.mas_equalTo(@(CFC_AUTOSIZING_WIDTH(SYSTEM_GLOBAL_BUTTON_HEIGHT)));
    }];
    
    UILabel *titleLabel = [UILabel new];
    [content addSubview:titleLabel];
    [titleLabel setText:NSLocalizedString(@"请输入群密码", nil)];
    [titleLabel setFont:[UIFont boldSystemFontOfSize:16.0f]];
    [titleLabel setTextColor:COLOR_HEXSTRING(@"#5E6C84")];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(content.mas_bottom).multipliedBy(0.2f);
        make.centerX.equalTo(content.mas_centerX);
    }];

    UIButton *confirmButton = ({
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button defaultStyleButton];
        [content addSubview:button];
        [button.layer setBorderWidth:0.0f];
        [button setTitle:NSLocalizedString(@"立即进群", nil) forState:UIControlStateNormal];
        [button addTarget:self action:@selector(pressConfirmButtonAction) forControlEvents:UIControlEventTouchUpInside];

        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(content.mas_bottom).multipliedBy(0.78f);
            make.left.mas_equalTo(passwordBackView.mas_left);
            make.right.mas_equalTo(passwordBackView.mas_right);
            make.height.equalTo(@(CFC_AUTOSIZING_WIDTH(SYSTEM_GLOBAL_BUTTON_HEIGHT)));
        }];

        button;
    });
    confirmButton.mas_key = @"confirmButton";
}

- (void)pressConfirmButtonAction
{
    if (VALIDATE_STRING_EMPTY(self.textField.text)) {
        ALTER_INFO_MESSAGE(NSLocalizedString(@"密码不能为空", nil))
        return;
    }
    
    if (self.joinGroupBtnBlock) {
        self.joinGroupBtnBlock(self.textField.text);
    }
}

- (void)showInView:(UIView *)view
{
    if (self == nil) {
        return;
    }
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    _content.transform = CGAffineTransformMakeScale(0.4, 0.4);
    _content.alpha = 0.0;
    _backControl.alpha = 0.0;
    [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:0.5 options:0 animations:^{
        // 放大
        self->_content.transform = CGAffineTransformMakeScale(1, 1);
        self->_backControl.alpha = 0.6;
        self->_content.alpha = 1.0;

    } completion:nil];
}

- (void)remover
{
    [UIView animateWithDuration:0.25 animations:^{
        self->_content.transform = CGAffineTransformMakeScale(0.2, 0.2);
        self->_content.alpha = 0.0;
        self->_backControl.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)disMissView
{
    if (self.disMissViewBlock) {
        self.disMissViewBlock();
    }
    [self remover];
}

- (void)onbackControl
{
    [self disMissView];
}

//点击输入框界面跟随键盘上移
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    CGFloat marginWidth = CD_WidthScal(35, 375);
    CGFloat w = SCREEN_WIDTH-marginWidth * 2;
    CGFloat h = kFyEnterPwdBoxViewHeight;
    CGFloat y = SCREEN_HEIGHT /2 - h/2;
    
    CGFloat keyboard = 258 + 45;
    CGFloat lowestHeight = SCREEN_HEIGHT -(h+keyboard);
    
//    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
//    [UIView setAnimationDuration:0.5f];
    if ((y - lowestHeight) > 0) {
        self.content.frame = CGRectMake(marginWidth, lowestHeight, w, h);
//        [UIView commitAnimations];
    }
}

// 输入框编辑完成以后，将视图恢复到原始状态
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    CGFloat marginWidth = CD_WidthScal(35, 375);
    CGFloat w = SCREEN_WIDTH-marginWidth * 2;
    CGFloat h = kFyEnterPwdBoxViewHeight;
    CGFloat y = SCREEN_HEIGHT /2 - h/2;
    self.content.frame = CGRectMake(marginWidth, y, w, h);
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self pressConfirmButtonAction];
    
    return YES;
}


@end

