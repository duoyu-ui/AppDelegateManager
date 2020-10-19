//
//  FYSuperBombNumberTableViewCell.h
//  ProjectCSHB
//
//  Created by fangyuan on 2019/11/7.
//  Copyright © 2019 Fangyuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FYSuperBombAttrModel.h"

@class FYSuperBombNumberTableViewCell;

NS_ASSUME_NONNULL_BEGIN

@protocol FYSuperBombNumberCellDelegate <NSObject>
@optional
- (void)cell:(FYSuperBombNumberTableViewCell *)cell didSelectedAtNumber:(NSString *)number;
@end

@interface FYSuperBombNumberTableViewCell : UITableViewCell

@property (nonatomic, weak) id<FYSuperBombNumberCellDelegate> delegate;

@property (nonatomic, strong) FYSuperBombAttrModel *model;


@end

NS_ASSUME_NONNULL_END
