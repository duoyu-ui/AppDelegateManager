//
//  FYAgentReportAllTableViewCell.m
//  ProjectCSHB
//
//  Created by fangyuan on 2020/6/29.
//  Copyright © 2020 Fangyuan. All rights reserved.
//
// 代理报表 - 汇总信息
//

#import "FYAgentReportAllTableViewCell.h"
#import "FYAgentReportAllModel.h"

@interface FYAgentReportAllTableViewCell ()
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
 * 分割线
 */
@property (nonatomic, strong) UIView *topSplitLineH1;
@property (nonatomic, strong) UIView *topSplitLineH2;
/**
 * 返回总额（元）
 */
@property (nonatomic, strong) UILabel *totalMoneyTitleLabel;
@property (nonatomic, strong) UILabel *totalMoneyValueLabel;
/**
 * 今日返水
 */
@property (nonatomic, strong) UILabel *todayMoneyTitleLabel;
@property (nonatomic, strong) UILabel *todayMoneyValueLabel;

@end


@implementation FYAgentReportAllTableViewCell

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
    UIFont *itemTotalTitleFont = FONT_PINGFANG_REGULAR(14);
    UIColor *itemTotalTitleColor = COLOR_SYSTEM_MAIN_FONT_DEFAULT;
    UIFont *itemTotalValueFont = FONT_PINGFANG_SEMI_BOLD(20);
    UIColor *itemTotalValueColor = COLOR_SYSTEM_MAIN_FONT_DEFAULT;
    //
    CGFloat public_left_right_margin = margin;
    CGFloat item_left_right_margin = margin*1.5f;
    CGFloat item_title_value_margin = margin*0.25f;

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
            make.top.equalTo(publicContainerView.mas_top).offset(margin*1.0f);
            make.left.equalTo(publicContainerView.mas_left).offset(item_left_right_margin);
        }];
        
        label;
    });
    self.titleLabel = titleLabel;
    self.titleLabel.mas_key = @"titleLabel";
    
    // 分割线
    UIView *topSplitLineH1 = ({
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
    self.topSplitLineH1 = topSplitLineH1;
    self.topSplitLineH1.mas_key = @"topSplitLineH1";
    
    // 返水总额（元）
    UILabel *totalMoneyTitleLabel = ({
        UILabel *label = [UILabel new];
        [publicContainerView addSubview:label];
        [label setText:NSLocalizedString(@"返水总额(元)", nil)];
        [label setFont:itemTotalTitleFont];
        [label setTextColor:itemTotalTitleColor];
        [label setTextAlignment:NSTextAlignmentLeft];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(topSplitLineH1.mas_bottom).offset(margin*1.5f);
            make.left.equalTo(publicContainerView.mas_left).offset(item_left_right_margin);
        }];
        
        label;
    });
    self.totalMoneyTitleLabel = totalMoneyTitleLabel;
    self.totalMoneyTitleLabel.mas_key = @"totalMoneyTitleLabel";
    
    // 返水总额（元） - 金额
    UILabel *totalMoneyValueLabel = ({
        UILabel *label = [UILabel new];
        [publicContainerView addSubview:label];
        [label setText:@"0.00"];
        [label setFont:itemTotalValueFont];
        [label setTextColor:itemTotalValueColor];
        [label setTextAlignment:NSTextAlignmentLeft];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(totalMoneyTitleLabel.mas_bottom).offset(item_title_value_margin);
            make.left.equalTo(totalMoneyTitleLabel.mas_left);
        }];
        
        label;
    });
    self.totalMoneyValueLabel = totalMoneyValueLabel;
    self.totalMoneyValueLabel.mas_key = @"totalMoneyValueLabel";
    
    // 今日返水
    UILabel *todayMoneyTitleLabel = ({
        UILabel *label = [UILabel new];
        [publicContainerView addSubview:label];
        [label setText:NSLocalizedString(@"今日返水", nil)];
        [label setFont:itemTotalTitleFont];
        [label setTextColor:itemTotalTitleColor];
        [label setTextAlignment:NSTextAlignmentRight];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(publicContainerView.mas_right).offset(-item_left_right_margin);
            make.centerY.equalTo(totalMoneyTitleLabel.mas_centerY);
        }];
        
        label;
    });
    self.todayMoneyTitleLabel = todayMoneyTitleLabel;
    self.todayMoneyTitleLabel.mas_key = @"todayMoneyTitleLabel";
    
    // 今日返水 - 金额
    UILabel *todayMoneyValueLabel = ({
        UILabel *label = [UILabel new];
        [publicContainerView addSubview:label];
        [label setText:@"0.00"];
        [label setFont:itemTotalValueFont];
        [label setTextColor:itemTotalValueColor];
        [label setTextAlignment:NSTextAlignmentLeft];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(todayMoneyTitleLabel.mas_bottom).offset(item_title_value_margin);
            make.right.equalTo(todayMoneyTitleLabel.mas_right);
        }];
        
        label;
    });
    self.todayMoneyValueLabel = todayMoneyValueLabel;
    self.todayMoneyValueLabel.mas_key = @"todayMoneyValueLabel";
    
    // 分割线
    UIView *topSplitLineH2 = ({
        UIView *view = [[UIView alloc] init];
        [view setBackgroundColor:COLOR_TABLEVIEW_SEPARATOR_LINE_DEFAULT];
        [publicContainerView addSubview:view];
        
        CGFloat height = SEPARATOR_LINE_HEIGHT;
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(todayMoneyValueLabel.mas_bottom).offset(margin*1.0f);
            make.left.right.equalTo(publicContainerView);
            make.height.mas_equalTo(height);
        }];
        
        view;
    });
    self.topSplitLineH2 = topSplitLineH2;
    self.topSplitLineH2.mas_key = @"topSplitLineH2";
}


#pragma mark - 设置数据模型
- (void)setModel:(FYAgentReportAllModel *)model
{
    if (![model isKindOfClass:[FYAgentReportAllModel class]]) {
        return;
    }
     
    _model = model;
    
    // 标题
    [self.titleLabel setText:self.model.title];
    
    // 返回总额
    [self.totalMoneyTitleLabel setText:self.model.totalMoneyTitle];
    [self.totalMoneyValueLabel setText:[NSString stringWithFormat:@"%.2f", self.model.totalMoneyValue.floatValue]];
    
    // 今日返水
    [self.todayMoneyTitleLabel setText:self.model.todayMoneyTitle];
    [self.todayMoneyValueLabel setText:[NSString stringWithFormat:@"%.2f", self.model.todayMoneyValue.floatValue]];
    
    // 项目列表
    {
        // 删除控件
        [self.publicContainerView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj.tag > 1000) {
                [obj removeFromSuperview];
            }
        }];
        
        // 重建控件
        NSInteger count = self.model.subitems ? self.model.subitems.count : 0;
        CGFloat margin = CFC_AUTOSIZING_MARGIN(MARGIN);
        if (count <= 0) {

            [self.publicContainerView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(self.topSplitLineH2.mas_bottom).offset(margin*1.5f).priority(749);
            }];
        
        } else {
            
            UIFont *itemTitleFont = FONT_PINGFANG_REGULAR(14);
            UIColor *itemTitleColor = COLOR_SYSTEM_MAIN_FONT_DEFAULT;
            UIFont *itemContentFont = FONT_PINGFANG_REGULAR(14);
            UIColor *itemContentColor = COLOR_HEXSTRING(@"#6B6B6B");
            //
            UIFont *itemAgentTitleFont = FONT_PINGFANG_REGULAR(14);
            UIColor *itemAgentTitleColor = COLOR_HEXSTRING(@"#C5C5C5");
            UIFont *itemAgentContentFont = FONT_PINGFANG_REGULAR(14);
            UIColor *itemAgentContentColor = COLOR_HEXSTRING(@"#C5C5C5");
            //
            NSInteger column = 2;
            CGFloat public_left_right_margin = margin;
            CGFloat item_left_right_margin = margin*1.5f;
            CGFloat item_top_bottom_margin = margin*1.5f;
            CGFloat item_margin = margin*2.0f;
            CGFloat item_title_value_margin = margin*0.25f;
            CGFloat item_width = (SCREEN_WIDTH-public_left_right_margin*2.0f-item_left_right_margin*2.0f-item_margin*(column-1)) / column;
            
            // 项目列表
            UILabel *lastItemLabel = nil;
            UILabel *lastItemSplitLabel = nil;
            {
                for (NSInteger index = 0; index < count; index ++) {
                    
                    FYAgentReportAllItemModel *itemModel = [self.model.subitems objectAtIndex:index];
                    BOOL isHiddenRight = VALIDATE_STRING_EMPTY(itemModel.rightTitle) ? YES : NO;
                    
                    // 标题 - 左
                    UILabel *itemLeftTitleLabel = ({
                        UILabel *label = [UILabel new];
                        [self.publicContainerView addSubview:label];
                        [label setText:itemModel.leftTitle];
                        [label setTag:1001+index];
                        [label setFont:itemTitleFont];
                        [label setTextColor:itemTitleColor];
                        [label setTextAlignment:NSTextAlignmentLeft];
                        
                        [label mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.width.equalTo(@(item_width));
                            if (!lastItemLabel) {
                                make.top.equalTo(self.topSplitLineH2.mas_bottom).offset(item_top_bottom_margin);
                                make.left.equalTo(self.publicContainerView.mas_left).offset(item_left_right_margin);
                            } else {
                                if (index % column == 0) {
                                    make.top.equalTo(lastItemSplitLabel.mas_bottom).offset(item_top_bottom_margin);
                                    make.left.equalTo(self.publicContainerView.mas_left).offset(item_left_right_margin);
                                } else {
                                    make.bottom.equalTo(lastItemLabel.mas_top).offset(-item_title_value_margin);
                                    make.left.equalTo(lastItemLabel.mas_right).offset(item_margin);
                                }
                            }
                        }];
                        
                        label;
                    });
                    itemLeftTitleLabel.mas_key = @"itemLeftTitleLabel";
                    
                    // 内容 - 左
                    UILabel *itemLeftValueLabel = ({
                        UILabel *label = [UILabel new];
                        [self.publicContainerView addSubview:label];
                        [label setText:itemModel.leftValue];
                        [label setTag:2001+index];
                        [label setFont:itemContentFont];
                        [label setTextColor:itemContentColor];
                        [label setTextAlignment:NSTextAlignmentLeft];
                        
                        [label mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.width.equalTo(@(item_width));
                            make.top.equalTo(itemLeftTitleLabel.mas_bottom).offset(item_title_value_margin);
                            make.left.equalTo(itemLeftTitleLabel.mas_left);
                        }];
                        
                        label;
                    });
                    itemLeftValueLabel.mas_key = @"itemLeftValueLabel";
                    
                    // 标题 - 右
                    UILabel *itemRightTitleLabel = ({
                        UILabel *label = [UILabel new];
                        [self.publicContainerView addSubview:label];
                        [label setText:itemModel.rightTitle];
                        [label setTag:3001+index];
                        [label setHidden:isHiddenRight];
                        [label setFont:itemAgentTitleFont];
                        [label setTextColor:itemAgentTitleColor];
                        [label setTextAlignment:NSTextAlignmentRight];
                        
                        [label mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.centerY.equalTo(itemLeftTitleLabel.mas_centerY);
                            make.right.equalTo(itemLeftTitleLabel.mas_right).offset(-item_left_right_margin);
                        }];
                        
                        label;
                    });
                    itemRightTitleLabel.mas_key = @"itemAgentLabel";
                    
                    // 内容 - 右
                    UILabel *itemRightValueLabel = ({
                        UILabel *label = [UILabel new];
                        [self.publicContainerView addSubview:label];
                        [label setText:itemModel.rightValue];
                        [label setTag:4001+index];
                        [label setHidden:isHiddenRight];
                        [label setFont:itemAgentContentFont];
                        [label setTextColor:itemAgentContentColor];
                        [label setTextAlignment:NSTextAlignmentRight];
                        
                        [label mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.centerY.equalTo(itemLeftValueLabel.mas_centerY);
                            make.right.equalTo(itemRightTitleLabel.mas_right);
                        }];
                        
                        label;
                    });
                    itemRightValueLabel.mas_key = @"itemAgentContentLabel";
                    
                    // 分割线 - 竖直
                    if (index % column == 0) {
                        UIView *itemSplitLineV = ({
                            UIView *view = [[UIView alloc] init];
                            [view setTag:5001+index];
                            [view setBackgroundColor:COLOR_TABLEVIEW_SEPARATOR_LINE_DEFAULT];
                            [self.publicContainerView addSubview:view];
                            
                            CGFloat width = SEPARATOR_LINE_HEIGHT;
                            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                                make.top.equalTo(itemLeftTitleLabel.mas_top).offset(-item_top_bottom_margin);
                                make.bottom.equalTo(itemLeftValueLabel.mas_bottom).offset(item_top_bottom_margin);
                                make.centerX.equalTo(itemLeftTitleLabel.mas_right);
                                make.width.mas_equalTo(width);
                            }];
                            
                            view;
                        });
                        itemSplitLineV.mas_key = @"itemSplitLineV";
                    }
                    
                    // 分割线 - 水平
                    if (index % column == 0) {
                        UILabel *itemSplitLineH = ({
                            UILabel *label = [UILabel new];
                            [label setTag:6001+index];
                            [label setBackgroundColor:COLOR_TABLEVIEW_SEPARATOR_LINE_DEFAULT];
                            [self.publicContainerView addSubview:label];
                            
                            CGFloat height = SEPARATOR_LINE_HEIGHT;
                            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                                make.left.equalTo(self.publicContainerView.mas_left);
                                make.right.equalTo(self.publicContainerView.mas_right);
                                make.top.equalTo(itemLeftValueLabel.mas_bottom).offset(item_top_bottom_margin);
                                make.height.mas_equalTo(height);
                            }];
                            
                            label;
                        });
                        itemSplitLineH.mas_key = @"itemSplitLineH";
                        
                        lastItemSplitLabel = itemSplitLineH;
                    }

                    lastItemLabel = itemLeftValueLabel;
                }
            }
            
            // 约束的完整性
            [self.publicContainerView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(lastItemSplitLabel.mas_bottom).priority(749);
            }];
        }
    }
    
}


@end

