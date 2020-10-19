//
//  FYMultiRowLabel.h
//  ProjectCSHB
//
//  Created by fangyuan on 2020/5/27.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FYMultiRowLabel : UIView

- (void)setTitle:(NSString *)title;
- (void)setTitleFont:(UIFont *)font;
- (void)setTitleColor:(UIColor *)color;
- (void)setTitleTextAlignment:(NSTextAlignment)textAlignment;

- (void)setContent:(NSString *)money;
- (void)setContentFont:(UIFont *)font;
- (void)setContentColor:(UIColor *)color;
- (void)setContentTextAlignment:(NSTextAlignment)textAlignment;

@end

NS_ASSUME_NONNULL_END
