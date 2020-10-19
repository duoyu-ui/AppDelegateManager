//
//  FYGamesClassMenuModel.m
//  ProjectCSHB
//
//  Created by fangyuan on 2020/5/16.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "FYGamesClassMenuModel.h"
#import "FYGamesTypesModel.h"

@implementation FYGamesClassMenuModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{
             @"uuid" : @"id",
             @"title" : @"showName"
             };
}

+ (NSNumber *)reuseHotGameUUID
{
    return [NSNumber numberWithInteger:INT_MAX];
}

+ (NSMutableArray<FYGamesClassMenuModel *> *) buildingDataModles:(FYGamesTypesModel *)gamesTypesModel
{
    NSMutableArray<FYGamesClassMenuModel *> *itemMenuModels = [NSMutableArray arrayWithArray:gamesTypesModel.menuItems];

    // 判断热门游戏数量
    BOOL isHasHotGames = NO;
    if (STR_GAMES_CENTER_CLASS_TYPE_RED_PACKET == gamesTypesModel.type.integerValue) { // 0:原生游戏
        isHasHotGames = gamesTypesModel.hotRedHBContents.count > 0 || itemMenuModels.count > 0;
    } else { // 1：自己游戏（电子游戏），2：三方游戏（王者棋牌，幸运棋牌，QG棋牌，开元棋牌，双赢彩票，其它）
        isHasHotGames = gamesTypesModel.hotOtherContents.count > 0 || itemMenuModels.count > 0;
    }
    if (isHasHotGames) {
        FYGamesClassMenuModel *model = [[FYGamesClassMenuModel alloc] init];
        [model setIsHotGame:YES];
        [model setIsSelected:YES];
        [model setUuid:[[self class] reuseHotGameUUID]];
        [model setShowName:STR_GAMES_CENTER_CLASS_MENU_TITLE];
        [itemMenuModels insertObject:model atIndex:0];
    }

    return itemMenuModels;
}

+ (NSMutableArray<FYGamesClassMenuModel *> *) buildingDataModles1
{
    NSMutableArray<FYGamesClassMenuModel *> *models = [NSMutableArray array];
    {
        NSArray *names = @[ NSLocalizedString(@"热门游戏", nil),
                            NSLocalizedString(@"扫雷红包", nil),
                            NSLocalizedString(@"禁抢红包", nil),
                            NSLocalizedString(@"牛牛红包", nil),
                            NSLocalizedString(@"抢庄牛牛", nil),
                            NSLocalizedString(@"二八杠", nil),
                            NSLocalizedString(@"接龙", nil),
                            NSLocalizedString(@"二人牛牛", nil),
                            NSLocalizedString(@"龙虎斗", nil),
                            NSLocalizedString(@"超级扫雷", nil),
                            NSLocalizedString(@"王者棋牌", nil),
                            NSLocalizedString(@"幸运棋牌", nil),
                            NSLocalizedString(@"王者棋牌", nil),
                            NSLocalizedString(@"幸运棋牌", nil),
                            NSLocalizedString(@"KY棋牌", nil) ];
        NSInteger count = 4 + arc4random() % (names.count-4);
        for (int index = 0; index < count; index ++) {
            FYGamesClassMenuModel *model = [[FYGamesClassMenuModel alloc] init];
            [model setShowName:names[index]];
            [model setIsSelected:0 == index];
            [models addObject:model];
        }
    }
    
    return models;
}




@end
