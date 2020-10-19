//
//  IMUserModel.m
//  ProjectCSHB
//
//  Created by fangyuan on 2019/8/27.
//  Copyright © 2019 CDJay. All rights reserved.
//

#import "IMUserModule.h"


@interface IMUserModule ()

@property (nonatomic, strong) NSMutableDictionary<NSString *, IMUserEntity *> *users;

@end


@implementation IMUserModule
DEF_SINGLETON(IMUserModule)

- (instancetype)init {
    self = [super init];
    self.users = @{}.mutableCopy;
    return self;
}

+ (void)initialModule
{
    // 初始化置空
    [IMUserModule sharedInstance].users = @{}.mutableCopy;
    
    FYLog(NSLocalizedString(@"初始化好友信息 ========> 开始", nil));
    PROGRESS_HUD_SHOW
    [NET_REQUEST_MANAGER requestContactFriednsDataSuccess:^(id response) {
        PROGRESS_HUD_DISMISS
        if (NET_REQUEST_SUCCESS(response)) {
            NSDictionary *data = NET_REQUEST_DATA(response);
            // 客服(serviceMembers)
            {
                NSArray<NSDictionary *> *arrOfDicts = [data arrayForKey:@"serviceMembers"];
                [[IMUserModule sharedInstance] setupUserEntitys:arrOfDicts type:0 friendType:IMUserEntityFriendService];
            }
            // 邀请我的好友(superior)
            {
                NSArray<NSDictionary *> *arrOfDicts = [data arrayForKey:@"superior"];
                [[IMUserModule sharedInstance] setupUserEntitys:arrOfDicts type:1 friendType:IMUserEntityFriendSuperior];
            }
            // 我邀请的好友(subordinate)
            {
                NSArray<NSDictionary *> *arrOfDicts = [data arrayForKey:@"subordinate"];
                [[IMUserModule sharedInstance] setupUserEntitys:arrOfDicts type:1 friendType:IMUserEntityFriendSubordinate];
            }
            // 普通朋友(userFriends)
            {
                NSArray<NSDictionary *> *arrOfDicts = [data arrayForKey:@"userFriends"];
                [[IMUserModule sharedInstance] setupUserEntitys:arrOfDicts type:1 friendType:IMUserEntityFriendRegularFriends];
            }
            FYLog(NSLocalizedString(@"初始化好友信息 ========> 结束（成功）", nil));
        } else {
            FYLog(NSLocalizedString(@"初始化好友信息 ========> 结束（失败）", nil));
        }
    } failure:^(id error) {
        PROGRESS_HUD_DISMISS
        FYLog(NSLocalizedString(@"初始化好友信息 ========> 结束（失败）", nil));
    }];
}

- (void)setupUserEntitys:(NSArray<NSDictionary *> *)arrOfDicts type:(int)type friendType:(IMUserEntityFriendType)friendType
{
    if (![arrOfDicts isKindOfClass:[NSArray class]]) {
        return ;
    }
    
    NSArray<IMUserEntity *> *entitys = [IMUserEntity mj_objectArrayWithKeyValuesArray:arrOfDicts];
    [entitys enumerateObjectsUsingBlock:^(IMUserEntity * _Nonnull entity, NSUInteger idx, BOOL * _Nonnull stop) {
        [entity setType:type]; // 0:客服，1:好友
        [entity setIsFriend:(1 == type)]; // 0:客服，1:好友
        [entity setFriendType:friendType]; // 0:我的客服 1:我的上级 2:我的下级 3:普通朋友
        [[IMUserModule sharedInstance].users setObj:entity forKey:entity.userId];
        //
        FYContacts *session = [[IMSessionModule sharedInstance] getSessionWithSessionId:entity.chatId];
        if (session) {
            [session setStatus:entity.status];
            [session setAvatar:entity.avatar];
            [session setIsFriend:entity.isFriend];
            if (VALIDATE_STRING_EMPTY(entity.friendNick)) {
                [session setFriendNick:entity.nick];
            } else {
                [session setFriendNick:entity.friendNick];
            }
            [[IMSessionModule sharedInstance] updateSeesion:session];
        }
        FYLog(@"[%@][%@][%@][%@]", 1==entity.type?NSLocalizedString(@"好友", nil):NSLocalizedString(@"客服", nil), 1==entity.status?NSLocalizedString(@"在线", nil):NSLocalizedString(@"离线", nil), entity.nick, entity.friendNick);
    }];
}

- (void)handleUpdateAllUserEntitys:(void(^)(BOOL success))then
{
    FYLog(NSLocalizedString(@"更新好友信息 ========> 开始", nil));
    [NET_REQUEST_MANAGER requestContactFriednsDataSuccess:^(id response) {
        if (NET_REQUEST_SUCCESS(response)) {
            // 清空原数据
            [IMUserModule sharedInstance].users = @{}.mutableCopy;
            //
            NSDictionary *data = NET_REQUEST_DATA(response);
            // 客服(serviceMembers)
            {
                NSArray<NSDictionary *> *arrOfDicts = [data arrayForKey:@"serviceMembers"];
                [[IMUserModule sharedInstance] setupUserEntitys:arrOfDicts type:0 friendType:IMUserEntityFriendService];
            }
            // 邀请我的好友(superior)
            {
                NSArray<NSDictionary *> *arrOfDicts = [data arrayForKey:@"superior"];
                [[IMUserModule sharedInstance] setupUserEntitys:arrOfDicts type:1 friendType:IMUserEntityFriendSuperior];
            }
            // 我邀请的好友(subordinate)
            {
                NSArray<NSDictionary *> *arrOfDicts = [data arrayForKey:@"subordinate"];
                [[IMUserModule sharedInstance] setupUserEntitys:arrOfDicts type:1 friendType:IMUserEntityFriendSubordinate];
            }
            // 普通朋友(userFriends)
            {
                NSArray<NSDictionary *> *arrOfDicts = [data arrayForKey:@"userFriends"];
                [[IMUserModule sharedInstance] setupUserEntitys:arrOfDicts type:1 friendType:IMUserEntityFriendRegularFriends];
            }
            
            !then ?: then(YES);
            FYLog(NSLocalizedString(@"更新好友信息 ========> 结束（成功）", nil));
        } else {
            !then ?: then(NO);
            FYLog(NSLocalizedString(@"更新好友信息 ========> 结束（失败）", nil));
        }
    } failure:^(id object) {
        !then ?: then(NO);
        FYLog(NSLocalizedString(@"更新好友信息 ========> 结束（失败）", nil));
    }];
}


- (IMUserEntity *)getUserWithUserId:(NSString *)userId
{
    return [[IMUserModule sharedInstance].users objectForKey:userId];
}

- (NSArray<IMUserEntity *> *)getAllUsers
{
    return [IMUserModule sharedInstance].users.allValues;
}

- (NSArray<IMUserEntity *> *)getAllFreinds
{
    __block NSMutableArray<IMUserEntity *> *itemUserEntitys = [NSMutableArray<IMUserEntity *> array];
    [[IMUserModule sharedInstance].users enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, IMUserEntity * _Nonnull entity, BOOL * _Nonnull stop) {
        if (1 == entity.type) {
            [itemUserEntitys addObj:entity];
        }
    }];
    return itemUserEntitys;
}

- (NSArray<IMUserEntity *> *)getAllServices
{
    __block NSMutableArray<IMUserEntity *> *itemUserEntitys = [NSMutableArray<IMUserEntity *> array];
    [[IMUserModule sharedInstance].users enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, IMUserEntity * _Nonnull entity, BOOL * _Nonnull stop) {
        if (0 == entity.type) {
            [itemUserEntitys addObj:entity];
        }
    }];
    return itemUserEntitys;
}


@end

