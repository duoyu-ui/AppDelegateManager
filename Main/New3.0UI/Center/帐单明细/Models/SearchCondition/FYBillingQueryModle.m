//
//  FYBillingQueryModle.m
//  ProjectCSHB
//
//  Created by fangyuan on 2020/6/22.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "FYBillingQueryModle.h"

@implementation FYBillingQueryFilterSubModle

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{
             @"uuid" : @"id",
             @"title" : @"label",
             @"imageUrl" : @"linkUrl"
             };
}

@end


@implementation FYBillingQueryFilterModle

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{
             @"uuid" : @"id",
             @"title" : @"label",
             @"imageUrl" : @"linkUrl",
             @"subItems" : @"children"
             };
}

+ (NSDictionary *)mj_objectClassInArray
{
    return @{
        @"subItems" : @"FYBillingQueryFilterSubModle"
    };
}

@end


@implementation FYBillingQueryClassModle

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{
             @"uuid" : @"id",
             @"title" : @"label",
             @"imageUrl" : @"linkUrl",
             @"filterItems" : @"children"
             };
}

+ (NSDictionary *)mj_objectClassInArray
{
    return @{
        @"filterItems" : @"FYBillingQueryFilterModle"
    };
}

@end


@implementation FYBillingQueryModle

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{
             @"uuid" : @"id",
             @"title" : @"label",
             @"classItems" : @"children"
             };
}

+ (NSDictionary *)mj_objectClassInArray
{
    return @{
        @"classItems" : @"FYBillingQueryClassModle"
    };
}

@end
