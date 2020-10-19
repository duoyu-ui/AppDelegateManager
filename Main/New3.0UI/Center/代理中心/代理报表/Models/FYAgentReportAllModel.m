//
//  FYAgentReportAllModel.m
//  ProjectCSHB
//
//  Created by fangyuan on 2020/6/29.
//  Copyright © 2020 Fangyuan. All rights reserved.
//
// 代理报表 - 汇总信息
//

#import "FYAgentReportAllModel.h"

@implementation FYAgentReportAllItemModel

@end

@implementation FYAgentReportAllModel

+ (NSDictionary *)mj_objectClassInArray
{
    return @{
        @"subitems" : @"FYAgentReportAllItemModel"
    };
}

/// 汇总
+ (NSMutableArray<FYAgentReportAllModel *> *) buildingDataModlesForSumTotal:(NSDictionary *)dict
{
    NSArray<NSDictionary *> *arrayOfDict = @[
        @{
            @"title": NSLocalizedString(@"团队数据", nil),
            @"totalMoneyTitle": NSLocalizedString(@"团队返水(元)", nil),
            @"totalMoneyValue": [NSString stringWithFormat:@"%.2f", [[dict numberForKey:@"totalBackWater"] floatValue]],
            @"todayMoneyTitle": NSLocalizedString(@"今日返水", nil),
            @"todayMoneyValue": [NSString stringWithFormat:@"%.2f", [[dict numberForKey:@"todayBackWater"] floatValue]],
            @"subitems": @[
                @{
                    @"leftTitle": NSLocalizedString(@"团队投注", nil),
                    @"leftValue": [NSString stringWithFormat:@"%.2f", [[dict numberForKey:@"bett"] floatValue]],
                    @"rightTitle": NSLocalizedString(@"人数", nil),
                    @"rightValue": [NSString stringWithFormat:@"%ld", (long)[[dict numberForKey:@"totalBetPerson"] integerValue]]
                },
                @{
                    @"leftTitle": NSLocalizedString(@"团队游戏报表", nil),
                    @"leftValue": [NSString stringWithFormat:@"%.2f", [[dict numberForKey:@"teamProfitLoss"] floatValue]]
                },
                @{
                    @"leftTitle": NSLocalizedString(@"直属下级余额", nil),
                    @"leftValue": [NSString stringWithFormat:@"%.2f", [[dict numberForKey:@"personBanlance"] floatValue]]
                },
                @{
                    @"leftTitle": NSLocalizedString(@"团队余额", nil),
                    @"leftValue": [NSString stringWithFormat:@"%.2f", [[dict numberForKey:@"teamBanlance"] floatValue]]
                }
            ]
        }
    ];
    return [FYAgentReportAllModel mj_objectArrayWithKeyValuesArray:arrayOfDict];
}

/// 公共
+ (NSMutableArray<FYAgentReportAllModel *> *) buildingDataModlesForCommon:(NSDictionary *)dict title:(NSString *)title isFull:(BOOL)isfull
{
    NSMutableArray<NSDictionary *> *subitems = @[
        @{
            @"leftTitle": NSLocalizedString(@"团队投注", nil),
            @"leftValue": [NSString stringWithFormat:@"%.2f", [[dict numberForKey:@"bett"] floatValue]],
            @"rightTitle": NSLocalizedString(@"人数", nil),
            @"rightValue": [NSString stringWithFormat:@"%ld", (long)[[dict numberForKey:@"bettAmount"] integerValue]]
        },
        @{
            @"leftTitle": NSLocalizedString(@"团队游戏报表", nil),
            @"leftValue": [NSString stringWithFormat:@"%.2f", [[dict numberForKey:@"gameProfitLoss"] floatValue]]
        }
    ].mutableCopy;
    
    if (isfull) {
        [subitems addObj:@{
            @"leftTitle": NSLocalizedString(@"团队抽水", nil),
            @"leftValue": [NSString stringWithFormat:@"%.2f", [[dict numberForKey:@"gameShrink"] floatValue]]
        }];
    }
    
    NSArray<NSDictionary *> *arrayOfDict = @[
        @{
            @"title": title,
            @"totalMoneyTitle": NSLocalizedString(@"团队返水(元)", nil),
            @"totalMoneyValue": [NSString stringWithFormat:@"%.2f", [[dict numberForKey:@"totalBackWater"] floatValue]],
            @"todayMoneyTitle": NSLocalizedString(@"今日返水", nil),
            @"todayMoneyValue": [NSString stringWithFormat:@"%.2f", [[dict numberForKey:@"todayBackWater"] floatValue]],
            @"subitems": subitems
        }
    ];
    
    return [FYAgentReportAllModel mj_objectArrayWithKeyValuesArray:arrayOfDict];
}


@end

