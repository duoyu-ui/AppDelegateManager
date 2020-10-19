//
//  FYRechargeOfficialViewController.h
//  ProjectCSHB
//
//  Created by fangyuan on 2020/5/24.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "CFCBaseCoreViewController.h"

NS_ASSUME_NONNULL_BEGIN

@class FYPayModeModel;
@interface FYRechargeOfficialViewController : CFCBaseCoreViewController

- (instancetype)initWithUserRealName:(NSString *)userRealName money:(NSString *)money payModeModel:(FYPayModeModel *)payModeModel;

@end

NS_ASSUME_NONNULL_END
