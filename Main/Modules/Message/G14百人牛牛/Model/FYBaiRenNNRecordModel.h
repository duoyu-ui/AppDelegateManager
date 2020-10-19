//
//  FYBaiRenNNRecordModel.h
//  ProjectCSHB
//
//  Created by fangyuan on 2020/8/26.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import <Foundation/Foundation.h>
@class FYBestWinsLossesRed, FYBestWinsLossesRed;

NS_ASSUME_NONNULL_BEGIN

@interface FYBaiRenNNRecordSubDetailModel : NSObject
@property (nonatomic, copy) NSString *groupId; // 群id
@property (nonatomic, copy) NSString *gameNumber; // 游戏期数
@property (nonatomic, assign) NSInteger winSide; // 1:蓝方胜 2:红方胜
@property (nonatomic, strong) FYBestWinsLossesBlue *blue;
@property (nonatomic, strong) FYBestWinsLossesRed *red;
@end

@interface FYBaiRenNNRecordModel : NSObject
@property (nonatomic, copy) NSString *uuid; // 游戏记录id
@property (nonatomic, copy) NSString *money; // 用户盈亏金额
@property (nonatomic, copy) NSString *createTime; // 时间
@property (nonatomic, copy) NSString *period; // 游戏期数
@property (nonatomic, copy) NSString *winStr; // 胜方结果字符串
@property (nonatomic, strong) NSArray<FYBaiRenNNRecordSubDetailModel *> *result; // 用户所有投注单
@end

NS_ASSUME_NONNULL_END
