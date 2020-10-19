//
//  FYPokerWinsLossesHeadView.h
//  ProjectCSHB
//
//  Created by Tom on 2020/8/24.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FYBestWinsLossesModel.h"
NS_ASSUME_NONNULL_BEGIN
///FYPokerWinsLossesHeadView 高
#define pokerWinsLossesHeadViewHigh 60
///扑克输赢VS
@interface FYPokerWinsLossesHeadView : UIView
///请求数据的字典
@property (nonatomic , strong) NSDictionary *dict;
///牌面数据
@property (nonatomic , strong) FYBestWinsLossesFlopResult *result;

@end

NS_ASSUME_NONNULL_END
