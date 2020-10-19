//
//  FYArrowUpDownButton.m
//  ProjectCSHB
//
//  Created by fangyuan on 2020/6/21.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "FYArrowUpDownButton.h"


@interface FYArrowUpDownButton ()

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UIImageView *indicatorImageView;

@property (nonatomic, assign) BOOL isIndicatorOpen;

@property (nonatomic, assign) CGFloat indicatorSize;

@property (nonatomic, assign) CGFloat defBtnMinWidth;

@end


@implementation FYArrowUpDownButton

#pragma mark -
#pragma mark 构造函数
- (instancetype)initWithFrame:(CGRect)frame
                        title:(NSString *)title
              titleFontNormal:(UIFont *)titleFontNormal
              titleFontSelect:(UIFont *)titleFontSelect
             titleColorNormal:(UIColor *)titleColorNormal
             titleColorSelect:(UIColor *)titleColorSelect
{
    if (self = [super initWithFrame:frame]) {
        _titleString = title;
        _titleFontNormal = titleFontNormal;
        _titleFontSelect = titleFontSelect;
        _titleColorNormal = titleColorNormal;
        _titleColorSelect = titleColorSelect;
        _isIndicatorOpen = NO;
        _indicatorSize = CFC_AUTOSIZING_WIDTH(12.0f);
        _defBtnMinWidth = [FYArrowUpDownButton defaultWidth];
        
        // 计算图标与标题宽度
        CGFloat margin = CFC_AUTOSIZING_MARGIN(MARGIN);
        CGFloat titleWidth = [_titleString widthWithFont:_titleFontNormal constrainedToHeight:MAXFLOAT] + margin*0.5f;
        CGFloat title_indicator_gap = margin * 0.5f;
        CGFloat totalWidth = self.indicatorSize + titleWidth + title_indicator_gap;
        CGFloat titleX = (self.frame.size.width - totalWidth)/2.0f;
        // 创建图标与标题控件
        {
            // 标题
            UILabel *titleLabel = ({
                CGRect labelFrame = CGRectMake(titleX, 0, titleWidth, frame.size.height);
                UILabel *label = [[UILabel alloc] initWithFrame:labelFrame];
                [label setText:_titleString];
                [label setFont:titleFontNormal];
                [label setUserInteractionEnabled:YES];
                [label setTextAlignment:NSTextAlignmentCenter];
                [label setTextColor:_titleColorNormal];
                [self addSubview:label];
                
                label;
            });
            self.titleLabel = titleLabel;
            self.titleLabel.mas_key = @"titleLabel";
            
            // 指示
            UIImageView *indicatorImageView = ({
                CGRect imageFrame = CGRectMake(CGRectGetMaxX(titleLabel.frame) + title_indicator_gap*0.5f, (frame.size.height - self.indicatorSize)/2.0f, self.indicatorSize, self.indicatorSize);
                UIImageView *imageView = [[UIImageView alloc] initWithFrame:imageFrame];
                [imageView setUserInteractionEnabled:YES];
                [imageView setImage:[UIImage imageNamed:ICON_BILLING_QUERY_BUTTON_INDICATOR]];
                [self addSubview:imageView];

                imageView;
            });
            self.indicatorImageView = indicatorImageView;
            self.indicatorImageView.mas_key = @"indicatorImageView";
        }
        
        // 点击事件
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pressButtonAction)];
        [self addGestureRecognizer:tapGesture];
    }
    
    return self;
}

- (void)setTitleString:(NSString *)titleString
{
    _titleString = titleString;
    [self.titleLabel setText:_titleString];
    
    // 调整标题位置
    {
        // 计算模式与标题按钮宽度
        CGFloat margin = CFC_AUTOSIZING_MARGIN(MARGIN);
        CGFloat titleWidth = [_titleString widthWithFont:_titleFontNormal constrainedToHeight:MAXFLOAT] + margin*0.5f;
        CGFloat title_indicator_gap = margin * 0.5f;
        CGFloat totalWidth = self.indicatorSize + titleWidth + title_indicator_gap;
        CGFloat button_width = totalWidth + margin*1.5f;
        
        // 调整大小
        CGRect frame_button = self.frame;
        if (button_width < self.defBtnMinWidth) {
            button_width = self.defBtnMinWidth;
        }
        frame_button = CGRectMake(frame_button.origin.x, frame_button.origin.y, button_width, frame_button.size.height);
        [self setFrame:frame_button];
        
        // 标题的位置
        CGFloat titleX = (frame_button.size.width - totalWidth)/2.0f;
        CGRect titleFrame = CGRectMake(titleX, 0, titleWidth, frame_button.size.height);
        [self.titleLabel setFrame:titleFrame];
        
        // 指示器位置
        CGRect indicatorFrame = CGRectMake(CGRectGetMaxX(self.titleLabel.frame) + title_indicator_gap*0.5f, (self.frame.size.height-self.indicatorSize)/2.0f, self.indicatorSize, self.indicatorSize);
        [self.indicatorImageView setFrame:indicatorFrame];
    }
}

- (void)setChangeButtonIndicator
{
    if (_isIndicatorOpen) {
        _isIndicatorOpen = NO;
        [self.titleLabel setTextColor:self.titleColorNormal];
        [self.indicatorImageView setImage:[[UIImage imageNamed:ICON_BILLING_QUERY_BUTTON_INDICATOR] imageWithChangeColor:self.titleColorNormal]];
        [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
            self.indicatorImageView.layer.anchorPoint = CGPointMake(0.5, 0.5);
            self.indicatorImageView.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            
        }];
    } else {
        _isIndicatorOpen = YES;
        [self.titleLabel setTextColor:self.titleColorSelect];
        [self.indicatorImageView setImage:[[UIImage imageNamed:ICON_BILLING_QUERY_BUTTON_INDICATOR] imageWithChangeColor:self.titleColorSelect]];
        [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
            self.indicatorImageView.layer.anchorPoint = CGPointMake(0.5, 0.5);
            self.indicatorImageView.transform = CGAffineTransformRotate(self.indicatorImageView.transform, M_PI);
        } completion:^(BOOL finished) {
            
        }];
    }
}

- (void)setChangeButtonIndicatorOpen:(BOOL)isIndicatorOpen
{
    if (isIndicatorOpen) {
        if (_isIndicatorOpen) {
            return;
        }
        [self setChangeButtonIndicator];
    } else {
        if (!_isIndicatorOpen) {
            return;
        }
        [self setChangeButtonIndicator];
    }
}

- (void)pressButtonAction
{
    if (self.isCanClickActionBlock) {
        if (self.isCanClickActionBlock()) {
            [self setChangeButtonIndicator];
            
            if (self.didClickActionBlock) {
                self.didClickActionBlock();
            }
        }
    } else {
        [self setChangeButtonIndicator];
        
        if (self.didClickActionBlock) {
            self.didClickActionBlock();
        }
    }
}

- (void)setChangeButtonTitleValue:(NSString *)titleString
{
    // 计算模式与标题按钮宽度
    CGFloat margin = CFC_AUTOSIZING_MARGIN(MARGIN);
    CGFloat indicatorSize = CFC_AUTOSIZING_WIDTH(12.0f);
    CGFloat titleWidth = [titleString widthWithFont:self.titleFontNormal constrainedToHeight:MAXFLOAT] + margin*0.5f;
    CGFloat title_indicator_gap = margin * 0.20f;
    CGFloat button_width = indicatorSize + titleWidth + title_indicator_gap + margin*1.5f;
    // 玩法位置
    CGRect frame_button = self.frame;
    if (button_width < self.defBtnMinWidth) {
        button_width = self.defBtnMinWidth;
    }
    // 变动动画
    frame_button = CGRectMake(frame_button.origin.x, frame_button.origin.y, button_width, frame_button.size.height);
    [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [self setTitleString:titleString];
    } completion:^(BOOL finished) {
        [self setFrame:frame_button];
        [self mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(button_width);
        }];
    }];
}

+ (CGFloat)defaultWidth
{
    return SCREEN_WIDTH*0.175f;
}

+ (CGFloat)defaultHeight
{
    return 26.0f;
}

+ (void)setTitleValue:(NSString *)titleString button:(FYArrowUpDownButton *)button
{
    // 按钮宽度
    CGFloat button_width = [FYArrowUpDownButton getWidthByTitleValue:titleString button:button];
    // 变动动画
    CGRect frame_button = button.frame;
    frame_button = CGRectMake(frame_button.origin.x, frame_button.origin.y, button_width, frame_button.size.height);
    [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [button setTitleString:titleString];
    } completion:^(BOOL finished) {
        [button setFrame:frame_button];
        [button mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(button_width);
        }];
    }];
}

+ (CGFloat)getWidthByTitleValue:(NSString *)titleString button:(FYArrowUpDownButton *)button
{
    // 计算模式与标题按钮宽度
    CGFloat margin = CFC_AUTOSIZING_MARGIN(MARGIN);
    CGFloat indicatorSize = CFC_AUTOSIZING_WIDTH(12.0f);
    CGFloat titleWidth = [titleString widthWithFont:button.titleFontNormal constrainedToHeight:MAXFLOAT] + margin*0.5f;
    CGFloat title_indicator_gap = margin * 0.20f;
    CGFloat button_width = indicatorSize + titleWidth + title_indicator_gap + margin*1.5f;
    // 玩法位置
    CGFloat width = [FYArrowUpDownButton defaultWidth];
    if (button_width < width) {
        button_width = width;
    }
    return button_width;
}


@end

