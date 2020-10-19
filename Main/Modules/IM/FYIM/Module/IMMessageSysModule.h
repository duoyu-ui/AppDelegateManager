//
//  IMMessageSysModule.h
//  ProjectCSHB
//
//  Created by fangyuan on 2020/7/4.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FYSysMsgNoticeEntity.h"

NS_ASSUME_NONNULL_BEGIN

@interface IMMessageSysModule : NSObject
AS_SINGLETON(IMMessageSysModule)

+ (void)initialModule;

/**
 * 添加系统消息
 */
- (BOOL)addSystemMessageEntity:(FYSysMsgNoticeEntity *)entity;
/**
 * 更新系统消息
 */
- (BOOL)updateSystemMessageEntity:(FYSysMsgNoticeEntity *)entity;
/**
 * 删除系统消息
 */
- (BOOL)deleteSystemMessageEntity:(FYSysMsgNoticeEntity *)entity;
- (BOOL)deleteSystemMessageEntityId:(NSString *)entityId;
/**
 * 删除所有系统消息
 */
- (BOOL)deleteAllSystemMessageEntities;
/**
 * 获取所有系统消息
 */
- (NSArray<FYSysMsgNoticeEntity *> *)allSystemMessageEntities;


@end

NS_ASSUME_NONNULL_END
