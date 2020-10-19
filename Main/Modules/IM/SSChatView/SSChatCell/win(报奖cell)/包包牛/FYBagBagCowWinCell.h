//
//  FYBagBagCowWinCellCell.h
//  ProjectCSHB
//
//  Created by Tom on 2020/7/25.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SSChatBagBagCowWinCell.h"
NS_ASSUME_NONNULL_BEGIN

@interface FYBagBagCowWinCell : UITableViewCell
@property (nonatomic , strong) SSChatBagBagCowWinData *list;
@property (nonatomic , strong) UILabel *nickLab;
@property (nonatomic , strong) UILabel *numLab;
@end

NS_ASSUME_NONNULL_END
