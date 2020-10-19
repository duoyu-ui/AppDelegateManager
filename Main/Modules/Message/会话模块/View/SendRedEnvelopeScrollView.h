//
//  SendRedEnvelopeScrollView.h
//  ProjectCSHB
//
//  Created by Tom on 2020/6/19.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageItem.h"
NS_ASSUME_NONNULL_BEGIN

@protocol SendRedEnvelopeDelegate <NSObject>

/// 发红包代理
/// @param money 红包金额
/// @param count 红包个数
/// @param leiNums 雷号
- (void)sendRedMoney:(NSString *)money count:(NSString *)count leiNums:(NSString *)leiNums;
@end
///发包界面
@interface SendRedEnvelopeScrollView : UIScrollView
@property (nonatomic , strong) MessageItem *item;
@property (nonatomic , assign) BOOL isFu;
@property (nonatomic , weak) id<SendRedEnvelopeDelegate> srDelegate;

@end

NS_ASSUME_NONNULL_END
