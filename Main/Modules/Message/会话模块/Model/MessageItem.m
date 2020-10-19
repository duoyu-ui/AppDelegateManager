//
//  MessageItem.m
//  Project
//
//  Created by mini on 2018/8/1.
//  Copyright © 2018年 CDJay. All rights reserved.
//

#import "MessageItem.h"


@implementation MessageItem

MJExtensionCodingImplementation

/**
 * 为了在swift中能够生成模型
 */
+ (instancetype)initWithDict:(NSDictionary *)dict {
    MessageItem *item = [MessageItem mj_objectWithKeyValues:dict];
    item.tableOwnerId = AppModel.shareInstance.userInfo.userId;
    return item;
}

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"groupId": @"id"};
}

- (instancetype)init {
    if (self = [super init]) {
        self.tableOwnerId = AppModel.shareInstance.userInfo.userId;
    }
    return self;
}

+ (NSString *)whc_SqliteVersion {
    return @"1.0.3";
}


@end
