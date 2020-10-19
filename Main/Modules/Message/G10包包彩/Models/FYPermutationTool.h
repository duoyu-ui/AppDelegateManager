//
//  FYPermutationTool.h
//  ProjectCSHB
//
//  Created by Tom on 2020/7/23.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
///计算出所有的排列组合方式
@interface FYPermutationTool : NSObject
/*
 计算出 1-10 所有的排列组合方式
一个的话   C(10,1)=10
两个的话   C(10,2)=10*9/2*1=45
三个的话   C(10,3)=10*9*8/3*2*1=120
四个的话   C(10,4)=10*9*8*7/4*3*2*1=210
五个      C(10,5)=252
*/

/**
 计算出所有的排列组合方式
 例如从10个中选取4个，totalNum就是10，pickNum就是4
 
 @param pickNum  目标个数
 @param totalNum  抽取对象个数

 @return 所有的排列组合方式
 */
+ (NSArray *)pickPermutation:(NSInteger)pickNum totalNum:(NSInteger)totalNum;

/// 计算出所有的排列组合方式
/// @param data 数据源
/// @param pickNum 目标个数
+ (NSArray *)pickPermutationWhitData:(NSArray*)data pickNum:(NSInteger)pickNum;

/**
 计算出排列组合个数
 例如从10个中选取5个，totalNum就是10，pickNum就是5
 @param pickNum  目标个数
 @param totalNum  抽取对象个数
 
 @return 所有的排列组合的个数
 */
+ (NSInteger)pickNum:(NSInteger)pickNum totalNum:(NSInteger)totalNum;


@end

NS_ASSUME_NONNULL_END
