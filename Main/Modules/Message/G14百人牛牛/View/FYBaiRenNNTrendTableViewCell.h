//
//  FYBaiRenNNTrendTableViewCell.h
//  ProjectCSHB
//
//  Created by fangyuan on 2020/8/27.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FYBaiRenNNTrendModel;

NS_ASSUME_NONNULL_BEGIN

@interface FYBaiRenNNTrendTableViewCell : UITableViewCell

@property (nonatomic, strong) NSIndexPath *indexPath;

@property (nonatomic, strong) FYBaiRenNNTrendModel *model;

+ (NSString *)reuseIdentifier;

+ (CGFloat)height;

@end

NS_ASSUME_NONNULL_END
