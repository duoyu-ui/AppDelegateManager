//
//  FYLhhTouZhuJiLuCell.h
//  ProjectCSHB
//
//  Created by Tom on 2019/10/26.
//  Copyright © 2019 Fangyuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FYRobNNJiLuModel.h"
NS_ASSUME_NONNULL_BEGIN

/// 龙虎和,接龙投注记录cell
@interface FYLhhTouZhuJiLuCell : UITableViewCell
@property (nonatomic, strong) FYRobNNTouZhuJiLuList *list;
///接龙数据源
@property (nonatomic, strong) FYRobSolitaireTouZhuJiLuList *slist;
@end

NS_ASSUME_NONNULL_END
