//
//  FYBaiRenNNGroupInfoModel.h
//  ProjectCSHB
//
//  Created by fangyuan on 2020/8/27.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FYBaiRenNNGroupInfoModel : NSObject
@property (nonatomic, copy) NSString *chatId;
@property (nonatomic, copy) NSString *endTime; // 周期结束时间：秒
@property (nonatomic, copy) NSString *gameList; // 本局游戏参与的所有玩家ID
@property (nonatomic, copy) NSString *gameNumber; // 游戏期数
@property (nonatomic, copy) NSString *gameVersion; // 游戏赔率版本
@property (nonatomic, copy) NSString *people; // 投注/游戏人数
@property (nonatomic, copy) NSString *status; // 游戏周期：3.投注 6.结算
@property (nonatomic, copy) NSString *type; // 群类型 百人牛牛
//
@property (nonatomic, copy) NSString *periodId; // 期数表id
@property (nonatomic, copy) NSDictionary *resultDTO;
@end

NS_ASSUME_NONNULL_END
