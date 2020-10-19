//
//  LaunchFristPageVC.m
//  Project
//
//  Created by Aalto on 2019/4/30.
//  Copyright © 2019 CDJay. All rights reserved.
//  启动首页
#import "LaunchFristPageVC.h"
#import "UIView+AZGradient.h"
#import "MsgHeaderView.h"
#import "WebViewController.h"
#import "AddIpViewController.h"
//
#ifdef _PROJECT_WITH_WECHAT_
#import "WXApi.h"
#endif
#import "WXApiManager.h"

#import "FYLaunchFristPageCell.h"
#import "FYLaunchPageModel.h"
#import "FYLaunchristPageHeaderView.h"
#import "FYLaunchristPageFooterView.h"
@interface LaunchFristPageVC ()<ActionSheetDelegate,UITableViewDelegate,UITableViewDataSource,FYLaunchristPageLoginDelegate,WXAuthDelegate>
@property (nonatomic, strong)NSArray *dataSource;
@property (nonatomic, strong) MsgHeaderView *bannerView;
@property (nonatomic ,strong)FYLaunchristPageHeaderView *headerView;
@property (nonatomic ,strong)FYLaunchristPageFooterView *footerView;
@property (nonatomic ,strong)UITableView *tableView;

@end

@implementation LaunchFristPageVC
+(BaseNewNavViewController *)noLoginView{
    static BaseNewNavViewController *instance;
    @synchronized (self) {
        if (instance == nil) {
            LaunchFristPageVC *rootVC = [[LaunchFristPageVC alloc] init];
            instance = [[BaseNewNavViewController alloc]initWithRootViewController:rootVC];
        }
    }
    return instance;
}

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = COLOR_X(232, 232, 232);
    [self initCustomNav];
    [self makeUI];
    [self layoutChangeEnvirment];
    [self getLoginConfiguration];
}
- (void)makeUI{
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    WeakSelf
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf getData];
    }];
    [self.tableView.mj_header beginRefreshing];
}
- (void)getData{
    [NET_REQUEST_MANAGER requestMsgBannerWithId:OccurBannerAdsTypeLogin WithPictureSpe:OccurBannerAdsPictureTypeNormal success:^(id object) {
        FYLaunchModels *model = [FYLaunchModels mj_objectWithKeyValues:object];
        self.headerView.model = model;
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
    } fail:^(id object) {
        [self.tableView.mj_header endRefreshing];
    }];
}

-(void)getLoginConfiguration{
    NSDictionary *getConfig=@{@"loginType":@"1",
                              @"loginWay":@"0"};
    __weak typeof(self) tempVC = self;
    [NET_REQUEST_MANAGER getLoginConfig:getConfig successBlock:^(NSDictionary *success) {
        NSLog(@"get login configuration:%@",success);
        if ([success isKindOfClass:[NSDictionary class]]) {
            NSDictionary *data = [success valueForKey:@"data"];
            if (data) {
                NSString *appid=[data valueForKey:@"appId"];
                NSString *appsecret = [data valueForKey:@"secret"];
                NSInteger isenable = [[data valueForKey:@"enableFlag"] integerValue];
                if (isenable != 1) {
                    tempVC.footerView.hidden = YES;
                }
                if (appid) {
                    [AppModel shareInstance].wxAppid = appid;
                }
                if (appsecret) {
                    [AppModel shareInstance].wxAppSecret = appsecret;
                }
            }
        }
    } failureBlock:^(NSError *failure) {
        [[FunctionManager sharedInstance] handleFailResponse:failure];
        NSLog(@"get login configuration failure:%@",failure);
    }];
    [NET_REQUEST_MANAGER requestAppConfigWithSuccess:^(id object) {
        if ([object isKindOfClass:[NSDictionary class]]) {
            NSDictionary *result = object;
            [[AppModel shareInstance] updateCommonInformation:result];
            [tempVC.footerView updateBottomTouristsLoginButton];
        }
    } fail:^(id object) {
        
    }];
}

#pragma mark - HTTP
//https://api.weixin.qq.com/sns/auth?access_token=ACCESS_TOKEN&openid=OPENID

-(void)httpGetWeChatInformation:(NSString *)token openid:(NSString *)openID{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/userinfo?access_token=%@&openid=%@",token,openID]];
    __weak typeof(self) tempVC = self;
    NSURLSessionDataTask *task=[[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSDictionary *dict = [data mj_JSONObject];
        [tempVC wechatBindCode:dict];
    }];
    [task resume];
}

-(void)httpWechatCheck:(NSString *)unionID token:(NSString *)token openid:(NSString *)openid{
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
                [tempVC updateUserInformation];
            }else{
                [tempVC httpGetWeChatInformation:token openid:openid];
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

-(void)wechatBindCode:(NSDictionary *)sender{
    UIViewController *controller=[UIViewController new];
    controller.view.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0.5];
    controller.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    controller.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    FYAlertWechatBindCodeView *centerView=[[FYAlertWechatBindCodeView alloc] initWithFrame:CGRectMake(0, (SCREEN_HEIGHT - SCREEN_WIDTH) * 0.5, SCREEN_WIDTH, SCREEN_WIDTH)];
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
                [tempVC updateUserInformation];
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

-(void)updateUserInformation{
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

#pragma mark - 微信登录回调通知
- (void)wxAuthSucceed:(NSString *)code
{
    NSString *appid = [AppModel shareInstance].wxAppid;
    NSString *appsecret = [AppModel shareInstance].wxAppSecret;
    if (appid == nil) {
        [self getLoginConfiguration];
        return;
    }
    
    NSString *url = [NSString stringWithFormat:@"https://api.weixin.qq.com/sns/oauth2/access_token?appid=%@&secret=%@&code=%@&grant_type=authorization_code",appid,appsecret,code];
    __weak typeof(self) tempVC = self;
   NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithURL:[NSURL URLWithString:url] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
       NSDictionary *dict = [data mj_JSONObject];
       NSLog(@"authorization:%@",dict);
       //添加获取用户信息的接口
       NSString *openID = [dict valueForKey:@"openid"];
       if (openID) {
           NSString *token = [dict valueForKey:@"access_token"];
           NSString *unionid = [dict valueForKey:@"unionid"];
           [tempVC httpWechatCheck:unionid token:token openid:openID];
       }else{
           NSString *message = [dict valueForKey:@"errmsg"];
           SVP_ERROR_STATUS(message);
       }
    }];
    [task resume];
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


- (void)touristsLogin{
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
//    [FYAlertDangerView alertShowFromVC:self result:^(UIButton * _Nonnull button) {
//        NSLog(@"%@",button.currentTitle);
//    }];
//    [FYAlertCloseTipsView alertShowFromVC:self result:^(UIButton * _Nonnull button) {
//        NSLog(@"%@",button.currentTitle);
//    }];
//    [FYAlertWechatBindCodeView alertShowFromVC:self result:^(UIButton * _Nonnull button) {
//        NSLog(@"%@",button.currentTitle);
//    }];
//    [FYAlertToRegister alertShowFromVC:self result:^(UIButton * _Nonnull button) {
//        switch (button.tag) {
//            case 1:{
//                NSLog(NSLocalizedString(@"右上角的关闭按钮", nil));
//            }break;
//            case 2:{
//                NSLog(NSLocalizedString(@"立即注册 按钮", nil));
//            }break;
//            case 3:{
//                NSLog(NSLocalizedString(@"推出游戏模式 按钮", nil));
//            }break;
//
//            default:
//                break;
//        }
//    }];
    NSLog(NSLocalizedString(@"游客登录", nil));
}

///微信登录
- (void)weiXinLogin
{
#ifdef _PROJECT_WITH_WECHAT_
    if ([self verifyWXAppID] && [WXApi isWXAppInstalled]) {
        [[WXApiManager sharedWXApiManager] sendAuthRequestWithController:self delegate:self];
    } else {
        [self setupAlertController];
    }
#else
    [self alertPromptMessage:NSLocalizedString(@"没有集成微信登录功能！", nil) okActionBlock:nil];
#endif
}

- (BOOL)verifyWXAppID
{
    // 验证微信注册ID
    NSString *appId = [AppModel shareInstance].wxAppid;
    if (![kAppID isEqualToString:appId]) {
        [self alertPromptMessage:[NSString stringWithFormat:NSLocalizedString(@"警告：微信AppID配置错误！\n[%@]", nil), appId]
                   okActionBlock:nil];
        // 重新获取配置信息
        [self getLoginConfiguration];
        return NO;
    }
     
    return YES;
}

- (void)setupAlertController {
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

#pragma mark - 添加切换环境按钮

- (void)layoutChangeEnvirment {
    
#if DEBUG
    UIButton *serviceBtn = [[UIButton alloc] init];
    [serviceBtn addTarget:self action:@selector(envirmentBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:serviceBtn];
    [serviceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.equalTo(self.view);
        make.width.equalTo(@60);
        make.height.equalTo(@80);
    }];

    UIButton *tenantBtn = [[UIButton alloc] init];
    [tenantBtn addTarget:self action:@selector(tenantBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:tenantBtn];
    [tenantBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.equalTo(self.view);
        make.width.equalTo(@60);
        make.height.equalTo(@80);
    }];
#endif
    
}


#pragma mark - ActionSheetDelegate

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

#pragma mark - Action

- (void)envirmentBtnClick {
    
    [self accountSwitch];
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

- (void)feedback {
    WebViewController *vc = [[WebViewController alloc] initWithUrl:[AppModel shareInstance].commonInfo[@"pop"]];
    vc.title = NSLocalizedString(@"联系客服", nil);
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)getPingRouteChoice{
    PingViewController *vc = [[PingViewController alloc] init];
    CDPush(self.navigationController, vc, YES);
}

- (void)initCustomNav {
    self.title = NSLocalizedString(@"登录注册", nil);
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"线路选择", nil) style:UIBarButtonItemStyleDone target:self action:@selector(getPingRouteChoice)];
    self.navigationItem.rightBarButtonItem = item;
    
}

#pragma mark - UITableViewDelegate,UITableViewDataSource
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:
            CDPush(self.navigationController, CDVC(@"LoginViewController"), YES);
            break;
        case 1:
            CDPush(self.navigationController, CDVC(@"RegisterViewController"), YES);
            break;
        default:
            break;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    FYLaunchFristPageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FYLaunchFristPageCell"];
    cell.model = self.dataSource[indexPath.row];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}
#pragma mark - FYLaunchristPageLoginDelegate
- (void)didSeledWihtIndx:(NSInteger)index{
    switch (index) {
        case 0://微信登录
            [self weiXinLogin];
            break;
        case 1://游客登录
            [self touristsLogin];
            break;
        default:
            break;
    }
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = UIColor.clearColor;
        _tableView.tableHeaderView = self.headerView;
        _tableView.tableFooterView = self.footerView;
        [_tableView registerClass:[FYLaunchFristPageCell class] forCellReuseIdentifier:@"FYLaunchFristPageCell"];
    }
    return _tableView;
}
- (NSArray *)dataSource{
    if (!_dataSource) {
        UIColor *color = [UIColor colorWithPatternImage:[UIImage imageNamed:@"navBarBg"]];
        FYLaunchPageModel *loginMoel = [[FYLaunchPageModel alloc]initWithTitle:NSLocalizedString(@"登录", nil) titleColor:UIColor.whiteColor backgroundColor:color];
        FYLaunchPageModel *registeredModel = [[FYLaunchPageModel alloc]initWithTitle:NSLocalizedString(@"注册", nil) titleColor:UIColor.blackColor backgroundColor:UIColor.whiteColor];
        _dataSource = @[loginMoel,registeredModel];
    }
    return _dataSource;
}
- (FYLaunchristPageHeaderView *)headerView{
    if (!_headerView) {
        _headerView = [[FYLaunchristPageHeaderView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 200)];
    }
    return _headerView;
}
- (FYLaunchristPageFooterView *)footerView{
    if (!_footerView) {
        _footerView = [[FYLaunchristPageFooterView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 300)];
        _footerView.delegate = self;
        _footerView.textView.label.text = NSLocalizedString(@"其他登录方式", nil);
    }
    return _footerView;
}
@end

@implementation FYAlertToRegister

+(void)alertShowWithResult:(void(^)(UIButton *button))callBack{
    UIViewController *controller=[UIViewController new];
    controller.view.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0.5];
    controller.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    controller.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    FYAlertToRegister *centerView=[[FYAlertToRegister alloc] initWithFrame:CGRectMake(0, (SCREEN_HEIGHT - SCREEN_WIDTH) * 0.5, SCREEN_WIDTH, SCREEN_WIDTH)];
    centerView.buttonCallBack = ^(UIButton * _Nonnull button) {
        [controller dismissViewControllerAnimated:YES completion:nil];
        callBack(button);
    };
    [controller.view addSubview:centerView];
    [[AppModel shareInstance].rootViewController presentViewController:controller animated:YES completion:nil];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIView *topView = [UIView new];
        topView.backgroundColor = UIColor.whiteColor;
        topView.layer.cornerRadius = 8;
        topView.clipsToBounds = YES;
        [self addSubview:topView];
        [topView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.mas_equalTo(20);
            make.centerX.mas_equalTo(0);
            make.height.mas_equalTo(PX(803 / 3));
        }];
        UIButton *buttonClose=[UIButton new];
        buttonClose.tag = 1;
        [buttonClose setImage:[UIImage imageNamed:@"icon_alert_close"] forState:UIControlStateNormal];
        [self addSubview:buttonClose];
        [buttonClose mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(topView.mas_right);
            make.centerY.equalTo(topView.mas_top);
            make.size.mas_equalTo(CGSizeMake(42, 42));
        }];
        UILabel *labelTitle=[UILabel new];
        UILabel *labelGray=[UILabel new];
        UILabel *labelRed=[UILabel new];
        [topView addSubview:labelTitle];
        [topView addSubview:labelGray];
        [topView addSubview:labelRed];
        labelTitle.text = NSLocalizedString(@"游客账户\n不可使用该功能", nil);
        labelTitle.textColor = UIColor.blackColor;
        labelTitle.font = [UIFont boldSystemFontOfSize:22];
        labelTitle.numberOfLines = 0;
        labelGray.text = NSLocalizedString(@"立即注册即可解锁所有功能，\n还能获得海量彩金豪礼", nil);
        labelGray.textColor = UIColor.grayColor;
        labelGray.font = [UIFont systemFontOfSize:18];
        labelGray.numberOfLines = 0;
        labelRed.text = NSLocalizedString(@"还等什么，立即注册吧", nil);
        labelRed.textColor = UIColor.redColor;
        labelRed.font = [UIFont systemFontOfSize:18];
        [labelTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(22);
            make.top.mas_equalTo(30);
        }];
        [labelGray mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(22);
            make.centerY.mas_equalTo(0);
        }];
        [labelRed mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(22);
            make.top.mas_equalTo(labelGray.mas_bottom).mas_offset(20);
        }];
        UIButton *buttonRegister=[UIButton new];
        buttonRegister.tag = 2;
        buttonRegister.backgroundColor = UIColor.redColor;
        [buttonRegister setTitle:NSLocalizedString(@"立即注册", nil) forState:UIControlStateNormal];
        [buttonRegister setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [topView addSubview:buttonRegister];
        [topView bringSubviewToFront:buttonRegister];
        [buttonRegister mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.right.mas_equalTo(topView);
            make.height.mas_equalTo(45);
        }];
        UIImageView *imageGirl=[UIImageView new];
        imageGirl.image = [UIImage imageNamed:@"icon_alert_girl"];
        [self addSubview:imageGirl];
        [imageGirl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(buttonRegister.mas_top);
            make.right.mas_equalTo(0);
            make.size.mas_equalTo(CGSizeMake(PX(530 / 3), PX(650 / 3)));
        }];
        
        UIButton *buttonExit=[UIButton new];
        buttonExit.tag = 3;
        [buttonExit setTitle:NSLocalizedString(@"退出游客模式", nil) forState:UIControlStateNormal];
        [buttonExit setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        buttonExit.backgroundColor = [UIColor whiteColor];
        buttonExit.layer.cornerRadius = 8;
        [self addSubview:buttonExit];
        [buttonExit mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(topView);
            make.right.equalTo(topView);
            make.height.mas_equalTo(45);
            make.top.equalTo(topView.mas_bottom).mas_offset(16);
        }];
        [buttonClose addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [buttonRegister addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [buttonExit addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

-(void)buttonAction:(UIButton *)sender{
    if (self.buttonCallBack != nil) {
        self.buttonCallBack(sender);
    }
}

@end

@implementation FYTwoButtonView

- (UIButton *)buttonLeft{
    if (!_buttonLeft) {
        _buttonLeft = [UIButton new];
        _buttonLeft.tag = 1;
        _buttonLeft.layer.cornerRadius = 4;
        _buttonLeft.layer.borderColor = UIColor.grayColor.CGColor;
        _buttonLeft.layer.borderWidth = 1;
        [_buttonLeft setTitle:NSLocalizedString(@"取消", nil) forState:UIControlStateNormal];
        [_buttonLeft setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [self addSubview:_buttonLeft];
        [_buttonLeft mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.height.mas_equalTo(self);
            make.centerY.mas_equalTo(0);
            make.right.mas_equalTo(self.mas_centerX).mas_offset(-10);
        }];
    }
    return _buttonLeft;
}

- (UIButton *)buttonRight{
    if (!_buttonRight) {
        _buttonRight = [UIButton new];
        _buttonRight.tag = 2;
        _buttonRight.layer.cornerRadius = 4;
        _buttonRight.layer.backgroundColor = UIColor.redColor.CGColor;
        [_buttonRight setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self addSubview:_buttonRight];
        [_buttonRight mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.buttonLeft.mas_right).mas_offset(20);
            make.centerY.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.height.mas_equalTo(self);
        }];
    }
    return _buttonRight;
}

@end

@implementation FYAlertWechatBindCodeView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIView *contentView=[UIView new];
        contentView.backgroundColor = [UIColor whiteColor];
        contentView.layer.cornerRadius = 8;
        [self addSubview:contentView];
        [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(20);
            make.centerX.mas_equalTo(0);
            make.top.mas_equalTo(10);
            make.height.mas_equalTo(300);
        }];
        UILabel *labelTips=[UILabel new];
        labelTips.text = NSLocalizedString(@"邀请码", nil);
        labelTips.textColor = UIColor.blackColor;
        [contentView addSubview:labelTips];
        [labelTips mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(25);
            make.top.mas_equalTo(25);
            make.height.mas_equalTo(17);
        }];
        [contentView addSubview:self.textField];
        [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(20);
            make.right.mas_equalTo(-20);
            make.top.equalTo(labelTips.mas_bottom).mas_offset(10);
            make.height.mas_equalTo(45);
        }];
        [contentView addSubview:self.buttonView];
        [self.buttonView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(20);
            make.centerX.mas_equalTo(0);
            make.height.mas_equalTo(45);
            make.top.equalTo(self.textField.mas_bottom).mas_offset(20);
        }];
        [self.buttonView.buttonLeft setTitle:NSLocalizedString(@"取消", nil) forState:UIControlStateNormal];
        [self.buttonView.buttonRight setTitle:NSLocalizedString(@"提交并登录", nil) forState:UIControlStateNormal];
        FYTextLineView *textLineView=[FYTextLineView new];
        [contentView addSubview:textLineView];
        [textLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(20);
            make.right.mas_equalTo(-20);
            make.height.mas_equalTo(20);
            make.top.equalTo(self.buttonView.mas_bottom).mas_offset(30);
        }];
        textLineView.label.text = NSLocalizedString(@"没有邀请码请联系客服", nil);
        UIButton *buttonService = [UIButton new];
        buttonService.tag = 999;
        [contentView addSubview:buttonService];
        [buttonService setImage:[UIImage imageNamed:@"icon_alert_customer"] forState:UIControlStateNormal];
        [buttonService mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(0);
            make.top.equalTo(textLineView.mas_bottom).mas_offset(20);
            make.size.mas_equalTo(CGSizeMake(45, 45));
        }];
        [buttonService addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

-(void)buttonAction:(UIButton *)sender{
    [self endEditing:YES];
    if (self.buttonCallBack != nil) {
        self.buttonCallBack(sender,self.textField.text);
    }
}

-(UITextField *)textField{
    if (!_textField) {
        _textField = [UITextField new];
        _textField.borderStyle = UITextBorderStyleNone;
        _textField.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1];
        _textField.layer.cornerRadius = 4;
    }
    return _textField;
}

-(FYTwoButtonView *)buttonView{
    if (!_buttonView) {
        _buttonView = [FYTwoButtonView new];
        [_buttonView.buttonLeft addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [_buttonView.buttonRight addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _buttonView;
}

@end

@implementation FYAlertCloseTipsView

+ (void)alertShowFromVC:(UIViewController *)vc result:(void (^)(UIButton * _Nonnull))callBack{
    UIViewController *controller=[UIViewController new];
    controller.view.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0.5];
    controller.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    controller.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    FYAlertCloseTipsView *centerView=[[FYAlertCloseTipsView alloc] initWithFrame:CGRectMake(0, (SCREEN_HEIGHT - SCREEN_WIDTH) * 0.5, SCREEN_WIDTH, SCREEN_WIDTH)];
    [centerView.buttonView.buttonLeft setTitle:NSLocalizedString(@"取消", nil) forState:UIControlStateNormal];
    [centerView.buttonView.buttonRight setTitle:NSLocalizedString(@"前往设置", nil) forState:UIControlStateNormal];
    centerView.message.text = NSLocalizedString(@"检测到您暂未设置登录密码，存在风险，\n请及时设置", nil);
    centerView.buttonCallBack = ^(UIButton * _Nonnull button) {
        [controller dismissViewControllerAnimated:YES completion:nil];
        callBack(button);
    };
    [controller.view addSubview:centerView];
    [vc presentViewController:controller animated:YES completion:nil];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIView *contentView=[UIView new];
        contentView.backgroundColor = [UIColor whiteColor];
        contentView.layer.cornerRadius = 8;
        [self addSubview:contentView];
        [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(20);
            make.centerX.mas_equalTo(0);
            make.top.mas_equalTo(20);
            make.height.mas_equalTo(PX(688/3));
        }];
        UIImageView *imageRed=[UIImageView new];
        imageRed.image = [UIImage imageNamed:@"icon_alert_!red"];
        [contentView addSubview:imageRed];
        [imageRed mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(PX(108 / 3), PX(108 / 3)));
            make.centerX.mas_equalTo(0);
            make.top.mas_equalTo(PX(115 / 3));
        }];
        [contentView addSubview:self.message];
        [self.message mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(imageRed.mas_bottom).mas_offset(5);
            make.left.mas_equalTo(20);
            make.centerX.mas_equalTo(0);
            make.height.mas_equalTo(PX(210/3));
        }];
        [contentView addSubview:self.buttonView];
        [self.buttonView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(20);
            make.bottom.mas_equalTo(-20);
            make.right.mas_equalTo(-20);
            make.height.mas_equalTo(45);
        }];
        
    }
    return self;
}

-(void)buttonAction:(UIButton *)sender{
    if (self.buttonCallBack) {
        self.buttonCallBack(sender);
    }
}

-(UILabel *)message{
    if (!_message) {
        _message = [UILabel new];
        _message.numberOfLines = 0;
        _message.textColor = [UIColor grayColor];
        _message.font = [UIFont systemFontOfSize:16];
    }
    return _message;
}

-(FYTwoButtonView *)buttonView{
    if (!_buttonView) {
        _buttonView = [FYTwoButtonView new];
        [_buttonView.buttonLeft addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [_buttonView.buttonRight addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _buttonView;
}

@end

@implementation FYAlertDangerView

+ (void)alertShowFromVC:(UIViewController *)vc result:(void (^)(UIButton * _Nonnull))callBack{
    UIViewController *controller=[UIViewController new];
    controller.view.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0.5];
    controller.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    controller.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    FYAlertCloseTipsView *centerView=[[FYAlertCloseTipsView alloc] initWithFrame:CGRectMake(0, (SCREEN_HEIGHT - SCREEN_WIDTH) * 0.5, SCREEN_WIDTH, SCREEN_WIDTH)];
    [centerView.buttonView.buttonLeft setTitle:NSLocalizedString(@"取消", nil) forState:UIControlStateNormal];
    [centerView.buttonView.buttonRight setTitle:NSLocalizedString(@"联系客服", nil) forState:UIControlStateNormal];
    centerView.message.text = NSLocalizedString(@"您已经被封号，请与客服联系", nil);
    centerView.message.textAlignment = NSTextAlignmentCenter;
    centerView.buttonCallBack = ^(UIButton * _Nonnull button) {
        [controller dismissViewControllerAnimated:YES completion:nil];
        callBack(button);
    };
    [controller.view addSubview:centerView];
    [vc presentViewController:controller animated:YES completion:nil];
}

@end

@implementation FYAlertBindPhoneView



@end
