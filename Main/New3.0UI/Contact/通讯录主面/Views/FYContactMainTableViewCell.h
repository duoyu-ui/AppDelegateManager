//
//  FYContactMainTableViewCell.h
//  ProjectCSHB
//
//  Created by fangyuan on 2020/6/15.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "MGSwipeTableCell.h"
@class FYContactsModel;

NS_ASSUME_NONNULL_BEGIN

UIKIT_EXTERN CGFloat const TABLEVIEW_CELL_HEIGHT_FOR_CONTACT_MAIN;

@interface FYContactMainTableViewCell : MGSwipeTableCell

@property (nonatomic, strong) NSIndexPath *indexPath;

@property (nonatomic, strong) FYContactsModel *model;

@property (nonatomic, assign) NSInteger badge;

+ (NSString *)reuseIdentifier;

@end

NS_ASSUME_NONNULL_END
