//
//  FYSegmentedView.m
//  FunOnline
//
//  Created by Jetter on 2018/4/9.
//  Copyright © 2018年 iOS. All rights reserved.
//

#import "FYSegmentedView.h"
#import "UIView+SSAdd.h"

#define kBASE_SEGMNRT_TAG   1000

@interface FYSegmentedView()

/** 可滚动容器 */
@property (nonatomic, strong) UIScrollView *segmentedView;
/** 保存所有的按钮 */
@property (nonatomic, strong) NSMutableArray *btnArray;
/** 标题数组 */
@property (nonatomic, strong) NSArray *titles;
/** 记录选中的按钮 */
@property (nonatomic, strong) UIButton *selectedBtn;
/** 滚动索引条 */
@property (nonatomic, strong) UIView *indicatorView;
/** 底部分割线 */
@property (nonatomic, strong) UIView *lineView;

@property (nonatomic, strong) UIFont *selectedFont;

@property (nonatomic, strong) UIFont *unSelectFont;

@end


@implementation FYSegmentedView

#pragma mark - Lazy

- (UIFont *)selectedFont {
    
    if (!_selectedFont) {
        
        _selectedFont = [UIFont systemFontOfSize:16];
    }
    return _selectedFont;
}

- (UIFont *)unSelectFont {
    
    if (!_unSelectFont) {
        
        _unSelectFont = [UIFont systemFontOfSize:16];
    }
    return _unSelectFont;
}

- (NSMutableArray *)btnArray {
    
    if (!_btnArray) {
        
        _btnArray = [NSMutableArray array];
    }
    return _btnArray;
}


#pragma mark - Life Cycle

- (instancetype)initWithOrigin:(CGPoint)origin height:(CGFloat)height
{
    if (self = [super initWithFrame:CGRectMake(origin.x, origin.y, [UIScreen mainScreen].bounds.size.width, height)]) {
        self.backgroundColor = HexColor(@"#EDEDED");;
        
        if (self.titles == nil) {
            self.titles = [[NSArray alloc] init];
        }
    }
    return self;
}

- (instancetype)initWithOrigin:(CGPoint)origin height:(CGFloat)height titles:(NSArray *)titles
{
    return [self initWithFrame:CGRectMake(origin.x, origin.y, [UIScreen mainScreen].bounds.size.width, height) titles:titles];
}

- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray *)titles
{
    if (self = [super initWithFrame:frame]) {
        if (titles && titles.count) {
            self.titles = titles;
            [self setupSegmentView];
        }
    }
    return self;
}

- (void)setupSegmentView {
    if (self.segmentedView.subviews) { //移除所有子视图
        [self.segmentedView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
    
    CGFloat itemWidth  = SCREEN_WIDTH / self.titles.count;
    CGFloat itemHeight = 30;
    
    CGFloat maxH = 0.5;
    self.segmentedView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.frame.size.height - maxH)];
    self.segmentedView.contentSize = CGSizeMake(itemWidth * self.titles.count, 0);
    self.segmentedView.showsHorizontalScrollIndicator = NO;
    [self addSubview:self.segmentedView];
    
    CGFloat maxY = CGRectGetMaxY(self.segmentedView.frame) - maxH;
    self.lineView = [[UIView alloc] initWithFrame:CGRectMake(0, maxY, SCREEN_WIDTH, maxH)];
    self.lineView.backgroundColor = [UIColor colorWithHexString:@"e8e8e8"];
    self.lineView.hidden = NO;
    [self addSubview:self.lineView];
    
    CGFloat itemY = (self.segmentedView.frame.size.height - itemHeight) * 0.5;
    UIColor *selectedColor = self.titleSelectedColor ? self.titleSelectedColor : [UIColor colorWithHexString:@"#ff3535"];
    
    self.indicatorView = [[UIView alloc] init];
    self.indicatorView.backgroundColor = selectedColor;
    
    for (NSInteger index = 0; index < self.titles.count; index++)
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(index * itemWidth, itemY, itemWidth, itemHeight);
        button.titleLabel.font = self.unSelectFont;
        button.titleLabel.textAlignment = NSTextAlignmentCenter;
        [button setTitle:self.titles[index] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
        [button setTitleColor:selectedColor forState:UIControlStateSelected];
        [self.segmentedView addSubview:button];
        button.tag = index + kBASE_SEGMNRT_TAG; //绑定tag值
        [button addTarget:self action:@selector(segmentedClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.btnArray addObject:button];
        
        if (index == 0) {
            CGFloat h = 2.5;
            CGFloat y = self.segmentedView.height - h - maxH;
            [button.titleLabel sizeToFit];
            
            self.indicatorView.y       = y;
            self.indicatorView.height  = h;
            self.indicatorView.width   = self.indicatorWidth ? self.indicatorWidth : itemWidth;
            self.indicatorView.centerX = button.centerX;
            [self.segmentedView addSubview:self.indicatorView];
            
            button.selected = YES;
            button.titleLabel.font = self.selectedFont;
            self.selectedBtn = button;
        }
    }
}


#pragma mark - setter / getter

- (void)setIndicatorWidth:(CGFloat)indicatorWidth {
    _indicatorWidth = indicatorWidth;
    
    for (UIView *view in self.segmentedView.subviews) {
        if ([view isKindOfClass:[UIView class]]) {
            self.indicatorView.width = indicatorWidth;
            if (self.btnArray.count > 0) {
                UIButton *button = [self.btnArray firstObject];
                self.indicatorView.centerX = button.centerX;
            }
        }
    }
}

- (void)setIndicatorHeight:(CGFloat)indicatorHeight {
    _indicatorHeight = indicatorHeight;
    
    for (UIView *view in self.segmentedView.subviews) {
        if ([view isKindOfClass:[UIView class]]) {
            self.indicatorView.height = indicatorHeight;
            if (self.btnArray.count > 0) {
                UIButton *button = [self.btnArray firstObject];
                self.indicatorView.centerX = button.centerX;
            }
        }
    }
}

- (void)setIndicatorColor:(UIColor *)indicatorColor {
    _indicatorColor = indicatorColor;
    
    self.indicatorView.backgroundColor = indicatorColor;
}

- (void)setSegmentTitles:(NSArray<NSString *> *)segmentTitles {
    _segmentTitles = segmentTitles;
    
    if (segmentTitles && segmentTitles.count) {
        self.titles = segmentTitles;
        [self setupSegmentView];
    }
}

- (CGPoint)scrollOffset {
    
    return self.segmentedView.contentOffset;
}

- (void)setHideIndicator:(BOOL)hideIndicator {
    _hideIndicator = hideIndicator;
    
    self.indicatorView.hidden = hideIndicator;
}

- (void)setHideLine:(BOOL)hideLine {
    _hideLine = hideLine;
    
    self.lineView.hidden = hideLine;
}

- (void)setTitleSelectedColor:(UIColor *)titleSelectedColor {
    _titleSelectedColor = titleSelectedColor;
    
    for (UIView *view in self.segmentedView.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            [(UIButton *)view setTitleColor:titleSelectedColor forState:UIControlStateSelected];
        }
    }
}

- (void)setTitleNormalColor:(UIColor *)titleNormalColor {
    _titleNormalColor = titleNormalColor;
    
    for (UIView *view in self.segmentedView.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            [(UIButton *)view setTitleColor:titleNormalColor forState:UIControlStateNormal];
        }
    }
}

- (void)setTitleSelectedFont:(UIFont *)titleSelectedFont {
    _titleSelectedFont = titleSelectedFont;
    
    self.titleSelectedFont = titleSelectedFont;
    self.selectedBtn.titleLabel.font = titleSelectedFont;
}

- (void)setTitleNormalFont:(UIFont *)titleNormalFont {
    _titleNormalFont = titleNormalFont;
    
    self.unSelectFont = titleNormalFont;
}

#pragma mark - ScrollView Item Action

- (void)scrollToAtIndex:(NSInteger)index {
    UIButton *button = self.btnArray[index];
    self.selectedBtn.selected = NO;
    
    button.selected = YES;
    self.selectedBtn = button;
    
    [self animedScroll:button];
}

- (void)segmentedClick:(UIButton *)button {
    if (button.selected) return;
    
    self.selectedBtn.titleLabel.font = self.unSelectFont;
    self.selectedBtn.selected = !self.selectedBtn.selected;
    self.selectedBtn = button;
    button.selected = !button.selected;
    
    [self animedScroll:button];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(segmentView:didSelectedAtIndex:)]){
        [self.delegate segmentView:self didSelectedAtIndex:button.tag - kBASE_SEGMNRT_TAG];
    }
    
    if (self.didSelectedBlock){
        self.didSelectedBlock(button.tag - kBASE_SEGMNRT_TAG);
    }
}

- (void)animedScroll:(UIButton *)button {
    [UIView animateWithDuration:0.25 animations:^{
        self.indicatorView.centerX = button.centerX;
    } completion:nil];
    
    button.titleLabel.font = self.titleSelectedFont;
}

@end
