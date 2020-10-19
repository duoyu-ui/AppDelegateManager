//
//  FYBillingRecordTableViewCell.h
//  ProjectCSHB
//
//  Created by fangyuan on 2020/6/20.
//  Copyright © 2020 Fangyuan. All rights reserved.
//
// 账单
//

#import <UIKit/UIKit.h>
@class FYBillingRecordModel;

NS_ASSUME_NONNULL_BEGIN


@protocol FYBillingRecordTableViewCellDelegate <NSObject>
@optional
- (void)didSelectRowAtBillingRecordModel:(FYBillingRecordModel *)model indexPath:(NSIndexPath *)indexPath;
@end


@interface FYBillingRecordTableViewCell : UITableViewCell

@property (nonatomic, strong) NSIndexPath *indexPath;

@property (nonatomic, strong) FYBillingRecordModel *model;

@property (nonatomic, weak) id<FYBillingRecordTableViewCellDelegate> delegate;

+ (NSString *)reuseIdentifier;

@end


NS_ASSUME_NONNULL_END

