//
//  FYBindBankCardTableViewCell.h
//  ProjectCSHB
//
//  Created by fangyuan on 2020/6/8.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FYMyBankCardModel;

NS_ASSUME_NONNULL_BEGIN

UIKIT_EXTERN NSString * const CELL_IDENTIFIER_BIND_BANKCARD_TABLEVIEW_CELL;

@protocol FYBindBankCardTableViewCellDelegate <NSObject>
@optional
- (void)didSelectRowAtBankCardModel:(FYMyBankCardModel *)model indexPath:(NSIndexPath *)indexPath;
- (void)didUnBindCardAtBankCardModel:(FYMyBankCardModel *)model indexPath:(NSIndexPath *)indexPath;
@end

@interface FYBindBankCardTableViewCell : UITableViewCell

@property (nonatomic, strong) NSIndexPath *indexPath;

@property (nonatomic, strong) FYMyBankCardModel *model;

@property (nonatomic, weak) id<FYBindBankCardTableViewCellDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
