//
//  UITabBar+Badge.h
//  ProjectCSHB
//
//  Created by fangyuan on 2020/5/14.
//  Copyright © 2020 Fangyuan. All rights reserved.
//
//  [self.tabBar setBadgeStyle:kCustomBadgeStyleNumber value:@"2" atIndex:1];
//  [self.tabBar setBadgeStyle:kCustomBadgeStyleNumber value:@"0" atIndex:2];
//  [self.tabBar setBadgeStyle:kCustomBadgeStyleRedDot value:@"0" atIndex:3];
//  [self.tabBar setBadgeStyle:kCustomBadgeStyleNumber value:@"0" atIndex:4];


#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, BadgeStyle) {
    kCustomBadgeStyleRedDot,
    kCustomBadgeStyleNumber,
    kCustomBadgeStyleNone
};

@interface UITabBar (Badge)

/**
 * 设置badge的top
 */
- (void)setBadgeTop:(CGFloat)top;

/**
 * 设置tab上icon的宽度，用于调整badge的位置
 */
- (void)setTabIconWidth:(CGFloat)width;

/**
 * 设置badge的颜色
 */
- (void)setBadgeColor:(UIColor *)badgeColor;

/**
 * 设置badge的背景色
 */
- (void)setBadgeBackgroundColor:(UIColor *)badgeBackgroundColor;

/**
 * 设置badge样式、数字
 */
- (void)setBadgeStyle:(BadgeStyle)type value:(NSString *)badgeValue atIndex:(NSInteger)index;

/**
 * 设置badge数字（数字样式）
*/
- (void)setBadgeNumberValue:(NSInteger )badgeValue atIndex:(NSInteger)index;

/**
 * 设置badge数字（红点样式）
*/
- (void)setBadgeRedDotValue:(NSInteger )badgeValue atIndex:(NSInteger)index;


@end

NS_ASSUME_NONNULL_END
