//
//  FYMyWithdrawModel.h
//  ProjectCSHB
//
//  Created by fangyuan on 2020/6/8.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FYMyWithdrawModel : NSObject

@property (nonatomic, strong) NSNumber *brokerageMaxMoney;
@property (nonatomic, strong) NSNumber *brokerageMinMoney;
@property (nonatomic, strong) NSNumber *dayCashNum;

@end

NS_ASSUME_NONNULL_END
