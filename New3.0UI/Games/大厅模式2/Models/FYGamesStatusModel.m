//
//  FYGamesStatusModel.m
//  ProjectCSHB
//
//  Created by fangyuan on 2020/5/21.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "FYGamesStatusModel.h"

@implementation FYGamesStatusModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{
             @"uuid" : @"id"
             };
}

@end

