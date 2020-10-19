//
//  FYAgentReportMenuModel.m
//  ProjectCSHB
//
//  Created by fangyuan on 2020/7/1.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "FYAgentReportMenuModel.h"

@implementation FYAgentReportMenuModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{
             @"uuid" : @"id",
             @"title" : @"name"
             };
}

+ (NSMutableArray<FYAgentReportMenuModel *> *) buildingDataModles:(NSArray<NSDictionary *> *)arrayOfDicts
{
    NSMutableArray<NSDictionary *> *arrayOfDictionary = @[
        @{
            @"id": [NSNumber numberWithInteger:0],
            @"name": NSLocalizedString(@"汇总", nil)
        }
    ].mutableCopy;
    [arrayOfDictionary addObjectsFromArray:arrayOfDicts];
    return [FYAgentReportMenuModel mj_objectArrayWithKeyValuesArray:arrayOfDictionary];
}

@end
