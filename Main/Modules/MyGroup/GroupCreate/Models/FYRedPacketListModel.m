//
//  FYRedPacketListModel.m
//  ProjectCSHB
//
//  Created by fangyuan on 2019/10/20.
//  Copyright © 2019 Fangyuan. All rights reserved.
//

#import "FYRedPacketListModel.h"

@implementation FYRedPacketListModel

MJExtensionCodingImplementation

+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"Id" : @"id"};
}

@end
