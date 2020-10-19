//
//  FYMsgNoticeModel.m
//  ProjectCSHB
//
//  Created by fangyuan on 2020/5/28.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "FYMsgNoticeModel.h"

@implementation FYMsgNoticeModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{
             @"uuid" : @"id"
             };
}

+ (NSMutableArray<FYMsgNoticeModel *> *) buildingDataModles
{
    NSMutableArray<FYMsgNoticeModel *> *models = [NSMutableArray array];
    FYMsgNoticeModel *model = [[FYMsgNoticeModel alloc] init];
    [model setTitle:NSLocalizedString(@"暂时没有公告！", nil)];
    [model setContent:NSLocalizedString(@"暂时没有公告！", nil)];
    [model setIsLoacl:[NSNumber numberWithBool:1]];
    [models addObject:model];
    return models;
}

@end
