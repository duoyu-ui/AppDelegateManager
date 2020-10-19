//
//  PersonalSignatureSettingVC.m
//  Project
//
//  Created by Mike on 2019/6/25.
//  Copyright © 2019 CDJay. All rights reserved.
//

#import "PersonalSignatureSettingVC.h"
#import "GroupNet.h"
#import "FYFriendName.h"


@interface PersonalSignatureSettingVC()<UITextFieldDelegate>

@property (nonatomic, strong) id requestParams;

@property (nonatomic, strong) UITextField *textField;

@property (nonatomic, copy) DataBlock successBlock;

@end

@implementation PersonalSignatureSettingVC


+ (instancetype)pushFromVC:(UIViewController *)rootVC requestParams:(id )requestParams success:(DataBlock)block
{
    PersonalSignatureSettingVC *vc = [[PersonalSignatureSettingVC alloc] init];
    vc.successBlock = block;
    if (requestParams != nil) {
        vc.requestParams = requestParams;
    }
    [rootVC.navigationController pushViewController:vc animated:true];
    return vc;
}

- (UITextField *)textField {
    
    if (!_textField) {
        _textField = [[UITextField alloc] init];
        _textField.delegate = self;
        _textField.textAlignment = NSTextAlignmentLeft;
        _textField.font = [UIFont systemFontOfSize:15];
        _textField.backgroundColor = [UIColor whiteColor];
        _textField.placeholder = NSLocalizedString(@"限制0-12个字符", nil);
    }
    return _textField;
}

#pragma mark - Life cycle

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self.textField becomeFirstResponder];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = NSLocalizedString(@"设置备注名", nil);
    self.view.backgroundColor = BaseColor;

    [self setupSubview];
}

- (void)setupSubview {
    [self.view addSubview:self.textField];
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.view);
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view).offset(10);
        make.height.equalTo(@42);
    }];
    
    self.textField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 0)];
    self.textField.leftViewMode = UITextFieldViewModeAlways;
    
    UIButton *saveBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [saveBtn setTitleColor:COLOR_SYSTEM_MAIN_FONT_DEFAULT forState:UIControlStateNormal];
    saveBtn.titleLabel.font = [UIFont systemFontOfSize2:15];
    [saveBtn setTitle:NSLocalizedString(@"保存", nil) forState:UIControlStateNormal];
    [saveBtn addTarget:self action:@selector(saveAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:saveBtn];
    self.navigationItem.rightBarButtonItems = @[rightItem];
    
    if (self.requestParams != nil) {
        FYContacts *contacts = (FYContacts *)self.requestParams;
        if (![NSString isBlankString:contacts.friendNick]) {
            self.textField.text = contacts.friendNick;
        }
    }
}

#pragma mark - Request

- (void)saveAction:(UIButton *)sender
{
    [self.view endEditing:YES];
    
    if (self.textField.text.length <= 0) {
        [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"请输入备注名", nil)];
        return;
    }else if (self.textField.text.length > 12) {
        [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"字数超出限制", nil)];
        return;
    }
    
    PROGRESS_HUD_SHOW;
    __weak __typeof(self)weakSelf = self;
    FYContacts *contacts = self.requestParams;
    if (contacts.isFriend) {
        [NET_REQUEST_MANAGER getUpdateFriendNickWithUserId:contacts.userId friendNick:self.textField.text success:^(id object) {
            PROGRESS_HUD_DISMISS
            
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            
            contacts.friendNick = strongSelf.textField.text;
            [FYFriendName setName:contacts.friendNick userID:[NSString stringWithFormat:@"%@",contacts.userId]];
            if (strongSelf.successBlock) {
                strongSelf.successBlock(contacts);
            }
            
            [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"保存成功", nil)];
            [strongSelf.navigationController popViewControllerAnimated:true];
            
        } fail:^(id object) {
            
             [[FunctionManager sharedInstance] handleFailResponse:object];
        }];
    } else {
        /*
         {"friendNick":"峰9528","userId":"14102"}
         */
        NSDictionary *sender=@{@"friendNick":self.textField.text,
                               @"userId":contacts.userId};
        [NET_REQUEST_MANAGER updateInternalNick:sender successBlock:^(NSDictionary *success) {
            PROGRESS_HUD_DISMISS
            
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            
            contacts.friendNick = strongSelf.textField.text;
            [FYFriendName setName:contacts.friendNick userID:[NSString stringWithFormat:@"%@",contacts.userId]];
            if (strongSelf.successBlock) {
                strongSelf.successBlock(contacts);
            }
            
            [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"保存成功", nil)];
            [strongSelf.navigationController popViewControllerAnimated:true];
        } failureBlock:^(NSError *failure) {
            PROGRESS_HUD_DISMISS
            [[FunctionManager sharedInstance] handleFailResponse:failure];
        }];
    }
    
}

#pragma mark - <UITextFieldDelegate>

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([string isEqualToString:@""]) {
        return YES;
    }
    
    if (range.location >= 12) {
        return NO;
    } else {
        return YES;
    }
    
    return YES;
}


@end

