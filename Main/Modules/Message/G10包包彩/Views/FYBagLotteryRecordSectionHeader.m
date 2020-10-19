//
//  FYBagLotteryRecordSectionHeader.m
//  ProjectCSHB
//
//  Created by fangyuan on 2020/7/24.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "FYBagLotteryRecordSectionHeader.h"

@implementation FYBagLotteryRecordSectionHeader

- (NSArray<NSString *> *)getColumnTitles
{
    return @[ NSLocalizedString(@"期号", nil),
              NSLocalizedString(@"开奖", nil),
              NSLocalizedString(@"盈亏", nil),
              NSLocalizedString(@"时间", nil),
              @"" ];
}

- (NSArray<NSNumber *> *)getColumnPercents
{
    return @[ @(0.20f), @(0.40f), @(0.60f), @(0.97f), @(1.0f) ];
}

@end

