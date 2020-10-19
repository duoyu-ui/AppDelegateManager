//
//  FYPrecisionManager.m
//  ProjectCSHB
//
//  Created by fangyuan on 2020/5/22.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "FYPrecisionManager.h"
#import "FYGameBaseViewController.h"
#import "FYGamesStatusModel.h"
#import "FYContactsModel.h"

@implementation FYPrecisionManager

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static FYPrecisionManager *instance = nil;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] initInPrivate];
    });
    return instance;
}

- (instancetype)initInPrivate {
    self = [super init];
    if (self) {

    }
    return self;
}

- (instancetype)init {
    return nil;
}

- (instancetype)copy {
    return nil;
}

- (void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:[FYPrecisionManager sharedInstance]];
}


#pragma mark - 聊天群组

///  进入群游戏
/// - Parameters:
///   - msgItem: 数据模型
- (void)doTryToJoinGroupGame:(MessageItem *)msgItem from:(UINavigationController *)navigationController
{
    if (GroupTemplate_N15_MineClearance == msgItem.type) {
        FYGameBaseViewController *groupGameVC = [FYGameBaseViewController createGameVCByMsgItem:msgItem];
        if (navigationController) {
            [navigationController pushViewController:groupGameVC animated:YES];
        } else {
            [[FunctionManager getTopNavigationController] pushViewController:groupGameVC animated:YES];
        }
    } else {
        ChatViewController *charVC = [ChatViewController groupChatWithObj:msgItem];
        if (navigationController) {
            [navigationController pushViewController:charVC animated:YES];
        } else {
            [[FunctionManager getTopNavigationController] pushViewController:charVC animated:YES];
        }
    }
}

/// 进入群游戏（自建）
/// - Parameters:
///   - msgItem: 数据模型
- (void)doTryToJoinGroupOfficeNo:(MessageItem *)msgItem from:(UINavigationController *)navigationController
{
    [APPINFORMATION setGameType:msgItem.type];
    [APPINFORMATION setOfficeFlag:msgItem.officeFlag];
    
    [self doTryToJoinGroupGame:msgItem from:navigationController];
}

///  进入群游戏（官方）
/// - Parameters:
///   - msgItem: 数据模型
///   - password: 进群密码
- (void)doTryToJoinGroupOfficeYes:(MessageItem *)msgItem password:(NSString *)password from:(UINavigationController *)navigationController
{
    [APPINFORMATION setGameType:msgItem.type];
    [APPINFORMATION setOfficeFlag:msgItem.officeFlag];
    
    // 加入群组 -> 退出聊天时 -> 再退出群
    PROGRESS_HUD_SHOW
    [NET_REQUEST_MANAGER requestChatGroupOfficeYesTryJoinWithGroupId:msgItem.groupId password:password success:^(id response) {
        PROGRESS_HUD_DISMISS
        FYLog(NSLocalizedString(@"请求进入群游戏 => \n%@", nil), response);
        if (NET_REQUEST_SUCCESS(response) || NET_REQUEST_SUCCESS_KEYVALUE(response, @"errorcode", 19)) {
            [self doTryToJoinGroupGame:msgItem from:navigationController];
        } else if (NET_REQUEST_SUCCESS_KEYVALUE(response, @"errorcode", 40001)) {
            [APPINFORMATION isGuest];
        } else {
            ALTER_HTTP_ERROR_MESSAGE(response)
        }
    } failure:^(id error) {
        PROGRESS_HUD_DISMISS
        FYLog(NSLocalizedString(@"请求进入群游戏出错 => \n%@", nil), [error mj_JSONString]);
        if([error isKindOfClass:[NSDictionary class]]) {
            if (NET_REQUEST_SUCCESS_KEYVALUE(error, @"errorcode", 40001)) {
                [APPINFORMATION isGuest];
            } else {
                ALTER_HTTP_ERROR_MESSAGE(error)
            }
        } else {
            [[FunctionManager sharedInstance] handleFailResponse:error];
        }
    }];
}

/// 退出群游戏（官方）
/// - Parameters:
///   - msgItem: 数据模型
///   - isBackToRootVC: 退至根控制器
- (void)doTryToQuitGroupOfficeYes:(MessageItem *)msgItem isBackToRootVC:(BOOL)isBackToRootVC from:(UINavigationController *)navigationController
{
    PROGRESS_HUD_SHOW
    [[NetRequestManager sharedInstance] requestChatGroupOfficeYesTryQuitWithGroupId:msgItem.groupId success:^(id response) {
        PROGRESS_HUD_DISMISS
        if (NET_REQUEST_SUCCESS(response)) {
            if (isBackToRootVC) {
                [navigationController popToRootViewControllerAnimated:YES];
            } else {
                [navigationController popViewControllerAnimated:YES];
            }
        } else {
            ALTER_HTTP_MESSAGE(response)
        }
    } failure:^(id error) {
        PROGRESS_HUD_DISMISS
        if (isBackToRootVC) {
            [navigationController popToRootViewControllerAnimated:YES];
        } else {
            [navigationController popViewControllerAnimated:YES];
        }
        [[FunctionManager sharedInstance] handleFailResponse:error];
    }];
}


#pragma mark - 聊天会话

/// 是否已经置顶
- (BOOL)doTryGetChatSessionStickForSwitch:(NSString *)sessionId
{
    if (VALIDATE_STRING_EMPTY(sessionId)) {
        return NO;
    }
    
    NSString *stickString = CHAT_STICK_SWITCH_KEY(APPINFORMATION.userInfo.userId, sessionId);
    NSString *stringOfArr = NSUSERDEFAULTS_OBJ_KEY(FYMSG_CHAT_STICK_ARRAY_DEF_KEY);
    if (VALIDATE_STRING_EMPTY(stringOfArr)) {
        return NO;
    } else {
        NSArray<NSString *> *arrOfStickKey = [stringOfArr componentsSeparatedByString:FYMSG_CHAT_STICK_ARRAY_SPLIIT];
        if (arrOfStickKey.count <= 0) {
            return NO;
        } else {
            for (NSString *obj in arrOfStickKey) {
                if ([obj isEqualToString:stickString]) {
                    return YES;
                }
            }
        }
    }
    
    return NO;
}

/// 置顶聊天记录（置顶）
- (void)doTryChatSessionForStickYes:(NSString *)sessionId then:(void(^)(BOOL success))then
{
    if (VALIDATE_STRING_EMPTY(sessionId)) {
        ALTER_INFO_MESSAGE(NSLocalizedString(@"消息置顶失败", nil))
        !then?:then(NO);
        return;
    }
    
    NSString *stickString = CHAT_STICK_SWITCH_KEY(APPINFORMATION.userInfo.userId, sessionId);
    NSString *stringOfArr = NSUSERDEFAULTS_OBJ_KEY(FYMSG_CHAT_STICK_ARRAY_DEF_KEY);
    if (VALIDATE_STRING_EMPTY(stringOfArr)) {
        NSUSERDEFAULTS_OBJ_SET(FYMSG_CHAT_STICK_ARRAY_DEF_KEY,stickString);
    } else {
        NSArray<NSString *> *arrOfStickKey = [stringOfArr componentsSeparatedByString:FYMSG_CHAT_STICK_ARRAY_SPLIIT];
        if (arrOfStickKey.count <= 0) {
            NSUSERDEFAULTS_OBJ_SET(FYMSG_CHAT_STICK_ARRAY_DEF_KEY,stickString);
        } else {
            NSMutableArray<NSString *> *arrOfStickUserIdNew = [NSMutableArray<NSString *> array];
            [arrOfStickUserIdNew addObj:stickString];
            for (NSString *obj in arrOfStickKey) {
                if (![obj isEqualToString:stickString]) {
                    [arrOfStickUserIdNew addObj:obj];
                }
            }
            NSString *stringOfStickArr = [arrOfStickUserIdNew componentsJoinedByString:FYMSG_CHAT_STICK_ARRAY_SPLIIT];
            NSUSERDEFAULTS_OBJ_SET(FYMSG_CHAT_STICK_ARRAY_DEF_KEY,stringOfStickArr);
        }
    }
    
    !then?:then(YES);
}

/// 置顶聊天记录（取消置顶）
- (void)doTryChatSessionForStickNO:(NSString *)sessionId then:(void(^)(BOOL success))then
{
    if (VALIDATE_STRING_EMPTY(sessionId)) {
        ALTER_INFO_MESSAGE(NSLocalizedString(@"取消置顶失败", nil))
        !then?:then(NO);
        return;
    }
    
    NSString *stickString = CHAT_STICK_SWITCH_KEY(APPINFORMATION.userInfo.userId, sessionId);
    NSString *stringOfArr = NSUSERDEFAULTS_OBJ_KEY(FYMSG_CHAT_STICK_ARRAY_DEF_KEY);
    if (VALIDATE_STRING_EMPTY(stringOfArr)) {
        NSUSERDEFAULTS_OBJ_SET(FYMSG_CHAT_STICK_ARRAY_DEF_KEY,@"");
    } else {
        NSArray<NSString *> *arrOfStickKey = [stringOfArr componentsSeparatedByString:FYMSG_CHAT_STICK_ARRAY_SPLIIT];
        if (arrOfStickKey.count <= 0) {
            NSUSERDEFAULTS_OBJ_SET(FYMSG_CHAT_STICK_ARRAY_DEF_KEY,@"");
        } else {
            NSMutableArray<NSString *> *arrOfStickUserIdNew = [NSMutableArray<NSString *> array];
            for (NSString *obj in arrOfStickKey) {
                if (![obj isEqualToString:stickString]) {
                    [arrOfStickUserIdNew addObj:obj];
                }
            }
            if (arrOfStickUserIdNew.count <= 0) {
                NSUSERDEFAULTS_OBJ_SET(FYMSG_CHAT_STICK_ARRAY_DEF_KEY,@"");
            } else {
                NSString *stringOfStickArr = [arrOfStickUserIdNew componentsJoinedByString:FYMSG_CHAT_STICK_ARRAY_SPLIIT];
                NSUSERDEFAULTS_OBJ_SET(FYMSG_CHAT_STICK_ARRAY_DEF_KEY,stringOfStickArr);
            }
        }
    }
    
    !then?:then(YES);
}

/// 是否已经读取
- (BOOL)doTryGetChatSessionFinishRead:(id)model
{
    if ([model isKindOfClass:[FYContacts class]]) {
        NSString *sessionId = ((FYContacts *)model).sessionId;
        if (VALIDATE_STRING_EMPTY(sessionId)) {
            return NO;
        }
        FYContacts *session = [[IMSessionModule sharedInstance] getSessionWithSessionId:sessionId];
        return session.unReadMsgCount <= 0;
    } else if ([model isKindOfClass:[FYContactsModel class]]) {
        NSString *sessionId = ((FYContactsModel *)model).chatId;
        if (VALIDATE_STRING_EMPTY(sessionId)) {
            return NO;
        }
        FYContacts *session = [[IMSessionModule sharedInstance] getSessionWithSessionId:sessionId];
        return session.unReadMsgCount <= 0;
    }
    return NO;
}

/// 标记已读
- (void)doTryChatSessionForFinishRead:(id)model then:(void(^)(BOOL success))then
{
    FYContacts *session = nil;
    if ([model isKindOfClass:[FYContacts class]]) {
        NSString *sessionId = ((FYContacts *)model).sessionId;
        session = [[IMSessionModule sharedInstance] getSessionWithSessionId:sessionId];
    } else {
        NSString *sessionId = ((FYContactsModel *)model).chatId;
        session = [[IMSessionModule sharedInstance] getSessionWithSessionId:sessionId];
    }
    
    // 将当前 session 未读消息数清空
    if (session) {
        session.unReadMsgCount = 0;
        BOOL isSuccess = [IMSessionModule.sharedInstance updateSeesion:session];
        if (isSuccess) {
            [NOTIF_CENTER postNotificationName:kNotificationMsgUnreadMessageNumberChange object:nil];
            !then?:then(YES);
        }
    }
    !then?:then(NO);
}

/// 标记未读
- (void)doTryChatSessionForUnFinishRead:(id)model then:(void(^)(BOOL success))then
{
    FYContacts *session = nil;
    if ([model isKindOfClass:[FYContacts class]]) {
        NSString *sessionId = ((FYContacts *)model).sessionId;
        session = [[IMSessionModule sharedInstance] getSessionWithSessionId:sessionId];
    } else {
        NSString *sessionId = ((FYContactsModel *)model).chatId;
        session = [[IMSessionModule sharedInstance] getSessionWithSessionId:sessionId];
    }
    
    // 将当前 session 未读消息数+1
    if (session) {
        session.unReadMsgCount = 1;
        BOOL isSuccess = [IMSessionModule.sharedInstance updateSeesion:session];
        if (isSuccess) {
            [NOTIF_CENTER postNotificationName:kNotificationMsgUnreadMessageNumberChange object:nil];
            !then?:then(YES);
        }
    }
    !then?:then(NO);
}

/// 清空聊天记录
- (void)doTryChatSessionForRecordsClear:(NSString *)sessionId then:(void(^)(BOOL success))then
{
    if (VALIDATE_STRING_EMPTY(sessionId)) {
        ALTER_INFO_MESSAGE(NSLocalizedString(@"聊天【sessionid】为空，不能清空！", nil))
        return;
    }
    
    AlertViewCus *alertView = [AlertViewCus createInstanceWithView:nil];
    [alertView.textLabel setFont:[UIFont systemFontOfSize:16]];
    [alertView showWithText:NSLocalizedString(@"是否清空聊天记录?", nil) button1:NSLocalizedString(@"取消", nil) button2:NSLocalizedString(@"确认", nil) callBack:^(id object) {
        NSInteger tag = [object integerValue];
        if (tag == 1) {
            BOOL isSuccess = [[IMMessageModule sharedInstance] removeLocalMessagesWithSessionId:sessionId];
            !then?:then(isSuccess);
            [NOTIF_CENTER postNotificationName:kNotificationClearChatRecordsContent object:nil];
        }
    }];
}

/// 删除聊天记录
- (void)doTryChatSessionForRecordsDelete:(NSString *)sessionId then:(void(^)(BOOL success))then
{
    if (VALIDATE_STRING_EMPTY(sessionId)) {
        ALTER_INFO_MESSAGE(NSLocalizedString(@"聊天【sessionid】为空，不能删除！", nil))
        return;
    }
    
    AlertViewCus *alertView = [AlertViewCus createInstanceWithView:nil];
    [alertView.textLabel setFont:[UIFont systemFontOfSize:16]];
    [alertView showWithText:NSLocalizedString(@"删除后，将清空该聊天的消息记录", nil) button1:NSLocalizedString(@"取消", nil) button2:NSLocalizedString(@"确认", nil) callBack:^(id object) {
        NSInteger tag = [object integerValue];
        if (tag == 1) {
            BOOL isSuccess = [[IMSessionModule sharedInstance] removeSession:sessionId];
            !then?:then(isSuccess);
            [NOTIF_CENTER postNotificationName:kNotificationMsgUnreadMessageNumberChange object:nil];
        }
    }];
}


#pragma mark - 未读消息
- (void)doTryInitializeUnReadMessageThen:(void (^)(void))then
{
    // 通讯录角标，初始始加载验证消息
    [IMContactsModule initialModule];
    
    // 系统消息 or 通知公告
    [FYMSG_PRECISION_MANAGER doTryInitializeSystemMessageSession];
    
    // 初始化后操作，显示角标
    !then ?: then();
}


#pragma mark - 系统消息 或 通知公告

- (void)doTryInitializeSystemMessageSession
{
    // 获取所有消息会话
    [IMSessionModule getAllSessions];
    
    // 初始化系统会话
    NSString *sessionId = [FYSysMsgNoticeEntity reuseChatSysMsgNoticeSessionId];
    FYContacts *session = [[IMSessionModule sharedInstance] getSessionWithSessionId:sessionId];
    if (!session) {
        [FYMSG_PRECISION_MANAGER doTryGetSysMsgNoticeData:@"" then:^(BOOL success, NSMutableArray<FYSysMsgNoticeEntity *> * _Nonnull itemSysMsgNoticeModels) {
            if (success && itemSysMsgNoticeModels.count > 0) {
                FYSysMsgNoticeEntity *sysMsgNoticeEntity = itemSysMsgNoticeModels.firstObject;
                [[IMSessionModule sharedInstance] insertFYSysMsgContacts:sysMsgNoticeEntity isFirstInit:YES];
            }
        }];
    } else {
        NSString *time = APPINFORMATION.lastSysMsgNoticeReadTime;
        [FYMSG_PRECISION_MANAGER doTryGetSysMsgNoticeData:time then:^(BOOL success, NSMutableArray<FYSysMsgNoticeEntity *> * _Nonnull itemSysMsgNoticeModels) {
            // 离线状态下未读系统消息
            if (success && itemSysMsgNoticeModels.count > 0) {
                // 离线状态下未读系统消息数
                session.unReadMsgCount = itemSysMsgNoticeModels.count;
                [[IMSessionModule sharedInstance] updateSeesion:session];
                // 会话显示最后一条未读消息
                FYSysMsgNoticeEntity *sysMsgNoticeEntity = itemSysMsgNoticeModels.firstObject;
                [[IMSessionModule sharedInstance] updateSessionSysMsgNotice:sysMsgNoticeEntity];
                // 未读消息数有变更
                [NOTIF_CENTER postNotificationName:kNotificationMsgUnreadMessageNumberChange object:nil];
            }
        }];
    }
}

- (void)doTryGetSysMsgNoticeData:(NSString *)time then:(void (^)(BOOL success, NSMutableArray<FYSysMsgNoticeEntity *> *itemSysMsgNoticeModels))then
{
    [[NetRequestManager sharedInstance] allSystemMessagesWithrTime:time page:1 success:^(id response) {
        FYLog(NSLocalizedString(@"系统消息或通知公告 => \n%@", nil), response);
        if (!NET_REQUEST_SUCCESS(response)) {
            !then ?: then(NO,nil);
        } else {
            NSDictionary *data = NET_REQUEST_DATA(response);
            NSArray<NSDictionary *> *arrayOfDicts = [data arrayForKey:@"records"];
            NSMutableArray<FYSysMsgNoticeEntity *> *allSysMsgNoticeModels = [FYSysMsgNoticeEntity buildingDataModles:arrayOfDicts];
            if (allSysMsgNoticeModels && allSysMsgNoticeModels.count > 0) {
                !then ?: then(YES,allSysMsgNoticeModels);
            } else {
                !then ?: then(YES,nil);
            }
        }
    } fail:^(id error) {
        FYLog(NSLocalizedString(@"获取系统消息或通知公告异常 => \n%@", nil), error);
        !then ?: then(NO,nil);
    }];
}


#pragma mark - 游戏大厅

/// 游戏大厅 - WAY1 - 进入三方游戏
- (void)doTryWay1JoinQPGamesWithUrl:(NSString *)url title:(NSString *)title from:(UINavigationController *)navigationController
{
    if ([APPINFORMATION isGuest]) {
        return;
    }

    if (VALIDATE_STRING_EMPTY(url)) {
        ALTER_INFO_MESSAGE(NSLocalizedString(@"游戏登录地址错误！", nil))
        return;
    }
    
    // 自己游戏（QG电子）
    FYWebViewController *webViewController = [[FYWebViewController alloc] initWithUrl:url gameType:FYWebGameSelfDianZiType];
    [webViewController setUserid:APPINFORMATION.userInfo.userId];
    [webViewController setTitle:title];
    [navigationController pushViewController:webViewController animated:YES];
}

/// 游戏大厅 - WAY2 - 进入三方游戏
- (void)doTryWay2JoinQPGamesWidthUrl:(NSString *)url gametype:(NSNumber *)gameType title:(NSString *)title from:(UINavigationController *)navigationController
{
    if ([APPINFORMATION isGuest]) {
        return;
    }
    
    if (VALIDATE_STRING_EMPTY(url)) {
        ALTER_INFO_MESSAGE(NSLocalizedString(@"游戏登录地址错误！", nil))
        return;
    }
    
    // 三方游戏（1：王者棋牌，2：幸运棋牌，3：QG棋牌，4：开元棋牌，5：双赢彩票，6：IM电竞，7：IM体育，8：AG真人，9：AG电子，10：AG捕鱼，11：KG电子）
    FYWebViewController *webViewController = [[FYWebViewController alloc] initWithUrl:url gameType:gameType.integerValue];
    [webViewController setUserid:APPINFORMATION.userInfo.userId];
    [webViewController setTitle:title];
    [navigationController pushViewController:webViewController animated:YES];
}

/// 验证检查游戏状态（大厅模式2）
- (void)doTryCheckVerifyGamesStatus:(NSString *)parentId then:(void (^)(BOOL success, FYGamesStatusModel *gamesStatusModel))then
{
    PROGRESS_HUD_SHOW
    [NET_REQUEST_MANAGER requestGamesCheckStatusWithParentId:parentId success:^(id response) {
        PROGRESS_HUD_DISMISS
        FYLog(NSLocalizedString(@"游戏状态 => \n%@", nil), response);
        if (![CFCSysUtil validateNetRequestResult:response]) {
            ALTER_HTTP_MESSAGE(response)
            !then ?: then(NO,nil);
        } else {
            NSDictionary *data = NET_REQUEST_DATA(response);
            FYGamesStatusModel *gamesStatusModel = [FYGamesStatusModel mj_objectWithKeyValues:data];
            !then ?: then(YES,gamesStatusModel);
        }
    } failure:^(id error) {
        PROGRESS_HUD_DISMISS
        ALTER_HTTP_ERROR_MESSAGE(error)
        FYLog(NSLocalizedString(@"获取游戏状态数据出错 => \n%@", nil), error);
    }];
}

/// 游戏大厅 - 三方游戏余额核实
- (void)doTryThirdPartyGamesVerifyBalanceAffirmThen:(void (^)(BOOL success))then
{
    PROGRESS_HUD_SHOW
    [NET_REQUEST_MANAGER requestGamesThirdPartyBalanceAffirm:@{} success:^(id response) {
        PROGRESS_HUD_DISMISS
        FYLog(NSLocalizedString(@"三方游戏余额核实 => \n%@", nil), response);
        if (![CFCSysUtil validateNetRequestResult:response]) {
            ALTER_HTTP_MESSAGE(response)
            !then ?: then(NO);
        } else {
            !then ?: then(YES);
        }
    } failure:^(id error) {
        PROGRESS_HUD_DISMISS
        ALTER_HTTP_ERROR_MESSAGE(error)
        FYLog(NSLocalizedString(@"三方游戏余额核实出错 => \n%@", nil), error);
    }];
}

/// 游戏大厅 - 三方游戏登录地址URL
- (void)doTryThirdPartyGamesLoginUrlWithGameId:(NSString *)gameId gameType:(NSNumber *)gameType walletId:(NSNumber *)walletId linkUrl:(NSString *)linkUrl then:(void (^)(NSString *url))then
{
    if ([APPINFORMATION isGuest]) {
        return;
    }
    
    NSMutableDictionary *parameters = @{ @"gameid" : gameId,
                                         @"playerType" : @"1",
                                         @"productWallet" : walletId,
                                         @"userid" : APPINFORMATION.userInfo.userId }.mutableCopy;
    
    PROGRESS_HUD_SHOW
    [NET_REQUEST_MANAGER requestGamesThirdPartyLoginWithParameters:parameters gameType:gameType.integerValue linkUrl:linkUrl success:^(id response) {
        PROGRESS_HUD_DISMISS
        FYLog(NSLocalizedString(@"三方游戏登录地址 => \n%@", nil), response);
        if (!NET_REQUEST_SUCCESS(response)) {
            ALTER_HTTP_ERROR_MESSAGE(response)
        } else {
            NSDictionary *data = NET_REQUEST_DATA(response);
            NSString *url = [data stringForKey:@"url"];
            !then ?: then(url);
        }
    } failure:^(id error) {
        PROGRESS_HUD_DISMISS
        ALTER_HTTP_ERROR_MESSAGE(error)
        FYLog(NSLocalizedString(@"获取三方游戏登录地址出错 => \n%@", nil), error);
    }];
}


@end

