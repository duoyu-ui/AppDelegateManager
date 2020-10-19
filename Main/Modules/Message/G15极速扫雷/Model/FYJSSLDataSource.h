//
//  FYJSSLDataSource.h
//  ProjectCSHB
//
//  Created by Tom on 2020/8/26.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FYJSSLDataSource : NSObject
///位数  4:个,3:十,2:百,1:千,0:万
@property (nonatomic , assign) NSInteger digits;
@property (nonatomic , assign) NSInteger num;
@property (nonatomic , assign) BOOL isSelected;
///普通状态
@property (nonatomic , strong) UIImage *imgNor;
///选中状态
@property (nonatomic , strong) UIImage *imgSel;
+ (NSArray<FYJSSLDataSource*>*)setJSSLDataSource;
///单选
+ (NSArray<FYJSSLDataSource*>*)singleSelect:(NSArray<FYJSSLDataSource*>*)dataSource;

/// 多选 x选1
/// @param dataSource 数据源
/// @param num x
/// @param rando 随机开始的行  0 - 2
+ (NSArray<FYJSSLDataSource*>*)multiSelectWithData:(NSArray<FYJSSLDataSource*>*)dataSource num:(int)num rando:(int)rando;

@end

NS_ASSUME_NONNULL_END
