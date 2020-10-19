//
//  IMGroupModule.m
//  ProjectCSHB
//
//  Created by fangyuan on 2019/8/22.
//  Copyright © 2019 CDJay. All rights reserved.
//

#import "IMGroupModule.h"

@interface IMGroupModule ()

@property (nonatomic, strong) NSMutableDictionary<NSString *, MessageItem *> *groups;

@end


@implementation  IMGroupModule

DEF_SINGLETON(IMGroupModule)

- (instancetype)init
{
    self = [super init];
    self.groups = @{}.mutableCopy;
    return self;
}

+ (void)initialModule
{
    // 初始化置空
    [IMGroupModule sharedInstance].groups = @{}.mutableCopy;
    
    NSArray<MessageItem *> *array = [WHC_ModelSqlite query:MessageItem.class where:[NSString stringWithFormat:@"tableOwnerId=%@", AppModel.shareInstance.userInfo.userId]];
    [array enumerateObjectsUsingBlock:^(MessageItem * _Nonnull msgItem, NSUInteger idx, BOOL * _Nonnull stop) {
        if (msgItem && !msgItem.officeFlag) {
            IMGroupModule.sharedInstance.groups[msgItem.groupId] = msgItem;
            //
            FYContacts *session = [[IMSessionModule sharedInstance] getSessionWithSessionId:msgItem.groupId];
            if (session) {
                [session setAvatar:msgItem.img];
                [session setName:msgItem.chatgName];
                [session setFriendNick:msgItem.chatgName];
                [[IMSessionModule sharedInstance] updateSeesion:session];
            }
        }
    }];
    
    {
        FYLog(NSLocalizedString(@"初始化群组信息 ========> 开始", nil));
        PROGRESS_HUD_SHOW
        [[NetRequestManager sharedInstance] getGroupListWithPageSize:1000 pageIndex:0 officeFlag:NO success:^(id response) {
            PROGRESS_HUD_DISMISS
            if (NET_REQUEST_SUCCESS(response)) {
                NSDictionary *data = [(NSDictionary *)response objectForKey:NET_REQUEST_KEY_DATA];
                if ([data isKindOfClass:[NSDictionary class]]) {
                    NSArray *arrOfDicts = [data arrayForKey:@"records"];
                    [[IMGroupModule sharedInstance] setupGroupEntitys:arrOfDicts];
                }
                FYLog(NSLocalizedString(@"初始化群组信息 ========> 结束（成功）", nil));
            } else {
                FYLog(NSLocalizedString(@"初始化群组信息 ========> 结束（失败）", nil));
            }
        } fail:^(id error) {
            PROGRESS_HUD_DISMISS
            FYLog(NSLocalizedString(@"初始化群组信息 ========> 结束（失败）", nil));
        }];
    }
}

- (void)setupGroupEntitys:(NSArray<NSDictionary *> *)arrOfDicts
{
    if (![arrOfDicts isKindOfClass:[NSArray class]]) {
        return ;
    }
    
    NSArray<MessageItem *> *entitys = [MessageItem mj_objectArrayWithKeyValuesArray:arrOfDicts];
    [entitys enumerateObjectsUsingBlock:^(MessageItem * _Nonnull msgItem, NSUInteger idx, BOOL * _Nonnull stop) {
        if (msgItem && !msgItem.officeFlag) {
            [[IMGroupModule sharedInstance].groups setObj:msgItem forKey:msgItem.groupId];
            [[IMGroupModule sharedInstance] updateGroupWithGroupId:msgItem];
            //
            FYContacts *session = [[IMSessionModule sharedInstance] getSessionWithSessionId:msgItem.groupId];
            if (session) {
                [session setAvatar:msgItem.img];
                [session setName:msgItem.chatgName];
                [session setFriendNick:msgItem.chatgName];
                [[IMSessionModule sharedInstance] updateSeesion:session];
            }
            FYLog(NSLocalizedString(@"群组信息 => [%@]【%@】", nil), msgItem.groupId, msgItem.chatgName);
        }
    }];
}


- (void)handleUpdateAllGroupEntitys:(void(^)(BOOL success))then
{
    FYLog(NSLocalizedString(@"更新群组信息 ========> 开始", nil));
    [NET_REQUEST_MANAGER requestJoinGroupDataWithOfficeFlag:NO success:^(id response) {
        if (NET_REQUEST_SUCCESS(response)) {
            NSDictionary *data = NET_REQUEST_DATA(response);
            if ([data isKindOfClass:[NSDictionary class]]) {
                NSArray *arrOfDicts = [data arrayForKey:@"records"];
                [[IMGroupModule sharedInstance] setupGroupEntitys:arrOfDicts];
            }
            !then ?: then(YES);
            FYLog(NSLocalizedString(@"更新群组信息 ========> 结束（成功）", nil));
        } else {
            !then ?: then(NO);
            FYLog(NSLocalizedString(@"更新群组信息 ========> 结束（失败）", nil));
        }
    } failure:^(id object) {
        !then ?: then(NO);
        FYLog(NSLocalizedString(@"更新群组信息 ========> 结束（失败）", nil));
    }];
}

/// 校验是否能创建群
- (void)handleVerifyCreateGroupThen:(void(^)(BOOL success))then
{
    PROGRESS_HUD_SHOW
    [NET_REQUEST_MANAGER isDisplayCreateGroup:@{} successBlock:^(id response) {
        PROGRESS_HUD_DISMISS
        if (NET_REQUEST_SUCCESS(response)) {
            !then?:then(YES);
        } else {
            ALTER_HTTP_MESSAGE(NSLocalizedString(@"游戏暂未开放，敬请期待", nil));
        }
    } failureBlock:^(id error) {
        PROGRESS_HUD_DISMISS
        ALTER_HTTP_ERROR_MESSAGE(error)
        FYLog(NSLocalizedString(@"请求创建群出错 => \n%@", nil), error);
        !then?:then(NO);
    }];
}


- (NSArray<MessageItem *> *)getAllGroups
{
    return self.groups.allValues;
}

- (id)getGroupWithGroupId:(NSString *)groupId
{
    return self.groups[groupId];
}

- (void)updateGroupWithGroupId:(MessageItem *)entity
{
    if (entity.groupId == nil) { return; }
    
    self.groups[entity.groupId] = entity;
    BOOL isSuccess = [WHC_ModelSqlite update:entity where:[NSString stringWithFormat:@"id=%@ AND tableOwnerId=%@", entity.groupId, AppModel.shareInstance.userInfo.userId]];
    if (!isSuccess) {
        [WHC_ModelSqlite delete:MessageItem.class where:[NSString stringWithFormat:@"id=%@ AND tableOwnerId=%@", entity.groupId, AppModel.shareInstance.userInfo.userId]];
        [WHC_ModelSqlite insert:entity];
    }
}

- (void)removeGroupEntityWithGroupId:(NSString *)groupId
{
    [self.groups removeObjectForKey:groupId];
    BOOL isSuccess = [WHC_ModelSqlite delete:MessageItem.class where:[NSString stringWithFormat:@"id=%@ AND tableOwnerId=%@", groupId, AppModel.shareInstance.userInfo.userId]];
    if (!isSuccess) {
        FYLog(NSLocalizedString(@"🔴🔴🔴🔴🔴🔴 删除本地 groupentity 失败", nil));
        [WHC_ModelSqlite delete:MessageItem.class where:[NSString stringWithFormat:@"id=%@ AND tableOwnerId=%@", groupId, AppModel.shareInstance.userInfo.userId]];
    }
}

- (NSMutableDictionary *)groups
{
    if (!_groups) {
        _groups = @{}.mutableCopy;
    }
    return _groups;
}


@end
