//
//  IMContactsModule.h
//  ProjectCSHB
//
//  Created by fangyuan on 2020/6/14.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FYFriendVerifiEntity.h"
#import "FYGroupVerifiEntity.h"
#import "IMUserEntity.h"

NS_ASSUME_NONNULL_BEGIN

@interface IMContactsModule : NSObject
AS_SINGLETON(IMContactsModule)

+ (void)initialModule;


#pragma mark - 通讯录联系人
/**
 * 获取所有联系人
 */
- (NSArray<IMUserEntity *> *)getAllContacts;
/**
 * 获取所有好友信息
 */
- (NSArray<IMUserEntity *> *)getAllFreinds;
/**
 * 获取所有客服信息
 */
- (NSArray<IMUserEntity *> *)getAllServices;
/**
 * 根据 userId 获取联系人信息
 */
- (IMUserEntity *)getContactWithUserId:(NSString *)userId;
/**
 * 获取联系人备注
 */
- (NSString *)getContactRemarkName:(NSString *)userId;
/**
 * 从服务器更新所有联系人信息
 */
- (void)handleUpdateAllContactEntitys:(void(^)(BOOL success))then;



#pragma mark - 群验证消息
/**
 * 添加群验证消息
 */
- (void)addGroupVerification:(FYGroupVerifiEntity *)entity;
/**
 * 删除群验证消息
 */
- (void)deleteGroupVerification:(FYGroupVerifiEntity *)entity;
/**
 * 删除所有群验证消息
*/
- (void)deleteAllGroupVerification;
/**
 * 获取所有群验证消息
 */
- (NSArray<FYGroupVerifiEntity *> *)allVerifyGroupEntities;



#pragma mark - 好友验证消息
/**
 * 添加好友验证消息
 */
- (void)addFriendVerification:(FYFriendVerifiEntity *)entity;
/**
 * 删除好友验证消息
 */
- (void)deleteFriendVerification:(FYFriendVerifiEntity *)entity;
/**
 * 删除所有好友验证消息
 */
- (void)deleteAllFriendVerification;
/**
 * 获取所有好友验证消息
 */
- (NSArray<FYFriendVerifiEntity *> *)allVerifyFriendEntities;



#pragma mark - 所有验证消息
/**
 * 获取所有验证消息
 */
- (NSArray<NSObject *> *)allVerifyEntities;


@end

NS_ASSUME_NONNULL_END
