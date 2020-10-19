//
//  FYDateUtil.h
//  ProjectCSHB
//
//  Created by fangyuan on 2020/5/26.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FYDateUtil : NSObject

#pragma mark NSDate => 日期字符串，例:YYYY-MM-dd-EEEE-HH:mm:ss
+ (NSString *)getCurrentDateWithDateFormate:(NSString *)formate;
#pragma mark NSDate => 日期字符串，例:YYYY-MM-dd HH:mm:ss
+ (NSString *)dateFormattingWithDate:(NSDate *)date toFormate:(NSString *)formate;


#pragma mark 日期字符串转 => NSDate
+ (NSDate *)dateWithString:(NSString *)dateString formatString:(NSString *)formatString;
#pragma mark 日期字符串转 => NSDate
+ (NSDate *)dateWithString:(NSString *)dateString formatString:(NSString *)formatString timeZone:(NSTimeZone *)timeZone;
#pragma mark 日期字符串转 => 日期字符串
+ (NSString *)dateFormattingWithDateString:(NSString *)dateString dateFormate:(NSString *)dateFormate toFormate:(NSString *)toFormate;


#pragma mark 比较两个日期字符串大小
+ (NSInteger)compareDate:(NSString*)aDate withDate:(NSString*)bDate formate:(NSString *)formate;


#pragma mark 获取周的第一天
+ (NSDate *)getFirstDateOfWeekFromDate:(NSDate *)date;
#pragma mark 获取周的最后一天
+ (NSDate *)getLastDateOfWeekFromDate:(NSDate *)date;
#pragma mark 获取月的第一天
+ (NSDate *)getFirstDateOfMonthFromDate:(NSDate *)date;
#pragma mark 获取月的最后一天
+ (NSDate *)getLastDateOfMonthFromDate:(NSDate *)date;


#pragma mark 根据组件获取时间
+ (NSDate *)getDateWithDateComponents:(NSDateComponents *)dateComponents;
#pragma mark 获取时间，时分秒是否返回，NO则则清零
+ (NSDate *)returnDateClock:(NSDate *)date hour:(BOOL)hasHour minute:(BOOL)hasMinute second:(BOOL)hasSecond;
#pragma mark 获取00点时间
+ (NSDate *)returnDate00Clock:(NSDate *)date;
#pragma mark 获取当天24点时间
+ (NSDate *)returnDate24Clock:(NSDate *)date;
#pragma mark 获取当天00点时间
+ (NSDate *)returnToDay00Clock;
#pragma mark 获取当天24点时间
+ (NSDate *)returnToDay24Clock;


@end

NS_ASSUME_NONNULL_END
