//
//  FYSocketMessageManager.h
//  
//
//  Created by Mike on 2019/3/30.
//  Copyright © 2019 Mike. All rights reserved.
//

#import <Foundation/Foundation.h>


NS_ASSUME_NONNULL_BEGIN

typedef void (^FYReceiveMessageBlock)(FYMessage *message, NSDictionary *dictionary);

@interface FYIMMessageManager : NSObject

// 聊天代理
@property (nonatomic, weak) id<FYChatManagerDelegate> delegate;

// 设置代理
@property (nonatomic, weak) id<FYReceiveMessageDelegate> receiveMessageDelegate;

// 是否已连接 Socket
@property (nonatomic, assign) BOOL isConnectFY;

// 单聊消息
@property (nonatomic, copy) FYReceiveMessageBlock receiveMessageBlock;

/**
 * 单例
 */
+ (FYIMMessageManager *)shareInstance;

/**
 * 初始化
 */
- (void)initWithAppKey:(NSString *)appKey;

/**
 * 发送消息
 */
- (void)sendMessageServer:(NSDictionary *)parameters;

/**
 * 用户主动退出登录
 */
- (void)userSignout;


@end

NS_ASSUME_NONNULL_END
