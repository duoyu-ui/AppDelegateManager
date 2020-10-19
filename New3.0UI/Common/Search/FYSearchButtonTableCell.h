//
//  FYSearchButtonTableCell.h
//  ProjectCSHB
//
//  Created by fangyuan on 2020/7/10.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FYSearchButtonModel;

NS_ASSUME_NONNULL_BEGIN

@interface FYSearchButtonTableCell : UITableViewCell

@property (nonatomic, strong) FYSearchButtonModel *model;

+ (NSString *)reuseIdentifier;

+ (CGFloat)heightOfSearchButton;

@end

NS_ASSUME_NONNULL_END
