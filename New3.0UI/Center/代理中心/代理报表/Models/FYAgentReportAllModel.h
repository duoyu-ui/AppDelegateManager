//
//  FYAgentReportAllModel.h
//  ProjectCSHB
//
//  Created by fangyuan on 2020/6/29.
//  Copyright © 2020 Fangyuan. All rights reserved.
//
// 代理报表 - 汇总信息
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FYAgentReportAllItemModel : NSObject
@property (nonatomic, copy) NSString *leftTitle;
@property (nonatomic, copy) NSString *leftValue;
@property (nonatomic, copy) NSString *rightTitle;
@property (nonatomic, copy) NSString *rightValue;
@end

@interface FYAgentReportAllModel : NSObject
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *totalMoneyTitle;
@property (nonatomic, copy) NSString *todayMoneyTitle;
@property (nonatomic, copy) NSString *totalMoneyValue;
@property (nonatomic, copy) NSString *todayMoneyValue;
@property (nonatomic, strong) NSArray<FYAgentReportAllItemModel *> *subitems;

/// 汇总
+ (NSMutableArray<FYAgentReportAllModel *> *) buildingDataModlesForSumTotal:(NSDictionary *)dict;

/// 公共
+ (NSMutableArray<FYAgentReportAllModel *> *) buildingDataModlesForCommon:(NSDictionary *)dict title:(NSString *)title isFull:(BOOL)isfull;


@end

NS_ASSUME_NONNULL_END
