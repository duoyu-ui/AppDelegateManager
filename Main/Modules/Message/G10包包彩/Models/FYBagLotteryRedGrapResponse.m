//
//  FYBagLotteryRedGrapResponse.m
//  ProjectCSHB
//
//  Created by fangyuan on 2020/7/24.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "FYBagLotteryRedGrapResponse.h"

@implementation FYBagLotteryRedGrapModel

@end

@implementation FYBagLotteryRedGrapData

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{
        @"uuid" : @"id",
        @"items" : @"grapDetailMapDTO"
    };
}

+ (NSDictionary *)mj_objectClassInArray
{
    return @{
        @"items" : @"FYBagLotteryRedGrapModel"
    };
}

@end

@implementation FYBagLotteryRedGrapResponse

@end
