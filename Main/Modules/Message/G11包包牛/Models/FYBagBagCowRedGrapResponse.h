//
//  FYBagBagCowRedGrapResponse.h
//  ProjectCSHB
//
//  Created by fangyuan on 2020/7/23.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FYBagBagCowRedGrapModel : NSObject
@property (nonatomic, copy) NSString *avatar;
@property (nonatomic, copy) NSString *createTime;
@property (nonatomic, copy) NSString *money;
@property (nonatomic, copy) NSString *nickName;
@property (nonatomic, strong) NSNumber *niuNum;
@property (nonatomic, strong) NSNumber *profitLoss;
@end

@interface FYBagBagCowRedGrapData : NSObject
@property (nonatomic, copy) NSString *avatar;
@property (nonatomic, copy) NSString *nickName;
@property (nonatomic, copy) NSString *text;
@property (nonatomic, assign) BOOL overFlag;
@property (nonatomic, assign) NSInteger amount;
@property (nonatomic, assign) NSInteger seconds;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, assign) NSInteger exceptOverdueTime;
@property (nonatomic, strong) NSNumber *totalMoney;
@property (nonatomic, copy) NSArray<FYBagBagCowRedGrapModel *> *items;
@end

@interface FYBagBagCowRedGrapResponse : NSObject
@property (nonatomic, copy) NSString *msg;
@property (nonatomic, assign) NSInteger code;
@property (nonatomic, strong) FYBagBagCowRedGrapData *data;
@end

NS_ASSUME_NONNULL_END
