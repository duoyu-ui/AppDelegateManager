//
//  FYGamesMode1QPGroupSubModel.h
//  ProjectCSHB
//
//  Created by fangyuan on 2020/7/31.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FYGamesMode1QPGroupSubModel : NSObject

@property (nonatomic, strong) NSNumber *uuid;
@property (nonatomic, strong) NSNumber *sort;
@property (nonatomic, strong) NSNumber *flag;
@property (nonatomic, strong) NSNumber *gameFlag; // 1：显示，2隐藏，3：维护
@property (nonatomic, strong) NSNumber *gameType; // 1：王者棋牌，2：幸运棋牌，3：QG棋牌，4：开元棋牌，5：彩票游戏
@property (nonatomic, strong) NSNumber *parentId; // 棋牌游戏（王者棋牌，幸运棋牌，QG棋牌，开元棋牌）
@property (nonatomic, strong) NSNumber *fromId; // 电子游戏
@property (nonatomic, strong) NSNumber *accessWay; // 0：原生游戏，1：自己游戏（QG电子），2：三方游戏（王者棋牌，幸运棋牌，QG棋牌，开元棋牌）
@property (nonatomic, strong) NSNumber *topGamesFlag;
@property (nonatomic, strong) NSNumber *productWallet; // 钱包

@property (nonatomic, copy) NSString *gameId; // 彩票游戏
@property (nonatomic, copy) NSString *gameCode;
@property (nonatomic, copy) NSString *gameName;
@property (nonatomic, copy) NSString *img;
@property (nonatomic, copy) NSString *imageUrl;
@property (nonatomic, copy) NSString *linkUrl;
@property (nonatomic, copy) NSString *statusValue;
@property (nonatomic, copy) NSString *descriptionMsg;

// 以下三个字段，从二级菜单取值
@property (nonatomic, strong) NSNumber *menuGameFlag;  // 1显示 2隐藏 3维护
@property (nonatomic, copy) NSString *menuMaintainEnd; // 维护结束时间
@property (nonatomic, copy) NSString *menuMaintainStart; // 维护开始时间

@end

NS_ASSUME_NONNULL_END
