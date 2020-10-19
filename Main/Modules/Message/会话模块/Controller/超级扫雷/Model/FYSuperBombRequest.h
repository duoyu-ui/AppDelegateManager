//
//  FYSuperBombRequest.h
//  ProjectCSHB
//
//  Created by fangyuan on 2019/11/8.
//  Copyright © 2019 Fangyuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FYSuperBombAttrModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface FYSuperBombRequest : NSObject
/// 已选择包数
@property (nonatomic, copy) NSString *packetCount;
/// 赔率
@property (nonatomic, copy) NSString *handicap;
/// 最大金额
@property (nonatomic, copy) NSString *maxMoney;
/// 最小金额
@property (nonatomic, copy) NSString *minMoney;
/// 发包金额
@property (nonatomic, copy) NSString *sendMoney;
/// 发包类型
@property (nonatomic, assign) SendPackageType sendType;

@end

NS_ASSUME_NONNULL_END
