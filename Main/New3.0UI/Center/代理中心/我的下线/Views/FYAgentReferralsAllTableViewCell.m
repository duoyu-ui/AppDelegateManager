//
//  FYAgentReferralsAllTableViewCell.m
//  ProjectCSHB
//
//  Created by fangyuan on 2020/6/27.
//  Copyright © 2020 Fangyuan. All rights reserved.
//
// 我的下线 - 汇总信息
//

#import "FYAgentReferralsAllTableViewCell.h"
#import "FYAgentReferralsAllModel.h"

#define AGENT_REFERRALS_ALL_TITLE_BETTING       NSLocalizedString(@"投注汇总", nil)
#define AGENT_REFERRALS_ALL_TITLE_PROFITLOSS    NSLocalizedString(@"游戏报表", nil)
#define AGENT_REFERRALS_ALL_TITLE_BALANCE       NSLocalizedString(@"余额汇总", nil)
#define AGENT_REFERRALS_ALL_TITLE_BACKWATER     NSLocalizedString(@"返水汇总", nil)

@interface FYAgentReferralsAllTableViewCell ()
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
 * 下线人数
*/
@property (nonatomic, strong) UILabel *subNumberLabel;
/**
 * 项目列表
 */
@property (nonatomic, strong) NSMutableArray<NSString *> *itemTitles;
@property (nonatomic, strong) NSMutableArray<UILabel *> *itemValueLabels;

@end


@implementation FYAgentReferralsAllTableViewCell

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
    UIFont *itemTopFont = FONT_PINGFANG_REGULAR(16);
    UIColor *itemTopColor = COLOR_SYSTEM_MAIN_FONT_DEFAULT;
    UIFont *itemValueFont = FONT_PINGFANG_REGULAR(14);
    UIColor *itemValueColor = COLOR_SYSTEM_MAIN_FONT_DEFAULT;
    UIFont *itemTitleFont = FONT_PINGFANG_REGULAR(13);
    UIColor *itemTitleColor = COLOR_SYSTEM_MAIN_FONT_ASSIST_DEFAULT;
    //
    NSInteger column = 4;
    CGFloat public_left_right_margin = margin;
    CGFloat item_left_right_margin = 0.0f;
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
    
    // 标题控件
    UILabel *titleLabel = ({
        UILabel *label = [UILabel new];
        [publicContainerView addSubview:label];
        [label setText:STR_APP_TEXT_PLACEHOLDER];
        [label setFont:itemTopFont];
        [label setTextColor:itemTopColor];
        [label setTextAlignment:NSTextAlignmentLeft];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(publicContainerView.mas_top).offset(margin*1.0f);
            make.left.equalTo(publicContainerView.mas_left).offset(margin*1.5f);
        }];
        
        label;
    });
    self.titleLabel = titleLabel;
    self.titleLabel.mas_key = @"titleLabel";
    
    // 下线人数
    UILabel *subNumberLabel = ({
        UILabel *label = [UILabel new];
        [publicContainerView addSubview:label];
        [label setText:NSLocalizedString(@"共 0 人", nil)];
        [label setFont:itemTopFont];
        [label setTextColor:COLOR_SYSTEM_MAIN_FONT_ASSIST_DEFAULT];
        [label setTextAlignment:NSTextAlignmentRight];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(titleLabel.mas_top);
            make.right.equalTo(publicContainerView.mas_right).offset(-margin*1.5f);
        }];
        
        label;
    });
    self.subNumberLabel = subNumberLabel;
    self.subNumberLabel.mas_key = @"subNumberLabel";
    
    // 分割线
    UIView *topSplitLineH = ({
        UIView *view = [[UIView alloc] init];
        [view setBackgroundColor:COLOR_TABLEVIEW_SEPARATOR_LINE_DEFAULT];
        [publicContainerView addSubview:view];
        
        CGFloat height = SEPARATOR_LINE_HEIGHT;
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(titleLabel.mas_bottom).offset(margin*1.0f);
            make.left.right.equalTo(publicContainerView);
            make.height.mas_equalTo(height);
        }];
        
        view;
    });
    topSplitLineH.mas_key = @"topSplitLineH";
    
    // 项目列表
    UILabel *lastItemLabel = nil;
    {
        
        _itemValueLabels = @[].mutableCopy;
        _itemTitles = @[ AGENT_REFERRALS_ALL_TITLE_BETTING,
                         AGENT_REFERRALS_ALL_TITLE_PROFITLOSS,
                         AGENT_REFERRALS_ALL_TITLE_BALANCE,
                         AGENT_REFERRALS_ALL_TITLE_BACKWATER ].mutableCopy;
        for (NSInteger index = 0; index < self.itemTitles.count; index ++) {
            
            NSString *itemString = [self.itemTitles objectAtIndex:index];
            
            // 内容
            UILabel *itemValueLabel = ({
                UILabel *label = [UILabel new];
                [publicContainerView addSubview:label];
                [label setText:@"0.00"];
                [label setFont:itemValueFont];
                [label setTextColor:itemValueColor];
                [label setTextAlignment:NSTextAlignmentCenter];
                
                [label mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.width.equalTo(@(item_width));

                    if (!lastItemLabel) {
                        make.top.equalTo(topSplitLineH.mas_bottom).offset(item_top_bottom_margin);
                        make.left.equalTo(publicContainerView.mas_left).offset(item_left_right_margin);
                    } else {
                        make.bottom.equalTo(lastItemLabel.mas_top).offset(-item_title_value_margin);
                        make.left.equalTo(lastItemLabel.mas_right).offset(item_margin);
                    }
                }];
                
                label;
            });
            itemValueLabel.mas_key = @"itemValueLabel";
            
            // 标题
            UILabel *itemTitleLabel = ({
                UILabel *label = [UILabel new];
                [publicContainerView addSubview:label];
                [label setText:itemString];
                [label setFont:itemTitleFont];
                [label setTextColor:itemTitleColor];
                [label setTextAlignment:NSTextAlignmentCenter];
                
                [label mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.width.equalTo(@(item_width));
                    make.top.equalTo(itemValueLabel.mas_bottom).offset(item_title_value_margin);
                    make.centerX.equalTo(itemValueLabel.mas_centerX);
                }];
                
                label;
            });
            itemTitleLabel.mas_key = @"itemTitleLabel";
            
            // 分割线
            if (index + 1 < self.itemTitles.count) {
                UIView *itemSplitLineV = ({
                    UIView *view = [[UIView alloc] init];
                    [view setBackgroundColor:COLOR_TABLEVIEW_SEPARATOR_LINE_DEFAULT];
                    [publicContainerView addSubview:view];
                    
                    CGFloat width = SEPARATOR_LINE_HEIGHT;
                    [view mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.top.equalTo(itemValueLabel.mas_top).offset(-margin*0.5f);
                        make.bottom.equalTo(itemTitleLabel.mas_bottom).offset(margin*0.5f);
                        make.centerX.equalTo(itemTitleLabel.mas_right);
                        make.width.mas_equalTo(width);
                    }];
                    
                    view;
                });
                itemSplitLineV.mas_key = @"itemSplitLineV";
            }
            
            [_itemValueLabels addObj:itemValueLabel];
            
            lastItemLabel = itemTitleLabel;
        }
    }
    
    // 约束的完整性
    [publicContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(lastItemLabel.mas_bottom).offset(margin*1.5f).priority(749);
    }];
}

#pragma mark - 设置数据模型
- (void)setModel:(FYAgentReferralsAllModel *)model
{
    if (![model isKindOfClass:[FYAgentReferralsAllModel class]]) {
        return;
    }
    
    _model = model;

    // 汇总标题
    [self.titleLabel setText:self.model.title];
    
    // 下线人数
    [self.subNumberLabel setText:[NSString stringWithFormat:NSLocalizedString(@"共 %ld 人", nil), self.model.personCount.integerValue]];
    
    // 项目列表
    for (NSInteger index = 0; index < self.itemTitles.count; index ++) {
        NSString *itemTitle = [self.itemTitles objectAtIndex:index];
        UILabel *itemLabel = [self.itemValueLabels objectAtIndex:index];
        if ([AGENT_REFERRALS_ALL_TITLE_BETTING isEqualToString:itemTitle]) {
            [itemLabel setText:[NSString stringWithFormat:@"%.2f", self.model.bett.floatValue]];
        } else if ([AGENT_REFERRALS_ALL_TITLE_PROFITLOSS isEqualToString:itemTitle]) {
            [itemLabel setText:[NSString stringWithFormat:@"%.2f", self.model.profitLoss.floatValue]];
        } else if ([AGENT_REFERRALS_ALL_TITLE_BALANCE isEqualToString:itemTitle]) {
            [itemLabel setText:[NSString stringWithFormat:@"%.2f", self.model.banlance.floatValue]];
        } else if ([AGENT_REFERRALS_ALL_TITLE_BACKWATER isEqualToString:itemTitle]) {
            [itemLabel setText:[NSString stringWithFormat:@"%.2f", self.model.backWater.floatValue]];
        }
    }
}


@end

