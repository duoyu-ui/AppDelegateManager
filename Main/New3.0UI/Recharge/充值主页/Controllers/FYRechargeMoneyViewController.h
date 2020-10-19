//
//  FYRechargeMoneyViewController.h
//  ProjectCSHB
//
//  Created by fangyuan on 2020/5/23.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "CFCBaseCoreViewController.h"

NS_ASSUME_NONNULL_BEGIN

@class FYPayModeModel;
@interface FYRechargeMoneyViewController : CFCBaseCoreViewController

- (instancetype)initWithPayModeModel:(FYPayModeModel *)payModeModel;

- (instancetype)initWithUserRealName:(NSString *)userRealName payModeModel:(FYPayModeModel *)payModeModel;

@end

NS_ASSUME_NONNULL_END
