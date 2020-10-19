//
//  FYGroupVerifiEntity.m
//  ProjectCSHB
//
//  Created by fangyuan on 2019/8/27.
//  Copyright © 2019 CDJay. All rights reserved.
//

#import "FYGroupVerifiEntity.h"

@implementation FYGroupVerifiEntity

MJExtensionCodingImplementation

+ (instancetype)initWithDict:(NSDictionary *)dict
{
    FYGroupVerifiEntity *entity = [FYGroupVerifiEntity mj_objectWithKeyValues:dict];
    return entity;
}

+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"Id" : @"id"};
}

@end
