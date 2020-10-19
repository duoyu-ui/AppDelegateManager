//
//  FYNNGameJiLuList.h
//  ProjectCSHB
//
//  Created by 汤姆 on 2019/10/4.
//  Copyright © 2019 CDJay. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FYNNGameJiLuList : NSObject
@property (nonatomic , assign) NSInteger              score;
///是否庄家
@property (nonatomic , assign)BOOL                  isBanker;
@property (nonatomic , copy) NSString              *money;
@property (nonatomic , copy) NSString              * profitLoss;
@property (nonatomic , copy) NSString              * betting;
@property (nonatomic , copy) NSString              * niuStr;
@property (nonatomic , copy) NSString              * userName;
@end

NS_ASSUME_NONNULL_END
