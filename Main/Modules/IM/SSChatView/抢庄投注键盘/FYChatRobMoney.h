//
//  FYChatRobMoney.h
//  ProjectCSHB
//
//  Created by 汤姆 on 2019/10/8.
//  Copyright © 2019 Jetter. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FYChatRobKeyboardModel.h"
@interface FYChatRobMoney : UIView

@property (nonatomic, strong) NSDictionary *dict;
/** 类型 2:抢庄 3:投注*/
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, copy) NSString *input;
/** 代理*/
@property (nonatomic, weak) id<FYChatRobKeyboardViewOutputDelegate> delegate;
@end


