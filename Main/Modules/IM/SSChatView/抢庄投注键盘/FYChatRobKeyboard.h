//
//  FYChatRobKeyboard.h
//  ProjectCSHB
//
//  Created by 汤姆 on 2019/10/7.
//  Copyright © 2019 Jetter. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FYChatRobKeyboardDelegate <NSObject>
//投注,抢庄代理
- (void)chatRobKeyboardaAmount:(NSString*)Amount type:(NSInteger)type betAttr:(NSInteger)betAttr;
@end

@interface FYChatRobKeyboard : UIView

/// 投注,抢庄键盘
/// @param delegate 代理方法
/// @param dict 键盘数据
/// @param balance 余额
/// @param status 投注或者抢庄
/// @param gameType 游戏类型
+ (void)showPayKeyboardViewAnimate:(id<FYChatRobKeyboardDelegate>)delegate keyDict:(NSDictionary *)dict balance:(NSString*)balance   status:(NSInteger)status gameType:(NSInteger)gameType;
@end


