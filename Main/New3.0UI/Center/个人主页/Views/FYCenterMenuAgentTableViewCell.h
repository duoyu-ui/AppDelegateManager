//
//  FYCenterMenuAgentTableViewCell.h
//  ProjectCSHB
//
//  Created by fangyuan on 2020/5/19.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FYCenterMenuItemModel, FYCenterMenuSectionModel;

NS_ASSUME_NONNULL_BEGIN

@protocol FYCenterMenuAgentTableViewCellDelegate <NSObject>
@optional
- (void)didSelectRowAtMyAgentMenuItemModel:(FYCenterMenuItemModel *)model indexPath:(NSIndexPath *)indexPath;
@end

@interface FYCenterMenuAgentTableViewCell : UITableViewCell

@property (nonatomic, strong) NSIndexPath *indexPath;

@property (nonatomic, strong) FYCenterMenuSectionModel *model;

@property (nonatomic, weak) id<FYCenterMenuAgentTableViewCellDelegate> delegate;

+ (NSString *)reuseIdentifier;

@end

NS_ASSUME_NONNULL_END
