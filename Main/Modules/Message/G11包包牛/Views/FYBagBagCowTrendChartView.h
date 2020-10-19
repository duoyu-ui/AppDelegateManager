//
//  FYBagBagCowTrendChartView.h
//  ProjectCSHB
//
//  Created by fangyuan on 2020/7/24.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FYBagBagCowTrendModel;

NS_ASSUME_NONNULL_BEGIN

@interface FYBagBagCowTrendChartView : UIView

+ (CGFloat)headerViewHeight;

- (void)refreshTrendChart:(NSMutableArray<FYBagBagCowTrendModel *> *)trendChartDataSource isBankerNumberTrendChart:(BOOL)isBankerNumberTrendChart;

@end

@interface FYBagBagCowTrendChartModel : NSObject
@property (nonatomic, assign) BOOL isLastIssue; // 是否最新开奖期号
@property (nonatomic, copy) NSString *issueNumber; // 期数
@property (nonatomic, copy) NSString *pointNumber; // 点数
//
@property (nonatomic, copy) NSString *issueShortNumber; // 期数缩写
@property (nonatomic, copy) NSString *pointNumberTitle; // 点数标题
@property (nonatomic, strong) UIFont *pointNumberTitleFont; // 点数字体
@property (nonatomic, strong) UIColor *pointNumberTitleColor; // 点数颜色
@property (nonatomic, strong) UIColor *pointNumberBackColor; // 点数背景颜色
@end

NS_ASSUME_NONNULL_END
