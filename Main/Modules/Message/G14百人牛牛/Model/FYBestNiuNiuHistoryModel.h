//
//  FYBestNiuNiuHistoryModel.h
//  ProjectCSHB
//
//  Created by Tom on 2020/8/24.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, BestNiuNiuHistoryState) {
    ///牌面
    BestNiuNiuHistoryCardState,
    ///大小
    BestNiuNiuHistorysize,
    ///单双
    BestNiuNiuHistorySingle,
    
};
@interface FYBestNiuNiuHistoryResult :NSObject
///牌用于计算的值
@property (nonatomic , assign) NSInteger              number;
/// 用于牛数相等时 的比较
@property (nonatomic , assign) NSInteger              count;
///牌大小
@property (nonatomic , copy) NSString              * bigSmall;
///牌单双
@property (nonatomic , copy) NSString              * singleDouble;
///牌文本
@property (nonatomic , copy) NSString              * text;
///牌类型
@property (nonatomic , copy) NSString              * type;
///牌数字
@property (nonatomic , assign) NSInteger              num;

@end

@interface FYBestNiuNiuHistoryData :NSObject
@property (nonatomic , assign)BestNiuNiuHistoryState state;
///文本描述
@property (nonatomic , assign) NSInteger              other;
///牛数
@property (nonatomic , copy) NSString              * cattleNum;
///期数
@property (nonatomic , copy) NSString              * gameNumber;
///牌面 牛牛5张牌
@property (nonatomic , copy) NSArray<FYBestNiuNiuHistoryResult *>              * result;

@end

@interface FYBestNiuNiuHistoryModel :NSObject
@property (nonatomic , assign) NSInteger              code;
@property (nonatomic , copy) NSString              * errorcode;
@property (nonatomic , copy) NSString              * msg;
@property (nonatomic , copy) NSString              * alterMsg;
@property (nonatomic , copy) NSArray<FYBestNiuNiuHistoryData *>              * data;

@end


NS_ASSUME_NONNULL_END
