//
//  FYCountDownObject.h
//  ProjectCSHB
//
//  Created by fangyuan on 2020/7/28.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FYCountDownObject : NSObject

#pragma mark 每秒回调一次，注意释放定时器
- (void)countDownWithSecondBlock:(void (^)(void))secondBlock;

#pragma mark 每second回调一次，注意释放定时器
- (void)countDownWithSecond:(NSInteger)second block:(void (^)(void))secondBlock;

#pragma mark 根据日期 NSDate 类型倒计时
- (void)countDownWithStratDate:(NSDate *)startDate finishDate:(NSDate *)finishDate completeBlock:(void (^)(NSInteger timeInterval, NSInteger day, NSInteger hour, NSInteger minute, NSInteger second))completeBlock;

#pragma mark 销毁定时器
- (void)destoryTimer;

@end

NS_ASSUME_NONNULL_END
