//
//  FYGameReportTableViewCell.m
//  ProjectCSHB
//
//  Created by fangyuan on 2020/6/25.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "FYGameReportTableViewCell.h"
#import "FYGameReportModel.h"


@interface FYGameReportTableViewCell ()
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
@property (nonatomic, strong) UILabel *issueLabel;
/**
 * 投注控件
 */
@property (nonatomic, strong) UILabel *bettingLabel;
/**
 * 盈亏控件
 */
@property (nonatomic, strong) UILabel *profitLossLabel;
/**
 * 时间控件 - 年月日
 */
@property (nonatomic, strong) UILabel *datetimeLabel;
/**
 * 时间控件 - 时分秒
 */
@property (nonatomic, strong) UILabel *hourMinuteSecondLabel;
/**
 * 分割线控件
 */
@property (nonatomic, strong) UIView *separatorLineView;

@end


@implementation FYGameReportTableViewCell

+ (NSString *)reuseIdentifier
{
    return NSStringFromClass(self);
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
    CGFloat margin = CFC_AUTOSIZING_MARGIN(MARGIN);
    CGFloat itemWidth = SCREEN_WIDTH * 0.25f;
    UIFont *itemFont = FONT_PINGFANG_REGULAR(14);
    UIColor *itemColor = COLOR_SYSTEM_MAIN_FONT_DEFAULT;
    
    // 根容器
    UIView *rootContainerView = ({
        UIView *view = [[UIView alloc] init];
        [view setBackgroundColor:[UIColor whiteColor]];
        [self.contentView insertSubview:view atIndex:0];
        
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@0.0f);
            make.top.equalTo(@0.0f);
            make.right.equalTo(@0.0f);
            make.bottom.equalTo(self.contentView.mas_bottom);
        }];
        
        view;
    });
    self.rootContainerView = rootContainerView;
    self.rootContainerView.mas_key = @"rootContainerView";
    
    // 公共容器
    UIView *publicContainerView = ({
        UIView *view = [[UIView alloc] init];
        [view.layer setMasksToBounds:YES];
        [rootContainerView addSubview:view];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pressPublicItemView:)];
        [view addGestureRecognizer:tapGesture];
        
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(rootContainerView.mas_left);
            make.top.equalTo(rootContainerView.mas_top);
            make.right.equalTo(rootContainerView.mas_right);
            make.bottom.equalTo(rootContainerView.mas_bottom);
        }];
        
        view;
    });
    self.publicContainerView = publicContainerView;
    self.publicContainerView.mas_key = @"publicContainerView";
    
    // 期数控件
    UILabel *issueLabel = ({
        UILabel *label = [UILabel new];
        [publicContainerView addSubview:label];
        [label setText:STR_APP_TEXT_PLACEHOLDER];
        [label setFont:itemFont];
        [label setTextColor:itemColor];
        [label setTextAlignment:NSTextAlignmentCenter];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(itemWidth);
            make.left.equalTo(publicContainerView.mas_left);
            make.centerY.equalTo(publicContainerView.mas_centerY);
        }];
        
        label;
    });
    self.issueLabel = issueLabel;
    self.issueLabel.mas_key = @"issueLabel";
    
    // 投注控件
    UILabel *bettingLabel = ({
        UILabel *label = [UILabel new];
        [publicContainerView addSubview:label];
        [label setText:STR_APP_TEXT_PLACEHOLDER];
        [label setFont:itemFont];
        [label setTextColor:itemColor];
        [label setTextAlignment:NSTextAlignmentCenter];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(itemWidth);
            make.left.equalTo(issueLabel.mas_right);
            make.centerY.equalTo(publicContainerView.mas_centerY);
        }];
        
        label;
    });
    self.bettingLabel = bettingLabel;
    self.bettingLabel.mas_key = @"bettingLabel";
    
    // 盈亏控件
    UILabel *profitLossLabel = ({
        UILabel *label = [UILabel new];
        [publicContainerView addSubview:label];
        [label setText:STR_APP_TEXT_PLACEHOLDER];
        [label setFont:itemFont];
        [label setTextColor:itemColor];
        [label setTextAlignment:NSTextAlignmentCenter];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(itemWidth);
            make.left.equalTo(bettingLabel.mas_right);
            make.centerY.equalTo(publicContainerView.mas_centerY);
        }];
        
        label;
    });
    self.profitLossLabel = profitLossLabel;
    self.profitLossLabel.mas_key = @"profitLossLabel";
    
    // 时间控件 - 年月日
    UILabel *datetimeLabel = ({
        UILabel *label = [UILabel new];
        [publicContainerView addSubview:label];
        [label setFont:FONT_PINGFANG_REGULAR(13)];
        [label setTextColor:itemColor];
        [label setTextAlignment:NSTextAlignmentCenter];

        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(itemWidth);
            make.left.equalTo(profitLossLabel.mas_right);
            make.bottom.equalTo(publicContainerView.mas_centerY);
        }];
        
        label;
    });
    self.datetimeLabel = datetimeLabel;
    self.datetimeLabel.mas_key = @"datetimeLabel";
    
    // 时间控件 - 时分秒
    UILabel *hourMinuteSecondLabel = ({
        UILabel *label = [UILabel new];
        [publicContainerView addSubview:label];
        [label setFont:FONT_PINGFANG_REGULAR(13)];
        [label setTextAlignment:NSTextAlignmentCenter];
        [label setTextColor:COLOR_SYSTEM_MAIN_FONT_ASSIST_DEFAULT];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(datetimeLabel.mas_left);
            make.right.equalTo(datetimeLabel.mas_right);
            make.top.equalTo(publicContainerView.mas_centerY);
        }];
        
        label;
    });
    self.hourMinuteSecondLabel = hourMinuteSecondLabel;
    self.hourMinuteSecondLabel.mas_key = @"hourMinuteSecondLabel";
    
    // 分割线
    UIView *separatorLineView = ({
        UIView *view = [[UIView alloc] init];
        [view setBackgroundColor:COLOR_TABLEVIEW_SEPARATOR_LINE_DEFAULT];
        [publicContainerView addSubview:view];
        
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(issueLabel.mas_bottom).offset(margin*1.5f);
            make.left.equalTo(publicContainerView.mas_left);
            make.right.equalTo(publicContainerView.mas_right);
            make.height.mas_equalTo(SEPARATOR_LINE_HEIGHT);
        }];
        
        view;
    });
    self.separatorLineView = separatorLineView;
    self.separatorLineView.mas_key = @"separatorLineView";
    
    // 约束的完整性
    [publicContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(separatorLineView.mas_bottom).priority(749);
    }];
}

#pragma mark - 设置数据模型
- (void)setModel:(FYGameReportModel *)model
{
    if (![model isKindOfClass:[FYGameReportModel class]]) {
        return;
    }
    
    _model = model;

    // 期数
    [self.issueLabel setText:[NSString stringWithFormat:@"%@", self.model.sendRedId]];
    
    // 投注
    [self.bettingLabel setText:[NSString stringWithFormat:@"%.2f", self.model.betMoney.floatValue]];
    
    // 盈亏
    if (model.money.floatValue == 0) {
        NSDictionary *attrText = @{ NSForegroundColorAttributeName:COLOR_SYSTEM_MAIN_FONT_DEFAULT};
        NSString *content = [NSString stringWithFormat:@"%.2f", fabs(self.model.money.floatValue)];
        NSAttributedString *attrString = [CFCSysUtil attributedString:@[content] attributeArray:@[attrText]];
        [self.profitLossLabel setAttributedText:attrString];
    } else if (model.money.floatValue < 0) {
        NSDictionary *attrText = @{ NSForegroundColorAttributeName:COLOR_SYSTEM_MAIN_FONT_DEFAULT};
        NSString *content = [NSString stringWithFormat:@"- %.2f", fabs(self.model.money.floatValue)];
        NSAttributedString *attrString = [CFCSysUtil attributedString:@[content] attributeArray:@[attrText]];
        [self.profitLossLabel setAttributedText:attrString];
    } else {
        NSDictionary *attrText = @{ NSForegroundColorAttributeName:COLOR_SYSTEM_MAIN_UI_THEME_DEFAULT};
        NSString *content = [NSString stringWithFormat:@"+ %.2f", fabs(self.model.money.floatValue)];
        NSAttributedString *attrString = [CFCSysUtil attributedString:@[content] attributeArray:@[attrText]];
        [self.profitLossLabel setAttributedText:attrString];
    }
    
    // 时间
    [self.datetimeLabel setText:[FYDateUtil dateFormattingWithDateString:model.createTime dateFormate:kFYDatePickerFormatDateFull toFormate:kFYDatePickerFormatYearMonthDay]];
    [self.hourMinuteSecondLabel setText:[FYDateUtil dateFormattingWithDateString:model.createTime dateFormate:kFYDatePickerFormatDateFull toFormate:kFYDatePickerFormatTimeAndSecond]];
}


#pragma mark - 触发操作事件
- (void)pressPublicItemView:(UITapGestureRecognizer *)gesture
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectRowAtGameReportModel:indexPath:)]) {
        [self.delegate didSelectRowAtGameReportModel:self.model indexPath:self.indexPath];
    }
}


@end

