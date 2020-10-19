//
//  EnvelopeMessage.h
//  Project
//
//  Created by mini on 2018/8/8.
//  Copyright © 2018年 CDJay. All rights reserved.
//

/// 红包类型
typedef NS_ENUM(NSInteger, FYRedEnvelopeType) {
    /// 福利红包
    FYRedEnvelopeType_Fu    = 0,
    /// 扫雷红包
    FYRedEnvelopeType_Mine    = 1, 
    /// 牛牛红包
    FYRedEnvelopeType_Cow    = 2,
    /// 禁抢红包
    FYRedEnvelopeType_NoRob    = 3,
    /// 抢庄牛牛
    FYRedEnvelopeType_RobNN    = 4,
    /**二八杠*/
     FYRedEnvelopeType_ebg = 5,
     /**龙虎斗*/
     FYRedEnvelopeType_lhd = 6,
     /**接龙*/
     FYRedEnvelopeType_jl = 7,
    /// 二人牛牛
    FYRedEnvelopeType_ErRenNN  = 8,
    ///超级扫雷
    FYRedEnvelopeType_SuperBomb = 9,
    ///包包彩
    FYRedEnvelopeType_BagLottery = 10,
    ///包包牛
    FYRedEnvelopeType_BagBagCow = 11,
 
};

@interface EnvelopeMessage : NSObject<NSCoding>
@property (nonatomic, assign) NSInteger count;
@property (nonatomic, copy) NSString *money;
//bombList
@property (nonatomic, copy) NSString *bombList;
@property (nonatomic, copy) NSString *date;
// 红包id
@property (nonatomic, copy) NSString *redpacketId;
@property (nonatomic, assign) NSInteger num;
@property (nonatomic, assign) FYRedEnvelopeType type;
// Cell状态   (红包标识符+ userId) 获得 0:查看红包 1:红包已领取 2:红包已被领完 3:红包已过期
 @property (nonatomic, copy) NSString *cellStatus;
// 禁抢
@property (nonatomic, strong) NSDictionary *nograbContent;
@property (nonatomic, copy) NSString *content;

- (instancetype)initWithObj:(id)obj;

@end
