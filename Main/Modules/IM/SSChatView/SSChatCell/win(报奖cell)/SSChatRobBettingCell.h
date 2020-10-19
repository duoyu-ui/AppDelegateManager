//
//  SSChatRobBettingCell.h
//  ProjectXZHB
//
//  Created by 汤姆 on 2019/9/4.
//  Copyright © 2019 CDJay. All rights reserved.
//

#import "FYChatBaseCell.h"

/**
 抢庄牛牛投注cell
 */
@interface SSChatRobBettingCell : FYChatBaseCell

@end
@interface FYChatRobBettingModel :NSObject
@property (nonatomic , assign) NSInteger              money;
@property (nonatomic , assign) NSInteger              chatId;
@property (nonatomic , assign) NSInteger              userId;
@property (nonatomic , copy) NSString              *betAttr;
@end
