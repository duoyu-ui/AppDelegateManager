//
//  FYGamesMode1StatusModel.m
//  ProjectCSHB
//
//  Created by fangyuan on 2020/7/28.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "FYGamesMode1StatusModel.h"

@implementation FYGamesMode1StatusModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{
             @"uuid" : @"id"
             };
}

@end
