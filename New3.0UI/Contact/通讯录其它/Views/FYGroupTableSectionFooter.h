//
//  FYGroupTableSectionFooter.h
//  ProjectCSHB
//
//  Created by fangyuan on 2020/7/10.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FYGroupTableSectionFooter : UIView

+ (CGFloat)height;

- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title;

- (void)setTitleString:(NSString *)titleString;

@end

NS_ASSUME_NONNULL_END
