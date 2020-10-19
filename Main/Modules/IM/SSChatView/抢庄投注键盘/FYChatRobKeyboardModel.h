//
//  FYChatRobKeyboardModel.h
//  ProjectCSHB
//
//  Created by 汤姆 on 2019/10/8.
//  Copyright © 2019 Jetter. All rights reserved.
//

#import <Foundation/Foundation.h>
#define KeyboardH (SCREEN_WIDTH - 80 - ([UIApplication sharedApplication].statusBarFrame.size.height == 20 ? 0 : 34))
@protocol FYChatRobKeyboardViewOutputDelegate<NSObject>

/**
 删除

 @param keyType 1:数字键盘,2货币键盘
 */
- (void)chatRobKeyboardDelete:(NSInteger)keyType;

/**
 手动输入,快捷输入

 @param keyType 1:数字键盘,2货币键盘
 */
- (void)chatRobKeyboardInput:(NSInteger)keyType;
/**
 抢庄投注

 @param type 2: 抢庄 ,3: 投注
 @param keyType 1:数字键盘,2货币键盘
 */
- (void)chatRobKeyboardType:(NSInteger)type keyType:(NSInteger)keyType;


/**
 键盘输出

 @param num 值
 @param keyType 1:数字键盘,2货币键盘
 */
- (void)chatRobKeyboardNum:(NSString*)num row:(NSInteger)row keyType:(NSInteger)keyType;


@end

@interface FYChatRobKeyboardModel : NSObject

@property (nonatomic, copy) NSString *text;

@end


