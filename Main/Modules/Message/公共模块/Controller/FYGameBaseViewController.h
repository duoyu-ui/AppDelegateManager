//
//  FYGameBaseViewController.h
//  ProjectCSHB
//
//  Created by fangyuan on 2020/8/24.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "FYBaseCoreViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface FYGameBaseViewController : FYBaseCoreViewController

@property(nonatomic, strong) MessageItem *messageItem;

+ (FYGameBaseViewController *)createGameVCByMsgItem:(MessageItem *)msgItem;

@end

NS_ASSUME_NONNULL_END
