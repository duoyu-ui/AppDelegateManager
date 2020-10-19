//
//  FYJSSLGameTrendModel.h
//  ProjectCSHB
//
//  Created by fangyuan on 2020/8/28.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FYJSSLGameTrendModel : NSObject
@property (nonatomic, copy) NSString *gameNumber; // 游戏期数
@property (nonatomic, copy) NSString *individual; // 个
@property (nonatomic, copy) NSString *ten; // 十
@property (nonatomic, copy) NSString *hundred; // 百
@property (nonatomic, copy) NSString *thousand; // 千
@property (nonatomic, copy) NSString *myriad; // 万

@property (nonatomic, assign) BOOL isIssuePlaying; // 是否未开奖期号

@end

NS_ASSUME_NONNULL_END
