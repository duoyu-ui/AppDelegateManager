//
//  FYBagLotteryBetHudView.h
//  ProjectCSHB
//
//  Created by Tom on 2020/7/21.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^goDetermine)(void);
///投注弹框
@interface FYBagLotteryBetHudView : UIView
/// 投注弹窗
/// @param list 数据源
/// @param singleMoney 单注金额
/// @param text 按钮确认还是跟单
/// @param title 标题
/// @param block 回调
+ (void)showBetHubWithList:(NSArray *)list singleMoney:(NSString *)singleMoney determineBtnText:(NSString *)text title:(NSString *)title block:(goDetermine)block;

@end


NS_ASSUME_NONNULL_END
