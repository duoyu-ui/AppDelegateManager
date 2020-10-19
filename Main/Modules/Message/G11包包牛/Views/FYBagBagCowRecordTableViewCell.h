//
//  FYBagBagCowRecordTableViewCell.h
//  ProjectCSHB
//
//  Created by fangyuan on 2020/7/22.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FYBagBagCowRecordModel;

NS_ASSUME_NONNULL_BEGIN


@protocol FYBagBagCowRecordTableViewCellDelegate <NSObject>
@optional
- (void)didSelectRowAtBagBagCowRecordModel:(FYBagBagCowRecordModel *)model indexPath:(NSIndexPath *)indexPath;
@end


@interface FYBagBagCowRecordTableViewCell : UITableViewCell

@property (nonatomic, strong) NSIndexPath *indexPath;

@property (nonatomic, strong) FYBagBagCowRecordModel *model;

@property (nonatomic, weak) id<FYBagBagCowRecordTableViewCellDelegate> delegate;

+ (NSString *)reuseIdentifier;

@end


NS_ASSUME_NONNULL_END

