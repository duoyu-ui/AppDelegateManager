//
//  GamePacketModel.h
//  ProjectCSHB
//
//  Created by fangyuan on 2019/9/6.
//  Copyright © 2019 CDJay. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


/**
 * 红包游戏模型
 */
@interface GamePacketModel : NSObject

@property (nonatomic, copy) NSString *name;

/**
 * 游戏规则
 */
@property (nonatomic, copy) NSString *ruleImage;

@property (nonatomic, copy) NSString *thumbnail;

@property (nonatomic, assign) BOOL openFlag;

/**
 * 0 == 福利 ，1 == 扫雷， 2 == 牛牛， 3 == 禁枪
 */
@property (nonatomic, assign) NSInteger type;

@end

NS_ASSUME_NONNULL_END
