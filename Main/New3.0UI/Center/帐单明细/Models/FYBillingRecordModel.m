//
//  FYBillingRecordModel.m
//  ProjectCSHB
//
//  Created by fangyuan on 2020/6/20.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "FYBillingRecordModel.h"

@implementation FYBillingRecordModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{
             @"uuid" : @"id",
             @"imageUrl" : @"linkUrl",
             @"content" : @"levelList"
             };
}


+ (NSMutableArray<FYBillingRecordModel *> *) buildingDataModles
{
    NSMutableArray<FYBillingRecordModel *> *models = [NSMutableArray array];
    {
        NSArray *titles = @[ NSLocalizedString(@"福利抢包", nil),
                             NSLocalizedString(@"牛牛结算", nil),
                             NSLocalizedString(@"扫雷抢包", nil),
                             NSLocalizedString(@"扫雷踩雷赔付", nil),
                             NSLocalizedString(@"超级扫雷发包", nil),
                             NSLocalizedString(@"福利抢包", nil),
                             NSLocalizedString(@"牛牛结算", nil),
                             NSLocalizedString(@"扫雷抢包", nil),
                             NSLocalizedString(@"扫雷踩雷赔付", nil),
                             NSLocalizedString(@"超级扫雷发包", nil),
                             NSLocalizedString(@"福利抢包", nil),
                             NSLocalizedString(@"牛牛结算", nil),
                             NSLocalizedString(@"扫雷抢包", nil),
                             NSLocalizedString(@"扫雷踩雷赔付", nil),
                             NSLocalizedString(@"超级扫雷发包", nil),
                             NSLocalizedString(@"超级扫雷", nil) ];
        NSArray *contents = @[ NSLocalizedString(@"游戏报表1", nil),
                               NSLocalizedString(@"游戏报表2", nil),
                               NSLocalizedString(@"游戏报表3", nil),
                               NSLocalizedString(@"游戏报表4", nil),
                               NSLocalizedString(@"游戏报表5", nil),
                               NSLocalizedString(@"游戏报表1", nil),
                               NSLocalizedString(@"游戏报表2", nil),
                               NSLocalizedString(@"游戏报表3", nil),
                               NSLocalizedString(@"游戏报表4", nil),
                               NSLocalizedString(@"游戏报表5", nil),
                               NSLocalizedString(@"游戏报表1", nil),
                               NSLocalizedString(@"游戏报表2", nil),
                               NSLocalizedString(@"游戏报表3", nil),
                               NSLocalizedString(@"游戏报表4", nil),
                               NSLocalizedString(@"游戏报表5", nil),
                               NSLocalizedString(@"游戏报表6", nil) ];
        NSArray *imageUrls = @[ @"icon_game_cjsl",
                                @"icon_game_fl",
                                @"icon_game_nn",
                                @"icon_game_qznn",
                                @"icon_game_rbg",
                                @"icon_game_cjsl",
                                @"icon_game_fl",
                                @"icon_game_nn",
                                @"icon_game_qznn",
                                @"icon_game_rbg",
                                @"icon_game_cjsl",
                                @"icon_game_fl",
                                @"icon_game_nn",
                                @"icon_game_qznn",
                                @"icon_game_rbg",
                                @"icon_game_sl" ];
        for (int index = 0; index < titles.count; index ++) {
            FYBillingRecordModel *model = [[FYBillingRecordModel alloc] init];
            [model setTitle:titles[index]];
            [model setContent:contents[index]];
            [model setImageUrl:imageUrls[index]];
            [models addObject:model];
        }
    }
    
    return models;
}

@end
