//
//  FYPayModeScrollTab.h
//  ProjectCSHB
//
//  Created by fangyuan on 2020/5/17.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FYPayModeScrollTabConfig : NSObject
@property (nonatomic, strong) NSArray<NSString *> *items;
@property (nonatomic, strong) NSArray<NSString *> *itemNormalImages;
@property (nonatomic, strong) NSArray<NSString *> *itemSelectedImages;

@property (nonatomic, strong) UIFont *font;
@property (nonatomic, assign) CGFloat itemPad;
@property (nonatomic, assign) CGFloat itemWidth;
@property (nonatomic, assign) BOOL layoutIsVertical;
@property (nonatomic, assign) BOOL showScrollIndicator;
@property (nonatomic, strong) UIColor *selectedTextColor;
@property (nonatomic, strong) UIColor *unselectedTextColor;
@property (nonatomic, strong) UIColor *selectedBackgroundColor;
@property (nonatomic, strong) UIColor *unselectedBackgroundColor;
//
@property (nonatomic, assign) BOOL showUnderlineIndicator;
@property (nonatomic, strong) UIColor *underlineIndicatorColor;
//
@property (nonatomic, assign) BOOL showCover;
@property (nonatomic, assign) CGFloat coverHeight;
@property (nonatomic, assign) CGFloat coverBorder;
@property (nonatomic, assign) CGFloat coverCornerRadius;
@property (nonatomic, strong) UIColor *coverBorderColor;
@property (nonatomic, strong) UIColor *coverBackgroundColor;

@property (assign, nonatomic, getter=isCoverGradualChangeColor) BOOL coverGradualChangeColor;
@property (strong, nonatomic) NSArray<UIColor *> *coverGradualColors;
@property (assign, nonatomic) CGPoint coverGradualStartPoint;
@property (assign, nonatomic) CGPoint coverGradualEndPoint;

@end


@interface FYPayModeScrollTab : UIView

@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) FYPayModeScrollTabConfig *config;
@property (nonatomic, copy) void (^selected)(NSString *selection, NSInteger index);

- (void)setIndex:(NSInteger)index animated:(BOOL)animated;

@end

NS_ASSUME_NONNULL_END
