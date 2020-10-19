//
//  FYIMManager.m
//  Project
//
//  Created by Mike on 2019/4/2.
//  Copyright © 2019 CDJay. All rights reserved.
//

#import "FYIMManager.h"
#import "FYIMMessageManager.h"
#import "ChatViewController.h"
#import "SqliteManage.h"
#import "GTMBase64.h"
#import "NSData+AES.h"
#import "MessageSingle.h"
#import "PushMessageModel.h"
#import "FYContacts.h"
#import "IMMessageModule.h"

@implementation FYIMManager

+ (FYIMManager *)shareInstance
{
    static FYIMManager *instance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        instance = [[[self class] alloc] init];
    });
    return instance;
}

- (void)initSetting
{
    [self onConnectSocket];
    
    [FYIMMessageManager shareInstance].receiveMessageDelegate = self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onConnectSocket)
                                                 name:kOnConnectSocketNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onLoggedSuccess)
                                                 name:kLoggedSuccessNotification
                                               object:nil];
    
    [IMSessionModule getAllSessions];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)onConnectSocket
{
    if ([FYIMMessageManager shareInstance].isConnectFY) {
        return;
    }
    if ([AppModel shareInstance].commonInfo[@"ws_url"] == nil) {
        return;
    }
    // 用户token
    if ([AppModel shareInstance].userInfo.token != nil) {
        [[FYIMMessageManager shareInstance] initWithAppKey:[AppModel shareInstance].userInfo.token];
    } else {
        if([AppModel shareInstance].userInfo.isLogined == YES) {
            [[AppModel shareInstance] logout];
        }
    }
}

- (void)onLoggedSuccess
{
    [self notificationLogin];
}


#pragma mark - FYReceiveMessageDelegate 消息来源

- (void)onFYIMReceiveMessage:(FYMessage *)message messageCount:(NSInteger)messageCount left:(NSInteger)left
{
    // 官方群不处理
    if (message.extType == FYMessageExtypeGroupOffice) {
        return;
    }
    
    // 最后一条信息
    NSString *lastMessage = [IMMessageModule.sharedInstance filterMessageToShowMessage:message];
    
    // TODO: 记得之后要过滤掉官方群的 session 和 消息
    [[IMSessionModule sharedInstance] insertFYContacts:message lastMessage:lastMessage];
    
    // 未读消息数有变更
    [NOTIF_CENTER postNotificationName:kNotificationMsgUnreadMessageNumberChange object:nil];
}

// 设置通知消息有没有提示音（YES有声音，NO无声音）
- (BOOL)onFYIMCustomAlertSound:(FYMessage *)message
{
    // 程序是否进入后台
    if (APPINFORMATION.isAppEnterBackground) {
        return NO;
    }
    
    // 官方群消息提示音（消息太多，无提示音）
    if (message.extType == FYMessageExtypeGroupOffice) {
        return NO;
    }
    
    // 私聊、自建群
    if (FYConversationType_PRIVATE == message.chatType
        || FYConversationType_GROUP == message.chatType) {
        NSString *key = MESSAGE_NOTICE_SWITCH_KEY(APPINFORMATION.userInfo.userId, message.sessionId);
        BOOL isNotDisturbSound = [[NSUserDefaults standardUserDefaults] boolForKey:key];
        return !isNotDisturbSound;
    }
    
    // 默认提示（客服等）
    return YES;
}


#pragma mark - 更新红包

- (void)updateGroup:(NSString *)sessionId number:(NSInteger)number lastMessage:(NSString *)last messageCount:(NSInteger)messageCount left:(NSInteger)left chatType:(FYChatConversationType)chatType
{
    NSString *queryId = [NSString stringWithFormat:@"%@-%@",sessionId,[AppModel shareInstance].userInfo.userId];
    PushMessageModel *oldModel = (PushMessageModel *)[MessageSingle shareInstance].allUnreadMessagesDict[queryId];
    
    if (oldModel) {
        if (number == 0) {
            [AppModel shareInstance].unReadCount -= oldModel.number;
            if (chatType == FYConversationType_PRIVATE) {
                [AppModel shareInstance].friendUnReadTotal -= oldModel.number;
            }
            
//            else if (chatType == FYConversationType_CUSTOMERSERVICE) {
//                [AppModel shareInstance].customerServiceUnReadTotal -= oldModel.number;
//            }
            oldModel.number = 0;
        } else {
            if (oldModel.number > 99) {
                return;
            }
            oldModel.number += 1;
            [AppModel shareInstance].unReadCount += 1;
            if (chatType == FYConversationType_PRIVATE) {
                [AppModel shareInstance].friendUnReadTotal += 1;
            }
            
//            else if (chatType == FYConversationType_CUSTOMERSERVICE) {
//                [AppModel shareInstance].customerServiceUnReadTotal += 1;
//            }
            oldModel.messageCountLeft = messageCount;
        }
        
        if (last.length >0) {
            oldModel.lastMessage = last;
        }
        [[MessageSingle shareInstance].allUnreadMessagesDict setObject:oldModel forKey:queryId];
    } else {
        if (number == 0) {
            return;
        }
        
        [AppModel shareInstance].unReadCount += 1;
        if (chatType == FYConversationType_PRIVATE) {
            [AppModel shareInstance].friendUnReadTotal += 1;
        }
        
//        else if (chatType == FYConversationType_CUSTOMERSERVICE) {
//            [AppModel shareInstance].customerServiceUnReadTotal += 1;
//        }
        PushMessageModel *newModel = [PushMessageModel new];
        newModel.userId = [AppModel shareInstance].userInfo.userId;
        newModel.number = 1;
        newModel.lastMessage = last;
        newModel.sessionId = sessionId;
        newModel.messageCountLeft = messageCount;
        
        [[MessageSingle shareInstance].allUnreadMessagesDict setObject:newModel forKey:queryId];
        
    }
    
    if ((left == 0 && oldModel.number <= 99) || (messageCount > 0 && left == 0)) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationMsgUnreadMessageNumberChange object:@"GroupListNotification"];
    }
    
    if (oldModel.number == 0 || [AppModel shareInstance].unReadCount == 1) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationMsgUnreadMessageNumberChange object:@"updateBadeValue"];
    }
}


/**
 * 通知服务器登录了
 */
- (void)notificationLogin
{
    [NET_REQUEST_MANAGER appLogin:nil successBlock:^(NSDictionary *response) {
        FYLog(NSLocalizedString(@"通知服务器已登录，成功 => %@", nil), response);
    } failureBlock:^(NSError *error) {
        FYLog(NSLocalizedString(@"通知服务器已登录，失败 => %@", nil), error);
    }];
}


/**
 * 用户主动退出登录
 */
- (void)userSignout
{
    [[FYIMMessageManager shareInstance] userSignout];
    [WHC_ModelSqlite removeModel:[PushMessageModel class]];
    [[MessageSingle shareInstance].allUnreadMessagesDict removeAllObjects];
}

- (void)onTokenInvalid
{
    [FYIMMessageManager shareInstance].isConnectFY = NO;
    [AppModel shareInstance].userInfo.token = nil;
    [AppModel shareInstance].userInfo.fullToken = nil;
    if([AppModel shareInstance].userInfo.isLogined == YES) {
        [[AppModel shareInstance] logout];
    }
}


@end

