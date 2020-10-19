//
//  FYPayModeTableViewCell.h
//  ProjectCSHB
//
//  Created by fangyuan on 2020/5/18.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FYPayModeModel;

NS_ASSUME_NONNULL_BEGIN

UIKIT_EXTERN NSString * const CELL_IDENTIFIER_PAY_MODE_TABLEVIEW_CELL;

@protocol FYPayModeTableViewCellDelegate <NSObject>
@optional
- (void)didSelectRowAtPayModeModel:(FYPayModeModel *)model indexPath:(NSIndexPath *)indexPath;
@end

@interface FYPayModeTableViewCell : UITableViewCell

@property (nonatomic, strong) NSIndexPath *indexPath;

@property (nonatomic, strong) FYPayModeModel *model;

@property (nonatomic, weak) id<FYPayModeTableViewCellDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
