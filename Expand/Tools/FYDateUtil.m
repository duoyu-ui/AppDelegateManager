//
//  FYDateUtil.m
//  ProjectCSHB
//
//  Created by fangyuan on 2020/5/26.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "FYDateUtil.h"

@implementation FYDateUtil

#pragma mark NSDate => 日期字符串，例:YYYY-MM-dd-EEEE-HH:mm:ss
+ (NSString *)getCurrentDateWithDateFormate:(NSString *)formate
{
    NSDate *now = [NSDate date];
    return [self dateFormattingWithDate:now toFormate:formate];
}

#pragma mark NSDate => 日期字符串，例:YYYY-MM-dd HH:mm:ss
+ (NSString *)dateFormattingWithDate:(NSDate *)date toFormate:(NSString *)formate
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:formate];
    return [formatter stringFromDate:date];
}


#pragma mark -

#pragma mark 日期字符串转 => NSDate
+ (NSDate *)dateWithString:(NSString *)dateString formatString:(NSString *)formatString
{
    return [[self class] dateWithString:dateString formatString:formatString timeZone:[NSTimeZone systemTimeZone]];
}

#pragma mark 日期字符串转 => NSDate
+ (NSDate *)dateWithString:(NSString *)dateString formatString:(NSString *)formatString timeZone:(NSTimeZone *)timeZone
{
    static NSDateFormatter *parser = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        parser = [[NSDateFormatter alloc] init];
    });

    parser.dateStyle = NSDateFormatterNoStyle;
    parser.timeStyle = NSDateFormatterNoStyle;
    parser.timeZone = timeZone;
    parser.dateFormat = formatString;

    return [parser dateFromString:dateString];
}

#pragma mark 日期字符串转 => 日期字符串
+ (NSString *)dateFormattingWithDateString:(NSString *)dateString dateFormate:(NSString *)dateFormate toFormate:(NSString *)toFormate
{
    NSDate *date = [[self class] dateWithString:dateString formatString:dateFormate];
    return [FYDateUtil dateFormattingWithDate:date toFormate:toFormate];
}


#pragma mark -

#pragma mark 比较两个日期字符串大小
+ (NSInteger)compareDate:(NSString*)aDate withDate:(NSString*)bDate formate:(NSString *)formate
{
    NSDate *dta = [[self class] dateWithString:aDate formatString:formate];
    NSDate *dtb = [[self class] dateWithString:bDate formatString:formate];
    
    int aa = 0;
    NSComparisonResult result = [dta compare:dtb];
    if (result==NSOrderedSame) {
        // 相等
        aa = 0;
    } else if (result==NSOrderedAscending) {
        // aDate 比 bDate 小
        aa = 1;
    } else if (result==NSOrderedDescending) {
        // aDate 比 bDate 大
        aa = -1;
    }
    return aa;
}


#pragma mark-

// 获取一周的日期
+ (NSArray<NSDate *> *)getWeekDays:(NSDate *)date
{
    NSMutableArray<NSDate *> *weekArray = [NSMutableArray<NSDate *> arrayWithCapacity:7];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *component = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday fromDate:date];
    
    // 几号
    NSInteger day = [component day];
    
    // 1(星期天) 2(星期一) 3(星期二) 4(星期三) 5(星期四) 6(星期五) 7(星期六)
    NSInteger weekDay = [component weekday];

    if (weekDay == 1) {
        for (int i = 7; i >= 1; i --) {
            // 在当前日期(去掉时分秒)基础上加上差的天数
            NSDateComponents *weekComp = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay  fromDate:date];
            // 由于 weekDay 是一周的最后一天，所以减去7得到周一
            [weekComp setDay:day + (weekDay - i)];
            NSDate *dayOfWeek = [calendar dateFromComponents:weekComp];
            [weekArray addObject:dayOfWeek];
        }
    } else {
        for (int i = 2; i <= 8; i ++) {
            NSDateComponents *weekComp = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:date];
            [weekComp setDay:day + (i - weekDay)];
            NSDate *dayOfWeek = [calendar dateFromComponents:weekComp];
            [weekArray addObject:dayOfWeek];
        }
    }
    return weekArray;
}


#pragma mark 获取周的第一天
+ (NSDate *)getFirstDateOfWeekFromDate:(NSDate *)date
{
    return [FYDateUtil getWeekDays:date].firstObject;
}

#pragma mark 获取周的最后一天
+ (NSDate *)getLastDateOfWeekFromDate:(NSDate *)date
{
    NSDate *lastDayOWeek = [FYDateUtil getWeekDays:date].lastObject;
    NSDate *currentDay = [NSDate today];
    if ([lastDayOWeek isLaterThan:currentDay]) {
        return currentDay;
    }
    return lastDayOWeek;
}

#pragma mark 获取月的第一天
+ (NSDate *)getFirstDateOfMonthFromDate:(NSDate *)date
{
    return [NSDate dateWithYear:date.year month:date.month day:1];
}

#pragma mark 获取月的最后一天
+ (NSDate *)getLastDateOfMonthFromDate:(NSDate *)date
{
    NSDate *currentDay = [NSDate today];
    NSDate *lastDayOfMonth = [NSDate dateWithYear:date.year month:date.month day:date.daysInMonth];
    if ([lastDayOfMonth isLaterThan:currentDay]) {
        return currentDay;
    }
    return lastDayOfMonth;
}


#pragma mark -

#pragma mark 根据组件获取时间
+ (NSDate *)getDateWithDateComponents:(NSDateComponents *)dateComponents
{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    return [gregorian dateFromComponents:dateComponents];
#pragma clang diagnostic pop
}


#pragma mark 获取时间，时分秒是否返回，NO则则清零
+ (NSDate *)returnDateClock:(NSDate *)date hour:(BOOL)hasHour minute:(BOOL)hasMinute second:(BOOL)hasSecond
{
    NSCalendar *calender = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *dateComponent = [calender components:unitFlags fromDate:date];
    int hour = hasHour ? 0 : (int)[dateComponent hour];
    int minute = hasMinute ? 0 : (int)[dateComponent minute];
    int second = hasSecond ? 0 : (int)[dateComponent second];
    // 当前时分秒:hour,minute,second
    // 返回当前时间(hour * 3600 + minute * 60 + second)之前的时间,即为今天凌晨0点
    NSDate *nowDay = [NSDate dateWithTimeInterval: - (hour * 3600 + minute * 60 + second) sinceDate:date];
    long long inter = [nowDay timeIntervalSince1970] * 1000;
    NSDate *newDate = [NSDate dateWithTimeIntervalSince1970:inter / 1000];
    return newDate;
}

#pragma mark 获取00点时间
+ (NSDate *)returnDate00Clock:(NSDate *)date
{
    NSCalendar *calender = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *dateComponent = [calender components:unitFlags fromDate:date];
    int hour = (int)[dateComponent hour];
    int minute = (int)[dateComponent minute];
    int second = (int)[dateComponent second];
    // 当前时分秒:hour,minute,second
    // 返回当前时间(hour * 3600 + minute * 60 + second)之前的时间,即为今天凌晨0点
    NSDate *nowDay = [NSDate dateWithTimeInterval: - (hour * 3600 + minute * 60 + second) sinceDate:date];
    long long inter = [nowDay timeIntervalSince1970] * 1000;
    NSDate *newDate = [NSDate dateWithTimeIntervalSince1970:inter / 1000];
    return newDate;
}

#pragma mark 获取24点时间
+ (NSDate *)returnDate24Clock:(NSDate *)date
{
    NSCalendar *calender = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *dateComponent = [calender components:unitFlags fromDate:date];
    int hour = (int)[dateComponent hour];
    int minute = (int)[dateComponent minute];
    int second = (int)[dateComponent second];
    // 一天是60分钟 * 60秒 * 24小时 = 86400秒
    NSDate *nextDay = [NSDate dateWithTimeInterval: - (hour * 3600 + minute * 60 + second) + 86400 - 1 sinceDate:date];
    return nextDay;
}

#pragma mark 获取当天0点时间
+ (NSDate *)returnToDay00Clock
{
    return [FYDateUtil returnDate00Clock:[NSDate date]];
}

#pragma mark 获取当天24点时间
+ (NSDate *)returnToDay24Clock
{
    return [FYDateUtil returnDate24Clock:[NSDate date]];
}


@end
