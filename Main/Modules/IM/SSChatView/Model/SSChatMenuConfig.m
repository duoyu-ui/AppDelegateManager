//
//  SSChatMenuConfig.m
//  ProjectCSHB
//
//  Created by fangyuan on 2019/12/9.
//  Copyright © 2019 Fangyuan. All rights reserved.
//

#import "SSChatMenuConfig.h"

@implementation SSChatMenuConfig

+ (instancetype)initWithTitle:(NSString *)title image:(NSString *)image tag:(NSInteger)tag {
    SSChatMenuConfig *config = [[SSChatMenuConfig alloc] init];
    config.title = title;
    config.image = image;
    config.tag = tag;
    return config;
}


- (instancetype)initWithTitle:(NSString *)title image:(NSString *)image tag:(NSInteger)tag {
    if (self = [super init]) {
        self.title = title;
        self.image = image;
        self.tag = tag;
    }
    return self;
}

@end
