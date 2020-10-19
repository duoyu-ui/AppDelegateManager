//
//  FYNewRobChatKeyBord.h
//  ProjectCSHB
//
//  Created by Tom on 2020/6/25.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol FYNewRobChatKeyboardDelegate <NSObject>

/// 抢庄,投注,龙虎和代理
/// @param Amount 金额
/// @param status 2:抢庄 3:投注
/// @param lhh 0:龙 1:虎 2:和
- (void)chatRobKeyboardaAmount:(NSString*)Amount status:(NSInteger)status lhh:(NSInteger)lhh;
///充值
- (void)goToPay;
@end
///投注,抢庄键盘
@interface FYNewRobChatKeyBord : UIView
+ (void)showPayKeyboardViewAnimate:(id<FYNewRobChatKeyboardDelegate>)delegate moneyArr:(NSArray <NSString*>*)moneyArr money:(NSString *)money status:(NSInteger)status gameType:(NSInteger)gameType;
@end

NS_ASSUME_NONNULL_END
