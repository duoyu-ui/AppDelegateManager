//
//  FYBagLotteryHistoryCell.h
//  ProjectCSHB
//
//  Created by Tom on 2020/7/22.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FYBegLotteryHistoryModel.h"
#import "FYBagBagCowRecordObject.h"
NS_ASSUME_NONNULL_BEGIN

@interface FYBagLotteryHistoryCell : UITableViewCell
@property (nonatomic , strong) FYBegLotteryHistoryData *list;
@property (nonatomic , strong) FYBagBagCowRecordData *cowList;
@property (nonatomic , strong) UIButton *hubBtn;
@end

NS_ASSUME_NONNULL_END
