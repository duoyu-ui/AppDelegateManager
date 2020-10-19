//
//  FYGamesMode1TypesModel.m
//  ProjectCSHB
//
//  Created by fangyuan on 2020/7/27.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "FYGamesMode1TypesModel.h"
#import "FYGamesMode1ClassModel.h"

@implementation FYGamesMode1TypesModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{
             @"uuid" : @"id",
             @"title" : @"showName"
             };
}

+ (NSDictionary *)mj_objectClassInArray
{
    return @{
        @"list" : @"FYGamesMode1ClassModel"
    };
}

@end
