//
//  FYDropDownMenuBasedModel.m
//  ProjectCSHB
//
//  Created by fangyuan on 2020/6/22.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "FYDropDownMenuBasedModel.h"

@implementation FYDropDownMenuBasedModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        _cellClassName = @"FYDropDownMenuBasedCell";
    }
    return self;
}

@end
