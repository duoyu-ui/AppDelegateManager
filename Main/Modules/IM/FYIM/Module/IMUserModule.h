//
//  IMUserModel.h
//  ProjectCSHB
//
//  Created by fangyuan on 2019/8/27.
//  Copyright © 2019 CDJay. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IMUserEntity.h"

NS_ASSUME_NONNULL_BEGIN

@interface IMUserModule : NSObject
AS_SINGLETON(IMUserModule)

+ (void)initialModule;

/**
 * 获取所有用户
*/
- (NSArray<IMUserEntity *> *)getAllUsers;

/**
 * 获取好友列表
 */
- (NSArray<IMUserEntity *> *)getAllFreinds;

/**
 * 获取客服列表
 */
- (NSArray<IMUserEntity *> *)getAllServices;

/**
 * 根据 userId 获取用户信息
 */
- (IMUserEntity *)getUserWithUserId:(NSString *)userId;

/**
 * 更新所有好友信息
 */
- (void)handleUpdateAllUserEntitys:(void(^)(BOOL success))then;


@end

NS_ASSUME_NONNULL_END
