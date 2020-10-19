//
//  FYGameReportStatisticsModel.h
//  ProjectCSHB
//
//  Created by fangyuan on 2020/6/25.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FYGameReportStatisticsModel : NSObject

@property (nonatomic, strong) NSNumber *moneyAll;  // 所有盈利
@property (nonatomic, strong) NSNumber *rewardMoneyAll;  // 所有奖励
@property (nonatomic, strong) NSNumber *waterMoneyAll;  // 所有投注
@property (nonatomic, strong) NSNumber *gameWaterMoneyAll;

@end

NS_ASSUME_NONNULL_END
