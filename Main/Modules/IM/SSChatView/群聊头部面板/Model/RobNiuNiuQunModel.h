//
//  RobNiuNiuQunModel.h
//  Project
//
//  Created by 汤姆 on 2019/9/7.
//  Copyright © 2019 CDJay. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RobNiuNiuQunModel : NSObject
@property (nonatomic, assign) NSInteger banMoney;
@property (nonatomic, assign) NSInteger chatId;
@property (nonatomic, assign) NSInteger endTime;
@property (nonatomic, assign) NSInteger gameNumber;
/**群状态：1.连续上庄 2.抢庄 3.投注 4.发包 5.抢包 6.结算*/
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString * oddsVerion; // 赔率版本
/**status: 1,2抢庄/ 3:投注/ 4,5,6游戏人数*/
@property (nonatomic, assign) NSInteger people;
@property (nonatomic, copy) NSString * bankerId;
@property (nonatomic, copy) NSString * bankNick;
@property (nonatomic, copy) NSString              * gameList;
///极速扫雷->赔率因子
@property (nonatomic, copy) NSString              *oddsP;

@end

