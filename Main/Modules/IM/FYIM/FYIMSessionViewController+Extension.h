//
//  FYIMSessionViewController+Extension.h
//  ProjectCSHB
//
//  Created by Tom on 2020/7/22.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "FYIMSessionViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface FYIMSessionViewController (Extension)
///更新群信息
- (void)UpdateGroupInfo;
/// 重新获取群配置（加注金额，上庄比例）
- (void)reloadPlayGroupInfo;
/// 抢庄牛牛投注
/// @param money 投注金额
- (void)robNiuNiuBett:(NSString *)money betAttr:(NSInteger)betAttr;
/// 抢庄
- (void)robNiuNiuBankeer:(NSString *)money;
///包包彩投注点击事件处理
-(void)didChatBagbagBetCell:(FYMessage *)model row:(NSInteger)row;

/// 包包牛cell投注点击事件处理
/// @param row 1:跟投 2:复制
- (void)didBagBagCowBetCell:(FYMessage *)model row:(NSInteger)row;
///包包牛键盘投注按钮
- (void)bagBagCowBetKeyboardButtonEvent;
///更新余额
- (void)updateBalance;
@end

NS_ASSUME_NONNULL_END
