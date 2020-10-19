//
//  FYJSSLGameBetOddsUtil.h
//  ProjectCSHB
//
//  Created by fangyuan on 2020/8/28.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import <Foundation/Foundation.h>
@class FYJSSLDataSource, FYJSSLGameOddsModel;

NS_ASSUME_NONNULL_BEGIN

@interface FYJSSLGameBetOddsUtil : NSObject

/**
 * 获取投注赔率
 * @param betDataSource 数据模型
 * @param oddsTableData 赔率配制表
 * @param oddsP 倍率因子P
 * @return 投注赔率
 */
+ (NSString *)getBetOddsValue:(NSArray<FYJSSLDataSource *> *)betDataSource oddsTableData:(FYJSSLGameOddsModel *)oddsTableData oddsP:(NSString *)oddsP;

@end

NS_ASSUME_NONNULL_END
