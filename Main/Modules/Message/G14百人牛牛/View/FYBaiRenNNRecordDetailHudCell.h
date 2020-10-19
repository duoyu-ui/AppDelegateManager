//
//  FYBaiRenNNRecordDetailHudCell.h
//  ProjectCSHB
//
//  Created by fangyuan on 2020/8/28.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FYBaiRenNNRecordDetailInfoModel;

NS_ASSUME_NONNULL_BEGIN

@interface FYBaiRenNNRecordDetailHudCell : UITableViewCell

@property (nonatomic, strong) FYBaiRenNNRecordDetailInfoModel *model;

+ (NSString *)reuseIdentifier;

+ (CGFloat)headerViewHeight;

+ (NSArray<NSNumber *> *)getColumnPercents;

@end

NS_ASSUME_NONNULL_END
