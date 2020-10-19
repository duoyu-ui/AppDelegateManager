//
//  JPushApiManager.m
//  ProjectCSHB
//
//  Created by fangyuan on 2020/3/12.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "JPushApiManager.h"
#import "NotificationManager.h"
// iOS10注册APNs所需头文件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif

@implementation JPushApiManager

+ (instancetype)sharedJPushApiManager {
    static dispatch_once_t onceToken;
    static JPushApiManager *instance = nil;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] initInPrivate];
    });
    return instance;
}

- (instancetype)initInPrivate {
    self = [super init];
    if (self) {

    }
    return self;
}

- (instancetype)init {
    return nil;
}

- (instancetype)copy {
    return nil;
}

- (void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:[JPushApiManager sharedJPushApiManager]];
}

#pragma mark - Public Methods

- (void)setupWithAppKey:(NSString *)appkey options:(NSDictionary *)launchOptions
{
#ifdef _PROJECT_WITH_JPUSH_
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    if (@available(iOS 12.0, *)) {
        entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound|JPAuthorizationOptionProvidesAppNotificationSettings;
    } else {
        entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
    }
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:[JPushApiManager sharedJPushApiManager]];
    
    // isProduction 是否生产环境（开发状态NO; 生产状态YES）。
    BOOL isProduction = YES;
#if DEBUG
    isProduction = NO;
#endif
    [JPUSHService setupWithOption:launchOptions
                           appKey:appkey
                          channel:@"Publish Channel"
                 apsForProduction:isProduction
            advertisingIdentifier:nil];
    [JPUSHService registrationIDCompletionHandler:^(int resCode, NSString *registrationID) {
        if(resCode == 0){
            NSLog(NSLocalizedString(@"极光[JPushSDK 版本 V3.3.0] => 注册成功！=>%@", nil), registrationID);
        } else {
            NSLog(NSLocalizedString(@"极光[JPushSDK 版本 V3.3.0] => 注册失败！", nil));
        }
    }];
    
    // 极光推送的角标问题
    [JPUSHService setBadge:[NotificationManager sharedNotificationManager].badge];
    
    // 监听极光的自定义消息，只能在前台展示
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter addObserver:[JPushApiManager sharedJPushApiManager]
                      selector:@selector(handleJPushNetworkDidReceiveMessage:)
                          name:kJPFNetworkDidReceiveMessageNotification
                        object:nil];
#endif
}

- (void)registerDeviceToken:(NSData *)deviceToken
{
#ifdef _PROJECT_WITH_JPUSH_
    [JPUSHService registerDeviceToken:deviceToken];
#endif
}

- (void)handleRemoteNotification:(NSDictionary *)userInfo
{
#ifdef _PROJECT_WITH_JPUSH_
    [JPUSHService handleRemoteNotification:userInfo];
    [JPUSHService setBadge:[NotificationManager sharedNotificationManager].badge];
#endif
}


#pragma mark - 极光自定义消息
// 处理从极光服务器发送来的极光通知
- (void)handleJPushNetworkDidReceiveMessage:(NSNotification *)notification
{
    NSDictionary * userInfo = [notification userInfo];
    NSLog(NSLocalizedString(@"极光的自定义消息 => %@", nil), userInfo);
    
    // TODO: 处理极光的自定义消息 。。。。。。
    
}


#ifdef _PROJECT_WITH_JPUSH_
#pragma mark- JPUSHRegisterDelegate
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center
        willPresentNotification:(UNNotification *)notification
          withCompletionHandler:(void (^)(NSInteger options))completionHandler API_AVAILABLE(ios(10.0))
{
    UNNotificationRequest *request = notification.request; // 收到推送的请求
    UNNotificationContent *content = request.content; // 收到推送的内容
    NSDictionary *userInfo = content.userInfo; // 收到用户的基本信息
    NSNumber *badge = content.badge; // 收到推送消息的角标
    NSString *title = content.title; // 推送消息的标题
    NSString *subtitle = content.subtitle; // 推送消息的副标题
    NSString *body = content.body; // 收到推送消息body
    UNNotificationSound *sound = content.sound; // 推送消息的声音
    
    // 判断远程通知、本地通知
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        NSLog(NSLocalizedString(@"[JPush] iOS10 收到远程通知:%@", nil), userInfo);
        [JPUSHService handleRemoteNotification:userInfo];
        [[NotificationManager sharedNotificationManager] handleRemoteDidReceiveNotification:userInfo];
    } else {
        NSLog(NSLocalizedString(@"[JPush] iOS10 收到本地通知:body:%@,title:%@,subtitle:%@,badge:%@,sound:%@,userInfo:%@", nil), body,title,subtitle,badge,sound,userInfo);
        [[NotificationManager sharedNotificationManager] handleLocalDidReceiveNotification:userInfo];
    }
    
    // 在前台默认不显示推送，如果要显示，就要设置以下内容
    // 微信设置里-新消息通知-微信打开时-声音or振动就是该原理
    // 需要执行这个方法，选择是否提醒用户，有 Badge、Sound、Alert 三种类型可以设置
    completionHandler(UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionSound|UNNotificationPresentationOptionAlert);
}

- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center
 didReceiveNotificationResponse:(UNNotificationResponse *)response
          withCompletionHandler:(void(^)(void))completionHandler API_AVAILABLE(ios(10.0))
{
    UNNotificationRequest *request = response.notification.request; // 收到推送的请求
    UNNotificationContent *content = request.content; // 收到推送的内容
    NSDictionary *userInfo = content.userInfo; // 收到用户的基本信息
    NSNumber *badge = content.badge; // 收到推送消息的角标
    NSString *title = content.title; // 推送消息的标题
    NSString *subtitle = content.subtitle; // 推送消息的副标题
    NSString *body = content.body; // 收到推送消息body
    UNNotificationSound *sound = content.sound; // 推送消息的声音
    
    // 判断远程通知、本地通知
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        NSLog(NSLocalizedString(@"[JPush] iOS10 点击远程通知:%@", nil), userInfo);
        [JPUSHService handleRemoteNotification:userInfo];
        [[NotificationManager sharedNotificationManager] handleRemoteDidOperateNotification:userInfo];
    } else {
        NSLog(NSLocalizedString(@"[JPush] iOS10 点击本地通知:body:%@,title:%@,subtitle:%@,badge:%@,sound:%@,userInfo:%@", nil),body,title,subtitle,badge,sound,userInfo);
        [[NotificationManager sharedNotificationManager] handleLocalDidOperateNotification:userInfo];
    }
    
    completionHandler();  // 系统要求执行这个方法
}

- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center openSettingsForNotification:(UNNotification *)notification NS_AVAILABLE_IOS(12.0)
{
    // 从通知界面直接进入应用
    if (notification && [notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        // 远程通知
        NSLog(NSLocalizedString(@"[远程通知]极光通知界面直接进入应用 => %@", nil), notification.request.content.userInfo);
    } else {
        // 本地通知
        NSLog(NSLocalizedString(@"[本地通知]极光通知界面直接进入应用 => %@", nil), notification.request.content.userInfo);
    }
}

- (void)jpushNotificationAuthorization:(JPAuthorizationStatus)status withInfo:(NSDictionary *)info
{
    //
    
}
#endif


@end
