//
//  FYBegLotteryHistoryModel.h
//  ProjectCSHB
//
//  Created by Tom on 2020/7/21.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
///包包彩历史记录

@interface FYBegLotteryHistoryData :NSObject
@property (nonatomic , copy) NSString              * typeName;
@property (nonatomic , copy) NSString              * gameNumber;
@property (nonatomic , copy) NSString              * winNumbers;

@end

@interface FYBegLotteryHistoryModel :NSObject
@property (nonatomic , copy) NSString              * msg;
@property (nonatomic , copy) NSArray<FYBegLotteryHistoryData *>              * data;
@property (nonatomic , assign) NSInteger              code;

@end
@interface FYBegLotteryTool :NSObject
+ (UIColor *)setLabBackgroundColor:(NSString *)num;
@end
NS_ASSUME_NONNULL_END
