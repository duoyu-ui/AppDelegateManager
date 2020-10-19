//
//  IMMessageSysModule.m
//  ProjectCSHB
//
//  Created by fangyuan on 2020/7/4.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "IMMessageSysModule.h"

@interface IMMessageSysModule ()

@property (nonatomic, strong) NSMutableDictionary<NSString *, FYSysMsgNoticeEntity *> *systemnotices;

@end

@implementation IMMessageSysModule

DEF_SINGLETON(IMMessageSysModule)

- (instancetype)init
{
    self = [super init];
    self.systemnotices = @{}.mutableCopy;
    return self;
}

+ (void)initialModule
{
    // 初始化置空
    [IMMessageSysModule sharedInstance].systemnotices = @{}.mutableCopy;
    
    // 系统消息
    {
        NSString *query = [NSString stringWithFormat:@"select * from FYSysMsgNoticeEntity limit 999999"];
        NSArray *whereSysMsgNoticeArray = [WHC_ModelSqlite query:[FYSysMsgNoticeEntity class] sql:query];
        for (NSInteger index = 0; index < whereSysMsgNoticeArray.count; index++) {
            FYSysMsgNoticeEntity *entity = (FYSysMsgNoticeEntity *)whereSysMsgNoticeArray[index];
            NSString *entityId = [NSString stringWithFormat:@"%ld", entity.Id];
            [[IMMessageSysModule sharedInstance].systemnotices setObj:entity forKey:entityId];
        }
    }
}

- (BOOL)addSystemMessageEntity:(FYSysMsgNoticeEntity *)entity
{
    if (entity == nil) {
        return NO;
    }
    
    NSString *entityId = [NSString stringWithFormat:@"%ld", entity.Id];
    [IMMessageSysModule sharedInstance].systemnotices[entityId] = entity;
    BOOL isSuccess = [WHC_ModelSqlite insert:entity];
    if (!isSuccess) {
        NSString *delWhereSql = [NSString stringWithFormat:@"Id=%@", entityId];
        [WHC_ModelSqlite delete:FYSysMsgNoticeEntity.class where:delWhereSql];
        [WHC_ModelSqlite insert:entity];
    }
    return isSuccess;
}

- (BOOL)updateSystemMessageEntity:(FYSysMsgNoticeEntity *)entity
{
    if (entity == nil) {
        return NO;
    }
    
    NSString *entityId = [NSString stringWithFormat:@"%ld", entity.Id];
    [IMMessageSysModule sharedInstance].systemnotices[entityId] = entity;
    
    NSString *delWhereSql = [NSString stringWithFormat:@"Id=%@", entityId];
    [WHC_ModelSqlite delete:FYSysMsgNoticeEntity.class where:delWhereSql];
    BOOL isSuccess = [WHC_ModelSqlite insert:entity];
    return isSuccess;
}

- (BOOL)deleteSystemMessageEntity:(FYSysMsgNoticeEntity *)entity
{
    if (entity == nil) {
        return NO;
    }
    
    NSString *entityId = [NSString stringWithFormat:@"%ld", entity.Id];
    return [self deleteSystemMessageEntityId:entityId];
}

- (BOOL)deleteSystemMessageEntityId:(NSString *)entityId
{
    if (entityId.length <= 0) {
        return NO;
    }
    
    [[IMMessageSysModule sharedInstance].systemnotices removeObjectForKey:entityId];
    
    NSString *delWhereSql = [NSString stringWithFormat:@"Id=%@", entityId];
    BOOL isSuccess = [WHC_ModelSqlite delete:FYSysMsgNoticeEntity.class where:delWhereSql];
    return isSuccess;
}

- (BOOL)deleteAllSystemMessageEntities
{
    [[IMMessageSysModule sharedInstance].systemnotices removeAllObjects];
    
    BOOL isSuccess = [WHC_ModelSqlite clear:FYSysMsgNoticeEntity.class];
    if (!isSuccess) {
        FYLog(NSLocalizedString(@"🔴🔴🔴🔴🔴🔴 清空系统消息失败！", nil));
        return isSuccess;
    } else {
        FYLog(NSLocalizedString(@"🌱🌱🌱🌱🌱🌱 清空系统消息成功！", nil));
    }
    return isSuccess;
}

- (NSArray<FYSysMsgNoticeEntity *> *)allSystemMessageEntities
{
    [[self class] initialModule];
    return self.systemnotices.allValues;
}

@end

