//
//  UITabBar+Badge.m
//  ProjectCSHB
//
//  Created by fangyuan on 2020/5/14.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "UITabBar+Badge.h"
#import <objc/runtime.h>

static NSString * const kBadgeViewInitedKey = @"kBadgeViewInited";
static NSString * const kBadgeDotViewsKey = @"kBadgeDotViewsKey";
static NSString * const kBadgeNumberViewsKey = @"kBadgeNumberViewsKey";

static NSString * const kBadgeTop = @"kBadgeTop";
static NSString * const kTabIconWidth = @"kTabIconWidth";
static NSString * const kBbadgeColor = @"kBbadgeColor";
static NSString * const kBadgeBackgroundColor = @"kBadgeBackgroundColor";

@implementation UITabBar (Badge)

- (void)setBadgeTop:(CGFloat)top
{
    [self setValue:@(top) forUndefinedKey:kBadgeTop];
}

- (void)setTabIconWidth:(CGFloat)width
{
    [self setValue:@(width) forUndefinedKey:kTabIconWidth];
}

- (void)setBadgeColor:(UIColor *)badgeColor
{
    [self setValue:badgeColor forUndefinedKey:kBbadgeColor];
}

- (void)setBadgeBackgroundColor:(UIColor *)badgeBackgroundColor
{
    [self setValue:badgeBackgroundColor forUndefinedKey:kBadgeBackgroundColor];
}

- (void)setBadgeStyle:(BadgeStyle)type value:(NSString *)badgeValue atIndex:(NSInteger)index
{
    if (index >= self.items.count) {
        return;
    }
    
    if( ![[self valueForKey:kBadgeViewInitedKey] boolValue] ) {
        [self setValue:@(YES) forKey:kBadgeViewInitedKey];
        [self addBadgeViews];
    }
    NSMutableArray *badgeDotViews = [self valueForKey:kBadgeDotViewsKey];
    NSMutableArray *badgeNumberViews = [self valueForKey:kBadgeNumberViewsKey];
    
    [badgeDotViews[index] setHidden:YES];
    [badgeNumberViews[index] setHidden:YES];
    
    if(type == kCustomBadgeStyleRedDot) {
        [badgeDotViews[index] setHidden:NO];
    } else if(type == kCustomBadgeStyleNumber) {
        if (!badgeValue || badgeValue.length == 0 || badgeValue.integerValue <= 0) {
            return;
        }
        [badgeNumberViews[index] setHidden:NO];
        UILabel *label = badgeNumberViews[index];
        [self adjustBadgeNumberViewWithLabel:label number:badgeValue];
    } else if(type == kCustomBadgeStyleNone) {
        
    }
}

- (void)setBadgeNumberValue:(NSInteger )badgeValue atIndex:(NSInteger)index
{
    [self setBadgeStyle:kCustomBadgeStyleNumber
                  value:[NSString stringWithFormat:@"%ld", badgeValue]
                atIndex:index];
}

- (void)setBadgeRedDotValue:(NSInteger )badgeValue atIndex:(NSInteger)index
{
    [self setBadgeStyle:kCustomBadgeStyleRedDot
                  value:[NSString stringWithFormat:@"%ld", badgeValue]
                atIndex:index];
}

- (void)addBadgeViews
{
    id idIconWith = [self valueForKey:kTabIconWidth];
    CGFloat tabIconWidth = idIconWith ? [idIconWith floatValue] : 36;
    id idBadgeTop = [self valueForKey:kBadgeTop];
    CGFloat badgeTop = idBadgeTop ? [idBadgeTop floatValue] : 10;
    id idBadgeColor = [self valueForKey:kBbadgeColor];
    UIColor *badgeColor = idBadgeColor ? (UIColor *)idBadgeColor : [UIColor whiteColor];
    id idBadgeBackgroundColor = [self valueForKey:kBadgeBackgroundColor];
    UIColor *badgeBackgroundColor = idBadgeBackgroundColor ? (UIColor *)idBadgeBackgroundColor : [UIColor redColor];
    
    NSInteger itemsCount = self.items.count;
    CGFloat itemWidth = self.bounds.size.width / itemsCount;
    
    // dot views
    NSMutableArray *badgeDotViews = [NSMutableArray new];
    for(int i = 0;i < itemsCount;i ++){
        UIView *redDot = [UIView new];
        redDot.bounds = CGRectMake(0, 0, 7, 7);
        redDot.center = CGPointMake(itemWidth*(i+0.5)+tabIconWidth/3.5, badgeTop*0.8);
        redDot.layer.cornerRadius = redDot.bounds.size.width/2;
        redDot.clipsToBounds = YES;
        redDot.backgroundColor = badgeBackgroundColor ? badgeBackgroundColor : [UIColor redColor];
        redDot.hidden = YES;
        [self addSubview:redDot];
        [badgeDotViews addObject:redDot];
    }
    [self setValue:badgeDotViews forKey:kBadgeDotViewsKey];
    
    // number views
    NSMutableArray *badgeNumberViews = [NSMutableArray new];
    for(int i = 0;i < itemsCount;i ++){
        UILabel *redNum = [UILabel new];
        redNum.layer.anchorPoint = CGPointMake(0, 0.5);
        redNum.bounds = CGRectMake(0, 0, 20, 18);
        redNum.center = CGPointMake(itemWidth*(i+0.54)+tabIconWidth/2-10, badgeTop);
        redNum.layer.cornerRadius = redNum.bounds.size.height/2;
        redNum.clipsToBounds = YES;
        redNum.backgroundColor = badgeBackgroundColor ? badgeBackgroundColor : [UIColor redColor];
        redNum.hidden = YES;

        redNum.textAlignment = NSTextAlignmentCenter;
        redNum.font = [UIFont systemFontOfSize:CFC_AUTOSIZING_FONT(11)];
        redNum.textColor = badgeColor ? badgeColor : [UIColor redColor];
        
        [self addSubview:redNum];
        [badgeNumberViews addObject:redNum];
    }
    [self setValue:badgeNumberViews forKey:kBadgeNumberViewsKey];
}

- (void)adjustBadgeNumberViewWithLabel:(UILabel *)label number:(NSString *)number
{
    NSInteger value = [number integerValue];
    [label setText:(value > 99 ? @"99+" : @(value).stringValue)];
    if(value < 10) {
        label.bounds = CGRectMake(0, 0, 18, 18);
    } else if(value <= 99) {
        label.bounds = CGRectMake(0, 0, 20, 18);
    } else {
        label.bounds = CGRectMake(0, 0, 26, 18);
    }
}

- (id)valueForUndefinedKey:(NSString *)key
{
    return objc_getAssociatedObject(self, (__bridge const void *)(key));
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    objc_setAssociatedObject(self, (__bridge const void *)(key), value, OBJC_ASSOCIATION_COPY);
}

@end
