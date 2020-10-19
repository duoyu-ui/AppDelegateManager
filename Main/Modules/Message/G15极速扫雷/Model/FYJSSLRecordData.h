//
//  FYJSSLRecordData.h
//  ProjectCSHB
//
//  Created by Tom on 2020/8/28.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
///极速扫雷历史记录
@interface FYJSSLRecordData : NSObject
/// 个位
@property (nonatomic , assign) NSInteger              individual;
///百位
@property (nonatomic , assign) NSInteger              hundred;
/// 千位
@property (nonatomic , assign) NSInteger              thousand;
///万位
@property (nonatomic , assign) NSInteger              myriad;
///十位
@property (nonatomic , assign) NSInteger              ten;
///期数
@property (nonatomic , assign) NSInteger              gameNumber;
@end

NS_ASSUME_NONNULL_END
