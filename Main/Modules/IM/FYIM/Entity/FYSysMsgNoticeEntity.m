//
//  FYSysMsgNoticeEntity.m
//  ProjectCSHB
//
//  Created by fangyuan on 2020/7/3.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "FYSysMsgNoticeEntity.h"
#import "FYContactsModel.h"

@interface FYSysMsgNoticeEntity () <WHC_SqliteInfo>

@end

@implementation FYSysMsgNoticeEntity

MJExtensionCodingImplementation

+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"Id" : @"id"};
}

+ (NSString *)whc_SqliteVersion
{
    return @"1.0.1";
}

+ (NSString *)reuseChatSysMsgNoticeSessionId
{
    return [NSString stringWithFormat:@"kFySyMsgNoticeSessionId%@", NSStringFromClass(self)];
}

+ (NSMutableArray<FYSysMsgNoticeEntity *> *) buildingDataModles:(NSArray<NSDictionary *> *)arrayOfDicts
{
    __block NSMutableArray<NSMutableDictionary *> *arrayOfNewDicts = [NSMutableArray array];

    [arrayOfDicts enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull dict, NSUInteger idx, BOOL * _Nonnull stop) {
        NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithDictionary:dict];
        FYContactsModel *sysContactsModel = [FYContactsModel buildingDataModleForSystemMessage];
        NSDictionary *sysContactsDict = [sysContactsModel mj_keyValues];
        [dictionary addEntriesFromDictionary:sysContactsDict];
        [dictionary addEntriesFromDictionary:@{
            @"sessionId" : [FYSysMsgNoticeEntity reuseChatSysMsgNoticeSessionId]
        }];
        [arrayOfNewDicts addObj:dictionary];
    }];
    
    return [FYSysMsgNoticeEntity mj_objectArrayWithKeyValuesArray:arrayOfNewDicts];
}


@end
