//
//  FY2020LoginCell.m
//  FY_OC
//
//  Created by FangYuan on 2020/1/31.
//  Copyright © 2020 FangYuan. All rights reserved.
//

#import "FY2020LoginCell.h"
#import "CDAlertViewController.h"

#ifdef _PROJECT_WITH_OPENINSTALL_
#import "OpenInstallSDK.h"
#endif

@implementation FYFieldModel

+(FYFieldModel *)key:(NSString *)key value:(NSString *)value place:(NSString *)place require:(BOOL)reuire{
    FYFieldModel *model = [FYFieldModel new];
    model.key = key;
    model.value = value;
    model.place = place;
    model.isRequire = reuire;
    return model;
}
/*
 if ([listData.itemId isEqualToString:@"mobile"]) {
     [section0 addObject:@{kTit:listData.placeholder,
                           kImg:@"icon_phone",
                           kType:@(EnumActionTag0),
                           kSubTit:listData.itemId,
                           kIsOn:listData.loginUseFlag
                           }];
 }
 */
+(NSArray<FYFieldModel *> *)assembelArray:(NSArray *)source{
    NSMutableArray *datalist=[NSMutableArray new];
    for (NSDictionary *dict in source) {
        NSString *key=dict[kSubTit];
        NSString *value=@"";
        if ([key isEqualToString:@"mobile"] || [key isEqualToString:@"mobile_user"]) {
            if ([[AppModel shareInstance] loginType] == FYLoginTypeDefault) {
                NSString *mobile = GetUserDefaultWithKey(@"mobilemobile");
                if (mobile.length > 1) {
                    value = mobile;
                }
            }
        }
        NSString *place=dict[kTit];
        BOOL isRequire=[dict[kIsOn] boolValue];
        FYFieldModel *model=[FYFieldModel key:key value:value place:place require:isRequire];
        [datalist addObject:model];
    }
    return datalist;
}

@end

@implementation FY2020LoginCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = [UIColor colorWithWhite:0.93725 alpha:1];
        [self labelTitle];
        UIView *xxView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 70, 70)];
        xxView.backgroundColor = [UIColor blueColor];
        [self.stackView addArrangedSubview:xxView];
    }
    return self;
}

-(void)buttonAction:(UIButton *)sender{
    
}

- (UILabel *)labelTitle{
    if (!_labelTitle) {
        _labelTitle = [UILabel new];
        _labelTitle.font = [UIFont systemFontOfSize:15];
        _labelTitle.text = NSLocalizedString(@"第三方登录", nil);
        _labelTitle.textColor = [UIColor grayColor];
        [self.contentView addSubview:_labelTitle];
        _labelTitle.translatesAutoresizingMaskIntoConstraints = NO;
        [_labelTitle.centerXAnchor constraintEqualToAnchor:self.contentView.centerXAnchor].active = YES;
        [_labelTitle.topAnchor constraintEqualToAnchor:self.contentView.topAnchor constant:40].active = YES;
        [_labelTitle.heightAnchor constraintEqualToConstant:20].active = YES;
        [_labelTitle.bottomAnchor constraintEqualToAnchor:self.contentView.bottomAnchor constant:-80].active = YES;
        UIView *leftView=[UIView new];
        [self.contentView addSubview:leftView];
        leftView.backgroundColor = [UIColor grayColor];
        leftView.translatesAutoresizingMaskIntoConstraints = NO;
        [leftView.centerYAnchor constraintEqualToAnchor:_labelTitle.centerYAnchor].active = YES;
        [leftView.heightAnchor constraintEqualToConstant:1].active = YES;
        [leftView.leftAnchor constraintEqualToAnchor:self.contentView.leftAnchor constant:30].active = YES;
        [leftView.rightAnchor constraintEqualToAnchor:_labelTitle.leftAnchor constant:-5].active = YES;
        UIView *rightView=[UIView new];
        [self.contentView addSubview:rightView];
        rightView.backgroundColor = [UIColor grayColor];
        rightView.translatesAutoresizingMaskIntoConstraints = NO;
        [rightView.centerYAnchor constraintEqualToAnchor:_labelTitle.centerYAnchor].active = YES;
        [rightView.leftAnchor constraintEqualToAnchor:_labelTitle.rightAnchor constant:5].active = YES;
        [rightView.rightAnchor constraintEqualToAnchor:self.contentView.rightAnchor constant:-30].active = YES;
        [rightView.heightAnchor constraintEqualToConstant:1].active = YES;
        
    }
    return _labelTitle;
}

- (UIStackView *)stackView{
    if (!_stackView) {
        _stackView=[[UIStackView alloc] initWithFrame:CGRectMake(0, 70, self.contentView.frame.size.width, 70)];
        _stackView.axis = UILayoutConstraintAxisHorizontal;
        _stackView.distribution = UIStackViewDistributionFillEqually;
        _stackView.spacing = 30;
        _stackView.alignment = UIStackViewAlignmentFill;
        _stackView.backgroundColor = [UIColor redColor];
        _stackView.center = CGPointMake(UIScreen.mainScreen.bounds.size.width * 0.5, 140-35);
        [self.contentView addSubview:_stackView];
    }
    return _stackView;
}


@end

@implementation FY2020LoginInputCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = [UIColor colorWithWhite:0.93725 alpha:1];
        [self field];
    }
    return self;
}

- (void)setModel:(FYFieldModel *)model{
    _model = model;
    self.field.placeholder = model.place;
    if ([model.key isEqualToString:@"mobile_code"]) {
        self.field.rightViewMode = UITextFieldViewModeAlways;
        self.field.rightView = self.buttonCode;
        self.field.text = model.value;
    } else if ([model.key isEqualToString:@"mobile_1"]) {
        self.field.rightViewMode = UITextFieldViewModeAlways;
        self.field.rightView = self.buttonCode;
        if ([[AppModel shareInstance] loginType] == FYLoginTypeDefault) {
            if (model.value.length < 1) {
                NSString *mobile = GetUserDefaultWithKey(@"mobile");
                model.value = mobile;
            }
        }else if ([[AppModel shareInstance] loginType] == FYLoginTypeWeChat){
            if ([AppModel shareInstance].userInfo.isBindMobile == YES) {
                if (model.value.length < 1) {
                    NSString *mobile = GetUserDefaultWithKey(@"mobile");
                    model.value = mobile;
                }
            }
        }
        self.field.text = model.value;
    } else if ([model.key isEqualToString:@"pic_code"]) {
        self.field.rightViewMode = UITextFieldViewModeAlways;
        if (self.field.rightView == nil) {
            UIView *rightView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 106, 40)];
            [rightView addSubview:self.buttonImageAnimator];
            self.field.rightView = rightView;
        }
        self.field.text = model.value;
    } else if ([model.key isEqualToString:@"birthday"]) {
        if (model.value.length < 1) {
            model.value = NSLocalizedString(@"选择日期 >", nil);
        }
        self.field.rightViewMode = UITextFieldViewModeAlways;
        self.field.rightView = self.buttonCode;
        [self.buttonCode setTitle:model.value forState:UIControlStateNormal];
        [self.buttonCode setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [self.buttonCode addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    } else if ([model.key isEqualToString:@"sex"]) {
        if (model.value.length < 1) {
            model.value = NSLocalizedString(@"男", nil);
        }
        self.field.rightViewMode = UITextFieldViewModeAlways;
        self.field.rightView = self.buttonCode;
        [self.buttonCode setTitle:model.value forState:UIControlStateNormal];
        [self.buttonCode setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [self.buttonCode addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    } else if ([model.key isEqualToString:@"passwd"]) {
        self.field.text = model.value;
        self.field.rightViewMode = UITextFieldViewModeAlways;
        self.field.rightView = self.buttonCode;
        [self.buttonCode setTitle:NSLocalizedString(@"忘记密码?", nil) forState:UIControlStateNormal];
        [self.buttonCode addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    } else if ([model.key isEqualToString:@"invite_code"]) {
        [self checkOpenInstalll];
    } else {
        self.field.text = model.value;
    }
    if ([model.key hasPrefix:@"pass"]) {
        self.field.secureTextEntry = YES;
    }else{
        self.field.secureTextEntry = NO;
    }
    
}

- (void)checkOpenInstalll
{
    if (!VALIDATE_STRING_EMPTY(kOpenInviteCode)) {
        self.model.value = kOpenInviteCode;
        self.field.text = kOpenInviteCode;
        self.field.enabled = NO;
    } else {  
#ifdef _PROJECT_WITH_OPENINSTALL_
        NSString *nubmer = VALIDATE_STRING_EMPTY(kOpenInviteCode) ? GetUserDefaultWithKey(kUserDefaultsStandardKeyOpenInstallCode) : kOpenInviteCode;
        if (nubmer.length > 0) {
            self.model.value = nubmer;
            self.field.text = nubmer;
            self.field.enabled = NO;
        } else {
            self.field.enabled = YES;
            __weak typeof(self) tempVC = self;
            [[OpenInstallSDK defaultManager] getInstallParmsCompleted:^(OpeninstallData*_Nullable appData) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    //在主线程中回调
                    if (appData.data) {//(动态安装参数)
                        //e.g.如免填邀请码建立邀请关系、自动加好友、自动进入某个群组或房间等
                    }
                    if (appData.channelCode) {//(通过渠道链接或二维码安装会返回渠道编号)
                        //e.g.可自己统计渠道相关数据等
                    }
                    NSString *codeNumber = VALIDATE_STRING_EMPTY(kOpenInviteCode) ? appData.data[@"code"] : kOpenInviteCode;
                    if (codeNumber.length > 0) {
                        tempVC.model.value = codeNumber;
                        tempVC.field.text = codeNumber;
                        SetUserDefaultKeyWithObject(kUserDefaultsStandardKeyOpenInstallCode, codeNumber);
                        tempVC.field.enabled = NO;
                    }
                    NSLog(NSLocalizedString(@"OpenInstallSDK:\n动态参数：%@;\n渠道编号：%@", nil),appData.data,appData.channelCode);
                });
            }];
        }
#endif
    }
}

-(void)buttonAction:(UIButton *)sender{
    if ([sender.currentTitle isEqualToString:NSLocalizedString(@"忘记密码?", nil)]) {
        if (self.actionCallBack) {
            self.actionCallBack(2);
        }
    }else{
        if (self.actionCallBack) {
            self.actionCallBack(1);
        }
        [self.field becomeFirstResponder];
    }
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if ([self.model.key isEqualToString:@"sex"]) {
        if (self.actionCallBack) {
            self.actionCallBack(1);
        }
        ActionSheetCus *sheet = [[ActionSheetCus alloc] initWithArray:@[NSLocalizedString(@"男", nil),NSLocalizedString(@"女", nil)]];
        sheet.titleLabel.text = NSLocalizedString(@"请选择性别", nil);
        sheet.delegate = self;
        [sheet showWithAnimationWithAni:YES];
        return NO;
    }else if ([self.model.key isEqualToString:@"birthday"]){
        if (self.actionCallBack) {
            self.actionCallBack(1);
        }
        __weak typeof(self) tempVC = self;
        [CDAlertViewController showDatePikerDate:^(NSString *date) {
            tempVC.model.value = date;
            [tempVC.buttonCode setTitle:tempVC.model.value forState:UIControlStateNormal];
            [tempVC.buttonCode sizeToFit];
        }];
        return NO;
    }
    
    return YES;
}

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    if ([self.model.key isEqualToString:@"sex"]) {
        
    }else if ([self.model.key isEqualToString:@"birthday"]){
        
    }else{
        self.model.value = textField.text;
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

-(void)actionSheetDelegateWithActionSheet:(ActionSheetCus *)actionSheet index:(NSInteger)index{
    self.model.value = index == 0 ? NSLocalizedString(@"男", nil) : NSLocalizedString(@"女", nil);
    [self.buttonCode setTitle:self.model.value forState:UIControlStateNormal];
}

- (UITextField *)field{
    if (!_field) {
        _field=[UITextField new];
        _field.leftViewMode = UITextFieldViewModeAlways;
        _field.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 40)];
        _field.borderStyle = UITextBorderStyleNone;
        _field.backgroundColor = [UIColor whiteColor];
        _field.layer.cornerRadius = 20;
        [self.contentView addSubview:_field];
        _field.translatesAutoresizingMaskIntoConstraints = NO;
        [_field.leftAnchor constraintEqualToAnchor:self.contentView.leftAnchor constant:30].active = YES;
        [_field.topAnchor constraintEqualToAnchor:self.contentView.topAnchor constant:10].active = YES;
        [_field.heightAnchor constraintEqualToConstant:40].active = YES;
        [_field.centerXAnchor constraintEqualToAnchor:self.contentView.centerXAnchor].active = YES;
        [_field.bottomAnchor constraintEqualToAnchor:self.contentView.bottomAnchor constant:-3].active = YES;
        _field.delegate = self;
        _field.textColor = UIColor.blackColor;
    }
    return _field;
}

- (UIButton *)buttonCode{
    if (!_buttonCode) {
        _buttonCode = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 138, 40)];
        [_buttonCode setTitle:NSLocalizedString(@"获取验证码", nil) forState:UIControlStateNormal];
        _buttonCode.titleLabel.adjustsFontSizeToFitWidth = YES;
        _buttonCode.titleLabel.textAlignment = NSTextAlignmentRight;
        [_buttonCode setTitleColor:[UIColor colorWithRed:249.0/255 green:71.0/255 blue:54.0/255 alpha:1] forState:UIControlStateNormal];
        _buttonCode.contentEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 20);
        _buttonCode.titleLabel.font = [UIFont systemFontOfSize:15];
    }
    return _buttonCode;
}

- (UIButton *)buttonRegisterCode{
    if (!_buttonRegisterCode) {
        _buttonRegisterCode = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 138, 40)];
        _buttonRegisterCode.tag = 99;
        _buttonRegisterCode.titleLabel.adjustsFontSizeToFitWidth = YES;
        _buttonRegisterCode.titleLabel.textAlignment = NSTextAlignmentRight;
        [_buttonRegisterCode setTitle:NSLocalizedString(@"获取验证码", nil) forState:UIControlStateNormal];
        [_buttonRegisterCode setTitleColor:[UIColor colorWithRed:249.0/255 green:71.0/255 blue:54.0/255 alpha:1] forState:UIControlStateNormal];
        _buttonRegisterCode.contentEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 20);
        _buttonRegisterCode.titleLabel.font = [UIFont systemFontOfSize:15];
    }
    return _buttonRegisterCode;
}

- (FLAnimatedImageView *)buttonImageAnimator{
    if (!_buttonImageAnimator) {
        _buttonImageAnimator = [[FLAnimatedImageView alloc] initWithFrame:CGRectMake(0, 5, 86, 30)];
    }
    return _buttonImageAnimator;
}

@end

@implementation FY2020LoginActionCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = [UIColor colorWithWhite:0.93725 alpha:1];
        [self buttonLogin];
//        [self buttonOther];
    }
    return self;
}

- (UIButton *)buttonLogin{
    if (!_buttonLogin) {
        _buttonLogin=[UIButton new];
        [_buttonLogin setTitle:NSLocalizedString(@"登录", nil) forState:UIControlStateNormal];
        [_buttonLogin setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _buttonLogin.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 8, 0);
        [_buttonLogin setBackgroundImage:[UIImage imageNamed:@"icon_login_button"] forState:UIControlStateNormal];
        [self.contentView addSubview:_buttonLogin];
        _buttonLogin.translatesAutoresizingMaskIntoConstraints = NO;
        [_buttonLogin.leftAnchor constraintEqualToAnchor:self.contentView.leftAnchor].active=YES;
        [_buttonLogin.topAnchor constraintEqualToAnchor:self.contentView.topAnchor constant:5].active = YES;
        [_buttonLogin.heightAnchor constraintEqualToConstant:55].active = YES;
        [_buttonLogin.centerXAnchor constraintEqualToAnchor:self.contentView.centerXAnchor].active = YES;
        [_buttonLogin.bottomAnchor constraintEqualToAnchor:self.contentView.bottomAnchor constant:-5].active = YES;
    }
    return _buttonLogin;
}


//- (UIButton *)buttonOther{
//    if (!_buttonOther) {
//        _buttonOther= [UIButton new];
//        [_buttonOther setTitle:NSLocalizedString(@" 使用密码登录 ", nil) forState:UIControlStateNormal];
//        [_buttonOther setTitleColor:[UIColor colorWithRed:249.0/255 green:71.0/255 blue:54.0/255 alpha:1] forState:UIControlStateNormal];
//        [self.contentView addSubview:_buttonOther];
//        _buttonOther.titleLabel.adjustsFontSizeToFitWidth = YES;
//        _buttonOther.translatesAutoresizingMaskIntoConstraints = NO;
//        _buttonOther.titleLabel.font = [UIFont systemFontOfSize:15];
//        [_buttonOther.topAnchor constraintEqualToAnchor:self.buttonLogin.bottomAnchor constant:5].active = YES;
//        [_buttonOther.widthAnchor constraintEqualToConstant:300].active = YES;
//        [_buttonOther.heightAnchor constraintEqualToConstant:25].active = YES;
//        [_buttonOther.centerXAnchor constraintEqualToAnchor:self.contentView.centerXAnchor].active = YES;
//        [_buttonOther.bottomAnchor constraintEqualToAnchor:self.contentView.bottomAnchor constant:-20].active = YES;
//    }
//    return _buttonOther;
//}
@end

@implementation FY2020LoginRedActionCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = [UIColor colorWithWhite:0.93725 alpha:1];
        [self button];
    }
    return self;
}

- (UIButton *)button{
    if (!_button) {
        _button=[UIButton new];
        [_button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [_button setTitle:NSLocalizedString(@"用户名登录", nil) forState:UIControlStateNormal];
        _button.titleLabel.font=[UIFont systemFontOfSize:15];
        [self.contentView addSubview:_button];
        _button.translatesAutoresizingMaskIntoConstraints=NO;
        [_button.centerYAnchor constraintEqualToAnchor:self.contentView.centerYAnchor].active=YES;
        [_button.centerXAnchor constraintEqualToAnchor:self.contentView.centerXAnchor].active=YES;
        [_button.heightAnchor constraintEqualToConstant:16].active=YES;
        [_button.widthAnchor constraintEqualToConstant:kScreenWidth].active=YES;
        _button.tag = 200;
    }
    return _button;
}
@end


@implementation FY2020LoginRightButtonCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = [UIColor colorWithWhite:0.93725 alpha:1];
        [self button];
    }
    return self;
}

- (UIButton *)button{
    if (!_button) {
        _button=[UIButton new];
        [_button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [_button setTitle:NSLocalizedString(@"密码登录", nil) forState:UIControlStateNormal];
        _button.titleLabel.font=[UIFont systemFontOfSize:15];
        [self.contentView addSubview:_button];
        _button.translatesAutoresizingMaskIntoConstraints=NO;
        [_button.rightAnchor constraintEqualToAnchor:self.contentView.rightAnchor constant:-40].active=YES;
        [_button.topAnchor constraintEqualToAnchor:self.contentView.topAnchor constant:15].active=YES;
        [_button.heightAnchor constraintEqualToConstant:16].active=YES;
        [_button.bottomAnchor constraintEqualToAnchor:self.contentView.bottomAnchor constant:-10].active = YES;
        _button.tag = 300;
    }
    return _button;
}
@end
