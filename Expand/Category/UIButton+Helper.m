//
//  UIButton+Helper.m
//  ProjectCSHB
//
//  Created by fangyuan on 2020/5/23.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "UIButton+Helper.h"

@implementation UIButton (Helper)

- (void)bootStyleButton
{
    [self.layer setBorderWidth:1.0];
    [self.layer setCornerRadius:5.0];
    [self.layer setMasksToBounds:YES];
    [self setAdjustsImageWhenHighlighted:NO];
    [self.titleLabel setFont:[UIFont fontWithName:@"FontAwesome" size:self.titleLabel.font.pointSize]];
}

/**
 * 默认按钮
 */
- (void)defaultStyleButton
{
    [self bootStyleButton];
    [self.layer setCornerRadius:3.0];
    [self setShowsTouchWhenHighlighted:YES];
    [self setTitleColor:[UIColor colorWithRed:1.00 green:1.00 blue:1.00 alpha:1.00] forState:UIControlStateNormal];
    [self setTitleColor:[UIColor colorWithRed:1.00 green:1.00 blue:1.00 alpha:1.00] forState:UIControlStateHighlighted];
    [self.layer setBorderColor:COLOR_SYSTEM_MAIN_BUTTON_BACKGROUND_SELECT_DEFAULT.CGColor];
    [self setBackgroundColor:COLOR_SYSTEM_MAIN_BUTTON_BACKGROUND_SELECT_DEFAULT];
    [self setBackgroundImage:[self buttonImageFromColor:COLOR_SYSTEM_MAIN_BUTTON_BACKGROUND_SELECT_DEFAULT
                                                   rect:CGRectMake(self.frame.origin.x, self.frame.origin.y, SCREEN_WIDTH, 50)]
                    forState:UIControlStateHighlighted];
    
}

/**
 * 公共按钮
 */
- (void)defaultCommonButtonWithTitleColor:(UIColor *)titleColor
                          backgroundColor:(UIColor *)backgroundColor
                     backgroundImageColor:(UIColor *)backgroundImageColor
                              borderColor:(UIColor *)borderColor
                              borderWidth:(CGFloat)borderWidth
                             cornerRadius:(CGFloat)cornerRadius
{
    [self.layer setMasksToBounds:YES];
    [self setShowsTouchWhenHighlighted:YES];
    [self setAdjustsImageWhenHighlighted:YES];
    [self.layer setBorderWidth:borderWidth];
    [self.layer setCornerRadius:cornerRadius];
    [self.layer setBorderColor:borderColor.CGColor];
    [self.titleLabel setFont:[UIFont fontWithName:@"FontAwesome" size:self.titleLabel.font.pointSize]];
    [self setTitleColor:titleColor forState:UIControlStateNormal];
    [self setTitleColor:titleColor forState:UIControlStateHighlighted];
    [self setBackgroundColor:backgroundColor];
    [self setBackgroundImage:[self buttonImageFromColor:backgroundImageColor
                                                   rect:CGRectMake(self.frame.origin.x, self.frame.origin.y, SCREEN_WIDTH, 50)]
                    forState:UIControlStateHighlighted];
}


/**
 * 公共按钮：高亮显示
 */
- (void)defaultCommonButtonWithTitleColor:(UIColor *)titleColor
                          backgroundColor:(UIColor *)backgroundColor
               backgroundImageNormalColor:(UIColor *)backgroundImageNormalColor
             backgroundImageSelectedColor:(UIColor *)backgroundImageSelectedColor
                              borderColor:(UIColor *)borderColor
                              borderWidth:(CGFloat)borderWidth
                             cornerRadius:(CGFloat)cornerRadius
{
    [self.layer setMasksToBounds:YES];
    [self setShowsTouchWhenHighlighted:YES];
    [self setAdjustsImageWhenHighlighted:YES];
    [self.layer setBorderWidth:borderWidth];
    [self.layer setCornerRadius:cornerRadius];
    [self.titleLabel setFont:[UIFont fontWithName:@"FontAwesome" size:self.titleLabel.font.pointSize]];
    
    [self setTitleColor:titleColor forState:UIControlStateNormal];
    [self setTitleColor:titleColor forState:UIControlStateHighlighted];
    [self setBackgroundColor:backgroundColor];
    [self.layer setBorderColor:borderColor.CGColor];
    [self setBackgroundImage:[self buttonImageFromColor:backgroundImageNormalColor
                                                   rect:CGRectMake(self.frame.origin.x, self.frame.origin.y, SCREEN_WIDTH, 50)]
                    forState:UIControlStateNormal];
    [self setBackgroundImage:[self buttonImageFromColor:backgroundImageSelectedColor
                                                   rect:CGRectMake(self.frame.origin.x, self.frame.origin.y, SCREEN_WIDTH, 50)]
                    forState:UIControlStateHighlighted];
}


/**
 * 生成背景图片
 */
- (UIImage *) buttonImageFromColor:(UIColor *)color rect:(CGRect)frame
{
    CGRect rect = CGRectMake(0, 0, frame.size.width, frame.size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}


@end
