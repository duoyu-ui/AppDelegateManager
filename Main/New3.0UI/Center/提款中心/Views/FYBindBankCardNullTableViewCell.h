//
//  FYBindBankCardNullTableViewCell.h
//  ProjectCSHB
//
//  Created by fangyuan on 2020/6/9.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FYMyBankCardModel;

NS_ASSUME_NONNULL_BEGIN

UIKIT_EXTERN NSString * const CELL_IDENTIFIER_BIND_BANKCARD_NULL_TABLEVIEW_CELL;

@protocol FYBindBankCardNullTableViewCellDelegate <NSObject>
@optional
- (void)didBindAddCardAtBankCardModel:(FYMyBankCardModel *)model indexPath:(NSIndexPath *)indexPath;
@end

@interface FYBindBankCardNullTableViewCell : UITableViewCell

@property (nonatomic, strong) NSIndexPath *indexPath;

@property (nonatomic, strong) FYMyBankCardModel *model;

@property (nonatomic, weak) id<FYBindBankCardNullTableViewCellDelegate> delegate;

+ (NSString *)reuseIdentifier;

@end

NS_ASSUME_NONNULL_END
