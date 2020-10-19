//
//  FYAgentReportSubViewController.h
//  ProjectCSHB
//
//  Created by fangyuan on 2020/6/28.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "FYScrollPageViewController.h"

NS_ASSUME_NONNULL_BEGIN

@protocol FYAgentReportSubViewControllerDelegate <FYScrollPageViewControllerDelegate>
@optional
// 刷新头部的搜索区域
- (void)doRefreshSearchKey:(NSString *)userId userName:(NSString *)username headIcon:(NSString *)headIcon;
// 选择时间后刷新数据
- (void)doRefreshDatePickerTimeType:(FYDatePickerTimeType)datePickerTimeType
                datePickerYearMonth:(NSString *)datePickerYearMonth
                datePickerStartTime:(NSString *)datePickerStartTime
                  datePickerEndTime:(NSString *)datePickerEndTime
                      isNeedRefresh:(BOOL)isNeedRefresh;
// 选择时间按钮标题
- (void)doDatePickerDateTimeButtonTitle:(NSString *)titleString;
- (NSString *)getCurrentDatePickerrButtonTitle;
// 获取已选择时间信息
- (FYDatePickerTimeType)getCurrentDatePickerTimeType;
- (NSString *)getCurrentDatePickerYearMonthTitleFormat;
- (NSString *)getCurrentDatePickerYearMonthContentFormat;
- (NSString *)getCurrentDatePickerStartEndTimeTitleFormat;
- (NSString *)getCurrentDatePickerStartEndTimeContentFormat;
- (NSString *)getCurrentDatePickerYearMonth;
- (NSString *)getCurrentDatePickerStartTime;
- (NSString *)getCurrentDatePickerEndTime;
// 获取搜索用户关键词
- (NSString *)getCurrentSearchMemberKey;

@end

@interface FYAgentReportSubViewController : FYScrollPageViewController <FYAgentReportViewControllerProtocol>

- (instancetype)initWithTabTitleCode:(NSString *)tabTitleCode searchMemberKey:(NSString *)searchMemberKey;

@end

NS_ASSUME_NONNULL_END
