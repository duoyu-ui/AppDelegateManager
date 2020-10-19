//
//  IMContactsModule.m
//  ProjectCSHB
//
//  Created by fangyuan on 2020/6/14.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "IMContactsModule.h"

@interface IMContactsModule ()

@property (nonatomic, strong) NSMutableDictionary<NSString *, FYGroupVerifiEntity *> *verifyGroupDict;
@property (nonatomic, strong) NSMutableDictionary<NSString *, FYFriendVerifiEntity *> *verifyFriendDict;

@end

@implementation IMContactsModule

DEF_SINGLETON(IMContactsModule)

- (instancetype)init
{
    self = [super init];
    self.verifyGroupDict = @{}.mutableCopy;
    self.verifyFriendDict = @{}.mutableCopy;
    return self;
}

+ (void)initialModule
{
    // 初始化置空
    [IMContactsModule sharedInstance].verifyGroupDict = @{}.mutableCopy;
    [IMContactsModule sharedInstance].verifyFriendDict = @{}.mutableCopy;
    
    // 好友验证
    {
        NSString *query = [NSString stringWithFormat:@"select * from FYFriendVerifiEntity limit 999999"];
        NSArray *whereMyFriendByArray = [WHC_ModelSqlite query:[FYFriendVerifiEntity class] sql:query];
        for (NSInteger index = 0; index < whereMyFriendByArray.count; index++) {
            FYFriendVerifiEntity *entity = (FYFriendVerifiEntity *)whereMyFriendByArray[index];
            [[IMContactsModule sharedInstance].verifyFriendDict setObj:entity forKey:entity.userId];
        }
    }
    
    // 群组验证
    PROGRESS_HUD_SHOW
    [[NetRequestManager sharedInstance] getMyGroupVerificationsWhitPageIndex:0 pageSize:999 success:^(id response) {
        PROGRESS_HUD_DISMISS
        FYLog(NSLocalizedString(@"群组验证 %@", nil), response);
        if (NET_REQUEST_SUCCESS(response)) {
            NSDictionary *data = [(NSDictionary *)response objectForKey:NET_REQUEST_KEY_DATA];
            if ([data isKindOfClass:[NSDictionary class]]) {
                NSArray *dataOfRecords = [data arrayForKey:@"records"];
                if (dataOfRecords) {
                    NSArray<FYGroupVerifiEntity *> *records = [FYGroupVerifiEntity mj_objectArrayWithKeyValuesArray:dataOfRecords];
                    [records enumerateObjectsUsingBlock:^(FYGroupVerifiEntity * _Nonnull entity, NSUInteger idx, BOOL * _Nonnull stop) {
                        [[IMContactsModule sharedInstance].verifyGroupDict setObj:entity forKey:entity.groupId];
                    }];
                }
            }
        }
    } fail:^(id error) {
        PROGRESS_HUD_DISMISS
    }];
}


#pragma mark - 通讯录联系人

- (NSArray<IMUserEntity *> *)getAllContacts
{
    return [[IMUserModule sharedInstance] getAllUsers];
}

- (NSArray<IMUserEntity *> *)getAllFreinds
{
    return [[IMUserModule sharedInstance] getAllFreinds];
}

- (NSArray<IMUserEntity *> *)getAllServices
{
    return [[IMUserModule sharedInstance] getAllServices];
}

- (IMUserEntity *)getContactWithUserId:(NSString *)userId
{
    return [[IMUserModule sharedInstance] getUserWithUserId:userId];
}

- (NSString *)getContactRemarkName:(NSString *)userId
{
    IMUserEntity *entity = [self getContactWithUserId:userId];
    if (entity) {
        NSString *remarkName = [[AppModel shareInstance] getFriendName:entity.userId];
        if (!VALIDATE_STRING_EMPTY(remarkName)) {
            return remarkName;
        } else if (!VALIDATE_STRING_EMPTY(entity.friendNick)) {
            return entity.friendNick;
        }
        return entity.nick;
    }
    return nil;
}

- (void)handleUpdateAllContactEntitys:(void(^)(BOOL success))then
{
    [[IMUserModule sharedInstance] handleUpdateAllUserEntitys:then];
}


#pragma mark - 群验证消息

- (void)addGroupVerification:(FYGroupVerifiEntity *)entity
{
    if (entity == nil) {
        return;
    }
    
    self.verifyGroupDict[entity.groupId] = entity;
    BOOL success = [WHC_ModelSqlite insert:entity];
    if (!success) {
        [WHC_ModelSqlite delete:FYGroupVerifiEntity.class where:[NSString stringWithFormat:@"groupId=%@",entity.groupId]];
        [WHC_ModelSqlite insert:entity];
    }
}

- (void)deleteGroupVerification:(FYGroupVerifiEntity *)entity
{
    if (entity == nil) {
        return;
    }

    [self.verifyGroupDict removeObjectForKey:entity.groupId];
    NSString *sql = [NSString stringWithFormat:@"groupId=%@", entity.groupId];
    [WHC_ModelSqlite delete:FYGroupVerifiEntity.class where:sql];
}

- (void)deleteAllGroupVerification
{
    [self.verifyGroupDict removeAllObjects];
    [WHC_ModelSqlite clear:FYGroupVerifiEntity.class];
}

- (NSArray<FYGroupVerifiEntity *> *)allVerifyGroupEntities
{
    return self.verifyGroupDict.allValues;
}



#pragma mark - 好友验证消息

- (void)addFriendVerification:(FYFriendVerifiEntity *)entity
{
    if (entity == nil) {
        return;
    }
    
    self.verifyFriendDict[entity.userId] = entity;
    BOOL success = [WHC_ModelSqlite insert:entity];
    if (!success) {
        [WHC_ModelSqlite delete:FYGroupVerifiEntity.class where:[NSString stringWithFormat:@"userId=%@", entity.userId]];
        [WHC_ModelSqlite insert:entity];
    }
    
    [NOTIF_CENTER postNotificationName:kNotificationNewFriendInvitation object:nil];
}

- (void)deleteFriendVerification:(FYFriendVerifiEntity *)entity
{
    if (entity == nil) {
        return;
    }
    
    [self.verifyFriendDict removeObjectForKey:entity.userId];
    NSString *sql = [NSString stringWithFormat:@"userId=%@", entity.userId];
    [WHC_ModelSqlite delete:FYGroupVerifiEntity.class where:sql];
    
    [NOTIF_CENTER postNotificationName:kNotificationNewFriendInvitation object:nil];
}

- (void)deleteAllFriendVerification
{
   [WHC_ModelSqlite clear:FYFriendVerifiEntity.class];
    
    [self.verifyFriendDict removeAllObjects];
    
    [NOTIF_CENTER postNotificationName:kNotificationNewFriendInvitation object:nil];
}

- (NSArray<FYFriendVerifiEntity *> *)allVerifyFriendEntities
{
    return self.verifyFriendDict.allValues;
}


#pragma mark - 所有验证消息

- (NSArray<NSObject *> *)allVerifyEntities
{
    NSMutableArray *allVerifyEntities = [NSMutableArray array];
    [allVerifyEntities addObjectsFromArray:self.verifyGroupDict.allValues];
    [allVerifyEntities addObjectsFromArray:self.verifyFriendDict.allValues];
    return [NSArray arrayWithArray:allVerifyEntities];
}


@end

