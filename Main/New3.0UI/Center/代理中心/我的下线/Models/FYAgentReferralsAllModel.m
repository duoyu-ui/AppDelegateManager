//
//  FYAgentReferralsAllModel.m
//  ProjectCSHB
//
//  Created by fangyuan on 2020/6/27.
//  Copyright © 2020 Fangyuan. All rights reserved.
//
// 我的下线 - 汇总信息
//

#import "FYAgentReferralsAllModel.h"

@implementation FYAgentReferralsAllModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{
             @"imageUrl" : @"headIco"
             };
}

+ (NSMutableArray<FYAgentReferralsAllModel *> *) buildingDataModles:(NSDictionary *)dictionary
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:dictionary];
    [dict addEntriesFromDictionary:@{
        @"title": NSLocalizedString(@"当前层级数据汇总", nil)
    }];
    NSArray<NSMutableDictionary *> *arrayOfDict = @[ dict ];
    return [FYAgentReferralsAllModel mj_objectArrayWithKeyValuesArray:arrayOfDict];
}

@end
