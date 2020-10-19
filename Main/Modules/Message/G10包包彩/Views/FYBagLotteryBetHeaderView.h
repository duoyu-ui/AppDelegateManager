//
//  FYBagLotteryBetHeaderView.h
//  ProjectCSHB
//
//  Created by Tom on 2020/7/20.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN
@protocol FYBagLotteryBetHeaderDelegate <NSObject>
///查看余额
- (void)didActionOfCheckBalance;
///充值
- (void)didActionOfRecharge;
///玩法
- (void)didActionOfPlayRule;
///分享
- (void)didActionOfShare;
@end

///包包彩投注头部
@interface FYBagLotteryBetHeaderView : UIView
@property (nonatomic , weak) id<FYBagLotteryBetHeaderDelegate> delegate;
@property (nonatomic , copy) NSString *balance;
@end

NS_ASSUME_NONNULL_END
