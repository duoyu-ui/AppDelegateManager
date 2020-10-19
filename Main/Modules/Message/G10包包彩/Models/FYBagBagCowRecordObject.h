//
//  FYBagBagCowRecord.h
//  ProjectCSHB
//
//  Created by Tom on 2020/7/24.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
///包包牛游戏记录
@interface FYBagBagCowRecordData :NSObject
@property (nonatomic , assign) NSInteger              bankerNumber;
@property (nonatomic , assign) NSInteger              winner;
@property (nonatomic , assign) NSInteger              playerNumber;
@property (nonatomic , assign) NSInteger              gameNumber;

@end

@interface FYBagBagCowRecordObject :NSObject
@property (nonatomic , copy) NSString              * msg;
@property (nonatomic , copy) NSArray<FYBagBagCowRecordData *>              * data;
@property (nonatomic , assign) NSInteger              code;

@end
@interface FYBagBagCowTool :NSObject

/// 包包牛输赢显示
+ (NSMutableAttributedString *)setWinner:(NSInteger)winner;
/// 包包牛闲庄牛号
+ (NSString *)setCowNumber:(NSInteger)number;
@end
NS_ASSUME_NONNULL_END
