//
//  FYBagLotteryTrendTableViewCell.h
//  ProjectCSHB
//
//  Created by fangyuan on 2020/7/25.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FYBagLotteryTrendModel;

NS_ASSUME_NONNULL_BEGIN

@interface FYBagLotteryTrendTableViewCell : UITableViewCell

@property (nonatomic, strong) NSIndexPath *indexPath;

@property (nonatomic, strong) FYBagLotteryTrendModel *model;

+ (NSString *)reuseIdentifier;

+ (CGFloat)height;

@end

NS_ASSUME_NONNULL_END
