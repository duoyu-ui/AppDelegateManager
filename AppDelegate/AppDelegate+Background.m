//
//  AppDelegate+Background.m
//  ProjectCSHB
//
//  Created by fangyuan on 2020/3/14.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "AppDelegate+Background.h"
#import "FYContacts.h"
#import "MessageSingle.h"
#import "PushMessageModel.h"
#import "FYIMMessageManager.h"
#import "ChatViewController.h"
#import "NSObject+SSAdd.h"
#import "NotificationManager.h"
#import "TaskBGRunManager.h"
//
#ifdef _PROJECT_WITH_JPUSH_
#import "JPUSHService.h"
#import "JPushApiManager.h"
#endif
// iOS10注册APNs所需头文件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif


@implementation AppDelegate (Background)

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [[TaskBGRunManager sharedTaskBGRunManager] startBackgroundTaskRun];
    
    //
    [self setupModelSqlite];
    
    /**
     * 客户端是通过心跳来和服务端保持连接，心跳是由定时器触发的，当我退到后台以后，定时器方法被挂起，那么通过如下设置来在后台运行定时器
     */
    /*
    __block UIBackgroundTaskIdentifier backgroundTaskIdentifier;
    backgroundTaskIdentifier = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if(backgroundTaskIdentifier != UIBackgroundTaskInvalid){
                backgroundTaskIdentifier= UIBackgroundTaskInvalid;
            }
        });
    }];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,  0  ),^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if  (backgroundTaskIdentifier != UIBackgroundTaskInvalid)  {
                backgroundTaskIdentifier= UIBackgroundTaskInvalid;
            }
        });
    });
    */
    
    [[AppModel shareInstance] setIsAppEnterBackground:YES];
    [[AppModel shareInstance] saveAppModel];
    [FYIMMessageManager shareInstance].receiveMessageBlock = ^(FYMessage * message, NSDictionary * dictionary) {
        NSString *to = [NSString stringWithFormat:@"%@", dictionary[@"to"]];
        if (![[AppModel shareInstance].userInfo.userId isEqualToString:to]) {
            return;
        }
        if (FYConversationType_PRIVATE == [dictionary[@"chatType"] integerValue]) { // 单聊
            [self addLocalNotificationForChatMessage:dictionary];
            [[NotificationManager sharedNotificationManager] handleLocalDidReceiveNotification:dictionary];
        }
    };
}


#pragma mark - Private Methods

- (void)setupModelSqlite
{
    NSDictionary *dict = [NSDictionary dictionaryWithDictionary:[MessageSingle shareInstance].allUnreadMessagesDict];
    NSArray *arr = [dict allKeys];
    for (NSInteger i = 0; i < arr.count; i++) {
        PushMessageModel *model = (PushMessageModel *)[dict objectForKey:arr[i]];
        NSString *query = [NSString stringWithFormat:@"sessionId='%@' AND userId='%@'",model.sessionId,[AppModel shareInstance].userInfo.userId];
        PushMessageModel *sqlModel = [[WHC_ModelSqlite query:[PushMessageModel class] where:query] firstObject];
        
        if (sqlModel) {
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                [WHC_ModelSqlite update:model where:query];
            });
        } else {
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                [WHC_ModelSqlite insert:model];
            });
        }
    }
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSString *whereStr = @"deliveryState = 1";
        NSArray *modelArray = [WHC_ModelSqlite query:[FYMessage class] where:whereStr];
        for (NSInteger index =0; index < modelArray.count; index++) {
            FYMessage *message = (FYMessage *)modelArray[index];
            message.deliveryState = FYMessageDeliveryStateFailed;
            NSString *query = [NSString stringWithFormat:@"messageId='%@'",message.messageId];
            [WHC_ModelSqlite update:message where:query];
        }
    });
}


- (void)addLocalNotificationForChatMessage:(NSDictionary *)dictionary
{
    if (!dictionary) return;

    FYMessage *message = [FYMessage mj_objectWithKeyValues:dictionary];
    NSString *text;
    // 判断是否是以 "{" 开头并且 "}"结尾
    if ([message.text hasPrefix:@"{"] && [message.text hasSuffix:@"}"]) {
        NSError *error;
        NSData *data = [message.text  dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *dict = [NSJSONSerialization  JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
        NSString *url = [NSString stringWithFormat:@"%@", dict[@"url"]];
        if ([url hasSuffix:@".png"] || [url hasSuffix:@".jpg"]|| [url hasSuffix:@".jpeg"]) {
            text = NSLocalizedString(@"对方给您发了一张图片!", nil);
        }
    } else {
        text = message.text;
    }
    
    NSNumber *badge = [NSNumber numberWithInteger:[NotificationManager sharedNotificationManager].badge+1];
    
    if (@available(iOS 10.0, *)) {
        UNMutableNotificationContent *content = (UNMutableNotificationContent *)[[NotificationManager sharedNotificationManager] createLocalNotificationWithTitle:message.user.nick body:text badge:badge userInfo:dictionary];
        NSString *notificationId = [NSString stringWithFormat:@"ProLocalNotificationIdentifer%@", message.messageId];
        UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:notificationId content:content trigger:nil];
        [[UNUserNotificationCenter currentNotificationCenter] addNotificationRequest:request withCompletionHandler:^(NSError *_Nullable error) {
            if (!error) {
                NSLog(NSLocalizedString(@"添加本地通知成功 -> \n%@ %@", nil), notificationId, dictionary);
            } else {
                NSLog(NSLocalizedString(@"添加本地通知失败 -> \n%@ %@", nil), notificationId, dictionary);
            }
        }];
    } else {
        UILocalNotification *localNotification = (UILocalNotification *)[[NotificationManager sharedNotificationManager] createLocalNotificationWithTitle:message.user.nick body:text badge:badge userInfo:dictionary]; ;
        [[UIApplication sharedApplication] presentLocalNotificationNow:localNotification];
    }
}

@end
