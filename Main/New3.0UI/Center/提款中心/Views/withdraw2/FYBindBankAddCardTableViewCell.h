//
//  FYBindBankAddCardTableViewCell.h
//  ProjectCSHB
//
//  Created by fangyuan on 2020/6/9.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FYMyBankCardModel;

NS_ASSUME_NONNULL_BEGIN

UIKIT_EXTERN NSString * const CELL_IDENTIFIER_BIND_BANKADDCARD_TABLEVIEW_CELL;

@protocol FYBindBankAddCardTableViewCellDelegate <NSObject>
@optional
- (void)didBindAddCardAtBankCardModel:(FYMyBankCardModel *)model indexPath:(NSIndexPath *)indexPath;
@end

@interface FYBindBankAddCardTableViewCell : UITableViewCell

@property (nonatomic, strong) NSIndexPath *indexPath;

@property (nonatomic, strong) FYMyBankCardModel *model;

@property (nonatomic, weak) id<FYBindBankAddCardTableViewCellDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
