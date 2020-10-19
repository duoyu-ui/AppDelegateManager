//
//  IMMessageModule.m
//  ProjectCSHB
//
//  Created by fangyuan on 2019/8/22.
//  Copyright © 2019 CDJay. All rights reserved.
//

#import "IMMessageModule.h"
#import <WHC_ModelSqlite.h>
#import "FYIMMessageManager.h"

@interface IMMessageModule ()

@end

@implementation IMMessageModule

DEF_SINGLETON(IMMessageModule)

- (instancetype)init
{
    self = [super init];
    return self;
}

+ (void)initialModule
{

}

/// 所有未读消息数
- (NSInteger)allUnreadMesagges
{
    __block NSInteger count = 0;
    [[IMSessionModule getAllSessions] enumerateObjectsUsingBlock:^(FYContacts * _Nonnull object, NSUInteger idx, BOOL * _Nonnull stop) {
        count += object.unReadMsgCount;
    }];
    return count;
}


- (BOOL)removeLocalMessagesWithSessionId:(NSString *)sessionId
{
    // 清空所有消息
    NSString *query = [NSString stringWithFormat:@"sessionId='%@'",sessionId];
    BOOL isSuccess = [WHC_ModelSqlite delete:FYMessage.class where:query];
    // 最后一条消息
    NSDate *datetime = [NSDate new];
    FYContacts *session = [[IMSessionModule sharedInstance] getSessionWithSessionId:sessionId];
    [session setLastMessage:@""];
    [session setLastMessageId:@""];
    [session setLastCreate_time:datetime];
    [session setLastTimestamp:[datetime timeIntervalSince1970]];
    isSuccess = [[IMSessionModule sharedInstance] updateSeesion:session];
#if DEBUG
    if (!isSuccess) {
        FYContacts *contacts = [[IMSessionModule sharedInstance] getSessionWithSessionId:sessionId];
        FYLog(NSLocalizedString(@"🔴🔴🔴🔴🔴🔴 删除 message [%@][%@] 失败！", nil), sessionId, contacts.name);
    } else {
        FYContacts *contacts = [[IMSessionModule sharedInstance] getSessionWithSessionId:sessionId];
        FYLog(NSLocalizedString(@"🌱🌱🌱🌱🌱🌱 删除 message [%@][%@] 成功！", nil), sessionId, contacts.name);
    }
#endif
    return isSuccess;
}

- (void)removeLocalMessageWithMessageId:(NSString *)messageId
{
    NSString *query = [NSString stringWithFormat:@"messageId='%@'",messageId];
    [WHC_ModelSqlite delete:FYMessage.class where:query];
}

- (FYMessage *)getLocalLastMessage:(NSString *)sessionId
{
    NSString *query = [NSString stringWithFormat:@"sessionId='%@'",sessionId];
    return (FYMessage *)[WHC_ModelSqlite query:FYMessage.class where:query order:@"by timestamp desc" limit:@"0,1"].firstObject;
}

- (FYMessage *)getLocalMessage:(NSString *)sessionId startIndex:(NSInteger)index
{
    NSString *query = [NSString stringWithFormat:@"sessionId='%@'",sessionId];
    return (FYMessage *)[WHC_ModelSqlite query:FYMessage.class where:query order:@"by timestamp desc" limit:[NSString stringWithFormat:@"%ld,1",index]].firstObject;
}

- (NSArray<FYMessage *> *)getLocalMessage:(NSString *)sessionId
{
    NSString *query = [NSString stringWithFormat:@"sessionId='%@'",sessionId];
    return [WHC_ModelSqlite query:FYMessage.class where:query];
}

- (FYMessage *)getMessageWithMessageId:(NSString *)messageId
{
    NSString *whereStr = [NSString stringWithFormat:@"messageId='%@'", messageId];
    return (FYMessage *)[WHC_ModelSqlite query:FYMessage.class where:whereStr].firstObject;
}

#pragma mark - 不同消息类型显示处理
/// 不同消息类型显示处理
/// @param message 消息类型
- (NSString *)filterMessageToShowMessage:(FYMessage *)message
{
    NSString *lastMessage = nil;
    if (message.messageType == FYMessageTypeImage && message.messageFrom != FYChatMessageFromSystem) {
        lastMessage = NSLocalizedString(@"【图片】", nil);
    } else if (message.messageType == FYMessageTypeVoice && message.messageFrom != FYChatMessageFromSystem) {
        lastMessage = NSLocalizedString(@"【语音】", nil);
    }else if (message.messageType == FYMessageTypeVideo && message.messageFrom != FYChatMessageFromSystem){
        lastMessage = NSLocalizedString(@"【视频】", nil);
    } else if (message.messageType == FYMessageTypeRedEnvelope) {
        lastMessage = NSLocalizedString(@"【红包】", nil);
    } else if (message.messageType == FYMessageTypeNoticeRewardInfo) {
        lastMessage = NSLocalizedString(@"【牛牛中奖结果】", nil);
    } else if (message.messageType == FYMessageTypeBett) {
        lastMessage = NSLocalizedString(@"【投注消息】", nil);
    } else if (message.messageType == FYMessageTypeReportAwardInfo) {
        lastMessage = NSLocalizedString(@"【禁枪报奖信息】", nil);
    } else if (message.messageType == FYMessageTypeRobReport) {
        lastMessage = NSLocalizedString(@"【抢庄报奖消息】", nil);
    } else if(message.messageType == FYMessageTypeRob){
        lastMessage = NSLocalizedString(@"【抢庄消息】", nil);
    } else if (message.messageType == FYMessageTypeNotice) {
        lastMessage = NSLocalizedString(@"【提示消息】", nil);
    }else if (message.messageType == FYMessageTypeRopPrompt){
        lastMessage = NSLocalizedString(@"【豹顺报奖消息】", nil);
    }else if (message.messageType == FYMessageTypeGunControlWin){
        lastMessage = NSLocalizedString(@"【禁抢报奖消息】", nil);
    }else if (message.messageType == FYMessageTypeDeminingWin){
        lastMessage = NSLocalizedString(@"【扫雷报奖消息】", nil);
    }else if (message.messageType == FYMessageTypeSuperDemining){
        lastMessage = NSLocalizedString(@"【超级扫雷报奖消息】", nil);
    }else if (message.messageType == FYMessageTypeNiuNiu){
        lastMessage = NSLocalizedString(@"【牛牛报奖消息】", nil);
    }else if (message.messageType == FYMessageTypeTwoNiuNiu){
        lastMessage = NSLocalizedString(@"【二人牛牛报奖消息】", nil);
    } else {
        lastMessage = message.text;
        if (message.chatType == FYConversationType_GROUP) {
            lastMessage = [NSString stringWithFormat:@"%@：%@", [self getLastFriendNickWithMessage:message], message.text];
        }
    }
    return lastMessage;
}

/// 加载好友备注名
- (NSString *)getLastFriendNickWithMessage:(FYMessage *)message
{
    FYContacts *sesstion = [[IMSessionModule sharedInstance] getSessionWithUserId:message.user.userId];
    if (sesstion.friendNick.length > 0 && ![sesstion.friendNick containsString:@"null"]) {
        return sesstion.friendNick;
    } else {
        return message.user.nick;
    }
}

/// 更新message
- (BOOL)updateMessage:(FYMessage *)message
{
    if (message.messageId.length == 0) {
        FYLog(NSLocalizedString(@"🔴🔴🔴🔴🔴🔴 更新 message 失败，messageId 为空", nil));
        return NO;
    }
    
    __block BOOL isSuccess = NO;
    NSString *whereStr = [NSString stringWithFormat:@"messageId='%@'", message.messageId];
    FYMessage *fyMessage = [self getMessageWithMessageId:message.messageId];
    if (fyMessage != nil) {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            isSuccess = [WHC_ModelSqlite update:message where:whereStr];
        });
    }
    
    if (!isSuccess) {
        FYLog(NSLocalizedString(@"🔴🔴🔴🔴🔴🔴 更新 message [%@] 失败！", nil), message.messageId);
    } else {
        FYLog(NSLocalizedString(@"🌱🌱🌱🌱🌱🌱 更新 message [%@] 成功！", nil), message.messageId);
    }
    
    return isSuccess;
}


@end
