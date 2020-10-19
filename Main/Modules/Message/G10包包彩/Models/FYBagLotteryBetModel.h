//
//  FYBagLotteryBetModel.h
//  ProjectCSHB
//
//  Created by Tom on 2020/7/18.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@interface FYBagLotteryBetList :NSObject
@property (nonatomic , copy) NSString              *bet;
@property (nonatomic , copy) NSString              *name;
@property (nonatomic , copy) NSString              *num;
@property (nonatomic , assign) BOOL selected;
@end

@interface FYBagLotteryBetOdds :NSObject

@end

@interface FYBagLotteryBetConfig :NSObject
@property (nonatomic , copy) NSString              * title;
@property (nonatomic , copy) NSArray<FYBagLotteryBetList *>              * data;
@property (nonatomic , assign) NSInteger              type;

@end

@interface FYBagLotteryBetData :NSObject
@property (nonatomic , assign) NSInteger              minSingleMoney;
@property (nonatomic , assign) NSInteger              maxSingleMoney;
@property (nonatomic , copy) NSString              * singleMoneyTips;
/***************包包彩******************/
@property (nonatomic , copy) NSArray<FYBagLotteryBetConfig *>              * qianhouConfig;
@property (nonatomic , copy) NSArray<FYBagLotteryBetConfig *>              * liangmianConfig;
@property (nonatomic , copy) NSArray<FYBagLotteryBetConfig *>              * housanConfig;
@property (nonatomic , copy) NSArray<FYBagLotteryBetConfig *>              * weishuConfig;
@property (nonatomic , copy) NSArray<FYBagLotteryBetConfig *>              * teshuConfig;
@property (nonatomic , copy) NSArray<FYBagLotteryBetConfig *>              * qiansanConfig;
@property (nonatomic , strong) FYBagLotteryBetOdds              * odds;
/***************百人牛牛******************/
@property (nonatomic , copy) NSArray<FYBagLotteryBetList *>              * twoSidesConfig;
@property (nonatomic , copy) NSArray<FYBagLotteryBetList *>              * winLoseConfig;
@property (nonatomic , copy) NSArray<FYBagLotteryBetList *>              * cattleConfig;
@property (nonatomic , copy) NSArray<FYBagLotteryBetList *>              * pokerSideConfig;
@end

@interface FYBagLotteryBetModel :NSObject
@property (nonatomic , copy) NSString              * msg;
@property (nonatomic , strong) FYBagLotteryBetData              * data;
@property (nonatomic , assign) NSInteger              code;

@end

@interface FYBagLotteryBetListData:NSObject
@property (nonatomic , copy) NSString *title;
@property (nonatomic , copy) NSArray<FYBagLotteryBetConfig *> * config;
@end
NS_ASSUME_NONNULL_END
