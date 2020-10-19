//
//  FYFriendName.h
//  ProjectCSHB
//
//  Created by FangYuan on 2020/3/4.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FYFriendName : NSObject

+ (void)setName:(NSString *)name userID:(NSString *)userId;
+ (NSString *)getName:(NSString *)userId;
+ (void)addNames:(NSArray *)array;


/* 如果是登录状态，会拉取好友的备注名
 * 否则 会删除所有的备注名
 */
+ (void)httpGetFriends;

+ (void)clearData;

@end

NS_ASSUME_NONNULL_END
