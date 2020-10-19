//
//  FYBillingDetailsTableViewCell.h
//  ProjectCSHB
//
//  Created by fangyuan on 2020/6/21.
//  Copyright © 2020 Fangyuan. All rights reserved.
//
// 账单详情
//

#import <UIKit/UIKit.h>
@class FYBillingDetailsModel;

NS_ASSUME_NONNULL_BEGIN

@interface FYBillingDetailsTableViewCell : UITableViewCell

@property (nonatomic, strong) FYBillingDetailsModel *model;

+ (NSString *)reuseIdentifier;

@end

NS_ASSUME_NONNULL_END
