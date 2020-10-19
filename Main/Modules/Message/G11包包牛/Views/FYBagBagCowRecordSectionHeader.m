//
//  FYBagBagCowRecordSectionHeader.m
//  ProjectCSHB
//
//  Created by fangyuan on 2020/7/22.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "FYBagBagCowRecordSectionHeader.h"

@implementation FYBagBagCowRecordSectionHeader

- (NSArray<NSString *> *)getColumnTitles
{
    return @[ NSLocalizedString(@"期号", nil),
              NSLocalizedString(@"输赢", nil),
              NSLocalizedString(@"盈亏", nil),
              NSLocalizedString(@"时间", nil),
              @"" ];
}

- (NSArray<NSNumber *> *)getColumnPercents
{
    return @[ @(0.23f), @(0.33f), @(0.60f), @(0.97f), @(1.0f) ];
}

@end

