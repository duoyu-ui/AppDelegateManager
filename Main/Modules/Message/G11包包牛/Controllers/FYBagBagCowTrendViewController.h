//
//  FYBagBagCowTrendViewController.h
//  ProjectCSHB
//
//  Created by fangyuan on 2020/7/22.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "CFCTableRefreshViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface FYBagBagCowTrendViewController : CFCTableRefreshViewController <FYIMSessionViewControllerLotteryGameGroupInfoDelegate>

- (instancetype)initWithMessageItem:(MessageItem *)messageItem;

@end

NS_ASSUME_NONNULL_END
