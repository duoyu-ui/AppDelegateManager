//
//  FYAgentReportItem2Model.m
//  ProjectCSHB
//
//  Created by fangyuan on 2020/6/29.
//  Copyright © 2020 Fangyuan. All rights reserved.
//
// 代理报表 - 样式二
//

#import "FYAgentReportItem2Model.h"
#import "FYAgentReportHelper.h"

@implementation FYAgentReportItem2SubModel

@end

@implementation FYAgentReportItem2Model

+ (NSDictionary *)mj_objectClassInArray
{
    return @{
        @"subitems" : @"FYAgentReportItem2SubModel"
    };
}

+ (NSMutableArray<FYAgentReportItem2Model *> *)buildingDataModles:(NSArray *)arrayOfDicts code:(NSString *)code
{
    __block NSMutableArray<NSMutableDictionary *> *arrayOfDictionary = [NSMutableArray array];
    [arrayOfDicts enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull dict, NSUInteger idx, BOOL * _Nonnull stop) {
        NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithDictionary:dict];
        // 汇总
        if ([kFyAgentReportCodeSumTotal isEqualToString:code]) {

        }
        // 红包、棋牌
        else if ([kFyAgentReportCodeRedPacket isEqualToString:code]
                 || [kFyAgentReportCodeQGChess isEqualToString:code]) {
            [dictionary setObj:@[
                @{
                    @"title": NSLocalizedString(@"团队投注", nil),
                    @"value": [NSString stringWithFormat:@"%.2f", [[dict numberForKey:@"bett"] floatValue]]
                },
                @{
                    @"title": NSLocalizedString(@"团队游戏报表", nil),
                    @"value": [NSString stringWithFormat:@"%.2f", [[dict numberForKey:@"profitLoss"] floatValue]]
                },
                @{
                    @"title": NSLocalizedString(@"团队抽水", nil),
                    @"value": [NSString stringWithFormat:@"%.2f", [[dict numberForKey:@"shrink"] floatValue]]
                },
                @{
                    @"title": NSLocalizedString(@"团队返水", nil),
                    @"value": [NSString stringWithFormat:@"%.2f", [[dict numberForKey:@"backWater"] floatValue]]
                }
            ] forKey:@"subitems"];
        }
        // 电子、彩票、电竞、体育、真人
        else if ([kFyAgentReportCodeElectronic isEqualToString:code]
                 || [kFyAgentReportCodeLottery isEqualToString:code]
                 || [kFyAgentReportCodeElectronicSports isEqualToString:code]
                 || [kFyAgentReportCodeSports isEqualToString:code]
                 || [kFyAgentReportCodeMortalPeople isEqualToString:code]) {
            [dictionary setObj:@[
                @{
                    @"title": NSLocalizedString(@"团队投注", nil),
                    @"value": [NSString stringWithFormat:@"%.2f", [[dict numberForKey:@"bett"] floatValue]]
                },
                @{
                    @"title": NSLocalizedString(@"团队游戏报表", nil),
                    @"value": [NSString stringWithFormat:@"%.2f", [[dict numberForKey:@"profitLoss"] floatValue]]
                },
                @{
                    @"title": NSLocalizedString(@"团队返水", nil),
                    @"value": [NSString stringWithFormat:@"%.2f", [[dict numberForKey:@"backWater"] floatValue]]
                }
            ] forKey:@"subitems"];
        }
        // 其它
        else {
            [dictionary setObj:@[
                @{
                    @"title": NSLocalizedString(@"团队投注", nil),
                    @"value": [NSString stringWithFormat:@"%.2f", [[dict numberForKey:@"bett"] floatValue]]
                },
                @{
                    @"title": NSLocalizedString(@"团队游戏报表", nil),
                    @"value": [NSString stringWithFormat:@"%.2f", [[dict numberForKey:@"profitLoss"] floatValue]]
                },
                @{
                    @"title": NSLocalizedString(@"团队返水", nil),
                    @"value": [NSString stringWithFormat:@"%.2f", [[dict numberForKey:@"backWater"] floatValue]]
                }
            ] forKey:@"subitems"];
        }
        [arrayOfDictionary addObj:dictionary];
    }];
    return [FYAgentReportItem2Model mj_objectArrayWithKeyValuesArray:arrayOfDictionary];
}


@end

