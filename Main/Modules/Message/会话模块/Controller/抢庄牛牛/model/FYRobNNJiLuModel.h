//
//  FYRobNNJiLuModel.h
//  ProjectCSHB
//
//  Created by 汤姆 on 2019/10/3.
//  Copyright © 2019 CDJay. All rights reserved.
//

#import <Foundation/Foundation.h>
@class FYRobNNJiLuRecords;
@interface FYRobNNJiLuModel : NSObject
@property (nonatomic , copy) NSArray<FYRobNNJiLuRecords *>              * records;
@property (nonatomic , assign) NSInteger              pages;
@property (nonatomic , assign) NSInteger              current;
@property (nonatomic , assign) NSInteger              size;
@property (nonatomic , assign) NSInteger              total;
@end

@interface FYRobNNJiLuRecords :NSObject
@property (nonatomic , assign) NSInteger              profitLoss;
@property (nonatomic , assign) NSInteger              userId;
@property (nonatomic , assign) NSInteger              bankScore;
@property (nonatomic , copy) NSString              * niuStr;
@property (nonatomic , copy) NSString              *period;
@property (nonatomic , copy) NSString              * result;
@property (nonatomic , copy) NSString              * userName;

@end

@interface FYRobNNTouZhuJiLuList:NSObject
@property (nonatomic , assign) NSInteger              betting;
@property (nonatomic , assign) NSInteger              profitLoss;
@property (nonatomic , copy) NSString              * period;
@property (nonatomic , copy) NSString              * createTime;
@property (nonatomic , copy) NSString              * niuStr;
@end
@interface FYRobSolitaireTouZhuJiLuList:NSObject
@property (nonatomic , assign) NSInteger              chatGroupId;
@property (nonatomic , assign) NSInteger              userId;
/**-1:此红包没抢,0:最小包,1:普通包,2:最大包*/
@property (nonatomic , assign) NSInteger              moneyType;
@property (nonatomic , assign) NSInteger              gameNumber;
@property (nonatomic , assign) NSInteger              redPacketId;
@property (nonatomic , copy) NSString              *minPayMoney;
@property (nonatomic , copy) NSString              *profitMoney;
@property (nonatomic , copy) NSString              *grabMoney;
@property (nonatomic , copy) NSString              * gameTime;
@end
