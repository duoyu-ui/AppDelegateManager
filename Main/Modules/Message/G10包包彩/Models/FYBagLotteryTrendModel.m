//
//  FYBagLotteryTrendModel.m
//  ProjectCSHB
//
//  Created by fangyuan on 2020/7/25.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "FYBagLotteryTrendModel.h"

@implementation FYBagLotteryTrendOneModel

@end

@implementation FYBagLotteryTrendTwoModel

@end

@implementation FYBagLotteryTrendSubModel

@end

@implementation FYBagLotteryTrendModel

+ (NSDictionary *)mj_objectClassInArray
{
    return @{
        @"subs" : @"FYBagLotteryTrendSubModel"
    };
}

@end

@implementation FYBagLotteryTrendData

+ (NSDictionary *)mj_objectClassInArray
{
    return @{
        @"ones" : @"FYBagLotteryTrendOneModel",
        @"twos" : @"FYBagLotteryTrendTwoModel",
        @"threes" : @"FYBagLotteryTrendModel"
    };
}

@end

@implementation FYBagLotteryTrendResponse : NSObject

@end
