//
//  FYBankCardFuncTableViewCell.h
//  ProjectCSHB
//
//  Created by fangyuan on 2020/6/19.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FYMyBankCardModel;

NS_ASSUME_NONNULL_BEGIN

@protocol FYBankCardFuncTableViewCellDelegate <NSObject>
@optional
- (void)didSelectRowAtFunctionBankCardModel:(FYMyBankCardModel *)model indexPath:(NSIndexPath *)indexPath;
@end

@interface FYBankCardFuncTableViewCell : UITableViewCell

@property (nonatomic, strong) NSIndexPath *indexPath;

@property (nonatomic, strong) FYMyBankCardModel *model;

@property (nonatomic, weak) id<FYBankCardFuncTableViewCellDelegate> delegate;

+ (NSString *)reuseIdentifier;

@end

NS_ASSUME_NONNULL_END

