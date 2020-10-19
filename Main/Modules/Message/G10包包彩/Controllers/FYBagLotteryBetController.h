//
//  FYBagLotteryBetController.h
//  ProjectCSHB
//
//  Created by Tom on 2020/7/17.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "FYBaseCoreViewController.h"
#import "RobNiuNiuQunModel.h"
#import "MessageItem.h"
typedef void(^upBalance)(void);
///包包彩投注控制器
@interface FYBagLotteryBetController : FYBaseCoreViewController <FYIMSessionViewControllerLotteryGameGroupInfoDelegate>
@property (nonatomic , strong) RobNiuNiuQunModel *bagLotteryModel;
@property (nonatomic , copy) NSString *groupId;
@property (nonatomic , strong) MessageItem *messageItem;
@property (nonatomic , copy) upBalance block;
@end


