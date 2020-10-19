//
//  FYAgentReferralsViewController.h
//  ProjectCSHB
//
//  Created by fangyuan on 2020/6/27.
//  Copyright © 2020 Fangyuan. All rights reserved.
//
// 我的下线
//

#import "FYAgentSearchTableViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface FYAgentReferralsViewController : FYAgentSearchTableViewController

- (instancetype)initWithSearchMemberKey:(NSString *)searchMemberKey isFromMineCenter:(BOOL)isFromMineCenter;

@end

NS_ASSUME_NONNULL_END
