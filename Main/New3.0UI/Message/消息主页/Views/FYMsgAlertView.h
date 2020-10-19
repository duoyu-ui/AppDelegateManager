//
//  FYMsgAlertView.h
//  ProjectCSHB
//
//  Created by fangyuan on 2020/5/29.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FYMsgAlertView : UIView

@property (nonatomic, copy) void(^confirmActionBlock)(void);

@property (nonatomic, copy) void(^cancleActionBlock)(void);

+ (void)alertWithTitle:(NSString *)title content:(NSString *)content confirmBlock:(void(^)(void))confirmBlock cancleBlock:(void(^)(void))cancleBlock;

@end

NS_ASSUME_NONNULL_END
