//
//  FYBagBagCowRecordModel.m
//  ProjectCSHB
//
//  Created by fangyuan on 2020/7/22.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "FYBagBagCowRecordModel.h"

@implementation FYBagBagCowRecordSubDetailsItemModel

@end

@implementation FYBagBagCowRecordSubDetailsModel

+ (NSDictionary *)mj_objectClassInArray
{
    return @{
        @"userBetMapDTOS" : @"FYBagBagCowRecordSubDetailsItemModel"
    };
}

@end

@implementation FYBagBagCowRecordModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{
             @"uuid" : @"id"
             };
}

+ (NSMutableArray<FYBagBagCowRecordModel *> *) buildingDataModles
{
    NSArray<NSDictionary<NSString *, NSDictionary *> *> *arrayOfDict = @[
        @{
            @"bankerNumber": @"0",
            @"createTime": @"2020-05-31 00:01:30",
            @"details": @{
                @"allLoss": @"0",
                @"allProfits": @"0",
                @"userBetMapDTOS": @[
                    @{
                        @"betAttr": @"0",
                        @"betMoney": @"0",
                        @"odds": @"0",
                        @"profitLoss": @"0"
                    }
                ]
            },
            @"gameNumber": @"123456",
            @"id": @"0",
            @"money": @"432.34",
            @"playerNumber": @"0",
            @"roomName": @"",
            @"winner": @"0"
        },
        @{
            @"bankerNumber": @"0",
            @"createTime": @"2020-05-31 00:01:30",
            @"details": @{
                @"allLoss": @"0",
                @"allProfits": @"0",
                @"userBetMapDTOS": @[
                    @{
                        @"betAttr": @"0",
                        @"betMoney": @"0",
                        @"odds": @"0",
                        @"profitLoss": @"0"
                    }
                ]
            },
            @"gameNumber": @"123457",
            @"id": @"0",
            @"money": @"-132.34",
            @"playerNumber": @"0",
            @"roomName": @"",
            @"winner": @"1"
        },
        @{
            @"bankerNumber": @"0",
            @"createTime": @"2020-05-31 00:01:30",
            @"details": @{
                @"allLoss": @"0",
                @"allProfits": @"0",
                @"userBetMapDTOS": @[
                    @{
                        @"betAttr": @"0",
                        @"betMoney": @"0",
                        @"odds": @"0",
                        @"profitLoss": @"0"
                    }
                ]
            },
            @"gameNumber": @"123458",
            @"id": @"0",
            @"money": @"35.34",
            @"playerNumber": @"0",
            @"roomName": @"",
            @"winner": @"2"
        }
    ];
    return [FYBagBagCowRecordModel mj_objectArrayWithKeyValuesArray:arrayOfDict];
}


@end

