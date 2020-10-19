//
//  FYBaiRenNNRecordDetailModel.h
//  ProjectCSHB
//
//  Created by fangyuan on 2020/8/27.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import <Foundation/Foundation.h>
@class FYBestWinsLossesRed, FYBestWinsLossesRed;

NS_ASSUME_NONNULL_BEGIN

@interface FYBaiRenNNRecordDetailInfoModel : NSObject
@property (nonatomic, copy) NSString *money; // 中奖金额 0为未中奖 大于零为中奖金额
@property (nonatomic, copy) NSString *odds; // 赔率
@property (nonatomic, copy) NSString *oneLevelType; // 百人牛牛一级类型
@property (nonatomic, copy) NSString *pokerNum; // 第几张牌
@property (nonatomic, copy) NSString *singleMoney; // 单注金额
@property (nonatomic, copy) NSString *twoLevelType; // 百人牛牛二级类型
@property (nonatomic, copy) NSString *winResult; // 胜方结果 保存为 json 字符串
@end

@interface FYBaiRenNNRecordDetailResultModel : NSObject
@property (nonatomic, copy) NSString *groupId; // 群id
@property (nonatomic, copy) NSString *gameNumber; // 游戏期数
@property (nonatomic, assign) NSInteger winSide; // 1:蓝方胜 2:红方胜
@property (nonatomic, strong) FYBestWinsLossesBlue *blue;
@property (nonatomic, strong) FYBestWinsLossesRed *red;
@end

@interface FYBaiRenNNRecordDetailModel : NSObject
@property (nonatomic, copy) NSString *money; // 用户盈亏金额
@property (nonatomic, copy) NSString *bettMoney; // 用户投注金额
@property (nonatomic, copy) NSString *winMoney; // 用户中奖金额
@property (nonatomic, copy) NSString *createTime; // 时间
@property (nonatomic, copy) NSString *period; // 游戏期数
@property (nonatomic, copy) NSString *winStr; // 胜方结果字符串
@property (nonatomic, strong) FYBaiRenNNRecordDetailResultModel *result; // 比牌结果
@property (nonatomic, strong) NSArray<FYBaiRenNNRecordDetailInfoModel *> *details; // 游戏记录详情
@end

NS_ASSUME_NONNULL_END
