//
//  FYPersonStaticItemTableViewCell.m
//  ProjectCSHB
//
//  Created by fangyuan on 2020/6/26.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "FYPersonStaticItemTableViewCell.h"
#import "FYPersonStaticItemModel.h"


@interface FYPersonStaticItemTableViewCell ()
/**
 * 根容器组件
 */
@property (nonatomic, strong) UIView *rootContainerView;
/**
 * 公共容器
 */
@property (nonatomic, strong) UIView *publicContainerView;
/**
 * 标题控件
 */
@property (nonatomic, strong) UILabel *titleLabel;
/**
 * 投注控件
 */
@property (nonatomic, strong) UILabel *bettingMoneyLabel;
/**
 * 盈亏控件
 */
@property (nonatomic, strong) UILabel *profitLossMoneyLabel;
/**
 * 返水控件
 */
@property (nonatomic, strong) UILabel *backwaterMoneyLabel;

@end


@implementation FYPersonStaticItemTableViewCell

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
    UIFont *itemFont = FONT_PINGFANG_REGULAR(14);
    UIColor *itemColor = COLOR_SYSTEM_MAIN_FONT_DEFAULT;
    UIFont *itemContentFont = FONT_PINGFANG_REGULAR(14);
    UIColor *itemContentColor = COLOR_SYSTEM_MAIN_FONT_ASSIST_DEFAULT;
    //
    CGFloat column = 3;
    CGFloat public_left_right_margin = margin;
    CGFloat item_left_right_margin = margin*1.5f;
    CGFloat item_top_bottom_margin = margin*1.5f;
    CGFloat item_margin = margin*0.2f;
    CGFloat item_title_value_margin = margin*0.25f;
    CGFloat item_width = (SCREEN_WIDTH-public_left_right_margin*2.0f-item_left_right_margin*2.0f-item_margin*(column-1)) / column;
    
    // 根容器
    UIView *rootContainerView = ({
        UIView *view = [[UIView alloc] init];
        [view setBackgroundColor:COLOR_TABLEVIEW_SEPARATOR_LINE_DEFAULT];
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
        [view addCornerRadius:margin];
        [view setBackgroundColor:[UIColor whiteColor]];
        [rootContainerView addSubview:view];
        
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(rootContainerView.mas_left).offset(public_left_right_margin);
            make.top.equalTo(rootContainerView.mas_top);
            make.right.equalTo(rootContainerView.mas_right).offset(-public_left_right_margin);
            make.bottom.equalTo(rootContainerView.mas_bottom).offset(-margin*0.5f);
        }];
        
        view;
    });
    self.publicContainerView = publicContainerView;
    self.publicContainerView.mas_key = @"publicContainerView";
    
    // 标题
    UILabel *titleLabel = ({
        UILabel *label = [UILabel new];
        [publicContainerView addSubview:label];
        [label setText:STR_APP_TEXT_PLACEHOLDER];
        [label setFont:FONT_COMMON_TABLE_SECTION_TITLE];
        [label setTextColor:COLOR_SYSTEM_MAIN_FONT_DEFAULT];
        [label setTextAlignment:NSTextAlignmentLeft];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(publicContainerView.mas_top).offset(margin*1.5f);
            make.left.equalTo(publicContainerView.mas_left).offset(item_left_right_margin);
        }];
        
        label;
    });
    self.titleLabel = titleLabel;
    self.titleLabel.mas_key = @"titleLabel";
    
    // 投注
    UILabel *bettingLabel = ({
        UILabel *label = [UILabel new];
        [publicContainerView addSubview:label];
        [label setText:NSLocalizedString(@"投注", nil)];
        [label setFont:itemFont];
        [label setTextColor:itemColor];
        [label setTextAlignment:NSTextAlignmentLeft];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(item_width);
            make.top.equalTo(titleLabel.mas_bottom).offset(item_top_bottom_margin);
            make.left.equalTo(publicContainerView.mas_left).offset(item_left_right_margin);
        }];
        
        label;
    });
    bettingLabel.mas_key = @"bettingLabel";
    
    // 投注 - 金额
    UILabel *bettingMoneyLabel = ({
        UILabel *label = [UILabel new];
        [publicContainerView addSubview:label];
        [label setText:@"0.00"];
        [label setFont:itemContentFont];
        [label setTextColor:itemContentColor];
        [label setTextAlignment:NSTextAlignmentLeft];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(item_width);
            make.top.equalTo(bettingLabel.mas_bottom).offset(item_title_value_margin);
            make.left.equalTo(bettingLabel.mas_left);
        }];
        
        label;
    });
    self.bettingMoneyLabel = bettingMoneyLabel;
    self.bettingMoneyLabel.mas_key = @"bettingMoneyLabel";
    
    // 盈亏
    UILabel *profitLossLabel = ({
        UILabel *label = [UILabel new];
        [publicContainerView addSubview:label];
        [label setText:NSLocalizedString(@"游戏报表", nil)];
        [label setFont:itemFont];
        [label setTextColor:itemColor];
        [label setTextAlignment:NSTextAlignmentLeft];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(item_width);
            make.left.equalTo(bettingLabel.mas_right).offset(item_margin);
            make.centerY.equalTo(bettingLabel.mas_centerY);
        }];
        
        label;
    });
    profitLossLabel.mas_key = @"profitLossLabel";
    
    // 盈亏 - 金额
    UILabel *profitLossMoneyLabel = ({
        UILabel *label = [UILabel new];
        [publicContainerView addSubview:label];
        [label setText:@"0.00"];
        [label setFont:itemContentFont];
        [label setTextColor:itemContentColor];
        [label setTextAlignment:NSTextAlignmentLeft];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(item_width);
            make.top.equalTo(profitLossLabel.mas_bottom).offset(item_title_value_margin);
            make.left.equalTo(profitLossLabel.mas_left);
        }];
        
        label;
    });
    self.profitLossMoneyLabel = profitLossMoneyLabel;
    self.profitLossMoneyLabel.mas_key = @"profitLossMoneyLabel";
    
    // 返水
    UILabel *backwaterLabel = ({
        UILabel *label = [UILabel new];
        [publicContainerView addSubview:label];
        [label setText:NSLocalizedString(@"返水", nil)];
        [label setFont:itemFont];
        [label setTextColor:itemColor];
        [label setTextAlignment:NSTextAlignmentLeft];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(item_width);
            make.left.equalTo(profitLossLabel.mas_right).offset(item_margin);
            make.centerY.equalTo(bettingLabel.mas_centerY);
        }];
        
        label;
    });
    backwaterLabel.mas_key = @"backwaterLabel";
    
    // 返水 - 金额
    UILabel *backwaterMoneyLabel = ({
        UILabel *label = [UILabel new];
        [publicContainerView addSubview:label];
        [label setText:@"0.00"];
        [label setFont:itemContentFont];
        [label setTextColor:itemContentColor];
        [label setTextAlignment:NSTextAlignmentLeft];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(item_width);
            make.top.equalTo(backwaterLabel.mas_bottom).offset(item_title_value_margin);
            make.left.equalTo(backwaterLabel.mas_left);
        }];
        
        label;
    });
    self.backwaterMoneyLabel = backwaterMoneyLabel;
    self.backwaterMoneyLabel.mas_key = @"backwaterMoneyLabel";
    
    // 约束的完整性
    [publicContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(backwaterMoneyLabel.mas_bottom).offset(margin*1.5f).priority(749);
    }];
}


#pragma mark - 设置数据模型
- (void)setModel:(FYPersonStaticItemModel *)model isLastIndexRow:(BOOL)isLastIndexRow
{
    if (![model isKindOfClass:[FYPersonStaticItemModel class]]) {
        return;
    }
    
    _model = model;

    // 最后一个表格
    CGFloat margin = CFC_AUTOSIZING_MARGIN(MARGIN);
    if (isLastIndexRow) {
        [self.publicContainerView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.rootContainerView.mas_bottom).offset(-margin*1.0f);
        }];
    } else {
        [self.publicContainerView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.rootContainerView.mas_bottom).offset(-margin*0.5f);
        }];
    }
    
    // 标题
    [self.titleLabel setText:self.model.title];
    
    // 投注
    [self.bettingMoneyLabel setText:[NSString stringWithFormat:@"%.2f", self.model.bett.floatValue]];
    
    // 盈亏
    [self.profitLossMoneyLabel setText:[NSString stringWithFormat:@"%.2f", self.model.profit.floatValue]];
    
    // 返水
    [self.backwaterMoneyLabel setText:[NSString stringWithFormat:@"%.2f", self.model.backWater.floatValue]];
}


@end

