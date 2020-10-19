//
//  FYAgentReportHelper.h
//  ProjectCSHB
//
//  Created by fangyuan on 2020/7/5.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

static NSString *const kFyAgentReportCodeSumTotal = @"0";
static NSString *const kFyAgentReportCodeRedPacket = @"1";
static NSString *const kFyAgentReportCodeQGChess = @"3";
static NSString *const kFyAgentReportCodeElectronic = @"2";
static NSString *const kFyAgentReportCodeLottery = @"4";
static NSString *const kFyAgentReportCodeElectronicSports = @"5";
static NSString *const kFyAgentReportCodeSports = @"6";
static NSString *const kFyAgentReportCodeMortalPeople = @"7";

@interface FYAgentReportHelper : NSObject

+ (NSMutableArray *) buildingDataModles:(NSString *)code data:(NSDictionary *)dictionary;

@end

NS_ASSUME_NONNULL_END
