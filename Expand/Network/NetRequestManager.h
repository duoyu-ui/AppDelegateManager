//
//  NetRequestManager.h
//  XM_12580
//
//  Created by mac on 12-7-9.
//  Copyright (c) 2012年 Neptune. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Public.h"

typedef enum {
    RequestType_post,
    RequestType_get,
    RequestType_put,
    RequestType_delete,
} RequestType;

#define NET_REQUEST_KEY_DATA          @"data"
#define NET_REQUEST_KEY_MESS          @"msg"
#define NET_REQUEST_KEY_STATUS        @"code"
#define NET_REQUEST_KEY_MESS_ALTER    @"alterMsg"

#define NET_HEADER_LANG_KEY           @"Accept-Language"
#define NET_HEADER_LANG_ZHCN          @"zh-CN"
#define NET_HEADER_LANG_ENUS          @"en-US"

typedef enum {
    ActNil,
    ActRequestMsgBanner,
    ActRequestClickBanner,
    
    ActRequestUserInfo,//用户信息
    ActRequestUserInfoById,//用户信息
    ActModifyUserInfo,//修改个人信息
    ActModifyPassword,//修改密码
    ActResetPassword,//找回密码
    ActUpPayPasswd, //设置支付密码
    ActRequestVerifyCode,
    ActRegister,
    ActCheckRegister,
    ActRequestToken,
    ActCheckLogin,
    ActRequestCaptcha,
    ActRequestTokenBySMS,  // 短信验证码获取token
    ActRequestIMToken,
    ActRemoveToken,//删除token
    ActRequestCommonInfo,//APP基本数据
    ActMyPlayer,//我的下线
    ActCheckMyPlayers,//团队人数查询
    ActRequestAgentReportInfo,//个人代理报表
    ActRequestPromotionCourse,//推广教程
    ActRequestRechargeChannel,//推广教程
    ActOrderRechargeCheckUser,
    ActRequestAgentDatas,
    ActUploadImg,
    ActRequestBankList,
    ActRequestjoinGroupPage,//会话列表
    ActDraw,//提现
    ActRequestBillList,//账单列表
    ActRequestBillTypeList,//账单类型
    ActRequestSystemNotice,//通知列表
    ActRequestShareList,//分享列表
    ActAddShareCount,//增加分享页的访问量
    ActRequestRechargeList,//充值列表
    ActRequestReportForms,//代理中心报表
    ActRequestActivityList,//查询活动列表
    ActGetReward,//领取奖励
    ActGetFirstRewardInfo,//获取首充、二充数据
    ActToBeAgent,//申请成为代理
    ActGetLotteryList,//可抽奖列表
    ActGetLotterys,//查询转盘奖品
    ActLottery,//抽奖
    ActAddBankCard,//添加银行卡
    
    ActRequestMyBankList,//我添加的银行卡
    ActRequestWithdrawHistory,//提现历史记录
    ActRequestLastWithdrawInfo,//上次提现的信息
    
    ActRequestRechargeListAll,//所有支付通道
    ActOrderRecharge,//提交订单
    ActReOrderRecharge,//重新下单
    ActSubmitRechargeInfo,//提交用户充值信息（去支付）
    ActRequestShareUrl,//获取分享URL
    ActRequestGuideImageList,//获取新手引导图片列表
    
    ActRequestActivityList2,//活动奖励列表
    ActRequestQiaoBaoReward,//获取抢包奖励金额
    ActRequestFaBaoReward,//获取发包奖励金额
    ActRequestQiaoBaoList,//获取抢包活动阶段
    ActRequestJiujiJingList,//获取抢包活动阶段
    ActRequestFaBaoList,//获取发包活动阶段
    ActRequestListUserActivity,//个人中心,活动列表
    ActRequestListRecord,//个人中心,活动列表,分页查询活动记录
    ActRequestListRedBonusType,//获取所有红包游戏
    OnlineCustomerService, //在线客服
    ActJoinSelfGroupList, //我加入的群组
    ActRequestChatGroupJoin,//加入群组(官方)
    ActRequestChatGroupQuit,//退出群组
    ActRequestlistOfficialGroup,//获取所有红包子游戏
    
    ActRequestThirdPartyGamesBalanceAffirm, // 三方游戏余额核实（除了QG电子游戏外，其它游戏在进入前需要调用此接口核实余额）
    ActRequestThirdPartyBoardGamesLogin, // 1：王者棋牌 - 登录
    ActRequestThirdPartyBoardGamesQuit, // 1：王者棋牌 - 退出
    ActRequestThirdPartyLuckyGamesLogin, // 2：幸运棋牌 - 登录
    ActRequestThirdPartyLuckyGamesQuit, // 2：幸运棋牌 - 退出
    ActRequestThirdPartyQGGamesLogin, // 3：QG棋牌 - 登录
    ActRequestThirdPartyQGGamesQuit, // 3：QG棋牌 - 退出
    ActRequestThirdPartyKaiYuanGamesLogin, // 4：开元棋牌 - 登录
    ActRequestThirdPartyKaiYuanGamesQuit, // 4：开元棋牌 - 退出
    ActRequestThirdPartyShuangYingGamesLogin, // 5：双赢彩票 - 登录
    ActRequestThirdPartyShuangYingGamesQuit, // 5：双赢彩票 - 退出
    ActRequestThirdPartyIMElectronicSportsGamesLogin, // 6：IM电竞 - 登录
    ActRequestThirdPartyIMElectronicSportsGamesQuit, // 6：IM电竞 - 退出
    ActRequestThirdPartyIMSportsGamesLogin, // 7：IM体育 - 登录
    ActRequestThirdPartyIMSportsGamesQuit, // 7：IM体育 - 退出
    ActRequestThirdPartyAGMortalPeopleGamesLogin, // 8：AG真人 - 登录
    ActRequestThirdPartyAGMortalPeopleGamesQuit, // 8：AG真人 - 退出
    ActRequestThirdPartyAGElectronicGamesLogin, // 9：AG电子 - 登录
    ActRequestThirdPartyAGElectronicGamesQuit, // 9：AG电子 - 退出
    ActRequestThirdPartyAGCatchFishGamesLogin, // 10：AG捕鱼 - 登录
    ActRequestThirdPartyAGCatchFishGamesQuit, // 10：AG捕鱼 - 退出
    ActRequestThirdPartyKGElectronicGamesLogin, // 11：KG电子 - 登录
    ActRequestThirdPartyKGElectronicGamesQuit, // 11：KG电子 - 退出
    ActRequestThirdPartyAGSportsGamesLogin, // 12：AG体育 - 登录
    ActRequestThirdPartyAGSportsGamesQuit, // 12：AG体育 - 退出
    ActRequestThirdPartyIMElectronicCityGamesLogin, // 13：IM电玩城 - 登录
    ActRequestThirdPartyIMElectronicCityGamesQuit, // 13：IM电玩城 - 退出
    
#pragma mark - 接龙相关
    ActRequestSolitaireInfo,//群信息
    ActRequestSolitaireSend,//发包
    ActRequestSolitaireRecordPage,

#pragma mark - 包包牛相关
    ActRequestBagBagCowBett, // 包包牛 - 投注接口（版本V3.0）
    ActRequestBagBagCowRecords, // 包包牛 - 游戏记录（版本V3.0）
    ActRequestBagBagCowAppConfig, // 包包牛 - 配置返回APP（版本V3.0）
    ActRequestBagBagCowGetBBNInfo, // 包包牛 - 包包牛群状态（版本V3.0）
    ActRequestBagBagCowGrapDetail, // 包包牛 - 抢包详情（版本V3.0）
    ActRequestBagBagCowTrendsChart, // 包包牛 - 基本走势（版本V3.0）
    ActRequestBagBagCowBettDetail, // 包包牛 - 投注详情（版本V3.0）
    ActRequestBagBagCowHistoryRecord, // 包包牛 - 历史记录（版本V3.0）
    
#pragma mark - 包包彩相关
    ActRequestBagBagLotteryInfo, // 包包彩 - 群状态
    ActRequestBagBagLotteryBett, // 包包彩 - 投注
    ActRequestBagBagLotteryGameOdds, // 包包彩 - 游戏赔率
    ActRequestBagBagLotteryGameRecords, // 包包彩 - 游戏记录
    ActRequestBagBagLotteryGameRecordsDetail, // 包包彩 - 游戏记录详情
    ActRequestBagBagLotteryHistory, // 包包彩 - 近10天历史详情
    ActRequestBagBagLotteryGrap, // 包包彩 - 抢包接口
    ActRequestBagBagLotteryGrapDetail, // 包包彩 - 抢包详情
    ActRequestBagBagLotteryTrendsChart, // 包包彩 - 走势图

#pragma mark - 抢庄牛牛相关
    ActRequestRobNiuNiuInfo,
    ActRequestRobFinance,//抢庄牛牛获取用户余额
    ActRequestRobBett, //抢庄牛牛投注
    ActRequestRobBankeer,//抢庄接口
    ActRequestRobRedpacket,//抢庄牛牛发红包
    ActRequestRobContinueBanker, // 连续上庄接口
    ActRequestRobBettingRecord,//投注记录
    ActRequestRobGameDetails,//游戏记录
    ActRequestRobPeriodRecord,//期数记录
    ActRequestRobNiuNiuBet,//抢庄,投注,按钮数组
    ActRequestRobNiuNiuBetAmount,//庄牛牛 二八杠  龙虎斗投注预设金额
    
#pragma mark - 百人牛牛相关
    ActRequestBestNiuNiuInfo, // 百人牛牛 - 群状态
    ActRequestBestNiuNiuGameOdds, // 百人牛牛 -赔率
    ActRequestBestNiuNiuBett, // 百人牛牛 - 投注
    ActRequestBestNiuNiuHistory, // 百人牛牛 - 历史详情
    ActRequestBestNiuNiuGameRecords, // 百人牛牛 - 游戏记录
    ActRequestBestNiuNiuGameRecordsDetail, // 百人牛牛 - 游戏记录详情
    ActRequestBestNiuNiuGameTrendsChart, // 百人牛牛 - 走势图
    
#pragma mark - 极速扫雷
    ActRequestJsslInfo, // 极速扫雷 - 群状态
    ActRequestJsslGameOdds, // 极速扫雷 -赔率
    ActRequestJsslGameBett, // 极速扫雷 -投注
    ActRequestJsslGameHistory, // 极速扫雷 -历史记录
    ActRequestJsslGameRecords, // 极速扫雷 - 游戏记录
    ActRequestJsslGameRecordsDetail, // 极速扫雷 - 游戏记录详情
    ActRequestJsslGameTrendsChart, // 极速扫雷 - 走势图
    
#pragma mark - 余额宝相关
    ActRequestBalanceDetails,// 获取账户详情
    ActRequestEarningsReport,// 获取收益报表
    ActRequestMoneyDetail,//获取资金详情
    ActRequestIntoMoney,//转入
    ActRequestOutMoney,//转出
#pragma mark - IM相关
    ActRequestGroupList,//获取我加入的群组列表
    ActRequestGroupInfo,//根据群组id获取群组信息
    ActRequestAddGroup,//加入群
    ActRequestInviteToGroup,//邀请入群
    ActRequestMyGroup,//分页查询群邀请记录
    ActRequestOperateGroup,//拒绝或同意群邀请
    ActRequestQuitGroup,//退出群组
    ActRequestFindFriendById,
    ActRequestUpdateFriendNick,
#pragma mark - 通讯录
    ActRequestContact,//获取在线客服列表
#pragma mark - 银行卡
    ActRequestAddBankcard,//添加提现银行卡
    ActRequestWithdraw,//提款
    ActRequestUnbindBankcard,//解绑银行卡
    ActAll,//通用
    
#pragma mark - 🎮
    ActRequestGameTypes,
    ActRequestGameCheckStatus,
#pragma mark - 自建群
    ActRequestGroupRedTypeList, //自建群获取红包类型列表
    ActSelfGroupTemplateBomb, //查询自建群扫雷群模板
    ActSelfGroupTemplateNiuNiu, //查询自建群牛牛群模板
    ActSelfGroupTemplateErBaGang, //查询自建群二八杠群模板
    ActSelfGroupTemplateRobNiuNiu, //查询自建群抢庄群模板
    ActSelfGroupTemplateTwoPeopleNiuNiu,//查询自建群二人牛牛模板
    
    ActUpdateGroupRedPacketBomb, //更新扫雷群红包设置
    ActUpdateGroupRedPacketNiuNiu, //更新牛牛群红包设置
    ActUpdateGroupRedPacketErBaGang, //更新二八杠群红包设置
    ActUpdateGroupRedPacketRobNiuNiu, //更新抢庄牛牛红包设置
    ActUpdateGroupRedPacketTowNiuNiu, //更新二人牛牛红包设置
    
    ActCreateGroupTypeBomb, //创建自建扫雷群
    ActCreateGroupTypeNiuNiu, //创建自建牛牛群
    ActCreateGroupTypeErBaGang, //创建自建二八杠群
    ActCreateGroupTypeRobNiuNiu, //创建自建群群抢庄群
    ActCreateGroupTypeRobFuLi, //创建自建福利群
    ActCreateGroupTypeTowNiuNiu, //创建二人牛牛
    
    ActSelfCreateGroupStopSpeak, //群主禁言
    ActSelfCreateGroupStopPic, //群主禁图
    ActJoinSelfCreateGroupList, //获取加入/自建群列表
    ActUpdateGroupName, //群编辑,修改名称
    ActUpdateGroupNotice, //群编辑,修改公告
    ActGetNotIntoGroupPage, //查询可入群好友
    ActGroupUsersAndSelf, //查询自建群组中的用户（含群主自己）
    ActAddgroupMember,  //添加群成员
    ActGroupSelect, //查询群成员
    ActSkChatGroupInformation,//根据群组id获取群组信息
    ActSelfGroupInvite, //自建群-邀请入群
    ActAppLogin,  //通知服务器 登录了
    ActPullFriendOfflineMsg,  //默认获取未读消息
    ActGetWaterDetail, //获取红包详情
    ActRedpacketDetail,  //获取红包详情
    ActRedpacketGrab, //抢红包
    ActRedpacketSend,  //发红包
    ActDelgroupMember,  // 删除群成员
    ActSkChatroupStop, //群组禁言
    ActGroupStopPic, //群组禁图
    ActSearchGroupUsers,//查询群成员
    ActQueryGroupUsers,//查询群成员
    ActDelGroup,  //删群
    ActIsDisplayCreateGroup,
    Act2020AuthLoginToken,//登陆接口auth/nauth/new/mobile/token
    Act2020GetLoginConfig,//1、获取第三方登入配置
    Act2020ThirdpartRegister,//微信注册
    Act2020BindPhone,//绑定手机
    Act2020ThirdpartyCheck,//thirdparty/check
    Act2020NewRegister,//新注册接口auth/nauth/mobile/token/newreg
    Act2020ToGuestLogin,
    Act2020ListOfficialGroupPage,
    Act2020CheckJoin,
    Act2020UpdateInternalNick,//修改内部号的备注名
    Act2020SelectInternalNick,//获取所有的内部号备注名
    ActQuerySelfDeleteGroupUsers,//查询群成员预删除
    
    ActRequestInviteListFriends,
    ActRequestInviteAcceptFriend,
    ActRequestSearchUserID,
    ActRequestGamesAllClassList, // 游戏大厅-游戏分类（版本V3.0）
    ActRequestGamesQPChildContentList, // 游戏大厅-除红包游戏的三级列表（版本V3.0）
    ActRequestGamesDianZiLoginWebUrl, // 游戏大厅-电子游戏登录（版本V3.0）
    ActRequestRechargePayChannel, // 支付类型（版本V3.0）
    ActRequestRechargePayModeMethods, // 根据支付类型获取通道信息（版本V3.0）
    ActRequestAgentRegister, // 代理开启注册（版本V3.0）
    ActRequestChatGroupSelfJoin, // 进入群组（自建）（版本V3.0）
    ActRequestGameNewCheckStatus, // 三方游戏验证（版本V3.0）
    ActRequestBillingTypeQueryConfition, // 账单条件（版本V3.0）
    ActRequestBillingRecordQuery, // 账单明细（版本V3.0）
    ActRequestBillingProfitLossMoney, // 账单盈亏（版本V3.0）
    ActRequestGameReportRecordProfitLoss, // 游戏报表（版本V3.0）
    ActRequestMyCenterPersonalStatistics, // 个人汇总（版本V3.0）
    ActRequestAgentCenterProxyReferrals, // 我的下线（版本V3.0）
    ActRequestAgentCenterProxyGameReportMenus, // 代理报表 - 菜单（版本V3.0）
    ActRequestAgentCenterProxyGameReportRecord, // 代理报表 - 数据（版本V3.0）
    ActRequestContactsInviteFriends, // 通讯录添加朋友（版本V3.0）
    ActRequestTransferMoneyNearRecord, // 转账交易 - 最近收款人（版本V3.0）
    ActRequesCenterUserVIPRule, // VIP规则（版本V3.0）
    ActRequestOfficeGroupCheckJoinNew,
    ActRequestScannerQRCodeGetUserInfo,
    ActRequesTransferMoneyToUser,
    ActRequesAgentBackWaterRuleInfo,
} Act;


@interface RequestInfo : NSObject
@property(nonatomic,assign)RequestType requestType;
@property(nonatomic,copy)NSString *url;
@property(nonatomic,assign)Act act;
@property(nonatomic,assign)long long startTime;
-(id)initWithType:(RequestType)type;
@end


@interface NetRequestManager : NSObject {
    NSMutableArray *_httpManagerArray;
}

#pragma mark ---------------------------公共

+ (NetRequestManager *)sharedInstance;

#pragma mark -
#pragma mark 通用请求
-(void)requestWithAct:(Act)actInfo
          requestType:(RequestType)requestType
           parameters:(NSDictionary *)params
              success:(CallbackBlock)successBlock
                 fail:(CallbackBlock)failBlock;

#pragma mark 通用请求
- (void)requestWithData:(NSDictionary *)dict
            requestInfo:(RequestInfo *)requestInfo
                success:(CallbackBlock)successBlock
                   fail:(CallbackBlock)failBlock;

#pragma mark 请求参数
- (RequestInfo *)createRequestInfoAct:(Act)act;
- (NSMutableDictionary *)createRrequestParameters;


#pragma mark ---------------------------接口
-(void)requestClickBannerWithAdvSpaceId:(NSString*)advSpaceId Id:(NSString*)adId success:(CallbackBlock)successBlock
                                   fail:(CallbackBlock)failBlock;
-(void)requestMsgBannerWithId:(OccurBannerAdsType)adId WithPictureSpe:(OccurBannerAdsPictureType)pictureSpe success:(CallbackBlock)successBlock
                         fail:(CallbackBlock)failBlock;

#pragma mark 手机注册
-(void)checkRegisterWithDic:(NSMutableDictionary*)dic
                    success:(CallbackBlock)successBlock
                       fail:(CallbackBlock)failBlock;

-(void)registerWithDic:(NSMutableDictionary*)dic
                  success:(CallbackBlock)successBlock
                     fail:(CallbackBlock)failBlock;

#pragma mark 请求验证码
-(void)requestSmsCodeWithPhone:(NSString *)phone
                    type:(GetSmsCodeFromVCType)type
                       success:(CallbackBlock)successBlock
                          fail:(CallbackBlock) failBlock;

-(void)requestImageCaptchaWithPhone:(NSString *)phone type:(GetSmsCodeFromVCType)type
                            success:(CallbackBlock)successBlock
                               fail:(CallbackBlock)failBlock;
#pragma mark 重置密码（找回密码）
-(void)findPasswordWithPhone:(NSString *)phone
                     smsCode:(NSString *)smsCode
                    password:(NSString *)password
                     success:(CallbackBlock)successBlock
                        fail:(CallbackBlock)failBlock;
-(void)robNiuNiuBetWithChatID:(NSString *)chatID
                 SuccessBlock:(void (^)(NSDictionary * success))successBlock
                       failureBlock:(void (^)(NSError *failure))failureBlock;
#pragma mark 重设支付密码
-(void)setPayPasswordWithPhone:(NSString *)phone
                       smsCode:(NSString *)smsCode
                      password:(NSString *)password
                       success:(CallbackBlock)successBlock
                          fail:(CallbackBlock)failBlock;

#pragma mark 密码请求token
-(void)checkLoginWithDic:(NSMutableDictionary*)dic
                 success:(CallbackBlock)successBlock
                    fail:(CallbackBlock)failBlock;
-(void)requestTokenWithDic:(NSMutableDictionary*)dic
                        success:(CallbackBlock)successBlock
                           fail:(CallbackBlock)failBlock;

#pragma mark 短信验证码获取tocken
-(void)requestTockenWithPhone:(NSString *)phone
                      smsCode:(NSString *)smsCode
                      success:(CallbackBlock)successBlock
                         fail:(CallbackBlock)failBlock;

#pragma mark 请求用户信息
-(void)requestUserInfoWithSuccess:(CallbackBlock)successBlock
                            fail:(CallbackBlock)failBlock;


#pragma mark 领取福利（暂不知道此接口用处及参数）
//-(void)drawBoonWithId:(NSString *)bId
//              success:(CallbackBlock)successBlock
//                 fail:(CallbackBlock)failBlock;

#pragma mark 是否签到
//-(void)isSignWithSuccess:(CallbackBlock)successBlock
//                    fail:(CallbackBlock)failBlock;

#pragma mark 签到
//-(void)signWithSuccess:(CallbackBlock)successBlock
//                  fail:(CallbackBlock)failBlock;

#pragma mark 获取银行列表
-(void)requestBankListWithSuccess:(CallbackBlock)successBlock
                             fail:(CallbackBlock)failBlock;

#pragma mark 获取提现记录
-(void)requestDrawRecordListWithPage:(NSInteger)page success:(CallbackBlock)successBlock
                                   fail:(CallbackBlock)failBlock;

#pragma mark 提现
//弃用
-(void)withDrawWithAmount:(NSString *)amount//金额
                  userName:(NSString *)name//名字
                  bankName:(NSString *)backName//银行名
                   bankId:(NSString *)bankId//银行id
                   address:(NSString *)address//地址
                   uppayNO:(NSString *)uppayNO //卡号
                    remark:(NSString *)remark//备注
                   success:(CallbackBlock)successBlock
                      fail:(CallbackBlock)failBlock;

-(void)withDrawWithAmount:(NSString *)amount//金额
                   bankId:(NSString *)bankId//银行id
                  success:(CallbackBlock)successBlock
                     fail:(CallbackBlock)failBlock;

#pragma mark 编辑用户信息
-(void)editUserInfoWithUserAvatar:(NSString *)url
                personalSignature:(NSString *)personalSignature
                         userNick:(NSString *)nickName
                           gender:(NSInteger)gender
                          success:(CallbackBlock)successBlock
                             fail:(CallbackBlock)failBlock;

#pragma mark 上传图片
-(void)upLoadImageObj:(UIImage *)image
              success:(CallbackBlock)successBlock
                 fail:(CallbackBlock)failBlock;

#pragma mark - 上传语音
-(void)upLoadVoiceObj:(NSData *)videoData
              success:(CallbackBlock)successBlock
                 fail:(CallbackBlock)failBlock;
#pragma mark - 上传视频
-(void)upLoadVideoObj:(NSData *)voiceData
             fileName:(NSString *)fileName
              success:(CallbackBlock)successBlock
                 fail:(CallbackBlock)failBlock;

#pragma mark - 抢庄牛牛获取用户余额
-(void)getRobFinanceSuccess:(CallbackBlock)successBlock fail:(CallbackBlock)failBlock;
#pragma mark - 抢庄牛牛投注
-(void)robNiuNiuBettChatId:(NSString *)chatId money:(NSString *)money betAttr:(NSInteger)betAttr success:(CallbackBlock)successBlock fail:(CallbackBlock)failBlock;
#pragma mark - 抢庄牛牛抢庄
-(void)robNiuNiuBankeerChatId:(NSString *)chatId money:(NSString *)money success:(CallbackBlock)successBlock fail:(CallbackBlock)failBlock;
#pragma mark - 抢庄牛牛发包
-(void)robNiuNiuRedpacketChatId:(NSString *)chatId success:(CallbackBlock)successBlock fail:(CallbackBlock)failBlock;
#pragma mark - 抢庄牛牛连续上庄
-(void)robNiuNiuContinueBankerChatId:(NSString *)chatId money:(NSString *)money success:(CallbackBlock)successBlock fail:(CallbackBlock)failBlock;

#pragma mark - 抢庄牛牛期数记录
- (void)getRobPeriodRecordChatId:(NSString *)chatId page:(NSInteger )page type:(NSInteger)type success:(CallbackBlock)successBlock fail:(CallbackBlock)failBlock;

#pragma mark - 抢庄牛牛游戏记录
- (void)getRobGameDetailsChatId:(NSString *)chatId period:(NSString *)period type:(NSInteger)type success:(CallbackBlock)successBlock fail:(CallbackBlock)failBlock;
#pragma mark - 抢庄牛牛投注记录
- (void)getRobBettingRecordChatId:(NSString *)chatId page:(NSInteger)page  success:(CallbackBlock)successBlock fail:(CallbackBlock)failBlock;
#pragma mark 我的下线列表
-(void)requestMyPlayerWithPage:(NSInteger)page
                      pageSize:(NSInteger)pageSize
                    userString:(NSString *)userString
                          type:(NSInteger)type
                       success:(CallbackBlock)successBlock
                          fail:(CallbackBlock)failBlock;

#pragma mark 获取下线基础信息
-(void)requestMyPlayerCommonInfoWithSuccess:(CallbackBlock)successBlock
                                       fail:(CallbackBlock)failBlock;

#pragma mark 账单类型   线上充值 人工充值 抢包 踩雷...
-(void)requestBillTypeWithType:(NSString *)type success:(CallbackBlock)successBlock
                          fail:(CallbackBlock)failBlock;

#pragma mark 获取账单列表
-(void)requestBillListWithName:(NSString *)billName
                   categoryStr:(NSString *)categoryStr
                     beginTime:(NSString *)beginTime
                       endTime:(NSString *)endTime
                          page:(NSInteger)page
                      pageSize:(NSInteger)pageSize
                       success:(CallbackBlock)successBlock
                          fail:(CallbackBlock)failBlock;

#pragma mark 获取app配置
-(void)requestAppConfigWithSuccess:(CallbackBlock)successBlock
                              fail:(CallbackBlock)failBlock;

#pragma mark 获取通知列表
-(void)requestSystemNoticeWithType:(NSString *)type
                           success:(CallbackBlock)successBlock
                              fail:(CallbackBlock)failBlock;
///所有系统消息
- (void)allSystemMessagesWithrTime:(NSString*)time
                              page:(NSInteger)page
                           success:(CallbackBlock)successBlock
                              fail:(CallbackBlock)failBlock;
#pragma mark 请求分享列表
-(void)requestShareListWithSuccess:(CallbackBlock)successBlock
                              fail:(CallbackBlock)failBlock;

#pragma mark 增加分享页的访问量
-(void)addShareCountWithId:(NSInteger)shareId success:(CallbackBlock)successBlock
                      fail:(CallbackBlock)failBlock;

#pragma mark 充值列表
-(void)requestRechargeListWithSuccess:(CallbackBlock)successBlock
                              fail:(CallbackBlock)failBlock;

#pragma mark 报表
-(void)requestReportFormsWithUserId:(NSString *)userId beginTime:(NSString *)beginTime endTime:(NSString *)endTime success:(CallbackBlock)successBlock fail:(CallbackBlock)failBlock;

#pragma mark 删除token
-(void)removeTokenWithSuccess:(CallbackBlock)successBlock
                         fail:(CallbackBlock)failBlock;

#pragma mark 获取活动列表
-(void)requestActivityListWithUserId:(NSString *)userId success:(CallbackBlock)successBlock
                                fail:(CallbackBlock)failBlock;

#pragma mark 领取奖励
-(void)getRewardWithActivityType:(NSString *)type userId:(NSString *)userId success:(CallbackBlock)successBlock
                            fail:(CallbackBlock)failBlock;

#pragma mark 领取首充 二充奖励
-(void)getFirstRewardWithUserId:(NSString *)userId rewardType:(NSInteger)rewardType success:(CallbackBlock)successBlock
                           fail:(CallbackBlock)failBlock;

#pragma mark 申请成为代理
-(void)askForToBeAgentWithSuccess:(CallbackBlock)successBlock
                             fail:(CallbackBlock)failBlock;

#pragma mark 查询可抽奖列表
-(void)getLotteryListWithSuccess:(CallbackBlock)successBlock
                            fail:(CallbackBlock)failBlock;

#pragma mark 查询可抽奖具体信息
-(void)getLotteryDetailWithId:(NSInteger)lId success:(CallbackBlock)successBlock
                            fail:(CallbackBlock)failBlock;

#pragma mark 抽奖
-(void)lotteryWithId:(NSInteger)lId success:(CallbackBlock)successBlock
                         fail:(CallbackBlock)failBlock;

#pragma mark 添加银行卡
-(void)addBankCardWithUserName:(NSString *)userName cardNO:(NSString *)cardNO bankId:(NSString *)bankId bankCode:(NSString *)bankCode address:(NSString *)address success:(CallbackBlock)successBlock fail:(CallbackBlock)failBlock;

#pragma mark 我的银行卡
-(void)getMyBankCardListWithSuccess:(CallbackBlock)successBlock fail:(CallbackBlock)failBlock;

//#pragma mark 获取首先支付通道列表
//-(void)requestFirstRechargeListWithSuccess:(CallbackBlock)successBlock fail:(CallbackBlock)failBlock;

#pragma mark 获取所有支付通道列表
-(void)requestAllRechargeListWithSuccess:(CallbackBlock)successBlock fail:(CallbackBlock)failBlock;
#pragma mark - 接龙状态
-(void)getSolitaireInfoDict:(NSDictionary *)dict success:(CallbackBlock)successBlock fail:(CallbackBlock)failBlock;
#pragma mark - 接龙 群主发包
-(void)getSolitaireSendDict:(NSDictionary *)dict success:(CallbackBlock)successBlock fail:(CallbackBlock)failBlock;
#pragma mark - 接龙
-(void)getSolitaireRecordPageWithGroupId:(NSString *)groupId page:(NSInteger)page type:(NSInteger)type success:(CallbackBlock)successBlock fail:(CallbackBlock)failBlock;
#pragma mark - 包包彩状态
-(void)getBegLotteryInfoDict:(NSDictionary *)dict success:(CallbackBlock)successBlock fail:(CallbackBlock)failBlock;
#pragma mark - 包包彩赔率
-(void)getBegLotteryGameOddsDict:(NSDictionary *)dict success:(CallbackBlock)successBlock fail:(CallbackBlock)failBlock;
#pragma mark - 包包彩游戏记录
-(void)getBegLotteryGameRecordsDict:(NSDictionary *)dict success:(CallbackBlock)successBlock fail:(CallbackBlock)failBlock;
#pragma mark - 包包彩历史记录
-(void)getBegLotteryHistoryDict:(NSDictionary *)dict success:(CallbackBlock)successBlock fail:(CallbackBlock)failBlock;
#pragma mark - 包包彩游戏投注
-(void)getBegLotteryBettDict:(NSDictionary *)dict success:(CallbackBlock)successBlock fail:(CallbackBlock)failBlock;
#pragma mark - 包包牛群状态
-(void)getBegBagCowInfoDict:(NSDictionary *)dict success:(CallbackBlock)successBlock fail:(CallbackBlock)failBlock;
#pragma mark - 包包牛历史记录
-(void)getBegBagCowRecordDict:(NSDictionary *)dict success:(CallbackBlock)successBlock fail:(CallbackBlock)failBlock;
#pragma mark - 抢庄牛牛状态
-(void)getRobNiuNiuInfoDict:(NSDictionary *)dict success:(CallbackBlock)successBlock fail:(CallbackBlock)failBlock;
#pragma mark 提交支付资料
-(void)submitRechargeInfoWithBankId:(NSString *)bankId
                           bankName:(NSString *)bankName
                             bankNo:(NSString *)bankNo
                                tId:(NSString *)tId//通道id
                              money:(NSString *)money
                               name:(NSString *)name
                            orderId:(NSString *)orderId//无用
                               type:(NSInteger)type
                           typeCode:(NSInteger)typeCode//微信 银行卡
                             userId:(NSString *)userId
                            success:(CallbackBlock)successBlock
                               fail:(CallbackBlock)failBlock;

#pragma mark 提交订单
-(void)submitOrderRechargeInfoWithId:(NSString *)orderId money:(NSString *)money
                                name:(NSString *)name success:(CallbackBlock)successBlock fail:(CallbackBlock)failBlock;

#pragma mark 获取分享url
-(void)getShareUrlWithCode:(NSString *)code success:(CallbackBlock)successBlock fail:(CallbackBlock)failBlock;

#pragma mark 获取新手引导图片列表
-(void)getGuideImageListWithSuccess:(CallbackBlock)successBlock fail:(CallbackBlock)failBlock;

#pragma mark 活动奖励列表
-(void)getActivityListWithSuccess:(CallbackBlock)successBlock fail:(CallbackBlock)failBlock;

-(void)getActivityJiujiJingListWithId:(NSString *)activityId success:(CallbackBlock)successBlock fail:(CallbackBlock)failBlock;
#pragma mark 获取抢包活动阶段
-(void)getActivityQiaoBaoListWithId:(NSString *)activityId success:(CallbackBlock)successBlock fail:(CallbackBlock)failBlock;

#pragma mark 获取发包活动阶段
-(void)getActivityFaBaoListWithId:(NSString *)activityId success:(CallbackBlock)successBlock fail:(CallbackBlock)failBlock;

#pragma mark 获取活动详情
-(void)getActivityDetailWithId:(NSString *)activityId type:(NSInteger)type success:(CallbackBlock)successBlock fail:(CallbackBlock)failBlock;

#pragma mark 获取发包抢包奖励
-(void)getRewardWithId:(NSString *)activityId type:(NSInteger)type success:(CallbackBlock)successBlock fail:(CallbackBlock)failBlock;

#pragma mark 个人报表信息
-(void)requestUserReportInfoWithId:(NSString *)userId success:(CallbackBlock)successBlock
                              fail:(CallbackBlock)failBlock;

#pragma mark 查询所有推广教程
-(void)requestCopyListWithSuccess:(CallbackBlock)successBlock
                             fail:(CallbackBlock)failBlock;

#pragma mark 查询所有支付通道
-(void)requestAllRechargeChannelWithSuccess:(CallbackBlock)successBlock
                                       fail:(CallbackBlock)failBlock;
-(void)requestAllRechargeCheckUser:(CallbackBlock)successBlock
                              fail:(CallbackBlock)failBlock;
-(void)requestAgentDatas:(CallbackBlock)successBlock
                    fail:(CallbackBlock)failBlock;

#pragma mark - 个人中心活动列表
-(void)requestListUserActivitySuccess:(CallbackBlock)successBlock
                                 fail:(CallbackBlock)failBlock;
#pragma mark - 通讯录在线客服
- (void)requestCustomerServiceSuccess:(CallbackBlock)successBlock
                                 fail:(CallbackBlock)failBlock;
#pragma mark - 通讯录我加入的群组
- (void)requestSelfJionGrouIsOfficeFlag:(BOOL)officeFlag Success:(CallbackBlock)successBlock fail:(CallbackBlock)failBlock;

#pragma mark - 个人中心查询活动记录
- (void)requestUserListRecordDict:(NSDictionary *)dict success:(CallbackBlock)successBlock fail:(CallbackBlock)failBlock;

#pragma mark - 获取所有红包游戏
-(void)requestListRedBonusTypeSuccess:(CallbackBlock)successBlock
                                 fail:(CallbackBlock)failBlock;
#pragma mark - 获取所有红包子游戏
-(void)requestListOfficialGroup:(NSInteger)type success:(CallbackBlock)successBlock
                           fail:(CallbackBlock)failBlock;
-(void)getjoinGroupPageSuccess:(CallbackBlock)successBlock fail:(CallbackBlock)failBlock;
#pragma mark - 加入群组
- (void)getChatGroupJoinWithGroupId:(NSString *)groupId pwd:(NSString*)pwd success:(CallbackBlock)successBlock fail:(CallbackBlock)failBlock;
#pragma mark - 退出群组
- (void)getChatGroupQuitWithGroupId:(NSString *)groupId success:(CallbackBlock)successBlock fail:(CallbackBlock)failBlock;
#pragma mark - 余额宝相关
#pragma mark - 获取账户详情
- (void)getBalanceDetailsSuccess:(CallbackBlock)successBlock fail:(CallbackBlock)failBlock;
#pragma mark - 获取收益报表
- (void)getEarningsReportSuccess:(CallbackBlock)successBlock fail:(CallbackBlock)failBlock;
/**
 获取资金详情
 @param type 类型：1：转入 2：转出 3：收益
 @param isASC 是否升序
 */
- (void)getMoneyDetailWithPageIndex:(NSInteger)pageIndex pageSize:(NSInteger)pageSize type:(NSInteger)type isASC:(BOOL)isASC success:(CallbackBlock)successBlock fail:(CallbackBlock)failBlock;

/**
 转入
 */
- (void)getInWithMoney:(double)money password:(NSString *)password success:(CallbackBlock)successBlock fail:(CallbackBlock)failBlock;
#pragma mark - 转出
- (void)getOutWithMoney:(double)money password:(NSString *)password success:(CallbackBlock)successBlock fail:(CallbackBlock)failBlock;


#pragma mark - IM相关
#pragma mark - 退出群组
- (void)getQuitGroupWithID:(NSString *)ID opFlag:(NSInteger)opFlag success:(CallbackBlock)successBlock fail:(CallbackBlock)failBlock;
#pragma mark -  查询是否为好友关系
- (void)getFindFriendWithID:(NSString *)Id success:(CallbackBlock)successBlock fail:(CallbackBlock)failBlock;
#pragma mark - 修改好友昵称
- (void)getUpdateFriendNickWithUserId:(NSString *)ID  friendNick:(NSString *)friendNick success:(CallbackBlock)successBlock fail:(CallbackBlock)failBlock;
#pragma mark - 拒绝或同意群邀请 opFlag 0 发起邀请，1，同意邀请 2 删除
- (void)getOperateGroupWithID:(NSString *)ID opFlag:(NSInteger)opFlag success:(CallbackBlock)successBlock fail:(CallbackBlock)failBlock;
#pragma mark - 分页查询群邀请记录
- (void)getMyGroupVerificationsWhitPageIndex:(NSInteger)pageIndex pageSize:(NSInteger)pageSize  success:(CallbackBlock)successBlock fail:(CallbackBlock)failBlock;
#pragma mark - 邀请入群
- (void)getInviteToGroupWhitGroupId:(NSString *)groupId usersId:(NSArray *)usersId  success:(CallbackBlock)successBlock fail:(CallbackBlock)failBlock;
#pragma mark - 加入群
- (void)getAddGroupWhitGroupId:(NSString *)groupId pwd:(NSString *)pwd  success:(CallbackBlock)successBlock fail:(CallbackBlock)failBlock;
#pragma mark - 根据群组id获取群组信息
- (void)getGroupInfoWithGroupId:(NSString *)groupId success:(CallbackBlock)successBlock fail:(CallbackBlock)failBlock;
#pragma mark - 获取我加入的群组列表
- (void)getGroupListWithPageSize:(NSInteger )pageSize pageIndex:(NSInteger)pageIndex officeFlag:(BOOL)officeFlag success:(CallbackBlock)successBlock fail:(CallbackBlock)failBlock;
#pragma mark - 获取在线客服列表
- (void)getContactsSuccess:(CallbackBlock)successBlock fail:(CallbackBlock)failBlock;
#pragma mark - 添加提现银行卡
- (void)setAddBankcardWhitUserName:(NSString *)userName bankID:(NSString *)bankID cardNO:(NSString *)cardNO bankCode:(NSString *)bankCode address:(NSString *)address success:(CallbackBlock)successBlock fail:(CallbackBlock)failBlock;

/**
 提款

 @param amount 金额
 @param userPaymentId 银行id
 @param uppPayName 名字
 @param uppayBank 银行名
 @param uppayAddress 地址
 @param uppayNo 卡号
 */
- (void)getWithdrawWhitAmount:(NSString *)amount userPaymentId:(NSString *)userPaymentId uppPayName:(NSString *)uppPayName uppayBank:(NSString *)uppayBank uppayAddress:(NSString *)uppayAddress uppayNo:(NSString *)uppayNo success:(CallbackBlock)successBlock fail:(CallbackBlock)failBlock;
//解绑银行卡
- (void)getUnbindBankcardWhitPaymentId:(NSString *)paymentId success:(CallbackBlock)successBlock fail:(CallbackBlock)failBlock;

#pragma mark - 🎮类型列表
- (void)requestGameTypesSuccess:(CallbackBlock)successBlock fail:(CallbackBlock)failBlock;
- (void)requestGameCheckStatusWithId:(NSString *)parentId  success:(CallbackBlock)successBlock fail:(CallbackBlock)failBlock;

#pragma mark - *********** 自建群相关请求 ***********
/// 获取红包类型列表
- (void)requestGroupRedListSuccess:(CallbackBlock)successBlock fail:(CallbackBlock)failBlock;

#pragma mark 查询自建群红包配置模板列表
/// 查询自建群红包配置模板列表
/// @param type 群类型（ 0：福利；1：扫雷群；2：牛牛群；4：抢庄牛牛群；5：二八杠）
- (void)requestSelfGroupTemplateWithGroupType:(GroupTemplateType)type Success:(CallbackBlock)successBlock fail:(CallbackBlock)failBlock;

#pragma mark 创建自建群群组
/// 创建自建群群组
/// @param type 群类型（ 0：福利；1：扫雷群；2：牛牛群；4：抢庄牛牛群；5：二八杠）
/// @param params 主要请求参数设置
- (void)requestCreateSelfGroupWithGroupType:(GroupTemplateType)type params:(NSDictionary *)params Success:(CallbackBlock)successBlock fail:(CallbackBlock)failBlock;


/// 更新自建群红包设置
/// @param type 群类型（ 0：福利；1：扫雷群；2：牛牛群；4：抢庄牛牛群；5：二八杠）
- (void)updateGroupRedPacketWithGroupType:(GroupTemplateType)type params:(NSDictionary *)params Success:(CallbackBlock)successBlock fail:(CallbackBlock)failBlock;


/// 自建群-群主禁言
/// @param groupId 群ID
- (void)requestGroupStopSpeakWithGroupId:(NSString *)groupId Success:(CallbackBlock)successBlock fail:(CallbackBlock)failBlock;


/// 自建群-群主禁图
/// @param groupId 群ID
- (void)requestGroupStopPicWithGroupId:(NSString *)groupId Success:(CallbackBlock)successBlock fail:(CallbackBlock)failBlock;

/// 获取加入/创建的自建群列表
- (void)requestJoinSelfGroupListWithPage:(NSInteger)page Success:(CallbackBlock)successBlock fail:(CallbackBlock)failBlock;
 
#pragma mark - MessageNet 迁移

/**群编辑,修改名称*/
- (void)groupEditorName:(NSDictionary *)dict
           successBlock:(void (^)(NSDictionary * success))successBlock
           failureBlock:(void (^)(NSError *failure))failureBlock;

/**群编辑,修改公告*/
- (void)groupEditorNotice:(NSDictionary *)dict
             successBlock:(void (^)(NSDictionary * success))successBlock
             failureBlock:(void (^)(NSError *failure))failureBlock;
/**
查询可入群好友
*/
- (void)getNotIntoGroupPage:(NSDictionary *)dict
               successBlock:(void (^)(NSDictionary * success))successBlock
               failureBlock:(void (^)(NSError *failure))failureBlock;

//查询自建群组中的用户（含群主自己）
- (void)querySelfGroupUsers:(NSDictionary *)dict
               successBlock:(void (^)(NSDictionary * success))successBlock
               failureBlock:(void (^)(NSError *failure))failureBlock;

//添加群成员
- (void)addgroupMember:(NSDictionary *)dict
          successBlock:(void (^)(NSDictionary * success))successBlock
          failureBlock:(void (^)(NSError *failure))failureBlock;

//查询群成员
- (void)addGroupSelect:(NSDictionary *)dict
          successBlock:(void (^)(NSDictionary * success))successBlock
          failureBlock:(void (^)(NSError *failure))failureBlock;

-(void)skChatGroup:(NSDictionary *)dict
      successBlock:(void (^)(NSDictionary * success))successBlock
      failureBlock:(void (^)(NSError *failure))failureBlock;

//自建群-邀请入群
-(void)selfGroupInvite:(NSDictionary *)dict
          successBlock:(void (^)(NSDictionary * success))successBlock
          failureBlock:(void (^)(NSError *failure))failureBlock;

//通知服务器 登录了
-(void)appLogin:(NSDictionary *)dict
   successBlock:(void (^)(NSDictionary * success))successBlock
   failureBlock:(void (^)(NSError *failure))failureBlock;

//默认获取未读消息
-(void)pullFriendOfflineMsg:(NSDictionary *)dict
               successBlock:(void (^)(NSDictionary * success))successBlock
               failureBlock:(void (^)(NSError *failure))failureBlock;

//获取红包详情
-(void)getWaterDetail:(NSDictionary *)dict
         successBlock:(void (^)(NSDictionary * success))successBlock
         failureBlock:(void (^)(NSError *failure))failureBlock;

//获取红包详情
-(void)redpacketDetail:(NSDictionary *)dict
          successBlock:(void (^)(NSDictionary * success))successBlock
          failureBlock:(void (^)(NSError *failure))failureBlock;

//抢红包
-(void)redpacketGrab:(NSDictionary *)dict
        successBlock:(void (^)(NSDictionary * success))successBlock
        failureBlock:(void (^)(NSError *failure))failureBlock;

//发红包
-(void)redpacketSend:(NSDictionary *)dict
        successBlock:(void (^)(NSDictionary * success))successBlock
        failureBlock:(void (^)(NSError *failure))failureBlock;

// 删除群成员
-(void)delgroupMember:(NSDictionary *)dict
         successBlock:(void (^)(NSDictionary * success))successBlock
         failureBlock:(void (^)(NSError *failure))failureBlock;

//群组禁言
-(void)skChatGroupStop:(NSDictionary *)dict
         successBlock:(void (^)(NSDictionary * success))successBlock
         failureBlock:(void (^)(NSError *failure))failureBlock;

//群组禁图
-(void)groupStopPic:(NSDictionary *)dict
       successBlock:(void (^)(NSDictionary * success))successBlock
       failureBlock:(void (^)(NSError *failure))failureBlock;

//查询群成员
-(void)searchGroupUsers:(NSDictionary *)dict
           successBlock:(void (^)(NSDictionary * success))successBlock
           failureBlock:(void (^)(NSError *failure))failureBlock;
//查询群成员
-(void)queryGroupUsers:(NSDictionary *)dict
          successBlock:(void (^)(NSDictionary * success))successBlock
          failureBlock:(void (^)(NSError *failure))failureBlock;
-(void)querySelfDeleteGroupUsers:(NSDictionary *)dict
                    successBlock:(void (^)(NSDictionary * success))successBlock
                    failureBlock:(void (^)(NSError *failure))failureBlock;
//删群
-(void)delGroup:(NSDictionary *)dict
   successBlock:(void (^)(NSDictionary * success))successBlock
   failureBlock:(void (^)(NSError *failure))failureBlock;

/// 判断是否能创建群
-(void)isDisplayCreateGroup:(NSDictionary *)dict
               successBlock:(void (^)(NSDictionary * success))successBlock
               failureBlock:(void (^)(NSError *failure))failureBlock;
-(void)urlRoutes:(NSString *)url
    successBlock:(void (^)(NSString * success))successBlock
    failureBlock:(void (^)(NSError *failure))failureBlock;

-(void)toLogin:(NSDictionary *)dict
  successBlock:(void (^)(NSDictionary * success))successBlock
  failureBlock:(void (^)(NSError *failure))failureBlock;

-(void)getLoginConfig:(NSDictionary *)dict
         successBlock:(void (^)(NSDictionary * success))successBlock
         failureBlock:(void (^)(NSError *failure))failureBlock;

-(void)thirdPartRegister:(NSDictionary *)dict
            successBlock:(void (^)(NSDictionary * success))successBlock
            failureBlock:(void (^)(NSError *failure))failureBlock;

-(void)toBindPhone:(NSDictionary *)dict
      successBlock:(void (^)(NSDictionary * success))successBlock
      failureBlock:(void (^)(NSError *failure))failureBlock;
//auth/nauth/mobile/thirdparty/check
-(void)thirdpartyCheck:(NSDictionary *)dict
          successBlock:(void (^)(NSDictionary * success))successBlock
          failureBlock:(void (^)(NSError *failure))failureBlock;
//新注册接口auth/nauth/mobile/token/newreg
-(void)toRegisterAPI:(NSDictionary *)dict
          successBlock:(void (^)(NSDictionary * success))successBlock
          failureBlock:(void (^)(NSError *failure))failureBlock;

///guest
-(void)toGuestLoginAPI:(NSDictionary *)dict
          successBlock:(void (^)(NSDictionary * success))successBlock
          failureBlock:(void (^)(NSError *failure))failureBlock;

//游戏大厅，所有红包游戏的房间：/skChatGroup/listOfficialGroupPage
-(void)listOfficialGroupPage:(NSDictionary *)dict
                successBlock:(void (^)(NSDictionary * success))successBlock
                failureBlock:(void (^)(NSError *failure))failureBlock;

//官方群进群之前的校验："/social/skChatGroup/checkJoin";校验通过再调用进群的接口，校验不通过弹出提示给用户
-(void)checkJoin:(NSDictionary *)dict
    successBlock:(void (^)(NSDictionary * success))successBlock
    failureBlock:(void (^)(NSError *failure))failureBlock;

//修改内部号对备注名http://sit_gateway.fy.com/social/friend/updateInternalNick.
//数据格式：{"friendNick":"峰9528","userId":"14102"}
-(void)updateInternalNick:(NSDictionary *)dict
             successBlock:(void (^)(NSDictionary * success))successBlock
             failureBlock:(void (^)(NSError *failure))failureBlock;

//获取所有的好友备注http://sit_gateway.fy.com/social/friend/selectInternalNick[Logger]
-(void)selectInternalNick:(NSDictionary *)dict
             successBlock:(void (^)(NSDictionary * success))successBlock
             failureBlock:(void (^)(NSError *failure))failureBlock;

@end
