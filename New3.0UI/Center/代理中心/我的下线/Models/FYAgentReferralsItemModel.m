//
//  FYAgentReferralsItemModel.m
//  ProjectCSHB
//
//  Created by fangyuan on 2020/6/27.
//  Copyright © 2020 Fangyuan. All rights reserved.
//
// 我的下线 - 下线信息
//

#import "FYAgentReferralsItemModel.h"

@implementation FYAgentReferralsItemModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{
             @"isNewReg" : @"newRegister",
             @"imageUrl" : @"headIco"
             };
}

+ (NSMutableArray<FYAgentReferralsItemModel *> *) buildingDataModles
{
    NSArray<NSDictionary<NSString *, NSString *> *> *arrayOfDict = @[
        @{

        }
    ];
    return [FYAgentReferralsItemModel mj_objectArrayWithKeyValuesArray:arrayOfDict];
}


@end
