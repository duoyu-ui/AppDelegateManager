//
//  FYStatusDefine.h
//  
//
//  Created by Mike on 2019/3/30.
//  Copyright © 2019 Mike. All rights reserved.
//




#import <Foundation/Foundation.h>

#ifndef __FYStatusDefine
#define __FYStatusDefine


#pragma mark - 会话相关

#pragma mark FYConversationType - 会话类型

/*!
 会话类型
 */
typedef NS_ENUM(NSUInteger, FYChatConversationType) {
    /*!
     群组
     */
    FYConversationType_GROUP = 1,
    
    /*!
     单聊
     */
    FYConversationType_PRIVATE = 2,

    /*!
     客服
     */
    FYConversationType_CUSTOMERSERVICE = 3,

    /*!
     系统会话
     */
    FYConversationType_SYSTEM = 4,

    /*!
     推送服务会话
     */
    FYConversationType_PUSHSERVICE = 5,
    
    /*!
     无效类型
     */
    FYCoversationType_INVALID
};


/**
 判断消息的发送者
 
 - FYMessageDirection_SEND:     我发的
 - FYMessageDirection_RECEIVE:  对方发的(单聊群里同等对待)
 - FYChatMessageFromSystem: 系统消息(提示撤销删除、商品信息等)
 */
typedef NS_ENUM(NSInteger, FYChatMessageFrom) {
    // 发送
    FYMessageDirection_SEND    = 1,
    // 接收
    FYMessageDirection_RECEIVE = 2,
    // 系统
    FYChatMessageFromSystem
};


/**
 判断发送消息所属的类型
 - FYMessageTypeText:        发送文本消息
 - FYMessageTypeImage:       发送图片消息
 - FYMessageTypeVoice:       发送语音消息
 - FYMessageTypeMap:         发送地图定位
 - FYMessageTypeVideo:       发送小视频
 - FYMessageTypeRedEnvelope: 发红包
 
 - FYMessageTypeUndo:        撤销的消息
 - FYMessageTypeDelete:      删除的消息
 */
typedef NS_ENUM(NSInteger, FYMessageType) {
    /// 0:文本
    FYMessageTypeText = 0,
    /// 1:图片
    FYMessageTypeImage = 1,
    ///语音
    FYMessageTypeVoice = 2,
    ///视频
    FYMessageTypeVideo = 3,
    FYMessageTypeMap = 4,
    
    /// 6:红包
    FYMessageTypeRedEnvelope = 6,
    /// 7:牛牛报奖信息
    FYMessageTypeNoticeRewardInfo = 7,
    /// 8:禁抢报奖信息
    FYMessageTypeReportAwardInfo = 8,
    /// 9:投注
    FYMessageTypeBett = 9,
    /// 10:抢庄
    FYMessageTypeRob = 10,
    /// 11:提示
    FYMessageTypeNotice = 11,
    /// 12:抢庄报奖
    FYMessageTypeRobReport = 12,
    ///系统报奖
    FYMessageTypeSystemWin = 13,
    ///竟奖
    FYMessageTypeRopPrompt = 14,
    ///抢庄牛牛报奖
    FYMessageTypeRobNiuNiu = 15,
    ///禁抢报奖
    FYMessageTypeGunControlWin = 16,
    ///扫雷报奖
    FYMessageTypeDeminingWin = 17,
    ///超级扫雷
    FYMessageTypeSuperDemining = 18,
    ///牛牛
    FYMessageTypeNiuNiu = 19,
    ///二人牛牛
    FYMessageTypeTwoNiuNiu = 20,
    ///接龙
    FYMessageTypeJieLong = 21,
    ///包包牛报奖
    FYMessageTypeBagBagCowWin = 22,
    ///包包牛
    FYMessageTypeBagBagCowBet = 23,
    
#pragma mark - 包包彩
    ///包包彩本期结果
    FYMessageTypeBagLotteryResults = 24,
    ///包包彩投注
    FYMessageTypeBagLotteryBet = 25,
    
    FYMessageTypeUndo,
    FYMessageTypeDelete,
    ///百人牛牛投注
    FYMessageTypeBestNiuNiuBett = 61,
    
};

/**
 提示类型
 - RobNiuNiuTypeStartGame: 游戏开始
 - RobNiuNiuTypeNoRob: 无压庄,延迟上庄
 - RobNiuNiuTypeWaitRob: 等待连续上庄
 - RobNiuNiuTypeContiueRob: 连续坐庄
 - RobNiuNiuTypeQuitRob: 放弃连续上庄,开始抢庄
 - RobNiuNiuTypeElecRob: 竞选上庄
 - RobNiuNiuTypeStartBett: 开始投注
 - RobNiuNiuTypeEndBett: 等待发包
 - RobNiuNiuTypeStartGrab: 开始抢包
 - RobNiuNiuTypeHaveGrab: 领取了红包
 - RobNiuNiuTypeLottery: 开奖结果
 - RobNiuNiuTypeRobPassKill: 庄家通杀
 - RobNiuNiuTypeRobLostAll: 庄家通赔
 - RobNiuNiuTypeGameResult: 比方结算
 - RobNiuNiuTypeNoBett: 本期无投注,延迟投注
 - SolitaireWaitInitTip,//16 接龙-x秒后,系统发出初始包,准备开抢
 - SolitaireWaitSendTip,//17 接龙-x秒后,系统发出红包,准备开抢
 - SolitaireExpiredRemind,//18 大奖还未被领取,试试
 - SolitaireUserGrabTip,//19 x领取了 x发是红包
 - SolitaireGameAward,//20 最佳手气
 - SolitaireInterrupt//21 游戏人生不足,游戏中断
 */
typedef NS_ENUM(NSInteger, RobNiuNiuType){
    RobNiuNiuTypeStartGame = 1,
    RobNiuNiuTypeNoRob,
    RobNiuNiuTypeWaitRob,
    RobNiuNiuTypeContiueRob,
    RobNiuNiuTypeQuitRob,
    RobNiuNiuTypeElecRob,
    RobNiuNiuTypeStartBett,
    RobNiuNiuTypeEndBett,
    RobNiuNiuTypeStartGrab,
    RobNiuNiuTypeHaveGrab,
    RobNiuNiuTypeLottery,
    RobNiuNiuTypeRobPassKill,
    RobNiuNiuTypeRobLostAll,
    RobNiuNiuTypeGameResult,
    RobNiuNiuTypeNoBett,
    SolitaireWaitInitTip = 16,//16
    SolitaireWaitSendTip,//17
    SolitaireExpiredRemind,//18
    SolitaireUserGrabTip,//19
    SolitaireGameAward ,//20
    SolitaireInterrupt,//21
    RobNiuNiuTypeSaoLeiReceiveOther,//22:["xxx","领取了您的红包","xxx",元]
    RobNiuNiuTypeSaoLeiReceive,//23:["您领取了","xxx","的红包","xxx","元，预中雷"]
    RobNiuNiuTypeSaoLeiReceiveLib,//24:["您", "领取了", "体验一下", "的红包", "1.73", "元，不幸中雷，赔付金额[-5.50]"], type=24}
    RobNiuNiuTypeSaoLeiResult,//25:[红包结算,雷点[5,1],中雷数[5.1],获赔金额[40],逾期红包退回[3.2]]
    RobNiuNiuTypeBaoShun = 26,
    BagBagGamesReceive = 43,
    /// 修改了红包设置
    RobNiuNiuTypeUpdateRed = 1004,
};


#endif
