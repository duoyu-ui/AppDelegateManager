//
//  FYGameReportModel.h
//  ProjectCSHB
//
//  Created by fangyuan on 2020/6/25.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FYGameReportModel : NSObject

@property (nonatomic, copy) NSString *uuid;
@property (nonatomic, copy) NSString *createTime;
@property (nonatomic, copy) NSString *sendRedId; // 期数
@property (nonatomic, copy) NSString *money; // 盈亏
@property (nonatomic, copy) NSString *betMoney; // 投注

@end

NS_ASSUME_NONNULL_END
