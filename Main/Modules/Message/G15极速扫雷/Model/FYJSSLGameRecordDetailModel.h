//
//  FYJSSLGameRecordDetailModel.h
//  ProjectCSHB
//
//  Created by fangyuan on 2020/8/28.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FYJSSLGameRecordDetailModel : NSObject
@property (nonatomic, copy) NSString *odds; // 结算倍率
@property (nonatomic, copy) NSString *betMoney; // 投注金额
@property (nonatomic, copy) NSString *profitLoss; // 投注盈亏
@property (nonatomic, strong) NSArray<NSString *> *individualBet; // 个位投注号码
@property (nonatomic, strong) NSArray<NSString *> *tenBet; // 十位投注号码
@property (nonatomic, strong) NSArray<NSString *> *hundredBet; // 百位投注号码
@property (nonatomic, strong) NSArray<NSString *> *thousandBet; // 千位投注号码
@property (nonatomic, strong) NSArray<NSString *> *myriadBet; // 万位投注号码
@end

NS_ASSUME_NONNULL_END
