//
//  FYIMManager.h
//  Project
//
//  Created by Mike on 2019/4/2.
//  Copyright © 2019 CDJay. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FYIMManager : NSObject<FYReceiveMessageDelegate>

+ (FYIMManager *)shareInstance;

- (void)initSetting;

/**
 * 通知服务器登录了
*/
- (void)updateGroup:(NSString *)sessionId number:(NSInteger)number lastMessage:(NSString *)last messageCount:(NSInteger)messageCount left:(NSInteger)left chatType:(FYChatConversationType)chatType;

/**
 * 通知服务器登录了
 */
- (void)notificationLogin;

/**
 * 用户主动退出登录
 */
- (void)userSignout;


@end

NS_ASSUME_NONNULL_END
