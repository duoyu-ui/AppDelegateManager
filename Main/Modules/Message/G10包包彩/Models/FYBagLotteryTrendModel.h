//
//  FYBagLotteryTrendModel.h
//  ProjectCSHB
//
//  Created by fangyuan on 2020/7/25.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FYBagLotteryTrendOneModel : NSObject
@property (nonatomic, copy) NSString *num; // 数字
@property (nonatomic, copy) NSString *count; // 出现次数
@end

@interface FYBagLotteryTrendTwoModel : NSObject
@property (nonatomic, copy) NSString *num; // 数字
@property (nonatomic, copy) NSString *unOpen; // 未开次数
@property (nonatomic, copy) NSString *linkOpen; // 连开次数
@end

@interface FYBagLotteryTrendSubModel : NSObject
@property (nonatomic, copy) NSString *num; // 中奖号码
@property (nonatomic, copy) NSString *numCount; // 中奖号码出现次数
@end

@interface FYBagLotteryTrendModel : NSObject
@property (nonatomic, copy) NSString *gameNumber; // 期号
@property (nonatomic, copy) NSString *typeName; // 类型名称
@property (nonatomic, copy) NSArray<FYBagLotteryTrendSubModel *> *subs; // 走势图List
@property (nonatomic, assign) BOOL isIssuePlaying; // 是否未开奖期号
@end

@interface FYBagLotteryTrendData : NSObject
@property (nonatomic, copy) NSArray<FYBagLotteryTrendOneModel *> *ones;
@property (nonatomic, copy) NSArray<FYBagLotteryTrendTwoModel *> *twos;
@property (nonatomic, copy) NSArray<FYBagLotteryTrendModel *> *threes;
@end

@interface FYBagLotteryTrendResponse : NSObject
@property (nonatomic, copy) NSString *msg;
@property (nonatomic, assign) NSInteger code;
@property (nonatomic, strong) FYBagLotteryTrendData *data;
@end


NS_ASSUME_NONNULL_END
