//
//  NetRequestManager+Helper.h
//  ProjectCSHB
//
//  Created by fangyuan on 2020/5/18.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "NetRequestManager.h"

NS_ASSUME_NONNULL_BEGIN

#define NET_URL_APPENDING(URL)  [NetRequestManager createRequestWithUrlString:URL]

@interface NetRequestManager (Helper)

#pragma mark - 公共方法
+ (NSString *)getRequestUrl:(Act)actType;
+ (NSString *)createRequestWithUrlString:(NSString *)urlString;
+ (NSString *)createRequestWithBaseUrlString:(NSString *)baseUrlString UrlString:(NSString *)urlString;
- (void)requestWithAct:(Act)actInfo parameters:(NSDictionary *)params success:(CallbackBlock)success failure:(CallbackBlock)failure;
- (void)requestWithAct:(Act)actInfo requestType:(RequestType)requestType parameters:(NSDictionary *)params success:(CallbackBlock)success failure:(CallbackBlock)failure;
- (RequestInfo *)createRequestInfoWithAct:(Act)act;


#pragma mark - 请求接口

#pragma mark 获取游戏大厅分类
- (void)requestAllGamesListWithSuccess:(CallbackBlock)success failure:(CallbackBlock)failure;

#pragma mark 获取充值通道列表
- (void)requestRechargePayModeChannel:(NSString *)type success:(CallbackBlock)success failure:(CallbackBlock)failure;

#pragma mark 获取更新用户信息
- (void)requestUpdateUserInfoWithSuccess:(CallbackBlock)success failure:(CallbackBlock)failure;

#pragma mark 获取验证游戏状态
- (void)requestGamesCheckStatusWithParentId:(NSString *)parentId success:(CallbackBlock)success failure:(CallbackBlock)failure;

#pragma mark 进入自建群通知提醒
- (void)requestJoinChatGroupSelfNoticeWithGroupId:(NSString *)groupId success:(CallbackBlock)success failure:(CallbackBlock)failure;

#pragma mark 请求加入群组验证（官方）
- (void)requestChatGroupOfficeVerifyJoinWithGroupId:(NSString *)groupId success:(CallbackBlock)success failure:(CallbackBlock)failure;

#pragma mark 请求加入群组（官方）
- (void)requestChatGroupOfficeYesTryJoinWithGroupId:(NSString *)groupId password:(NSString*)password success:(CallbackBlock)success failure:(CallbackBlock)failure;

#pragma mark 请求退出群组（官方）
- (void)requestChatGroupOfficeYesTryQuitWithGroupId:(NSString *)groupId success:(CallbackBlock)success failure:(CallbackBlock)failure;

#pragma mark 获取验证用户充值状态
- (void)requestGamesAllRechargeCheckUserStatusVerify:(CallbackBlock)success failure:(CallbackBlock)failure;

#pragma mark 提交用户充值订单
- (void)requestUserOfficialRechargeOrderWithPayModeId:(NSNumber *)uuid money:(NSString *)money remark:(NSString *)remark success:(CallbackBlock)success failure:(CallbackBlock)failure;

#pragma mark 代理开户注册
- (void)requestAgentRegisterUserId:(NSString *)userId userName:(NSString *)userName passwrod:(NSString *)password success:(CallbackBlock)success failure:(CallbackBlock)failure;

#pragma mark 获取通讯录好友（客服+我邀请的好友+邀请我的好友）
- (void)requestContactFriednsDataSuccess:(CallbackBlock)success failure:(CallbackBlock)failure;

#pragma mark 获取通讯录群组（加入的群组）
- (void)requestJoinGroupDataWithOfficeFlag:(BOOL)officeFlag success:(CallbackBlock)success failure:(CallbackBlock)failure;

#pragma mark 获取账单明细查询条件数据
- (void)requestBillingTypeQueryConditionDataSuccess:(CallbackBlock)success failure:(CallbackBlock)failure;

#pragma mark 获取账单明细数据
- (void)requestBillingRecordQuery:(NSDictionary *)param success:(CallbackBlock)success failure:(CallbackBlock)failure;

#pragma mark 获取账单收入盈亏
- (void)requestBillingProfitLossMoney:(NSDictionary *)param success:(CallbackBlock)success failure:(CallbackBlock)failure;

#pragma mark 获取代理报表菜单
- (void)requestAgentReportMenuDataSuccess:(CallbackBlock)success failure:(CallbackBlock)failure;

#pragma mark 包包牛抢包详情
- (void)requesGamesBagBagCowWithId:(NSString *)uuid success:(CallbackBlock)success failure:(CallbackBlock)failure;

#pragma mark 包包彩抢包详情
- (void)requesGamesBagBagLotteryWithId:(NSString *)uuid success:(CallbackBlock)success failure:(CallbackBlock)failure;

#pragma mark 包包彩抢包操作
- (void)requesGamesBagBagLotteryGrapWithGroupId:(NSString *)groupId gameNumber:(NSString *)gameNumber redId:(NSString *)redId success:(CallbackBlock)success failure:(CallbackBlock)failure;

#pragma mark 自己游戏登录（电子游戏）
-(void)requesGamesSelfDianZiLoginUrlWithId:(NSString *)uuid success:(CallbackBlock)success failure:(CallbackBlock)failure;

#pragma mark 三方游戏登录（1：王者棋牌，2：幸运棋牌，3：QG棋牌，4：开元棋牌，5：双赢彩票，6：IM电竞，7：IM体育，8：AG真人，9：AG电子，10：AG捕鱼，11：KG电子）
- (void)requestGamesThirdPartyLoginWithParameters:(NSDictionary *)parameters gameType:(NSInteger)gameType linkUrl:(NSString *)linkUrl success:(CallbackBlock)success failure:(CallbackBlock)failure;

#pragma mark 三方游戏退出（1：王者棋牌，2：幸运棋牌，3：QG棋牌，4：开元棋牌，5：双赢彩票，6：IM电竞，7：IM体育，8：AG真人，9：AG电子，10：AG捕鱼，11：KG电子）
-(void)requestGamesThirdPartyLogoutWithParameters:(NSDictionary *)parameters gameType:(NSInteger)gameType success:(CallbackBlock)success failure:(CallbackBlock)failure;

#pragma mark 三方游戏余额核实（1：王者棋牌，2：幸运棋牌，3：QG棋牌，4：开元棋牌，5：双赢彩票，6：IM电竞，7：IM体育，8：AG真人，9：AG电子，10：AG捕鱼，11：KG电子）
- (void)requestGamesThirdPartyBalanceAffirm:(NSDictionary *)param success:(CallbackBlock)success failure:(CallbackBlock)failure;


@end


NS_ASSUME_NONNULL_END

