//
//  FYGameRecordSectionHeader.h
//  ProjectCSHB
//
//  Created by fangyuan on 2020/8/26.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FYGameRecordSectionHeader : UIView

+ (CGFloat)headerViewHeight;

- (NSArray<NSString *> *)getColumnTitles;

- (NSArray<NSNumber *> *)getColumnPercents;

@end

NS_ASSUME_NONNULL_END
