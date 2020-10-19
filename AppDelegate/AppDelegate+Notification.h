//
//  AppDelegate+Notification.h
//  ProjectCSHB
//
//  Created by fangyuan on 2020/3/14.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "AppDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface AppDelegate (Notification)

/**
 * 注册申请通知权限
 * @param application 应用程序
 */
- (void)registerNotificationAuthorization:(UIApplication *)application;

@end

NS_ASSUME_NONNULL_END
