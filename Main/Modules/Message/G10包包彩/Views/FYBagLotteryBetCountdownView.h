//
//  FYBagLotteryBetCountdownView.h
//  ProjectCSHB
//
//  Created by Tom on 2020/7/22.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
///包包彩倒计时
@interface FYBagLotteryBetCountdownView : UIView
@property (nonatomic , strong) RobNiuNiuQunModel *model;
- (void)stopTime;
@end

NS_ASSUME_NONNULL_END
