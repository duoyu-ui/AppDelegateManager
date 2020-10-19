//
//  FYBaiRenNNTrendModel.h
//  ProjectCSHB
//
//  Created by fangyuan on 2020/8/27.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import <Foundation/Foundation.h>
@class FYBestWinsLossesPokers;

NS_ASSUME_NONNULL_BEGIN

@interface FYBaiRenNNTrendModel : NSObject
@property (nonatomic, copy) NSString *gameNumber; // 期数
@property (nonatomic, copy) NSString *cattleNum; // 牛数
@property (nonatomic, assign) NSInteger other; // 1:蓝色 2:红色
@property (nonatomic, strong) NSArray<FYBestWinsLossesPokers *> *result; // 牌面

@property (nonatomic, assign) BOOL isIssuePlaying; // 是否未开奖期号

@end

NS_ASSUME_NONNULL_END
