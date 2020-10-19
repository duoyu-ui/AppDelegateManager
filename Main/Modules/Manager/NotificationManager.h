//
//  NotificationManager.h
//  ProjectCSHB
//
//  Created by fangyuan on 2020/3/14.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NotificationManager : NSObject

@property (assign, nonatomic) NSInteger badge;

/**
 *  严格单例
 *  @return 实例对象.
 */
+ (instancetype)sharedNotificationManager;
/**
 * 本地通知
 * @param userInfo 通知内容
*/
- (void)handleLocalNotification:(NSDictionary *)userInfo;
/**
 * 本地通知 - 收到通知
 * @param userInfo 通知内容
*/
- (void)handleLocalDidReceiveNotification:(NSDictionary *)userInfo;
/**
 * 本地通知 - 点击通知
 * @param userInfo 通知内容
*/
- (void)handleLocalDidOperateNotification:(NSDictionary *)userInfo;
/**
 * 远程通知
 * @param userInfo 通知内容
*/
- (void)handleRemoteNotification:(NSDictionary *)userInfo;
/**
 * 远程通知 - 收到通知
 * @param userInfo 通知内容
*/
- (void)handleRemoteDidReceiveNotification:(NSDictionary *)userInfo;
/**
 * 远程通知 - 点击通知
 * @param userInfo 通知内容
*/
- (void)handleRemoteDidOperateNotification:(NSDictionary *)userInfo;
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
                              userInfo:(NSDictionary *)userInfo;


@end

NS_ASSUME_NONNULL_END
