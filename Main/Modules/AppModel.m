//
//  AppModel.m
//  Project
//
//  Created by mini on 2018/8/1.
//  Copyright © 2018年 CDJay. All rights reserved.
//

#import "AppModel.h"
#import "UserInfo.h"
#import "LoginViewController.h"

#import "FYIMManager.h"
#import "LaunchFristPageVC.h"
#import "GTMBase64.h"
#import "NSData+AES.h"
#import "SAMKeychain.h"
#import "AppDelegate.h"
#import "FY2020LoginViewController.h"
#import "FYFriendName.h"

static NSString *Path = @"COM.XMFX.path";

@interface AppModel()

@property (nonatomic, strong) UILabel *debugUrlLabel;

@end


@implementation AppModel

MJCodingImplementation

@synthesize accountId = _accountId;

+ (void)load
{
    [self performSelectorOnMainThread:@selector(shareInstance) withObject:nil waitUntilDone:NO];
}

+ (instancetype)shareInstance
{
    static AppModel *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if(instance == nil) {
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString* filename = [[paths objectAtIndex:0] stringByAppendingPathComponent:Path];
            if ([[NSFileManager defaultManager] fileExistsAtPath:filename]) {
                instance = [NSKeyedUnarchiver unarchiveObjectWithFile:filename];
                if(instance == nil){
                    instance = [[AppModel alloc] init];
                    instance.turnOnSound = YES;
                    instance.lastSysMsgNoticeReadTime = [[NSDate today] stringFromDateWithFormat:kNSDateFormatDateFullNormal];
                }
            } else {
                instance = [[AppModel alloc] init];
                instance.turnOnSound = YES;
                instance.lastSysMsgNoticeReadTime = [[NSDate today] stringFromDateWithFormat:kNSDateFormatDateFullNormal];
            }
        }

        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        NSInteger serverIndex = [[userDefault objectForKey:@"serverIndex"] integerValue];
        NSArray *arr = [instance ipArray];
        if(serverIndex >= arr.count)
            serverIndex = 0;
        NSDictionary *dic = arr[serverIndex];
        //--start
        NSString *urlString = [userDefault stringForKey:@"currentURL"];
        if (urlString == nil) {
            NSLog(@"Not CurrentURL");
            instance.serverUrl = dic[@"url"];
        } else {
            instance.serverUrl = urlString;
        }
        //--end
        instance.debugMode = [dic[@"isBeta"] boolValue];
        NSString *authKey = instance.commonInfo[@"app_client_id"];
        if(authKey)
            instance.authKey = [NSString stringWithFormat:@"%@",authKey];
        else
            instance.authKey = dic[@"baseKey"];
    });
    return instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)setTurnOnSound:(BOOL)Sound {
    _turnOnSound = Sound;
}

- (void)saveAppModel
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* filename = [[paths objectAtIndex:0] stringByAppendingPathComponent:Path];
    [NSKeyedArchiver archiveRootObject:self toFile:filename];
}

- (UserInfo *)userInfo
{
    if(_userInfo == nil)
        _userInfo = [[UserInfo alloc] init];
    return _userInfo;
}

- (void)logout
{
    [self clearData];
    
    self.userInfo = [UserInfo new];

    [[FYIMManager shareInstance] userSignout];
    self.unReadCount = 0;
//    [[MessageNet shareInstance] destroyData];
    [self saveAppModel];
    [self restRootAnimation:NO];
    [FYFriendName clearData];
//    [self reSetTabBarAsRootAnimation];
}

- (void)setAccountId:(NSString *)accountId {
    
    _accountId = accountId;
    
    [[NSUserDefaults standardUserDefaults] setObject:accountId forKey:@"kAccount_id_key__"];
    
}

- (NSString *)accountId {
    
    if (_accountId.length == 0) {
        return [[NSUserDefaults standardUserDefaults] objectForKey:@"kAccount_id_key__"];
    }
    return _accountId;
}

- (NSString *)address {
  NSString *address =[NSString stringWithFormat:@"%@", self.commonInfo[@"website.address"]];
    if ([address hasSuffix:@"/"]) {//有斜杠
        return address;
    }else{
        return [address stringByAppendingString:@"/"];
    }
}

#pragma mark method

- (void)initSetUp
{    
    // 开启消息撤回功能
    // [RCIM sharedRCIM].enableMessageRecall = YES;
    
    // 开启消息@功能（只支持群聊和讨论组, App需要实现群成员数据源groupMemberDataSource）
    // [RCIM sharedRCIM].enableMessageMentioned = YES;
    
    // SVProgressHUD
    [SVProgressHUD setMinimumDismissTimeInterval:1.2f];
    [SVProgressHUD setMaximumDismissTimeInterval:1.2f];
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    
    // 去掉底部和适配11
    [[UITableView appearance] setTableFooterView:[UIView new]];
    [[UITableView appearance] setEstimatedSectionFooterHeight:0];
    [[UITableView appearance] setEstimatedSectionHeaderHeight:0];
    [[UITableViewCell appearance] setSelectionStyle:0];
    
    [[UIWindow appearance] setBackgroundColor:UIColor.grayColor];
    [[UIButton appearance] setExclusiveTouch:YES];
    
#ifdef DEBUG
    if([AppModel shareInstance].debugMode){
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, -2, SCREEN_WIDTH, 14)];
        label.text = [NSString stringWithFormat:NSLocalizedString(@"%@  新IM", nil),[AppModel shareInstance].serverUrl];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:12];
        [[UINavigationBar appearance] addSubview:label];
        self.debugUrlLabel = label;
    }
#endif
}

+ (void)debugShowCurrentUrl
{
#ifdef DEBUG
    if([AppModel shareInstance].debugMode) {
        [AppModel shareInstance].debugUrlLabel.text = [NSString stringWithFormat:NSLocalizedString(@"%@  新IM", nil),[AppModel shareInstance].serverUrl];
    }
#endif
}

- (void)login
{
    if([[[FunctionManager sharedInstance] currentViewController] isKindOfClass:[LoginViewController class]]){
        [self restRootAnimation:YES];
    }
}

- (UIViewController *)rootVc
{
    if (![[NSUserDefaults standardUserDefaults]objectForKey:[NSString appVersion]]) {
        return [[NSClassFromString(@"GuideViewController") alloc]init];
    } else {
        if ([AppModel shareInstance].userInfo.isLogined) {
            return [[FYRootUI4TabBarController alloc] init];
        } else {
            if (APP_ENUM_VERSION > 2) {
                return [FY2020LoginViewController noLoginView];
            } else {
                return [LaunchFristPageVC noLoginView];
            }
            
        }
    }
}

-(void)updateTabBarIndex:(NSInteger)index
{
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    FYRootUI4TabBarController *rootTabBar=(FYRootUI4TabBarController *)app.window.rootViewController;
    if ([rootTabBar isMemberOfClass:[FYRootUI4TabBarController class]]) {
        [rootTabBar setSelectedIndex:index];
    }
}

- (void)restRootAnimation:(BOOL)animation {
    dispatch_async(dispatch_get_main_queue(),^{
        UIWindow* window = [UIApplication sharedApplication].keyWindow;
        if (animation) {
            [window.layer addAnimation:[AppModel shareInstance].animation forKey:nil];
        }
        window.rootViewController = [AppModel shareInstance].rootVc;
    });
}

- (void)reSetTabBarAsRootAnimation {
    [self restRootAnimation:NO];
}


- (CATransition *)animation {
    CATransition *animation = [CATransition animation];
    animation.duration = 0.3;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    animation.type =  @"cube";  //立方体效果
    
    //设置动画子类型
    animation.subtype = kCATransitionFromTop;
    return animation;
}

- (NSString *)serverUrl {
    return [self serverUrl2:_serverUrl];
}

- (NSString *)serverUrl2:(NSString *)url{
    url = [url stringByReplacingOccurrencesOfString:@"10.15" withString:@"10.95"];
    return url;
}

-(NSArray *)ipArray {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSArray *arr = [ud objectForKey:@"ipArray"];
    NSDictionary *dic1 = @{@"url":kServerUrl, @"isBeta":@(NO),@"baseKey":kBaseKey};
    NSMutableArray *array = [NSMutableArray arrayWithObjects:dic1, nil];
    [array addObjectsFromArray:self.envirments];
    if(arr)
    [array addObjectsFromArray:arr];
    return array;
}


/**
 * 测试环境
 */
- (NSArray *)envirments {
    
    return @[
             @{@"url":@"http://sit_gateway.fy.com/",@"isBeta":@"1",@"baseKey":@"YXBwOmFwcA=="},
             @{@"url":@"http://uat_gateway.fy.com/",@"isBeta":@"1",@"baseKey":@"YXBwOmFwcA=="},
             @{@"url":@"https://graygateway.em558.com/",@"isBeta":@"1",@"baseKey":@"YXBwOmFwcA=="},
             @{@"url":@"http://sit2_gateway.fy.com/",@"isBeta":@"1",@"baseKey":@"YXBwOmFwcA=="},
             @{@"url":@"http://sit3_gateway.fy.com/",@"isBeta":@"1",@"baseKey":@"YXBwOmFwcA=="},
             @{@"url":@"http://gateway.test536.com/",@"isBeta":@"1",@"baseKey":@"YXBwOmFwcA=="},
             @{@"url":@"http://gateway.test966.com/",@"isBeta":@"1",@"baseKey":@"YXBwOmFwcA=="}
             ];
    
}


/**
 * 商户号
 */
- (NSArray *)tenants {
    
    return @[@"100000", @"fy_pig_test", @"200000"];
}


- (nonnull id)copyWithZone:(nullable NSZone *)zone {
    return self;
}

- (void)checkGroupId:(NSString *)groupId Completed:(void (^)(BOOL complete))completed
{
    if (self.myGroupArray.count == 0) {
        __weak __typeof(self)weakSelf = self;
        [[NetRequestManager sharedInstance] getGroupListWithPageSize:1000 pageIndex:0 officeFlag:NO success:^(id object) {
            if ([object[@"code"] integerValue] == 0) {
                if (![object[@"data"] isKindOfClass:[NSDictionary class]]) {
                    return ;
                }
                NSMutableArray *idarr = [NSMutableArray mj_objectArrayWithKeyValuesArray:object[@"data"][@"records"]];
                NSMutableArray *ids = [NSMutableArray arrayWithCapacity:0];
                [idarr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    [ids addObject:obj[@"id"]];
                }];
                [AppModel shareInstance].myGroupArray = ids;
                completed([weakSelf isContainGroup:groupId]);
            }
        } fail:^(id object) {
            completed(NO);
        }];
    } else {
        completed([self isContainGroup:groupId]);
    }
}

- (BOOL)isContainGroup:(NSString *)groupId {
    BOOL b = NO;
    for (NSDictionary *dict in self.myGroupArray) {
        NSString *gid = [NSString stringWithFormat:@"%ld",[dict[@"id"] integerValue]];
        if ([groupId isEqualToString:gid]) {
            b = YES;
            break;
        }
    }
    return b;
}

-(void)updateUserInfo:(NSDictionary *)dict
{
    FYLog(@"%@",dict);
    
    UserInfo *user = [UserInfo mj_objectWithKeyValues:dict];
    if([user.userId isKindOfClass:[NSNumber class]]){
        user.userId = [(NSNumber *)user.userId stringValue];
    }
    user.token = self.userInfo.token;
    user.fullToken = self.userInfo.fullToken;
    user.groupowenFlag = [dict boolForKey:@"groupowenFlag"];
    self.userInfo = user;
    self.userInfo.isLogined = YES;
    [self saveAppModel];
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:user.userId forKey:@"userId"];
    [ud setObject:user.mobile forKey:@"mobile"];
    [ud synchronize];
    
    [SAMKeychain setPassword:@"1" forService:@"com.fy.ser" account:user.mobile];
//    [NET_REQUEST_MANAGER selectInternalNick:@{} successBlock:^(NSDictionary *success) {
//        if (success) {
//            NSInteger code=[[success valueForKey:@"code"] integerValue];
//            if (code==0) {
//                NSArray *datas=success[@"data"];
//                if (datas.count>0) {
//                    [FYFriendName addNames:datas];
//                }
//            }
//        }
//    } failureBlock:^(NSError *failure) {
//        
//    }];
}

-(void)clearData{
    //commonInfo clear
    self.commonInfo = nil;
    self.appClientIdInCommonInfo = nil;
//    self.authKey = nil;
    //token clear
    self.randomly16Key = nil;
    self.publicKey = nil;
    self.ruleString = nil;
    self.encRSAPubKey = nil;
    //user clear
    self.userInfo = nil;
    [NET_REQUEST_MANAGER requestAppConfigWithSuccess:^(id object) {
        if ([object isKindOfClass:[NSDictionary class]]) {
            NSDictionary *result = object;
            [[AppModel shareInstance] updateCommonInformation:result];
        }
    } fail:^(id object) {
        
    }];
}

- (void)updateCommonInformation:(NSDictionary *)response
{
    if (response == nil) {
        [self logout];
    } else {
        if (NET_REQUEST_SUCCESS(response)) {
            NSString *dataString = [response valueForKey:@"data"];
            if ([dataString isKindOfClass:[NSString class]]) {
                NSData *data = [GTMBase64 decodeString:dataString];
                data = [data AES128DecryptWithKey:kAccountPasswordKey gIv:kAccountPasswordKey];
                NSString *json = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                NSDictionary * commonInformation = [json mj_JSONObject];
                self.commonInfo = commonInformation;
                BOOL isShowLevel2=[[commonInformation valueForKey:@"sd_show_hide"] boolValue];
                [self isShow2LevelSetting:isShowLevel2];
                NSString *authKey = self.commonInfo[@"app_client_id"];
                if(authKey) {
                    self.appClientIdInCommonInfo = authKey;
                    self.authKey = [NSString stringWithFormat:@"%@",authKey];
                }
            }
            [FYFriendName httpGetFriends];
        }
    }
}

- (FYGameAppConfigStyle)getGameAppConfigStyle
{
    NSString *appStyleSwitchFlag = [self.commonInfo stringForKey:@"app_style_switch_flag"];
    if ([@"1" isEqualToString:appStyleSwitchFlag]) {
        return FYGameAppConfigStyleMode1;
    } else if ([@"2" isEqualToString:appStyleSwitchFlag]) {
        return FYGameAppConfigStyleMode2;
    }
    return FYGameAppConfigStyleMode2;
}

-(void)loginToUpdateUserInformation:(BOOL)isRefreshRoot{
    [NET_REQUEST_MANAGER requestUserInfoWithSuccess:^(id object) {
        if (isRefreshRoot) {
//            [[AppModel shareInstance] reSetTabBarAsRootAnimation];
            [[AppModel shareInstance] restRootAnimation:isRefreshRoot];
        }
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

-(UIViewController *)rootViewController{
    AppDelegate *app=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    return app.window.rootViewController;
}

-(UIWindow *)appWindow{
    AppDelegate *app=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    return app.window;
}

- (FYLoginType)loginType
{
    FYLoginType type=(FYLoginType)[[[NSUserDefaults standardUserDefaults] valueForKey:@"loginType"] integerValue];
    return type;
}

- (BOOL)isGuest
{
    if ([self loginType] == FYLoginTypeGuest) {
        [AppModel alertShowGuestWithResult:^(UIButton *button) {
            if (button.tag == 3) {
                [[AppModel shareInstance] logout];
            } else if (button.tag == 2) {
                NSUserDefaults *user=[NSUserDefaults standardUserDefaults];
                [user setBool:YES forKey:@"toRegister"];
                [user synchronize];
                [[AppModel shareInstance] logout];
            }
        }];
        return YES;
    }
    return NO;
}

- (BOOL)isGuestLogin
{
    if ([self loginType] == FYLoginTypeGuest) {
        return YES;
    }
    return NO;
}

- (BOOL)isShow2Level
{
    BOOL isShow = [[NSUserDefaults standardUserDefaults] boolForKey:@"sd_show_hide"];
//    BOOL isShow = [[self.commonInfo valueForKey:@"sd_show_hide"] boolValue];
    return isShow;
}

- (void)isShow2LevelSetting:(BOOL)isShow
{
    NSUserDefaults *userpefference = [NSUserDefaults standardUserDefaults];
    [userpefference setBool:isShow forKey:@"sd_show_hide"];
    [userpefference synchronize];
}

- (void)setLoginType:(FYLoginType)type
{
    NSUserDefaults *userpefference = [NSUserDefaults standardUserDefaults];
    [userpefference setValue:@(type) forKey:@"loginType"];
    [userpefference synchronize];
}

- (NSString *)getFriendName:(NSString *)userid
{
    return [FYFriendName getName:userid];
}

+ (void)alertShowGuestWithResult:(void(^)(UIButton *button))callBack
{
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

@end
