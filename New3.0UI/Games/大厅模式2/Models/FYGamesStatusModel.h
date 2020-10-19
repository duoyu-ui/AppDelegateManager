//
//  FYGamesStatusModel.h
//  ProjectCSHB
//
//  Created by fangyuan on 2020/5/21.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FYGamesStatusModel : NSObject

@property (nonatomic, strong) NSNumber *uuid;
@property (nonatomic, strong) NSNumber *type;
@property (nonatomic, strong) NSNumber *amountLimit;
@property (nonatomic, copy) NSString *linkUrl;

@property (nonatomic, strong) NSNumber *gameFlag;  // 1显示 2隐藏 3维护
@property (nonatomic, copy) NSString *maintainEnd; // 维护结束时间
@property (nonatomic, copy) NSString *maintainStart; // 维护开始时间
@property (nonatomic, strong) NSNumber *maintainLimitTime;

@end

NS_ASSUME_NONNULL_END

