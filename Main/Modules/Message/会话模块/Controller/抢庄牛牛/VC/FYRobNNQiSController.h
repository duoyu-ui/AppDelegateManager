//
//  FYRobNNQiSController.h
//  ProjectCSHB
//
//  Created by 汤姆 on 2019/10/3.
//  Copyright © 2019 CDJay. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
//抢庄牛牛期数记录
@interface FYRobNNQiSController : FYBaseCoreViewController
/** 群id*/
@property (nonatomic, copy) NSString *chatId;
/** 游戏类型*/
@property (nonatomic, assign) NSInteger type;
@end

NS_ASSUME_NONNULL_END
