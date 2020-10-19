//
//  FYBagLotteryRecordTableViewCell.h
//  ProjectCSHB
//
//  Created by fangyuan on 2020/7/24.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FYBagLotteryRecordModel;

NS_ASSUME_NONNULL_BEGIN


@protocol FYBagLotteryRecordTableViewCellDelegate <NSObject>
@optional
- (void)didSelectRowAtBagLotteryRecordModel:(FYBagLotteryRecordModel *)model indexPath:(NSIndexPath *)indexPath;
@end


@interface FYBagLotteryRecordTableViewCell : UITableViewCell

@property (nonatomic, strong) NSIndexPath *indexPath;

@property (nonatomic, strong) FYBagLotteryRecordModel *model;

@property (nonatomic, weak) id<FYBagLotteryRecordTableViewCellDelegate> delegate;

+ (NSString *)reuseIdentifier;

@end


NS_ASSUME_NONNULL_END

