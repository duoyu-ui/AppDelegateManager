//
//  FYGamesTypesModel.m
//  ProjectCSHB
//
//  Created by fangyuan on 2020/5/20.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "FYGamesTypesModel.h"

@implementation FYGamesTypesModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{
             @"uuid" : @"id",
             @"type" : @"id",
             @"title" : @"showName",
             @"menuItems" : @"list",
             @"hotRedHBContents" : @"chatGroupDTOS",
             @"hotOtherContents" : @"skGameChildTypes",
             };
}

+ (NSDictionary *)mj_objectClassInArray
{
    return @{
        @"menuItems" : @"FYGamesClassMenuModel",
        @"hotRedHBContents" : @"FYGamesClassContent1HBModel",
        @"hotOtherContents" : @"FYGamesClassContent2QPModel"
    };
}

@end
