//
//  IMGroupModule.h
//  ProjectCSHB
//
//  Created by fangyuan on 2019/8/22.
//  Copyright © 2019 CDJay. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MessageItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface IMGroupModule : NSObject
AS_SINGLETON(IMGroupModule)

+ (void)initialModule;

- (MessageItem * _Nullable)getGroupWithGroupId:(NSString *)groupId;

- (NSArray<MessageItem *> * _Nullable)getAllGroups;

/// 更新或者添加
- (void)updateGroupWithGroupId:(MessageItem *)entity;

- (void)removeGroupEntityWithGroupId:(NSString *)groupId;

/**
 * 更新所有群组信息
 */
- (void)handleUpdateAllGroupEntitys:(void(^)(BOOL success))then;

/**
 * 校验是否能创建群
*/
- (void)handleVerifyCreateGroupThen:(void(^)(BOOL success))then;


@end

NS_ASSUME_NONNULL_END
