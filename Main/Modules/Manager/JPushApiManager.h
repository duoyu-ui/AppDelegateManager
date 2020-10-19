//
//  JPushApiManager.h
//  ProjectCSHB
//
//  Created by fangyuan on 2020/3/12.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#ifdef _PROJECT_WITH_JPUSH_
#import "JPUSHService.h"
#endif

NS_ASSUME_NONNULL_BEGIN

#ifndef _PROJECT_WITH_JPUSH_
@interface JPushApiManager : NSObject
#else
@interface JPushApiManager : NSObject <JPUSHRegisterDelegate>
#endif

/**
 *  严格单例
 *  @return 实例对象.
 */
+ (instancetype)sharedJPushApiManager;

/**
 * 注册极光
 * @param appkey 极光标识
 * @param launchOptions 程序参数
 */
- (void)setupWithAppKey:(NSString *)appkey options:(NSDictionary *)launchOptions;

/**
 * 注册上报DeviceToken
 * @param deviceToken 极光标识
 */
- (void)registerDeviceToken:(NSData *)deviceToken;

/**
 * 处理通知
 * @param userInfo 通知内容
*/
- (void)handleRemoteNotification:(NSDictionary *)userInfo;

@end

NS_ASSUME_NONNULL_END
