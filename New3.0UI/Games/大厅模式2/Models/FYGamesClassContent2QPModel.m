//
//  FYGamesClassContent2QPModel.m
//  ProjectCSHB
//
//  Created by fangyuan on 2020/5/20.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "FYGamesClassContent2QPModel.h"
#import "FYGamesClassMenuModel.h"

@implementation FYGamesClassContent2QPModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{
             @"uuid" : @"id",
             @"imageUrl" : @"img",
             
             // 以下三个字段，从二级菜单取值。（热门分类，则三级数据自己返回，无取从二级取）=> 1显示2隐藏3维护
             @"menuGameFlag" : @"gameFlag",
             @"menuMaintainEnd" : @"maintainEnd",
             @"menuMaintainStart" : @"maintainStart"
             };
}

+ (NSMutableArray<FYGamesClassContent2QPModel *> *) buildingDataModles:(FYGamesClassMenuModel *)itemMenuModel
{
    NSMutableArray<FYGamesClassContent2QPModel *> *models = [NSMutableArray array];
    {
        NSMutableDictionary *dict = [itemMenuModel mj_keyValues];
        FYGamesClassContent2QPModel *model = [FYGamesClassContent2QPModel mj_objectWithKeyValues:dict];
        [models addObject:model];
    }
    
    return models;
}

@end

