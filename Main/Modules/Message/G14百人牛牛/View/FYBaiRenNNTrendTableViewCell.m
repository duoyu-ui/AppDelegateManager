//
//  FYBaiRenNNTrendTableViewCell.m
//  ProjectCSHB
//
//  Created by fangyuan on 2020/8/27.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "FYBaiRenNNTrendTableViewCell.h"
#import "FYBestWinsLossesModel.h"
#import "FYBaiRenNNTrendModel.h"
#import "FYPockerView.h"

@interface FYBaiRenNNTrendTableViewCell ()
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
 * 胜方控件
 */
@property (nonatomic, strong) UILabel *column3Label;
/**
 * 牛数控件
 */
@property (nonatomic, strong) UILabel *column4Label;
/**
 * 分割线控件
 */
@property (nonatomic, strong) UIView *separatorLineView;
/**
 * 开奖结果
 */
@property (nonatomic, strong) NSMutableArray <FYPockerView *> *resultPockerViews;

@end


@implementation FYBaiRenNNTrendTableViewCell

+ (NSString *)reuseIdentifier
{
    return NSStringFromClass(self);
}

+ (CGFloat)height
{
    return 32.0f;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createViewAtuoLayout];
    }
    return self;
}

#pragma mark - 创建子控件
- (void)createViewAtuoLayout
{
    UIFont *itemFont = FONT_PINGFANG_REGULAR(14);
    UIColor *itemColor = COLOR_SYSTEM_MAIN_FONT_DEFAULT;
    NSArray<NSNumber *> *percents = @[ @(0.25f), @(0.65f), @(0.85f), @(1.0f) ];
    
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

    UILabel *column3Label = ({
        UILabel *label = [UILabel new];
        [self.contentView addSubview:label];
        [label setFont:FONT_PINGFANG_REGULAR(13)];
        [label setTextColor:itemColor];
        [label setTextAlignment:NSTextAlignmentCenter];

        CGFloat percent = [percents objectAtIndex:2].floatValue;
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView.mas_right).multipliedBy(percent);
            make.left.equalTo(column2Label.mas_right);
            make.centerY.equalTo(self.contentView.mas_centerY);
        }];
        
        label;
    });
    self.column3Label = column3Label;
    self.column3Label.mas_key = @"column3Label";

    UILabel *column4Label = ({
        UILabel *label = [UILabel new];
        [self.contentView addSubview:label];
        [label setText:STR_APP_TEXT_PLACEHOLDER];
        [label setFont:itemFont];
        [label setTextColor:itemColor];
        [label setTextAlignment:NSTextAlignmentCenter];
        
        CGFloat percent = [percents objectAtIndex:3].floatValue;
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView.mas_right).multipliedBy(percent);
            make.left.equalTo(column3Label.mas_right);
            make.centerY.equalTo(self.contentView.mas_centerY);
        }];
        
        label;
    });
    self.column4Label = column4Label;
    self.column4Label.mas_key = @"column4Label";
    
    {
        NSInteger count = 5;
        CGFloat percent1 = [percents objectAtIndex:0].floatValue;
        CGFloat percent2 = [percents objectAtIndex:1].floatValue;
        CGFloat container_width = SCREEN_MIN_LENGTH * (percent2 - percent1);
        CGFloat pocker_gap = 2.0f;
        CGFloat pocker_height = [[self class] height] * 0.65f;
        CGFloat pocker_width = (container_width-pocker_gap*(count+1)) / count;
        _resultPockerViews = [NSMutableArray array];
        FYPockerView *lastPockerView = nil;
        for (NSInteger idx = 0; idx < count; idx ++) {
            FYPockerView *pockerView = [[FYPockerView alloc] init];
            [self.column2Label addSubview:pockerView];
            [pockerView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(pocker_width);
                make.height.mas_equalTo(pocker_height);
                make.centerY.equalTo(self);
                if (!lastPockerView) {
                    make.left.mas_equalTo(self.column2Label).offset(pocker_gap);
                } else {
                    make.left.mas_equalTo(lastPockerView.mas_right).offset(pocker_gap);
                }
            }];
            lastPockerView = pockerView;
            [self.resultPockerViews addObj:pockerView];
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
    
    UIView *splitLineViewV2 = ({
        UIView *view = [[UIView alloc] init];
        [view setBackgroundColor:COLOR_TABLEVIEW_SEPARATOR_LINE_DEFAULT];
        [self.contentView addSubview:view];
        
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self.contentView);
            make.centerX.equalTo(self.column2Label.mas_right);
            make.width.mas_equalTo(SEPARATOR_LINE_HEIGHT);
        }];
        
        view;
    });
    splitLineViewV2.mas_key = @"splitLineViewV2";
    
    UIView *splitLineViewV3 = ({
        UIView *view = [[UIView alloc] init];
        [view setBackgroundColor:COLOR_TABLEVIEW_SEPARATOR_LINE_DEFAULT];
        [self.contentView addSubview:view];
        
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self.contentView);
            make.centerX.equalTo(self.column3Label.mas_right);
            make.width.mas_equalTo(SEPARATOR_LINE_HEIGHT);
        }];
        
        view;
    });
    splitLineViewV3.mas_key = @"splitLineViewV3";
    
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
- (void)setModel:(FYBaiRenNNTrendModel *)model
{
    if (![model isKindOfClass:[FYBaiRenNNTrendModel class]]) {
        return;
    }
    
    _model = model;

    // 期数
    [self.column1Label setText:[NSString stringWithFormat:@"%@", self.model.gameNumber]];
    
    // 开奖号码
    if (self.model.isIssuePlaying) {
        [self.column2Label setText: @"?"];
        for (NSInteger idx = 0; idx < self.resultPockerViews.count; idx ++) {
            FYPockerView *pockerView = [self.resultPockerViews objectAtIndex:idx];
            [pockerView setHidden:YES];
        }
    } else {
        [self.column2Label setText: @""];
        for (NSInteger idx = 0; idx < self.resultPockerViews.count; idx ++) {
            FYPockerView *pockerView = [self.resultPockerViews objectAtIndex:idx];
            FYBestWinsLossesPokers *pocker = idx < self.model.result.count ? [self.model.result objectAtIndex:idx] : nil;
            [pockerView setImgViewImgWithPokers:pocker flopType:1];
            [pockerView setHidden:NO];
        }
    }

    // 胜方
    if (self.model.isIssuePlaying) {
        [self.column3Label setText: @"?"];
    } else {
        NSDictionary *attrText = @{ NSForegroundColorAttributeName:COLOR_SYSTEM_MAIN_FONT_DEFAULT};
        NSDictionary *attrBlue = @{ NSForegroundColorAttributeName:HexColor(@"#38AAF6")};
        NSDictionary *attrRed = @{ NSForegroundColorAttributeName:COLOR_SYSTEM_MAIN_UI_THEME_DEFAULT};
        // 1:蓝色 2:红色
        if (1 == self.model.other) {
            NSAttributedString *attrString = [CFCSysUtil attributedString:@[NSLocalizedString(@"蓝方", nil),NSLocalizedString(@"胜", nil)] attributeArray:@[attrBlue,attrText]];
            [self.column3Label setAttributedText:attrString];
        } else {
            NSAttributedString *attrString = [CFCSysUtil attributedString:@[NSLocalizedString(@"红方", nil),NSLocalizedString(@"胜", nil)] attributeArray:@[attrRed,attrText]];
            [self.column3Label setAttributedText:attrString];
        }
    }
    
    // 牛数
    NSString *niuNumString = self.model.isIssuePlaying ? @"?" : NSLocalizedString(self.model.cattleNum, nil);
    [self.column4Label setText:niuNumString];
}


@end

