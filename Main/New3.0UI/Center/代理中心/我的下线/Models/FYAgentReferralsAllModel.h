//
//  FYAgentReferralsAllModel.h
//  ProjectCSHB
//
//  Created by fangyuan on 2020/6/27.
//  Copyright © 2020 Fangyuan. All rights reserved.
//
// 我的下线 - 汇总信息
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FYAgentReferralsAllModel : NSObject

@property (nonatomic, copy) NSString *title;
//
@property (nonatomic, strong) NSNumber *backWater; // 返水汇总
@property (nonatomic, strong) NSNumber *banlance; // 余额汇总
@property (nonatomic, strong) NSNumber *bett; // 投注汇总
@property (nonatomic, strong) NSNumber *profitLoss; // 盈亏汇总
@property (nonatomic, strong) NSNumber *personCount; // 人数
@property (nonatomic, strong) NSNumber *userType; // 会员类型：0 会员，1 代理
//
@property (nonatomic, copy) NSString *nick;
@property (nonatomic, copy) NSString *subUserId;
@property (nonatomic, copy) NSString *headIco;
@property (nonatomic, copy) NSString *imageUrl;

+ (NSMutableArray<FYAgentReferralsAllModel *> *) buildingDataModles:(NSDictionary *)dictionary;

@end

NS_ASSUME_NONNULL_END
