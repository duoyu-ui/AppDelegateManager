//
//  FYGameReportModel.m
//  ProjectCSHB
//
//  Created by fangyuan on 2020/6/25.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "FYGameReportModel.h"

@implementation FYGameReportModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{
             @"uuid" : @"id"
             };
}

@end
