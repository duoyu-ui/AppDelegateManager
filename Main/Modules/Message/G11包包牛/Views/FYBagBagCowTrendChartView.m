//
//  FYBagBagCowTrendChartView.m
//  ProjectCSHB
//
//  Created by fangyuan on 2020/7/24.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "FYBagBagCowTrendChartView.h"
#import "FYBagBagCowTrendModel.h"

@interface FYBagBagCowTrendChartView () <UIScrollViewDelegate>
@property(nonatomic, strong) NSMutableArray<FYBagBagCowTrendChartModel *> *trendChartModels;
@property(nonatomic, assign) CGPoint trendChartScrollViewOffset;
@property(nonatomic, strong) UIScrollView *trendChartScrollView;
@property(nonatomic, strong) UIView *trendChartSlideBackView;
@property(nonatomic, strong) UIView *trendChartSliderView;
@property(nonatomic, assign) CGFloat trendChartSliderWidth;
@property(nonatomic, assign) CGFloat trendChartSliderHeight;
@property(nonatomic, assign) CGFloat trendChartItemWidth;
@property(nonatomic, assign) CGFloat trendChartItemHeight;
@end

@implementation FYBagBagCowTrendChartView

#pragma mark - Life Cycle

+ (CGFloat)headerViewHeight
{
    return SCREEN_MIN_LENGTH * 0.38f;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _trendChartSliderHeight = 4.0f;
        _trendChartSliderWidth = frame.size.width * 0.6f;
        _trendChartItemWidth = frame.size.width / 12.0f;
        _trendChartItemHeight = frame.size.height - _trendChartSliderHeight;
    }
    return self;
}

/// 刷新走势图表
- (void)refreshTrendChart:(NSMutableArray<FYBagBagCowTrendModel *> *)trendChartDataSource isBankerNumberTrendChart:(BOOL)isBankerNumberTrendChart
{
    __block NSMutableArray<FYBagBagCowTrendChartModel *> *allTrendChartModels = [NSMutableArray array];
    [trendChartDataSource enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(FYBagBagCowTrendModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (!obj.isIssuePlaying) {
            NSString *pointNumber = isBankerNumberTrendChart ? obj.bankerNumber : obj.playerNumber;
            FYBagBagCowTrendChartModel *chartModel = [FYBagBagCowTrendChartModel new];
            [chartModel setIssueNumber:obj.gameNumber];
            [chartModel setPointNumber:pointNumber];
            [chartModel setIsLastIssue:idx == 1];
            [allTrendChartModels addObj:chartModel];
        }
    }];
    
    self.trendChartModels = [NSMutableArray array];
    if (allTrendChartModels && 0 < allTrendChartModels.count) {
        [self.trendChartModels addObjectsFromArray:allTrendChartModels];
    }
    [self refreshTrendChartWithChartModels:self.trendChartModels];
}

/// 重创走势图表
- (void)refreshTrendChartWithChartModels:(NSMutableArray<FYBagBagCowTrendChartModel *> *)trendChartModels
{
    // 重建控件
    {
        [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [obj removeFromSuperview];
        }];
        [self setTrendChartScrollView:nil];
        [self setTrendChartSliderView:nil];
        [self setTrendChartSlideBackView:nil];
        //
        [self addSubview:self.trendChartSlideBackView];
        [self addSubview:self.trendChartScrollView];
        [self addSubview:self.trendChartSliderView];
    }

    //
    CGFloat margin = CFC_AUTOSIZING_MARGIN(MARGIN);
    CGFloat itemCircleSize = self.trendChartItemWidth * 0.8f;
    CGFloat itemIssueLabelHeight = self.trendChartItemWidth * 0.6f;
    CGFloat itemTopBottomGap = margin*0.5f;
    CGFloat itemCenterYOffset = (self.trendChartItemHeight-itemIssueLabelHeight-itemTopBottomGap*2.0f-itemCircleSize) / 14;
    
    // 走势折线图
    NSInteger count = trendChartModels.count;
    NSMutableArray<NSValue *> *itemCenterPoints = [NSMutableArray array];
    for (NSInteger index = 0; index < count; index ++) {
        FYBagBagCowTrendChartModel *chartModel = [trendChartModels objectAtIndex:index];
        
        // 坐标
        NSInteger percent = llabs(15 - chartModel.pointNumber.integerValue);
        CGFloat offsetCenterX = self.trendChartItemWidth*0.5f + self.trendChartItemWidth * index;
        CGFloat offsetCenterY = itemTopBottomGap + itemCircleSize*0.5f + itemCenterYOffset * percent;
        CGPoint itemCenterPoint = CGPointMake(offsetCenterX, offsetCenterY);
        NSValue *itemCenterPointValue = [NSValue valueWithCGPoint:itemCenterPoint];
        [itemCenterPoints addObject:itemCenterPointValue];
        
        // 容器
        UIColor *backgroundColor = index % 2 ? COLOR_HEXSTRING(@"#E0E0E0") : COLOR_HEXSTRING(@"#F1F1F1");
        CGRect frame = CGRectMake(self.trendChartItemWidth*index, 0, self.trendChartItemWidth, self.trendChartItemHeight);
        UIView *itemChartBackView = [[UIView alloc] initWithFrame:frame];
        [itemChartBackView setBackgroundColor:backgroundColor];
        [self.trendChartScrollView addSubview:itemChartBackView];

        // 期号
        UILabel *itemIssueLabel = ({
            UIColor *textColor = chartModel.isLastIssue ? COLOR_SYSTEM_MAIN_UI_THEME_DEFAULT : COLOR_SYSTEM_MAIN_FONT_DEFAULT;
            UILabel *label = [[UILabel alloc] init];
            [itemChartBackView addSubview:label];
            [label setText:chartModel.issueShortNumber];
            [label setFont:FONT_PINGFANG_REGULAR(13.0f)];
            [label setTextColor:textColor];
            [label setTextAlignment:NSTextAlignmentCenter];
            [label setBackgroundColor:[UIColor whiteColor]];

            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.bottom.right.equalTo(itemChartBackView);
                make.height.mas_equalTo(itemIssueLabelHeight);
            }];

            label;
        });
        itemIssueLabel.mas_key = @"itemIssueLabel";
    }
    [self.trendChartScrollView setContentSize:CGSizeMake(self.trendChartItemWidth*count, 0)];
    [self refreshTrendChartScrollViewOffset:self.trendChartScrollViewOffset];
    [self refreshTrendChartPathWithPoints:itemCenterPoints];
    
    // 标题
    for (NSInteger index = 0; index < count; index ++) {
        NSValue *itemCenterPointValue = [itemCenterPoints objectAtIndex:index];
        FYBagBagCowTrendChartModel *chartModel = [trendChartModels objectAtIndex:index];
        
        // 标题
        UILabel *itemCircleLabel = ({
            UILabel *label = [[UILabel alloc] init];
            [self.trendChartScrollView addSubview:label];
            [label setText:chartModel.pointNumberTitle];
            [label setFont:chartModel.pointNumberTitleFont];
            [label setTextColor:chartModel.pointNumberTitleColor];
            [label setBackgroundColor:chartModel.pointNumberBackColor];
            [label setTextAlignment:NSTextAlignmentCenter];
            [label addCornerRadius:itemCircleSize*0.5f];

            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(itemCircleSize, itemCircleSize));
                make.centerX.equalTo(self.trendChartScrollView.mas_left).offset(itemCenterPointValue.CGPointValue.x);
                make.centerY.equalTo(self.trendChartScrollView.mas_top).offset(itemCenterPointValue.CGPointValue.y);
            }];

            label;
        });
        itemCircleLabel.mas_key = @"itemCircleLabel";
    }
}

- (void)refreshTrendChartScrollViewOffset:(CGPoint)trendChartScrollViewOffset
{
    CGPoint offset = trendChartScrollViewOffset;
    CGRect frame = self.trendChartSliderView.frame;
    frame.origin.x = offset.x*(self.trendChartSlideBackView.frame.size.width-self.trendChartSliderView.frame.size.width)/(self.trendChartScrollView.contentSize.width-self.trendChartScrollView.frame.size.width);
    self.trendChartSliderView.frame = frame;
    
    [self.trendChartScrollView setContentOffset:trendChartScrollViewOffset];
}

// 绘制线路
- (void)refreshTrendChartPathWithPoints:(NSArray *)points
{
    UIBezierPath *path = [UIBezierPath bezierPath];
    for (int index = 0; index < points.count; index ++) {
        if (index == 0) {
            [path moveToPoint:[points[0] CGPointValue]];
        } else {
            [path addLineToPoint:[points[index] CGPointValue]];
        }
    }
    
    // layer
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.lineWidth = 2.0f;
    layer.fillColor = [UIColor clearColor].CGColor;
    layer.strokeColor = COLOR_HEXSTRING(@"#6B6B6B").CGColor;
    layer.path = path.CGPath;
    [self.trendChartScrollView.layer addSublayer:layer];
    
    // animation
    CABasicAnimation *basicAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    basicAnimation.fromValue = @(0);
    basicAnimation.toValue = @(1);
    basicAnimation.duration = 1;
    basicAnimation.repeatCount = 1;
    basicAnimation.removedOnCompletion = YES;
    basicAnimation.fillMode = kCAFillModeForwards;
    [layer addAnimation:basicAnimation forKey:@"AnimationMoveTrendChartPath"];
}


#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self setTrendChartScrollViewOffset:scrollView.contentOffset];
    
    [UIView animateWithDuration:0.5 animations:^{
        CGPoint offset = scrollView.contentOffset;
        CGRect frame = self.trendChartSliderView.frame;
        frame.origin.x = offset.x*(self.trendChartSlideBackView.frame.size.width-self.trendChartSliderView.frame.size.width)/(scrollView.contentSize.width-scrollView.frame.size.width);
        self.trendChartSliderView.frame = frame;
    }];
}


#pragma mark - Getter & Setter

- (NSMutableArray *)trendChartModels
{
    if (!_trendChartModels) {
        _trendChartModels = [NSMutableArray array];
    }
    return _trendChartModels;
}

- (UIScrollView *)trendChartScrollView
{
    if (!_trendChartScrollView) {
        CGRect frame = CGRectMake(0, 0, self.width, self.height - self.trendChartSliderHeight);
        _trendChartScrollView = [[UIScrollView alloc] initWithFrame:frame];
        _trendChartScrollView.delegate = self;
        _trendChartScrollView.scrollEnabled = YES;
        _trendChartScrollView.bounces = YES;
        _trendChartScrollView.showsHorizontalScrollIndicator = NO;
        _trendChartScrollView.decelerationRate = UIScrollViewDecelerationRateFast;
    }
    return _trendChartScrollView;
}

- (UIView *)trendChartSlideBackView
{
    if (!_trendChartSlideBackView) {
        CGRect frame = CGRectMake(0, self.height-self.trendChartSliderHeight, self.width, self.trendChartSliderHeight);
        _trendChartSlideBackView = [[UIView alloc] initWithFrame:frame];
        _trendChartSlideBackView.backgroundColor = COLOR_HEXSTRING(@"#C5C5C5");
    }
    return _trendChartSlideBackView;
}

- (UIView *)trendChartSliderView
{
    if (!_trendChartSliderView) {
        CGFloat offset = 1.0f;
        CGRect frame = CGRectMake(self.trendChartSlideBackView.x, self.trendChartSlideBackView.y+offset*0.5f, self.trendChartSliderWidth, self.trendChartSliderHeight-offset);
        _trendChartSliderView = [[UIView alloc] initWithFrame:frame];
        _trendChartSliderView.backgroundColor = COLOR_SYSTEM_MAIN_UI_THEME_DEFAULT;
    }
    return _trendChartSliderView;
}

@end


@implementation FYBagBagCowTrendChartModel

- (NSString *)issueShortNumber
{
    if (VALIDATE_STRING_EMPTY(self.issueNumber)) {
        return self.issueNumber;
    }
    
    if (self.issueNumber.length < 3) {
        return self.issueNumber;
    }
    
    return [self.issueNumber substringFromIndex:self.issueNumber.length-3];
}

- (NSString *)pointNumberTitle
{
    NSString *result = @"-";
    NSString *number = self.pointNumber;
    if (1 == number.integerValue) {
        result = NSLocalizedString(@"牛一", nil);
    } else if (2 == number.integerValue) {
        result = NSLocalizedString(@"牛二", nil);
    } else if (3 == number.integerValue) {
        result = NSLocalizedString(@"牛三", nil);
    } else if (4 == number.integerValue) {
        result = NSLocalizedString(@"牛四", nil);
    } else if (5 == number.integerValue) {
        result = NSLocalizedString(@"牛五", nil);
    } else if (6 == number.integerValue) {
        result = NSLocalizedString(@"牛六", nil);
    } else if (7 == number.integerValue) {
        result = NSLocalizedString(@"牛七", nil);
    } else if (8 == number.integerValue) {
        result = NSLocalizedString(@"牛八", nil);
    } else if (9 == number.integerValue) {
        result = NSLocalizedString(@"牛九", nil);
    } else if (10 == number.integerValue) {
        result = NSLocalizedString(@"牛牛", nil);
    } else if (11 == number.integerValue) {
        result = NSLocalizedString(@"金牛", nil);
    } else if (12 == number.integerValue) {
        result = NSLocalizedString(@"对子", nil);
    } else if (13 == number.integerValue) {
        result = NSLocalizedString(@"正顺", nil);
    } else if (14 == number.integerValue) {
        result = NSLocalizedString(@"倒顺", nil);
    } else if (15 == number.integerValue) {
        result = NSLocalizedString(@"豹子", nil);
    }
    return result;
}

- (UIColor *)pointNumberBackColor
{
    NSString *number = self.pointNumber;
    if (number.integerValue <= 6) {
        return COLOR_HEXSTRING(@"#3875F6");
    }
    return COLOR_SYSTEM_MAIN_UI_THEME_DEFAULT;
}

- (UIFont *)pointNumberTitleFont
{
    return FONT_PINGFANG_REGULAR(12.0f);
}

- (UIColor *)pointNumberTitleColor
{
    return COLOR_HEXSTRING(@"#FFFFFF");
}


@end
