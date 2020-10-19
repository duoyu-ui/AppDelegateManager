//
//  SSChatBagLotteryOrderPromptCell.h
//  ProjectCSHB
//
//  Created by Tom on 2020/7/22.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "FYChatBaseCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface SSChatBagLotteryOrderPromptCell : FYChatBaseCell

@end
@interface SSChatBagLotteryOrderPromptModel :NSObject
@property (nonatomic , copy) NSArray<NSString *>              * msg;
@property (nonatomic , assign) NSInteger              type;

@end

NS_ASSUME_NONNULL_END
