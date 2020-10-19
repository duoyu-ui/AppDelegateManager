//
//  FYGamesMode1QPGroupSubModel.m
//  ProjectCSHB
//
//  Created by fangyuan on 2020/7/31.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "FYGamesMode1QPGroupSubModel.h"

@implementation FYGamesMode1QPGroupSubModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{
             @"uuid" : @"id",
             @"imageUrl" : @"img",
             @"menuGameFlag" : @"gameFlag"
             };
}

@end

