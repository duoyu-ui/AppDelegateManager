//
//  FYGamesClassContent1HBModel.m
//  ProjectCSHB
//
//  Created by fangyuan on 2020/5/16.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "FYGamesClassContent1HBModel.h"

@implementation FYGamesClassContent1HBModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{
             @"uuid" : @"id",
             @"groupId": @"id",
             @"title" : @"chatgName",
             @"content" : @"notice",
             @"imageUrl" : @"img",
             
             // 以下三个字段，从二级菜单取值。（热门分类，则三级数据自己返回，无取从二级取）=> 1显示2隐藏3维护
             @"menuGameFlag" : @"gameFlag",
             @"menuMaintainEnd" : @"maintainEnd",
             @"menuMaintainStart" : @"maintainStart"
             };
}

+ (NSMutableArray<FYGamesClassContent1HBModel *> *) buildingDataModles
{
    NSMutableArray<FYGamesClassContent1HBModel *> *models = [NSMutableArray array];
    {
        NSInteger count = 5 + arc4random() % 10;
        for (int index = 0; index < count; index ++) {
            FYGamesClassContent1HBModel *model = [[FYGamesClassContent1HBModel alloc] init];
            [model setTitle:NSLocalizedString(@"扫雷7包：5-30元可发可抢（赔率1.6）", nil)];
            [model setContent:NSLocalizedString(@"进群余额：满50元，可发可抢（赔率1.6）", nil)];
            [model setImageUrl:@"icon_game_content_temp"];
            [models addObject:model];
        }
    }
    
    return models;
}

@end
