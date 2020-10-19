//
//  FYBagLotteryRedGrapResponse.h
//  ProjectCSHB
//
//  Created by fangyuan on 2020/7/24.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FYBagLotteryRedGrapModel : NSObject
@property (nonatomic, copy) NSString *avatar;
@property (nonatomic, copy) NSString *createTime;
@property (nonatomic, copy) NSString *money;
@property (nonatomic, copy) NSString *nickName;
@property (nonatomic, copy) NSString *moneyStr;
@property (nonatomic, copy) NSString *userId;
@end

@interface FYBagLotteryRedGrapData : NSObject
@property (nonatomic, copy) NSString *uuid;
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *avatar;
@property (nonatomic, copy) NSString *nickName;
@property (nonatomic, copy) NSString *text;
@property (nonatomic, assign) NSInteger left;
@property (nonatomic, assign) BOOL overFlag;
@property (nonatomic, assign) NSInteger amount;
@property (nonatomic, assign) NSInteger seconds;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, assign) NSInteger exceptOverdueTime;
@property (nonatomic, strong) NSNumber *totalMoney;
@property (nonatomic, copy) NSArray<FYBagLotteryRedGrapModel *> *items;
@end

@interface FYBagLotteryRedGrapResponse : NSObject
@property (nonatomic, copy) NSString *msg;
@property (nonatomic, assign) NSInteger code;
@property (nonatomic, strong) FYBagLotteryRedGrapData *data;
@end

NS_ASSUME_NONNULL_END
