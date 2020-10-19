//
//  FYAgentReportHelper.m
//  ProjectCSHB
//
//  Created by fangyuan on 2020/7/5.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "FYAgentReportHelper.h"
#import "FYAgentReportAllModel.h"
#import "FYAgentReportUserModel.h"
#import "FYAgentReportItem1Model.h"
#import "FYAgentReportItem2Model.h"

@implementation FYAgentReportHelper

+ (NSMutableArray *) buildingDataModles:(NSString *)code data:(NSDictionary *)data
{
    // 汇总
    if ([kFyAgentReportCodeSumTotal isEqualToString:code]) {
        return [[self class] buildingDataModlesForSumTotal:data code:code];
    }
    // 红包
    else if ([kFyAgentReportCodeRedPacket isEqualToString:code]) {
        return [[self class] buildingDataModlesForCommon:data code:code title:NSLocalizedString(@"红包游戏代理数据", nil) isFull:YES];
    }
    // 棋牌
    else if ([kFyAgentReportCodeQGChess isEqualToString:code]) {
        return [[self class] buildingDataModlesForCommon:data code:code title:NSLocalizedString(@"棋牌游戏代理数据", nil) isFull:YES];
    }
    // 电子
    else if ([kFyAgentReportCodeElectronic isEqualToString:code]) {
        return [[self class] buildingDataModlesForCommon:data code:code title:NSLocalizedString(@"电子游戏代理数据", nil) isFull:NO];
    }
    // 彩票
    else if ([kFyAgentReportCodeLottery isEqualToString:code]) {
        return [[self class] buildingDataModlesForCommon:data code:code title:NSLocalizedString(@"彩票游戏代理数据", nil) isFull:NO];
    }
    // 电竞
    else if ([kFyAgentReportCodeElectronicSports isEqualToString:code]) {
        return [[self class] buildingDataModlesForCommon:data code:code title:NSLocalizedString(@"电竞游戏代理数据", nil) isFull:NO];
    }
    // 体育
    else if ([kFyAgentReportCodeSports isEqualToString:code]) {
        return [[self class] buildingDataModlesForCommon:data code:code title:NSLocalizedString(@"体育游戏代理数据", nil) isFull:NO];
    }
    // 真人
    else if ([kFyAgentReportCodeMortalPeople isEqualToString:code]) {
        return [[self class] buildingDataModlesForCommon:data code:code title:NSLocalizedString(@"真人游戏代理数据", nil) isFull:NO];
    }
    // 其它
    else {
        return [[self class] buildingDataModlesForCommon:data code:code title:STR_APP_TEXT_PLACEHOLDER isFull:YES];
    }
    
    return @[].mutableCopy;
}

/// 汇总
+ (NSMutableArray<FYAgentReportAllModel *> *) buildingDataModlesForSumTotal:(NSDictionary *)data code:(NSString *)code
{
    NSMutableArray *allItemModels = [NSMutableArray array];
    
    // 用户数据
    NSDictionary *dictOfUser = [data dictionaryForKey:@"userDO"];
    NSMutableArray *itemUserModels = [FYAgentReportUserModel buildingDataModles:dictOfUser code:code];
    if (itemUserModels && 0 < itemUserModels.count) {
        [allItemModels addObjectsFromArray:itemUserModels];
    }
    
    // 团队数据
    NSDictionary *dictOfTeam = [data dictionaryForKey:@"teamDataDTO"];
    NSMutableArray *itemTeamModels = [FYAgentReportAllModel buildingDataModlesForSumTotal:dictOfTeam];
    if (itemTeamModels && 0 < itemTeamModels.count) {
        [allItemModels addObjectsFromArray:itemTeamModels];
    }
    
    // 团队下线
    NSDictionary *dictOfTeamSub = [data dictionaryForKey:@"memberBranchDTO"];
    NSMutableArray *itemTeamSubModels = [FYAgentReportItem1Model buildingDataModlesForTeamReferralis:dictOfTeamSub];
    if (itemTeamSubModels && 0 < itemTeamSubModels.count) {
        [allItemModels addObjectsFromArray:itemTeamSubModels];
    }
    
    // 充提业务
    NSDictionary *dictOfReachargeWithdraw = [data dictionaryForKey:@"rechargeBizDTO"];
    NSMutableArray *itemRechargeWithdrawModels = [FYAgentReportItem1Model buildingDataModlesForRechargeWithdraw:dictOfReachargeWithdraw];
    if (itemRechargeWithdrawModels && 0 < itemRechargeWithdrawModels.count) {
        [allItemModels addObjectsFromArray:itemRechargeWithdrawModels];
    }
    
    // 优惠奖励
    NSDictionary *dictOfRewards = [data dictionaryForKey:@"discountRewardDTO"];
    NSMutableArray *itemRewardsModels = [FYAgentReportItem1Model buildingDataModlesForRewards:dictOfRewards];
    if (itemRewardsModels && 0 < itemRewardsModels.count) {
        [allItemModels addObjectsFromArray:itemRewardsModels];
    }
    
    return allItemModels;
}

/// 公共
+ (NSMutableArray<FYAgentReportAllModel *> *) buildingDataModlesForCommon:(NSDictionary *)data code:(NSString *)code title:(NSString *)title isFull:(BOOL)isfull
{
    NSMutableArray *allItemModels = [NSMutableArray array];
    
    // 用户数据
    NSDictionary *dictOfUser = [data dictionaryForKey:@"userDO"];
    NSMutableArray *itemUserModels = [FYAgentReportUserModel buildingDataModles:dictOfUser code:code];
    if (itemUserModels && 0 < itemUserModels.count) {
        [allItemModels addObjectsFromArray:itemUserModels];
    }
    
    // 代理数据
    NSDictionary *dictOfTeam = [data dictionaryForKey:@"proxyDataDTO"];
    NSMutableArray *itemTeamModels = [FYAgentReportAllModel buildingDataModlesForCommon:dictOfTeam title:title isFull:isfull];
    if (itemTeamModels && 0 < itemTeamModels.count) {
        [allItemModels addObjectsFromArray:itemTeamModels];
    }
    
    // 游戏详情
    NSArray *arrayOfGames = [[data dictionaryForKey:@"proxyDataDTO"] arrayForKey:@"dts"];
    NSMutableArray *itemGamesModels = [FYAgentReportItem2Model buildingDataModles:arrayOfGames code:code];
    if (itemGamesModels && 0 < itemGamesModels.count) {
        [allItemModels addObjectsFromArray:itemGamesModels];
    }
    
    return allItemModels;
}


@end

