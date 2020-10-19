//
//  SSChatBagLotteryResultsCell.h
//  ProjectCSHB
//
//  Created by Tom on 2020/7/22.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "FYChatBaseCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface SSChatBagLotteryResultsCell : FYChatBaseCell

@end
@interface SSChatBagLotteryResultsOpen :NSObject
@property (nonatomic , assign) CGFloat              money;
@property (nonatomic , copy) NSString              * moneyStr;
@property (nonatomic , copy) NSString              * nick;
@property (nonatomic , assign) NSInteger              userId;

@end

@interface SSChatBagLotteryResultsData :NSObject
@property (nonatomic , copy) NSString              * result;
@property (nonatomic , copy) NSArray<SSChatBagLotteryResultsOpen *>              * open;

@end

@interface SSChatBagLotteryResultsModel :NSObject
@property (nonatomic , copy) NSArray<NSString *>              * msg;
@property (nonatomic , strong) SSChatBagLotteryResultsData              * data;
@property (nonatomic , assign) NSInteger              type;

@end

NS_ASSUME_NONNULL_END
