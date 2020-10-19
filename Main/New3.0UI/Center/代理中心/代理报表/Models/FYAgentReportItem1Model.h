//
//  FYAgentReportItem1Model.h
//  ProjectCSHB
//
//  Created by fangyuan on 2020/6/29.
//  Copyright © 2020 Fangyuan. All rights reserved.
//
// 代理报表 - 样式一
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FYAgentReportItem1SubModel : NSObject
@property (nonatomic, copy) NSString *leftTitle;
@property (nonatomic, copy) NSString *leftValue;
@property (nonatomic, copy) NSString *rightTitle;
@property (nonatomic, copy) NSString *rightValue;
@end

@interface FYAgentReportItem1Model : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) NSNumber *isLookSubUser;
@property (nonatomic, strong) NSArray<FYAgentReportItem1SubModel *> *subitems;

/// 团队下线
+ (NSMutableArray<FYAgentReportItem1Model *> *) buildingDataModlesForTeamReferralis:(NSDictionary *)dict;

/// 充提业务
+ (NSMutableArray<FYAgentReportItem1Model *> *) buildingDataModlesForRechargeWithdraw:(NSDictionary *)dict;

/// 优惠奖励
+ (NSMutableArray<FYAgentReportItem1Model *> *) buildingDataModlesForRewards:(NSDictionary *)dict;

@end

NS_ASSUME_NONNULL_END
