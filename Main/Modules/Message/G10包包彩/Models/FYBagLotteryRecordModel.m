//
//  FYBagLotteryRecordModel.m
//  ProjectCSHB
//
//  Created by fangyuan on 2020/7/24.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "FYBagLotteryRecordModel.h"

@implementation FYBagLotteryRecordSubDetailModel

@end

@implementation FYBagLotteryRecordModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{
             @"uuid" : @"id"
             };
}

+ (NSDictionary *)mj_objectClassInArray
{
    return @{
        @"details" : @"FYBagLotteryRecordSubDetailModel"
    };
}

@end
