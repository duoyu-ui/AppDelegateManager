//
//  UIButton+Helper.h
//  ProjectCSHB
//
//  Created by fangyuan on 2020/5/23.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIButton (Helper)

/**
 * 默认风格按钮
 */
- (void)defaultStyleButton;

/**
 * 公共按钮
 */
- (void)defaultCommonButtonWithTitleColor:(UIColor *)titleColor
                          backgroundColor:(UIColor *)backgroundColor
                     backgroundImageColor:(UIColor *)backgroundImageColor
                              borderColor:(UIColor *)borderColor
                              borderWidth:(CGFloat)borderWidth
                             cornerRadius:(CGFloat)cornerRadius;

/**
 * 公共按钮：高亮显示
 */
- (void)defaultCommonButtonWithTitleColor:(UIColor *)titleColor
                          backgroundColor:(UIColor *)backgroundColor
               backgroundImageNormalColor:(UIColor *)backgroundImageNormalColor
             backgroundImageSelectedColor:(UIColor *)backgroundImageSelectedColor
                              borderColor:(UIColor *)borderColor
                              borderWidth:(CGFloat)borderWidth
                             cornerRadius:(CGFloat)cornerRadius;

@end

NS_ASSUME_NONNULL_END
