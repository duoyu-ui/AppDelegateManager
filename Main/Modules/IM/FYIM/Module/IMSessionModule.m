//
//  IMSessionModule.m
//  Project
//
//  Created by fangyuan on 2019/8/21.
//  Copyright © 2019 CDJay. All rights reserved.
//

#import "IMSessionModule.h"
#import "IMMessageModule.h"
#import <WHC_ModelSqlite.h>

@interface IMSessionModule ()

@property (nonatomic, strong) NSMutableDictionary<NSString *, FYContacts *> *sessions;

@end

@implementation IMSessionModule {
    /// 查询本地消息的页面数
    NSInteger _dbIndex;
}

DEF_SINGLETON(IMSessionModule)

- (instancetype)init
{
    self = [super init];
    self.sessions = @{}.mutableCopy;
    return self;
}

+ (void)initialModule
{
    // 初始化置空
    [IMSessionModule sharedInstance].sessions = @{}.mutableCopy;
}

+ (NSArray<FYContacts *> *)getAllSessions
{
    NSString *query = [NSString stringWithFormat:@"select * from FYContacts where accountUserId='%@' order by isTopTime desc,lastTimestamp desc,lastCreate_time desc limit 999999", [AppModel shareInstance].userInfo.userId];
    NSArray *whereMyFriendByArray = [WHC_ModelSqlite query:[FYContacts class] sql:query];
    NSMutableArray *arrayM = [[NSMutableArray alloc] initWithCapacity:whereMyFriendByArray.count];
    for (NSInteger index = 0; index < whereMyFriendByArray.count; index++) {
        FYContacts *model = (FYContacts *)whereMyFriendByArray[index];
        [arrayM addObject:model];
        IMSessionModule.sharedInstance.sessions[model.sessionId] = model;
    }
    return arrayM.copy;
}

/**
 * 如果出现有的群组没有收到离线消息，需要改成从数据库中读取，有可能会漏掉刚好新加入得群组
 * @return 所有群组离线消息
 */
+ (NSArray<FYContacts *> *)getGroupSessionList
{
    NSMutableArray *array = @[].mutableCopy;
    [IMSessionModule.sharedInstance.sessions.allValues enumerateObjectsUsingBlock:^(FYContacts * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.sessionType == FYConversationType_GROUP) {
            [array addObject:obj];
        }
    }];
    
    return array.copy;
}

+ (NSArray<FYContacts *> *)getSignleSessionList
{
    NSMutableArray *array = @[].mutableCopy;
    [IMSessionModule.sharedInstance.sessions.allValues enumerateObjectsUsingBlock:^(FYContacts * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.sessionType == FYConversationType_PRIVATE) {
            [array addObject:obj];
        }
    }];
    return array.copy;
}


- (BOOL)addSession:(FYContacts *)session
{
    self.sessions[session.id] = session;
    BOOL isSuccess = [WHC_ModelSqlite insert:session];
    if (!isSuccess) {
        NSString *query = [NSString stringWithFormat:@"sessionId='%@' AND accountUserId='%@'", session.sessionId, [AppModel shareInstance].userInfo.userId];
        [WHC_ModelSqlite delete:FYContacts.class where:query];
        isSuccess = [WHC_ModelSqlite insert:session];
    }
    if (isSuccess) {
        FYLog(NSLocalizedString(@"🌱🌱🌱🌱🌱🌱 添加 session [%@][%@] 成功！", nil), session.sessionId, session.name);
    } else {
        FYLog(NSLocalizedString(@"🔴🔴🔴🔴🔴🔴 添加 session [%@][%@] 失败！", nil), session.sessionId, session.name);
    }
    
    return isSuccess;
}

- (BOOL)removeSession:(NSString *)sessionId
{
    NSString *query = [NSString stringWithFormat:@"sessionId='%@' AND accountUserId='%@'", sessionId, [AppModel shareInstance].userInfo.userId];
    BOOL isSuccess = [WHC_ModelSqlite delete:FYContacts.class where:query];
    if (!isSuccess) {
        FYContacts *contacts = [self.sessions objectForKey:sessionId];
        FYLog(NSLocalizedString(@"🔴🔴🔴🔴🔴🔴 删除 session [%@][%@] 失败！", nil), sessionId, contacts.name);
        return isSuccess;
    } else {
        FYContacts *contacts = [self.sessions objectForKey:sessionId];
        FYLog(NSLocalizedString(@"🌱🌱🌱🌱🌱🌱 删除 session [%@][%@] 成功！", nil), sessionId, contacts.name);
    }
    [IMMessageModule.sharedInstance removeLocalMessagesWithSessionId:sessionId];
    [IMSessionModule.sharedInstance.sessions removeObjectForKey:sessionId];
    return isSuccess;
}

- (BOOL)updateSeesion:(FYContacts *)session
{
    if (session.sessionId.length == 0) {
        FYLog(NSLocalizedString(@"🔴🔴🔴🔴🔴🔴 更新 session 失败，sessionId 为空", nil));
        return NO;
    }
    
    IMSessionModule.sharedInstance.sessions[session.sessionId] = session;
    
    NSString *query = [NSString stringWithFormat:@"sessionId='%@' AND accountUserId='%@'", session.sessionId, [AppModel shareInstance].userInfo.userId];
    BOOL isSuccess = [WHC_ModelSqlite update:session where:query];
    if (!isSuccess) {
        // 如果表中新加了字段会更新失败，所以先删除后插入
        [WHC_ModelSqlite delete:FYContacts.class where:query];
        isSuccess = [WHC_ModelSqlite insert:session];
    }
    
    if (!isSuccess) {
        FYLog(NSLocalizedString(@"🔴🔴🔴🔴🔴🔴 更新 session [%@][%@] 失败！", nil), session.sessionId, session.name);
    } else {
        FYLog(NSLocalizedString(@"🌱🌱🌱🌱🌱🌱 更新 session [%@][%@] 成功！", nil), session.sessionId, session.name);
    }
    
    return isSuccess;
}

- (FYContacts *)getSessionWithSessionId:(NSString *)sessionId
{
    return self.sessions[sessionId];
}

- (FYContacts *)getSessionWithUserId:(NSString *)userId
{
    __block FYContacts *session = nil;
    [self.sessions.allValues enumerateObjectsUsingBlock:^(FYContacts * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.userId == userId || obj.id == userId) {
            session = obj;
        }
    }];
    
    return session;
}

- (void)insertFYContacts:(FYMessage *)message lastMessage:(NSString *)lastMessage
{
    // 官方群不缓存消息
    if (message.extType == FYMessageExtypeGroupOffice || message.extType == 0) {
        return;
    }
    
    // 查询
    NSString *query = [NSString stringWithFormat:@"sessionId='%@' AND accountUserId='%@'", message.sessionId, [AppModel shareInstance].userInfo.userId];
    
    FYContacts *session = [[WHC_ModelSqlite query:[FYContacts class] where:query] firstObject];
    if (session) {
        
        session.lastMessage = lastMessage;
        session.messageType = message.extType;
        //
        session.lastTimestamp = message.timestamp;
        session.lastCreate_time = message.create_time;
        session.lastMessageId = message.messageId;
        session.lastMessage = lastMessage;
        
        if (message.chatType == FYConversationType_PRIVATE) {
            if (message.messageFrom == FYMessageDirection_SEND) {
                session.name = message.receiver[@"nick"];
                session.avatar = message.receiver[@"avatar"];
            } else {
                session.name = message.user.nick;
                session.avatar = message.user.avatar;
            }
            session.id = session.userId;
        } else if (message.chatType == FYConversationType_GROUP) {
            // 群组没有图像和名称
            session.id = message.sessionId;
        }
        
        if (message.messageFrom == FYMessageDirection_RECEIVE) {
            /// 只处理收到的消息
            session.unReadMsgCount += 1;
        }
        
        BOOL isSuccess = [WHC_ModelSqlite update:session where:query];
        if (!isSuccess) {
            [WHC_ModelSqlite delete:FYContacts.class where:query];
            isSuccess = [WHC_ModelSqlite insert:session];
        }
        
        if (isSuccess) {
            FYLog(NSLocalizedString(@"🌱🌱🌱🌱🌱🌱 更新 session [%@][%@] 成功！", nil), session.sessionId, session.name);
        } else {
            FYLog(NSLocalizedString(@"🔴🔴🔴🔴🔴🔴 更新 session [%@][%@] 失败！", nil), session.sessionId, session.name);
        }
    
    } else {
        
        session = [FYContacts new];
        
        if (message.chatType == FYConversationType_GROUP) {
            session.id = message.sessionId; // id 和 sessionId 与 groupId 一样
            // 群组 - 头像和昵称
            MessageItem *msgItem = [[IMGroupModule sharedInstance] getGroupWithGroupId:message.sessionId];
            if (msgItem) {
                session.nick = msgItem.chatgName;
                session.name = msgItem.chatgName;
                session.avatar = msgItem.img;
                session.friendNick = msgItem.chatgName;
            }
        } else if (message.chatType == FYConversationType_PRIVATE) {
            // 私聊 - 头像和昵称
            if (message.messageFrom == FYMessageDirection_SEND) {
                session.nick = message.receiver[@"nick"];
                session.name = message.receiver[@"nick"];
                session.avatar = message.receiver[@"avatar"];
                session.userId = message.receiver[@"userId"];
            } else {
                session.nick = message.user.nick;
                session.name = message.user.nick;
                session.avatar = message.user.avatar;
                session.userId = message.user.userId;
            }
            // 好友昵称
            IMUserEntity *entity = [[IMContactsModule sharedInstance] getContactWithUserId:session.userId];
            session.friendNick = VALIDATE_STRING_EMPTY(entity.friendNick)?entity.nick:entity.friendNick;
            session.isFriend = entity.isFriend;
            session.status = entity.status;
            //
            session.id = session.userId;
        }
        
        if (message.messageFrom == FYMessageDirection_RECEIVE) {
            ///只处理收到的消息
            session.unReadMsgCount += 1;
        }
        
        session.sessionId = message.sessionId; // 群组[groupId]、私聊[chatId]
        session.messageType = message.extType;
        session.sessionType = message.chatType;
        session.accountUserId = [AppModel shareInstance].userInfo.userId;
        //
        session.lastTimestamp = message.timestamp;
        session.lastCreate_time = message.create_time;
        session.lastMessageId = message.messageId;
        session.lastMessage = lastMessage;
        
        BOOL isSuccess = [WHC_ModelSqlite insert:session];
        if (!isSuccess) {
            [WHC_ModelSqlite delete:FYContacts.class where:query];
            isSuccess = [WHC_ModelSqlite insert:session];
        }
        if (isSuccess) {
            FYLog(NSLocalizedString(@"🌱🌱🌱🌱🌱🌱 插入 session [%@][%@] 成功！", nil), session.sessionId, session.name);
        } else {
            FYLog(NSLocalizedString(@"🔴🔴🔴🔴🔴🔴 插入 session [%@][%@] 失败！", nil), session.sessionId, session.name);
        }
    }
}

- (void)handleMessageForRecallOrDeletedWithSessionId:(NSString *)sessionId
{
    FYMessage *message = [IMMessageModule.sharedInstance getLocalMessage:sessionId startIndex:_dbIndex];
    if (message == nil) {
        // 退出递归
        _dbIndex = 0;
        return;
    }
    if (message.isDeleted || message.isRecallMessage) {
        _dbIndex ++;
        // 判断上一条消息也是被删除或者撤回
        [self handleMessageForRecallOrDeletedWithSessionId:sessionId];
        return;
    }
    
    FYContacts *contacts = [self getSessionWithSessionId:sessionId];
    contacts.lastMessage = [IMMessageModule.sharedInstance filterMessageToShowMessage:message];
    [IMSessionModule.sharedInstance updateSeesion:contacts];
    _dbIndex = 0;
}


#pragma mark - 系统消息

/**
 * 新增【系统消息】或【通知公告】
 */
- (void)insertFYSysMsgContacts:(FYSysMsgNoticeEntity *)message isFirstInit:(BOOL)isFirstInit
{
    [self handleFYSysMsgContacts:message isUpdate:NO isFirstInti:isFirstInit];
}

/**
 * 更新【系统消息】或【通知公告】
 */
- (void)updateSessionSysMsgNotice:(FYSysMsgNoticeEntity *)message
{
    [self handleFYSysMsgContacts:message isUpdate:YES isFirstInti:NO];
}

/**
 * 删除【系统消息】或【通知公告】
*/
- (BOOL)removeSessionSysMsgNotice:(NSString *)sessionId
{
    NSString *query = [NSString stringWithFormat:@"sessionId='%@' AND accountUserId='%@'", sessionId, [AppModel shareInstance].userInfo.userId];
    BOOL isSuccess = [WHC_ModelSqlite delete:FYContacts.class where:query];
    
    isSuccess = [[IMMessageSysModule sharedInstance] deleteAllSystemMessageEntities];
    
    if (!isSuccess) {
        FYContacts *contacts = [self.sessions objectForKey:sessionId];
        FYLog(NSLocalizedString(@"🔴🔴🔴🔴🔴🔴 删除系统消息 session [%@][%@] 失败！", nil), sessionId, contacts.name);
        return isSuccess;
    } else {
        FYContacts *contacts = [self.sessions objectForKey:sessionId];
        FYLog(NSLocalizedString(@"🌱🌱🌱🌱🌱🌱 删除系统消息 session [%@][%@] 成功！", nil), sessionId, contacts.name);
    }
    
    [IMSessionModule.sharedInstance.sessions removeObjectForKey:sessionId];
    
    return isSuccess;
}

/**
 * 添加、更新【系统消息】或【通知公告】
*/
- (void)handleFYSysMsgContacts:(FYSysMsgNoticeEntity *)message isUpdate:(BOOL)isUpdate isFirstInti:(BOOL)isFirstInit
{
    // 查询
    NSString *query = [NSString stringWithFormat:@"sessionId='%@' AND accountUserId='%@'", message.sessionId, [AppModel shareInstance].userInfo.userId];
    
    // 消息信息
    NSString *lastMessage = message.title;
    NSString *messageId = [NSString stringWithFormat:@"%ld", message.Id];
    NSDate *releaseTime = [NSDate dateFromString:message.releaseTime andFormat:kNSDateFormatDateFullNormal];
    
    // 插入系统会话
    FYContacts *session = [[WHC_ModelSqlite query:[FYContacts class] where:query] firstObject];
    if (session) {
        
        // 只处理收到的消息
        if (!isUpdate) {
            if (isFirstInit) {
                session.unReadMsgCount = 0;
                [[IMMessageSysModule sharedInstance] deleteAllSystemMessageEntities];
            } else {
                __block FYSysMsgNoticeEntity *itemSysMsgEntity = nil;
                [[IMMessageSysModule.sharedInstance allSystemMessageEntities] enumerateObjectsUsingBlock:^(FYSysMsgNoticeEntity * _Nonnull entity, NSUInteger idx, BOOL * _Nonnull stop) {
                    NSString *entityId = [NSString stringWithFormat:@"%ld", entity.Id];
                    if ([messageId isEqualToString:entityId]) {
                        itemSysMsgEntity = entity;
                    }
                }];
                if (!itemSysMsgEntity) {
                    session.unReadMsgCount += 1;
                } else if (itemSysMsgEntity.isRead) {
                    session.unReadMsgCount += 1;
                }
            }
        }
        
        session.lastMessageId = messageId;
        session.lastMessage = lastMessage;
        session.lastCreate_time = releaseTime;
        session.lastTimestamp = releaseTime.timeIntervalSince1970;
        
        BOOL isSuccess = [WHC_ModelSqlite update:session where:query];
        if (!isSuccess) {
            [WHC_ModelSqlite delete:FYContacts.class where:query];
            isSuccess = [WHC_ModelSqlite insert:session];
        }
        if (isSuccess) {
            FYLog(NSLocalizedString(@"🌱🌱🌱🌱🌱🌱 更新系统消息 session [%@][%@] 成功！", nil), session.sessionId, session.name);
        } else {
            FYLog(NSLocalizedString(@"🔴🔴🔴🔴🔴🔴 更新系统消息 session [%@][%@] 失败！", nil), session.sessionId, session.name);
        }
        
    } else {
        
        session = [FYContacts new];
        session.id = message.sessionId; // 本地固定写死
        session.sessionId = message.sessionId; // 会话[chatId]
        session.accountUserId = [AppModel shareInstance].userInfo.userId;
        
        session.nick = message.nick;
        session.name = message.nick;
        session.avatar = message.avatar;
        session.userId = message.userId;
        session.friendNick = message.friendNick;
        session.isFriend = message.isFriend;
        
        session.sessionType = FYConversationType_SYSTEM; // 系统会话
       
        session.lastMessageId = messageId;
        session.lastMessage = lastMessage;
        session.lastCreate_time = releaseTime;
        session.lastTimestamp = releaseTime.timeIntervalSince1970;

        // 只处理收到的消息
        if (!isUpdate) {
            if (isFirstInit) {
                session.unReadMsgCount = 0;
                [[IMMessageSysModule sharedInstance] deleteAllSystemMessageEntities];
            } else {
                session.unReadMsgCount += 1;
            }
        }
        
        BOOL isSuccess = [WHC_ModelSqlite insert:session];
        if (!isSuccess) {
            [WHC_ModelSqlite delete:FYContacts.class where:query];
            isSuccess = [WHC_ModelSqlite insert:session];
        }
        if (isSuccess) {
            FYLog(NSLocalizedString(@"🌱🌱🌱🌱🌱🌱 插入系统消息 session [%@][%@] 成功！", nil), session.sessionId, session.name);
        } else {
            FYLog(NSLocalizedString(@"🔴🔴🔴🔴🔴🔴 插入系统消息 session [%@][%@] 失败！", nil), session.sessionId, session.name);
        }
    }
}


@end

