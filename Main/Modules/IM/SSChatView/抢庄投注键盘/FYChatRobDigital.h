//
//  FYChatRobDigital.h
//  ProjectCSHB
//
//  Created by 汤姆 on 2019/10/8.
//  Copyright © 2019 Jetter. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FYChatRobKeyboardModel.h"
/**
 数字键盘
 */
@interface FYChatRobDigital : UIView


@property (nonatomic, copy) NSString *input;
/** 类型 2:抢庄 3:投注*/
@property (nonatomic, assign) NSInteger type;
/** 代理*/
@property (nonatomic, weak) id<FYChatRobKeyboardViewOutputDelegate> delegate;
@end


