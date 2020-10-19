//
//  NetRequestManager+Helper.m
//  ProjectCSHB
//
//  Created by fangyuan on 2020/5/18.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "NetRequestManager+Helper.h"
#import "NetResponseManager.h"

@implementation NetRequestManager (Helper)

#pragma mark -

+ (NSString *)getRequestUrl:(Act)actType
{
    RequestInfo *info = [NET_REQUEST_MANAGER createRequestInfoWithAct:actType];
    return info.url;
}

+ (NSString *)createRequestWithUrlString:(NSString *)urlString
{
    return [[self class] createRequestWithBaseUrlString:[AppModel shareInstance].serverUrl UrlString:urlString];
}

+ (NSString *)createRequestWithBaseUrlString:(NSString *)baseUrlString UrlString:(NSString *)urlString
{
    if ([baseUrlString hasSuffix:@"/"]) {
        baseUrlString = [baseUrlString substringToIndex:baseUrlString.length-1];
    }
    if ([urlString hasPrefix:@"/"]) {
        NSRange range = [urlString rangeOfString:@"/"];
        urlString = [urlString substringFromIndex:range.location + range.length];
    }
    return [NSString stringWithFormat:@"%@/%@", [CFCSysUtil stringByTrimmingWhitespaceAndNewline:baseUrlString],
            [CFCSysUtil stringByTrimmingWhitespaceAndNewline:urlString]];
}

- (void)requestWithAct:(Act)actInfo parameters:(NSDictionary *)params success:(CallbackBlock)success failure:(CallbackBlock)failure
{
    [self requestWithAct:actInfo requestType:RequestType_post parameters:params success:success failure:failure];
}

- (void)requestWithAct:(Act)actInfo requestType:(RequestType)requestType parameters:(NSDictionary *)params success:(CallbackBlock)success failure:(CallbackBlock)failure
{
    NSMutableDictionary *parameters = [self createRrequestParameters];
    [parameters addEntriesFromDictionary:params];
    //
    RequestInfo *requestInfo = [self createRequestInfoWithAct:actInfo];
    [requestInfo setRequestType:requestType];
    //
    [self requestWithData:parameters requestInfo:requestInfo success:success fail:failure];
}


#pragma mark - 请求路径配置

- (RequestInfo *)createRequestInfoWithAct:(Act)actType
{
    NSString *urlString = nil;
    switch (actType) {
        case ActRequestSearchUserID:
            urlString = @"social/skUserTransferRecord/queryUser";
            break;
        case ActRequestTransferMoneyNearRecord:
            urlString = @"social/skUserTransferRecord/transferList";
            break;
        case ActRequesTransferMoneyToUser:
            urlString = @"social/skUserTransferRecord/userTransfer";
            break;
        case ActRequestScannerQRCodeGetUserInfo:
            urlString = @"social/promotionShare/getDomainCode";
            break;
        case ActRequestGamesAllClassList:
            urlString = @"social/skChatManage/hallNewList";
            break;
        case ActRequestGamesQPChildContentList:
            urlString = @"social/skChatManage/queryGameChild";
            break;
        case ActRequestGamesDianZiLoginWebUrl:
            urlString = @"social/skChatManage/checkGameUrl";
            break;
        case ActRequestChatGroupSelfJoin:
            urlString = @"social/skChatGroup/selfJoinNotice";
            break;
        case ActRequestAgentRegister:
            urlString = @"social/nauth/proxyReg";
            break;
        case ActRequestRechargePayChannel:
            urlString = @"pay/recharge/getChanelType";
            break;
        case ActRequestRechargePayModeMethods:
            urlString = @"pay/recharge/getChanelDetailNew";
            break;
        case ActRequestBillingTypeQueryConfition:
            urlString = @"social/bill/billType/allList";
            break;
        case ActRequestBillingRecordQuery:
            urlString = @"social/bill/accountflow/pageNew";
            break;
        case ActRequestBillingProfitLossMoney:
            urlString = @"social/bill/profitLossMoney";
            break;
        case ActRequestGameReportRecordProfitLoss:
            urlString = @"social/redGameRecords/page";
            break;
        case ActRequestContactsInviteFriends:
            urlString = @"social/skUserInviteFriends/selectInviteRecord";
            break;
        case ActRequestMyCenterPersonalStatistics: // 个人汇总
            urlString = @"statistics/personal/overview";
            break;
        case ActRequestAgentCenterProxyReferrals: // 我的下线
            urlString = @"statistics/user/branch";
            break;
        case ActRequestAgentCenterProxyGameReportMenus: // 代理报表 - 菜单
            urlString = @"statistics/v2/global/types";
            break;
        case ActRequestAgentCenterProxyGameReportRecord: // 代理报表 - 数据
            urlString = @"statistics/proxy/report";
            break;
        case ActRequesCenterUserVIPRule: // VIP规则
            urlString = @"social/userVip/vip";
            break;
        case ActRequesAgentBackWaterRuleInfo:
            urlString = @"social/commissonSetting/commonPage";
            break;
            
#pragma mark 请求路径 - 包包牛
            
        case ActRequestBagBagCowBett: // 包包牛 - 投注接口
            urlString = @"baobaoniu/baobaoniu/bett";
            break;
        case ActRequestBagBagCowRecords: // 包包牛 - 游戏记录
            urlString = @"baobaoniu/baobaoniu/gamerecord";
            break;
        case ActRequestBagBagCowAppConfig: // 包包牛 - 配置返回APP
            urlString = @"baobaoniu/baobaoniu/getAppConfig";
            break;
        case ActRequestBagBagCowGetBBNInfo: // 包包牛 - 包包牛群状态
            urlString = @"baobaoniu/baobaoniu/getBBNInfo";
            break;
        case ActRequestBagBagCowGrapDetail: // 包包牛 - 抢包详情
            urlString = @"baobaoniu/baobaoniu/grapDetail";
            break;
        case ActRequestBagBagCowTrendsChart: // 包包牛 - 基本走势
            urlString = @"baobaoniu/baobaoniu/chart";
            break;
        case ActRequestBagBagCowHistoryRecord: // 包包牛 - 历史记录
            urlString = @"baobaoniu/baobaoniu/record";
            break;
        case ActRequestBagBagCowBettDetail: // 包包牛 - 投注详情
            urlString = @"baobaoniu/baobaoniu/userBetDetail";
            break;

#pragma mark 请求路径 - 棋牌游戏

        case ActRequestGameNewCheckStatus: // 状态验证
            urlString = @"social/skChatManage/newCheckStatus";
            break;
        case ActRequestThirdPartyGamesBalanceAffirm: // 余额核实
            urlString = @"chessgame/common/balancePull";
            break;
            
        case ActRequestThirdPartyBoardGamesLogin: // 1：王者棋牌
            urlString = @"chessgame/king/gameLogin";
            break;
        case ActRequestThirdPartyBoardGamesQuit:
            urlString = @"chessgame/king/quit";
            break;
            
        case ActRequestThirdPartyLuckyGamesLogin: // 2：幸运棋牌
            urlString = @"chessgame/lucky/gameLogin";
            break;
        case ActRequestThirdPartyLuckyGamesQuit:
            urlString = @"chessgame/lucky/quit";
            break;
            
        case ActRequestThirdPartyQGGamesLogin: // 3：QG棋牌
            urlString = @"openapi/laya/api/login";
            break;
        case ActRequestThirdPartyQGGamesQuit:
            urlString = @"openapi/laya/api/balanceExchange/out";
            break;
            
        case ActRequestThirdPartyKaiYuanGamesLogin: // 4：开元棋牌
            urlString = @"chessgame/ky/gameLogin";
            break;
        case ActRequestThirdPartyKaiYuanGamesQuit:
            urlString = @"chessgame/ky/gameQuit";
            break;
            
        case ActRequestThirdPartyShuangYingGamesLogin: // 5：双赢彩票
            urlString = @"chessgame/imone/gameLogin";
            break;
        case ActRequestThirdPartyShuangYingGamesQuit:
            urlString = @"chessgame/imone/gameQuit";
            break;
            
        case ActRequestThirdPartyIMElectronicSportsGamesLogin: // 6：IM电竞
            urlString = @"chessgame/imone/gameLogin";
            break;
        case ActRequestThirdPartyIMElectronicSportsGamesQuit:
            urlString = @"chessgame/imone/gameQuit";
            break;

        case ActRequestThirdPartyIMSportsGamesLogin: // 7：IM体育
            urlString = @"chessgame/imone/gameLogin";
            break;
        case ActRequestThirdPartyIMSportsGamesQuit:
            urlString = @"chessgame/imone/gameQuit";
            break;
            
        case ActRequestThirdPartyAGMortalPeopleGamesLogin: // 8：AG真人
            urlString = @"chessgame/ag/gameLogin";
            break;
        case ActRequestThirdPartyAGMortalPeopleGamesQuit:
            urlString = @"chessgame/ag/gameQuit";
            break;
            
        case ActRequestThirdPartyAGElectronicGamesLogin: // 9：AG电子
            urlString = @"chessgame/ag/gameLogin";
            break;
        case ActRequestThirdPartyAGElectronicGamesQuit:
            urlString = @"chessgame/ag/gameQuit";
            break;
            
        case ActRequestThirdPartyAGCatchFishGamesLogin: // 10：AG捕鱼
            urlString = @"chessgame/ag/gameLogin";
            break;
        case ActRequestThirdPartyAGCatchFishGamesQuit:
            urlString = @"chessgame/ag/gameQuit";
            break;
            
        case ActRequestThirdPartyKGElectronicGamesLogin: // 11：KG电子
            urlString = @"chessgame/king/gameLogin";
            break;
        case ActRequestThirdPartyKGElectronicGamesQuit:
            urlString = @"chessgame/king/quit";
            break;
            
        case ActRequestThirdPartyAGSportsGamesLogin: // 12：AG体育
            urlString = @"chessgame/ag/gameLogin";
            break;
        case ActRequestThirdPartyAGSportsGamesQuit:
            urlString = @"chessgame/ag/gameQuit";
            break;
            
        case ActRequestThirdPartyIMElectronicCityGamesLogin: // 13：IM电玩城
            urlString = @"chessgame/imone/gameLogin";
            break;
        case ActRequestThirdPartyIMElectronicCityGamesQuit:
            urlString = @"chessgame/imone/gameQuit";
            break;
            
        default:
            break;
    }
    
    if ([CFCSysUtil validateStringEmpty:urlString]) {
        return [self createRequestInfoAct:actType];
    }
    RequestInfo *requestInfo = [[RequestInfo alloc] initWithType:RequestType_post];
    requestInfo.act = actType;
    requestInfo.url = NET_URL_APPENDING(urlString);
    return requestInfo;
}


#pragma mark -

#pragma mark 获取游戏大厅分类
- (void)requestAllGamesListWithSuccess:(CallbackBlock)success failure:(CallbackBlock)failure
{
    RequestInfo *requestInfo = [self createRequestInfoWithAct:ActRequestGamesAllClassList];
    [self requestWithData:nil requestInfo:requestInfo success:success fail:failure];
}

#pragma mark 获取充值通道列表
- (void)requestRechargePayModeChannel:(NSString *)type success:(CallbackBlock)success failure:(CallbackBlock)failure
{
    RequestInfo *requestInfo = [self createRequestInfoWithAct:ActRequestRechargePayChannel];
    NSMutableDictionary *parameters = [self createRrequestParameters];
    [self requestWithData:parameters requestInfo:requestInfo success:success fail:failure];
}

#pragma mark 获取更新用户信息
- (void)requestUpdateUserInfoWithSuccess:(CallbackBlock)success failure:(CallbackBlock)failure
{
    // 请求ActRequestUserInfo后，会在 NetResponseManager 中自动更新 AppModel 中 UserInfo
    RequestInfo *requestInfo = [self createRequestInfoWithAct:ActRequestUserInfo];
    [self requestWithData:nil requestInfo:requestInfo success:success fail:failure];
}

#pragma mark 获取验证游戏状态
- (void)requestGamesCheckStatusWithParentId:(NSString *)parentId success:(CallbackBlock)success failure:(CallbackBlock)failure
{
    RequestInfo *requestInfo = [self createRequestInfoWithAct:ActRequestGameNewCheckStatus];
    NSMutableDictionary *parameters = [self createRrequestParameters];
    [parameters setObject:parentId forKey:@"id"];
    [self requestWithData:parameters requestInfo:requestInfo success:success fail:failure];
}

#pragma mark 进入自建群通知提醒
- (void)requestJoinChatGroupSelfNoticeWithGroupId:(NSString *)groupId success:(CallbackBlock)success failure:(CallbackBlock)failure
{
    RequestInfo *requestInfo = [self createRequestInfoWithAct:ActRequestChatGroupSelfJoin];
    NSMutableDictionary *parameters = [self createRrequestParameters];
    [parameters setObject:groupId forKey:@"id"];
    [self requestWithData:parameters requestInfo:requestInfo success:success fail:failure];
}

#pragma mark 请求加入群组验证（官方）
- (void)requestChatGroupOfficeVerifyJoinWithGroupId:(NSString *)groupId success:(CallbackBlock)success failure:(CallbackBlock)failure
{
    RequestInfo *requestInfo = [self createRequestInfoWithAct:ActRequestOfficeGroupCheckJoinNew];
    NSMutableDictionary *parameters = [self createRrequestParameters];
    [parameters setObject:groupId forKey:@"id"];
    [self requestWithData:parameters requestInfo:requestInfo success:success fail:failure];
}

#pragma mark 请求加入群组（官方）
- (void)requestChatGroupOfficeYesTryJoinWithGroupId:(NSString *)groupId password:(NSString*)password success:(CallbackBlock)success failure:(CallbackBlock)failure
{
    [self getChatGroupJoinWithGroupId:groupId pwd:password success:success fail:failure];
}

#pragma mark 请求退出群组（官方）
- (void)requestChatGroupOfficeYesTryQuitWithGroupId:(NSString *)groupId success:(CallbackBlock)success failure:(CallbackBlock)failure
{
    [self getChatGroupQuitWithGroupId:groupId success:success fail:failure];
}

#pragma mark 获取验证用户充值状态
- (void)requestGamesAllRechargeCheckUserStatusVerify:(CallbackBlock)success failure:(CallbackBlock)failure
{
    RequestInfo *requestInfo = [self createRequestInfoWithAct:ActOrderRechargeCheckUser];
    [self requestWithData:nil requestInfo:requestInfo success:success fail:failure];
}

#pragma mark 提交用户充值订单
- (void)requestUserOfficialRechargeOrderWithPayModeId:(NSNumber *)uuid money:(NSString *)money remark:(NSString *)remark success:(CallbackBlock)success failure:(CallbackBlock)failure
{
    RequestInfo *requestInfo = [self createRequestInfoWithAct:ActOrderRecharge];
    NSMutableDictionary *parameters = [self createRrequestParameters];
    [parameters setObject:uuid forKey:@"id"];
    [parameters setObject:money forKey:@"money"];
    [parameters setObject:remark forKey:@"remark"];
    [self requestWithData:parameters requestInfo:requestInfo success:success fail:failure];
}

#pragma mark 代理开户注册
- (void)requestAgentRegisterUserId:(NSString *)userId userName:(NSString *)userName passwrod:(NSString *)password success:(CallbackBlock)success failure:(CallbackBlock)failure
{
    RequestInfo *requestInfo = [self createRequestInfoWithAct:ActRequestAgentRegister];
    NSMutableDictionary *parameters = [self createRrequestParameters];
    [parameters setObject:userId forKey:@"userId"];
    [parameters setObject:userName forKey:@"regName"];
    [parameters setObject:password forKey:@"password"];
    [self requestWithData:parameters requestInfo:requestInfo success:success fail:failure];
}

#pragma mark 获取通讯录好友（客服+我邀请的好友+邀请我的好友）
- (void)requestContactFriednsDataSuccess:(CallbackBlock)success failure:(CallbackBlock)failure
{
    RequestInfo *requestInfo = [self createRequestInfoWithAct:OnlineCustomerService];
    NSMutableDictionary *parameters = [self createRrequestParameters];
    [self requestWithData:parameters requestInfo:requestInfo success:success fail:failure];
}

#pragma mark 获取通讯录群组（加入的群组）
- (void)requestJoinGroupDataWithOfficeFlag:(BOOL)officeFlag success:(CallbackBlock)success failure:(CallbackBlock)failure
{
    [self requestSelfJionGrouIsOfficeFlag:officeFlag Success:success fail:failure];
}

#pragma mark 获取账单明细查询条件数据
- (void)requestBillingTypeQueryConditionDataSuccess:(CallbackBlock)success failure:(CallbackBlock)failure
{
    RequestInfo *requestInfo = [self createRequestInfoWithAct:ActRequestBillingTypeQueryConfition];
    NSMutableDictionary *parameters = [self createRrequestParameters];
    [self requestWithData:parameters requestInfo:requestInfo success:success fail:failure];
}

#pragma mark 获取账单明细数据
- (void)requestBillingRecordQuery:(NSDictionary *)param success:(CallbackBlock)success failure:(CallbackBlock)failure
{
    /*
     {
         "current":1,
         "size":10,
         "queryParam":{
             "infoIdList": [19,54],   // 筛选类idAuto，如果刷选类不选就传所有筛选类idAuto
             "time":"2020-06",        // 字段年月，如果time不为空，其他两个置为null；否则 time 置为null
             "startTime":"",
             "endTime":"",
             "minMoeny":"",           // 第一个金额搜索字段
             "maxMoeny":""            // 第二个金额搜索字段
         }
     }
     */
    RequestInfo *requestInfo = [self createRequestInfoWithAct:ActRequestBillingRecordQuery];
    NSMutableDictionary *parameters = [self createRrequestParameters];
    [parameters setObject:@"10" forKey:@"size"];
    [parameters setObject:@"1" forKey:@"current"];
    [parameters setObject:param forKey:@"queryParam"];
    [self requestWithData:parameters requestInfo:requestInfo success:success fail:failure];
}

#pragma mark 获取账单收入盈亏
- (void)requestBillingProfitLossMoney:(NSDictionary *)param success:(CallbackBlock)success failure:(CallbackBlock)failure
{
    /*
     {
         "infoIdList": [19,54], // 筛选类idAuto，如果刷选类不选就传所有筛选类idAuto
         "time":"2020-06",  // 字段年月，如果time不为空，其他两个置为null；否则 time 置为null
         "startTime":"",
         "endTime":"",
         "minMoeny":"",  // 第一个金额搜索字段
         "maxMoeny":"" // 第二个金额搜索字段
     }
     */
    RequestInfo *requestInfo = [self createRequestInfoWithAct:ActRequestBillingProfitLossMoney];
    NSMutableDictionary *parameters = [self createRrequestParameters];
    [parameters addEntriesFromDictionary:param];
    [self requestWithData:parameters requestInfo:requestInfo success:success fail:failure];
}

#pragma mark 获取代理报表菜单
- (void)requestAgentReportMenuDataSuccess:(CallbackBlock)success failure:(CallbackBlock)failure
{
    RequestInfo *requestInfo = [self createRequestInfoWithAct:ActRequestAgentCenterProxyGameReportMenus];
    NSMutableDictionary *parameters = [self createRrequestParameters];
    [self requestWithData:parameters requestInfo:requestInfo success:success fail:failure];
}

#pragma mark 包包牛抢包详情
- (void)requesGamesBagBagCowWithId:(NSString *)uuid success:(CallbackBlock)success failure:(CallbackBlock)failure;
{
    RequestInfo *requestInfo = [self createRequestInfoWithAct:ActRequestBagBagCowGrapDetail];
    NSMutableDictionary *parameters = [self createRrequestParameters];
    [parameters setObject:uuid forKey:@"packetId"];
    [self requestWithData:parameters requestInfo:requestInfo success:success fail:failure];
}

#pragma mark 包包彩抢包详情
- (void)requesGamesBagBagLotteryWithId:(NSString *)uuid success:(CallbackBlock)success failure:(CallbackBlock)failure;
{
    RequestInfo *requestInfo = [self createRequestInfoWithAct:ActRequestBagBagLotteryGrapDetail];
    NSMutableDictionary *parameters = [self createRrequestParameters];
    [parameters setObject:uuid forKey:@"packetId"];
    [self requestWithData:parameters requestInfo:requestInfo success:success fail:failure];
}

#pragma mark 包包彩抢包操作
- (void)requesGamesBagBagLotteryGrapWithGroupId:(NSString *)groupId gameNumber:(NSString *)gameNumber redId:(NSString *)redId success:(CallbackBlock)success failure:(CallbackBlock)failure
{
    RequestInfo *requestInfo = [self createRequestInfoWithAct:ActRequestBagBagLotteryGrap];
    NSMutableDictionary *parameters = [self createRrequestParameters];
    [parameters setObject:gameNumber forKey:@"gameNumber"];
    [parameters setObject:groupId forKey:@"groupId"];
    [parameters setObject:redId forKey:@"redId"];
    [parameters setObject:APPINFORMATION.userInfo.userId forKey:@"userId"];
    [self requestWithData:parameters requestInfo:requestInfo success:success fail:failure];
}

#pragma mark 自己游戏登录（电子游戏）
-(void)requesGamesSelfDianZiLoginUrlWithId:(NSString *)uuid success:(CallbackBlock)success failure:(CallbackBlock)failure
{
    RequestInfo *requestInfo = [self createRequestInfoWithAct:ActRequestGamesDianZiLoginWebUrl];
    NSMutableDictionary *parameters = [self createRrequestParameters];
    [parameters setObject:uuid forKey:@"id"];
    [self requestWithData:parameters requestInfo:requestInfo success:success fail:failure];
}

#pragma mark 三方游戏登录（1：王者棋牌，2：幸运棋牌，3：QG棋牌，4：开元棋牌，5：双赢彩票，6：IM电竞，7：IM体育，8：AG真人，9：AG电子，10：AG捕鱼，11：KG电子）
- (void)requestGamesThirdPartyLoginWithParameters:(NSDictionary *)parameters gameType:(NSInteger)gameType linkUrl:(NSString *)linkUrl success:(CallbackBlock)success failure:(CallbackBlock)failure
{
    RequestInfo *requestInfo = nil;
    if (FYWebGameWangZeQiPaiType == gameType) {
        // 1：王者棋牌
        if (!VALIDATE_STRING_EMPTY(linkUrl)) {
            requestInfo = [[RequestInfo alloc] initWithType:RequestType_post];
            requestInfo.url = NET_URL_APPENDING(linkUrl);
        } else {
            requestInfo = [self createRequestInfoWithAct:ActRequestThirdPartyBoardGamesLogin];
        }
    } else if (FYWebGameXingYunQiPaiType == gameType) {
        // 2：幸运棋牌
        if (!VALIDATE_STRING_EMPTY(linkUrl)) {
            requestInfo = [[RequestInfo alloc] initWithType:RequestType_post];
            requestInfo.url = NET_URL_APPENDING(linkUrl);
        } else {
            requestInfo = [self createRequestInfoWithAct:ActRequestThirdPartyLuckyGamesLogin];
        }
    } else if (FYWebGameQGQiPaiType == gameType) {
        // 3：QG棋牌
        if (!VALIDATE_STRING_EMPTY(linkUrl)) {
            requestInfo = [[RequestInfo alloc] initWithType:RequestType_post];
            requestInfo.url = NET_URL_APPENDING(linkUrl);
        } else {
            requestInfo = [self createRequestInfoWithAct:ActRequestThirdPartyQGGamesLogin];
        }
    } else if (FYWebGameKaiYuanQiPaiType == gameType) {
        // 4：开元棋牌
        if (!VALIDATE_STRING_EMPTY(linkUrl)) {
            requestInfo = [[RequestInfo alloc] initWithType:RequestType_post];
            requestInfo.url = NET_URL_APPENDING(linkUrl);
        } else {
            requestInfo = [self createRequestInfoWithAct:ActRequestThirdPartyKaiYuanGamesLogin];
        }
    } else if (FYWebGameShuangYingCaiPiaoType == gameType) {
        // 5：双赢彩票
        if (!VALIDATE_STRING_EMPTY(linkUrl)) {
            requestInfo = [[RequestInfo alloc] initWithType:RequestType_post];
            requestInfo.url = NET_URL_APPENDING(linkUrl);
        } else {
            requestInfo = [self createRequestInfoWithAct:ActRequestThirdPartyShuangYingGamesLogin];
        }
    } else if (FYWebGameIMElectronicSportsType == gameType) {
        // 6：IM电竞
        if (!VALIDATE_STRING_EMPTY(linkUrl)) {
            requestInfo = [[RequestInfo alloc] initWithType:RequestType_post];
            requestInfo.url = NET_URL_APPENDING(linkUrl);
        } else {
            requestInfo = [self createRequestInfoWithAct:ActRequestThirdPartyIMElectronicSportsGamesLogin];
        }
    } else if (FYWebGameIMSportsType == gameType) {
        // 7：IM体育
        if (!VALIDATE_STRING_EMPTY(linkUrl)) {
            requestInfo = [[RequestInfo alloc] initWithType:RequestType_post];
            requestInfo.url = NET_URL_APPENDING(linkUrl);
        } else {
            requestInfo = [self createRequestInfoWithAct:ActRequestThirdPartyIMSportsGamesLogin];
        }
    } else if (FYWebGameAGMortalPeopleType == gameType) {
        // 8：AG真人
        if (!VALIDATE_STRING_EMPTY(linkUrl)) {
            requestInfo = [[RequestInfo alloc] initWithType:RequestType_post];
            requestInfo.url = NET_URL_APPENDING(linkUrl);
        } else {
            requestInfo = [self createRequestInfoWithAct:ActRequestThirdPartyAGMortalPeopleGamesLogin];
        }
    } else if (FYWebGameAGElectronicType == gameType) {
        // 9：AG电子
        if (!VALIDATE_STRING_EMPTY(linkUrl)) {
            requestInfo = [[RequestInfo alloc] initWithType:RequestType_post];
            requestInfo.url = NET_URL_APPENDING(linkUrl);
        } else {
            requestInfo = [self createRequestInfoWithAct:ActRequestThirdPartyAGElectronicGamesLogin];
        }
    } else if (FYWebGameAGCatchFishType == gameType) {
        // 10：AG捕鱼
        if (!VALIDATE_STRING_EMPTY(linkUrl)) {
            requestInfo = [[RequestInfo alloc] initWithType:RequestType_post];
            requestInfo.url = NET_URL_APPENDING(linkUrl);
        } else {
            requestInfo = [self createRequestInfoWithAct:ActRequestThirdPartyAGCatchFishGamesLogin];
        }
    } else if (FYWebGameKGElectronicType == gameType) {
        // 11：KG电子
        if (!VALIDATE_STRING_EMPTY(linkUrl)) {
            requestInfo = [[RequestInfo alloc] initWithType:RequestType_post];
            requestInfo.url = NET_URL_APPENDING(linkUrl);
        } else {
            requestInfo = [self createRequestInfoWithAct:ActRequestThirdPartyKGElectronicGamesLogin];
        }
    } else if (FYWebGameAGSportsType == gameType) {
        // 12：AG体育
        if (!VALIDATE_STRING_EMPTY(linkUrl)) {
            requestInfo = [[RequestInfo alloc] initWithType:RequestType_post];
            requestInfo.url = NET_URL_APPENDING(linkUrl);
        } else {
            requestInfo = [self createRequestInfoWithAct:ActRequestThirdPartyAGSportsGamesLogin];
        }
    } else if (FYWebGameIMElectronicCityType == gameType) {
        // 13：IM电玩城
        if (!VALIDATE_STRING_EMPTY(linkUrl)) {
            requestInfo = [[RequestInfo alloc] initWithType:RequestType_post];
            requestInfo.url = NET_URL_APPENDING(linkUrl);
        } else {
            requestInfo = [self createRequestInfoWithAct:ActRequestThirdPartyIMElectronicCityGamesLogin];
        }
    } else {
        // 默认
        if (!VALIDATE_STRING_EMPTY(linkUrl)) {
            requestInfo = [[RequestInfo alloc] initWithType:RequestType_post];
            requestInfo.url = NET_URL_APPENDING(linkUrl);
        } else {
            requestInfo = [self createRequestInfoWithAct:ActAll];
        }
    }
    [self requestWithData:parameters requestInfo:requestInfo success:success fail:failure];
}

#pragma mark 三方游戏退出（1：王者棋牌，2：幸运棋牌，3：QG棋牌，4：开元棋牌，5：双赢彩票，6：IM电竞，7：IM体育，8：AG真人，9：AG电子，10：AG捕鱼，11：KG电子）
-(void)requestGamesThirdPartyLogoutWithParameters:(NSDictionary *)parameters gameType:(NSInteger)gameType success:(CallbackBlock)success failure:(CallbackBlock)failure
{
    RequestInfo *requestInfo = nil;
    if (FYWebGameWangZeQiPaiType == gameType) {
        // 1：王者棋牌
        requestInfo = [self createRequestInfoWithAct:ActRequestThirdPartyBoardGamesQuit];
    } else if (FYWebGameXingYunQiPaiType == gameType) {
        // 2：幸运棋牌
        requestInfo = [self createRequestInfoWithAct:ActRequestThirdPartyLuckyGamesQuit];
    } else if (FYWebGameQGQiPaiType == gameType) {
        // 3：QG棋牌
        requestInfo = [self createRequestInfoWithAct:ActRequestThirdPartyQGGamesQuit];
    } else if (FYWebGameKaiYuanQiPaiType == gameType) {
        // 4：开元棋牌
        requestInfo = [self createRequestInfoWithAct:ActRequestThirdPartyKaiYuanGamesQuit];
    } else if (FYWebGameShuangYingCaiPiaoType == gameType) {
        // 5：双赢彩票
        requestInfo = [self createRequestInfoWithAct:ActRequestThirdPartyShuangYingGamesQuit];
    } else if (FYWebGameIMElectronicSportsType == gameType) {
        // 6：IM电竞
        requestInfo = [self createRequestInfoWithAct:ActRequestThirdPartyIMElectronicSportsGamesQuit];
    } else if (FYWebGameIMSportsType == gameType) {
        // 7：IM体育
        requestInfo = [self createRequestInfoWithAct:ActRequestThirdPartyIMSportsGamesQuit];
    } else if (FYWebGameAGMortalPeopleType == gameType) {
        // 8：AG真人
        requestInfo = [self createRequestInfoWithAct:ActRequestThirdPartyAGMortalPeopleGamesQuit];
    } else if (FYWebGameAGElectronicType == gameType) {
        // 9：AG电子
        requestInfo = [self createRequestInfoWithAct:ActRequestThirdPartyAGElectronicGamesQuit];
    } else if (FYWebGameAGCatchFishType == gameType) {
        // 10：AG捕鱼
        requestInfo = [self createRequestInfoWithAct:ActRequestThirdPartyAGCatchFishGamesQuit];
    } else if (FYWebGameKGElectronicType == gameType) {
        // 11：KG电子
        requestInfo = [self createRequestInfoWithAct:ActRequestThirdPartyKGElectronicGamesQuit];
    } else if (FYWebGameAGSportsType == gameType) {
        // 12：AG体育
        requestInfo = [self createRequestInfoWithAct:ActRequestThirdPartyAGSportsGamesQuit];
    } else if (FYWebGameIMElectronicCityType == gameType) {
        // 13：IM电玩城
        requestInfo = [self createRequestInfoWithAct:ActRequestThirdPartyIMElectronicCityGamesQuit];
    } else {
        // 默认
        requestInfo = [self createRequestInfoWithAct:ActAll];
    }
    [self requestWithData:parameters requestInfo:requestInfo success:success fail:failure];
}

#pragma mark 三方游戏余额核实（1：王者棋牌，2：幸运棋牌，3：QG棋牌，4：开元棋牌，5：双赢彩票，6：IM电竞，7：IM体育，8：AG真人，9：AG电子，10：AG捕鱼，11：KG电子）
- (void)requestGamesThirdPartyBalanceAffirm:(NSDictionary *)param success:(CallbackBlock)success failure:(CallbackBlock)failure
{
    RequestInfo *requestInfo = [self createRequestInfoWithAct:ActRequestThirdPartyGamesBalanceAffirm];
    NSMutableDictionary *parameters = [self createRrequestParameters];
    [parameters addEntriesFromDictionary:param];
    [self requestWithData:parameters requestInfo:requestInfo success:success fail:failure];
}


@end

