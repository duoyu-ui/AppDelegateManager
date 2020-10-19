//
//  FYBagLotteryTrendController.h
//  ProjectCSHB
//
//  Created by fangyuan on 2020/7/25.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "CFCTableRefreshViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface FYBagLotteryTrendController : CFCTableRefreshViewController <FYIMSessionViewControllerLotteryGameGroupInfoDelegate>

- (instancetype)initWithMessageItem:(MessageItem *)messageItem;

@end

NS_ASSUME_NONNULL_END
