//
//  FYBagLotteryTrendChartView.m
//  ProjectCSHB
//
//  Created by fangyuan on 2020/7/25.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "FYBagLotteryTrendChartView.h"
#import "FYBagLotteryTrendSectionHeader.h"
#import "FYBagLotteryTrendModel.h"

CGFloat const kFyBagLotteryTrendChartSplitLineAreaHeight = 3.0f; // 间隔

@interface FYBagLotteryTrendChartView ()
@property(nonatomic, assign) CGFloat trendChartItemWidth;
@property(nonatomic, assign) CGFloat trendChartItemHeight;
@property(nonatomic, strong) NSMutableArray<UILabel *> *itemUnOpenLabels;
@property(nonatomic, strong) NSMutableArray<UILabel *> *itemLinkOpenLabels;
@property(nonatomic, strong) NSMutableArray<UIView *> *itemChartBackViews;
@end

@implementation FYBagLotteryTrendChartView

#pragma mark - Life Cycle

+ (CGFloat)headerViewHeight
{
    return SCREEN_MIN_LENGTH * 0.45f;
}

+ (CGFloat)heightOfTrendChartTitle
{
    return [FYBagLotteryTrendSectionHeader columnWidthOfNum] * 0.95f;
}

+ (CGFloat)heightOfTrendChartLinkUnOpen
{
    return [FYBagLotteryTrendSectionHeader columnWidthOfNum] * 0.9f;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _trendChartItemWidth = frame.size.width * 0.1f;
        _trendChartItemHeight = frame.size.height - [FYBagLotteryTrendChartView heightOfTrendChartTitle] - [FYBagLotteryTrendChartView heightOfTrendChartLinkUnOpen]*2.0f;
        [self createViewAtuoLayout];
    }
    return self;
}

- (void)createViewAtuoLayout
{
    // 连开期数/未开期数
    {
        CGFloat firstItemWidth = [FYBagLotteryTrendSectionHeader columnWidthOfIssue];
        CGFloat lastItemWidth = [FYBagLotteryTrendSectionHeader columnWidthOfXingTai];
        CGFloat numItemWidth = [FYBagLotteryTrendSectionHeader columnWidthOfNum];
        NSArray<NSString *> *titlesOfUnOpen = @[ NSLocalizedString(@"未开期数", nil), @"", @"", @"", @"", @"", @"", @"", @"", @"", @"", @"" ];
        NSArray<NSString *> *titlesOfLinkOpen = @[ NSLocalizedString(@"连开期数", nil), @"", @"", @"", @"", @"", @"", @"", @"", @"", @"", @"" ];
        NSArray<NSNumber *> *itemWidths = @[ @(firstItemWidth), @(numItemWidth), @(numItemWidth), @(numItemWidth), @(numItemWidth), @(numItemWidth), @(numItemWidth), @(numItemWidth), @(numItemWidth), @(numItemWidth), @(numItemWidth), @(lastItemWidth) ];
        CGFloat itemHeight = [FYBagLotteryTrendChartView heightOfTrendChartLinkUnOpen];
        UIFont *itemFont = FONT_PINGFANG_SEMI_BOLD(13);
        UIColor *itemColor = COLOR_HEXSTRING(@"#FFFFFF");
        UIColor *itemBackColor = COLOR_HEXSTRING(@"#20AEE5");
        
        UILabel *lastItemLabel = nil;
        self.itemUnOpenLabels = [NSMutableArray array];
        self.itemLinkOpenLabels = [NSMutableArray array];
        for (NSInteger index = 0; index < titlesOfUnOpen.count && index < titlesOfLinkOpen.count; index ++) {
            CGFloat itemWidth = [itemWidths objectAtIndex:index].floatValue;
            // 未开期数
            UILabel *itemUnOpenLabel = ({
                UILabel *label = [UILabel new];
                [self addSubview:label];
                [label setText:titlesOfUnOpen[index]];
                [label setFont:itemFont];
                [label setTextColor:itemColor];
                [label setBackgroundColor:itemBackColor];
                [label setTextAlignment:NSTextAlignmentCenter];
                
                [label mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.width.equalTo(@(itemWidth));
                    make.height.equalTo(@(itemHeight));
                    if (!lastItemLabel) {
                        make.bottom.equalTo(self.mas_bottom);
                        make.left.equalTo(self.mas_left);
                    } else {
                        make.bottom.equalTo(lastItemLabel.mas_bottom);
                        make.left.equalTo(lastItemLabel.mas_right);
                    }
                }];
                
                label;
            });
            // 连开期数
            UILabel *itemLinkOpenLabel = ({
                UILabel *label = [UILabel new];
                [self addSubview:label];
                [label setText:titlesOfLinkOpen[index]];
                [label setFont:itemFont];
                [label setTextColor:itemColor];
                [label setBackgroundColor:itemBackColor];
                [label setTextAlignment:NSTextAlignmentCenter];
                
                [label mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.width.equalTo(@(itemWidth));
                    make.height.equalTo(@(itemHeight));
                    make.left.equalTo(itemUnOpenLabel.mas_left);
                    make.bottom.equalTo(itemUnOpenLabel.mas_top);
                }];
                
                label;
            });
            //
            [self.itemUnOpenLabels addObj:itemUnOpenLabel];
            [self.itemLinkOpenLabels addObj:itemLinkOpenLabel];
            //
            lastItemLabel = itemUnOpenLabel;
        }
        
        // 分割线
        {
            // 分割线 - 横线
            for (NSInteger index = 0; index < titlesOfUnOpen.count && index < titlesOfLinkOpen.count; index ++) {
                UILabel *itemUnOpenLabel = [self.itemUnOpenLabels objectAtIndex:index];
                UILabel *itemLinkOpenLabel = [self.itemLinkOpenLabels objectAtIndex:index];
                if (index < titlesOfUnOpen.count-1) {
                    UIView *splitLineView = ({
                        UIView *view = [[UIView alloc] init];
                        [view setBackgroundColor:COLOR_TABLEVIEW_SEPARATOR_LINE_DEFAULT];
                        [self addSubview:view];
                        
                        [view mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.top.equalTo(itemLinkOpenLabel.mas_top);
                            make.bottom.equalTo(itemUnOpenLabel.mas_bottom);
                            make.centerX.equalTo(itemUnOpenLabel.mas_right);
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
                [self addSubview:view];
                
                [view mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerY.equalTo(self.itemUnOpenLabels.firstObject.mas_top);
                    make.left.equalTo(self.mas_left);
                    make.right.equalTo(self.mas_right);
                    make.height.mas_equalTo(SEPARATOR_LINE_HEIGHT);
                }];
                
                view;
            });
            separatorLineView.mas_key = @"separatorLineView";
        }
    }
    
    // 柱状图
    {
        self.itemChartBackViews = [NSMutableArray array];
        NSArray<NSString *> *chartTitles = @[ @"0", @"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9" ];
        for (NSInteger index = 0; index < chartTitles.count; index ++) {
            // 容器
            UIColor *backgroundColor = index % 2 ? COLOR_HEXSTRING(@"#E0E0E0") : COLOR_HEXSTRING(@"#F1F1F1");
            CGRect frame = CGRectMake(self.trendChartItemWidth*index, 0, self.trendChartItemWidth, self.trendChartItemHeight);
            UIView *itemChartBackView = [[UIView alloc] initWithFrame:frame];
            [itemChartBackView setBackgroundColor:backgroundColor];
            [self addSubview:itemChartBackView];
            [self.itemChartBackViews addObj:itemChartBackView];
            // 标题
            UILabel *itemCharTitleLabel = ({
                UILabel *label = [[UILabel alloc] init];
                [self addSubview:label];
                [label setText:chartTitles[index]];
                [label setFont:FONT_PINGFANG_REGULAR(13)];
                [label setTextColor:COLOR_SYSTEM_MAIN_FONT_DEFAULT];
                [label setBackgroundColor:COLOR_HEXSTRING(@"#FFFFFF")];
                [label setTextAlignment:NSTextAlignmentCenter];

                CGFloat itemCharTitleHeight = [FYBagLotteryTrendChartView heightOfTrendChartTitle] - kFyBagLotteryTrendChartSplitLineAreaHeight;
                [label mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.height.mas_equalTo(itemCharTitleHeight);
                    make.left.right.equalTo(itemChartBackView);
                    make.top.equalTo(itemChartBackView.mas_bottom);
                }];

                label;
            });
            itemCharTitleLabel.mas_key = @"itemCharTitleLabel";
        }
        // 分割线 - 竖线
        UIView *separatorLineView = ({
            UIView *view = [[UIView alloc] init];
            [view setBackgroundColor:COLOR_HEXSTRING(@"#C5C5C5")];
            [self addSubview:view];
            
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(self.itemChartBackViews.firstObject.mas_bottom).offset([FYBagLotteryTrendChartView heightOfTrendChartTitle]);
                make.left.equalTo(self.mas_left);
                make.right.equalTo(self.mas_right);
                make.height.mas_equalTo(kFyBagLotteryTrendChartSplitLineAreaHeight);
            }];
            
            view;
        });
        separatorLineView.mas_key = @"separatorLineView";
    }
}

/// 刷新走势图表
- (void)refreshTrendChart:(FYBagLotteryTrendResponse *)trendChartResponse
{
    // 重置控件
    for (NSInteger index = 1; index < self.itemUnOpenLabels.count; index ++) {
        UILabel *itemUnOpenLabel = [self.itemUnOpenLabels objectAtIndex:index];
        [itemUnOpenLabel setText:@""];
    }
    for (NSInteger index = 1; index < self.itemLinkOpenLabels.count; index ++) {
        UILabel *itemLinkOpenLabel = [self.itemLinkOpenLabels objectAtIndex:index];
        [itemLinkOpenLabel setText:@""];
    }
    for (NSInteger index = 0; index < self.itemChartBackViews.count; index ++) {
        UIView *itemChartBackView = [self.itemChartBackViews objectAtIndex:index];
        [itemChartBackView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [obj removeFromSuperview];
        }];
    }
    
    // 连开期数/未开期数
    for (NSInteger index = 0; index < trendChartResponse.data.twos.count; index ++) {
        FYBagLotteryTrendTwoModel *trendTwoModel = [trendChartResponse.data.twos objectAtIndex:index];
        NSInteger itemIndex = trendTwoModel.num.intValue + 1;
        // 未开期数
        if (itemIndex < self.itemUnOpenLabels.count) {
            UILabel *itemUnOpenLabel = [self.itemUnOpenLabels objectAtIndex:itemIndex];
            [itemUnOpenLabel setText:trendTwoModel.unOpen];
        }
        // 连开期数
        if (itemIndex < self.itemLinkOpenLabels.count) {
            UILabel *itemLinkOpenLabel = [self.itemLinkOpenLabels objectAtIndex:itemIndex];
            [itemLinkOpenLabel setText:trendTwoModel.linkOpen];
        }
    }
    
    // 柱状图
    {
        NSInteger minCount = NSIntegerMax;
        NSInteger maxCount = NSIntegerMin;
        for (NSInteger index = 0; index < trendChartResponse.data.ones.count; index ++) {
            FYBagLotteryTrendOneModel *trendOneModel = [trendChartResponse.data.ones objectAtIndex:index];
            if (minCount > trendOneModel.count.integerValue) {
                minCount = trendOneModel.count.integerValue;
            }
            if (maxCount < trendOneModel.count.integerValue) {
                maxCount = trendOneModel.count.integerValue;
            }
        }
        CGFloat min_max_count_gap = maxCount - minCount;
        CGFloat min_max_count_gap_base = minCount <= 0 ? 0.0f : min_max_count_gap * 0.15f;
        CGFloat chartTitleHeight = self.trendChartItemWidth * 0.4f;
        CGFloat chartContentHeight = self.trendChartItemHeight - chartTitleHeight;
        CGFloat chartItemWidth = self.trendChartItemWidth * 0.5f;
        for (NSInteger index = 0; index < trendChartResponse.data.ones.count; index ++) {
            FYBagLotteryTrendOneModel *trendOneModel = [trendChartResponse.data.ones objectAtIndex:index];
            NSInteger itemIndex = trendOneModel.num.intValue;
            NSInteger itemCount = trendOneModel.count.intValue;
            CGFloat chartItemHeight = 0.0f;
            CGFloat dividendNumber = (llabs(itemCount - minCount) + min_max_count_gap_base);
            CGFloat divisorNum = (min_max_count_gap + min_max_count_gap_base);
            if (divisorNum > 0) {
                chartItemHeight = chartContentHeight * (dividendNumber / divisorNum);
            }
            if (itemIndex < self.itemUnOpenLabels.count) {
                UIView *itemChartBackView = [self.itemChartBackViews objectAtIndex:itemIndex];
                // 柱状图
                UIView *histogramBar = ({
                    UIView *view = [[UIView alloc] init];
                    [view setBackgroundColor:COLOR_HEXSTRING(@"#20AEE5")];
                    [itemChartBackView addSubview:view];
                    [view mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.bottom.equalTo(itemChartBackView.mas_bottom);
                        make.centerX.equalTo(itemChartBackView.mas_centerX);
                        make.height.mas_equalTo(chartItemHeight);
                        make.width.mas_equalTo(chartItemWidth);
                    }];
                    view;
                });
                histogramBar.mas_key = @"histogramBar";
                // 标题
                UILabel *charTitleLabel = ({
                    UILabel *label = [[UILabel alloc] init];
                    [itemChartBackView addSubview:label];
                    [label setText:[NSString stringWithFormat:NSLocalizedString(@"%ld次", nil),itemCount]];
                    [label setFont:FONT_PINGFANG_REGULAR(11)];
                    [label setTextColor:COLOR_SYSTEM_MAIN_FONT_DEFAULT];
                    [label setTextAlignment:NSTextAlignmentCenter];
                    [label mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.left.right.equalTo(itemChartBackView);
                        make.bottom.equalTo(histogramBar.mas_top);
                    }];
                    label;
                });
                charTitleLabel.mas_key = @"charTitleLabel";
            }
        }
    }
}


@end

