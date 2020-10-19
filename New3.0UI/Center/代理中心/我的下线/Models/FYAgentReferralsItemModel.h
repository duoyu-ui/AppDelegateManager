//
//  FYAgentReferralsItemModel.h
//  ProjectCSHB
//
//  Created by fangyuan on 2020/6/27.
//  Copyright © 2020 Fangyuan. All rights reserved.
//
// 我的下线 - 下线信息
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FYAgentReferralsItemModel : NSObject

@property (nonatomic, strong) NSNumber *backWater;
@property (nonatomic, strong) NSNumber *banlance;
@property (nonatomic, strong) NSNumber *bett;
@property (nonatomic, strong) NSNumber *isNewReg;
@property (nonatomic, strong) NSNumber *profitLoss;
@property (nonatomic, strong) NSNumber *proxy;
@property (nonatomic, strong) NSNumber *shrink;
@property (nonatomic, strong) NSNumber *userId;
@property (nonatomic, strong) NSNumber *isLookSubUser;
@property (nonatomic, copy) NSString *imageUrl;
@property (nonatomic, copy) NSString *nick;

+ (NSMutableArray<FYAgentReferralsItemModel *> *) buildingDataModles;

@end

NS_ASSUME_NONNULL_END
