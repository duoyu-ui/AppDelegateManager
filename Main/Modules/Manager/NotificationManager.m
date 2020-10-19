//
//  NotificationManager.m
//  ProjectCSHB
//
//  Created by fangyuan on 2020/3/14.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "NotificationManager.h"
#import "JPushApiManager.h"
#import "ChatViewController.h"
#import "NSObject+SSAdd.h"
// iOS10注册APNs所需头文件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif


@interface NotificationManager ()

@end

@implementation NotificationManager

+ (instancetype)sharedNotificationManager {
    static dispatch_once_t onceToken;
    static NotificationManager *instance = nil;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] initInPrivate];
    });
    return instance;
}

- (instancetype)initInPrivate {
    self = [super init];
    if (self) {
        _badge = 0;
    }
    return self;
}

- (instancetype)init {
    return nil;
}

- (instancetype)copy {
    return nil;
}

- (void)setBadge:(NSInteger)badge
{
    _badge = badge;
    if (0 >= badge) {
#ifdef _PROJECT_WITH_JPUSH_
        [JPUSHService setBadge:badge];
#endif
        dispatch_main_async_safe(^{
            [[UIApplication sharedApplication] cancelAllLocalNotifications];
            [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
        });
    } else {
#ifdef _PROJECT_WITH_JPUSH_
        [JPUSHService setBadge:badge];
#endif
        dispatch_main_async_safe(^{
            [[UIApplication sharedApplication] setApplicationIconBadgeNumber:badge];
        });
    }
}

#pragma mark - Public Methods
/**
 * 本地通知
 * @param userInfo 通知内容
*/
- (void)handleLocalNotification:(NSDictionary *)userInfo
{
    NSLog(NSLocalizedString(@"本地通知:%@", nil), userInfo);
}

/**
 * 本地通知 - 收到通知
 * @param userInfo 通知内容
*/
- (void)handleLocalDidReceiveNotification:(NSDictionary *)userInfo
{
    NSLog(NSLocalizedString(@"本地通知 -> 收到通知:%@", nil), userInfo);
    
    // 角标处理：+1
    [self applicationIconBadgeNumberIncrease];
}

/**
 * 本地通知 - 点击通知
 * @param userInfo 通知内容
*/
- (void)handleLocalDidOperateNotification:(NSDictionary *)userInfo
{
    NSLog(NSLocalizedString(@"本地通知 -> 点击通知:%@", nil), userInfo);
    
    // 角标处理：-1
    [self applicationIconBadgeNumberReduce];
    
    // 点击消息跳转到消息的详情界面中
    [self pushChatViewControllerWithUserInfo:userInfo];
}

/**
 * 远程通知
 * @param userInfo 通知内容
*/
- (void)handleRemoteNotification:(NSDictionary *)userInfo
{
    NSLog(NSLocalizedString(@"远程通知:%@", nil), userInfo);
}

/**
 * 远程通知 - 收到通知
 * @param userInfo 通知内容
*/
- (void)handleRemoteDidReceiveNotification:(NSDictionary *)userInfo
{
    NSLog(NSLocalizedString(@"远程通知 -> 收到通知:%@", nil), userInfo);
    
    // 角标处理：+1
    [self applicationIconBadgeNumberIncrease];
}

/**
 * 远程通知 - 点击通知
 * @param userInfo 通知内容
*/
- (void)handleRemoteDidOperateNotification:(NSDictionary *)userInfo
{
    NSLog(NSLocalizedString(@"远程通知 -> 点击通知:%@", nil), userInfo);
    
    // 角标处理：-1
    [self applicationIconBadgeNumberReduce];
}

/**
 * 创建本地通知
 * @param title 消息的标题
 * @param body 消息body
 * @param badge 消息的角标
 * @param userInfo 用户的基本信息
 * @return 通知对象.
 */
- (id)createLocalNotificationWithTitle:(NSString *)title
                                  body:(NSString *)body
                                 badge:(NSNumber *)badge
                              userInfo:(NSDictionary *)userInfo
{
    if (!userInfo) return nil;
    
    if (@available(iOS 10.0, *)) {
        UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
        content.title = [NSString localizedUserNotificationStringForKey:title arguments:nil];
        content.body = [NSString localizedUserNotificationStringForKey:body arguments:nil];
        content.badge = badge;
        content.userInfo = userInfo;
        content.sound = [UNNotificationSound defaultSound];
        return content;
    } else {
        UILocalNotification *localNotification = [[UILocalNotification alloc] init];
        [localNotification setAlertTitle:title];
        [localNotification setAlertBody:body];
        [localNotification setUserInfo:userInfo];
        [localNotification setSoundName:UILocalNotificationDefaultSoundName];
        [localNotification setApplicationIconBadgeNumber:[badge integerValue]];
        return localNotification;
    }
    return nil;
}


#pragma mark - Private Methods

- (void)applicationIconBadgeNumberIncrease
{
    [NotificationManager sharedNotificationManager].badge += 1;
#ifdef _PROJECT_WITH_JPUSH_
    [JPUSHService setBadge:[NotificationManager sharedNotificationManager].badge];
#endif
    dispatch_main_async_safe(^{
        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:self.badge];
    });
}

- (void)applicationIconBadgeNumberReduce
{
    [NotificationManager sharedNotificationManager].badge -= 1;
#ifdef _PROJECT_WITH_JPUSH_
    [JPUSHService setBadge:[NotificationManager sharedNotificationManager].badge];
#endif
    dispatch_main_async_safe(^{
        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:self.badge];
    });
}

- (void)pushChatViewControllerWithUserInfo:(NSDictionary *)dictionary
{
    if(![AppModel shareInstance].userInfo.isLogined)
        return;
    
    FYMessage *message = [FYMessage mj_objectWithKeyValues:dictionary];
    FYContacts *contact = [[FYContacts alloc]init];
    contact.sessionId = message.sessionId;
    contact.nick = message.user.nick;
    contact.name = message.user.nick;
    contact.avatar = message.user.avatar;
    contact.userId = message.user.userId;
    contact.accountUserId = message.toUserId;
    contact.lastTimestamp = message.timestamp;
    ChatViewController *chat = [ChatViewController privateChatWithModel:contact];
    chat.toContactsModel = contact;
    chat.hidesBottomBarWhenPushed = YES;
    
    if ([FunctionManager isEmpty:message.sessionId]
        || [FunctionManager isEmpty:message.toUserId]
        || [FunctionManager isEmpty:message.user.userId]) {
        return;
    }
    
    [[self currentViewController].navigationController pushViewController:chat animated:YES];
}

- (void)goToMssageViewControllerWithUserInfo:(NSDictionary *)userInfo
{
    if(![AppModel shareInstance].userInfo.isLogined)
        return;

}


@end
