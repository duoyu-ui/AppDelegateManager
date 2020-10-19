//
//  FYBagLotteryGroupInfoModel.h
//  ProjectCSHB
//
//  Created by fangyuan on 2020/8/27.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FYBagLotteryGroupInfoModel : NSObject
@property (nonatomic, copy) NSString *chatId;
@property (nonatomic, copy) NSString *endTime; // 周期结束时间：秒
@property (nonatomic, copy) NSString *gameNumber; // 游戏期数
@property (nonatomic, copy) NSString *people; // 投注/游戏人数
@property (nonatomic, copy) NSString *oddsVerion; // 游戏赔率版本
@property (nonatomic, copy) NSString *bettPeopleNum; // 投注人数限制
@property (nonatomic, copy) NSString *status; // 游戏周期：3.投注 4.发包 5.抢包 6.结算
@property (nonatomic, copy) NSString *type;
@end

NS_ASSUME_NONNULL_END
