//
//  FYBankerModel.h
//  ProjectCSHB
//
//  Created by 汤姆 on 2019/10/2.
//  Copyright © 2019 CDJay. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FYBankerModel : NSObject

/**
 下一次抢庄额度
 */
@property (nonatomic, assign) CGFloat currBanker;
///上期抢庄额度
@property (nonatomic, assign) CGFloat lastBanker;
/** 倒计时*/
@property (nonatomic, assign) NSInteger time;
/**
 百分百
 */
@property (nonatomic, assign) CGFloat continueBankerPercent;
@end

NS_ASSUME_NONNULL_END
