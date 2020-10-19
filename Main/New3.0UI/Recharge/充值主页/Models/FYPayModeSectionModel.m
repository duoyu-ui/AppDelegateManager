//
//  FYPayModeSectionModel.m
//  ProjectCSHB
//
//  Created by fangyuan on 2020/5/18.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "FYPayModeSectionModel.h"
#import "FYPayModeModel.h"

@implementation FYPayModeSectionModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{
             @"uuid" : @"id",
             @"title" : @"name"
             };
}

+ (NSMutableArray<FYPayModeSectionModel *> *) buildingDataModles
{
    NSMutableArray<FYPayModeSectionModel *> *models = [NSMutableArray array];
    
    {
        FYPayModeSectionModel *model = [[FYPayModeSectionModel alloc] init];
        [model setTitle:NSLocalizedString(@"推荐渠道", nil)];
        [model setList:[FYPayModeModel buildingDataModles1]];
        [models addObject:model];
    }
    
    {
        FYPayModeSectionModel *model = [[FYPayModeSectionModel alloc] init];
        [model setTitle:NSLocalizedString(@"更多渠道", nil)];
        [model setList:[FYPayModeModel buildingDataModles2]];
        [models addObject:model];
    }
    
    return models;
}

@end
