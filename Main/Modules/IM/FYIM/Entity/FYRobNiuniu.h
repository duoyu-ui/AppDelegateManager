//
//  FYRobNiuniu.h
//  ProjectCSHB
//
//  Created by fangyuan on 2019/10/26.
//  Copyright © 2019 Fangyuan. All rights reserved.
//  抢庄牛牛，二八杠

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FYRobNiuniu : NSObject

/// 群聊天ID
@property (nonatomic, copy) NSString *chatId;
/// 加注金额（后台返回）
@property (nonatomic, assign) NSInteger rabBankerMoney;
/// 支付比例（后台返回）
@property (nonatomic, assign) NSInteger continueBankerPercent;

@property (nonatomic, copy) NSString *bettMoneyList;

@property (nonatomic, copy) NSString *rabBankerMoneyList;

@end

NS_ASSUME_NONNULL_END
