//
//  RobNiuNiuMessageTypeModel.h
//  Project
//
//  Created by 汤姆 on 2019/9/4.
//  Copyright © 2019 CDJay. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 抢庄牛牛提示消息类型模型
 */
@interface RobNiuNiuMessageTypeModel : NSObject
@property (nonatomic , copy) NSArray<NSString *> * msg;
@property (nonatomic , assign) RobNiuNiuType type;
@property (nonatomic , copy) NSArray<NSString *> *userIdList;
@end


