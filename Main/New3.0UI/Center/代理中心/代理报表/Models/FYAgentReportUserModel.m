//
//  FYAgentReportUserModel.m
//  ProjectCSHB
//
//  Created by fangyuan on 2020/7/7.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "FYAgentReportUserModel.h"
#import "FYAgentReportHelper.h"

@implementation FYAgentReportUserItemModel

@end

@implementation FYAgentReportUserModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{
             @"isNewReg" : @"newRegister",
             @"imageUrl" : @"headIco"
             };
}

+ (NSDictionary *)mj_objectClassInArray
{
    return @{
        @"subitems" : @"FYAgentReportUserItemModel"
    };
}

+ (NSMutableArray<FYAgentReportUserModel *> *)buildingDataModles:(NSDictionary *)dictionary code:(NSString *)code
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:dictionary];
    
    // 汇总
    if ([kFyAgentReportCodeSumTotal isEqualToString:code]) {
        [dict setObj:@[
            @{
                @"title": NSLocalizedString(@"投注", nil),
                @"value": [NSString stringWithFormat:@"%.2f", [[dict numberForKey:@"bett"] floatValue]]
            },
            @{
                @"title": NSLocalizedString(@"游戏报表", nil),
                @"value": [NSString stringWithFormat:@"%.2f", [[dict numberForKey:@"profitLoss"] floatValue]]
            },
            @{
                @"title": NSLocalizedString(@"余额", nil),
                @"value": [NSString stringWithFormat:@"%.2f", [[dict numberForKey:@"banlance"] floatValue]]
            },
            @{
                @"title": NSLocalizedString(@"返水", nil),
                @"value": [NSString stringWithFormat:@"%.2f", [[dict numberForKey:@"backWater"] floatValue]]
            }
        ] forKey:@"subitems"];
        return [FYAgentReportUserModel mj_objectArrayWithKeyValuesArray:@[ dict ]];
    }
    // 红包、棋牌
    else if ([kFyAgentReportCodeRedPacket isEqualToString:code]
             || [kFyAgentReportCodeQGChess isEqualToString:code]) {
        [dict setObj:@[
            @{
                @"title": NSLocalizedString(@"投注", nil),
                @"value": [NSString stringWithFormat:@"%.2f", [[dict numberForKey:@"bett"] floatValue]]
            },
            @{
                @"title": NSLocalizedString(@"游戏报表", nil),
                @"value": [NSString stringWithFormat:@"%.2f", [[dict numberForKey:@"profitLoss"] floatValue]]
            },
            @{
                @"title": NSLocalizedString(@"抽水", nil),
                @"value": [NSString stringWithFormat:@"%.2f", [[dict numberForKey:@"shrink"] floatValue]]
            },
            @{
                @"title": NSLocalizedString(@"返水", nil),
                @"value": [NSString stringWithFormat:@"%.2f", [[dict numberForKey:@"backWater"] floatValue]]
            }
        ] forKey:@"subitems"];
        return [FYAgentReportUserModel mj_objectArrayWithKeyValuesArray:@[ dict ]];
    }
    // 电子、彩票、电竞、体育、真人
    else if ([kFyAgentReportCodeElectronic isEqualToString:code]
             || [kFyAgentReportCodeLottery isEqualToString:code]
             || [kFyAgentReportCodeElectronicSports isEqualToString:code]
             || [kFyAgentReportCodeSports isEqualToString:code]
             || [kFyAgentReportCodeMortalPeople isEqualToString:code]) {
        [dict setObj:@[
            @{
                @"title": NSLocalizedString(@"投注", nil),
                @"value": [NSString stringWithFormat:@"%.2f", [[dict numberForKey:@"bett"] floatValue]]
            },
            @{
                @"title": NSLocalizedString(@"游戏报表", nil),
                @"value": [NSString stringWithFormat:@"%.2f", [[dict numberForKey:@"profitLoss"] floatValue]]
            },
            @{
                @"title": NSLocalizedString(@"返水", nil),
                @"value": [NSString stringWithFormat:@"%.2f", [[dict numberForKey:@"backWater"] floatValue]]
            }
        ] forKey:@"subitems"];
        return [FYAgentReportUserModel mj_objectArrayWithKeyValuesArray:@[ dict ]];
    }
    // 其它
    else {
        [dict setObj:@[
            @{
                @"title": NSLocalizedString(@"投注", nil),
                @"value": [NSString stringWithFormat:@"%.2f", [[dict numberForKey:@"bett"] floatValue]]
            },
            @{
                @"title": NSLocalizedString(@"游戏报表", nil),
                @"value": [NSString stringWithFormat:@"%.2f", [[dict numberForKey:@"profitLoss"] floatValue]]
            },
            @{
                @"title": NSLocalizedString(@"抽水", nil),
                @"value": [NSString stringWithFormat:@"%.2f", [[dict numberForKey:@"shrink"] floatValue]]
            },
            @{
                @"title": NSLocalizedString(@"返水", nil),
                @"value": [NSString stringWithFormat:@"%.2f", [[dict numberForKey:@"backWater"] floatValue]]
            }
        ] forKey:@"subitems"];
        return [FYAgentReportUserModel mj_objectArrayWithKeyValuesArray:@[ dict ]];
    }

    return [FYAgentReportUserModel mj_objectArrayWithKeyValuesArray:@[ dict ]];
}


@end

