//
//  FYAgentReportItem2Model.h
//  ProjectCSHB
//
//  Created by fangyuan on 2020/6/29.
//  Copyright © 2020 Fangyuan. All rights reserved.
//
// 代理报表 - 样式二
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FYAgentReportItem2SubModel : NSObject
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *value;
@end

@interface FYAgentReportItem2Model : NSObject

@property (nonatomic, copy) NSString *gameIco;
@property (nonatomic, copy) NSString *gameName;
@property (nonatomic, strong) NSNumber *backWater;  // 返水
@property (nonatomic, strong) NSNumber *bett; // 投注
@property (nonatomic, strong) NSNumber *profitLoss; // 盈亏
@property (nonatomic, strong) NSNumber *shrink; // 抽水
@property (nonatomic, strong) NSArray<FYAgentReportItem2SubModel *> *subitems;

+ (NSMutableArray<FYAgentReportItem2Model *> *)buildingDataModles:(NSArray *)arrayOfDicts code:(NSString *)code;

@end

NS_ASSUME_NONNULL_END
