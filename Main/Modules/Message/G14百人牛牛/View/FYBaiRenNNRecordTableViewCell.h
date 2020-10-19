//
//  FYBaiRenNNRecordTableViewCell.h
//  ProjectCSHB
//
//  Created by fangyuan on 2020/8/26.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FYBaiRenNNRecordModel;

NS_ASSUME_NONNULL_BEGIN

@protocol FYBaiRenNNRecordTableViewCellDelegate <NSObject>
@optional
- (void)didSelectRowAtBaiRenNNRecordModel:(FYBaiRenNNRecordModel *)model indexPath:(NSIndexPath *)indexPath;
@end

@interface FYBaiRenNNRecordTableViewCell : UITableViewCell

@property (nonatomic, strong) NSIndexPath *indexPath;

@property (nonatomic, strong) FYBaiRenNNRecordModel *model;

@property (nonatomic, weak) id<FYBaiRenNNRecordTableViewCellDelegate> delegate;

+ (NSString *)reuseIdentifier;

@end

NS_ASSUME_NONNULL_END

