//
//  FYGamesMode1HBGroupSubModel.m
//  ProjectCSHB
//
//  Created by fangyuan on 2020/7/28.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "FYGamesMode1HBGroupSubModel.h"

@implementation FYGamesMode1HBGroupSubModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{
             @"uuid" : @"id",
             @"groupId": @"id",
             @"title" : @"chatgName",
             @"content" : @"notice",
             @"imageUrl" : @"img"
             };
}

@end
