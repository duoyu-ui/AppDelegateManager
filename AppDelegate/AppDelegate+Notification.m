//
//  AppDelegate+Notification.m
//  ProjectCSHB
//
//  Created by fangyuan on 2020/3/14.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "AppDelegate+Notification.h"
#import "NotificationManager.h"
#import "JPushApiManager.h"
// iOS10注册APNs所需头文件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif


@interface AppDelegate () <UNUserNotificationCenterDelegate>

@end

@implementation AppDelegate (Notification)

#pragma mark -
#pragma mark 注册申请通知权限
- (void)registerNotificationAuthorization:(UIApplication *)application
{
    if (@available(iOS 10.0, *)) {
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        center.delegate = self; // 必须写代理，不然无法监听通知的接收与点击事件
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert)
                              completionHandler:^(BOOL granted, NSError * _Nullable error) {
            if (!error && granted) {
                NSLog(NSLocalizedString(@"注册本地通知 -> 注册成功", nil));
                [AppModel shareInstance].granted = YES;
            } else {
                NSLog(NSLocalizedString(@"注册本地通知 -> 注册失败", nil));
                [AppModel shareInstance].granted = NO;
            }
        }];
        
        // 可以通过 getNotificationSettingsWithCompletionHandler 获取权限设置。
        // 注册推送服务，用户点击了同意还是不同意，以及用户之后又做了怎样的更改我们都无从得知，
        // 现在苹果开放了这个API，可以直接获取到用户的设定信息了。注意 UNNotificationSettings 是只读对象。
        [center getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {

        }];
    } else if (@available(iOS 8.0, *)) {
        UIUserNotificationType types = UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound;
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
        [application registerUserNotificationSettings:settings];
    } else {
        // iOS 8.0 系统以下
    }
    
#ifdef _PROJECT_WITH_JPUSH_
    // 注册远端消息通知并获取 DeviceToken
    [application registerForRemoteNotifications];
#endif
}

#pragma  mark 注册 APNs 失败
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(NSLocalizedString(@"注册 APNs 失败: %@", nil), error);
}

#pragma  mark 注册 APNs 成功
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    [self registerDeviceToken:deviceToken];
    //
    NSString *deviceString = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    deviceString = [deviceString stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSLog(NSLocalizedString(@"注册 APNs 成功 => [%@]", nil), deviceString);
}


#pragma mark - iOS10 之前通知
// 本地通知（前台），收到本地通知App并不会被唤醒，所以本地只有前台时才有回调
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    // 注意：本地通知统一在 NotificationManager 类的 handleLocalNotificationAtFront 方法中进行处理
    [[NotificationManager sharedNotificationManager] handleLocalNotification:notification.userInfo];
}

// 远程通知（前台+后台），iOS6及以下系统
// 注：iOS10以上，如果不使用 UNUserNotificationCenter，将走此回调方法
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    // 极光通知处理
    [[JPushApiManager sharedJPushApiManager] handleRemoteNotification:userInfo];
    
    // 注意：远程通知统一在 NotificationManager 类的 handleRemoteNotification:completion: 方法中进行处理
    [[NotificationManager sharedNotificationManager] handleRemoteNotification:userInfo];
    
    // iOS6及以下系统
    if (userInfo) {
        if ([UIApplication sharedApplication].applicationState == UIApplicationStateActive) {
            NSLog(NSLocalizedString(@"App位于前台通知(didReceiveRemoteNotification:):%@", nil), userInfo);
        } else {
            NSLog(NSLocalizedString(@"App位于后台通知(didReceiveRemoteNotification:):%@", nil), userInfo);
        }
    }
}

// 远程通知（前台+后台+唤醒），iOS7及以上系统
// 1. 该回调方法，App杀死后并不执行；
// 2. 该回调方法，会与application:didReceiveRemoteNotification:互斥执行；
// 3. 该回调方法，会与userNotificationCenter:willPresentNotification:withCompletionHandler:一并执行；
// 4. 该回调方法，会与userNotificationCenter:didReceiveNotificationResponse::withCompletionHandler:一并执行。
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult result))completionHandler
{
    // 极光通知处理
    [[JPushApiManager sharedJPushApiManager] handleRemoteNotification:userInfo];
    
    // 注意：远程通知统一在 NotificationManager 类的 handleRemoteNotification:completion: 方法中进行处理
    [[NotificationManager sharedNotificationManager] handleRemoteNotification:userInfo];
    
    // iOS7及以上系统
    if (userInfo) {
        if ([UIApplication sharedApplication].applicationState == UIApplicationStateActive) {
            NSLog(NSLocalizedString(@"App位于前台通知(didReceiveRemoteNotification:fetchCompletionHandler:):%@", nil), userInfo);
        } else {
            NSLog(NSLocalizedString(@"App位于后台通知(didReceiveRemoteNotification:fetchCompletionHandler:):%@", nil), userInfo);
        }
    }
    
    // 系统要求执行这个方法
    completionHandler(UIBackgroundFetchResultNewData);
}


#pragma mark - iOS10 之后通知 - UNUserNotificationCenterDelegate

// 程序处于前台接收通知（此方法只有在程序处于前台状态下才会走，后台模式下是不会走这里的）。
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler API_AVAILABLE(ios(10.0))
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
        NSLog(NSLocalizedString(@"iOS10 收到远程通知:%@", nil), userInfo);
        [[NotificationManager sharedNotificationManager] handleRemoteDidReceiveNotification:userInfo];
    } else {
        NSLog(NSLocalizedString(@"iOS10 收到本地通知:body:%@,title:%@,subtitle:%@,badge:%@,sound:%@,userInfo:%@", nil), body,title,subtitle,badge,sound,userInfo);
        [[NotificationManager sharedNotificationManager] handleLocalDidReceiveNotification:userInfo];
    }
    
    // 在前台默认不显示推送，如果要显示，就要设置以下内容
    // 微信设置里-新消息通知-微信打开时-声音or振动就是该原理
    // 需要执行这个方法，选择是否提醒用户，有 Badge、Sound、Alert 三种类型可以设置
    completionHandler(UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionSound|UNNotificationPresentationOptionAlert);
}

// 程序点击通知事件触发（此方法只有在用户点击消息时才会触发，如果使用户长按（3DTouch）、弹出Action页面等并不会触发）。
- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void(^)(void))completionHandler API_AVAILABLE(ios(10.0))
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
        NSLog(NSLocalizedString(@"iOS10 点击远程通知:%@", nil), userInfo);
        [[NotificationManager sharedNotificationManager] handleRemoteDidOperateNotification:userInfo];
    } else {
        NSLog(NSLocalizedString(@"iOS10 点击本地通知:body:%@,title:%@,subtitle:%@,badge:%@,sound:%@,userInfo:%@", nil),body,title,subtitle,badge,sound,userInfo);
        [[NotificationManager sharedNotificationManager] handleLocalDidOperateNotification:userInfo];
    }
    
    // 系统要求执行这个方法，否则会报错
    completionHandler();
}


#pragma mark - Private Methods

/**
 *  添加设备令牌到服务器端
 *  @param deviceToken 设备令牌
 */
-(void)registerDeviceToken:(NSData *)deviceToken
{
    if (!deviceToken) {
        NSLog(NSLocalizedString(@"注册 APNs 到服务器端失败，Device Token 不能为空", nil));
    }
    
    NSString *key = @"kUserDefaulstsKeyDeviceToken";
    NSData *oldDeviceToken = [[NSUserDefaults standardUserDefaults]objectForKey:key];
    // 如果偏好设置中的已存储设备令牌和新获取的令牌不同，则存储新令牌并且发送给服务器端
    if (![oldDeviceToken isEqualToData:deviceToken]) {
        [[NSUserDefaults standardUserDefaults] setObject:deviceToken forKey:key];
        //
        [[JPushApiManager sharedJPushApiManager] registerDeviceToken:deviceToken];
    }
}


@end
