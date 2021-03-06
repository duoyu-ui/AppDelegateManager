//
//  FYBankCardUnBindTableViewCell.h
//  ProjectCSHB
//
//  Created by fangyuan on 2020/6/19.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FYMyBankCardModel;

NS_ASSUME_NONNULL_BEGIN

@protocol FYBankCardUnBindTableViewCellDelegate <NSObject>
@optional
- (void)didSelectRowAtUnBindBankCardModel:(FYMyBankCardModel *)model indexPath:(NSIndexPath *)indexPath;
@end

@interface FYBankCardUnBindTableViewCell : UITableViewCell

@property (nonatomic, strong) NSIndexPath *indexPath;

@property (nonatomic, strong) FYMyBankCardModel *model;

@property (nonatomic, weak) id<FYBankCardUnBindTableViewCellDelegate> delegate;

+ (NSString *)reuseIdentifier;

@end

NS_ASSUME_NONNULL_END

