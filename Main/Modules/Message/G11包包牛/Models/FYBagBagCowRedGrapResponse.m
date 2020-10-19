//
//  FYBagBagCowRedGrapResponse.m
//  ProjectCSHB
//
//  Created by fangyuan on 2020/7/23.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "FYBagBagCowRedGrapResponse.h"

@implementation FYBagBagCowRedGrapModel

@end

@implementation FYBagBagCowRedGrapData

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{
             @"items" : @"grapDetailMapDTO"
             };
}

+ (NSDictionary *)mj_objectClassInArray
{
    return @{
        @"items" : @"FYBagBagCowRedGrapModel"
    };
}

@end

@implementation FYBagBagCowRedGrapResponse

@end
