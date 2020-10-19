//
//  FYBagLotteryTrendTableViewCell.m
//  ProjectCSHB
//
//  Created by fangyuan on 2020/7/25.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "FYBagLotteryTrendTableViewCell.h"
#import "FYBagLotteryTrendSectionHeader.h"
#import "FYBagLotteryTrendModel.h"

@interface FYBagLotteryTrendTableViewCell ()
@property (nonnull, nonatomic, strong) NSMutableArray<UILabel *> *itemContainerLabels;
@end

@implementation FYBagLotteryTrendTableViewCell

+ (NSString *)reuseIdentifier
{
    return NSStringFromClass(self);
}

+ (CGFloat)height
{
    return [FYBagLotteryTrendSectionHeader columnWidthOfNum];
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
    CGFloat firstItemWidth = [FYBagLotteryTrendSectionHeader columnWidthOfIssue];
    CGFloat lastItemWidth = [FYBagLotteryTrendSectionHeader columnWidthOfXingTai];
    CGFloat numItemWidth = [FYBagLotteryTrendSectionHeader columnWidthOfNum];
    NSArray<NSString *> *titles = @[ NSLocalizedString(@"期号", nil), @"0", @"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", NSLocalizedString(@"形态", nil) ];
    NSArray<NSNumber *> *itemWidths = @[ @(firstItemWidth), @(numItemWidth), @(numItemWidth), @(numItemWidth), @(numItemWidth), @(numItemWidth), @(numItemWidth), @(numItemWidth), @(numItemWidth), @(numItemWidth), @(numItemWidth), @(lastItemWidth) ];
    CGFloat itemHeight = [FYBagLotteryTrendTableViewCell height];
    UIFont *itemFont = FONT_PINGFANG_REGULAR(14);
    UIColor *itemColor = COLOR_SYSTEM_MAIN_FONT_DEFAULT;
    
    UILabel *lastItemLabel = nil;
    self.itemContainerLabels = [NSMutableArray array];
    for (NSInteger index = 0; index < titles.count; index ++) {
        CGFloat itemWidth = [itemWidths objectAtIndex:index].floatValue;
        lastItemLabel = ({
            UILabel *label = [UILabel new];
            [self.contentView addSubview:label];
            [label setFont:itemFont];
            [label setTextColor:itemColor];
            [label setTextAlignment:NSTextAlignmentCenter];
            [label setBackgroundColor:[UIColor whiteColor]];
            
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(@(itemWidth));
                make.height.equalTo(@(itemHeight));
                if (!lastItemLabel) {
                    make.top.equalTo(self.contentView.mas_top);
                    make.left.equalTo(self.contentView.mas_left);
                } else {
                    make.top.equalTo(lastItemLabel.mas_top);
                    make.left.equalTo(lastItemLabel.mas_right);
                }
            }];
            
            label;
        });
        [self.itemContainerLabels addObj:lastItemLabel];
    }
    
    // 分割线
    {
        // 分割线 - 横线
        for (NSInteger index = 0; index < titles.count; index ++) {
            UILabel *containerLabel = [self.itemContainerLabels objectAtIndex:index];
            if (index < titles.count-1) {
                UIView *splitLineView = ({
                    UIView *view = [[UIView alloc] init];
                    [view setBackgroundColor:COLOR_TABLEVIEW_SEPARATOR_LINE_DEFAULT];
                    [self.contentView addSubview:view];
                    
                    [view mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.top.bottom.equalTo(self.contentView);
                        make.centerX.equalTo(containerLabel.mas_right);
                        make.width.mas_equalTo(SEPARATOR_LINE_HEIGHT);
                    }];
                    
                    view;
                });
                splitLineView.mas_key = @"splitLineView";
            }
        }
        // 分割线 - 竖线
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
        separatorLineView.mas_key = @"separatorLineView";
    }
}


#pragma mark - 设置数据模型
- (void)setModel:(FYBagLotteryTrendModel *)model
{
    if (![model isKindOfClass:[FYBagLotteryTrendModel class]]) {
        return;
    }
    
    _model = model;
    
    // 重置控件
    for (NSInteger index = 0; index < self.itemContainerLabels.count; index ++) {
        UILabel *containerLabel = [self.itemContainerLabels objectAtIndex:index];
        [containerLabel setBackgroundColor:[UIColor whiteColor]];
        [containerLabel setText:@""];
        [containerLabel.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [obj removeFromSuperview];
        }];
    }
    
    // 游戏期号
    if (self.itemContainerLabels.count > 0) {
        [self.itemContainerLabels.firstObject setText:[NSString stringWithFormat:@"%@", self.model.gameNumber]];
    }
    
    // 是否未开奖期号
    if (self.model.isIssuePlaying) {
        for (NSInteger index = 1; index < self.itemContainerLabels.count; index ++) {
            UILabel *containerLabel = [self.itemContainerLabels objectAtIndex:index];
            [containerLabel setTextColor:COLOR_SYSTEM_MAIN_FONT_DEFAULT];
            [containerLabel setText:@"?"];
        }
    } else {
        if (self.model.subs.count <= 0) {
            for (NSInteger index = 1; index < self.itemContainerLabels.count; index ++) {
                UILabel *containerLabel = [self.itemContainerLabels objectAtIndex:index];
                [containerLabel setTextColor:COLOR_SYSTEM_MAIN_FONT_DEFAULT];
                [containerLabel setText:@"?"];
            }
        } else {
            NSInteger maxNumCount = 0; // 数字最大次数，2个为对子，3个以上为豹子
            for (NSInteger index = 0; index < self.model.subs.count; index ++) {
                FYBagLotteryTrendSubModel *subModel = [self.model.subs objectAtIndex:index];
                if (subModel.numCount.integerValue > maxNumCount) {
                    maxNumCount = subModel.numCount.integerValue;
                }
                //
                UIColor *itemColor = COLOR_SYSTEM_MAIN_FONT_DEFAULT;
                UILabel *containerLabel = [self getItemContainerLabel:subModel.num];
                [containerLabel setBackgroundColor:COLOR_HEXSTRING(@"#F6F6F6")];
                // 中奖号码
                UILabel *numberLabel = ({
                    UILabel *label = [UILabel new];
                    [containerLabel addSubview:label];
                    [label setText:subModel.num];
                    [label setTextColor:itemColor];
                    [label setFont:FONT_PINGFANG_REGULAR(14)];
                    [label setTextAlignment:NSTextAlignmentCenter];
                    
                    [label mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.centerX.equalTo(containerLabel.mas_centerX);
                        make.centerY.equalTo(containerLabel.mas_centerY);
                    }];
                    
                    label;
                });
                numberLabel.mas_key = @"numberLabel";
                // 中奖号码出现次数
                if (subModel.numCount.integerValue > 1) {
                    if (subModel.numCount.integerValue >= 3) {
                        itemColor = COLOR_SYSTEM_MAIN_UI_THEME_DEFAULT;
                    } else if (subModel.numCount.integerValue >= 2) {
                        itemColor = COLOR_HEXSTRING(@"#3875F6");
                    }
                    [numberLabel setTextColor:itemColor];
                    //
                    UILabel *countLabel = ({
                        UILabel *label = [UILabel new];
                        [containerLabel addSubview:label];
                        [label setText:subModel.numCount];
                        [label setTextColor:itemColor];
                        [label setFont:FONT_PINGFANG_REGULAR(9)];
                        [label setTextAlignment:NSTextAlignmentLeft];
                        
                        [label mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.left.equalTo(numberLabel.mas_right).offset(1.0f);
                            make.top.equalTo(numberLabel.mas_top).offset(1.0f);
                        }];
                        
                        label;
                    });
                    countLabel.mas_key = @"countLabel";
                }
            }
            
            // 形态
            if (maxNumCount >= 3) {
                [self.itemContainerLabels.lastObject setText:NSLocalizedString(@"豹子", nil)];
                [self.itemContainerLabels.lastObject setTextColor:COLOR_SYSTEM_MAIN_UI_THEME_DEFAULT];
            } else if (maxNumCount >= 2) {
                [self.itemContainerLabels.lastObject setText:NSLocalizedString(@"对子", nil)];
                [self.itemContainerLabels.lastObject setTextColor:COLOR_HEXSTRING(@"#3875F6")];
            } else {
                [self.itemContainerLabels.lastObject setText:@""];
                [self.itemContainerLabels.lastObject setTextColor:COLOR_SYSTEM_MAIN_FONT_DEFAULT];
            }
        }
    }
    
}

- (UILabel *)getItemContainerLabel:(NSString *)num
{
    if (num.integerValue < 0 || num.integerValue > 9) {
        return nil;
    }
    
    NSInteger index = num.integerValue + 1;
    if (index >= self.itemContainerLabels.count) {
        return nil;
    }
    return [self.itemContainerLabels objectAtIndex:index];
}



@end

