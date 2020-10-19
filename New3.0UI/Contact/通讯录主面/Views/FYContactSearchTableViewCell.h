//
//  FYContactSearchTableViewCell.h
//  ProjectCSHB
//
//  Created by fangyuan on 2020/6/15.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "MGSwipeTableCell.h"
@class FYContactsModel, FYContactSearchModel;

NS_ASSUME_NONNULL_BEGIN

UIKIT_EXTERN CGFloat const TABLEVIEW_CELL_HEIGHT_FOR_CONTACT_SEARCH;


@interface FYContactSearchTableViewCell : MGSwipeTableCell

@property (nonatomic, strong) NSIndexPath *indexPath;

@property (nonatomic, strong) FYContactsModel *model;

@property (nonatomic, strong) FYContactSearchModel *searchResModel;

@property (nonatomic, assign) NSInteger badge;

- (void)setContactsModel:(FYContactsModel *)model searchResModel:(FYContactSearchModel *)searchResModel;

+ (NSString *)reuseIdentifier;

@end

NS_ASSUME_NONNULL_END
