//
//  FYFriendVerifiEntity.m
//  ProjectCSHB
//
//  Created by fangyuan on 2020/6/10.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "FYFriendVerifiEntity.h"

@interface FYFriendVerifiEntity () <WHC_SqliteInfo>

@end

@implementation FYFriendVerifiEntity

MJExtensionCodingImplementation

+ (instancetype)initWithDict:(NSDictionary *)dict
{
    FYFriendVerifiEntity *entity = [FYFriendVerifiEntity mj_objectWithKeyValues:dict];
    return entity;
}

+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"Id" : @"id"};
}

+ (NSString *)whc_SqliteVersion
{
    return @"1.0.1";
}

@end
