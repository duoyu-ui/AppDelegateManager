//
//  FYJSSLGameTrendSectionHeader.m
//  ProjectCSHB
//
//  Created by fangyuan on 2020/8/28.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "FYJSSLGameTrendSectionHeader.h"

@implementation FYJSSLGameTrendSectionHeader

- (NSArray<NSString *> *)getColumnTitles
{
    return @[ NSLocalizedString(@"期号", nil),
              NSLocalizedString(@"雷点", nil) ];
}

- (NSArray<NSNumber *> *)getColumnPercents
{
    return @[ @(0.3f), @(1.0f) ];
}

@end
