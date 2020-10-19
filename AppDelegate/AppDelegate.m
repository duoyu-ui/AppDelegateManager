
#import "AppDelegate.h"
#import "NSData+AES.h"
#import "GTMBase64.h"
#import "FYIMManager.h"
#import <objc/runtime.h>
#import "MessageSingle.h"
#import "PushMessageModel.h"
#import "WHC_ModelSqlite.h"
#import "FYContacts.h"
#import "FYFriendName.h"
#import "TaskBGRunManager.h"
#import <IQKeyboardManager.h>
#import "FYIMMessageManager.h"
#import "AppDelegate+Background.h"
#import "AppDelegate+Notification.h"
#import "AFNetworkReachabilityManager.h"
#import "NotificationManager.h"
//
#ifdef _PROJECT_WITH_JPUSH_
#import "JPUSHService.h"
#import "JPushApiManager.h"
#endif
//
#ifdef _PROJECT_WITH_WECHAT_
#import "WXApi.h"
#import "WXApiManager.h"
#endif
//
#ifdef _PROJECT_WITH_OPENINSTALL_
#import "OpenInstallSDK.h"
#import "OpenInstallApiManager.h"
#endif

@interface AppDelegate ()

@end

@implementation AppDelegate
///视频播放使用到的
/// 在这里写支持的旋转方向，为了防止横屏方向，应用启动时候界面变为横屏模式
- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window {
    // 可以这么写
    if (self.allowOrentitaionRotation) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    }
    return UIInterfaceOrientationMaskPortrait;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSLog(NSLocalizedString(@"\n😊😊😊😊😊😊项目的名称：%@ \n😊😊😊😊😊😊程序的标识：%@ \n😊😊😊😊😊😊服务器地址：%@\n😊😊😊😊😊😊程序版本号：%@", nil), [[FunctionManager sharedInstance] getApplicationName],[[FunctionManager sharedInstance] getApplicationBundleID], kServerUrl, [NSString stringWithFormat:@"V %@ [%@]", [[FunctionManager sharedInstance] getApplicationVersion],[[FunctionManager sharedInstance] getApplicationBuild]]);
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
#pragma clang diagnostic pop
    
    [self setupAppConfig];
    [self loadHistoryMsgNumber];
    [[FYIMManager shareInstance] initSetting];
    
#if DEBUG
    
#else
    [NSThread sleepForTimeInterval:2.0];
#endif
    
    // 申请通知权限
    [self registerNotificationAuthorization:application];
    // 配置JPushSDK
    [self initSettingJPushSDK:launchOptions];
    // 配置WeiXinSDK
    [self initSettingWeiXinSDK];
    // 配置OpenInstallSDK
    [self initSettingOpenInstall];
    // 配置根视图控器
    [self setupRootViewController];

    return YES;
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [[AppModel shareInstance] setIsAppEnterBackground:NO];
    [[NotificationManager sharedNotificationManager] setBadge:0];
    [[FYIMMessageManager shareInstance] setReceiveMessageBlock:^(FYMessage * message, NSDictionary * dictionary) {
        // 此处什么也不处理，设置空操作。程序进入Background后，会设置Block相关操作（发通知）。
    }];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    [self setupAppConfig];
    
    [[AppModel shareInstance] setIsAppEnterBackground:NO];
    [[TaskBGRunManager sharedTaskBGRunManager] stopBackgroundTaskRun];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    [[AppModel shareInstance] setIsAppEnterBackground:NO];
    [[TaskBGRunManager sharedTaskBGRunManager] stopBackgroundTaskRun];
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    // 微信平台
#ifdef _PROJECT_WITH_WECHAT_
    [WXApi handleOpenURL:url delegate:[WXApiManager sharedWXApiManager]];
#endif
    
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    // 微信平台
#ifdef _PROJECT_WITH_WECHAT_
    if ([WXApi handleOpenURL:url delegate:[WXApiManager sharedWXApiManager]]) {
        return YES;
    }
#endif
    
    // OpenInstall
#ifdef _PROJECT_WITH_OPENINSTALL_
    // 判断是否通过 OpenInstall URL Scheme 唤起App
    if ([OpenInstallSDK handLinkURL:url]) {
        return YES;
    }
#endif
    
    return YES;
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey, id> *)options
{
    // 微信平台
#ifdef _PROJECT_WITH_WECHAT_
    if ([WXApi handleOpenURL:url delegate:[WXApiManager sharedWXApiManager]]) {
        return YES;
    }
#endif
    
    // OpenInstall
#ifdef _PROJECT_WITH_OPENINSTALL_
    // 判断是否通过 OpenInstall URL Scheme 唤起App
    if ([OpenInstallSDK handLinkURL:url]) {
        return YES;
    }
#endif
    
    return YES;
}

- (BOOL)application:(UIApplication *)application continueUserActivity:(nonnull NSUserActivity *)userActivity restorationHandler:(void(^)(NSArray<id<UIUserActivityRestoring>> * __nullable restorableObjects))restorationHandler
{
    // 微信平台 - 说明：微信SDK1.8.6版本需要在此处进行处理
#ifdef _PROJECT_WITH_WECHAT_
    /*
    if ([WXApi handleOpenUniversalLink:userActivity delegate:[WXApiManager sharedWXApiManager]]) {
        return YES;
    }
     */
#endif
    
    // OpenInstall
#ifdef _PROJECT_WITH_OPENINSTALL_
    // 判断是否通过 OpenInstall Universal Link 唤起App
    if ([OpenInstallSDK continueUserActivity:userActivity]) {
        return YES;
    }
#endif
    
    return YES;
}


#pragma mark - AppSetting Function

- (void)setupAppConfig
{
    PROGRESS_HUD_SHOW
    [[NetRequestManager sharedInstance] requestAppConfigWithSuccess:^(id response) {
        PROGRESS_HUD_DISMISS
        if ([response isKindOfClass:[NSDictionary class]]) {
            NSDictionary *result = response;
            [[AppModel shareInstance] updateCommonInformation:result];
        } else {
            ALTER_HTTP_MESSAGE(response)
        }
    } fail:^(id error) {
        PROGRESS_HUD_DISMISS
        ALTER_HTTP_ERROR_MESSAGE(error)
        [[AppModel shareInstance] logout];
    }];
}

- (void)setupRootViewController
{
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = CDCOLOR(245, 245, 245);
    self.window.rootViewController = [[AppModel shareInstance] rootVc];

    [self startAFNReachability];
    
    [[AppModel shareInstance] initSetUp];
}

- (void)initSettingJPushSDK:(NSDictionary *)launchOptions;
{
#ifdef _PROJECT_WITH_JPUSH_
    if ([FunctionManager isEmpty:kJPushAppKey]) {
        NSLog(NSLocalizedString(@"极光配置错误，kJPushAppKey 不能为空！", nil));
        return;
    }
    [[JPushApiManager sharedJPushApiManager] setupWithAppKey:kJPushAppKey options:launchOptions];
#else
    NSLog(NSLocalizedString(@"商户未开通【极光推送】功能！", nil));
#endif
}

- (void)initSettingWeiXinSDK
{
#ifdef _PROJECT_WITH_WECHAT_
    if ([FunctionManager isEmpty:kAppID]) {
        NSLog(NSLocalizedString(@"微信配置错误，kAppID 不能为空！", nil));
        return;
    }
    [WXApiManager registerApp:kAppID universalLink:kAppUniversalLink];
#else
    NSLog(NSLocalizedString(@"商户未开通【微信登录】功能！", nil));
#endif
}

- (void)initSettingOpenInstall
{
#ifdef _PROJECT_WITH_OPENINSTALL_
    [OpenInstallSDK initWithDelegate:[OpenInstallApiManager sharedOpenInstallApiManager]];
    NSLog(NSLocalizedString(@"配置[OpenInstallSDK 版本 V%@] => 注册成功！", nil), [OpenInstallSDK sdkVersion]);
#else
    NSLog(NSLocalizedString(@"商户未开通【OpenInstall】功能！", nil));
#endif
}

- (void)loadHistoryMsgNumber
{
    NSInteger oldMessageNum = 0;
    if ([AppModel shareInstance].unReadCount > 0) {
        oldMessageNum = [AppModel shareInstance].unReadCount;
    }
    [AppModel shareInstance].unReadCount = 0;

    NSString *queryWhere = [NSString stringWithFormat:@"userId='%@'", APPINFORMATION.userInfo.userId];
    NSArray *userGroups = [WHC_ModelSqlite query:[PushMessageModel class] where:queryWhere];

    for (NSInteger index = 0; index < userGroups.count; index++) {
        PushMessageModel *pushModel = (PushMessageModel *)userGroups[index];
        if (pushModel != nil && pushModel.sessionId != nil && ![pushModel.sessionId isEqualToString:@""]) {
            NSString *queryId = MESSAGE_SINGLE_KEY(pushModel.sessionId, APPINFORMATION.userInfo.userId);
            [MessageSingle shareInstance].allUnreadMessagesDict[queryId] = pushModel;
        }
    }
}


#pragma mark - AFNetworkReachability

- (void)startAFNReachability
{
    // 1.创建网络监听管理者
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    
    //2.监听网络状态的改变
    /*
     AFNetworkReachabilityStatusUnknown          = 未知
     AFNetworkReachabilityStatusNotReachable     = 没有网络
     AFNetworkReachabilityStatusReachableViaWWAN = 3G
     AFNetworkReachabilityStatusReachableViaWiFi = WIFI
     */
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusNotReachable:
                SVP_ERROR_STATUS(NSLocalizedString(@"当前网络错误，请检查网络", nil));
                [[NSNotificationCenter defaultCenter] postNotificationName:kNoNetworkNotification object:nil];
                break;
            case AFNetworkReachabilityStatusUnknown:
                NSLog(NSLocalizedString(@"未知", nil));
            case AFNetworkReachabilityStatusReachableViaWWAN:
                NSLog(@"3G");
            case AFNetworkReachabilityStatusReachableViaWiFi:
                NSLog(@"WIFI");
                [[NSNotificationCenter defaultCenter] postNotificationName:kYesNetworkNotification object:nil];
                break;
                
            default:
                break;
        }
    }];
    
    // 3.开始监听
    [manager startMonitoring];
}

@end
