//
//  FYGamesClassMenuModel.h
//  ProjectCSHB
//
//  Created by fangyuan on 2020/5/16.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import <Foundation/Foundation.h>
@class FYGamesTypesModel;

NS_ASSUME_NONNULL_BEGIN

@interface FYGamesClassMenuModel : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *showName;
@property (nonatomic, copy) NSString *linkUrl;

@property (nonatomic, strong) NSNumber *uuid;
@property (nonatomic, strong) NSNumber *type;
@property (nonatomic, strong) NSNumber *sort;
@property (nonatomic, strong) NSNumber *accessWay;  // 0:原生 1:自己游戏 2:三方游戏
@property (nonatomic, strong) NSNumber *parentId;  // 一级菜单ID
@property (nonatomic, strong) NSNumber *gameFlag;  // 1显示 2隐藏 3维护
@property (nonatomic, strong) NSNumber *powerFlag;  // 下放状态（不用管）
@property (nonatomic, strong) NSNumber *amountLimit; // 金额限制字段

@property (nonatomic, copy) NSString *maintainEnd; // 维护结束时间
@property (nonatomic, copy) NSString *maintainStart; // 维护开始时间
@property (nonatomic, strong) NSNumber *maintainLimitTime;

@property (nonatomic, assign) BOOL isHotGame; // 热门游戏
@property (nonatomic, assign) BOOL isSelected; // 是否选中

+ (NSNumber *)reuseHotGameUUID;

+ (NSMutableArray<FYGamesClassMenuModel *> *) buildingDataModles:(FYGamesTypesModel *)gamesTypesModel;

+ (NSMutableArray<FYGamesClassMenuModel *> *) buildingDataModles1;

@end

NS_ASSUME_NONNULL_END
