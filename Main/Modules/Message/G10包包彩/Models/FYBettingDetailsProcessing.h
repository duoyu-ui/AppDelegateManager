//
//  FYBettingDetailsProcessing.h
//  ProjectCSHB
//
//  Created by Tom on 2020/8/25.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
///投注详情处理
@interface FYBettingDetailsProcessing : NSObject

/// 包包彩投注详情处理
/// @param dict 赔率字典
/// @param textDict 投注数据
+ (NSArray*)getBagLotteryBettingDetailsWithDict:(NSDictionary*)dict textDict:(NSDictionary *)textDict;

/// 百人牛牛投注详情处理
/// @param dict 赔率字典
/// @param textDict 投注数据
+ (NSArray*)getBestNiuNiuBettingDetailsWithDict:(NSDictionary*)dict textDict:(NSDictionary *)textDict;
@end

@interface FYBestNiuNiuBettTwoLevel :NSObject
@property (nonatomic , assign) NSInteger              twoLevelType;
@property (nonatomic , copy) NSString              * bettOddsNums;
@property (nonatomic , copy) NSString              * bettName;
@property (nonatomic , assign) NSInteger              pokerNum;

@end


@interface FYBestNiuNiuBettOneLevel :NSObject
@property (nonatomic , copy) NSArray<FYBestNiuNiuBettTwoLevel *>              * bettTwoLevel;
@property (nonatomic , assign) NSInteger              oneLevelType;

@end

@interface FYBestNiuNiuBettVO :NSObject
@property (nonatomic , assign) NSInteger              totalMoney;
@property (nonatomic , copy) NSArray<FYBestNiuNiuBettOneLevel *>              * bettOneLevel;
@property (nonatomic , assign) NSInteger              chatId;
@property (nonatomic , assign) NSInteger              singleMoney;
@property (nonatomic , assign) NSInteger              userId;

@end

@interface FYBestNiuNiuModel :NSObject
@property (nonatomic , strong) FYBestNiuNiuBettVO              * bettVO;
@property (nonatomic , assign) NSInteger              chatId;
@property (nonatomic , assign) NSInteger              userId;
@property (nonatomic , assign) NSInteger              gameNumber;
@property (nonatomic , copy) NSString              * text;
@property (nonatomic , copy) NSString              * textCopy;
@property (nonatomic , assign) NSInteger              money;

@end

NS_ASSUME_NONNULL_END
