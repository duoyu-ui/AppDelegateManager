//
//  ForgotViewController.m
//  Project
//
//  Created by mini on 2018/7/31.
//  Copyright © 2018年 CDJay. All rights reserved.
//

#import "ForgotViewController.h"

@interface ForgotViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>{
    UITextField *_textField[5];
}

@property (nonatomic, strong) UIButton *codeBtn;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray *dataList;

@property (nonatomic, strong) UILabel *sexLabel;

@end

@implementation ForgotViewController

#pragma mark - Getter

- (NSArray *)dataList {
    
    if (!_dataList) {
        _dataList = @[@{@"title":NSLocalizedString(@"请输入手机号", nil), @"img": @"icon_phone"},
                      @{@"title":NSLocalizedString(@"请输入验证码", nil), @"img":@"icon_security"},
                      @{@"title":NSLocalizedString(@"请输入密码", nil), @"img":@"icon_lock"},
                      @{@"title":NSLocalizedString(@"请确认密码", nil), @"img":@"icon_lock"}];
    }
    return _dataList;
}

#pragma mark - Life cycle

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [SVProgressHUD dismiss];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if(_textField[0].text.length == 0)
        [_textField[0] becomeFirstResponder];
    else {
        [_textField[1] becomeFirstResponder];
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.title.length < 1) {
        self.navigationItem.title = NSLocalizedString(@"重设密码", nil);
    }
    
    
    [self setupSubview];
}

- (void)setupSubview {
    _tableView = [UITableView groupTable];
    [self.view addSubview:_tableView];
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = BaseColor;
    _tableView.backgroundView = view;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 52;
    _tableView.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
    _tableView.backgroundColor = BaseColor;
    _tableView.separatorColor = TBSeparaColor;
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 80)];
    _tableView.tableFooterView = footerView;
    
    UIButton *submitBtn = [UIButton new];
    [footerView addSubview:submitBtn];
    submitBtn.titleLabel.font = [UIFont boldSystemFontOfSize2:17];
    [submitBtn setTitle:NSLocalizedString(@"提交", nil) forState:UIControlStateNormal];
    [submitBtn addTarget:self action:@selector(action_submit) forControlEvents:UIControlEventTouchUpInside];
    [submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    submitBtn.layer.cornerRadius = 8.0f;
    submitBtn.layer.masksToBounds = YES;
    submitBtn.backgroundColor = MBTNColor;
    [submitBtn delayEnable];
    [submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(16));
        make.right.equalTo(self.view.mas_right).offset(-20);
        make.height.equalTo(@(44));
        make.top.equalTo(footerView.mas_top).offset(16);
    }];
    
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

#pragma mark - UITableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:0 reuseIdentifier:@"cell"];
        
        if (indexPath.row == 1) {
            _codeBtn = [UIButton new];
            [cell.contentView addSubview:_codeBtn];
            [_codeBtn setTitle:NSLocalizedString(@"获取验证码", nil) forState:UIControlStateNormal];
            [_codeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            _codeBtn.titleLabel.font = [UIFont systemFontOfSize:13];
            _codeBtn.layer.cornerRadius = 6;
            _codeBtn.layer.masksToBounds = YES;
            _codeBtn.backgroundColor = COLOR_X(244, 112, 35);//[UIColor colorWithHexString:@""];
            [_codeBtn addTarget:self action:@selector(action_getCode) forControlEvents:UIControlEventTouchUpInside];
            
            [_codeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(cell.contentView.mas_right).offset(-15);
                make.centerY.equalTo(cell.contentView.mas_centerY);
                make.height.equalTo(@(30));
                make.width.equalTo(@(86));
            }];
        }
        
        _textField[indexPath.row] = [UITextField new];
        [cell.contentView addSubview:_textField[indexPath.row]];
        _textField[indexPath.row].placeholder = self.dataList[indexPath.row][@"title"];
        _textField[indexPath.row].font = [UIFont systemFontOfSize2:15];
        _textField[indexPath.row].clearButtonMode = UITextFieldViewModeWhileEditing;
        _textField[indexPath.row].delegate = self;
        CGFloat r = (indexPath.row == 1)?116:15;
        [_textField[indexPath.row] mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(cell.contentView.mas_left).offset(50);
            make.top.bottom.equalTo(cell.contentView);
            make.right.equalTo(cell.contentView.mas_right).offset(-r);
        }];
        if(indexPath.row == 0){
            _textField[indexPath.row].keyboardType = UIKeyboardTypePhonePad;
            NSString *mobile = GetUserDefaultWithKey(@"mobile");
            _textField[indexPath.row].text = ![FunctionManager isEmpty:mobile]?mobile:@"";
        }
        if(indexPath.row == 2 || indexPath.row == 3){
            _textField[indexPath.row].secureTextEntry = YES;
        }
        if(indexPath.row != 3)
            _textField[indexPath.row].returnKeyType = UIReturnKeyNext;
        else
            _textField[indexPath.row].returnKeyType = UIReturnKeyDone;
    }
    cell.imageView.image = [UIImage imageNamed:self.dataList[indexPath.row][@"img"]];
    return cell;
}


#pragma mark - Action

- (void)action_getCode {
    NSString *phone = _textField[0].text;
    if (phone.length < 8 || ![[FunctionManager sharedInstance] checkIsNum:phone]) {
        SVP_ERROR_STATUS(NSLocalizedString(@"请输入正确的手机号", nil));
        return;
    }
    [_textField[1] becomeFirstResponder];
    SVP_SHOW;
    WEAK_OBJ(weakSelf, self);
    if ([self.title isEqualToString:NSLocalizedString(@"绑定手机", nil)]) {
        //GetSmsCodeFromVCRegister
        [NET_REQUEST_MANAGER requestSmsCodeWithPhone:_textField[0].text type:GetSmsCodeBindPhone success:^(id object) {
            SVP_SUCCESS_STATUS(NSLocalizedString(@"发送成功，请注意查收短信", nil));
            int time = ![FunctionManager isEmpty:object[@"data"]]?[object[@"data"] intValue]:60;
            [weakSelf.codeBtn beginTime:time];
        } fail:^(id object) {
            [[FunctionManager sharedInstance] handleFailResponse:object];
        }];
    }else{
        [NET_REQUEST_MANAGER requestSmsCodeWithPhone:_textField[0].text type:GetSmsCodeFromVCResetPW success:^(id object) {
            SVP_SUCCESS_STATUS(NSLocalizedString(@"发送成功，请注意查收短信", nil));
            int time = ![FunctionManager isEmpty:object[@"data"]]?[object[@"data"] intValue]:60;
            [weakSelf.codeBtn beginTime:time];
        } fail:^(id object) {
            [[FunctionManager sharedInstance] handleFailResponse:object];
        }];
    }
    
}

- (void)action_submit {
    if (_textField[0].text.length < 8) {
        SVP_ERROR_STATUS(NSLocalizedString(@"请输入正确的手机号", nil));
        return;
    }
    if (_textField[1].text.length < 3) {
        SVP_ERROR_STATUS(NSLocalizedString(@"请输入正确的验证码", nil));
        return;
    }
    if (_textField[2].text.length > 16 || _textField[2].text.length < 6) {
        SVP_ERROR_STATUS(NSLocalizedString(@"请输入6-16位密码", nil));
        return;
    }
    if (_textField[3].text.length > 16 || _textField[3].text.length < 6) {
        SVP_ERROR_STATUS(NSLocalizedString(@"请输入6-16位确认密码", nil));
        return;
    }
    if (![_textField[2].text isEqualToString:_textField[3].text]) {
        SVP_ERROR_STATUS(NSLocalizedString(@"密码不一致", nil));
        return;
    }
    
    SVP_SHOW;
    WEAK_OBJ(weakSelf, self);
    if ([self.title isEqualToString:NSLocalizedString(@"绑定手机", nil)]) {
        NSString *mobile=_textField[0].text;
        NSString *code=_textField[1].text;
        NSString *password=_textField[2].text;
        NSDictionary *sender=@{@"mobile":mobile,
                               @"code":code,
                               @"password":password};
        [NET_REQUEST_MANAGER toBindPhone:sender successBlock:^(NSDictionary *success) {
            SVP_SUCCESS_STATUS(NSLocalizedString(@"绑定成功", nil));
//            NSLog(@"%@",success);
            SetUserDefaultKeyWithObject(@"mobilemobile", mobile);
            [[AppModel shareInstance] logout];
        } failureBlock:^(NSError *failure) {
            [[FunctionManager sharedInstance] handleFailResponse:failure];
        }];
    }else{
        [NET_REQUEST_MANAGER findPasswordWithPhone:_textField[0].text smsCode:_textField[1].text password:_textField[2].text success:^(id object) {
            SVP_SUCCESS_STATUS(NSLocalizedString(@"重设成功，请重新登录", nil));
            [weakSelf.navigationController popViewControllerAnimated:YES];
        } fail:^(id object) {
            [[FunctionManager sharedInstance] handleFailResponse:object];
        }];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if(textField == _textField[0])
        [_textField[1] becomeFirstResponder];
    else if(textField == _textField[1])
        [_textField[2] becomeFirstResponder];
    else if(textField == _textField[2])
        [_textField[3] becomeFirstResponder];
    else
        [textField resignFirstResponder];
    return YES;
}

@end
