//
//  FYJSSLGameRecordModel.h
//  ProjectCSHB
//
//  Created by fangyuan on 2020/8/28.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import <Foundation/Foundation.h>
@class FYJSSLGameResultModel, FYJSSLGameRecordDetailModel;

NS_ASSUME_NONNULL_BEGIN

@interface FYJSSLGameRecordModel : NSObject
@property (nonatomic, copy) NSString *uuid; // 游戏记录id
@property (nonatomic, copy) NSString *money; // 用户盈亏金额
@property (nonatomic, copy) NSString *createTime; // 时间
@property (nonatomic, copy) NSString *gameNumber; // 游戏期数
@property (nonatomic, copy) NSString *result; // 开奖结果-拼接好的
@property (nonatomic, strong) FYJSSLGameResultModel *recordDTO; // 开奖结果
@property (nonatomic, strong) NSArray<FYJSSLGameRecordDetailModel *> *betRecordDTO; // 投注详情
@end

NS_ASSUME_NONNULL_END
