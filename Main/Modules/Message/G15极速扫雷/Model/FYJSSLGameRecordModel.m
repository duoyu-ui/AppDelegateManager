//
//  FYJSSLGameRecordModel.m
//  ProjectCSHB
//
//  Created by fangyuan on 2020/8/28.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "FYJSSLGameRecordModel.h"

@implementation FYJSSLGameRecordModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{
             @"uuid" : @"id"
             };
}

+ (NSDictionary *)mj_objectClassInArray
{
    return @{
        @"betRecordDTO" : @"FYJSSLGameRecordDetailModel"
    };
}

@end
