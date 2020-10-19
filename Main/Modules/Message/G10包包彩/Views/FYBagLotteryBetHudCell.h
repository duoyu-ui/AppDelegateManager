//
//  FYBagLotteryBetHudCell.h
//  ProjectCSHB
//
//  Created by Tom on 2020/7/21.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FYBagLotteryBetHudData.h"
NS_ASSUME_NONNULL_BEGIN

@interface FYBagLotteryBetHudCell : UITableViewCell

- (void)setHudData:(FYBagLotteryBetHudData *)list money:(NSString *)money;
@end

NS_ASSUME_NONNULL_END
