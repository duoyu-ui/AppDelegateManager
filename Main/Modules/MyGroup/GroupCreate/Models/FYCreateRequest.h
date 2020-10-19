//
//  FYCreateRequest.h
//  ProjectCSHB
//
//  Created by fangyuan on 2019/10/19.
//  Copyright © 2019 Fangyuan. All rights reserved.
//  创建自建群参数配置

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FYCreateRequest : NSObject
/// 游戏类型ID
@property (nonatomic, assign) NSInteger Id;
/// 当前群ID
@property (nonatomic, copy) NSString *groupId;
/// 当前创建自建群（群类型）
@property (nonatomic, assign) NSInteger type;
/// 群名称
@property (nonatomic, copy) NSString *chatgName;
/// 群公告
@property (nonatomic, copy) NSString *notice;
/// 是否禁言
@property (nonatomic, assign) BOOL isShutupFlag;
/// 是否禁图
@property (nonatomic, assign) BOOL isShutPicFlag;
/// 是否自建群（ 0：自建群，1：官方群）
@property (nonatomic, assign) NSInteger officeFlag;
/// 最大包数
@property (nonatomic, copy) NSString *maxCount;
/// 最小包数
@property (nonatomic, copy) NSString *minCount;
/// 连续上庄金额比例
@property (nonatomic, assign) NSInteger continueBankerPercent;
/// 抢庄加注金额
@property (nonatomic, assign) NSInteger rabBankerMoney;
/// 最大金额
@property (nonatomic, copy) NSString *maxMoney;
/// 最小金额
@property (nonatomic, copy) NSString *minMoney;
/// 加注金额
@property (nonatomic, copy) NSString *myAmount;
/// 支付比例
@property (nonatomic, copy) NSString *myPayRatio;
/// 当前创建群用户ID
@property (nonatomic, copy) NSString *userId;


/// 最大金额（后台返回）
@property (nonatomic, assign) NSInteger max;
/// 最大金额（后台返回）
@property (nonatomic, assign) NSInteger min;

/// 加注金额（后台返回）
@property (nonatomic, assign) NSInteger amount;
/// 支付比例（后台返回）
@property (nonatomic, assign) NSInteger payRatio;

@end

NS_ASSUME_NONNULL_END
