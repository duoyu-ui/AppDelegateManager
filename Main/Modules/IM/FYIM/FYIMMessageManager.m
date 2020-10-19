//
//  FYSocketMessageManager.m
//  
//
//  Created by Mike on 2019/3/30.
//  Copyright © 2019 Mike. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import "FYIMMessageManager.h"
#import "FYIMSessionViewController.h"
#import "FYSocketManager.h"
#import "WHC_ModelSqlite.h"
#import "EnvelopeMessage.h"


@interface FYIMMessageManager ()
// 声音提示
@property (nonatomic, strong) AVAudioPlayer *player;
// 是否已经获取到我加入的群数据
@property (nonatomic, assign) BOOL isGetMyJoinGroups;
// 是否已经获取到离线消息
@property (nonatomic, assign) BOOL isGetOfflineMessage;

@end


@implementation FYIMMessageManager

+ (FYIMMessageManager *)shareInstance
{
    static FYIMMessageManager *instance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        instance = [[[self class] alloc] init];
    });
    return instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _isConnectFY = NO;
        _isGetMyJoinGroups = YES;
        _isGetOfflineMessage = NO;
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)initWithAppKey:(NSString *)appKey
{
    [self startConnecting:appKey];
}

- (void)sendMessageServer:(NSDictionary *)parameters
{
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:parameters
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&parseError];
    [[FYSocketManager shareManager] fy_sendData:jsonData];
}

- (void)receiveMessageSendReceiptMessage:(FYMessage *)message
{
    NSDictionary *parameters = @{
                                 @"cmd":@"34",
                                 @"id":message.messageId,
                                 @"createTime":@(message.timestamp),
                                 @"from":message.messageSendId,
                                 @"to":message.toUserId,
                                 @"chatType":@(message.chatType),
                                 @"chatId":message.sessionId
                                 };
    [self sendMessageServer:parameters];
}


#pragma mark - Socket 消息处理

// 连接 Socket
- (void)startConnecting:(NSString *)appKey
{    
    appKey = [[FunctionManager sharedInstance] encodedWithString:appKey];
    NSString *url = [NSString stringWithFormat:@"%@?token=%@&deviceType=3", [AppModel shareInstance].commonInfo[@"ws_url"], appKey];
    FYLog(@"Socket URL => %@", url);
    
    [[FYSocketManager shareManager] fy_open:url connect:^{
        
    } receive:^(id message, FYSocketReceiveType type) {
    
        if (type == FYSocketReceiveTypeForMessage) {
            NSDictionary *dict = (NSDictionary *)[message mj_JSONObject];
//            NSLog(@"%@",[dict mj_JSONString]);
            // 消息业务指令
            NSInteger command = [dict[@"command"] integerValue];
            if (command == 6) {
                NSInteger code = [dict[@"code"] integerValue];
                if (code == 10007) {
                    self.isConnectFY = YES;
                    [FYSocketManager shareManager].isInvalidToken = NO;
                    // 登录成功，连接建立，收到消息
                    [self initialAllIMModules];
                    [self sendGetNewUnreadMessage];
                    // [self sendGetOfflineMessages];
                    //
                    [NOTIF_CENTER postNotificationName:kLoggedSuccessNotification object:nil];
                } else if (code == 10008) {
                    FYLog(NSLocalizedString(@"登录失败，无效[token]", nil));
                    self.isConnectFY = NO;
                    [FYSocketManager shareManager].isInvalidToken = YES;
                    [self fyHandleForcedOffline:dict];
                } else if (code == 10010) {
                    // 此账号已在其它终端登录
                    [self fyHandleKickedOutLogin:dict];
                } else if (code == 10009) {
                    FYLog(NSLocalizedString(@"登录失败，此账号已被封", nil));
                    [[FYSocketManager shareManager] fy_close:nil];
                    //
                    [self fyHandleForcedOffline:dict];
                }
            } else if (command == 11) {
                if ([dict[@"data"][@"msgType"] integerValue] == 12) {//抢庄牛牛,龙虎斗过滤老版本消息
                    return;
                }
                // 在线气泡
                [self fyHandleChatOnLineMessage:dict];
            } else if (command == 12) {
                // 系统消息类
                [self fyHandleSystemMessage:dict];
            } else if (command == 13) {
                // 心跳处理
            } else if (command == 16) {
                // 撤回消息
                [self fyHandleUserRecallMessage:dict];
            } else if (command == 20) {
                // 获取离线消息数据
                [self fyHandleGetOfflineMessages:dict];
            } else if (command == 31) {
                // 所有群的未读消息
                [self fyHandleGetNewUnreadMessage:dict];
            } else if (command == 26) {
                // 通知
                [self fyHandleSysNotifiMessage:dict];
            } else if (command == 28) {
                // 强制下线
                NSInteger code = [dict[@"code"] integerValue];
                if (code == 10029) {
                    // 强制下线
                    [self fyHandleForcedOffline:dict];
                }
            } else if (command == 33 || command == 34) {
                // 被退群，加入群
                [self fyHandleJoinKickedOutGroup:dict];
            } else if (command == 36) {
                // 牛牛消息
                [NOTIF_CENTER postNotificationName:kNotificationGroupOfRobNiuNiuContent object:dict];
            } else if (command == 40) {
                // 好友在线离线状态
                [self fyHandleFirendsOnOffLine:dict];
            } else if (command == 42) {
                // 被加入群邀请
                [self fyHandleInvitedToGroup:dict];
            } else if (command == 47) {
                // 实时更新用户余额
                [self fyHandleUserBalanceChange:dict];
            } else if (command == 49) {
                // 通讯录新好友申请
                [self fyHandleNewFriendInvitation:dict];
            }
            
        } else if (type == FYSocketReceiveTypeForPong){
            FYLog(NSLocalizedString(@"\n🔴🔴🔴🔴🔴🔴 Socket 接收 类型2--%@", nil), message);
        }
        
    } failure:^(NSError *error) {
        self.isConnectFY = NO; // 1、本地DNS没有设置也会出现连接不上；2、超时连接服务器，服务器可能挂了
        FYLog(NSLocalizedString(@"\n🔴🔴🔴🔴🔴🔴 ====== Socket 连接失败 ====== 🔴🔴🔴🔴🔴🔴\n%@", nil), error);
    }];
}


#pragma mark - 登录成功后操作

/**
 * 每次登录成功后初始化一次 IM module
 */
- (void)initialAllIMModules
{
    [IMMessageSysModule initialModule];
    [IMContactsModule initialModule];
    [IMMessageModule initialModule];
    [IMSessionModule initialModule];
    [IMGroupModule initialModule];
    [IMUserModule initialModule];
}


#pragma mark 上线发送获取未读消息命令
/**
 * 发送命令获取所有未读消息
 */
- (void)sendGetNewUnreadMessage
{
    if (self.isGetMyJoinGroups) {
        PROGRESS_HUD_SHOW
        [[NetRequestManager sharedInstance] getGroupListWithPageSize:1000 pageIndex:0 officeFlag:NO success:^(id object) {
            PROGRESS_HUD_DISMISS
            if (NET_REQUEST_SUCCESS(object)) {
                NSDictionary *data = [(NSDictionary *)object objectForKey:NET_REQUEST_KEY_DATA];
                if ([data isKindOfClass:[NSDictionary class]]) {
                    NSArray *dataOfRecords = [data arrayForKey:@"records"];
                    NSMutableArray *idarr = [NSMutableArray mj_objectArrayWithKeyValuesArray:dataOfRecords];
                    NSMutableArray *ids = [NSMutableArray arrayWithCapacity:0];
                    [idarr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        [ids addObject:obj[@"id"]];
                    }];
                    [AppModel shareInstance].myGroupArray = ids;
                    [self myGroups]; // 发送命令获取所有群未读消息
                }
            }
        } fail:^(id object) {
            PROGRESS_HUD_DISMISS
        }];
    }
    // 发送命令获取私人离线消息
    [self getOfflinePrivateMessages];
}

/**
 * 发送命令获取所有群未读消息（群组）
*/
- (void)myGroups
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        /// [AppModel shareInstance].myGroupArray 老版本是使用这个获取群组 ssessionid
        NSMutableArray *listArray = [NSMutableArray array];
        for (NSInteger i = 0; i < [AppModel shareInstance].myGroupArray.count; i++) {
            NSMutableDictionary *listDict = [NSMutableDictionary dictionary];
            [listDict setObject:[AppModel shareInstance].myGroupArray[i] forKey:@"chatId"];
            NSString *whereStr = [NSString stringWithFormat:@"sessionId = %@", [AppModel shareInstance].myGroupArray[i]];
            FYMessage *fyMessage = [[WHC_ModelSqlite query:[FYMessage class] where:whereStr order:@"by timestamp desc" limit:@"0,1"] firstObject];
            if (fyMessage) {
                [listDict setObject:@(fyMessage.timestamp) forKey:@"msgCreateTime"];
            } else {
                NSTimeInterval timestamp = [[NSDate new] timeIntervalSince1970] * 1000;
                [listDict setObject:@(timestamp) forKey:@"msgCreateTime"];
            }
            [listArray addObject:listDict];
        }
        
        NSDictionary *parameters = @{
                                     @"cmd":@"30",
                                     @"chatType":@(FYConversationType_GROUP),
                                     @"list":listArray,
                                     @"userId": AppModel.shareInstance.userInfo.userId
                                     };
        NSLog(NSLocalizedString(@"✅发送获取所有群未读消息请求✅%@", nil), parameters);
        [self sendMessageServer:parameters];
    });
}

/**
 * 发送命令获取私人离线消息（私人）
 */
- (void)getOfflinePrivateMessages
{
    PROGRESS_HUD_SHOW
    __weak __typeof(self)weakSelf = self;
    [NET_REQUEST_MANAGER pullFriendOfflineMsg:nil successBlock:^(id response) {
        PROGRESS_HUD_DISMISS
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        if (NET_REQUEST_SUCCESS(response)) {
            [strongSelf offlinePrivateMessagesData:response];
        } else {
            [[FunctionManager sharedInstance] handleFailResponse:response];
        }
    } failureBlock:^(NSError *error) {
        PROGRESS_HUD_DISMISS
        [[FunctionManager sharedInstance] handleFailResponse:error];
    }];
}

/**
 * 发送命令获取私人离线消息（私人）
 */
- (void)offlinePrivateMessagesData:(NSDictionary *)response
{
    id data = NET_REQUEST_DATA(response);
    if ([data isKindOfClass:[NSArray class]]) {
        NSArray *dataArray = (NSArray *)data;
        for (NSInteger index = 0; index < dataArray.count; index++) {
            NSDictionary *dataDict = dataArray[index];
            NSInteger messageCount = [dataDict integerForKey:@"count"]; // 未读消息总量
            NSArray *dataMessageList = [dataDict arrayForKey:@"msgList"];
            // 当前返回数量
            NSInteger num = dataMessageList.count;
            //
            for (NSInteger i = 0; i < dataMessageList.count; i++) {
                num--;
                [self receiveMessage:dataMessageList[i] isOfflineMsg:YES messageCount:messageCount left:num];
            }
        }
    }
}


#pragma mark - 退出登录
- (void)userSignout
{
    [[FYSocketManager shareManager] fy_close:nil];
    self.isConnectFY = NO;
    [AppModel shareInstance].userInfo.token = nil;
    [FYSocketManager shareManager].isViewLoad = NO;
    // [WHC_ModelSqlite removeModel:[FYMessage class]];
}

#pragma mark 账号已封、Token无效、强制下线
- (void)fyHandleForcedOffline:(NSDictionary *)dict
{
    [self userSignout];
    
    [[AppModel shareInstance] logout];
    
    dispatch_async(dispatch_get_main_queue(),^{
        AlertViewCus *view = [AlertViewCus createInstanceWithView:nil];
        [view showWithText:[NSString stringWithFormat:@"%@", dict[@"msg"]] button:NSLocalizedString(@"确定", nil) callBack:nil];
    });
}

#pragma mark 被踢出登录，此账号已在其它终端登录
- (void)fyHandleKickedOutLogin:(NSDictionary *)dict
{
    [self userSignout];
    
    [[AppModel shareInstance] logout];
    
    dispatch_async(dispatch_get_main_queue(),^{
        AlertViewCus *view = [AlertViewCus createInstanceWithView:nil];
        [view showWithText:[NSString stringWithFormat:@"%@",dict[@"msg"]] button:NSLocalizedString(@"好的", nil) callBack:nil];
    });
}


#pragma mark - 在线聊天气泡消息
- (void)fyHandleChatOnLineMessage:(NSDictionary *)dict
{
    // 在线气泡
    NSDictionary *dictList = dict[@"data"];
    {
        NSInteger groupType=[dictList[@"groupType"] integerValue];
        NSInteger msgType=[dictList[@"msgType"] integerValue];
        if (groupType == 9 && msgType == 11) {
            NSInteger userID = [[AppModel shareInstance].userInfo.userId integerValue];
            NSString *contentString = dictList[@"content"];
            NSDictionary *kvDict = [contentString mj_JSONObject];
            RobNiuNiuMessageTypeModel *msg = [RobNiuNiuMessageTypeModel mj_objectWithKeyValues:kvDict];
            if (msg.userIdList.count < 1 || [msg.userIdList containsObject:@(userID)]) {
                FYLog(NSLocalizedString(@"============找到了这个人=====是自己===<<", nil));
            } else {
                return;
            }
        }
    }
    [self receiveMessage:dictList isOfflineMsg:NO messageCount:0 left:0];
    [NOTIF_CENTER postNotificationName:kNotificationGroupOfRobNiuNiuContent object:dict];
}


#pragma mark - 撤回消息
- (void)fyHandleUserRecallMessage:(NSDictionary *)dict {
    
    NSDictionary *dataDict = dict[@"data"];
    NSString *whereStr = [NSString stringWithFormat:@"messageId='%@'", dataDict[@"id"]];
    FYMessage *fyMessage = [[WHC_ModelSqlite query:[FYMessage class] where:whereStr] firstObject];
    fyMessage.isDeleted = YES;
    fyMessage.isRecallMessage = YES;
    
  
    if (self.delegate && [self.delegate respondsToSelector:@selector(willRecallMessage:)]) {
        [self.delegate willRecallMessage:[NSString stringWithFormat:@"%@", dataDict[@"id"]]];
    }
    
    if (fyMessage != nil) {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
//            [WHC_ModelSqlite delete:FYMessage.class where:whereStr];
            [WHC_ModelSqlite update:fyMessage where:whereStr];
        });
    }
    //处理上一条消息的显示
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [IMSessionModule.sharedInstance handleMessageForRecallOrDeletedWithSessionId:fyMessage.sessionId];
    });
}


#pragma mark - 系统消息类
/**
 * common 12 系统消息类
 * @param dict 字典数据
 */
- (void)fyHandleSystemMessage:(NSDictionary *)dict
{
    NSInteger code = [dict[@"code"] integerValue];
//    FYMessage *message = [[FYMessage alloc] init];
    FYMessage *message = [FYMessage mj_objectWithKeyValues:dict[@"data"]];
    if (code == 10000) {  // 消息发送成功
        NSLog(NSLocalizedString(@"消息发送成功", nil));
    } else if (code == 10024 || code == 10025 || code == 10032 || code == 10033) {
        // 10024 您已被禁言!   // 10025 群组已禁言!   // 10032 聊天字数超过群限制    // 10033 说话速度超过群设置的聊天间隔
        
        message.create_time = [NSDate date];
        message.messageFrom = FYChatMessageFromSystem;
        
        message.deliveryState = FYMessageDeliveryStateFailed;
        message.isReceivedMsg = YES;
        
        if (message.messageType == FYMessageTypeImage || message.messageType == FYMessageTypeVoice ||message.messageType == FYMessageTypeVideo ) {
            if ([message.messageSendId isEqualToString:[AppModel shareInstance].userInfo.userId]) {
                NSString *messageId = [NSString stringWithFormat:@"%.f", [message.extras[@"timestamp"] doubleValue]];
                FYMessage *fyMessage = [[IMMessageModule sharedInstance] getMessageWithMessageId:messageId];
                fyMessage.deliveryState = FYMessageDeliveryStateFailed;
                [[IMMessageModule sharedInstance] updateMessage:fyMessage];
            }
        }
        
        message.text = dict[@"msg"];
        if (self.delegate && [self.delegate respondsToSelector:@selector(willAppendAndDisplayMessage:)]) {
            message = [self.delegate willAppendAndDisplayMessage:message];
        }
        
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [WHC_ModelSqlite insert:message];
        });
    }
}


#pragma mark - 获取离线消息数据

- (void)fyHandleGetOfflineMessages:(NSDictionary *)dict
{
    NSLog(@"✅收到离线消息：✅\n%@",[dict mj_JSONString]);
    NSInteger code = [dict integerForKey:@"code"];
    if (code == 10016) {
        NSDictionary *dataDict = [dict dictionaryForKey:@"data"];
        NSArray *groupArray = [dataDict arrayForKey:@"groups"];
        
        for (NSInteger index = 0; index < groupArray.count; index++) {
            NSDictionary *groupDict = groupArray[index];
            //            NSString *sessionId =  groupDict[@"chatId"];
            NSArray *groupMessageList =  [groupDict arrayForKey:@"offlineMsgList"];
            NSInteger num = groupMessageList.count;
            
            for (NSInteger i = 0; i < groupMessageList.count; i++) {
                num--;
                [self receiveMessage:groupMessageList[i] isOfflineMsg:YES messageCount:0 left:num];
            }
        }
    } else if (code == 10018) {
        // 下拉数据
        NSDictionary *groupDict = [dict dictionaryForKey:@"data"];
        NSArray *groupMessageList =  [groupDict arrayForKey:@"msgList"];
        NSArray <FYMessage*>*messageList = [self messageJsonModel:groupMessageList];
        if (self.delegate && [self.delegate respondsToSelector:@selector(downPullGetMessageArray:)]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.delegate downPullGetMessageArray:messageList];
            });
        }
        
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [WHC_ModelSqlite inserts:messageList];
        });
    } else {
       
    }
}


- (NSArray <FYMessage*>*)messageJsonModel:(NSArray *)array
{
    NSMutableArray <FYMessage*>*arrayM = [NSMutableArray array];
    NSString *currentUserID = [AppModel shareInstance].userInfo.userId;
    for (NSInteger index = 0; index < array.count; index++) {
        
        FYMessage *message = [FYMessage mj_objectWithKeyValues:array[index]];
        if (![[AppModel shareInstance].userInfo.userId isEqualToString:message.messageSendId]){
            
            message.isReceivedMsg = YES;
        }
        //9 超级扫雷
        if (message.groupType == 9 && message.messageType == FYMessageTypeNotice) {
            NSString *contentString=message.text;
            NSDictionary *kvDict=[contentString mj_JSONObject];
            RobNiuNiuMessageTypeModel *msg=[RobNiuNiuMessageTypeModel  mj_objectWithKeyValues:kvDict];
            if (msg.userIdList.count < 1 || [msg.userIdList containsObject:currentUserID]) {
                
            } else {
                continue;
            }
        }
        if(message.messageType == FYMessageTypeRedEnvelope){
            if ([array[index] isKindOfClass:[NSDictionary class]]) {
                if (message.redEnvelopeMessage == nil) {
                    EnvelopeMessage *reMessage = [EnvelopeMessage mj_objectWithKeyValues:[message.text mj_JSONObject]];
                    reMessage.cellStatus = @"0";
                    message.redEnvelopeMessage  = reMessage;
                }
            }
        }
        message.create_time = [NSDate date];
        
        if ([[AppModel shareInstance].userInfo.userId isKindOfClass:[NSNumber class]]) {
            [AppModel shareInstance].userInfo.userId  = [(NSNumber *)[AppModel shareInstance].userInfo.userId stringValue];
        }
        if (message.messageType == FYMessageTypeNotice) {
            NSDictionary *textDict = [message.text mj_JSONObject];
            if (textDict[@"userIdList"] != nil) {
                NSArray <NSNumber*>*list = [NSNumber mj_objectArrayWithKeyValuesArray:textDict[@"userIdList"]];
                ///消息里面是否包含自己的userID,包含的话要显示这条消息
                BOOL isUserId = [list containsObject:@([currentUserID integerValue])];
                if (!isUserId) {
                    continue;
                }
            }
        }
        if ( message.messageType !=  FYMessageTypeRobReport) {
            [arrayM addObject:message];
        }
    }
    
    return arrayM;
}


#pragma mark - 收到被邀请入群验证消息

- (void)fyHandleInvitedToGroup:(NSDictionary *)dict
{
    NSDictionary *data = dict[@"data"];
    FYGroupVerifiEntity *entity = [FYGroupVerifiEntity initWithDict:data];
    [[IMContactsModule sharedInstance] addGroupVerification:entity];
}


#pragma mark - 被加入群或者被踢出群

- (void)fyHandleJoinKickedOutGroup:(NSDictionary *)dict
{
    NSInteger command = [dict integerForKey:@"command"];
    if (command == 33) {
        // 被踢出群
        /*
        NSString *sessionId = dict[@"data"];
        [IMSessionModule.sharedInstance removeSession:sessionId];
        [IMGroupModule.sharedInstance removeGroupEntityWithGroupId:sessionId];
        */
    } else if (command == 34) {
        // 被加入群
        NSString *msg = [dict stringForKey:@"msg"];
        [SVProgressHUD showSuccessWithStatus:msg];
    }
    
    // 更新自己的群组信息
    [[IMGroupModule sharedInstance] handleUpdateAllGroupEntitys:^(BOOL success) {
        [NOTIF_CENTER postNotificationName:kNotificationJoinOrDeletedDidUserGroup object:dict];
    }];
}


#pragma mark - 获取所有群未读消息
- (void)fyHandleGetNewUnreadMessage:(NSDictionary *)dict
{
    NSInteger code = [dict integerForKey:@"code"];
    if (code == 10036) {
        
        NSArray *groupArray = [dict arrayForKey:@"data"];
        
        for (NSInteger index = 0; index < groupArray.count; index++) {
            NSDictionary *groupDict = groupArray[index];
            if (![groupDict isKindOfClass:[NSDictionary class]]) {
                continue;
            }
            NSString *sessionId = [NSString stringWithFormat:@"%@", [groupDict stringForKey:@"chatId"]];
            NSInteger messageCount = [groupDict integerForKey:@"count"]; // 未读消息总量
            NSArray *groupMessageList =  [groupDict arrayForKey:@"msgList"];
            NSInteger num = groupMessageList.count;  // 当前返回数量
            
            if (messageCount >= 100) {
                NSString *query = [NSString stringWithFormat:@"sessionId='%@'",sessionId];
                [WHC_ModelSqlite delete:[FYMessage class] where:query];
            }
            
            for (NSInteger i = 0; i < groupMessageList.count; i++) {
                num--;
                [self receiveMessage:groupMessageList[i] isOfflineMsg:YES messageCount:messageCount left:num];
            }
            
            // 从msg中取出 被踢出群的groupId
            NSString *groupId = [groupDict stringForKey:@"chatId"];
            NSString *msg = [dict stringForKey:@"msg"];
            if (msg.length > 0) {
                if ([msg containsString:groupId]) {
                    // 如果包含 代表被踢出了这个群
                    dispatch_async(dispatch_get_global_queue(0, 0), ^{
                        [self fyHandleJoinKickedOutGroup:@{@"cmd": @"33", @"data":groupId}];
                    });
                }
            }
        }
        
        // 获取到了 未读消息
        self.isGetOfflineMessage = YES;
    }
}


#pragma mark - 好友在线或离线

- (void)fyHandleFirendsOnOffLine:(NSDictionary *)dict
{
    NSDictionary *data = [[dict stringForKey:@"data"] mj_JSONObject];
    NSString *userId = [data stringForKey:@"friend"];
    NSInteger status = [data integerForKey:@"status"];
    
    if (userId.length > 0) {
        // 更新session
        [[IMSessionModule getAllSessions] enumerateObjectsUsingBlock:^(FYContacts * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj.userId isEqualToString:userId]) {
                obj.status = (int)status;
                [IMSessionModule.sharedInstance updateSeesion:obj];
                *stop = YES;
            }
        }];
       
        [[IMContactsModule sharedInstance] handleUpdateAllContactEntitys:^(BOOL success) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationUserOnOffStatusChange object:nil];
            });
        }];
    }
}


#pragma mark - 系统通知类
/**
 * common 26 系统通知类
 * @param dict 字典数据
 */
- (void)fyHandleSysNotifiMessage:(NSDictionary *)dict
{
    // 广播消息
    NSDictionary *dictData = [NSDictionary dictionaryWithDictionary:dict[@"data"]];
    NSString *objectName = [NSString stringWithFormat:@"%@", dictData[@"objectName"]];
    if ([objectName isEqualToString:@"refreshNews"]) {
        // 刷新系统消息或新闻公告
        [self fyHandleReceiveSysMsgOrNotice:dict];
        return;
    } else if ([objectName isEqualToString:@"refreshGroup"]) {
        // 刷新群信息
        [[NSNotificationCenter defaultCenter] postNotificationName:kReloadMyMessageGroupList object:dict];
    } else if ([objectName isEqualToString:@"appConfig"] || [objectName isEqualToString:@"refreshConfig"]) {
        // 刷新 appconfig 接口
        [[NetRequestManager sharedInstance] requestAppConfigWithSuccess:^(id object) {
            if ([object isKindOfClass:[NSDictionary class]]) {
                FYGameAppConfigStyle appConfigStyleOld = [APPINFORMATION getGameAppConfigStyle];
                [[AppModel shareInstance] updateCommonInformation:(NSDictionary *)object];
                FYGameAppConfigStyle appConfigStyleNew = [APPINFORMATION getGameAppConfigStyle];
                if (appConfigStyleOld != appConfigStyleNew) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationAppConfigStyleModeChange object:dict];
                }
            }
        } fail:^(id object) {
            
        }];
    } else if ([objectName isEqualToString:@"refreshGroupGame"]) {
        // 刷新游戏大厅
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationReloadGamesMallList object:dict];
    } else if ([objectName isEqualToString:@"refreshTryFlag"]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kGameCloseAtThreeMinLater object:dictData];
    } else if ([objectName isEqualToString:@"refrehSdShowHide"]) {
        //
        BOOL isShowLevel2 = [dictData[@"value"] boolValue];
        [[AppModel shareInstance] isShow2LevelSetting:isShowLevel2];
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationGamesMallSDShowHide object:dictData];
    }
}

// 刷新系统消息或新闻公告
- (void)fyHandleReceiveSysMsgOrNotice:(NSDictionary *)dict
{
    // 说明：添加，删除，修改都会收到刷新通知
    [FYMSG_PRECISION_MANAGER doTryGetSysMsgNoticeData:@"" then:^(BOOL success, NSMutableArray<FYSysMsgNoticeEntity *> * _Nonnull itemSysMsgNoticeModels) {
        if (success) {
            if (itemSysMsgNoticeModels.count > 0) { // 添加，删除，修改后，根据发布时间排序，获取最后一条消息
                NSString *sessionId = [FYSysMsgNoticeEntity reuseChatSysMsgNoticeSessionId];
                FYContacts *session = [[IMSessionModule sharedInstance] getSessionWithSessionId:sessionId];
                //
                FYSysMsgNoticeEntity *sysMsgNoticeEntity = itemSysMsgNoticeModels.firstObject;
                NSDate *releaseTime = [NSDate dateFromString:sysMsgNoticeEntity.releaseTime andFormat:kNSDateFormatDateFullNormal];
                //
                if (!session || [releaseTime isLaterThan:session.lastCreate_time]) { // 添加或更新了消息
                    // 播放消息的提示音
                    if ([AppModel shareInstance].turnOnSound) {
#if TARGET_IPHONE_SIMULATOR
                        FYLog(NSLocalizedString(@"模拟器：声音提示，你收到新消息了！", nil));
#elif TARGET_OS_IPHONE
                        [self.player play];
#endif
                    }
                    // 系统消息通知公告 - 添加
                    [[IMSessionModule sharedInstance] insertFYSysMsgContacts:sysMsgNoticeEntity isFirstInit:NO];
                    // 刷新系统消息或通知公告
                    [NOTIF_CENTER postNotificationName:kNotificationSysMsgOrPlatformNoticeChange object:itemSysMsgNoticeModels];
                    // 未读消息数有变更
                    [NOTIF_CENTER postNotificationName:kNotificationMsgUnreadMessageNumberChange object:nil];
                } else if ([releaseTime isEarlierThan:session.lastCreate_time]) { // 删除了最后一条消息
                    // 系统消息通知公告 - 更新
                    [[IMSessionModule sharedInstance] updateSessionSysMsgNotice:sysMsgNoticeEntity];
                    // 删除最后一条消息
                    [[IMMessageSysModule sharedInstance] deleteSystemMessageEntityId:session.lastMessageId];
                    // 刷新系统消息或通知公告
                    [NOTIF_CENTER postNotificationName:kNotificationSysMsgOrPlatformNoticeChange object:itemSysMsgNoticeModels];
                }
                // 将系统消息插入数据库
                dispatch_async(dispatch_get_global_queue(0, 0), ^{
                    [[IMMessageSysModule sharedInstance] addSystemMessageEntity:sysMsgNoticeEntity];
                });
            } else {
                // 系统消息通知公告 - 清空
                [[IMSessionModule sharedInstance] removeSessionSysMsgNotice:[FYSysMsgNoticeEntity reuseChatSysMsgNoticeSessionId]];
                // 刷新系统消息或通知公告
                [NOTIF_CENTER postNotificationName:kNotificationSysMsgOrPlatformNoticeChange object:@[].mutableCopy];
                // 未读消息数有变更
                [NOTIF_CENTER postNotificationName:kNotificationMsgUnreadMessageNumberChange object:nil];
            }
        }
    }];
}


#pragma mark - 实时更新用户余额

- (void)fyHandleUserBalanceChange:(NSDictionary *)dict
{
    /*
    {
        command = 47;
        data =     {
            chatType = 2;
            cmd = 47;
            content = "{\"balance\":98506.80,\"frozenMoney\":0.00,\"id\":6075,\"userId\":6075,\"version\":0}";
            createTime = 1591244157085;
            from = "fy-service-bill";
            id = 03cf663fa3114502bd203f68f6065c35;
            msgType = 0;
            to = 6075;
        };
    }
    */
    
    // JSON转字典
    NSDictionary *data = [dict dictionaryForKey:@"data"];
    NSString *jsoncontent = [data stringForKey:@"content"];
    NSDictionary *jsonObject = [jsoncontent mj_JSONObject];
    if (!jsonObject) {
        return;
    }
    
    // 余额是否为空
    NSString *balance = [jsonObject stringForKey:@"balance"];
    NSString *frozenMoney = [jsonObject stringForKey:@"frozenMoney"];
    if (!balance || VALIDATE_STRING_EMPTY(balance)) {
        return;
    }

    // 用户ID是否相等
    NSString *userId = [jsonObject stringForKey:@"userId"];
    if (![APPINFORMATION.userInfo.userId isEqualToString:userId]) {
        return;
    }

    // 更新用户余额
    [[AppModel shareInstance].userInfo setBalance:balance];
    [[AppModel shareInstance] saveAppModel];

    // 发余额变动通知
    FYLog(NSLocalizedString(@"用户[%@]余额变动 => %@", nil), userId, balance);
    NSDictionary *object = @{ @"balance": balance, @"frozenMoney": frozenMoney };
    [NOTIF_CENTER postNotificationName:kNotificationUserInfoBalanceChange object:object];
}


#pragma mark - 通讯录新好友申请

- (void)fyHandleNewFriendInvitation:(NSDictionary *)dict
{
    /*
     command:49
     code:10042
     msg
     data={
         userId   发起邀请的用户id
         avatar   发起邀请的用户头像
         nick     发起邀请的用户昵称
         opFlag   0发起邀请，1同意邀请 2删除好友
         message  申请信息
         remarks  好友备注信息
     }
     */
    NSLog(NSLocalizedString(@"*****====>用户申请处理信息:%@", nil), dict);
    
    // JSON转字典
    NSString *jsoncontent = [dict stringForKey:@"data"];
    NSDictionary *jsonObject = [jsoncontent mj_JSONObject];
    if (!jsonObject) {
        return;
    }
    
    /// 0发起邀请  1同意邀请   2删除好友
    FYFriendVerifiEntity *entity = [FYFriendVerifiEntity initWithDict:jsonObject];
    if (entity.opFlag.integerValue == 0) {
        if ([AppModel shareInstance].turnOnSound) {
#if TARGET_IPHONE_SIMULATOR
            FYLog(NSLocalizedString(@"模拟器：声音提示，你收到新消息了！", nil));
#elif TARGET_OS_IPHONE
            [self.player play];
#endif
        }
        [[IMContactsModule sharedInstance] addFriendVerification:entity];
    } else {
        [[IMContactsModule sharedInstance] handleUpdateAllContactEntitys:^(BOOL success) {
            [NOTIF_CENTER postNotificationName:kNotificationAddOrDeleteFriend object:nil];
        }];
    }
}


#pragma mark - 在线聊天消息接收处理
/**
 * common 11 or other 消息接收
 * @param dict 消息字典数据
 * @param isOfflineMsg 是否离线消息
 * @param left 未读数量
 */
- (void)receiveMessage:(NSDictionary *)dict isOfflineMsg:(BOOL)isOfflineMsg messageCount:(NSInteger)messageCount left:(NSInteger)left
{
    FYMessage *message = [FYMessage mj_objectWithKeyValues:dict];
    if (message.messageType == FYMessageTypeNotice) {
        NSDictionary *textDict = [message.text mj_JSONObject];
        if ([textDict[@"type"] intValue] == 22 || [textDict[@"type"] intValue] == 23 || [textDict[@"type"] intValue] == 24 || [textDict[@"type"] intValue] == 25) {
            if (textDict[@"userIdList"] != nil) {
                NSArray <NSNumber*>*list = [NSNumber mj_objectArrayWithKeyValuesArray:textDict[@"userIdList"]];
                ///消息里面是否包含自己的userID,包含的话要显示这条消息
                BOOL isUserId = [list containsObject:@([[AppModel shareInstance].userInfo.userId integerValue])];
                if (!isUserId) {
                    return;
                }
            }
        }
    }
    
    // 消息扩展类型（1-官方群，2-自建群，3-客服，4-好友）
//    if (message.extType != FYMessageExtypeGroupOffice
//        && message.extType != FYMessageExtypeGroupSelf
//        && message.extType != FYMessageExtypeCustomer
//        && message.extType != FYMessageExtypeMyFriedns) {
//#if DEBUG
////        NSLog(@"%@",[dict mj_JSONString]);
//        NSString *error = [NSString stringWithFormat:NSLocalizedString(@"后台消息类型错误：[extype=%ld][content=%@]", nil), message.extType, message.text];
//        ALTER_INFO_MESSAGE(error)
//#endif
//        return;
//    }

    if (message.chatType == FYConversationType_PRIVATE
        || message.chatType == FYConversationType_CUSTOMERSERVICE) {
        [self receiveMessageSendReceiptMessage:message];
        message.chatType = FYConversationType_PRIVATE;
        if (self.receiveMessageBlock != nil){
            self.receiveMessageBlock(message, dict);
        }
    }
    
    if(message.messageType == FYMessageTypeRedEnvelope) {
        if ([dict isKindOfClass:[NSDictionary class]]) {
            if (message.redEnvelopeMessage == nil) {
                EnvelopeMessage *reMessage = [EnvelopeMessage mj_objectWithKeyValues:[message.text mj_JSONObject]];
                reMessage.cellStatus = @"0";
                message.redEnvelopeMessage  = reMessage;
            }
        }
    }
    message.create_time = [NSDate date];
    
    // 此外代码特殊处理，userId 后台数据有问题
    if ([[AppModel shareInstance].userInfo.userId isKindOfClass:[NSNumber class]]) {
        [AppModel shareInstance].userInfo.userId  = [(NSNumber *)[AppModel shareInstance].userInfo.userId stringValue];
    }
    
    if ([message.messageSendId isEqualToString:[AppModel shareInstance].userInfo.userId]) {
        message.messageFrom = FYMessageDirection_SEND;
    } else {
        message.messageFrom  = FYMessageDirection_RECEIVE;
    }
    
    // if ([[AppModel shareInstance].userInfo.userId isEqualToString:message.messageSendId]) {
    message.deliveryState = FYMessageDeliveryStateDeliveried;
    message.isReceivedMsg = YES;
    // }
    
    NSString *sessionId = nil;
    FYIMSessionViewController *currentChatVC = [FYIMSessionViewController currentChat];
    if (currentChatVC) {
        sessionId = currentChatVC.sessionId;
    }
   
    if (self.delegate
        && [self.delegate respondsToSelector:@selector(willAppendAndDisplayMessage:)]
        && ([sessionId isEqualToString: message.sessionId])) {
        message = [self.delegate willAppendAndDisplayMessage:message];
    }
    if (self.receiveMessageDelegate && [self.receiveMessageDelegate respondsToSelector:@selector(onFYIMReceiveMessage: messageCount:left:)]) {
        [self.receiveMessageDelegate onFYIMReceiveMessage:message messageCount:messageCount left:left];
    }
    
    if ([AppModel shareInstance].turnOnSound) {
        if (![sessionId isEqualToString:message.sessionId] && ![[AppModel shareInstance].userInfo.userId isEqualToString:message.messageSendId]) {
            if (self.receiveMessageDelegate && [self.receiveMessageDelegate respondsToSelector:@selector(onFYIMCustomAlertSound:)] && [self.receiveMessageDelegate onFYIMCustomAlertSound:message]) {
#if TARGET_IPHONE_SIMULATOR
                FYLog(NSLocalizedString(@"模拟器：声音提示，你收到新消息了！", nil));
#elif TARGET_OS_IPHONE
                [self.player play];
#endif
            }
        }
    }
    
    if ((message.extType != FYMessageExtypeGroupOffice && message.messageType == FYMessageTypeImage) || (message.extType != FYMessageExtypeGroupOffice && message.messageType == FYMessageTypeVoice) || (message.extType != FYMessageExtypeGroupOffice && message.messageType == FYMessageTypeVideo)) {
        if ([message.messageSendId isEqualToString:[AppModel shareInstance].userInfo.userId]) {
            NSString *whereStr = [NSString stringWithFormat:@"messageId='%@'", [NSString stringWithFormat:@"%.f", [message.extras[@"timestamp"] doubleValue]]];
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                [WHC_ModelSqlite delete:[FYMessage class] where:whereStr];
            });
        }
    }
    
    // 扩展消息类型用于区别（1-官方群，2-自建群，3-客服，4-好友）
    if (message.extType == 0) {
        return;
    }
    if (message.extType != FYMessageExtypeGroupOffice ) {
        // 过滤官方群消息的保存
       
        if ((!isOfflineMsg && self.isGetOfflineMessage) || isOfflineMsg) {
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                BOOL isSuccess = [WHC_ModelSqlite insert:message];
                if (!isSuccess) {
                    NSString *query = [NSString stringWithFormat:@"messageId='%@'", message.messageId];
                    [WHC_ModelSqlite delete:FYMessage.class where:query];
                    [WHC_ModelSqlite insert:message];
                }
            });
        } else {
            // 来一条消息都放到数据库中 解决单聊时候的消息没有及时保存到数据库
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                BOOL isSuccess = [WHC_ModelSqlite insert:message];
                if (!isSuccess) {
                    NSString *query = [NSString stringWithFormat:@"messageId='%@'", message.messageId];
                    [WHC_ModelSqlite delete:FYMessage.class where:query];
                    [WHC_ModelSqlite insert:message];
                }
            });
        }
    }
}


#pragma mark - Private

- (AVAudioPlayer *)player
{
    if (!_player) {
        // 虽然传递的参数是NSURL地址, 但是只支持播放本地文件, 远程音乐文件路径不支持
        NSURL *url = [[NSBundle mainBundle]URLForResource:@"fy_sms-received.caf" withExtension:nil];
        _player = [[AVAudioPlayer alloc]initWithContentsOfURL:url error:nil];
        
        //允许调整速率,此设置必须在prepareplay 之前
        _player.enableRate = YES;
        //        _player.delegate = self;
        
        //指定播放的循环次数、0表示一次
        //任何负数表示无限播放
        [_player setNumberOfLoops:0];
        //准备播放
        [_player prepareToPlay];
        
    }
    return _player;
}

/**
 * 发送命令获取离线消息（未使用）
 */
- (void)sendGetOfflineMessages {
    NSDictionary *parameters = @{
                                 @"userId":[AppModel shareInstance].userInfo.userId,
                                 @"type":@"0",
                                 @"cmd":@"19"
                                 };
    [self sendMessageServer:parameters];
}

/**
 * 未知（未使用）
*/
- (void)doneGetMyJoinedGroupsNotification
{
    _isGetMyJoinGroups = YES;
    if (self.isConnectFY) {
        [self sendGetNewUnreadMessage];
    }
}


@end

