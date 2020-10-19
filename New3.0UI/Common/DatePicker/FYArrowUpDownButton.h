//
//  FYArrowUpDownButton.h
//  ProjectCSHB
//
//  Created by fangyuan on 2020/6/21.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^FYArrowUpDownButtonActionBlock)(void);
typedef BOOL (^FYArrowUpDownButtonCanDidBlock)(void);

@interface FYArrowUpDownButton : UIView

@property (nonatomic, copy) NSString *titleString;

@property (nonatomic, strong) UIFont *titleFontNormal;

@property (nonatomic, strong) UIFont *titleFontSelect;

@property (nonatomic, strong) UIColor *titleColorNormal;

@property (nonatomic, strong) UIColor *titleColorSelect;

@property (nonatomic, copy) FYArrowUpDownButtonActionBlock didClickActionBlock;

@property (nonatomic, copy) FYArrowUpDownButtonCanDidBlock isCanClickActionBlock; // 是否可以点击按钮，YES可以，NO不可以

- (instancetype)initWithFrame:(CGRect)frame
                        title:(NSString *)title
              titleFontNormal:(UIFont *)titleFontNormal
              titleFontSelect:(UIFont *)titleFontSelect
             titleColorNormal:(UIColor *)titleColorNormal
             titleColorSelect:(UIColor *)titleColorSelect;

- (void)setChangeButtonIndicator;
- (void)setChangeButtonIndicatorOpen:(BOOL)isIndicatorOpen;
- (void)setChangeButtonTitleValue:(NSString *)titleString;

+ (CGFloat)defaultWidth;
+ (CGFloat)defaultHeight;
+ (void)setTitleValue:(NSString *)titleString button:(FYArrowUpDownButton *)button;
+ (CGFloat)getWidthByTitleValue:(NSString *)titleString button:(FYArrowUpDownButton *)button;

@end


NS_ASSUME_NONNULL_END
