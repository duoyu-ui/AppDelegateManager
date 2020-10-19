//
//  FYBagLotteryBetFooterView.h
//  ProjectCSHB
//
//  Created by Tom on 2020/7/20.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol FYBagLotteryBetFooterDelegate <NSObject>
///删除
- (void)bagLotteryBetDelete;

/// 投注
- (void)bagLotteryBetWithMoney:(NSString *)money;
///消失
- (void)bagLotteryBetDismiss;

/// 选择money
- (void)bagLotteryBetSeletWithMoney:(NSString *)money;
@end
@interface FYBagLotteryBetFooterView : UIView
@property (nonatomic , weak) id<FYBagLotteryBetFooterDelegate> delegate;
@property (nonatomic , copy) NSString *singleMoneyTips;
@property (nonatomic , strong) UITextField *tf;
@property (nonatomic , strong) UILabel *moneyLab;
@property (nonatomic , strong) UIButton *betBtn;
@end

NS_ASSUME_NONNULL_END
