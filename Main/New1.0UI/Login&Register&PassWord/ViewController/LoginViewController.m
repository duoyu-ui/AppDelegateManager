//
//  LoginViewController.m
//  Project
//
//  Created by mini on 2018/7/31.
//  Copyright © 2018年 CDJay. All rights reserved.
//

#import "LoginViewController.h"
#import "WebViewController.h"
#import "GTMBase64.h"
#import "NSData+AES.h"
#import "NetRequestManager.h"
#import "AddIpViewController.h"
#import "SAMKeychain.h"
#import "RSA.h"
#import "LoginRegisterModel.h"
#import "LaunchFristPageVC.h"

@interface LoginViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,ActionSheetDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataList;
@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, copy) NSString *accountNum;
@property (nonatomic, strong) UIButton *codeBtn;
@property (nonatomic, strong) FLAnimatedImageView *vertifyImgBtn;
@property (nonatomic, copy) NSData *imageCaptchaData;
@property (nonatomic, copy) NSString *rsaGenerated;
@property (nonatomic, assign) BOOL isHavePictureCode;
@property (nonatomic, strong) UIButton *buttonLoginStyleChange;
@end

@implementation LoginViewController

#pragma mark - Getter

- (NSMutableArray *)dataList {
    
    if (!_dataList) {
        
        _dataList = [NSMutableArray arrayWithCapacity:4];
    }
    return _dataList;
}

#pragma mark - life cycle

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [SVProgressHUD dismiss];
}

- (void)viewDidAppear:(BOOL)animated {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *mobile = [ud objectForKey:@"mobile"];
    if(mobile == nil) {
        NSArray *accounts = [SAMKeychain accountsForService:@"com.fy.ser"];
        if(accounts.count > 0) {
            NSDictionary *object = accounts[0];
            mobile = object[@"acct"];
        }
    }
    [AppModel debugShowCurrentUrl];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadLoginInfo];
    [self setupSubview];
}

- (void)setupSubview {
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 40)];
    titleLabel.font = [UIFont systemFontOfSize:20];
    titleLabel.text = NSLocalizedString(@"登录", nil);
    titleLabel.textColor = UIColor.whiteColor;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = titleLabel;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"线路切换", nil) style:UIBarButtonItemStyleDone target:self action:@selector(showPingVC)];
    self.tableView = [UITableView groupTable];
    self.tableView.backgroundColor = BaseColor;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 52.f;
    [self.tableView setSeparatorInset:UIEdgeInsetsMake(0, 15, 0, 0)];
    self.tableView.separatorColor = TBSeparaColor;
    self.tableView.backgroundColor = BaseColor;
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadLoginInfo)];
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 300)];
    self.tableView.tableFooterView = footerView;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    UIButton *forgetBtn = [UIButton new];
        [forgetBtn setTitle:NSLocalizedString(@"忘记密码?", nil) forState:UIControlStateNormal];
        [forgetBtn setTitleColor:MBTNColor forState:UIControlStateNormal];
        forgetBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [footerView addSubview:forgetBtn];
        [forgetBtn addTarget:self action:@selector(action_forgot) forControlEvents:UIControlEventTouchUpInside];
        [forgetBtn delayEnable];
        [forgetBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.view.mas_right).offset(-30);
            make.top.mas_equalTo(1);
            make.height.equalTo(@(30));
        }];
    
    UIButton *loginBtn = [UIButton new];
    [footerView addSubview:loginBtn];
    loginBtn.layer.cornerRadius = 8;
    loginBtn.layer.masksToBounds = YES;
    loginBtn.backgroundColor = MBTNColor;
    [loginBtn az_setGradientBackgroundWithColors:@[HEXCOLOR(0xfe3366),HEXCOLOR(0xff733d)] locations:0 startPoint:CGPointMake(0, 0) endPoint:CGPointMake(1, 0)];
    loginBtn.titleLabel.font = [UIFont boldSystemFontOfSize2:17];
    [loginBtn setTitle:NSLocalizedString(@"登录", nil) forState:UIControlStateNormal];
    [loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [loginBtn addTarget:self action:@selector(loginAction) forControlEvents:UIControlEventTouchUpInside];
    [loginBtn delayEnable];
    [loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(16);
        make.right.equalTo(self.view.mas_right).offset(-16);
        make.top.equalTo(forgetBtn.mas_bottom).offset(10);
        make.height.equalTo(@(44));
    }];
    
    // 登录/注册
    UIButton *doneButton = [UIButton new];
    [footerView addSubview:doneButton];
    doneButton.backgroundColor = [UIColor clearColor];
    doneButton.titleLabel.font = [UIFont boldSystemFontOfSize2:16];
    [doneButton setTitle:NSLocalizedString(@"短信验证码登录", nil) forState:UIControlStateNormal];
    [doneButton setTitleColor:UIColor.redColor forState:UIControlStateNormal];
    [doneButton addTarget:self action:@selector(actionChangeLoginStyle:) forControlEvents:UIControlEventTouchUpInside];
    [doneButton delayEnable];
    doneButton.hidden = YES;
    self.buttonLoginStyleChange = doneButton;
    [doneButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(200);
        make.top.equalTo(loginBtn.mas_bottom).offset(15);
        make.height.equalTo(@(36));
        make.centerX.mas_equalTo(0);
    }];
    
    UIView *thirdView = [UIView new];
    [footerView addSubview:thirdView];
    thirdView.hidden = NO;
    [thirdView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(footerView);
        make.top.equalTo(doneButton.mas_bottom).offset(50);
    }];
    
    UILabel *thirdLabel = [UILabel new];
    [thirdView addSubview:thirdLabel];
    thirdLabel.font = [UIFont systemFontOfSize2:14];
    thirdLabel.text = NSLocalizedString(@"登录失败？请联系客服", nil);
    thirdLabel.textColor = Color_9;
    
    [thirdLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.top.equalTo(thirdView);
    }];
    
    UIView *leftLineView = [UIView new];
    [thirdView addSubview:leftLineView];
    leftLineView.backgroundColor = COLOR_X(210, 210, 210);
    
    [leftLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(thirdView.mas_left).offset(15);
        make.right.greaterThanOrEqualTo(thirdLabel.mas_left).offset(-15);
        make.centerY.equalTo(thirdLabel.mas_centerY);
        make.height.equalTo(@(1.0));
    }];
    
    UIView *rightLineView = [UIView new];
    [thirdView addSubview:rightLineView];
    rightLineView.backgroundColor = COLOR_X(210, 210, 210);
    [rightLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.lessThanOrEqualTo(thirdLabel.mas_right).offset(15);
        make.right.equalTo(thirdView.mas_right).offset(-15);
        make.height.equalTo(@(1.0));
        make.centerY.equalTo(thirdLabel.mas_centerY);
    }];
    
    UIButton *wx = [UIButton new];
    [thirdView addSubview:wx];
    [wx setBackgroundImage:[UIImage imageNamed:@"serverIcon"] forState:UIControlStateNormal];
    [wx addTarget:self action:@selector(feedback) forControlEvents:UIControlEventTouchUpInside];
    
    [wx mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(thirdView);
        make.top.equalTo(thirdLabel.mas_bottom).offset(25);
    }];
    
    UILabel *versionLabel = [UILabel new];
    [self.view addSubview:versionLabel];
    versionLabel.font = [UIFont systemFontOfSize:13];
    versionLabel.textAlignment = NSTextAlignmentCenter;
    #ifdef DEBUG
        versionLabel.text = [NSString stringWithFormat:@"debug v%@",[[FunctionManager sharedInstance] getApplicationVersion]];
    #else
        versionLabel.text = [NSString stringWithFormat:@"v%@",[[FunctionManager sharedInstance] getApplicationVersion]];
    #endif
    versionLabel.textColor = COLOR_X(200, 200, 200);
    
    [versionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.bottom.equalTo(self.view.mas_bottom).offset(-15);
    }];
}


#pragma mark - Request

- (void)loadLoginInfo {
//    [self.dataList addObject:@{kTit:NSLocalizedString(@"手机", nil),
//                               kImg:@"icon_phone",
//                               kType:@(EnumActionTag0),
//                               kSubTit:@"mobile",
//                               kIsOn:@"1"}];
//    [self.dataList addObject:@{kTit:NSLocalizedString(@"密码", nil),
//                               kImg:@"icon_lock",
//                               kType:@(EnumActionTag2),
//                               kSubTit:@"passwd",
//                               kIsOn:@"1"}];
    [SVProgressHUD show];
    WEAK_OBJ(weakSelf, self);
    [NET_REQUEST_MANAGER checkLoginWithDic:nil success:^(id object) {
        [SVProgressHUD dismiss];
        [weakSelf.tableView.mj_header endRefreshing];
        if (self.dataList.count > 0) {
            [self.dataList removeAllObjects];
        }

        LoginRegisterModel *model = [LoginRegisterModel mj_objectWithKeyValues:object];
        [weakSelf.dataList addObjectsFromArray:[model getLoginTypes]];
        
        
        weakSelf.rsaGenerated = [RSA randomlyGenerated16BitString];
        [weakSelf loadDataIfNeeded:weakSelf.rsaGenerated];
        [weakSelf checkInitInputData];
        

    } fail:^(id object) {
        [weakSelf.tableView.mj_header endRefreshing];
//        [[FunctionManager sharedInstance] handleFailResponse:object];
        [SVProgressHUD dismiss];

        [self showAlert];
    }];
}
- (void)showAlert{
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"线路切换", nil) message:NSLocalizedString(@"网络不好,请切换线路试试吧", nil) preferredStyle:UIAlertControllerStyleAlert];
    
    [alertVC addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"取消", nil) style:UIAlertActionStyleCancel handler:nil]];
    
    [alertVC addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"确认", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self showPingVC];
    }]];
    
    [self presentViewController:alertVC animated:YES completion:nil];
}
- (void)showPingVC{
    PingViewController *vc = [[PingViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)loadDataIfNeeded:(NSString *)rsaGenerated {
    WEAK_OBJ(weakSelf, self);
    [NET_REQUEST_MANAGER requestImageCaptchaWithPhone:rsaGenerated type:GetSmsCodeFromVCLoginBySMS success:^(id object) {
        [SVProgressHUD dismiss];
        weakSelf.imageCaptchaData = object;
        [weakSelf.tableView reloadData];
    } fail:^(id object) {
        [[FunctionManager sharedInstance] handleFailResponse:object];
        [weakSelf.tableView reloadData];
    }];
}

#pragma mark - Action

- (void)envirmentBtnClick {
    
    [self accountSwitch];
}

- (void)tenantBtnClick {
    
    [NetworkConfig showChangeTenantVC];
}

- (void)feedback {
    WebViewController *vc = [[WebViewController alloc] initWithUrl:[AppModel shareInstance].commonInfo[@"pop"]];
    vc.title = NSLocalizedString(@"联系客服", nil);
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark - <UITableViewDataSource && Delegate>

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger type = [_dataList[indexPath.row][kType] integerValue];
    NSString *cellIdentifier = [NSString stringWithFormat:@"cell_%ld",type];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:0 reuseIdentifier:cellIdentifier];
        cell.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
//        NSInteger type = [_dataList[indexPath.row][kType] integerValue];
        cell.tag = type;
        if (type == EnumActionTag1) {
            _codeBtn = [UIButton new];
            [cell.contentView addSubview:_codeBtn];
            [_codeBtn setTitle:NSLocalizedString(@"获取验证码", nil) forState:UIControlStateNormal];
            [_codeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            _codeBtn.titleLabel.font = [UIFont systemFontOfSize:13];
            _codeBtn.layer.cornerRadius = 6;
            _codeBtn.layer.masksToBounds = YES;
            _codeBtn.backgroundColor = COLOR_X(244, 112, 35);
            [_codeBtn addTarget:self action:@selector(getCodeAction) forControlEvents:UIControlEventTouchUpInside];
            
            [_codeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(cell.contentView.mas_right).offset(-15);
                make.centerY.equalTo(cell.contentView.mas_centerY);
                make.height.equalTo(@(30));
                make.width.equalTo(@(86));
            }];
        }
        if (type == EnumActionTag3) {
            _vertifyImgBtn = [FLAnimatedImageView new];
            [cell.contentView addSubview:_vertifyImgBtn];
            _vertifyImgBtn.animatedImage = [FLAnimatedImage animatedImageWithGIFData:self.imageCaptchaData];
            [_vertifyImgBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(cell.contentView.mas_right).offset(-15);
                make.centerY.equalTo(cell.contentView.mas_centerY);
                make.height.equalTo(@(30));
                make.width.equalTo(@(86));
            }];
            _vertifyImgBtn.userInteractionEnabled = true;
            UITapGestureRecognizer* tagG = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(action_refreshImgCode)];
            [_vertifyImgBtn addGestureRecognizer:tagG];
        }
        UITextField *textField = [UITextField new];
        textField.tag = 9000;
        textField.textColor = [UIColor colorWithHexString:@"#000000"];
        [cell.contentView addSubview:textField];
        textField.font = [UIFont systemFontOfSize2:15];
        textField.placeholder = _dataList[indexPath.row][kTit];
        textField.secureTextEntry = type == 2?YES:NO;
        textField.delegate = self;
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        cell.imageView.image = [UIImage imageNamed:_dataList[indexPath.row][kImg]];
        if(type == EnumActionTag0){
            textField.keyboardType = UIKeyboardTypeNumberPad;
            textField.returnKeyType = UIReturnKeyNext;
            NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
            NSString *mobile = [ud objectForKey:@"mobile"];
            textField.text = ![FunctionManager isEmpty:mobile]?mobile:@"";
        }else {
            
            textField.returnKeyType = UIReturnKeyDone;
        }
        
        CGFloat right = (type == EnumActionTag1 || type == EnumActionTag3) ? 116 : 15;
        [textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(cell.contentView.mas_left).offset(50);
            make.top.bottom.equalTo(cell.contentView);
            make.right.equalTo(cell.contentView.mas_right).offset(-right);
        }];
    }
    if (type == EnumActionTag3) {
        if (self.imageCaptchaData) {
            _vertifyImgBtn.animatedImage = [FLAnimatedImage animatedImageWithGIFData:self.imageCaptchaData];
            [cell.contentView bringSubviewToFront:_vertifyImgBtn];
        }
    }
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1f;
}


- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    for (int i = 0; i < self.dataList.count; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        UITableViewCell *cell = (UITableViewCell*)[_tableView cellForRowAtIndexPath:indexPath];
        UITextField *textField = (UITextField *)[cell.contentView viewWithTag:9000];
        [textField resignFirstResponder];
    }
}



#pragma mark - Action

- (void)getCodeAction {
    
    for (int i = 0; i < self.dataList.count; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        UITableViewCell* cell = (UITableViewCell*)[_tableView cellForRowAtIndexPath:indexPath];
        
        switch (cell.tag) {
            case EnumActionTag0:
            {
                UITextField *tf = (UITextField *)[cell.contentView viewWithTag:9000];
                NSString *account = tf.text;
                if (account.length < 8 || account.length > 11) {
                    SVP_ERROR_STATUS(NSLocalizedString(@"请输入正确的手机号", nil));
                    return;
                }
                _accountNum = account;
            }
                break;
            
            default:
                break;
        }
    }
    
    
    [SVProgressHUD show];
    WEAK_OBJ(weakSelf, self);
    [NET_REQUEST_MANAGER requestSmsCodeWithPhone:_accountNum type:GetSmsCodeFromVCLoginBySMS success:^(id object) {
        SVP_SUCCESS_STATUS(NSLocalizedString(@"发送成功，请注意查收短信", nil));
        int time = ![FunctionManager isEmpty:object[@"data"]]?[object[@"data"] intValue]:60;
        [weakSelf.codeBtn beginTime:time];
    } fail:^(id object) {
        [[FunctionManager sharedInstance] handleFailResponse:object];
    }];
}


- (void)loginAction {
    [self.view endEditing:YES];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    for (int i = 0; i<_dataList.count; i++) {
        NSIndexPath* indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        UITableViewCell* cell = (UITableViewCell*)[_tableView cellForRowAtIndexPath:indexPath];
        
        switch (cell.tag) {
            case EnumActionTag0:
            {
                UITextField *tf = (UITextField *)[cell.contentView viewWithTag:9000];
                NSString *account = tf.text;
                if([account isEqualToString:@"88866610"]){
                    [self accountSwitch];
                    return;
                }
                
                if (account.length < 8 || account.length > 11) {
                    SVP_ERROR_STATUS(NSLocalizedString(@"请输入正确的手机号", nil));
                    return;
                }
                [dic addEntriesFromDictionary:@{_dataList[i][kSubTit]:account}];
                _accountNum = account;
            }
                break;
            case EnumActionTag1:
            {
                UITextField *tf = (UITextField *)[cell.contentView viewWithTag:9000];
                NSString *vertifyCode = tf.text;
                if (vertifyCode.length == 0) {
                    SVP_ERROR_STATUS(NSLocalizedString(@"请输入验证码", nil));
                    return;
                }
                [dic addEntriesFromDictionary:@{_dataList[i][kSubTit]:vertifyCode}];
            }
                break;
            case EnumActionTag2:
            {
                UITextField *tf = (UITextField *)[cell.contentView viewWithTag:9000];
                NSString *pw = tf.text;
                if (pw.length < 6) {
                    SVP_ERROR_STATUS(NSLocalizedString(@"请输入6位以上密码", nil));
                    return;
                }
                NSData *data = [pw dataUsingEncoding:NSUTF8StringEncoding];
                data = [data AES128EncryptWithKey:kAccountPasswordKey gIv:kAccountPasswordKey];
                data = [GTMBase64 encodeData:data];
                NSString *s = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                [dic addEntriesFromDictionary:@{_dataList[i][kSubTit]:s}];
            }
                break;
            case EnumActionTag3:
            {
                UITextField *tf = (UITextField *)[cell.contentView viewWithTag:9000];
                NSString *vertifyImg = tf.text;
                if (vertifyImg.length == 0) {
                    SVP_ERROR_STATUS(NSLocalizedString(@"请输入图形验证码", nil));
                    return;
                }
                [dic addEntriesFromDictionary:@{_dataList[i][kSubTit]:vertifyImg}];
                [dic addEntriesFromDictionary:@{@"picCodeUUID":_rsaGenerated}];
            }
                break;
            default:
                break;
        }
    }
    
    
    NSLog(@"login:%@",dic);
    __weak typeof(self) tempVC = self;
    if ([AppModel shareInstance].commonInfo == nil||
        [AppModel shareInstance].appClientIdInCommonInfo==nil) {
        
        [NET_REQUEST_MANAGER requestAppConfigWithSuccess:^(id object) {
            SVP_SHOW;
            if ([object isKindOfClass:[NSDictionary class]]) {
                NSDictionary *result = object;
                [[AppModel shareInstance] updateCommonInformation:result];
            }
            [NET_REQUEST_MANAGER toLogin:dic successBlock:^(NSDictionary *object) {
                SVP_DISMISS;
                if([object isKindOfClass:[NSDictionary class]]){
                    if ([object objectForKey:@"code"] && [[object objectForKey:@"code"] integerValue] == 0) {
                    }
//                    [self getUserInfo];
                    [[AppModel shareInstance] loginToUpdateUserInformation:YES];
                }
            } failureBlock:^(NSError *failure) {
                SVP_DISMISS;
                [tempVC loginFailureAction:failure];
            }];
        } fail:^(id object) {
            SVP_ERROR_STATUS(NSLocalizedString(@"网络请求初始化接口失败，稍后重试...", nil));
        }];
        
    }else{
        
        SVP_SHOW;
        [NET_REQUEST_MANAGER toLogin:dic successBlock:^(NSDictionary *object) {
            SVP_DISMISS;
            
            NSDictionary *dict = [[object mj_JSONString] mj_JSONObject];
            if (dict != nil) {
//                [self getUserInfo];
                [[AppModel shareInstance] loginToUpdateUserInformation:YES];
            }
        } failureBlock:^(NSError *failure) {
            SVP_DISMISS;
            [tempVC loginFailureAction:failure];
        }];
    
    }
}

-(void)loginFailureAction:(NSError *)failure{
    if ([failure isKindOfClass:[NSDictionary class]]) {
        NSDictionary *dict = (NSDictionary *)failure;
        NSString *message = dict[@"alterMsg"];
        if ([message containsString:NSLocalizedString(@"封号", nil)]) {
            //您已经被封号，请与客服联系！
            __weak typeof(self) tempVC = self;
            [FYAlertDangerView alertShowFromVC:self result:^(UIButton * _Nonnull button) {
                NSLog(@"%@",button.currentTitle);
                if ([button.currentTitle isEqualToString:NSLocalizedString(@"联系客服", nil)]) {
                    [tempVC feedback];
                }
            }];
        }else{
            [[FunctionManager sharedInstance] handleFailResponse:failure];
        }
    }else{
        [[FunctionManager sharedInstance] handleFailResponse:failure];
    }
}

/**
 获取用户信息
 */
- (void)getUserInfo {
    
    [NET_REQUEST_MANAGER requestUserInfoWithSuccess:^(id object) {
        [[AppModel shareInstance] reSetTabBarAsRootAnimation];
    } fail:^(id object) {
        [[FunctionManager sharedInstance] handleFailResponse:object];
    }];
    
    [NET_REQUEST_MANAGER requestAppConfigWithSuccess:^(id object) {
        if ([object isKindOfClass:[NSDictionary class]]) {
            NSDictionary *result = object;
            [[AppModel shareInstance] updateCommonInformation:result];
        }
    } fail:^(id object) {
        
    }];
}

- (void)saveMobileAndPassword {
    
    SetUserDefaultKeyWithObject(@"mobilemobile", _accountNum);
    UserDefaultSynchronize;
    for (int i = 0; i<_dataList.count; i++) {
        NSIndexPath* indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        UITableViewCell* cell = (UITableViewCell*)[_tableView cellForRowAtIndexPath:indexPath];
        switch (cell.tag) {
            case EnumActionTag0:
            {
//                UITextField *tf = (UITextField *)[cell.contentView viewWithTag:9000];
//                self.accountNum = tf.text;
            }
                break;
            case EnumActionTag2:
            {
                UITextField *tf = (UITextField *)[cell.contentView viewWithTag:9000];
                NSString *pw = tf.text;
                [SAMKeychain setPassword:pw forService:@"password" account:_accountNum];
                
            }
                break;
            
            default:
                break;
        }
    }
    
}



- (void)accountSwitch {
    [self.view endEditing:YES];

    NSArray *ipArray = [[AppModel shareInstance] ipArray];
    NSMutableArray *newArr = [NSMutableArray array];
    for (NSDictionary *dic in ipArray) {
        NSString *bankName = dic[@"url"];
        [newArr addObject:bankName];
    }
    [newArr addObject:NSLocalizedString(@"添加ip", nil)];
    ActionSheetCus *sheet = [[ActionSheetCus alloc] initWithArray:newArr];
    sheet.titleLabel.text = NSLocalizedString(@"请选择地址", nil);
    sheet.delegate = self;
    [sheet showWithAnimationWithAni:YES];
}

-(void)actionSheetDelegateWithActionSheet:(ActionSheetCus *)actionSheet index:(NSInteger)index{
    NSArray *arr = [[AppModel shareInstance] ipArray];
    if(index > arr.count)
    return;
    if(index == arr.count){
        AddIpViewController *vc = [[AddIpViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        [ud setObject:INT_TO_STR(index) forKey:@"serverIndex"];
        [ud synchronize];
        SVP_SUCCESS_STATUS(NSLocalizedString(@"切换成功，重启生效", nil));
        [[FunctionManager sharedInstance] performSelector:@selector(exitApp) withObject:nil afterDelay:1.0];
    }
}

-(void)action_refreshImgCode {
    
    WEAK_OBJ(weakSelf, self);
    _rsaGenerated = [RSA randomlyGenerated16BitString];
    [NET_REQUEST_MANAGER requestImageCaptchaWithPhone:_rsaGenerated type:GetSmsCodeFromVCLoginBySMS success:^(id object) {
        weakSelf.imageCaptchaData = object;
        weakSelf.vertifyImgBtn.animatedImage = [FLAnimatedImage animatedImageWithGIFData:self.imageCaptchaData];
    } fail:^(id object) {
        [weakSelf.tableView reloadData];
    }];
}


- (void)action_forgot {
    CDPush(self.navigationController, CDVC(@"ForgotViewController"), YES);
}

-(void)checkInitInputData{
    [self.buttonLoginStyleChange setTitle:NSLocalizedString(@"密码登录", nil) forState:UIControlStateNormal];
    for (NSDictionary *dict in self.dataList) {
        NSString *inputCode = dict[kSubTit];
        if ([inputCode isEqualToString:@"mobile_code"]) {
            self.buttonLoginStyleChange.hidden = NO;
        }else if ([inputCode isEqualToString:@"pic_code"]){
            self.isHavePictureCode = YES;
        }
    }
    if (self.buttonLoginStyleChange.hidden == NO && self.dataList.count == 2) {
        self.buttonLoginStyleChange.hidden = YES;
        [self.tableView reloadData];
        return;
    }
    [self actionChangeLoginStyle:self.buttonLoginStyleChange];
}

-(void)actionChangeLoginStyle:(UIButton *)sender{
    NSLog(@"%@",sender.currentTitle);
    while (self.dataList.count > 1) {
        [self.dataList removeLastObject];
    }
    if ([sender.currentTitle isEqualToString:NSLocalizedString(@"短信验证码登录", nil)]) {
        if (self.buttonLoginStyleChange.hidden == NO) {
            [sender setTitle:NSLocalizedString(@"密码登录", nil) forState:UIControlStateNormal];
        }
        [self.dataList addObject:@{kTit:NSLocalizedString(@"验证码", nil),
                                   kImg:@"icon_security",
                                   kType:@(EnumActionTag1),
                                   kSubTit:@"mobile_code",
                                   kIsOn:@"1"}];
        
    }else if ([sender.currentTitle isEqualToString:NSLocalizedString(@"密码登录", nil)]){
        if (self.buttonLoginStyleChange.hidden == NO) {
            [sender setTitle:NSLocalizedString(@"短信验证码登录", nil) forState:UIControlStateNormal];
        }
        [self.dataList addObject:@{kTit:NSLocalizedString(@"密码", nil),
                                   kImg:@"icon_lock",
                                   kType:@(EnumActionTag2),
                                   kSubTit:@"passwd",
                                   kIsOn:@"1"}];
        if (self.isHavePictureCode) {
            [self.dataList addObject:@{kTit:NSLocalizedString(@"图形验证码", nil),
                                       kImg:@"icon_vertifyImg",
                                       kType:@(EnumActionTag3),
                                       kSubTit:@"pic_code",
                                       kIsOn:@"1"}];
        }
    }
    [self.tableView reloadData];
}
- (void)action_register {
    CDPush(self.navigationController, CDVC(@"RegisterViewController"), YES);
}

@end
