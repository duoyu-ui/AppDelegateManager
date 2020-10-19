//
//  FYAgentRuleSubViewController.h
//  ProjectCSHB
//
//  Created by fangyuan on 2020/7/29.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "FYScrollPageViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface FYAgentRuleSubViewController : FYScrollPageViewController <FYAgentRuleViewControllerProtocol>

- (instancetype)initWithTabTitleCode:(NSString *)tabTitleCode;

@end

NS_ASSUME_NONNULL_END
