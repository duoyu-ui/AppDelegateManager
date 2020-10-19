//
//  FYApplicationManager.h
//  ProjectCSHB
//
//  Created by fangyuan on 2020/7/28.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import <Foundation/Foundation.h>

#define FY_APPLICAION_MANAGER [FYApplicationManager sharedInstance]

NS_ASSUME_NONNULL_BEGIN

@interface FYApplicationManager : NSObject

@property (nonatomic, assign) BOOL isShowSystemNoticeAlterView; // 每次重启APP显示弹框。显示状态下，游戏大厅页面切换不显示弹框

+ (instancetype)sharedInstance;

@end

NS_ASSUME_NONNULL_END
