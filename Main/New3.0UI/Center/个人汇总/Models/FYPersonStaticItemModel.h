//
//  FYPersonStaticItemModel.h
//  ProjectCSHB
//
//  Created by fangyuan on 2020/6/26.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FYPersonStaticItemModel : NSObject

@property (nonatomic, copy) NSString *title;
//
@property (nonatomic, strong) NSNumber *bett; // 投注
@property (nonatomic, strong) NSNumber *profit; // 盈亏
@property (nonatomic, strong) NSNumber *backWater; // 返水
@property (nonatomic, copy) NSString *gameTypeName; // 名称

@end

NS_ASSUME_NONNULL_END
