//
//  FYAgentRegisterAlertView.h
//  ProjectCSHB
//
//  Created by fangyuan on 2020/5/27.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FYAgentRegisterAlertView : UIView

@property (nonatomic, copy) void(^confirmActionBlock)(void);

+ (void)alertWithTitle:(NSString *)title userName:(NSString *)userName password:(NSString *)password;

+ (void)alertWithTitle:(NSString *)title userName:(NSString *)userName password:(NSString *)password confirmBlock:(void(^)(void))block;

@end

NS_ASSUME_NONNULL_END
