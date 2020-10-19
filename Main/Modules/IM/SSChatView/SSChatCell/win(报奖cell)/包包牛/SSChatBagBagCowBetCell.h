//
//  SSChatBagBagCowBetCell.h
//  ProjectCSHB
//
//  Created by Tom on 2020/7/25.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "FYChatBaseCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface SSChatBagBagCowBetCell : FYChatBaseCell

@end
@interface SSChatBagBagCowBetModel :NSObject
@property (nonatomic , assign) NSInteger              money;
@property (nonatomic , assign) NSInteger              chatId;
@property (nonatomic , assign) NSInteger              userId;
@property (nonatomic , assign) NSInteger              betAttr;
@property (nonatomic , assign) NSInteger              gameNumber;
@end
NS_ASSUME_NONNULL_END
