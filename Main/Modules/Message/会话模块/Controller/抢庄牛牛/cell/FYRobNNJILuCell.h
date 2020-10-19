//
//  FYRobNNJILuCell.h
//  ProjectCSHB
//
//  Created by 汤姆 on 2019/10/3.
//  Copyright © 2019 CDJay. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FYRobNNJiLuModel.h"
NS_ASSUME_NONNULL_BEGIN
static NSString * const kFYRobNNJILuCellId = @"kFYRobNNJILuCellId";
@interface FYRobNNJILuCell : UITableViewCell

@property (nonatomic, strong) FYRobNNJiLuRecords *model;
@end

NS_ASSUME_NONNULL_END
