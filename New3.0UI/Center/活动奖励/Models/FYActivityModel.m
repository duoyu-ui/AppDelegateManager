//
//  FYActivityModel.m
//  ProjectCSHB
//
//  Created by fangyuan on 2020/5/26.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "FYActivityModel.h"

@implementation FYActivityModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{
             @"uuid" : @"id"
             };
}

@end
