//
//  FYApplicationManager.m
//  ProjectCSHB
//
//  Created by fangyuan on 2020/7/28.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "FYApplicationManager.h"

@implementation FYApplicationManager

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static FYApplicationManager *instance = nil;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] initInPrivate];
        instance.isShowSystemNoticeAlterView = YES;
    });
    return instance;
}

- (instancetype)initInPrivate {
    self = [super init];
    if (self) {

    }
    return self;
}

- (instancetype)init {
    return nil;
}

- (instancetype)copy {
    return nil;
}


#pragma mark -


@end
