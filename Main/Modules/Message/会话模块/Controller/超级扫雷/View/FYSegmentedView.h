//
//  FYSegmentedView.h
//  FunOnline
//
//  Created by Jetter on 2018/4/9.
//  Copyright © 2018年 iOS. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FYSegmentedView;

typedef void(^SegmentSelectedBlock)(NSInteger index);

@protocol FYSegmentedViewDelegate<NSObject>
@optional
- (void)segmentView:(FYSegmentedView *)segmentView didSelectedAtIndex:(NSInteger)index;

@end

@interface FYSegmentedView : UIView

- (instancetype)initWithOrigin:(CGPoint)origin
                        height:(CGFloat)height;

- (instancetype)initWithOrigin:(CGPoint)origin
                        height:(CGFloat)height
                        titles:(NSArray *)titles;

- (instancetype)initWithFrame:(CGRect)frame
                       titles:(NSArray *)titles;


/** 隐藏底部分割线（默认显示） */
@property (nonatomic, assign) BOOL hideLine;
/** 隐藏指示器（默认显示）*/
@property (nonatomic, assign) BOOL hideIndicator;
/** 选中的菜单字体颜色 */
@property (nonatomic, strong) UIColor *titleSelectedColor;
/** 未选中的菜单字体颜色 */
@property (nonatomic, strong) UIColor *titleNormalColor;
/** 选中的菜单字体 */
@property (nonatomic, strong) UIFont *titleSelectedFont;
/** 未选中的菜单字体 */
@property (nonatomic, strong) UIFont *titleNormalFont;

/** 指示条宽度 */
@property (nonatomic, assign) CGFloat indicatorWidth;
/** 指示条高度 */
@property (nonatomic, assign) CGFloat indicatorHeight;
/** 指示条颜色 */
@property (nonatomic, strong) UIColor *indicatorColor;
/** 设置代理 */
@property (nonatomic, weak) id<FYSegmentedViewDelegate> delegate;
/** 菜单选项标题 */
@property (nonatomic, strong) NSArray <NSString *>*segmentTitles;
/** 当前滚动范围 */
@property (nonatomic, assign, readonly) CGPoint scrollOffset;
/** 点击菜单回调 */
@property (nonatomic, copy) SegmentSelectedBlock didSelectedBlock;


/** 滚动到指定位置（并选中）*/
- (void)scrollToAtIndex:(NSInteger)index;

@end
