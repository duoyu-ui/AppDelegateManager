//
//  FYBagBagCowRecordModel.h
//  ProjectCSHB
//
//  Created by fangyuan on 2020/7/22.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FYBagBagCowRecordSubDetailsItemModel : NSObject
@property (nonatomic, copy) NSString *betAttr; // 庄/闲/和
@property (nonatomic, copy) NSString *betMoney; // 用户投注金额
@property (nonatomic, copy) NSString *odds; // 倍率
@property (nonatomic, copy) NSString *profitLoss; // 用户投注盈亏
@end

@interface FYBagBagCowRecordSubDetailsModel : NSObject
@property (nonatomic, copy) NSString *allLoss; // 未中奖金额
@property (nonatomic, copy) NSString *allProfits; // 中奖金额
@property (nonatomic, strong) NSArray<FYBagBagCowRecordSubDetailsItemModel *> *userBetMapDTOS; // 用户所有投注单
@end

@interface FYBagBagCowRecordModel : NSObject
@property (nonatomic, copy) NSString *uuid;
@property (nonatomic, copy) NSString *gameNumber; // 期数
@property (nonatomic, copy) NSString *money; // 盈利
@property (nonatomic, copy) NSString *winner; // 输赢
@property (nonatomic, copy) NSString *createTime; // 时间
@property (nonatomic, copy) NSString *bankerNumber; // 庄点数
@property (nonatomic, copy) NSString *playerNumber; // 闲点数
@property (nonatomic, copy) NSString *roomName; // 房间名
@property (nonatomic, strong) FYBagBagCowRecordSubDetailsModel *details; // 当前用户投注详情
+ (NSMutableArray<FYBagBagCowRecordModel *> *) buildingDataModles;
@end

NS_ASSUME_NONNULL_END
