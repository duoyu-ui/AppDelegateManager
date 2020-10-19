//
//  FY2020LoginViewController.m
//  FY_OC
//
//  Created by FangYuan on 2020/1/30.
//  Copyright © 2020 FangYuan. All rights reserved.
//

#import "FY2020LoginViewController.h"
#import "FY2020LoginHeaderView.h"
#import "FYLaunchristPageFooterView.h"
#import "FY2020LoginCell.h"
#import "LoginRegisterModel.h"
#import "FY2020ForgetController.h"
#import "RSA.h"
#import "WXApiNetManager.h"
#import "AddIpViewController.h"
#import <AFNetworking/AFNetworking.h>
//#import "Constants.h"
#import "NSData+AES.h"
#import "GTMBase64.h"
//一些弹窗写在LaunchFristPageVC里面
#import "LaunchFristPageVC.h"
#import "FYFriendName.h"
//
#ifdef _PROJECT_WITH_WECHAT_
#import "WXApi.h"
#endif
#import "WXApiManager.h"
//
#ifdef _PROJECT_WITH_OPENINSTALL_
#import "OpenInstallSDK.h"
#endif

typedef enum : NSUInteger {
    FYShowLoginMobile,
    FYShowLoginPassword,
    FYShowRegister,
} FYShowType;

typedef enum : NSUInteger {
    FYLoginUITypeUsernamePassword,
    FYLoginUITypeMobileCode,
    FYLoginUITypeMobilePassword,
    FYLoginUITypeToRegister,
    FYLoginUITypeToRegisterUsername,
} FYLoginUIType;

@interface FY2020LoginViewController ()<UITableViewDataSource,FYLaunchristPageLoginDelegate,ActionSheetDelegate,WXAuthDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) FY2020LoginHeaderView *headerView;
@property (nonatomic, strong) FYLaunchristPageFooterView *loginFooterView;
@property (nonatomic, strong) UIImageView *bottomImage;
@property (nonatomic, strong) UIButton *navigationButton;

@property (nonatomic, assign) FYShowType viewType;
@property (nonatomic, strong) NSArray *datalist;
@property (nonatomic, strong) NSArray *loginNetData;
@property (nonatomic, strong) NSArray *registerNetData;
@property (nonatomic, assign) BOOL isHaveUsernameRegiseter;

@property (nonatomic, strong) NSString *rsaGeneratedLogin;
@property (nonatomic, strong) NSString *rsaGeneratedRegister;
@property (nonatomic, strong) NSData *animatorImageCodeLogin;
@property (nonatomic, strong) NSData *animatorImageCodeRegister;
@property (nonatomic, assign) BOOL loginIsHavePictureCode;
@property (nonatomic, assign) BOOL loginIsHaveMobileCode;
@property (nonatomic, assign) BOOL loginMobileIsPassword;
@property (nonatomic, assign) FYLoginUIType loginTypeUI;
@property (nonatomic, assign) BOOL loginIsHavePasswordLogin;

@property (nonatomic, strong) NSArray *viewRegisterUsername;
@property (nonatomic, strong) NSArray *viewRegisterMobile;
@end

@implementation FY2020LoginViewController

+ (BaseNewNavViewController *)noLoginView{
    //    static BaseNewNavViewController *instance;
    //    static dispatch_once_t onceToken;
    //    dispatch_once(&onceToken, ^{
    //        FY2020LoginViewController *tempVC = [[FY2020LoginViewController alloc] init];
    //        instance = [[BaseNewNavViewController alloc]initWithRootViewController:tempVC];
    //    });
    //    return instance;
    FY2020LoginViewController *tempVC = [[FY2020LoginViewController alloc] init];
    return [[BaseNewNavViewController alloc] initWithRootViewController:tempVC];
}


#pragma mark - Navigation

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (BOOL)prefersNavigationBarHidden
{
    return YES;
}


#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithWhite:0.93725 alpha:1];
    self.tableView.tableHeaderView = self.headerView;
    [self.headerView updateIndicator];
    self.tableView.dataSource = self;
    self.headerView.buttonLeft.tag = 100;
    self.headerView.buttonRight.tag = 101;
    [self HTTPGetLoginConfiguration];
    
    [self.view addSubview:self.navigationButton];
    [self.navigationButton setTitle:NSLocalizedString(@"线路选择", nil) forState:UIControlStateNormal];
    [self.navigationButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(STATUS_BAR_HEIGHT);
        make.right.equalTo(self.view.mas_right).offset(-CFC_AUTOSIZING_MARGIN(MARGIN));
        make.size.mas_equalTo(CGSizeMake(80, NAVIGATION_BAR_HEIGHT));
    }];

#if DEBUG
    NSString *year= [FYDateUtil getCurrentDateWithDateFormate:@"YYYY"];
    NSString *versionString = [NSString stringWithFormat:@"Copyright © %@ QG 版权所有", year];
    UILabel *appVersionLabel = ({
        UILabel *label = [UILabel new];
        [self.view addSubview:label];
        [label setText:versionString];
        [label setTextAlignment:NSTextAlignmentCenter];
        [label setTextColor:COLOR_SYSTEM_MAIN_FONT_DEFAULT];
        [label setFont:FONT_PINGFANG_REGULAR(13)];
        
        CGFloat offfset = CFC_IS_IPHONE_X_OR_GREATER ? TAB_BAR_DANGER_HEIGHT + 20.f : 40.0f;
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.view.mas_bottom).offset(-offfset);
            make.centerX.equalTo(self.view.mas_centerX);
        }];
        
        label;
    });
    appVersionLabel.mas_key = @"appVersionLabel";
#endif
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self HTTPinitLoginData];
}


#pragma mark - init & assemble Data ...

-(void)initLoginForCode
{
    if (self.loginNetData.count < 1) {
        return;
    }
    self.viewType = FYShowLoginMobile;
    self.tableView.tableFooterView = self.loginFooterView;
    //手机号登陆分验证码登陆和密码登陆
    NSArray *tempArray;
    //手机号+验证码登陆
    if (self.loginTypeUI == FYLoginUITypeMobileCode) {
        self.loginTypeUI = FYLoginUITypeMobileCode;
        tempArray=@[self.loginNetData.firstObject,
        @{kTit:NSLocalizedString(@"验证码", nil),
        kImg:@"icon_security",
        kType:@(EnumActionTag1),
        kSubTit:@"mobile_code",
        kIsOn:@"1"}];
    } else {
        //手机号+密码登陆
        self.loginTypeUI = FYLoginUITypeMobilePassword;
        tempArray=@[self.loginNetData.firstObject,
        @{kTit:NSLocalizedString(@"密码", nil),
        kImg:@"icon_lock",
        kType:@(EnumActionTag2),
        kSubTit:@"passwd",
        kIsOn:@"1"}];
    }
    
//    NSArray *tempArray=@[self.loginNetData.firstObject,
//                      @{kTit:NSLocalizedString(@"验证码", nil),
//                      kImg:@"icon_security",
//                      kType:@(EnumActionTag1),
//                      kSubTit:@"mobile_code",
//                      kIsOn:@"1"}];
    self.datalist = [FYFieldModel assembelArray:tempArray];
    [self.tableView reloadData];
}

-(void)initLoginForPassword{
    if (self.loginNetData.count < 1) {
        return;
    }
    self.loginTypeUI = FYLoginUITypeUsernamePassword;
    self.viewType = FYShowLoginPassword;
    self.tableView.tableFooterView = self.loginFooterView;
    self.datalist = [FYFieldModel assembelArray:self.loginNetData];
    [self.tableView reloadData];
}

-(void)initRegisterData:(BOOL)isRequest{
    if (self.loginTypeUI == FYLoginUITypeToRegisterUsername) {
        if (self.viewRegisterUsername.count < 1) {
            NSDictionary *userNameDict=@{kTit:NSLocalizedString(@"请输入6-18位字母和数字用户名", nil),
                                         kImg:@"icon_lock",
                                         kType:@(EnumActionTag2),
                                         kSubTit:@"user_name",
                                         kIsOn:@"1"};
            NSDictionary *passwordDict=@{kTit:NSLocalizedString(@"请输入6-16位密码", nil),
                                         kImg:@"icon_lock",
                                         kType:@(EnumActionTag2),
                                         kSubTit:@"passwd",
                                         kIsOn:@"1"};
            NSDictionary *passwordDictRe=@{kTit:NSLocalizedString(@"请再次输入6-16位密码", nil),
                                       kImg:@"icon_lock",
                                       kType:@(EnumActionTag2),
                                       kSubTit:@"passwd_re",
                                       kIsOn:@"1"};
            NSMutableArray *baseArray=[NSMutableArray new];
            [baseArray addObject:userNameDict];
            [baseArray addObject:passwordDict];
            [baseArray addObject:passwordDictRe];
            if (self.registerNetData.count > 0) {
                for (NSDictionary *temp in self.registerNetData) {
                    NSString *keyString=temp[@"kSubTit"];
                    if ([keyString isEqualToString:@"mobile"]) {
                        continue;
                    }else if ([keyString isEqualToString:@"mobile_code"]){
                        continue;
                    }else if ([keyString isEqualToString:@"passwd"]){
                        continue;
                    }else if ([keyString isEqualToString:@"passwd_re"]){
                        continue;
                    }else{
                        [baseArray addObject:temp];
                    }
                }
                self.viewRegisterUsername = [FYFieldModel assembelArray:baseArray];;
            }
        }
        self.datalist = self.viewRegisterUsername;
        [self.tableView reloadData];
        return;
    }
    if (isRequest) {
        self.viewType = FYShowRegister;
        self.tableView.tableFooterView = [UIView new];
        [self HTTPinitRegisterData];
    }else{
        
    }
    if (self.registerNetData) {
        if (self.viewType == FYShowRegister) {
            if (self.viewRegisterMobile.count < 2) {
                self.viewRegisterMobile = [FYFieldModel assembelArray:self.registerNetData];
            }
            if (self.datalist.count > 0)
            self.datalist = self.viewRegisterMobile;
            [self.tableView reloadData];
        }
    }
}

-(void)assembleLoginInitData{
    NSInteger loginStyle=0;
    NSMutableArray *tempLoginItem=[NSMutableArray new];
    for (NSDictionary *dict in self.loginNetData) {
        NSString *inputCode = dict[kSubTit];
        if ([inputCode isEqualToString:@"mobile_code"]) {
            self.loginIsHaveMobileCode = YES;
        }else if ([inputCode isEqualToString:@"pic_code"]){
            self.loginIsHavePictureCode = YES;
        }else if ([inputCode isEqualToString:@"passwd"]){
            self.loginIsHavePasswordLogin = YES;
        }
        if ([inputCode isEqualToString:@"user_name"]) {
            loginStyle += 1;
        }else if ([inputCode isEqualToString:@"mobile"]){
            loginStyle += 1;
        }else{
            [tempLoginItem addObject:dict];
        }
    }
    if (loginStyle > 1) {
        NSDictionary *userNameDict=@{kTit:NSLocalizedString(@"请输入手机号/用户名", nil),
                                     kImg:@"icon_lock",
                                     kType:@(EnumActionTag2),
                                     kSubTit:@"mobile_user",
                                     kIsOn:@"1"};
        [tempLoginItem insertObject:userNameDict atIndex:0];
        self.loginNetData = tempLoginItem;
    }
    [self initLoginForPassword];

    BOOL isRegister = [[NSUserDefaults standardUserDefaults] boolForKey:@"toRegister"];
    if (isRegister) {
        NSUserDefaults *userD=[NSUserDefaults standardUserDefaults];
        [userD setBool:NO forKey:@"toRegister"];
        [userD synchronize];
        [self.headerView buttonAction:self.headerView.buttonRight];
    }else{
        [self.headerView buttonAction:self.headerView.buttonLeft];
    }
    
}

-(FYFieldModel *)getCellDataWithCode:(NSString *)key{
    for (FYFieldModel *temp in self.datalist) {
        if ([temp.key isEqualToString:key]) {
            return temp;
        }
    }
    return nil;
}

#pragma mark - Actions ...

-(void)buttonAction:(UIButton *)sender{
    switch (sender.tag) {
        case 99:{
            //获取验证码
            [self HTTPFetchMobileCode:sender];
        }break;
        case 100:{
            //登录页面
            if (self.loginIsHavePasswordLogin) {
                [self initLoginForPassword];
            }else if (self.loginIsHaveMobileCode){
                [self initLoginForCode];
            };
        }break;
        case 101:{
            //注册页面
            self.loginTypeUI = FYLoginUITypeToRegister;
            self.registerNetData=nil;
            self.viewRegisterMobile=nil;
            [self initRegisterData:YES];
        }break;
        case 102:
            //登录 or 注册 按钮
            if (self.viewType == FYShowRegister) {
                //to register
                [self HTTPToRegister];
            }else{
                //to login
                [self HTTPLoginAction];
            }
            break;
        case 103:{
            if (self.viewType == FYShowRegister) {
                //to register View 联系客服
                [self feedback];
            }else{
                //to login View
                //登录方式改变（密码登录和验证码登录）
                if (self.loginNetData.count < 1) {
                    return;
                }
                if (self.viewType == FYShowLoginMobile) {
                    
                    [self initLoginForPassword];
                }else{
                    [self initLoginForCode];
                }
            }
        }break;
        case 200:{
            //登录方式切换:
            if (self.loginTypeUI == FYLoginUITypeMobilePassword) {
                //手机号登录=====>密码登陆
                self.loginTypeUI = FYLoginUITypeUsernamePassword;
                [self initLoginForPassword];
            }else if (self.loginTypeUI == FYLoginUITypeMobileCode){
                //手机号登录=====>密码登陆
                self.loginTypeUI = FYLoginUITypeUsernamePassword;
                [self initLoginForPassword];
            }else if (self.loginTypeUI == FYLoginUITypeUsernamePassword){
                //非手机号登陆======>手机号登录
                self.loginTypeUI = FYLoginUITypeMobilePassword;
                [self initLoginForCode];
            }else if (self.loginTypeUI == FYLoginUITypeToRegister || self.loginTypeUI == FYLoginUITypeToRegisterUsername){
                [self feedback];
            }
        }break;
        case 300:{
            if (self.loginTypeUI == FYLoginUITypeMobileCode) {
                self.loginTypeUI = FYLoginUITypeMobilePassword;
            } else {
                self.loginTypeUI = FYLoginUITypeMobileCode;
            }
            [self initLoginForCode];
        }break;
        case 400:{
            if (self.loginTypeUI == FYLoginUITypeToRegister){
                //to用户名注册UI
                self.loginTypeUI = FYLoginUITypeToRegisterUsername;
                [self initRegisterData:NO];
            }else if (self.loginTypeUI == FYLoginUITypeToRegisterUsername){
                //to手机号注册UI
                self.loginTypeUI = FYLoginUITypeToRegister;
                [self initRegisterData:NO];
            }
        }break;
        case 1000:{
            //线路选择
            PingViewController *vc = [[PingViewController alloc] init];
            CDPush(self.navigationController, vc, YES);
        }break;
        default:
            break;
    }
}
-(void)forgetPassword{
    FY2020ForgetController *subView=[FY2020ForgetController new];
    subView.title = NSLocalizedString(@"忘记密码", nil);
    subView.isNeedChangeNavigation = true;
    [self.navigationController pushViewController:subView animated:YES];
}
- (void)feedback {
    FYWebViewController *vc = [[FYWebViewController alloc] initWithUrl:[AppModel shareInstance].commonInfo[@"pop"]];
    vc.title = NSLocalizedString(@"联系客服", nil);
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)gifImageRefresh:(UITapGestureRecognizer *)tap{
    [self HTTPFetchAnimatorImageCode:(self.viewType == FYShowRegister ? GetSmsCodeFromVCRegister : GetSmsCodeFromVCLoginBySMS)];
}

- (void)tenantBtnClick {
    
    [NetworkConfig showChangeTenantVC];
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

#pragma mark - Delegate ...

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
//    if (self.viewType == FYShowRegister) {
//        return 2;
//    }
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return self.datalist.count;
    }
    if (section==1) {
        if (self.loginTypeUI == FYLoginUITypeUsernamePassword) {
            return 0;
        }
        if (self.viewType == FYShowRegister) {
            if (self.isHaveUsernameRegiseter==YES) {
                return 1;
            }else{
                return 0;
            }
        }
        return 1;

    }
    if (self.viewType == FYShowRegister) {
        return 2;
    }
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        FYFieldModel *model = [self.datalist objectAtIndex:indexPath.row];
        NSString *cellIdentifier = [NSString stringWithFormat:@"cell%@",model.key];
        FY2020LoginInputCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell) {
            cell=[[FY2020LoginInputCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            if ([model.key isEqualToString:@"mobile_code"]) {
                cell.buttonCode.tag = 99;
                [cell.buttonCode addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
            }else if ([model.key isEqualToString:@"pic_code"]){
                cell.buttonImageAnimator.userInteractionEnabled = YES;
                [cell.buttonImageAnimator addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gifImageRefresh:)]];
            }
            __weak typeof(self) tempVC = self;
            cell.actionCallBack = ^(NSInteger actionType) {
                if (actionType == 1) {
                    [tempVC.view endEditing:YES];
                }else if (actionType == 2){
                    [tempVC forgetPassword];
                }
            };
        }
        cell.model = model;
        if ([model.key isEqualToString:@"pic_code"]) {
            if (self.viewType == FYShowRegister) {
                if (self.animatorImageCodeRegister) {
                    cell.buttonImageAnimator.animatedImage = [FLAnimatedImage animatedImageWithGIFData:self.animatorImageCodeRegister];
                }else{
                    cell.buttonImageAnimator.animatedImage = nil;
                }
            }else{
                if (self.animatorImageCodeLogin) {
                    cell.buttonImageAnimator.animatedImage = [FLAnimatedImage animatedImageWithGIFData:self.animatorImageCodeLogin];
                }else{
                    cell.buttonImageAnimator.animatedImage = nil;
                }
            }
        }else if ([model.key isEqualToString:@"passwd"]) {
            if (self.viewType == FYShowRegister) {
                cell.field.rightViewMode = UITextFieldViewModeNever;
            }else{
                cell.field.rightViewMode = UITextFieldViewModeAlways;
            }
        }else if ([model.key isEqualToString:@"mobile_code"]){
            if (self.viewType == FYShowRegister){
                cell.field.rightView = cell.buttonRegisterCode;
                [cell.buttonRegisterCode addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
            }
        }
        return cell;
    }else if (indexPath.section == 1){
        if (self.viewType == FYShowRegister) {
            FY2020LoginRedActionCell *cell=[tableView dequeueReusableCellWithIdentifier:@"FY2020LoginRedActionCell"];
            NSMutableAttributedString *msg=[NSMutableAttributedString new];
            if (self.loginTypeUI == FYLoginUITypeToRegisterUsername) {
                [msg appendAttributedString:[[NSAttributedString alloc] initWithString:NSLocalizedString(@"切换手机号码注册", nil) attributes:@{NSForegroundColorAttributeName:[UIColor redColor]}]];
                
            }else{
                [msg appendAttributedString:[[NSAttributedString alloc] initWithString:NSLocalizedString(@"切换用户名注册", nil) attributes:@{NSForegroundColorAttributeName:[UIColor redColor]}]];
            }
            cell.button.tag = 400;
            [cell.button setAttributedTitle:msg forState:UIControlStateNormal];
            [cell.button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
            return cell;
        }
        FY2020LoginRightButtonCell *cell=[tableView dequeueReusableCellWithIdentifier:@"FY2020LoginRightButtonCell"];
        if (self.loginTypeUI == FYLoginUITypeMobileCode) {
            [cell.button setTitle:NSLocalizedString(@"密码登录", nil) forState:UIControlStateNormal];
        } else {
            [cell.button setTitle:NSLocalizedString(@"短信验证码登录", nil) forState:UIControlStateNormal];
        }
        [cell.button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }else if (indexPath.section == 2){
        if (indexPath.row == 1) {
            FY2020LoginRedActionCell *cell=[tableView dequeueReusableCellWithIdentifier:@"FY2020LoginRedActionCell"];
            NSMutableAttributedString *msg=[NSMutableAttributedString new];
            if (self.viewType == FYShowRegister) {
                //注册
                
                [msg appendAttributedString:[[NSAttributedString alloc] initWithString:NSLocalizedString(@"没有邀请码请", nil) attributes:@{NSForegroundColorAttributeName:[UIColor grayColor]}]];
                [msg appendAttributedString:[[NSAttributedString alloc] initWithString:NSLocalizedString(@"联系客服", nil) attributes:@{NSForegroundColorAttributeName:[UIColor redColor]}]];
                
            }else{
                //登录
                if (self.loginTypeUI == FYLoginUITypeUsernamePassword) {
                    //用户名登陆
                    [msg appendAttributedString:[[NSAttributedString alloc] initWithString:NSLocalizedString(@"手机号登录", nil) attributes:@{NSForegroundColorAttributeName:[UIColor redColor]}]];;
                }else{
                    //手机号登陆
                    [msg appendAttributedString:[[NSAttributedString alloc] initWithString:NSLocalizedString(@"用户名登录", nil) attributes:@{NSForegroundColorAttributeName:[UIColor redColor]}]];;
                }
            }
            cell.button.tag = 200;
            [cell.button setAttributedTitle:msg forState:UIControlStateNormal];
            [cell.button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
            return cell;
        }
        FY2020LoginActionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FY2020LoginActionCell"];
        cell.buttonLogin.tag = 102;
//        cell.buttonOther.tag = 103;
        [cell.buttonLogin addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
//        [cell.buttonOther addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        NSMutableAttributedString *msg=[NSMutableAttributedString new];
        if (self.viewType == FYShowRegister) {
            [cell.buttonLogin setTitle:NSLocalizedString(@"注册", nil) forState:UIControlStateNormal];
            [msg appendAttributedString:[[NSAttributedString alloc] initWithString:NSLocalizedString(@"没有邀请码请", nil) attributes:@{NSForegroundColorAttributeName:[UIColor grayColor]}]];
            [msg appendAttributedString:[[NSAttributedString alloc] initWithString:NSLocalizedString(@"联系客服", nil) attributes:@{NSForegroundColorAttributeName:[UIColor redColor]}]];
//            cell.buttonOther.hidden = NO;
        }else{
            [cell.buttonLogin setTitle:NSLocalizedString(@"登录", nil) forState:UIControlStateNormal];
            if (self.viewType == FYShowLoginMobile) {
//                if (self.loginIsHavePasswordLogin) {
//                    cell.buttonOther.hidden = NO;
//                }else{
//                    cell.buttonOther.hidden = YES;
//                }
                [msg appendAttributedString:[[NSAttributedString alloc] initWithString:NSLocalizedString(@"使用密码登录", nil) attributes:@{NSForegroundColorAttributeName:[UIColor redColor]}]];
            }else{
//                if (self.loginIsHaveMobileCode) {
//                    cell.buttonOther.hidden = NO;
//                }else{
//                    cell.buttonOther.hidden = YES;
//                }
//                [msg appendAttributedString:[[NSAttributedString alloc] initWithString:NSLocalizedString(@"使用验证码登录", nil) attributes:@{NSForegroundColorAttributeName:[UIColor redColor]}]];
            }
        }
//        [cell.buttonOther setAttributedTitle:msg forState:UIControlStateNormal];
        return cell;
    }
    FY2020LoginCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FY2020LoginCell"];
    return cell;
}

- (void)didSeledWihtIndx:(NSInteger)index
{
    switch (index) {
        case 0: { // 微信登录
#ifdef _PROJECT_WITH_WECHAT_
            if ([self verifyWXAppID] && [WXApi isWXAppInstalled]) {
                [[WXApiManager sharedWXApiManager] sendAuthRequestWithController:self delegate:self];
            } else {
                [self setupAlertController];
            }
#else
            [self alertPromptMessage:NSLocalizedString(@"没有集成微信登录功能！", nil) okActionBlock:nil];
#endif
            break;
        }
        case 1: { // 游客登录
            [self HTTPTouristsLogin];
            break;
        }
        default:
            break;
    }
}

- (BOOL)verifyWXAppID
{
    // 验证微信注册ID
    NSString *appId = [AppModel shareInstance].wxAppid;
    if (![kAppID isEqualToString:appId]) {
        [self alertPromptMessage:[NSString stringWithFormat:NSLocalizedString(@"警告：微信AppID配置错误！\n[%@]", nil), appId]
                   okActionBlock:nil];
        // 重新获取配置信息
        [self HTTPGetLoginConfiguration];
        return NO;
    }

    return YES;
}

- (void)setupAlertController
{
#ifdef _PROJECT_WITH_WECHAT_
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"温馨提示", nil)message:NSLocalizedString(@"请先安装微信客户端", nil)preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"取消", nil) style:UIAlertActionStyleCancel handler:nil]];
    
    [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"确定", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:[WXApi getWXAppInstallUrl]]]){
            if (@available(iOS 10.0, *)) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[WXApi getWXAppInstallUrl]] options:@{} completionHandler:nil];
            } else {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[WXApi getWXAppInstallUrl]]];
            }
        }
    }]];
    [self presentViewController:alert animated:YES completion:nil];
#endif
}

-(void)actionSheetDelegateWithActionSheet:(ActionSheetCus *)actionSheet index:(NSInteger)index{
    NSArray *arr = [[AppModel shareInstance] ipArray];
    if(index > arr.count) {
        return;
    }
    
    if(index == arr.count) {
        AddIpViewController *vc = [[AddIpViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }else {
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        [ud setObject:INT_TO_STR(index) forKey:@"serverIndex"];
        [ud synchronize];
        AppModel *instance=[AppModel shareInstance] ;
        NSArray *arr = [instance ipArray];
        NSDictionary *dic = arr[index];
        if (dic) {
            NSString *serviceURL = dic[@"url"];
            if (serviceURL) {
                instance.serverUrl = serviceURL;
            }
        }else{
            NSString *urlString = [ud stringForKey:@"currentURL"];
            instance.serverUrl = urlString;
        }
        SVP_SUCCESS_STATUS(NSLocalizedString(@"切换成功", nil));
//        [[FunctionManager sharedInstance] performSelector:@selector(exitApp) withObject:nil afterDelay:1.0];
    }
}

#pragma mark - HTTP Request ...

-(void)HTTPinitLoginData{
    __weak typeof(self) tempVC = self;
    dispatch_main_async_safe(^{
        SVP_SHOW;
    });
    [NET_REQUEST_MANAGER checkLoginWithDic:nil success:^(id object) {
        dispatch_main_async_safe(^{
            SVP_DISMISS;
        });
        LoginRegisterModel *model = [LoginRegisterModel mj_objectWithKeyValues:object];
        tempVC.loginNetData = [model getLoginTypes];
        [tempVC HTTPFetchAnimatorImageCode:GetSmsCodeFromVCLoginBySMS];
        [tempVC assembleLoginInitData];
        
    } fail:^(id object) {
        dispatch_main_async_safe(^{
            SVP_DISMISS;
        });
        [[FunctionManager sharedInstance] handleFailResponse:object];
    }];
}

-(void)HTTPinitRegisterData{
    __weak typeof(self) tempVC = self;
    dispatch_main_async_safe(^{
        SVP_SHOW;
    });
    [NET_REQUEST_MANAGER checkRegisterWithDic:nil success:^(id object) {
        dispatch_main_async_safe(^{
            SVP_DISMISS;
        });
        LoginRegisterModel* model = [LoginRegisterModel mj_objectWithKeyValues:object];
        NSInteger registerMobielType=65535;
        NSInteger registerUsernameType=65535;
        for (LoginRegisterData *subModel in model.data) {
            if ([subModel.itemId isEqualToString:@"user_name"]) {
                NSLog(@"_________have user name regiseter___________");
                registerUsernameType=subModel.priorityLevel;
                tempVC.isHaveUsernameRegiseter=YES;
            }else if ([subModel.itemId isEqualToString:@"mobile"]){
                registerMobielType = subModel.priorityLevel;
            }
        }
        if (registerUsernameType < registerMobielType) {
            self.loginTypeUI = FYLoginUITypeToRegisterUsername;
        }
        tempVC.registerNetData = [model getRegisterTypes];
        [tempVC HTTPFetchAnimatorImageCode:GetSmsCodeFromVCRegister];
        [tempVC initRegisterData:NO];
    } fail:^(id object) {
        [[FunctionManager sharedInstance] handleFailResponse:object];
        dispatch_main_async_safe(^{
            SVP_DISMISS;
        });
    }];
}
-(void)HTTPFetchAnimatorImageCode:(GetSmsCodeFromVCType)type{
    __weak typeof(self) tempVC = self;
    NSString *rsa=[RSA randomlyGenerated16BitString];;
    if (type == GetSmsCodeFromVCLoginBySMS) {
        self.rsaGeneratedLogin = rsa;
    }else if (type == GetSmsCodeFromVCRegister){
        self.rsaGeneratedRegister=rsa;
    }else{
        return;
    }
    [NET_REQUEST_MANAGER requestImageCaptchaWithPhone:rsa type:type success:^(id object) {
        [SVProgressHUD dismiss];
        if (type == GetSmsCodeFromVCLoginBySMS) {
            tempVC.animatorImageCodeLogin = object;
        }else if (type == GetSmsCodeFromVCRegister){
            tempVC.animatorImageCodeRegister = object;
        }
        [tempVC.tableView reloadData];
    } fail:^(id object) {
        [[FunctionManager sharedInstance] handleFailResponse:object];
        [tempVC.tableView reloadData];
    }];
}

-(void)HTTPFetchMobileCode:(UIButton *)sender{
    [self.view endEditing:YES];
    FYFieldModel *phoneModel = [self getCellDataWithCode:@"mobile"];
    if (!phoneModel) {
        phoneModel=[self getCellDataWithCode:@"mobile_user"];
        if (!phoneModel) {
            return;
        }
    }
    if (phoneModel.value.length < 8 || phoneModel.value.length > 11) {
        SVP_ERROR_STATUS(NSLocalizedString(@"请输入正确的手机号", nil));
        return;
    }
    GetSmsCodeFromVCType type;
    if (self.viewType == FYShowRegister) {
        type = GetSmsCodeFromVCRegister;
    }else{
        type = GetSmsCodeFromVCLoginBySMS;
    }
    [NET_REQUEST_MANAGER requestSmsCodeWithPhone:phoneModel.value type:GetSmsCodeFromVCRegister success:^(id object) {
        SVP_SUCCESS_STATUS(NSLocalizedString(@"发送成功，请注意查收短信", nil));
        NSInteger time = 60;
        if ([object isKindOfClass:[NSDictionary class]]
            && ![FunctionManager isEmpty:object[@"data"]]) {
            NSDictionary *dict = (NSDictionary *)object;
            time = [dict integerForKey:@"data"];
        }
        [sender beginTime:(int)time];
    } fail:^(id object) {
        [[FunctionManager sharedInstance] handleFailResponse:object];
    }];
}

- (void)HTTPGetLoginConfiguration
{
    NSDictionary *getConfig=@{@"loginType":@"1",
                              @"loginWay":@"0"};
    __weak typeof(self) tempVC = self;
    dispatch_main_async_safe(^{
        SVP_SHOW;
    });
    [NET_REQUEST_MANAGER getLoginConfig:getConfig successBlock:^(NSDictionary *success) {
        if ([success isKindOfClass:[NSDictionary class]]) {
            NSDictionary *data = [success valueForKey:@"data"];
            if (data) {
                NSString *appid=[data valueForKey:@"appId"];
                NSString *appsecret = [data valueForKey:@"secret"];
                NSInteger isenable = [[data valueForKey:@"enableFlag"] integerValue];
                NSUserDefaults *userDefault=[NSUserDefaults standardUserDefaults];
                [userDefault setInteger:isenable forKey:@"enableFlag"];
                [userDefault synchronize];
                [tempVC.loginFooterView updateBottomWeiXingLoginButton];
                if (appid) {
                    [AppModel shareInstance].wxAppid = appid;
                    // [WXApiManager registerApp:appid universalLink:kAppUniversalLink];
                }
                if (appsecret) {
                    [AppModel shareInstance].wxAppSecret = appsecret;
                }
            }
        }
        //
        [NET_REQUEST_MANAGER requestAppConfigWithSuccess:^(id object) {
            dispatch_main_async_safe(^{
                SVP_DISMISS;
            });
            if ([object isKindOfClass:[NSDictionary class]]) {
                NSDictionary *result = object;
                [[AppModel shareInstance] updateCommonInformation:result];
                [tempVC.loginFooterView updateBottomTouristsLoginButton];
            }
        } fail:^(id object) {
            dispatch_main_async_safe(^{
                SVP_DISMISS;
            });
        }];
    } failureBlock:^(NSError *failure) {
        dispatch_main_async_safe(^{
            SVP_DISMISS;
        });
        [[FunctionManager sharedInstance] handleFailResponse:failure];
        NSLog(@"get login configuration failure:%@",failure);
    }];
}

- (void)HTTPLoginAction
{
    [self.view endEditing:YES];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    NSString *passwordA = @"";
    NSString *mobile=@"";
    for (FYFieldModel *model in self.datalist) {
        if ([model.key isEqualToString:@"mobile"]) {
            if (model.value.length<8 || model.value.length > 11) {
                SVP_ERROR_STATUS(NSLocalizedString(@"请输入正确的手机号", nil));
                return;
            }
            mobile = model.value;
            [dic setValue:model.value forKey:model.key];
        }else if ([model.key isEqualToString:@"mobile_user"]){
            if (model.value.length < 1) {
                SVP_ERROR_STATUS(NSLocalizedString(@"请输入手机号/用户名", nil));
                return;
            }
            if ([model.value mj_isPureInt]) {
                [dic setValue:model.value forKey:@"mobile"];
            }else{
                [dic setValue:model.value forKey:@"user_name"];
            }
            mobile = model.value;
        }else if ([model.key isEqualToString:@"mobile_code"]){
            if (model.value.length < 1) {
                SVP_ERROR_STATUS(NSLocalizedString(@"请输入验证码", nil));
                return;
            }
            [dic setValue:model.value forKey:model.key];
        }else if ([model.key isEqualToString:@"passwd"]){
            if (model.value.length < 6 ||model.value.length > 16) {
                SVP_ERROR_STATUS(NSLocalizedString(@"请输入6-16位密码", nil));
                return;
            }
            passwordA = model.value;
            NSData *data = [model.value dataUsingEncoding:NSUTF8StringEncoding];
            data = [data AES128EncryptWithKey:kAccountPasswordKey gIv:kAccountPasswordKey];
            data = [GTMBase64 encodeData:data];
            NSString *sPassword = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            [dic setValue:sPassword forKey:model.key];
        }else if ([model.key isEqualToString:@"passwd_re"]){
            if (![model.value isEqualToString:passwordA]) {
                SVP_ERROR_STATUS(NSLocalizedString(@"密码不一致", nil));
                return;
            }
        }else if ([model.key isEqualToString:@"pic_code"]){
            if (model.value.length < 3) {
                SVP_ERROR_STATUS(NSLocalizedString(@"请输入图形验证码", nil));
                return;
            }
            [dic setValue:model.value forKey:model.key];
            if (self.viewType == FYShowRegister) {
                [dic setValue:self.rsaGeneratedRegister forKey:@"picCodeUUID"];
            }else{
                [dic setValue:self.rsaGeneratedLogin forKey:@"picCodeUUID"];
            }
        }else{
            if (model.isRequire) {
                if (model.value.length < 1) {
                    NSString *message = [NSString stringWithFormat:NSLocalizedString(@"请输入%@", nil),model.place];
                    SVP_ERROR_STATUS(message);
                    return;
                }
                [dic setValue:model.value forKey:model.key];
            }else{
                [dic setValue:(model.value.length > 0 ? model.value : @"") forKey:model.key];
            }
        }
    }
    
    
    NSLog(@"login:%@",dic);
    __weak typeof(self) tempVC = self;
    if ([AppModel shareInstance].commonInfo == nil||
        [AppModel shareInstance].appClientIdInCommonInfo==nil) {
        dispatch_main_async_safe(^{
            SVP_SHOW;
        });
        [NET_REQUEST_MANAGER requestAppConfigWithSuccess:^(id object) {
            if ([object isKindOfClass:[NSDictionary class]]) {
                NSDictionary *result = object;
                [[AppModel shareInstance] updateCommonInformation:result];
            }
            [NET_REQUEST_MANAGER toLogin:dic successBlock:^(NSDictionary *object) {
                dispatch_main_async_safe(^{
                    SVP_DISMISS;
                });
                [[AppModel shareInstance] setLoginType:FYLoginTypeDefault];
                if([object isKindOfClass:[NSDictionary class]]){
                    if ([object objectForKey:@"code"] && [[object objectForKey:@"code"] integerValue] == 0) {
                    }
                    if (mobile.length > 2) {
                        SetUserDefaultKeyWithObject(@"mobilemobile", mobile);
                        [[NSUserDefaults standardUserDefaults] synchronize];
                    }
                    [[AppModel shareInstance] loginToUpdateUserInformation:YES];
                    [FYFriendName httpGetFriends];
                }
            } failureBlock:^(NSError *failure) {
                dispatch_main_async_safe(^{
                    SVP_DISMISS;
                });
                [tempVC loginFailureAction:failure];
            }];
        } fail:^(id object) {
            dispatch_main_async_safe(^{
                SVP_DISMISS;
            });
            SVP_ERROR_STATUS(NSLocalizedString(@"网络请求初始化接口失败，稍后重试...", nil));
        }];
        
    } else {
        dispatch_main_async_safe(^{
            SVP_SHOW;
        });
        [NET_REQUEST_MANAGER toLogin:dic successBlock:^(NSDictionary *object) {
            dispatch_main_async_safe(^{
                SVP_DISMISS;
            });
            [[AppModel shareInstance] setLoginType:FYLoginTypeDefault];
            if (mobile.length > 2) {
                SetUserDefaultKeyWithObject(@"mobilemobile", mobile);
                [[NSUserDefaults standardUserDefaults] synchronize];
            }
            NSDictionary *dict = [[object mj_JSONString] mj_JSONObject];
            if (dict != nil) {
                [[AppModel shareInstance] loginToUpdateUserInformation:YES];
                [FYFriendName httpGetFriends];
            }
        } failureBlock:^(NSError *failure) {
            dispatch_main_async_safe(^{
                SVP_DISMISS;
            });
            [tempVC loginFailureAction:failure];
        }];
    
    }
}

- (void)HTTPTouristsLogin{
    [NET_REQUEST_MANAGER toGuestLoginAPI:nil successBlock:^(NSDictionary *success) {
        NSLog(@"%@",success);
        if ([success isKindOfClass:[NSDictionary class]]) {
            NSInteger code = [[success valueForKey:@"code"] integerValue];
            if (code == 0) {
                [[AppModel shareInstance] setLoginType:FYLoginTypeGuest];
                [[AppModel shareInstance] loginToUpdateUserInformation:YES];
                return;
            }
        }
        [[FunctionManager sharedInstance] handleFailResponse:success];
    } failureBlock:^(NSError *failure) {
        [[FunctionManager sharedInstance] handleFailResponse:failure];
    }];
    NSLog(NSLocalizedString(@"游客登录", nil));
}

- (void)HTTPToRegister {
    [self.view endEditing:YES];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    NSString *passwordA = @"";
    for (FYFieldModel *model in self.datalist) {
        if ([model.key isEqualToString:@"mobile"]) {
            if (model.value.length<8 || model.value.length > 11) {
                if (self.loginTypeUI == FYLoginUITypeToRegisterUsername) {
                    
                }else{
                    SVP_ERROR_STATUS(NSLocalizedString(@"请输入正确的手机号", nil));
                    return;
                }
                
            }
            [dic setValue:model.value forKey:model.key];
        }else if ([model.key isEqualToString:@"mobile_code"]){
            if (model.value.length < 1) {
                SVP_ERROR_STATUS(NSLocalizedString(@"请输入验证码", nil));
                return;
            }
            [dic setValue:model.value forKey:model.key];
        }else if ([model.key isEqualToString:@"passwd"]){
            if (model.value.length < 6 ||model.value.length > 16) {
                SVP_ERROR_STATUS(NSLocalizedString(@"请输入6-16位密码", nil));
                return;
            }
            passwordA = model.value;
//            NSData *data = [model.value dataUsingEncoding:NSUTF8StringEncoding];
//            data = [data AES128EncryptWithKey:kAccountPasswordKey gIv:kAccountPasswordKey];
//            data = [GTMBase64 encodeData:data];
//            NSString *sPassword = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//            [dic setValue:sPassword forKey:model.key];
            [dic setValue:model.value forKey:model.key];
        }else if ([model.key isEqualToString:@"passwd_re"]){
            if (![model.value isEqualToString:passwordA]) {
                SVP_ERROR_STATUS(NSLocalizedString(@"密码不一致", nil));
                return;
            }
        }else if ([model.key isEqualToString:@"pic_code"]){
            if (model.value.length < 3) {
                if (model.isRequire == YES) {
                    SVP_ERROR_STATUS(NSLocalizedString(@"请输入图形验证码", nil));
                    return;
                }
            }
            [dic setValue:model.value forKey:model.key];
            if (self.viewType == FYShowRegister) {
                [dic setValue:self.rsaGeneratedRegister forKey:@"picCodeUUID"];
            }else{
                [dic setValue:self.rsaGeneratedLogin forKey:@"picCodeUUID"];
            }
        }else if ([model.key isEqualToString:@"sex"]){
            NSInteger typeSex = [model.value isEqualToString:NSLocalizedString(@"男", nil)] ? 0 : 1;
            [dic setValue:@(typeSex) forKey:model.key];
            
        }else{
            if (model.isRequire == YES) {
                if (model.value.length < 1) {
                    NSString *message = [NSString stringWithFormat:NSLocalizedString(@"请输入%@", nil),model.place];
                    SVP_ERROR_STATUS(message);
                    return;
                }
                [dic setValue:model.value forKey:model.key];
            }else{
                [dic setValue:(model.value.length > 0 ? model.value : @"") forKey:model.key];
            }
        }
    }
    SVP_SHOW;
    WEAK_OBJ(weakSelf, self);
    [NET_REQUEST_MANAGER toRegisterAPI:dic successBlock:^(NSDictionary *success) {
        [[AppModel shareInstance] setLoginType:FYLoginTypeDefault];
        SVP_SUCCESS_STATUS(NSLocalizedString(@"注册成功", nil));
        [weakSelf.headerView buttonAction:weakSelf.headerView.buttonLeft];
        [weakSelf.navigationController popViewControllerAnimated:YES];
        [[AppModel shareInstance] loginToUpdateUserInformation:YES];
    } failureBlock:^(NSError *failure) {
        [[FunctionManager sharedInstance] handleFailResponse:failure];
    }];
}


#pragma mark - 微信登录回调通知
- (void)wxAuthSucceed:(NSString *)code
{
    if ([FunctionManager isEmpty:code]) {
        [self alertPromptMessage:NSLocalizedString(@"微信授权码为空！", nil) okActionBlock:nil];
        return;
    }
    
    MBProgressHUD* hud = [MBProgressHUD showHUDAddedTo:self.view animated: YES];
    hud.minSize = CGSizeMake(150.0f, 100.0f);
    hud.label.text = NSLocalizedString(@"获取微信 AccessToken ...", nil);
    hud.contentColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.6];
    
    [WXApiNetManager getAccessTokenWithRespCode:code callback:^(BOOL requestStatus, NSDictionary *response) {
        if (requestStatus) {
            dispatch_async(dispatch_get_main_queue(), ^{
                hud.label.text = NSLocalizedString(@"获取微信 AccessToken 成功！", nil);
                //
                NSString *openid = response[@"openid"];
                NSString *unionid = response[@"unionid"];
                NSString *accessToken = response[@"access_token"];
                //
                if(accessToken && ![accessToken isEqualToString:@""] && openid && ![openid isEqualToString:@""]){
                    [self getWechatUserInfoFromServerWithHud:hud unionId:unionid token:accessToken openid:openid];
                } else {
                    hud.label.text = NSLocalizedString(@"微信 AccessToken 不能为空！", nil);
                    [hud hideAnimated:YES afterDelay:1.0f];
                }
            });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                hud.label.text = NSLocalizedString(@"获取微信 AccessToken 失败！", nil);
                [hud hideAnimated:YES afterDelay:1.0f];
            });
        }
    }];
}

- (void)wxAuthCommon
{
    [self alertPromptMessage:NSLocalizedString(@"普通类型错误！", nil) okActionBlock:^(NSString *content) {
        
    }];
}

- (void)wxAuthCancel
{
    [self alertPromptMessage:NSLocalizedString(@"用户已取消授权！", nil) okActionBlock:^(NSString *content) {
        
    }];
}

- (void)wxAuthSentFail
{
    [self alertPromptMessage:NSLocalizedString(@"微信发送失败！", nil) okActionBlock:^(NSString *content) {
        
    }];
}

- (void)wxAuthDenied
{
    [self alertPromptMessage:NSLocalizedString(@"用户拒绝授权！", nil) okActionBlock:^(NSString *content) {
        
    }];
}

- (void)wxAuthUnsupport
{
    [self alertPromptMessage:NSLocalizedString(@"微信不支持！", nil) okActionBlock:^(NSString *content) {
        
    }];
}

- (void)getWechatUserInfoFromServerWithHud:(MBProgressHUD *)hud
                                   unionId:(NSString *)unionId
                                     token:(NSString *)token
                                    openid:(NSString *)openid
{
    hud.label.text = NSLocalizedString(@"验证微信账号信息...", nil);
    
    // mobile/thirdparty/check
    NSDictionary *dict = @{@"unionid":unionId};
    __weak typeof(self) tempVC = self;
    [NET_REQUEST_MANAGER thirdpartyCheck:dict successBlock:^(NSDictionary *success) {
        NSDictionary *result=[success mj_JSONObject];
        NSInteger code = [[result valueForKey:@"code"] integerValue];
        if (code == 0) {
            [[AppModel shareInstance] setLoginType:FYLoginTypeWeChat];
            NSInteger check = [[result valueForKeyPath:@"data.is_exist"] integerValue];
            if (check == 1) {
                //直接登录
                dispatch_async(dispatch_get_main_queue(), ^{
                    hud.label.text = NSLocalizedString(@"正在登录中...", nil);
                    [hud hideAnimated:YES afterDelay:1.0f];
                });
                //toLogin
                NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
                [userDefault setValue:unionId forKey:@"WXunionID"];
                [userDefault synchronize];
                [[AppModel shareInstance] loginToUpdateUserInformation:YES];
            } else {
                [self getWechatUserInfoFromServerWithHud:hud token:token openid:openid];
            }
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                hud.label.text = NSLocalizedString(@"验证微信账号信息失败！", nil);
                [hud hideAnimated:YES afterDelay: 1.0f];
            });
        }
    } failureBlock:^(NSError *failure) {
        //
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hideAnimated:YES];
        });
        //
        if ([failure isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dict = (NSDictionary *)failure;
            NSString *message = dict[@"alterMsg"];
            if ([message containsString:NSLocalizedString(@"封号", nil)]) {
                //您已经被封号，请与客服联系！
                [FYAlertDangerView alertShowFromVC:tempVC result:^(UIButton * _Nonnull button) {
                    NSLog(@"%@",button.currentTitle);
                    if ([button.currentTitle isEqualToString:NSLocalizedString(@"联系客服", nil)]) {
                        WebViewController *vc = [[WebViewController alloc] initWithUrl:[AppModel shareInstance].commonInfo[@"pop"]];
                        vc.title = NSLocalizedString(@"联系客服", nil);
                        [tempVC.navigationController pushViewController:vc animated:YES];
                    }
                }];
            } else {
                SVP_ERROR_STATUS(dict[@"alterMsg"]);
            }
        } else {
            [[FunctionManager sharedInstance] handleFailResponse:failure];
        }
    }];
}

- (void)getWechatUserInfoFromServerWithHud:(MBProgressHUD *)hud
                                     token:(NSString *)token
                                    openid:(NSString *)openid
{
    hud.label.text = NSLocalizedString(@"获取微信信息 Userinfo ...", nil);
    [WXApiNetManager getUserInfoWithToken:token openid:openid callback:^(BOOL requestStatus, NSDictionary * response) {
        if (requestStatus) {
            dispatch_async(dispatch_get_main_queue(), ^{
                hud.label.text = NSLocalizedString(@"获取微信 Userinfo 信息成功！", nil);
                [hud hideAnimated:YES afterDelay:1.0f];
                //
                [self HTTPWechatBindCode:response];
            });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                hud.label.text = NSLocalizedString(@"获取微信 Userinfo 信息失败！", nil);
                [hud hideAnimated:YES afterDelay:1.0f];
            });
        }
    }];
}

/*
- (void)HTTPWechatCheck:(NSString *)unionID token:(NSString *)token openid:(NSString *)openid
{
    //mobile/thirdparty/check
    NSDictionary *dict=@{@"unionid":unionID};
    __weak typeof(self) tempVC = self;
    [NET_REQUEST_MANAGER thirdpartyCheck:dict successBlock:^(NSDictionary *success) {
        NSDictionary *result=[success mj_JSONObject];
        NSInteger code = [[result valueForKey:@"code"] integerValue];
        if (code == 0) {
            [[AppModel shareInstance] setLoginType:FYLoginTypeWeChat];
            NSInteger check = [[result valueForKeyPath:@"data.is_exist"] integerValue];
            if (check == 1) {
                //toLogin
                NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
                [userDefault setValue:unionID forKey:@"WXunionID"];
                [userDefault synchronize];
                [[AppModel shareInstance] loginToUpdateUserInformation:YES];
                [FYFriendName httpGetFriends];
            }else{
                [tempVC HTTPGetWeChatInformation:token openid:openid];
            }
        }
    } failureBlock:^(NSError *failure) {
        if ([failure isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dict = (NSDictionary *)failure;
            NSString *message = dict[@"alterMsg"];
            if ([message containsString:NSLocalizedString(@"封号", nil)]) {
                //您已经被封号，请与客服联系！
                [FYAlertDangerView alertShowFromVC:tempVC result:^(UIButton * _Nonnull button) {
                    NSLog(@"%@",button.currentTitle);
                    if ([button.currentTitle isEqualToString:NSLocalizedString(@"联系客服", nil)]) {
                        WebViewController *vc = [[WebViewController alloc] initWithUrl:[AppModel shareInstance].commonInfo[@"pop"]];
                        vc.title = NSLocalizedString(@"联系客服", nil);
                        [tempVC.navigationController pushViewController:vc animated:YES];
                    }
                }];
            }else{
                SVP_ERROR_STATUS(dict[@"alterMsg"]);
            }
        }else{
            [[FunctionManager sharedInstance] handleFailResponse:failure];
        }
        
    }];
}

- (void)HTTPGetWeChatInformation:(NSString *)token openid:(NSString *)openID{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/userinfo?access_token=%@&openid=%@",token,openID]];
    __weak typeof(self) tempVC = self;
    NSURLSessionDataTask *task=[[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSDictionary *dict = [data mj_JSONObject];
        [tempVC HTTPWechatBindCode:dict];
    }];
    [task resume];
}
*/
 
- (void)HTTPWechatBindCode:(NSDictionary *)sender
{
    UIViewController *controller=[UIViewController new];
    controller.view.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0.5];
    controller.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    controller.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    FYAlertWechatBindCodeView *centerView = [[FYAlertWechatBindCodeView alloc] initWithFrame:CGRectMake(0, (SCREEN_HEIGHT - SCREEN_WIDTH) * 0.5, SCREEN_WIDTH, SCREEN_WIDTH)];
    [self checkOpenInstalll:centerView.textField];
    __weak typeof(self) tempVC = self;
    centerView.buttonCallBack = ^(UIButton * _Nonnull button, NSString * _Nonnull code) {
        if (button.tag == 1) {
            [controller dismissViewControllerAnimated:NO completion:nil];
            //点击了取消
        }else if (button.tag == 999){
            [controller dismissViewControllerAnimated:NO completion:nil];
            //请联系客服
            [tempVC feedback];
        }else if (button.tag == 2) { //to bind
//            button.enabled = NO;
            NSString *nickName = [sender valueForKey:@"nickname"];
            NSInteger sex = [[sender valueForKey:@"sex"] integerValue];
            if (sex == 0) {
                sex = 1;
            }
            NSString *avatar = [sender valueForKey:@"headimgurl"];
            NSString *openID = [sender valueForKey:@"openid"];
            NSString *unionid = [sender valueForKey:@"unionid"];
            //微信用户注册：
            //{"headimgurl":"https://www.fdsf/icon.png","invite_code":"33183","nick":"zhangsan","sex":"0","wechat":"openidxxxxxx"
            [SVProgressHUD show];
            NSDictionary *sendDict=@{@"headimgurl":avatar,
                                     @"invite_code":code,
                                     @"nick":nickName,
                                     @"sex":@(sex),
                                     @"wechat":openID,
                                     @"unionid":unionid};
            [NET_REQUEST_MANAGER thirdPartRegister:sendDict successBlock:^(NSDictionary *success) {
                [controller dismissViewControllerAnimated:NO completion:nil];
                NSLog(NSLocalizedString(@"微信绑定成功:%@", nil),success);
                [SVProgressHUD dismiss];
                //更新信息
                NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
                [userDefault setValue:unionid forKey:@"WXunionID"];
                [userDefault synchronize];
                [[AppModel shareInstance] loginToUpdateUserInformation:YES];
            } failureBlock:^(NSError *failure) {
                NSLog(@"failure:%@",failure);
                [SVProgressHUD dismiss];
                [[FunctionManager sharedInstance] handleFailResponse:failure];
            }];
        }
        
    };
    
    [controller.view addSubview:centerView];
    [self presentViewController:controller animated:YES completion:nil];
}

- (void)checkOpenInstalll:(UITextField *)field
{
    if (!VALIDATE_STRING_EMPTY(kOpenInviteCode)) {
        field.text = kOpenInviteCode;
        field.enabled = NO;
    } else {
#ifdef _PROJECT_WITH_OPENINSTALL_
        NSString *nubmer = VALIDATE_STRING_EMPTY(kOpenInviteCode) ? GetUserDefaultWithKey(kUserDefaultsStandardKeyOpenInstallCode) : kOpenInviteCode;
        if (nubmer.length > 0) {
            field.text = nubmer;
            field.enabled = NO;
        } else {
            field.enabled = YES;
            [[OpenInstallSDK defaultManager] getInstallParmsCompleted:^(OpeninstallData*_Nullable appData) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    // 在主线程中回调
                    if (appData.data) {//(动态安装参数)
                        //e.g.如免填邀请码建立邀请关系、自动加好友、自动进入某个群组或房间等
                    }
                    if (appData.channelCode) { //(通过渠道链接或二维码安装会返回渠道编号)
                        //e.g.可自己统计渠道相关数据等
                    }
                    NSString *codeNumber = VALIDATE_STRING_EMPTY(kOpenInviteCode) ? appData.data[@"code"] : kOpenInviteCode;
                    if (codeNumber.length > 0) {
                        field.text = codeNumber;
                        SetUserDefaultKeyWithObject(kUserDefaultsStandardKeyOpenInstallCode, codeNumber);
                        field.enabled = NO;
                    }
                    NSLog(NSLocalizedString(@"OpenInstallSDK:\n动态参数：%@;\n渠道编号：%@", nil),appData.data,appData.channelCode);
                });
            }];
        }
#endif
    }
}

- (void)loginFailureAction:(NSError *)failure{
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

#pragma mark - Lazy loading ...

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView=[[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            // Fallback on earlier versions
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
        _tableView.clipsToBounds = NO;
        [_tableView registerClass:[FY2020LoginInputCell class] forCellReuseIdentifier:@"FY2020LoginInputCell"];
        [_tableView registerClass:[FY2020LoginActionCell class] forCellReuseIdentifier:@"FY2020LoginActionCell"];
        [_tableView registerClass:[FY2020LoginRedActionCell class] forCellReuseIdentifier:@"FY2020LoginRedActionCell"];
        [_tableView registerClass:[FY2020LoginRightButtonCell class] forCellReuseIdentifier:@"FY2020LoginRightButtonCell"];
        [self.view addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
        _tableView.backgroundColor = [UIColor colorWithWhite:0.93725 alpha:1];
        _tableView.tableFooterView = [UIView new];
        _tableView.bounces = NO;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.translatesAutoresizingMaskIntoConstraints = NO;
        [_tableView.topAnchor constraintEqualToAnchor:self.view.topAnchor].active = YES;
        [_tableView.leftAnchor constraintEqualToAnchor:self.view.leftAnchor].active = YES;
        [_tableView.rightAnchor constraintEqualToAnchor:self.view.rightAnchor].active = YES;
        [_tableView.bottomAnchor constraintEqualToAnchor:self.bottomImage.topAnchor].active = YES;
    }
    return _tableView;
}

- (FY2020LoginHeaderView *)headerView{
    if (!_headerView) {
        CGSize mainsize = [UIScreen mainScreen].bounds.size;
        _headerView = [[FY2020LoginHeaderView alloc] initWithFrame:CGRectMake(0, 0, mainsize.width, mainsize.width * (405.0/719.0) + 50)];
        _headerView.backgroundColor = [UIColor colorWithWhite:0.93725 alpha:1];
        __weak typeof(self) tempVC = self;
        _headerView.buttonCallBack = ^(UIButton * _Nonnull btn) {
            [tempVC buttonAction:btn];
        };
    }
    return _headerView;
}

- (FYLaunchristPageFooterView *)loginFooterView{
    if (!_loginFooterView) {
        _loginFooterView = [[FYLaunchristPageFooterView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 300)];
        _loginFooterView.delegate = self;
        _loginFooterView.textView.label.text = NSLocalizedString(@"第三方登录", nil);
    }
    return _loginFooterView;
}

- (UIImageView *)bottomImage{
    if (!_bottomImage) {
        _bottomImage = [UIImageView new];
        _bottomImage.image = [UIImage imageNamed:@"icon_login_bottom"];
        [self.view addSubview:_bottomImage];
        _bottomImage.translatesAutoresizingMaskIntoConstraints = NO;
        [_bottomImage.leftAnchor constraintEqualToAnchor:self.view.leftAnchor].active = YES;
        [_bottomImage.rightAnchor constraintEqualToAnchor:self.view.rightAnchor].active = YES;
        [_bottomImage.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor].active = YES;
        [_bottomImage.heightAnchor constraintEqualToAnchor:self.view.widthAnchor multiplier:65.0/719].active = YES;
#if DEBUG
        UIButton *buttonLeft=[UIButton new];
        [self.view addSubview:buttonLeft];
        UIButton *buttonRight=[UIButton new];
        [self.view addSubview:buttonRight];
        [buttonLeft mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.equalTo(self.view);
            make.size.mas_equalTo(CGSizeMake(100, 50));
        }];
        [buttonRight mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.bottom.equalTo(self.view);
            make.size.mas_equalTo(CGSizeMake(100, 50));
        }];
        [buttonLeft addTarget:self action:@selector(tenantBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [buttonRight addTarget:self action:@selector(accountSwitch) forControlEvents:UIControlEventTouchUpInside];
#endif
    }
    return _bottomImage;
}

- (UIButton *)navigationButton{
    if (!_navigationButton) {
        _navigationButton=[UIButton new];
        _navigationButton.tag = 1000;
        [_navigationButton setImage:[UIImage imageNamed:@"icon_nav_signal"] forState:UIControlStateNormal];
        [_navigationButton setImageEdgeInsets:UIEdgeInsetsMake(0, -5, 0, 5)];
//        [_navigationButton setTitle:NSLocalizedString(@"线路选择", nil) forState:UIControlStateNormal];
        _navigationButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [_navigationButton setTitleEdgeInsets:UIEdgeInsetsMake(5, 0, 0, 0)];
//        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_navigationButton];
    }
    return _navigationButton;
}
@end
