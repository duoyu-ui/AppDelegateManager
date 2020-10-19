//
//  FYJSSLGameTrendTableViewCell.m
//  ProjectCSHB
//
//  Created by fangyuan on 2020/8/28.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "FYJSSLGameTrendTableViewCell.h"
#import "FYJSSLGameTrendModel.h"

@interface FYJSSLGameTrendTableViewCell ()
/**
 * 根容器组件
 */
@property (nonatomic, strong) UIView *rootContainerView;
/**
 * 公共容器
 */
@property (nonatomic, strong) UIView *publicContainerView;
/**
 * 期数控件
 */
@property (nonatomic, strong) UILabel *column1Label;
/**
 * 开奖号码
 */
@property (nonatomic, strong) UILabel *column2Label;
/**
 * 分割线控件
 */
@property (nonatomic, strong) UIView *separatorLineView;
/**
 * 开奖结果
 */
@property (nonatomic, strong) NSMutableArray <UILabel *> *resultDrawLabels;
@property (nonatomic, strong) NSMutableArray <UIImageView *> *resultDrawViews;

@end


@implementation FYJSSLGameTrendTableViewCell

+ (NSString *)reuseIdentifier
{
    return NSStringFromClass(self);
}

+ (CGFloat)headerViewHeight
{
    return 40.0f;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = UIColor.whiteColor;
        [self createViewAtuoLayout];
    }
    return self;
}

#pragma mark - 创建子控件
- (void)createViewAtuoLayout
{
    UIFont *itemFont = FONT_PINGFANG_REGULAR(14);
    UIColor *itemColor = COLOR_SYSTEM_MAIN_FONT_DEFAULT;
    NSArray<NSNumber *> *percents = @[ @(0.3f), @(1.0f) ];
    
    [self.contentView setBackgroundColor:[UIColor whiteColor]];
    
    UILabel *column1Label = ({
        UILabel *label = [UILabel new];
        [self.contentView addSubview:label];
        [label setText:STR_APP_TEXT_PLACEHOLDER];
        [label setFont:itemFont];
        [label setTextColor:itemColor];
        [label setTextAlignment:NSTextAlignmentCenter];
        
        CGFloat percent = [percents objectAtIndex:0].floatValue;
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView.mas_right).multipliedBy(percent);
            make.left.equalTo(self.contentView.mas_left);
            make.centerY.equalTo(self.contentView.mas_centerY);
        }];
        
        label;
    });
    self.column1Label = column1Label;
    self.column1Label.mas_key = @"column1Label";
    
    UILabel *column2Label = ({
        UILabel *label = [UILabel new];
        [self.contentView addSubview:label];
        [label setFont:itemFont];
        [label setTextColor:itemColor];
        [label setTextAlignment:NSTextAlignmentCenter];
        
        CGFloat percent = [percents objectAtIndex:1].floatValue;
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView.mas_right).multipliedBy(percent);
            make.left.equalTo(column1Label.mas_right);
            make.centerY.equalTo(self.contentView.mas_centerY);
        }];
        
        label;
    });
    self.column2Label = column2Label;
    self.column2Label.mas_key = @"column2Label";
    
    {
        NSInteger count = 5;
        CGFloat percent1 = [percents objectAtIndex:0].floatValue;
        CGFloat percent2 = [percents objectAtIndex:1].floatValue;
        CGFloat container_width = SCREEN_MIN_LENGTH * (percent2 - percent1);
        CGFloat margin_left_right = SCREEN_MIN_LENGTH * 0.14f;
        CGFloat draw_gap = 5.0f;
        CGFloat draw_width = (container_width-margin_left_right*2.0f-draw_gap*(count-1)) / count;
        CGFloat draw_height = draw_width;
        if (draw_height > [[self class] headerViewHeight]) {
            draw_height = [[self class] headerViewHeight] * 0.8f;
            draw_width = draw_height;
            margin_left_right = (container_width-draw_gap*(count-1)-draw_width*count) * 0.5f;
        }
        
        _resultDrawLabels = [NSMutableArray array];
        _resultDrawViews = [NSMutableArray array];
        UIImageView *lastResultView = nil;
        for (NSInteger idx = 0; idx < count; idx ++) {
            // 背景
            UIImageView *resultDrawView = [[UIImageView alloc] init];
            [self.column2Label addSubview:resultDrawView];
            [resultDrawView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(draw_width);
                make.height.mas_equalTo(draw_height);
                make.centerY.equalTo(self);
                if (!lastResultView) {
                    make.left.mas_equalTo(self.column2Label).offset(margin_left_right);
                } else {
                    make.left.mas_equalTo(lastResultView.mas_right).offset(draw_gap);
                }
            }];
            if (0 == idx) {
                [resultDrawView setImage:[UIImage imageNamed:@"jssl_wan_icon_sel"]];
            } else if (1 == idx) {
                [resultDrawView setImage:[UIImage imageNamed:@"jssl_qian_icon_sel"]];
            } else if (2 == idx) {
                [resultDrawView setImage:[UIImage imageNamed:@"jssl_bai_icon_sel"]];
            } else if (3 == idx) {
                [resultDrawView setImage:[UIImage imageNamed:@"jssl_shi_icon_sel"]];
            } else if (4 == idx) {
                [resultDrawView setImage:[UIImage imageNamed:@"jssl_ge_icon_sel"]];
            }
            
            // 号码
            UILabel *resultDrawLabel = ({
                UILabel *label = [UILabel new];
                [resultDrawView addSubview:label];
                [label setText:@"?"];
                [label setFont:FONT_PINGFANG_BOLD(14)];
                [label setTextColor:[UIColor whiteColor]];
                [label setTextAlignment:NSTextAlignmentCenter];
                
                [label mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerX.equalTo(resultDrawView.mas_centerX);
                    make.centerY.equalTo(resultDrawView.mas_centerY);
                }];
                
                label;
            });
            //
            [self.resultDrawViews addObj:resultDrawView];
            [self.resultDrawLabels addObj:resultDrawLabel];
            //
            lastResultView = resultDrawView;
        }
    }
    
    UIView *splitLineViewV1 = ({
        UIView *view = [[UIView alloc] init];
        [view setBackgroundColor:COLOR_TABLEVIEW_SEPARATOR_LINE_DEFAULT];
        [self.contentView addSubview:view];
        
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self.contentView);
            make.centerX.equalTo(self.column1Label.mas_right);
            make.width.mas_equalTo(SEPARATOR_LINE_HEIGHT);
        }];
        
        view;
    });
    splitLineViewV1.mas_key = @"splitLineViewV1";
    
    UIView *separatorLineView = ({
        UIView *view = [[UIView alloc] init];
        [view setBackgroundColor:COLOR_TABLEVIEW_SEPARATOR_LINE_DEFAULT];
        [self.contentView addSubview:view];
        
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.contentView.mas_bottom);
            make.left.equalTo(self.contentView.mas_left);
            make.right.equalTo(self.contentView.mas_right);
            make.height.mas_equalTo(SEPARATOR_LINE_HEIGHT);
        }];
        
        view;
    });
    self.separatorLineView = separatorLineView;
    self.separatorLineView.mas_key = @"separatorLineView";
}

#pragma mark - 设置数据模型
- (void)setModel:(FYJSSLGameTrendModel *)model
{
    if (![model isKindOfClass:[FYJSSLGameTrendModel class]]) {
        return;
    }
    
    _model = model;

    // 期数
    [self.column1Label setText:[NSString stringWithFormat:@"%@", self.model.gameNumber]];
    
    // 开奖号码
    if (self.model.isIssuePlaying) {
        [self.column2Label setText: @"?"];
        for (NSInteger idx = 0; idx < self.resultDrawViews.count; idx ++) {
            UIImageView *imageView = [self.resultDrawViews objectAtIndex:idx];
            [imageView setHidden:YES];
        }
    } else {
        [self.column2Label setText: @""];
        for (NSInteger idx = 0; idx < self.resultDrawViews.count; idx ++) {
            UIImageView *imageView = [self.resultDrawViews objectAtIndex:idx];
            [imageView setHidden:NO];
            //
            UILabel *resultLable = [self.resultDrawLabels objectAtIndex:idx];
            if (0 == idx) {
                [resultLable setText:self.model.myriad];
            } else if (1 == idx) {
                [resultLable setText:self.model.thousand];
            } else if (2 == idx) {
                [resultLable setText:self.model.hundred];
            } else if (3 == idx) {
                [resultLable setText:self.model.ten];
            } else if (4 == idx) {
                [resultLable setText:self.model.individual];
            }
        }
    }
}


@end

