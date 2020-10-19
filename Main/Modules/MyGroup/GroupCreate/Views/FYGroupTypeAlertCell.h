//
//  FYGroupTypeAlertCell.h
//  ProjectCSHB
//
//  Created by fangyuan on 2019/10/19.
//  Copyright © 2019 Fangyuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FYRedPacketListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface FYGroupTypeAlertCell : UICollectionViewCell

@property (nonatomic, strong) UILabel *typeLabel;

@property (nonatomic, strong) FYRedPacketListModel *model;

@end

NS_ASSUME_NONNULL_END
