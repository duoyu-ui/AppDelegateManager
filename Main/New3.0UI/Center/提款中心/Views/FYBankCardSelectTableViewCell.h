//
//  FYBankCardSelectTableViewCell.h
//  ProjectCSHB
//
//  Created by fangyuan on 2020/6/19.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FYMyBankCardModel;

NS_ASSUME_NONNULL_BEGIN

@protocol FYBankCardSelectTableViewCellDelegate <NSObject>
@optional
- (void)didSelectRowAtBankCardModel:(FYMyBankCardModel *)model indexPath:(NSIndexPath *)indexPath;
@end

@interface FYBankCardSelectTableViewCell : UITableViewCell

@property (nonatomic, strong) NSIndexPath *indexPath;

@property (nonatomic, strong) FYMyBankCardModel *model;

@property (nonatomic, weak) id<FYBankCardSelectTableViewCellDelegate> delegate;

+ (NSString *)reuseIdentifier;

@end

NS_ASSUME_NONNULL_END

