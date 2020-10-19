//
//  FYAgentReportViewController.h
//  ProjectCSHB
//
//  Created by fangyuan on 2020/6/27.
//  Copyright © 2020 Fangyuan. All rights reserved.
//
//  代理报表
//

#import "FYAgentSearchViewController.h"

NS_ASSUME_NONNULL_BEGIN

@protocol FYAgentReportViewControllerProtocol <NSObject>
@optional
- (void)doScrollAgentReportSubTableToTopAnimated:(BOOL)animated;
- (void)doRefreshForAgentReportSubViewController:(NSString *)tabTitleCode searchMemberKey:(NSString *)searchMemberKey;
@end


@interface FYAgentReportViewController : FYAgentSearchViewController

@property (nonatomic, weak) id<FYAgentReportViewControllerProtocol> delegate_subclass;

- (instancetype)initWithSearchMemberKey:(NSString *)searchMemberKey isFromMineCenter:(BOOL)isFromMineCenter;

@end

NS_ASSUME_NONNULL_END
