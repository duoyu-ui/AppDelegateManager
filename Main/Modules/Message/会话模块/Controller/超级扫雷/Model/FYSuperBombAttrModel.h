//
//  FYSuperBombAttrModel.h
//  ProjectCSHB
//
//  Created by fangyuan on 2019/11/7.
//  Copyright © 2019 Fangyuan. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    /// 单雷
    SinglePackage = 1,
    /// 多雷
    MultiplePackage = 2,
    /// 混合雷
    MixedPackage = 3,
} SendPackageType;

NS_ASSUME_NONNULL_BEGIN

@interface FYSuperBombAttrModel : NSObject

@property (nonatomic, copy) NSString *count;
@property (nonatomic, assign) float handicap;
@property (nonatomic, assign) float handicap2;
@property (nonatomic, assign) float handicap3;
@property (nonatomic, assign) float handicap4;
@property (nonatomic, assign) float handicap5;
@property (nonatomic, assign) float handicap6;
@property (nonatomic, copy) NSString *maxMoney;
@property (nonatomic, copy) NSString *minMoney;

/// 发包类型
@property (nonatomic, assign) SendPackageType sendType;
/// 当前对应的赔率
@property (nonatomic, copy) NSString *setedHandicap;
/// 已选的包数
@property (nonatomic, copy) NSString *packetCount;

@property (nonatomic, assign) BOOL isRestSelected;

@end

NS_ASSUME_NONNULL_END
