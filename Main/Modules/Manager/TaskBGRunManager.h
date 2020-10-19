//
//  TaskBGRunManager.h
//  ProjectCSHB
//
//  Created by fangyuan on 2020/3/17.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TaskBGRunManager : NSObject

/**
 *  严格单例
 *  @return 实例对象.
 */
+ (instancetype)sharedTaskBGRunManager;

/**
 * 开启后台运行
 */
- (void)startBackgroundTaskRun;

/**
 * 关闭后台运行
 */
- (void)stopBackgroundTaskRun;

@end

NS_ASSUME_NONNULL_END
