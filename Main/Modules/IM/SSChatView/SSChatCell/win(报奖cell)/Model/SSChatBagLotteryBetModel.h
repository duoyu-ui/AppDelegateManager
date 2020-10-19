//
//  SSChatBagLotteryBetModel.h
//  ProjectCSHB
//
//  Created by Tom on 2020/7/23.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


@interface SSChatBagLotteryBetBettTwoLevel :NSObject
@property (nonatomic , assign) NSInteger              twoLevelType;
@property (nonatomic , copy) NSArray<NSNumber *>              * bettNums;
@property (nonatomic , strong) NSDictionary              * bettOddsNums;
@property (nonatomic , copy) NSString              * bettName;
@property (nonatomic , assign) NSInteger              pokerNum;

@end

@interface SSChatBagLotteryBetBettOneLevel :NSObject
@property (nonatomic , copy) NSArray<SSChatBagLotteryBetBettTwoLevel *>              * bettTwoLevel;
@property (nonatomic , assign) NSInteger              oneLevelType;

@end

@interface SSChatBagLotteryBetBettVO :NSObject
@property (nonatomic , assign) NSInteger              totalMoney;
@property (nonatomic , copy) NSArray<SSChatBagLotteryBetBettOneLevel *>              * bettOneLevel;
@property (nonatomic , assign) NSInteger              chatId;
@property (nonatomic , assign) NSInteger              singleMoney;
@property (nonatomic , assign) NSInteger              userId;

@end

@interface SSChatBagLotteryBetModel :NSObject
@property (nonatomic , strong) SSChatBagLotteryBetBettVO              * bettVO;
@property (nonatomic , assign) NSInteger              chatId;
@property (nonatomic , assign) NSInteger              userId;
@property (nonatomic , assign) NSInteger              gameNumber;
@property (nonatomic , copy) NSString              * text;
@property (nonatomic , copy) NSString              * textCopy;
@property (nonatomic , assign) NSInteger              money;

@end

NS_ASSUME_NONNULL_END
