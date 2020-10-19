//
//  FYCenterMenuReportTableViewCell.h
//  ProjectCSHB
//
//  Created by fangyuan on 2020/5/25.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FYCenterMenuItemModel, FYCenterMenuReportModel, FYCenterMenuSectionModel;

NS_ASSUME_NONNULL_BEGIN

@protocol FYCenterMenuReportTableViewCellDelegate <NSObject>
@optional
- (void)didSelectRowAtReportModel:(FYCenterMenuReportModel *)reportModel itemModel:(FYCenterMenuItemModel *)model;
@end

@interface FYCenterMenuReportTableViewCell : UITableViewCell

@property (nonatomic, strong) FYCenterMenuSectionModel *model;

@property (nonatomic, weak) id<FYCenterMenuReportTableViewCellDelegate> delegate;

+ (NSString *)reuseIdentifier;

@end

NS_ASSUME_NONNULL_END
