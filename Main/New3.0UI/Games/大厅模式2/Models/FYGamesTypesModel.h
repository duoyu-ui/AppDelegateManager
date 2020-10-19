//
//  FYGamesTypesModel.h
//  ProjectCSHB
//
//  Created by fangyuan on 2020/5/20.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import <Foundation/Foundation.h>
@class FYGamesClassMenuModel, FYGamesClassContent1HBModel, FYGamesClassContent2QPModel;

NS_ASSUME_NONNULL_BEGIN

@interface FYGamesTypesModel : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *showName;

@property (nonatomic, strong) NSNumber *uuid;  // 1:红包 2:棋牌 3:电子 4:彩票
@property (nonatomic, strong) NSNumber *type;  // 1:红包 2:棋牌 3:电子 4:彩票
@property (nonatomic, strong) NSNumber *sort;
@property (nonatomic, strong) NSNumber *gameFlag;
@property (nonatomic, strong) NSNumber *openFlag;

@property (nonatomic, strong) NSArray<FYGamesClassMenuModel *> *menuItems;  // 二级列表
@property (nonatomic, strong) NSArray<FYGamesClassContent1HBModel *> *hotRedHBContents;  // 热门红包游戏
@property (nonatomic, strong) NSArray<FYGamesClassContent2QPModel *> *hotOtherContents;  // 热门其它游戏

@end

NS_ASSUME_NONNULL_END
