//
//  FYRobTouZhuJLController.h
//  ProjectCSHB
//
//  Created by 汤姆 on 2019/10/3.
//  Copyright © 2019 CDJay. All rights reserved.
//  抢庄牛牛投注记录

#import "FYBaseCoreViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface FYRobTouZhuJLController : FYBaseCoreViewController
/** 群id*/
@property (nonatomic, copy) NSString *chatId;
/** 游戏类型*/
@property (nonatomic, assign) NSInteger type;

@end

NS_ASSUME_NONNULL_END
