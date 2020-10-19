//
//  FYPersonStaticAllModel.h
//  ProjectCSHB
//
//  Created by fangyuan on 2020/6/26.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FYPersonStaticAllModel : NSObject

@property (nonatomic, copy) NSString *title;
//
@property (nonatomic, strong) NSNumber *banlance; // 余额 主账户余额
@property (nonatomic, strong) NSNumber *bett; // 投注
@property (nonatomic, strong) NSNumber *commission; // 佣金
@property (nonatomic, strong) NSNumber *inAccount; // 转入
@property (nonatomic, strong) NSNumber *outAccount; // 转出
@property (nonatomic, strong) NSNumber *profitLoss; // 盈亏
@property (nonatomic, strong) NSNumber *recharge; // 充值 充值成功总额
@property (nonatomic, strong) NSNumber *reward; // 奖励
@property (nonatomic, strong) NSNumber *todayProfitLoss; // 今日盈亏
@property (nonatomic, strong) NSNumber *totalAssets; // 总资产
@property (nonatomic, strong) NSNumber *withdraw; // 提现 提现成功总额
@property (nonatomic, strong) NSNumber *yuEBao; // 余额宝

+ (NSMutableArray<FYPersonStaticAllModel *> *) buildingDataModles:(NSMutableArray<NSDictionary *> *)arrayOfDicts;

@end

NS_ASSUME_NONNULL_END
