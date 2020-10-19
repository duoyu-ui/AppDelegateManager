//
//  FYJSSLBettHUDView.h
//  ProjectCSHB
//
//  Created by Tom on 2020/8/28.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^bettDetermine)(void);
@class FYJSSLDataSource;
NS_ASSUME_NONNULL_BEGIN
///极速扫雷投注弹框
@interface FYJSSLBettHUDView : UIView
+ (void)showJJSLBetHubWithList:(NSArray <FYJSSLDataSource*>*)list money:(NSString*)money odds:(NSString*)odds block:(bettDetermine)block;
@end

NS_ASSUME_NONNULL_END
