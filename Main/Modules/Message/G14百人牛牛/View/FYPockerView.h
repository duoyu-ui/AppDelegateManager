//
//  FYPockerView.h
//  ProjectCSHB
//
//  Created by Tom on 2020/8/24.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FYBestWinsLossesModel.h"
#import "FYPokerCardView.h"

NS_ASSUME_NONNULL_BEGIN

///扑克牌
@interface FYPockerView : UIView
@property (nonatomic , assign) NSInteger flopType;
@property (nonatomic , strong) UIImageView *imgView;
@property (nonatomic , strong) FYPokerCardView *pokerView;
- (void)setImgViewImgWithPokers:(FYBestWinsLossesPokers*)pokers flopType:(NSInteger)flopType;
@end

NS_ASSUME_NONNULL_END
