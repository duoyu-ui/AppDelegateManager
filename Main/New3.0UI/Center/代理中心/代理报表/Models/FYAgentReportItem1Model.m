//
//  FYAgentReportItem1Model.m
//  ProjectCSHB
//
//  Created by fangyuan on 2020/6/29.
//  Copyright © 2020 Fangyuan. All rights reserved.
//
// 代理报表 - 样式一
//

#import "FYAgentReportItem1Model.h"

@implementation FYAgentReportItem1SubModel

@end

@implementation FYAgentReportItem1Model

+ (NSDictionary *)mj_objectClassInArray
{
    return @{
        @"subitems" : @"FYAgentReportItem1SubModel"
    };
}

/// 团队下线
+ (NSMutableArray<FYAgentReportItem1Model *> *) buildingDataModlesForTeamReferralis:(NSDictionary *)dict
{
    NSArray<NSDictionary *> *arrayOfDict = @[
        @{
            @"title": NSLocalizedString(@"团队下线", nil),
            @"isLookSubUser": [dict numberForKey:@"booleanClick"],
            @"subitems": @[
                @{
                    @"leftTitle": NSLocalizedString(@"团队人数", nil),
                    @"leftValue": [NSString stringWithFormat:@"%ld", [[dict numberForKey:@"teamPersonAmount"] integerValue]],
                    @"rightTitle": NSLocalizedString(@"代理", nil),
                    @"rightValue": [NSString stringWithFormat:@"%ld", [[dict numberForKey:@"proxyInTeamPerson"] integerValue]]
                },
                @{
                    @"leftTitle": NSLocalizedString(@"新注册人数", nil),
                    @"leftValue": [NSString stringWithFormat:@"%ld", [[dict numberForKey:@"newRegisterAmount"] integerValue]],
                    @"rightTitle": NSLocalizedString(@"代理", nil),
                    @"rightValue": [NSString stringWithFormat:@"%ld", [[dict numberForKey:@"proxyInNewRegister"] integerValue]]
                },
                @{
                    @"leftTitle": NSLocalizedString(@"直推人数", nil),
                    @"leftValue": [NSString stringWithFormat:@"%ld", [[dict numberForKey:@"directAmount"] integerValue]],
                    @"rightTitle": NSLocalizedString(@"代理", nil),
                    @"rightValue": [NSString stringWithFormat:@"%ld", [[dict numberForKey:@"proxyInDirect"] integerValue]]
                }
            ]
        }
    ];
    return [FYAgentReportItem1Model mj_objectArrayWithKeyValuesArray:arrayOfDict];
}

/// 充提业务
+ (NSMutableArray<FYAgentReportItem1Model *> *) buildingDataModlesForRechargeWithdraw:(NSDictionary *)dict
{
    NSArray<NSDictionary *> *arrayOfDict = @[
        @{
            @"title": NSLocalizedString(@"充提业务", nil),
            @"isLookSubUser": [NSNumber numberWithBool:NO],
            @"subitems": @[
                @{
                    @"leftTitle": NSLocalizedString(@"充值总额", nil),
                    @"leftValue": [NSString stringWithFormat:@"%.2f", [[dict numberForKey:@"totalRecharge"] floatValue]],
                    @"rightTitle": NSLocalizedString(@"人数", nil),
                    @"rightValue": [NSString stringWithFormat:@"%ld", [[dict numberForKey:@"totalRechargePersons"] integerValue]]
                },
                @{
                    @"leftTitle": NSLocalizedString(@"提款总额", nil),
                    @"leftValue": [NSString stringWithFormat:@"%.2f", [[dict numberForKey:@"totalWithDraw"] floatValue]],
                    @"rightTitle": NSLocalizedString(@"人数", nil),
                    @"rightValue": [NSString stringWithFormat:@"%ld", [[dict numberForKey:@"totalWithPersons"] integerValue]]
                },
                @{
                    @"leftTitle": NSLocalizedString(@"首充总额", nil),
                    @"leftValue": [NSString stringWithFormat:@"%.2f", [[dict numberForKey:@"firstRecharge"] floatValue]],
                    @"rightTitle": NSLocalizedString(@"人数", nil),
                    @"rightValue": [NSString stringWithFormat:@"%ld", [[dict numberForKey:@"firstRechargePersons"] integerValue]]
                },
                @{
                    @"leftTitle": NSLocalizedString(@"二充总额", nil),
                    @"leftValue": [NSString stringWithFormat:@"%.2f", [[dict numberForKey:@"secondRecharge"] floatValue]],
                    @"rightTitle": NSLocalizedString(@"人数", nil),
                    @"rightValue": [NSString stringWithFormat:@"%ld", [[dict numberForKey:@"secondRechargePersons"] integerValue]]
                }
            ]
        }
    ];
    return [FYAgentReportItem1Model mj_objectArrayWithKeyValuesArray:arrayOfDict];
}

/// 优惠奖励
+ (NSMutableArray<FYAgentReportItem1Model *> *) buildingDataModlesForRewards:(NSDictionary *)dict
{
    NSArray<NSDictionary *> *arrayOfDict = @[
        @{
            @"title": NSLocalizedString(@"优惠奖励", nil),
            @"isLookSubUser": [NSNumber numberWithBool:NO],
            @"subitems": @[
                @{
                    @"leftTitle": NSLocalizedString(@"充值奖励", nil),
                    @"leftValue": [NSString stringWithFormat:@"%.2f", [[dict numberForKey:@"rechargeReward"] floatValue]],
                    @"rightTitle": NSLocalizedString(@"人数", nil),
                    @"rightValue": [NSString stringWithFormat:@"%ld", [[dict numberForKey:@"rechargeRewardPersons"] integerValue]]
                },
                @{
                    @"leftTitle": NSLocalizedString(@"推广奖励", nil),
                    @"leftValue": [NSString stringWithFormat:@"%.2f", [[dict numberForKey:@"spreadReward"] floatValue]],
                    @"rightTitle": NSLocalizedString(@"人数", nil),
                    @"rightValue": [NSString stringWithFormat:@"%ld", [[dict numberForKey:@"spreadRewardPersons"] integerValue]]
                },
                @{
                    @"leftTitle": NSLocalizedString(@"游戏奖励", nil),
                    @"leftValue": [NSString stringWithFormat:@"%.2f", [[dict numberForKey:@"gameReward"] floatValue]],
                    @"rightTitle": NSLocalizedString(@"人数", nil),
                    @"rightValue": [NSString stringWithFormat:@"%ld", [[dict numberForKey:@"gameRewardPersons"] integerValue]]
                }
            ]
        }
    ];
    return [FYAgentReportItem1Model mj_objectArrayWithKeyValuesArray:arrayOfDict];
}


@end

