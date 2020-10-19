//
//  FYAgentRuleViewController.h
//  ProjectCSHB
//
//  Created by fangyuan on 2020/7/29.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "CFCBaseCoreViewController.h"

NS_ASSUME_NONNULL_BEGIN

@protocol FYAgentRuleViewControllerProtocol <NSObject>
@optional
- (void)doRefreshForAgentRuleSubController:(NSString *)tabTitleCode;
- (void)doRefreshForAgentRuleSubContentTableScrollToTopAnimated:(BOOL)animated;

@end

@interface FYAgentRuleViewController : CFCBaseCoreViewController

@property (nonatomic, weak) id<FYAgentRuleViewControllerProtocol> delegate_subclass;

/// 头部高度
+ (CGFloat)heightOfHeaderSpline;
+ (CGFloat)heightOfHeaderSegment;

@end

NS_ASSUME_NONNULL_END
