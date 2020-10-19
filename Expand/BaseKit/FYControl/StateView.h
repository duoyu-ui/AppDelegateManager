//
//  StateView.h
//  Project
//
//  Created by mac on 2018/8/27.
//  Copyright © 2018年 CDJay. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^CDStateHandleBlock)(void);
typedef void (^CDStateTapHandleBlock)(void);

@interface StateView : UIView

+ (instancetype)StateViewWithHandle:(CDStateHandleBlock)handle;

+ (instancetype)stateWithTapHandle:(CDStateTapHandleBlock)block;

- (void)showEmpty;
- (void)showNetError;
- (void)showEmpty:(NSString *)title;
- (void)showNetError:(NSString *)errmsg;
- (void)hidState;

@end
