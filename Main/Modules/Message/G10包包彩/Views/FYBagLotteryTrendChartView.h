//
//  FYBagLotteryTrendChartView.h
//  ProjectCSHB
//
//  Created by fangyuan on 2020/7/25.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FYBagLotteryTrendResponse;

NS_ASSUME_NONNULL_BEGIN

@interface FYBagLotteryTrendChartView : UIView

+ (CGFloat)headerViewHeight;

- (void)refreshTrendChart:(FYBagLotteryTrendResponse *)trendChartResponse;

@end

NS_ASSUME_NONNULL_END
