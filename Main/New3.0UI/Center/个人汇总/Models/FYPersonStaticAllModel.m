//
//  FYPersonStaticAllModel.m
//  ProjectCSHB
//
//  Created by fangyuan on 2020/6/26.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "FYPersonStaticAllModel.h"

@implementation FYPersonStaticAllModel

+ (NSMutableArray<FYPersonStaticAllModel *> *) buildingDataModles:(NSMutableArray<NSDictionary *> *)arrayOfDicts
{
    __block NSMutableArray<NSMutableDictionary *> *arrayOfDictionary = [NSMutableArray array];
    [arrayOfDicts enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull dict, NSUInteger idx, BOOL * _Nonnull stop) {
        NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithDictionary:dict];
        [dictionary setObj:NSLocalizedString(@"个人总览", nil) forKey:@"title"];
        [arrayOfDictionary addObj:dictionary];
    }];
    return [FYPersonStaticAllModel mj_objectArrayWithKeyValuesArray:arrayOfDictionary];
}

@end
