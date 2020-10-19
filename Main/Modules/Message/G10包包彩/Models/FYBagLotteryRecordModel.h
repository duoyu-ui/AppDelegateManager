//
//  FYBagLotteryRecordModel.h
//  ProjectCSHB
//
//  Created by fangyuan on 2020/7/24.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FYBagLotteryRecordSubDetailModel : NSObject
@property (nonatomic, copy) NSString *bettNumbers; // 投注信息 保存为 json 字符串
@property (nonatomic, copy) NSString *money; // 中奖金额 0为未中奖 大于零为中奖金额
@property (nonatomic, copy) NSString *odds; // 赔率
@property (nonatomic, copy) NSString *oneLevelType; // 时间
@property (nonatomic, copy) NSString *singleMoney; // 单注金额
@property (nonatomic, copy) NSString *twoLevelType; // 包包彩二级类型 例如 尾数：1：一尾 2：二尾 3：三尾 4：四尾 5：五尾 前后组合对应大小单双
@end

@interface FYBagLotteryRecordModel : NSObject
@property (nonatomic, copy) NSString *uuid;
@property (nonatomic, copy) NSString *money; // 用户盈亏金额
@property (nonatomic, copy) NSString *bettMoney; // 未中奖金额
@property (nonatomic, copy) NSString *createTime; // 时间
@property (nonatomic, copy) NSString *period; // 游戏期数
@property (nonatomic, copy) NSString *winMoney; // 中奖金额
@property (nonatomic, copy) NSString *winNumbers; // 彩票号码 格式：1,2,3,4,5,6
@property (nonatomic, copy) NSArray<FYBagLotteryRecordSubDetailModel *> *details; // 用户所有投注单
@end

NS_ASSUME_NONNULL_END
