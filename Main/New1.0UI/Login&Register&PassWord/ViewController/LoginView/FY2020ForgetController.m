//
//  FY2020ForgetController.m
//  FY_OC
//
//  Created by FangYuan on 2020/1/31.
//  Copyright © 2020 FangYuan. All rights reserved.
//

#import "FY2020ForgetController.h"
#import "FY2020LoginCell.h"

@interface FY2020ForgetController ()<UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UIImageView *bottomImage;
@property (nonatomic, strong) NSArray *datalist;

@end

@implementation FY2020ForgetController

#pragma mark - Navigation

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}


#pragma mark - Life Cycle


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [self doTranslucentNavigationBar:YES];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    [self doTranslucentNavigationBar:YES];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [self doTranslucentNavigationBar:NO];
}

- (void)doTranslucentNavigationBar:(BOOL)hidde
{
    if (self.isNeedChangeNavigation) {
        if (hidde) {
            self.navigationController.navigationBar.translucent = YES;
            [self.navigationController.navigationBar setShadowImage:[UIImage new]];
            [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
        } else {
            UIImage *image=[[UIImage imageNamed:@"navBarBg"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
            self.navigationController.navigationBar.translucent = NO;
        }
    }
}


- (void)viewDidLoad
{
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor colorWithWhite:0.93725 alpha:1];
    [self initForgetData];
    self.tableView.dataSource = self;
}

-(void)initForgetData
{
    self.datalist = @[
        [FYFieldModel key:@"mobile_1" value:@"" place:NSLocalizedString(@"手机号", nil) require:YES],
        [FYFieldModel key:@"mobile_code_1" value:@"" place:NSLocalizedString(@"请输入验证码", nil) require:YES],
        [FYFieldModel key:@"passwd" value:@"" place:NSLocalizedString(@"请输入密码", nil) require:YES],
        [FYFieldModel key:@"passwd_re" value:@"" place:NSLocalizedString(@"请确定密码", nil) require:YES]
    ];
    [self.tableView reloadData];
}

-(FYFieldModel *)getCellDataWithCode:(NSString *)key{
    for (FYFieldModel *temp in self.datalist) {
        if ([temp.key isEqualToString:key]) {
            return temp;
        }
    }
    return nil;
}

-(void)buttonAction:(UIButton *)sender{
    if (sender.tag == 100) {
        //提交
        [self HTTPActionSubmit];
    }else if (sender.tag == 99){
        //验证码
        [self HTTPGetPhoneCode:sender];
    }else if (sender.tag == 400){
        [self feedback];
    }
}
- (void)feedback
{
    WebViewController *vc = [[WebViewController alloc] initWithUrl:[AppModel shareInstance].commonInfo[@"pop"]];
    vc.title = NSLocalizedString(@"联系客服", nil);
    [self.navigationController pushViewController:vc animated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return self.datalist.count;
    }else if (section == 1){
        if ([self.title isEqualToString:NSLocalizedString(@"忘记密码", nil)]) {
            return 1;
        }
        return 0;
    }
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        FYFieldModel *model = [self.datalist objectAtIndex:indexPath.row];
        NSString *cellIdentifier = [NSString stringWithFormat:@"cell%@",model.key];
        FY2020LoginInputCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell) {
            cell=[[FY2020LoginInputCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            cell.model = model;
            if ([model.key isEqualToString:@"mobile_1"]) {
                cell.buttonCode.tag = 99;
                [cell.buttonCode addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
            }
            if ([model.key isEqualToString:@"passwd"]) {
                cell.field.rightViewMode = UITextFieldViewModeNever;
            }
        }
        return cell;
    }else if (indexPath.section == 1){
        FY2020LoginRightButtonCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FY2020LoginRightButtonCell"];
        NSMutableAttributedString *msg=[NSMutableAttributedString new];
        [msg appendAttributedString:[[NSAttributedString alloc] initWithString:NSLocalizedString(@"未绑定手机号", nil) attributes:@{NSForegroundColorAttributeName:[UIColor grayColor]}]];
        [msg appendAttributedString:[[NSAttributedString alloc] initWithString:NSLocalizedString(@"请联系客服", nil) attributes:@{NSForegroundColorAttributeName:[UIColor redColor]}]];
        cell.button.tag = 400;
        [cell.button setAttributedTitle:msg forState:UIControlStateNormal];
        [cell.button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }else if (indexPath.section == 2){
        FY2020LoginActionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FY2020LoginActionCell"];
        cell.buttonLogin.tag = 100;
//        cell.buttonOther.hidden = YES;
        [cell.buttonLogin setTitle:NSLocalizedString(@"提交", nil) forState:UIControlStateNormal];
        [cell.buttonLogin addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }
    FY2020LoginCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FY2020LoginCell"];
    return cell;
}

- (void)HTTPGetPhoneCode:(UIButton *)sender
{
    [self.view endEditing:YES];
    FYFieldModel *model = [self getCellDataWithCode:@"mobile_1"];
    NSString *phone = model.value;
    if (phone.length < 8 || ![[FunctionManager sharedInstance] checkIsNum:phone]) {
        SVP_ERROR_STATUS(NSLocalizedString(@"请输入正确的手机号", nil));
        return;
    }
    SVP_SHOW;
    if ([self.title isEqualToString:NSLocalizedString(@"绑定手机", nil)]) {
        //GetSmsCodeFromVCRegister
        [NET_REQUEST_MANAGER requestSmsCodeWithPhone:phone type:GetSmsCodeBindPhone success:^(id object) {
            SVP_SUCCESS_STATUS(NSLocalizedString(@"发送成功，请注意查收短信", nil));
            int time = ![FunctionManager isEmpty:object[@"data"]]?[object[@"data"] intValue]:60;
            [sender beginTime:time];
        } fail:^(id object) {
            [[FunctionManager sharedInstance] handleFailResponse:object];
        }];
    }else if ([self.title isEqualToString:NSLocalizedString(@"重设支付密码", nil)]){
        [NET_REQUEST_MANAGER requestSmsCodeWithPhone:phone type:GetSmsCodeFromVCPayPW success:^(id object) {
            SVP_SUCCESS_STATUS(NSLocalizedString(@"发送成功，请注意查收短信", nil));
            int time = ![FunctionManager isEmpty:object[@"data"]]?[object[@"data"] intValue]:60;
            [sender beginTime:time];
        } fail:^(id object) {
            [[FunctionManager sharedInstance] handleFailResponse:object];
        }];
    }else{
        [NET_REQUEST_MANAGER requestSmsCodeWithPhone:phone type:GetSmsCodeFromVCResetPW success:^(id object) {
            SVP_SUCCESS_STATUS(NSLocalizedString(@"发送成功，请注意查收短信", nil));
            int time = ![FunctionManager isEmpty:object[@"data"]]?[object[@"data"] intValue]:60;
            [sender beginTime:time];
        } fail:^(id object) {
            [[FunctionManager sharedInstance] handleFailResponse:object];
        }];
    }
    
}

- (void)HTTPActionSubmit
{
    [self.view endEditing:YES];
    NSString *mobile=@"";
    NSString *code=@"";
    NSString *password=@"";
    for (FYFieldModel *model in self.datalist) {
        if ([model.key isEqualToString:@"mobile_1"]) {
            if (model.value.length < 8) {
                SVP_ERROR_STATUS(NSLocalizedString(@"请输入正确的手机号", nil));
                return;
            }
            mobile = model.value;
        }else if ([model.key isEqualToString:@"mobile_code_1"]) {
            if (model.value.length < 3) {
                SVP_ERROR_STATUS(NSLocalizedString(@"请输入正确的验证码", nil));
                return;
            }
            code = model.value;
        }else if ([model.key isEqualToString:@"passwd"]){
            if (model.value.length < 6 || model.value.length > 16) {
                SVP_ERROR_STATUS(NSLocalizedString(@"请输入6-16位密码", nil));
                return;
            }
            password = model.value;
        }else if ([model.key isEqualToString:@"passwd_re"]){
            if (![model.value isEqualToString:password]) {
                SVP_ERROR_STATUS(NSLocalizedString(@"密码不一致", nil));
                return;
            }
        }
    }
    
    SVP_SHOW;
    WEAK_OBJ(weakSelf, self);
    if ([self.title isEqualToString:NSLocalizedString(@"绑定手机", nil)]) {
        NSDictionary *sender=@{@"mobile":mobile,
                               @"code":code,
                               @"password":password};
        [NET_REQUEST_MANAGER toBindPhone:sender successBlock:^(NSDictionary *success) {
            SVP_SUCCESS_STATUS(NSLocalizedString(@"绑定成功", nil));
            SetUserDefaultKeyWithObject(@"mobilemobile", mobile);
            [[AppModel shareInstance] logout];
        } failureBlock:^(NSError *failure) {
            [[FunctionManager sharedInstance] handleFailResponse:failure];
        }];
    }else if ([self.title isEqualToString:NSLocalizedString(@"重设支付密码", nil)]){
        [NET_REQUEST_MANAGER setPayPasswordWithPhone:mobile smsCode:code password:password success:^(id object) {
            
            SVP_SUCCESS_STATUS(NSLocalizedString(@"支付密码设置成功!", nil));
            [weakSelf.navigationController popViewControllerAnimated:YES];
        } fail:^(id object) {
            [[FunctionManager sharedInstance] handleFailResponse:object];
        }];
    }else{
        [NET_REQUEST_MANAGER findPasswordWithPhone:mobile smsCode:code password:password success:^(id object) {
            SVP_SUCCESS_STATUS(NSLocalizedString(@"重设成功，请重新登录", nil));
            [weakSelf.navigationController popViewControllerAnimated:YES];
        } fail:^(id object) {
            [[FunctionManager sharedInstance] handleFailResponse:object];
        }];
    }
    
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            // Fallback on earlier versions
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
        [self.view addSubview:_tableView];
        _tableView.backgroundColor = [UIColor colorWithWhite:0.93725 alpha:1];
        _tableView.tableFooterView = [UIView new];
        _tableView.bounces = NO;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.translatesAutoresizingMaskIntoConstraints = NO;
        [_tableView.topAnchor constraintEqualToAnchor:self.view.topAnchor].active = YES;
        [_tableView.leftAnchor constraintEqualToAnchor:self.view.leftAnchor].active = YES;
        [_tableView.rightAnchor constraintEqualToAnchor:self.view.rightAnchor].active = YES;
        [_tableView.bottomAnchor constraintEqualToAnchor:self.bottomImage.topAnchor].active = YES;
        _tableView.tableHeaderView = self.headerView;
        [_tableView registerClass:[FY2020LoginActionCell class] forCellReuseIdentifier:@"FY2020LoginActionCell"];
        [_tableView registerClass:[FY2020LoginRightButtonCell class] forCellReuseIdentifier:@"FY2020LoginRightButtonCell"];
    }
    return _tableView;
}

- (UIView *)headerView
{
    if (!_headerView) {
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 140)];
        _headerView.backgroundColor = [UIColor colorWithWhite:0.93725 alpha:1];
        UIImageView *imageView= [UIImageView new];
        imageView.image = [UIImage imageNamed:@"icon_forget_top"];
        [_headerView addSubview:imageView];
        imageView.translatesAutoresizingMaskIntoConstraints = NO;
        [imageView.leftAnchor constraintEqualToAnchor:_headerView.leftAnchor].active = YES;
        [imageView.topAnchor constraintEqualToAnchor:_headerView.topAnchor].active = YES;
        [imageView.rightAnchor constraintEqualToAnchor:_headerView.rightAnchor].active = YES;
        [imageView.heightAnchor constraintEqualToAnchor:imageView.widthAnchor multiplier:221.0/719].active = YES;
    }
    return _headerView;
}

- (UIImageView *)bottomImage
{
    if (!_bottomImage) {
        _bottomImage = [UIImageView new];
        _bottomImage.image = [UIImage imageNamed:@"icon_login_bottom"];
        [self.view addSubview:_bottomImage];
        _bottomImage.translatesAutoresizingMaskIntoConstraints = NO;
        [_bottomImage.leftAnchor constraintEqualToAnchor:self.view.leftAnchor].active = YES;
        [_bottomImage.rightAnchor constraintEqualToAnchor:self.view.rightAnchor].active = YES;
        [_bottomImage.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor].active = YES;
        [_bottomImage.heightAnchor constraintEqualToAnchor:self.view.widthAnchor multiplier:65.0/719].active = YES;
    }
    return _bottomImage;
}

@end
