//
//  FYMoneyRecordCollectionCell.h
//  ProjectCSHB
//
//  Created by fangyuan on 2020/5/26.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FYMoneyRecordModel;


NS_ASSUME_NONNULL_BEGIN


@protocol FYMoneyRecordCollectionCellDelegate <NSObject>
@optional
- (void)didSelectRowAtMoneyRecordModel:(FYMoneyRecordModel *)model indexPath:(NSIndexPath *)indexPath;
@end


@interface FYMoneyRecordCollectionCell : UICollectionViewCell
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, strong) FYMoneyRecordModel *model;
@property (nonatomic, weak) id<FYMoneyRecordCollectionCellDelegate> delegate;
+ (NSString *)reuseIdentifier;
@end


NS_ASSUME_NONNULL_END
