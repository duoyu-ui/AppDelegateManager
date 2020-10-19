//
//  FYSuperBombSendPacketVC.h
//  ProjectCSHB
//
//  Created by fangyuan on 2019/11/7.
//  Copyright © 2019 Fangyuan. All rights reserved.
//

#import "FYBaseCoreViewController.h"

@class MessageItem;

NS_ASSUME_NONNULL_BEGIN

@interface FYSuperBombSendPacketVC : FYBaseCoreViewController

/// 游戏基本信息
@property (nonatomic, strong) MessageItem *messageItem;

@end

NS_ASSUME_NONNULL_END
