//
//  FYDatePickerViewController.h
//  ProjectCSHB
//
//  Created by fangyuan on 2020/6/23.
//  Copyright © 2020 Fangyuan. All rights reserved.
//
// 时间选择器
//

#import "CFCBaseCoreViewController.h"

NS_ASSUME_NONNULL_BEGIN

static NSString *const kFYDatePickerFormatYearMonth = @"yyyy-MM";
static NSString *const kFYDatePickerFormatYearMonthDay = @"yyyy-MM-dd";
//
static NSString *const kFYDatePickerFormatYear = @"yyyy"; //年
static NSString *const kFYDatePickerFormatYearAndMonth = @"yyyy-MM"; //年月
static NSString *const kFYDatePickerFormatDate = @"yyyy-MM-dd"; //年月日
static NSString *const kFYDatePickerFormatDateHour = @"yyyy-MM-dd HH"; //年月日时
static NSString *const kFYDatePickerFormatDateHourMinute = @"yyyy-MM-dd HH:mm";//年月日时分
static NSString *const kFYDatePickerFormatDateHourMinuteSecond = @"yyyy-MM-dd HH:mm:ss"; //年月日时分秒
static NSString *const kFYDatePickerFormatMonthDay = @"MM-dd"; //月日
static NSString *const kFYDatePickerFormatMonthDayHour = @"MM-dd HH";//月日时
static NSString *const kFYDatePickerFormatMonthDayHourMinute = @"MM-dd HH:mm";//月日时分
static NSString *const kFYDatePickerFormatMonthDayHourMinuteSecond = @"MM-dd HH:mm:ss"; //月日时分秒
static NSString *const kFYDatePickerFormatTime = @"HH:mm";//时分
static NSString *const kFYDatePickerFormatTimeAndSecond = @"HH:mm:ss"; //时分秒
static NSString *const kFYDatePickerFormatMinuteAndSecond = @"mm:ss"; //分秒
static NSString *const kFYDatePickerFormatDateFull = @"yyyy-MM-dd HH:mm:ss";

typedef NS_ENUM(NSInteger, FYDatePickerTimeType) {
    FYDatePickerTimeTypeNone = 1000,  // 取消删除
    FYDatePickerTimeTypeYearMonth = 1001,  // 按月选择
    FYDatePickerTimeTypeStartEndTime = 1002, // 按日选择
};


@interface FYDatePickerViewController : CFCBaseCoreViewController

@property (nonatomic, copy) void(^dismissBlock)(void);

@property (nonatomic, copy) void(^cancleActionBlock)(void);

@property (nonatomic, copy) void(^confirmActionBlock)(FYDatePickerTimeType datePickerTimeType, NSString *yearmonth, NSString *yearMonthTitleFormat, NSString *yearMonthContentFormat, NSString *starttime, NSString *endtime, NSString *startEndTimeTitleFormat, NSString *startEndTimeContentFormat);

+ (instancetype)datePicker:(FYDatePickerTimeType)datePickerTimeType
                 yearMonth:(NSString *)yearMonth
      yearMonthTitleFormat:(NSString *)yearMonthTitleFormat
    yearMonthContentFormat:(NSString *)yearMonthContentFormat
                 startTime:(NSString *)starttime
                   endTime:(NSString *)endtime
   startEndTimeTitleFormat:(NSString *)startEndTimeTitleFormat
 startEndTimeContentFormat:(NSString *)startEndTimeContentFormat;

+ (NSDate *)datePickerSelectDate:(NSDate *)date
                      dateformat:(NSString *)dateformat
                    dateTimeType:(FYDatePickerTimeType)datePickerTimeType
           isBeginTimeOfStartEnd:(BOOL)isBeginTimeOfStartEnd;

@end


NS_ASSUME_NONNULL_END

