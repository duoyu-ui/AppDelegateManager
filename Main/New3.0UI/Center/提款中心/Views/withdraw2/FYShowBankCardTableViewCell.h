//
//  FYShowBankCardTableViewCell.h
//  ProjectCSHB
//
//  Created by fangyuan on 2020/6/10.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FYMyBankCardModel;

NS_ASSUME_NONNULL_BEGIN

UIKIT_EXTERN NSString * const CELL_IDENTIFIER_SHOW_BANKCARD_TABLEVIEW_CELL;

@protocol FYShowBankCardTableViewCellDelegate <NSObject>
@optional
- (void)didSelectRowAtShowBankCardModel:(FYMyBankCardModel *)model indexPath:(NSIndexPath *)indexPath;
@end

@interface FYShowBankCardTableViewCell : UITableViewCell

@property (nonatomic, strong) NSIndexPath *indexPath;

@property (nonatomic, strong) FYMyBankCardModel *model;

@property (nonatomic, weak) id<FYShowBankCardTableViewCellDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
