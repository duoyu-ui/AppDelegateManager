//
//  FYActivityTableViewCell.h
//  ProjectCSHB
//
//  Created by fangyuan on 2020/5/26.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FYActivityModel;

NS_ASSUME_NONNULL_BEGIN

UIKIT_EXTERN NSString * const CELL_IDENTIFIER_ACTIVITY_TABLEVIEW_CELL;

@protocol FYActivityTableViewCellDelegate <NSObject>
@optional
- (void)didSelectRowAtActivityModel:(FYActivityModel *)model;
@end

@interface FYActivityTableViewCell : UITableViewCell

@property (nonatomic, strong) FYActivityModel *model;

@property (nonatomic, weak) id<FYActivityTableViewCellDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
