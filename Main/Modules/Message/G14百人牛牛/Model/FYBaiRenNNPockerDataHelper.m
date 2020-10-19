//
//  FYBaiRenNNPockerDataHelper.m
//  ProjectCSHB
//
//  Created by fangyuan on 2020/8/26.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "FYBaiRenNNPockerDataHelper.h"
#import "FYBestWinsLossesModel.h"

@implementation FYBaiRenNNPockerDataHelper

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static FYBaiRenNNPockerDataHelper *instance = nil;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] initInPrivate];
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

@end
