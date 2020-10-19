//
//  FYMsgSearchTableViewCell.h
//  ProjectCSHB
//
//  Created by fangyuan on 2020/6/11.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "MGSwipeTableCell.h"
@class FYMsgSearchModel;

NS_ASSUME_NONNULL_BEGIN

UIKIT_EXTERN NSInteger const SEARCH_RESULT_MAX_COUNT;

UIKIT_EXTERN CGFloat const SEARCH_RESULT_CONTENT_HEIGHT;

UIKIT_EXTERN CGFloat const TABLEVIEW_CELL_HEIGHT_FOR_MSG_SEARCH;

UIKIT_EXTERN NSString * const CELL_IDENTIFIER_MSGSEARCH_TABLEVIEW_CELL;

@interface FYMsgSearchTableViewCell : MGSwipeTableCell

@property (nonatomic, strong) id model;

@property (nonatomic, strong) FYMsgSearchModel *searchResModel;

- (void)setMsgSessionModel:(id)model searchResModel:(FYMsgSearchModel *)searchResModel;

@end

NS_ASSUME_NONNULL_END
