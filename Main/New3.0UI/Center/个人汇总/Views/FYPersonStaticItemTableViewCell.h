//
//  FYPersonStaticItemTableViewCell.h
//  ProjectCSHB
//
//  Created by fangyuan on 2020/6/26.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FYPersonStaticItemModel;

NS_ASSUME_NONNULL_BEGIN

@interface FYPersonStaticItemTableViewCell : UITableViewCell

@property (nonatomic, strong) FYPersonStaticItemModel *model;

+ (NSString *)reuseIdentifier;

- (void)setModel:(FYPersonStaticItemModel *)model isLastIndexRow:(BOOL)isLastIndexRow;

@end

NS_ASSUME_NONNULL_END
