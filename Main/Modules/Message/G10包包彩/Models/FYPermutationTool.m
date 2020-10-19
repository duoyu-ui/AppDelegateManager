//
//  FYPermutationTool.m
//  ProjectCSHB
//
//  Created by Tom on 2020/7/23.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "FYPermutationTool.h"

@implementation FYPermutationTool
#pragma mark - 调用接口

+ (NSArray *)pickPermutation:(NSInteger)pickNum totalNum:(NSInteger)totalNum{
    if (pickNum > totalNum) {
        return [NSArray array];
    }
    NSArray * result = [self localArrayIndex:0 andLength:totalNum countIndex:0 count:pickNum];
    return result;
}

+ (NSInteger)pickNum:(NSInteger)pickNum totalNum:(NSInteger)totalNum
{
    if (pickNum > totalNum) {
        return 0;
    }else{
        NSInteger num1 = [self factorialWithStartNumber:totalNum - pickNum + 1 endNumber:totalNum];
        NSInteger num2 = [self factorialWithStartNumber:1 endNumber:pickNum];
        return  num1/num2;
    }
}
+ (NSArray *)pickPermutationWhitData:(NSArray*)data pickNum:(NSInteger)pickNum{
    if (pickNum > data.count) {
        return [NSArray array];
    }
    return [self localArrayIndex:0 dataArr:data countIndex:0 count:pickNum];
}

#pragma mark - 核心计算公式
/**
 
 核心计算公式
 
跑位    o1  o2  o3  o4
对象    A   B   C   D   E F G H I J
序号    0   1   2   3   4 5 6 7 8 9
 
 o1 到 o4 是代表目标数值
 目标长度是4，o1是最高位。
 当前跑序点的位置分别为 0 - 3
 
 A 到 J 是代表对象 长度是 10
 
 @param location 最高位的起点
 @param length   对象长度
 @param index    当前跑序点的位置 从0开始
 @param count    目的长度 几尾
 
 @return 0 - 1
 */

+ (NSArray * )localArrayIndex:(NSInteger)location
                    andLength:(NSInteger)length
                   countIndex:(NSInteger)index
                        count:(NSInteger)count
{
    NSMutableArray * arr = [NSMutableArray array];
    NSInteger rightPadding = count - 1 - index;
    if (rightPadding == 0) {
        for (; location < length ; location ++) {
            [arr addObject:[NSString stringWithFormat:@"%@",@(location)]];
        }
    }else {
        for (; location < length - rightPadding; location ++) {
            NSArray * subs = [self localArrayIndex:location + 1 andLength:length countIndex:index + 1 count:count];
            for (NSString * string in subs) {
                [arr addObject:[NSString stringWithFormat:@"%@,%@",@(location),string]];
            }
        }
    }
    return [arr copy];
}

///  核心计算公式
/// @param location 最高位的起点
/// @param dataArr 数据源
/// @param index 当前跑序点的位置 从0开始
/// @param count 目的长度 几尾
+ (NSArray * )localArrayIndex:(NSInteger)location
                    dataArr:(NSArray*)dataArr
                   countIndex:(NSInteger)index
                        count:(NSInteger)count
{
    NSMutableArray * arr = [NSMutableArray array];
    NSInteger rightPadding = count - 1 - index;
    if (rightPadding == 0) {
        for (; location < dataArr.count ; location ++) {
            [arr addObject:[NSString stringWithFormat:@"%@",dataArr[location]]];
        }
    }else {
        for (; location < dataArr.count - rightPadding; location ++) {
            NSArray * subs = [self localArrayIndex:location + 1 dataArr:dataArr countIndex:index + 1 count:count];
            for (NSString * string in subs) {
                [arr addObject:[NSString stringWithFormat:@"%@,%@",dataArr[location],string]];
            }
        }
    }
    return [arr copy];
}


#pragma mark - 辅助转换&数学计算


/**
 阶乘
 
 @param startNumber 起始数
 @param endNumber   结束数

 @return 阶乘结果
 */
+ (NSInteger)factorialWithStartNumber:(NSInteger)startNumber
                            endNumber:(NSInteger)endNumber
{
    NSInteger result = 1;
    for (; startNumber <= endNumber; startNumber ++) {
        result = result * startNumber;
    }
    return  result;
}


@end
