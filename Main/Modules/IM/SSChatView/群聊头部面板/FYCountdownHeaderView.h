//
//  FYCountdownHeaderView.h
//  ProjectCSHB
//
//  Created by Tom on 2020/6/30.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RobNiuNiuQunModel.h"
NS_ASSUME_NONNULL_BEGIN
///群聊倒计时控件
@interface FYCountdownHeaderView : UIView
/* 模型 - 模型 */
@property (nonatomic, strong) RobNiuNiuQunModel *modelOfNiuNiu;

///开始倒计时
- (void)startTimer;

///停止倒计时
- (void)stopTimer;

@end

NS_ASSUME_NONNULL_END
