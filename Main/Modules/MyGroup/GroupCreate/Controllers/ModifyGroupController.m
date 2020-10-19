//
//  ModifyGroupController.m
//  ProjectXZHB
//
//  Created by 汤姆 on 2019/7/28.
//  Copyright © 2019 CDJay. All rights reserved.
//

#import "ModifyGroupController.h"
#import "UITextPlaceholderView.h"

#define kNOTICE_MAX_LENGTH   900
#define kGROUPED_MAX_LENGTH  20

@interface ModifyGroupController ()<UITextViewDelegate, UITextFieldDelegate>

@property (nonatomic, strong) UITextPlaceholderView *customTxView;

@property (nonatomic, strong) UITextField *textField;

@property (nonatomic, strong) UIButton *confirmBtn;

@property (nonatomic, strong) UILabel *numLabel;

@end

@implementation ModifyGroupController

#pragma mark - Life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = BaseColor;
    
    [self setupSubview];
    [self editableHandler];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (self.type == ModifyGroupTypeName) {
        [self.textField becomeFirstResponder];
    }else {
        [self.customTxView becomeFirstResponder];
    }
}

- (void)editableHandler {
    if (!self.isSetting) {
        if ([AppModel shareInstance].isGroupOwner) {
            self.confirmBtn.hidden = false;
            self.customTxView.editable = true;
        }else {
            self.navigationItem.title = NSLocalizedString(@"群公告", nil);
            self.confirmBtn.hidden = true;
            self.customTxView.editable = false;
        }
    }
}

- (void)setupSubview {
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:self.confirmBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    switch (self.type) {
          case ModifyGroupTypeName:
              [self makeTextField];
              break;
          case ModifyGroupTypeMent:
              [self makeTextView];
              break;
          default:
              break;
      }
}


- (void)makeTextField {
    [self.view addSubview:self.textField];
    self.textField.text = self.content;
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.width.mas_equalTo(SCREEN_WIDTH * 0.95);
        make.height.mas_equalTo(35);
        make.top.mas_equalTo(30);
    }];
}

- (void)makeTextView {
    [self.view addSubview:self.customTxView];
    [self.view addSubview:self.numLabel];
    self.customTxView.text = self.content;
    
    CGFloat height = 260;
    [self.customTxView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(20);
        make.left.equalTo(self.view).offset(10);
        make.right.equalTo(self.view).offset(-10);
        make.height.mas_equalTo(@(height));
    }];
    
    [self.numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.equalTo(self.customTxView).offset(-5);
    }];
    self.numLabel.text = [NSString stringWithFormat:@"%lu/%d", (unsigned long)self.content.length, kNOTICE_MAX_LENGTH];
}


#pragma mark - Request

- (void)saveAction {
    if (self.isSetting) {
        if (self.modifyGroupBlock) {
            self.modifyGroupBlock(self.type == ModifyGroupTypeName ? self.textField.text : self.customTxView.text);
        }
        [self.navigationController popViewControllerAnimated:YES];
    }else {
        
        [self requestUpdate];
    }
}


/// 群公告,名称修改
- (void)requestUpdate {
    if (!self.groupID.length) {
        return;
    }
    
    if (self.type == ModifyGroupTypeName) {
        if (self.textField.text.length == 0) {
             SVP_ERROR_STATUS(NSLocalizedString(@"群名称不可为空", nil));
             return;
         }else if (self.textField.text.length > kGROUPED_MAX_LENGTH) {
             SVP_ERROR_STATUS(NSLocalizedString(@"群名称长度超出", nil));
             return;
         }
        
         NSDictionary *dict = @{
                                @"id": self.groupID,
                                @"chatgName": self.textField.text,
                                };
        PROGRESS_HUD_SHOW
        [NET_REQUEST_MANAGER groupEditorName:dict successBlock:^(NSDictionary *success) {
            PROGRESS_HUD_DISMISS
            if ([success[@"code"] integerValue ] == 0) {
                if (self.modifyGroupBlock != nil) {
                    self.modifyGroupBlock(self.textField.text);
                }
                
                [self updateGroupInfoWithId:self.groupID];
                [self updateSuccess:success[@"alterMsg"]];
            }else{
                SVP_ERROR_STATUS(success[@"alterMsg"]);
            }
        } failureBlock:^(NSError *failure) {
            PROGRESS_HUD_DISMISS
            [[FunctionManager sharedInstance] handleFailResponse:failure];
        }];
    }else {
        if (self.customTxView.text.length == 0) {
            SVP_ERROR_STATUS(NSLocalizedString(@"群公告不可为空", nil));
            return;
        }
        if (self.customTxView.text.length > kNOTICE_MAX_LENGTH) {
            SVP_ERROR_STATUS(NSLocalizedString(@"群公告长度超出", nil));
            return;
        }
        
        NSLog(@"%@",self.customTxView.text);
        NSDictionary *dict = @{@"id": self.groupID,
                                @"notice": self.customTxView.text};
        
        PROGRESS_HUD_SHOW
        [NET_REQUEST_MANAGER groupEditorNotice:dict successBlock:^(NSDictionary *success) {
            PROGRESS_HUD_DISMISS
            NSLog(@"%@",success);
            if ([success[@"code"] integerValue ] == 0) {
                if (self.modifyGroupBlock != nil) {
                    self.modifyGroupBlock(self.customTxView.text);
                }
                [self updateSuccess:success[@"alterMsg"]];
            }else{
                SVP_ERROR_STATUS(success[@"alterMsg"]);
            }
        } failureBlock:^(NSError *failure) {
            
            PROGRESS_HUD_DISMISS
            [[FunctionManager sharedInstance] handleFailResponse:failure];
        }];
    }
}

- (void)updateSuccess:(NSString *)msg
{
    [SVProgressHUD showSuccessWithStatus:msg];
    [[NSNotificationCenter defaultCenter] postNotificationName:kReloadMyMessageGroupList object:nil];
    [self.navigationController popViewControllerAnimated:YES];
    
    // 更新自己的群组信息
    [[IMGroupModule sharedInstance] handleUpdateAllGroupEntitys:^(BOOL success) {
        [NOTIF_CENTER postNotificationName:kNotificationModifyUpdateGroupInfo object:nil];
    }];
}

- (void)updateGroupInfoWithId:(NSString *)groupId {
    if (self.groupInfo != nil) {
        MessageItem *msgItem = self.groupInfo;
        msgItem.groupId = groupId;
        msgItem.chatgName = self.textField.text;
        
        FYContacts *contacts = [[IMSessionModule sharedInstance] getSessionWithSessionId:groupId];
        if (contacts != nil) {
            contacts.name = self.textField.text;
            [[IMSessionModule sharedInstance] updateSeesion:contacts];
        }
        
        [[IMGroupModule sharedInstance] updateGroupWithGroupId:msgItem];
    }
}

#pragma mark - Getters

- (UITextField *)textField {
    
    if (!_textField) {
        _textField = [[UITextField alloc]init];
        _textField.font = [UIFont systemFontOfSize:14];
        _textField.backgroundColor = UIColor.whiteColor;
        UIView *leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, 20)];
        _textField.leftView = leftView;
        _textField.layer.masksToBounds = YES;
        _textField.layer.cornerRadius = 4;
        _textField.delegate = self;
        _textField.leftViewMode = UITextFieldViewModeAlways;
        _textField.placeholder = [NSString stringWithFormat:NSLocalizedString(@"限制为1~%d个字符", nil), kGROUPED_MAX_LENGTH];
    }
    return _textField;
}

- (UIButton *)confirmBtn {
    
    if (!_confirmBtn) {
        _confirmBtn = [[UIButton alloc]init];
        [_confirmBtn setTitle:NSLocalizedString(@"完成", nil) forState:UIControlStateNormal];
        [_confirmBtn setTitleColor:COLOR_SYSTEM_MAIN_FONT_DEFAULT forState:UIControlStateNormal];
        _confirmBtn.titleLabel.font = [UIFont systemFontOfSize:CFC_AUTOSIZING_FONT(16)];
        [_confirmBtn addTarget:self action:@selector(saveAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _confirmBtn;
}


- (UITextPlaceholderView *)customTxView {
    
    if (!_customTxView) {
        _customTxView = [[UITextPlaceholderView alloc]init];
        _customTxView.delegate = self;
        _customTxView.font = [UIFont systemFontOfSize:14];
        _customTxView.textColor = UIColor.blackColor;
        _customTxView.layer.masksToBounds = YES;
        _customTxView.layer.cornerRadius = 4;
        _customTxView.placeholder = [NSString stringWithFormat:NSLocalizedString(@"限制1~%d个字符", nil), kNOTICE_MAX_LENGTH];
    }
    return _customTxView;
}

- (UILabel *)numLabel{
    
    if (!_numLabel) {
        _numLabel = [[UILabel alloc]init];
        _numLabel.font = [UIFont systemFontOfSize:12];
        _numLabel.textColor = UIColor.lightGrayColor;
        _numLabel.text = @"0/900";
    }
    return _numLabel;
}

#pragma mark - <UITextFieldDelegate>

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (toBeString.length > kGROUPED_MAX_LENGTH && range.length != 1){
        textField.text = [toBeString substringToIndex:kGROUPED_MAX_LENGTH];
        return NO;
    }
    return YES;
}

#pragma mark - <UITextViewDelegate>

- (void)textViewDidChange:(UITextView *)textView {
    
    self.numLabel.text = [NSString stringWithFormat:@"%ld/%d",self.customTxView.text.length, kNOTICE_MAX_LENGTH];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    //判断加上输入的字符，是否超过界限
    NSString *str = [NSString stringWithFormat:@"%@%@", textView.text, text];
    if (str.length > kNOTICE_MAX_LENGTH) {
        NSRange rangeIndex = [str rangeOfComposedCharacterSequenceAtIndex:kNOTICE_MAX_LENGTH];
        
        if (rangeIndex.length == 1) //字数超限
        {
            textView.text = [str substringToIndex:kNOTICE_MAX_LENGTH];
            //这里重新统计下字数，字数超限，我发现就不走textViewDidChange方法了，你若不统计字数，忽略这行
            self.numLabel.text = [NSString stringWithFormat:@"%lu/%d",self.customTxView.text.length, kNOTICE_MAX_LENGTH];
        }else{
            NSRange rangeRange = [str rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, kNOTICE_MAX_LENGTH)];
            textView.text = [str substringWithRange:rangeRange];
        }
        
        return NO;
    }
    
    return YES;
}

#pragma mark - dealloc

- (void)dealloc
{
     [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
