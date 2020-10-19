//
//  FYBagBagCowTrendModel.h
//  ProjectCSHB
//
//  Created by fangyuan on 2020/7/24.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FYBagBagCowTrendModel : NSObject
@property (nonatomic, copy) NSString *gameNumber; // 期数
@property (nonatomic, copy) NSString *bankerNumber; // 庄点数
@property (nonatomic, copy) NSString *playerNumber; // 闲点数
@property (nonatomic, copy) NSString *winner; // 输赢（0庄赢、1闲赢、2和赢）

@property (nonatomic, assign) BOOL isIssuePlaying; // 是否未开奖期号

@end

/*
 牛数
 1=牛一
 2=牛二
 3=牛三
 4=牛四
 5=牛五
 6=牛六
 7=牛七
 8=牛八
 9=牛九
 10=牛牛
 11=金牛
 12=对子
 13=正顺
 14=倒顺
 15=豹子
*/

NS_ASSUME_NONNULL_END
