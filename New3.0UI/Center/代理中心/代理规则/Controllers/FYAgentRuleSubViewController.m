//
//  FYAgentRuleSubViewController.m
//  ProjectCSHB
//
//  Created by fangyuan on 2020/7/29.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "FYAgentRuleViewController.h"
#import "FYAgentRuleSubViewController.h"

@interface FYAgentRuleSubViewController ()

@end

@implementation FYAgentRuleSubViewController

#pragma mark - Life Cycle

- (instancetype)initWithTabTitleCode:(NSString *)tabTitleCode
{
    self = [super init];
    if (self) {
        self.hasTableViewRefresh = NO;
    }
    return self;
}


#pragma mark - FYGamesMain1ViewControllerProtocol

- (void)doRefreshForAgentRuleSubController:(NSString *)tabTitleCode
{
   if (self.delegate && [self.delegate respondsToSelector:@selector(doAnyThingForSuperViewController:)]) {
       [self.delegate doAnyThingForSuperViewController:FYScrollPageForSuperViewTypeTableEndRefresh];
   }
}

- (void)doRefreshForAgentRuleSubContentTableScrollToTopAnimated:(BOOL)animated
{
    
}


@end
