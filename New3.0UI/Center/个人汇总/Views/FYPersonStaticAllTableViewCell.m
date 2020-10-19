//
//  FYPersonStaticAllTableViewCell.m
//  ProjectCSHB
//
//  Created by fangyuan on 2020/6/26.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "FYPersonStaticAllTableViewCell.h"
#import "FYPersonStaticAllModel.h"

#define PERSON_STATIC_TITLE_YUER           NSLocalizedString(@"余额", nil)
#define PERSON_STATIC_TITLE_YUERBAO        NSLocalizedString(@"余额宝", nil)
#define PERSON_STATIC_TITLE_RECHARGE       NSLocalizedString(@"充值", nil)
#define PERSON_STATIC_TITLE_WITHDRAW       NSLocalizedString(@"提现", nil)
#define PERSON_STATIC_TITLE_TRANSFER_IN    NSLocalizedString(@"转账(转入)", nil)
#define PERSON_STATIC_TITLE_TRANSFER_OUT   NSLocalizedString(@"转账(转出)", nil)
#define PERSON_STATIC_TITLE_BETTING        NSLocalizedString(@"投注", nil)
#define PERSON_STATIC_TITLE_PROFERLOSS     NSLocalizedString(@"盈亏", nil)
#define PERSON_STATIC_TITLE_JIANGLI        NSLocalizedString(@"奖励", nil)
#define PERSON_STATIC_TITLE_YONGJIN        NSLocalizedString(@"佣金", nil)

@interface FYPersonStaticAllTableViewCell ()
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
 * 总资产（元）
 */
@property (nonatomic, strong) UILabel *totalMoneyValueLabel;
/**
 * 今日盈亏
 */
@property (nonatomic, strong) UILabel *todayProfitLossValueLabel;
/**
 * 项目列表
 */
@property (nonatomic, strong) NSMutableArray<UILabel *> *itemLabels;
@property (nonatomic, strong) NSMutableArray<NSString *> *itemTitles;


@end


@implementation FYPersonStaticAllTableViewCell

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
    UIFont *itemTotalFont = FONT_PINGFANG_SEMI_BOLD(20);
    UIColor *itemTotalColor = COLOR_SYSTEM_MAIN_FONT_DEFAULT;
    UIFont *itemContentFont = FONT_PINGFANG_REGULAR(14);
    UIColor *itemContentColor = COLOR_SYSTEM_MAIN_FONT_ASSIST_DEFAULT;
    //
    NSInteger column = 2;
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
    
    // 总资产（元）
    UILabel *totalMoneyTitleLabel = ({
        UILabel *label = [UILabel new];
        [publicContainerView addSubview:label];
        [label setText:NSLocalizedString(@"总资产(元)", nil)];
        [label setFont:itemFont];
        [label setTextColor:itemColor];
        [label setTextAlignment:NSTextAlignmentLeft];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(titleLabel.mas_bottom).offset(item_top_bottom_margin);
            make.left.equalTo(publicContainerView.mas_left).offset(item_left_right_margin);
        }];
        
        label;
    });
    totalMoneyTitleLabel.mas_key = @"totalMoneyTitleLabel";
    
    // 总资产（元） - 金额
    UILabel *bettingMoneyLabel = ({
        UILabel *label = [UILabel new];
        [publicContainerView addSubview:label];
        [label setText:@"0.00"];
        [label setFont:itemTotalFont];
        [label setTextColor:itemTotalColor];
        [label setTextAlignment:NSTextAlignmentLeft];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(totalMoneyTitleLabel.mas_bottom).offset(item_title_value_margin);
            make.left.equalTo(totalMoneyTitleLabel.mas_left);
        }];
        
        label;
    });
    self.totalMoneyValueLabel = bettingMoneyLabel;
    self.totalMoneyValueLabel.mas_key = @"totalMoneyValueLabel";
    
    // 今日盈亏
    UILabel *todayProfitLossTitleLabel = ({
        UILabel *label = [UILabel new];
        [publicContainerView addSubview:label];
        [label setText:NSLocalizedString(@"今日盈亏", nil)];
        [label setFont:itemFont];
        [label setTextColor:itemColor];
        [label setTextAlignment:NSTextAlignmentRight];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(publicContainerView.mas_right).offset(-item_left_right_margin);
            make.centerY.equalTo(totalMoneyTitleLabel.mas_centerY);
        }];
        
        label;
    });
    todayProfitLossTitleLabel.mas_key = @"todayProfitLossTitleLabel";
    
    // 今日盈亏 - 金额
    UILabel *todayProfitLossValueLabel = ({
        UILabel *label = [UILabel new];
        [publicContainerView addSubview:label];
        [label setText:@"0.00"];
        [label setFont:itemTotalFont];
        [label setTextColor:itemTotalColor];
        [label setTextAlignment:NSTextAlignmentLeft];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(todayProfitLossTitleLabel.mas_bottom).offset(item_title_value_margin);
            make.right.equalTo(todayProfitLossTitleLabel.mas_right);
        }];
        
        label;
    });
    self.todayProfitLossValueLabel = todayProfitLossValueLabel;
    self.todayProfitLossValueLabel.mas_key = @"todayProfitLossValueLabel";
    
    // 项目列表
    UILabel *lastItemLabel = nil;
    {
        
        _itemLabels = @[].mutableCopy;
        _itemTitles = @[ PERSON_STATIC_TITLE_YUER,
                         PERSON_STATIC_TITLE_YUERBAO,
                         PERSON_STATIC_TITLE_RECHARGE,
                         PERSON_STATIC_TITLE_WITHDRAW,
                         PERSON_STATIC_TITLE_TRANSFER_IN,
                         PERSON_STATIC_TITLE_TRANSFER_OUT,
                         PERSON_STATIC_TITLE_BETTING,
                         PERSON_STATIC_TITLE_PROFERLOSS,
                         PERSON_STATIC_TITLE_JIANGLI,
                         PERSON_STATIC_TITLE_YONGJIN ].mutableCopy;
        for (NSInteger index = 0; index < self.itemTitles.count; index ++) {
            
            NSString *itemString = [self.itemTitles objectAtIndex:index];
            
            // 标题
            UILabel *itemTitleLabel = ({
                UILabel *label = [UILabel new];
                [publicContainerView addSubview:label];
                [label setText:itemString];
                [label setFont:itemFont];
                [label setTextColor:itemColor];
                [label setTextAlignment:NSTextAlignmentLeft];
                
                [label mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.width.equalTo(@(item_width));

                    if (!lastItemLabel) {
                        make.top.equalTo(bettingMoneyLabel.mas_bottom).offset(item_top_bottom_margin);
                        make.left.equalTo(publicContainerView.mas_left).offset(item_left_right_margin);
                    } else {
                        if (index % column == 0) {
                            make.top.equalTo(lastItemLabel.mas_bottom).offset(item_top_bottom_margin);
                            make.left.equalTo(publicContainerView.mas_left).offset(item_left_right_margin);
                        } else {
                            make.bottom.equalTo(lastItemLabel.mas_top).offset(-item_title_value_margin);
                            make.left.equalTo(lastItemLabel.mas_right).offset(item_margin);
                        }
                    }
                }];
                
                label;
            });
            itemTitleLabel.mas_key = @"itemTitleLabel";
            
            // 金额
            UILabel *itemMoneyLabel = ({
                UILabel *label = [UILabel new];
                [publicContainerView addSubview:label];
                [label setText:@"0.00"];
                [label setFont:itemContentFont];
                [label setTextColor:itemContentColor];
                [label setTextAlignment:NSTextAlignmentLeft];
                
                [label mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.width.equalTo(@(item_width));
                    make.top.equalTo(itemTitleLabel.mas_bottom).offset(item_title_value_margin);
                    make.left.equalTo(itemTitleLabel.mas_left);
                }];
                
                label;
            });
            itemMoneyLabel.mas_key = @"itemMoneyLabel";
            
            [_itemLabels addObj:itemMoneyLabel];
            
            lastItemLabel = itemMoneyLabel;
        }
    }
    
    // 约束的完整性
    [publicContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(lastItemLabel.mas_bottom).offset(margin*1.5f).priority(749);
    }];
}


#pragma mark - 设置数据模型
- (void)setModel:(FYPersonStaticAllModel *)model
{
    if (![model isKindOfClass:[FYPersonStaticAllModel class]]) {
        return;
    }
    
    _model = model;

    // 标题
    [self.titleLabel setText:self.model.title];
    
    // 总资产(元)
    [self.totalMoneyValueLabel setText:[NSString stringWithFormat:@"%.2f", self.model.totalAssets.floatValue]];
    
    // 今日盈亏
    [self.todayProfitLossValueLabel setText:[NSString stringWithFormat:@"%.2f", self.model.todayProfitLoss.floatValue]];
    
    // 项目
    for (NSInteger index = 0; index <self.itemTitles.count; index ++) {
        NSString *title = [self.itemTitles objectAtIndex:index];
        UILabel *valueLabel = [self.itemLabels objectAtIndex:index];
        if ([PERSON_STATIC_TITLE_YUER isEqualToString:title]) {
            [valueLabel setText:[NSString stringWithFormat:@"%.2f", self.model.banlance.floatValue]];
        } else if ([PERSON_STATIC_TITLE_YUERBAO isEqualToString:title]) {
            [valueLabel setText:[NSString stringWithFormat:@"%.2f", self.model.yuEBao.floatValue]];
        } else if ([PERSON_STATIC_TITLE_RECHARGE isEqualToString:title]) {
            [valueLabel setText:[NSString stringWithFormat:@"%.2f", self.model.recharge.floatValue]];
        } else if ([PERSON_STATIC_TITLE_WITHDRAW isEqualToString:title]) {
            [valueLabel setText:[NSString stringWithFormat:@"%.2f", self.model.withdraw.floatValue]];
        } else if ([PERSON_STATIC_TITLE_TRANSFER_IN isEqualToString:title]) {
            [valueLabel setText:[NSString stringWithFormat:@"%.2f", self.model.inAccount.floatValue]];
        } else if ([PERSON_STATIC_TITLE_TRANSFER_OUT isEqualToString:title]) {
            [valueLabel setText:[NSString stringWithFormat:@"%.2f", self.model.outAccount.floatValue]];
        } else if ([PERSON_STATIC_TITLE_BETTING isEqualToString:title]) {
            [valueLabel setText:[NSString stringWithFormat:@"%.2f", self.model.bett.floatValue]];
        } else if ([PERSON_STATIC_TITLE_PROFERLOSS isEqualToString:title]) {
            [valueLabel setText:[NSString stringWithFormat:@"%.2f", self.model.profitLoss.floatValue]];
        } else if ([PERSON_STATIC_TITLE_JIANGLI isEqualToString:title]) {
            [valueLabel setText:[NSString stringWithFormat:@"%.2f", self.model.reward.floatValue]];
        } else if ([PERSON_STATIC_TITLE_YONGJIN isEqualToString:title]) {
            [valueLabel setText:[NSString stringWithFormat:@"%.2f", self.model.commission.floatValue]];
        }
    }
}


@end

