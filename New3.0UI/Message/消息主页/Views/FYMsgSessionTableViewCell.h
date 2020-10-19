//
//  FYMsgSessionTableViewCell.h
//  ProjectCSHB
//
//  Created by fangyuan on 2020/5/28.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "MGSwipeTableCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface FYMsgSessionTableViewCell : MGSwipeTableCell

@property (nonatomic, strong) id model;

+ (NSString *)reuseIdentifier;

+ (CGFloat)height;

@end

NS_ASSUME_NONNULL_END
