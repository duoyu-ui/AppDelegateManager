//
//  FYGroupStatus.h
//  ProjectCSHB
//
//  Created by fangyuan on 2019/11/23.
//  Copyright © 2019 Fangyuan. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FYGroupStatus : NSObject
/// 二级显示状态  0:不显示  1:显示
@property (nonatomic, assign) BOOL displayFlag;
/// 是否进入维护
@property (nonatomic, assign) BOOL maintainFlag;
/// 维护开始时间
@property (nonatomic, copy) NSString *maintainStart;
/// 维护结束时间
@property (nonatomic, copy) NSString *maintainEnd;
/// 限制结束时间，默认5分钟结束
@property (nonatomic, copy) NSString *maintainLimitTime;
/// 群游戏类型启用状态  0:不启用  1：启用
@property (nonatomic, assign) BOOL openFlag;
/// 是否下放 | 敬请期待 判断
@property (nonatomic, assign) BOOL powerFlag;

@end

NS_ASSUME_NONNULL_END
