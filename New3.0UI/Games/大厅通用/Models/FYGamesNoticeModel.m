//
//  FYGamesNoticeModel.m
//  ProjectCSHB
//
//  Created by fangyuan on 2020/5/15.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "FYGamesNoticeModel.h"

@implementation FYGamesNoticeModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{
             @"uuid" : @"id"
             };
}

+ (NSMutableArray<FYGamesNoticeModel *> *) buildingDataModles
{
    NSMutableArray<FYGamesNoticeModel *> *models = [NSMutableArray array];
    FYGamesNoticeModel *model = [[FYGamesNoticeModel alloc] init];
    [model setTitle:NSLocalizedString(@"暂时没有公告！", nil)];
    [model setContent:NSLocalizedString(@"暂时没有公告！", nil)];
    [model setIsLoacl:[NSNumber numberWithBool:1]];
    [models addObject:model];
    return models;
}


@end
