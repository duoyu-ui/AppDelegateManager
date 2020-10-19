//
//  FYBaiRenNNTrendSectionHeader.m
//  ProjectCSHB
//
//  Created by fangyuan on 2020/8/27.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "FYBaiRenNNTrendSectionHeader.h"

@implementation FYBaiRenNNTrendSectionHeader

- (NSArray<NSString *> *)getColumnTitles
{
    return @[ NSLocalizedString(@"期号", nil),
              NSLocalizedString(@"开奖号码", nil),
              NSLocalizedString(@"胜方", nil),
              NSLocalizedString(@"牛数", nil) ];
}

- (NSArray<NSNumber *> *)getColumnPercents
{
    return @[ @(0.25f), @(0.65f), @(0.85f), @(1.0f) ];
}

@end

