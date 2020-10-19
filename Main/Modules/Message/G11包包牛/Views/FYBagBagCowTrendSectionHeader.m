//
//  FYBagBagCowTrendSectionHeader.m
//  ProjectCSHB
//
//  Created by fangyuan on 2020/7/24.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "FYBagBagCowTrendSectionHeader.h"

@implementation FYBagBagCowTrendSectionHeader

- (NSArray<NSString *> *)getColumnTitles
{
    return @[ NSLocalizedString(@"期号", nil),
              NSLocalizedString(@"庄", nil),
              NSLocalizedString(@"闲", nil),
              NSLocalizedString(@"输赢", nil) ];
}

- (NSArray<NSNumber *> *)getColumnPercents
{
    return @[ @(0.25f), @(0.50f), @(0.75f), @(1.0f) ];
}

@end

