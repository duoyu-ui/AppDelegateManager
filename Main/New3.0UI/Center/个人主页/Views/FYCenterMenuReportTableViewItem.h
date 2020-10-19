//
//  FYCenterMenuReportTableViewItem.h
//  ProjectCSHB
//
//  Created by fangyuan on 2020/5/25.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "FYScrollPageViewController.h"
@class FYCenterMenuItemModel, FYCenterMenuReportModel;

NS_ASSUME_NONNULL_BEGIN

@protocol FYCenterMenuReportTableViewItemDelegate <NSObject>
@optional
- (void)didSelectRowAtReportModel:(FYCenterMenuReportModel *)reportModel itemModel:(FYCenterMenuItemModel *)model;
@end


@interface FYCenterMenuReportTableViewItem : FYScrollPageViewController

@property (nonatomic, weak) id<FYCenterMenuReportTableViewItemDelegate> delegateOfReportCell;

- (instancetype)initWithTabMenuReportModel:(FYCenterMenuReportModel *)menuReportModel;

@end

NS_ASSUME_NONNULL_END
