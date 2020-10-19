//
//  FYCenterMenuServiceTableViewCell.h
//  ProjectCSHB
//
//  Created by fangyuan on 2020/6/20.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FYCenterMenuItemModel, FYCenterMenuSectionModel;

NS_ASSUME_NONNULL_BEGIN

@protocol FYCenterMenuServiceTableViewCellDelegate <NSObject>
@optional
- (void)didSelectRowAtMyServiceMenuItemModel:(FYCenterMenuItemModel *)model indexPath:(NSIndexPath *)indexPath;
@end

@interface FYCenterMenuServiceTableViewCell : UITableViewCell

@property (nonatomic, strong) NSIndexPath *indexPath;

@property (nonatomic, strong) FYCenterMenuSectionModel *model;

@property (nonatomic, weak) id<FYCenterMenuServiceTableViewCellDelegate> delegate;

+ (NSString *)reuseIdentifier;

@end

NS_ASSUME_NONNULL_END
