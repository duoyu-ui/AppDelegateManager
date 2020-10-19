//
//  FYPersonStaticItemModel.m
//  ProjectCSHB
//
//  Created by fangyuan on 2020/6/26.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "FYPersonStaticItemModel.h"

@implementation FYPersonStaticItemModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{
             @"title" : @"gameTypeName"
             };
}

@end

