//
//  FYGameReportSectionHeader.m
//  ProjectCSHB
//
//  Created by fangyuan on 2020/6/25.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "FYGameReportSectionHeader.h"
#import "FYGameReportStatisticsModel.h"

CGFloat const kFyGameReportHeaderStatisticsAreaHeight = 55.0; // 统计区域（总投注、总奖励、总盈亏）
CGFloat const kFyGameReportHeaderColumnTitleAreaHeight = 40.0f; // 列标题区域
CGFloat const kFyGameReportHeaderSplitLineAreaHeight = 3.3f; // 间隔

@interface FYGameReportSectionHeader ()
//
@property (nonatomic, strong) UIView *statisticsContainer;
@property (nonatomic, strong) UIView *columnTitleContainer;
@property (nonatomic, strong) UIView *splitLineContainer;
//
@property (nonatomic, strong) UILabel *moneyTotalBettingLabel; // 总投注
@property (nonatomic, strong) UILabel *moneyTotalBonusLabel; // 总奖励
@property (nonatomic, strong) UILabel *moneyTotalProfitLossLabel; // 总盈亏

@end

@implementation FYGameReportSectionHeader

#pragma mark - Life Cycle

+ (CGFloat)headerViewHeight
{
    return [FYDatePickerHeaderView headerViewHeight] + kFyGameReportHeaderStatisticsAreaHeight + kFyGameReportHeaderColumnTitleAreaHeight + kFyGameReportHeaderSplitLineAreaHeight;
}

- (void)createViewAtuoLayout
{
    [super createViewAtuoLayout];
    
    // 容器 - 统计区域
    [self addSubview:self.statisticsContainer];
    [self.statisticsContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(self.dateTimeContainer.mas_bottom);
        make.height.mas_equalTo(kFyGameReportHeaderStatisticsAreaHeight);
    }];
    
    // 容器 - 分割区域
    [self addSubview:self.splitLineContainer];
    [self.splitLineContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(self.statisticsContainer.mas_bottom);
        make.height.mas_equalTo(kFyGameReportHeaderSplitLineAreaHeight);
    }];
    
    // 容器 - 标题区域
    [self addSubview:self.columnTitleContainer];
    [self.columnTitleContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self);
        make.height.mas_equalTo(kFyGameReportHeaderColumnTitleAreaHeight);
    }];
    
    // 
    [self createViewStatisticsAtuoLayout];
    [self createViewColumnTitleAtuoLayout];
}

- (void)createViewStatisticsAtuoLayout
{
    NSString *STR_TITLE_TOTAL_BETTING = NSLocalizedString(@"总投注", nil);
    NSString *STR_TITLE_TOTAL_BONUS = NSLocalizedString(@"总奖励", nil);
    NSString *STR_TITLE_TOTAL_PROFITLOASS = NSLocalizedString(@"总盈亏", nil);
    NSArray<NSString *> *titles = @[ STR_TITLE_TOTAL_BETTING, STR_TITLE_TOTAL_BONUS, STR_TITLE_TOTAL_PROFITLOASS ];
    UIFont *titleFont = FONT_PINGFANG_REGULAR(13);
    UIColor *titleColor = COLOR_SYSTEM_MAIN_FONT_ASSIST_DEFAULT;
    CGFloat margin = CFC_AUTOSIZING_MARGIN(MARGIN);
    CGFloat itemWidth = SCREEN_WIDTH / 3.0f;
    
    UILabel *lastItemLabel = nil;
    for (NSInteger index = 0; index < titles.count; index ++) {
        
        NSString *title = [titles objectAtIndex:index];
        
        lastItemLabel = ({
            UILabel *label = [UILabel new];
            [self.statisticsContainer addSubview:label];
            [label setText:title];
            [label setFont:titleFont];
            [label setTextColor:titleColor];
            [label setTextAlignment:NSTextAlignmentCenter];
            
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(@(itemWidth));
                
                if (!lastItemLabel) {
                    make.top.equalTo(self.statisticsContainer.mas_centerY).offset(margin*0.15f);
                    make.left.equalTo(self.statisticsContainer.mas_left);
                } else {
                    make.top.equalTo(lastItemLabel.mas_top);
                    make.left.equalTo(lastItemLabel.mas_right);
                }
            }];
            
            label;
        });
        lastItemLabel.mas_key = [NSString stringWithFormat:@"titleLabel%ld", index];
         
        if (STR_TITLE_TOTAL_BETTING == title) {
            [self.statisticsContainer addSubview:self.moneyTotalBettingLabel];
            [self.moneyTotalBettingLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(lastItemLabel);
                make.bottom.equalTo(self.statisticsContainer.mas_centerY).offset(-margin*0.15f);
            }];
        } else if (STR_TITLE_TOTAL_BONUS == title) {
            [self.statisticsContainer addSubview:self.moneyTotalBonusLabel];
            [self.moneyTotalBonusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(lastItemLabel);
                make.bottom.equalTo(self.statisticsContainer.mas_centerY).offset(-margin*0.15f);
            }];
        } else if (STR_TITLE_TOTAL_PROFITLOASS == title) {
            [self.statisticsContainer addSubview:self.moneyTotalProfitLossLabel];
            [self.moneyTotalProfitLossLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(lastItemLabel);
                make.bottom.equalTo(self.statisticsContainer.mas_centerY).offset(-margin*0.15f);
            }];
        }
    }
}

- (void)createViewColumnTitleAtuoLayout
{
    NSArray<NSString *> *titles = @[ NSLocalizedString(@"期数", nil), NSLocalizedString(@"投注", nil), NSLocalizedString(@"盈亏", nil), NSLocalizedString(@"结束时间", nil) ];
    UIFont *titleFont = FONT_PINGFANG_REGULAR(15);
    UIColor *titleColor = COLOR_SYSTEM_MAIN_FONT_DEFAULT;
    CGFloat itemWidth = SCREEN_WIDTH / titles.count;
    CGFloat itemHeight = kFyGameReportHeaderColumnTitleAreaHeight;
    
    UILabel *lastItemLabel = nil;
    for (NSInteger index = 0; index < titles.count; index ++) {
        lastItemLabel = ({
            UILabel *label = [UILabel new];
            [self.columnTitleContainer addSubview:label];
            [label setText:titles[index]];
            [label setFont:titleFont];
            [label setTextColor:titleColor];
            [label setTextAlignment:NSTextAlignmentCenter];
            
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(@(itemWidth));
                make.height.equalTo(@(itemHeight));
                
                if (!lastItemLabel) {
                    make.top.equalTo(self.columnTitleContainer.mas_top);
                    make.left.equalTo(self.columnTitleContainer.mas_left);
                } else {
                    make.top.equalTo(lastItemLabel.mas_top);
                    make.left.equalTo(lastItemLabel.mas_right);
                }
            }];
            
            label;
        });
        lastItemLabel.mas_key = [NSString stringWithFormat:@"titleLabel%ld", index];
    }
}


#pragma mark - FYGameReportViewControllerDelegate

- (void)doRefreshSectionHeaderGameReportStatisticsModel:(FYGameReportStatisticsModel *)gameReportStatisticsModel
{
    // 总投注
    NSString *totalBetting = [NSString stringWithFormat:@"%.2f", fabs(gameReportStatisticsModel.waterMoneyAll.floatValue)];
    [self.moneyTotalBettingLabel setText:totalBetting];
    
    // 总奖励
    {
        NSString *totalBonus = [NSString stringWithFormat:@"%.2f", fabs(gameReportStatisticsModel.rewardMoneyAll.floatValue)];
        if (gameReportStatisticsModel.rewardMoneyAll.floatValue == 0) {
            NSDictionary *attrText = @{ NSForegroundColorAttributeName:COLOR_SYSTEM_MAIN_FONT_DEFAULT};
            NSString *content = [NSString stringWithFormat:@"%@", totalBonus];
            NSAttributedString *attrString = [CFCSysUtil attributedString:@[content] attributeArray:@[attrText]];
            [self.moneyTotalBonusLabel setAttributedText:attrString];
        } else if (gameReportStatisticsModel.rewardMoneyAll.floatValue < 0) {
            NSDictionary *attrText = @{ NSForegroundColorAttributeName:COLOR_SYSTEM_MAIN_FONT_DEFAULT};
            NSString *content = [NSString stringWithFormat:@"- %@", totalBonus];
            NSAttributedString *attrString = [CFCSysUtil attributedString:@[content] attributeArray:@[attrText]];
            [self.moneyTotalBonusLabel setAttributedText:attrString];
        } else {
            NSDictionary *attrText = @{ NSForegroundColorAttributeName:COLOR_SYSTEM_MAIN_UI_THEME_DEFAULT};
            NSString *content = [NSString stringWithFormat:@"+ %@", totalBonus];
            NSAttributedString *attrString = [CFCSysUtil attributedString:@[content] attributeArray:@[attrText]];
           [self.moneyTotalBonusLabel setAttributedText:attrString];
        }
    }
    
    // 总盈利
    {
        NSString *totalProfitLoss = [NSString stringWithFormat:@"%.2f", fabs(gameReportStatisticsModel.moneyAll.floatValue)];
        if (gameReportStatisticsModel.moneyAll.floatValue == 0) {
            NSDictionary *attrText = @{ NSForegroundColorAttributeName:COLOR_SYSTEM_MAIN_FONT_DEFAULT};
            NSString *content = [NSString stringWithFormat:@"%@", totalProfitLoss];
            NSAttributedString *attrString = [CFCSysUtil attributedString:@[content] attributeArray:@[attrText]];
            [self.moneyTotalProfitLossLabel setAttributedText:attrString];
        } else if (gameReportStatisticsModel.moneyAll.floatValue < 0) {
            NSDictionary *attrText = @{ NSForegroundColorAttributeName:COLOR_SYSTEM_MAIN_FONT_DEFAULT};
            NSString *content = [NSString stringWithFormat:@"- %@", totalProfitLoss];
            NSAttributedString *attrString = [CFCSysUtil attributedString:@[content] attributeArray:@[attrText]];
            [self.moneyTotalProfitLossLabel setAttributedText:attrString];
        } else {
            NSDictionary *attrText = @{ NSForegroundColorAttributeName:COLOR_SYSTEM_MAIN_UI_THEME_DEFAULT};
            NSString *content = [NSString stringWithFormat:@"+ %@", totalProfitLoss];
            NSAttributedString *attrString = [CFCSysUtil attributedString:@[content] attributeArray:@[attrText]];
           [self.moneyTotalProfitLossLabel setAttributedText:attrString];
        }
    }
}


#pragma mark - Getter & Setter

- (UIView *)statisticsContainer
{
    if (!_statisticsContainer) {
        _statisticsContainer = [[UIView alloc] init];
        [_statisticsContainer setBackgroundColor:[UIColor whiteColor]];
    }
    return _statisticsContainer;
}

- (UIView *)splitLineContainer
{
    if (!_splitLineContainer) {
        _splitLineContainer = [[UIView alloc] init];
        [_splitLineContainer setBackgroundColor:COLOR_TABLEVIEW_BACK_VIEW_BACKGROUND_DEFAULT];
    }
    return _splitLineContainer;
}

- (UIView *)columnTitleContainer
{
    if (!_columnTitleContainer) {
        _columnTitleContainer = [[UIView alloc] init];
        [_columnTitleContainer setBackgroundColor:[UIColor whiteColor]];
        [_columnTitleContainer addBorderWithColor:COLOR_TABLEVIEW_BACK_VIEW_BACKGROUND_DEFAULT cornerRadius:0.0f andWidth:SEPARATOR_LINE_HEIGHT];
    }
    return _columnTitleContainer;
}

- (UILabel *)moneyTotalBettingLabel
{
    if (!_moneyTotalBettingLabel) {
        _moneyTotalBettingLabel = [[UILabel alloc] init];
        [_moneyTotalBettingLabel setText:@"0.00"];
        [_moneyTotalBettingLabel setFont:FONT_PINGFANG_REGULAR(15)];
        [_moneyTotalBettingLabel setTextColor:COLOR_SYSTEM_MAIN_FONT_DEFAULT];
        [_moneyTotalBettingLabel setTextAlignment:NSTextAlignmentCenter];
    }
    return _moneyTotalBettingLabel;
}

- (UILabel *)moneyTotalBonusLabel
{
    if (!_moneyTotalBonusLabel) {
        _moneyTotalBonusLabel = [[UILabel alloc] init];
        [_moneyTotalBonusLabel setText:@"0.00"];
        [_moneyTotalBonusLabel setFont:FONT_PINGFANG_REGULAR(15)];
        [_moneyTotalBonusLabel setTextColor:COLOR_SYSTEM_MAIN_FONT_DEFAULT];
        [_moneyTotalBonusLabel setTextAlignment:NSTextAlignmentCenter];
    }
    return _moneyTotalBonusLabel;
}

- (UILabel *)moneyTotalProfitLossLabel
{
    if (!_moneyTotalProfitLossLabel) {
        _moneyTotalProfitLossLabel = [[UILabel alloc] init];
        [_moneyTotalProfitLossLabel setText:@"0.00"];
        [_moneyTotalProfitLossLabel setFont:FONT_PINGFANG_REGULAR(15)];
        [_moneyTotalProfitLossLabel setTextColor:COLOR_SYSTEM_MAIN_FONT_DEFAULT];
        [_moneyTotalProfitLossLabel setTextAlignment:NSTextAlignmentCenter];
    }
    return _moneyTotalProfitLossLabel;
}


@end

