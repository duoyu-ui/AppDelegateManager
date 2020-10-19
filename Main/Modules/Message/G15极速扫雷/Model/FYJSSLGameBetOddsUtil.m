//
//  FYJSSLGameBetOddsUtil.m
//  ProjectCSHB
//
//  Created by fangyuan on 2020/8/28.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "FYJSSLGameBetOddsUtil.h"
#import "FYJSSLGameOddsModel.h"
#import "FYJSSLDataSource.h"

@implementation FYJSSLGameBetOddsUtil

+ (NSString *)getBetOddsValue:(NSArray<FYJSSLDataSource *> *)betDataSource oddsTableData:(FYJSSLGameOddsModel *)oddsTableData oddsP:(NSString *)oddsP
{
    NSArray<NSString *> *countOfColumnList = [[self class] calculateSelectedCountOfColumn:betDataSource];
    NSString *calFormulaString = [countOfColumnList componentsJoinedByString:@"+"];
    NSString *countOfAllSelected = [CFCStringMathsUtil calcComplexFormulaString:calFormulaString];
    if ([countOfAllSelected integerValue] < 3 || [countOfAllSelected integerValue] > 45) {
        return @"0.00";
    }
    NSArray<NSString *> *sortedCountOfColumnList = [CFCStringMathsUtil sortedArray:countOfColumnList];
    if ([sortedCountOfColumnList.lastObject integerValue] >= 10) {
        return @"0.00";
    }
    __block NSMutableArray<NSString *> *oddsCalFormulaList = [NSMutableArray array];
    [sortedCountOfColumnList enumerateObjectsUsingBlock:^(NSString * _Nonnull number, NSUInteger idx, BOOL * _Nonnull stop) {
        NSInteger index = [number integerValue];
        if (idx < sortedCountOfColumnList.count-1) {
            if (index < oddsTableData.data.parameterList.count) {
                NSNumber *parameter = [oddsTableData.data.parameterList objectAtIndex:index];
                [oddsCalFormulaList addObj:parameter.stringValue];
            } else {
                [oddsCalFormulaList addObj:@"1"];
            }
        } else {
            if (index < oddsTableData.data.baseList.count) {
                NSNumber *base = [oddsTableData.data.baseList objectAtIndex:index];
                [oddsCalFormulaList addObj:base.stringValue];
            } else {
                [oddsCalFormulaList addObj:@"1"];
            }
        }
    }];
    NSString *oddsCalFormulaString = [oddsCalFormulaList componentsJoinedByString:@"*"];
    NSString *oddsCalFormulaValue = [CFCStringMathsUtil calcComplexFormulaString:oddsCalFormulaString];
    float oddsValue = (floorf(oddsCalFormulaValue.floatValue*100 + 0.5))/100;
    return [NSString stringWithFormat:@"%.2f", oddsValue];
}

+ (NSArray<NSString *> *)calculateSelectedCountOfColumn:(NSArray<FYJSSLDataSource *> *)betDataSource
{
    __block NSInteger selectedCountOfWan = 0;
    __block NSInteger selectedCountOfQian = 0;
    __block NSInteger selectedCountOfBai = 0;
    __block NSInteger selectedCountOfShi = 0;
    __block NSInteger selectedCountOfGe = 0;
    [betDataSource enumerateObjectsUsingBlock:^(FYJSSLDataSource * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        switch (obj.digits) {
            case 0:
                if (obj.isSelected)
                    selectedCountOfWan ++;
                break;
            case 1:
                if (obj.isSelected)
                    selectedCountOfQian ++;
                break;
            case 2:
                if (obj.isSelected)
                    selectedCountOfBai ++;
                break;
            case 3:
                if (obj.isSelected)
                    selectedCountOfShi ++;
                break;
            case 4:
                if (obj.isSelected)
                    selectedCountOfGe ++;
                break;
            default:
                break;
        }
    }];
    return @[ [NSString stringWithFormat:@"%ld", selectedCountOfWan],
              [NSString stringWithFormat:@"%ld", selectedCountOfQian],
              [NSString stringWithFormat:@"%ld", selectedCountOfBai],
              [NSString stringWithFormat:@"%ld", selectedCountOfShi],
              [NSString stringWithFormat:@"%ld", selectedCountOfGe] ];
}


@end

