//
//  NSString+Time.h
//  DZNCategories
//
//  Created by Ignacio Romero Zurbuchen on 8/17/13.
//  Copyright (c) 2013 DZN Labs. All rights reserved.
//  Licence: MIT-Licence
//  http://opensource.org/licenses/MIT
//

#import <Foundation/Foundation.h>

/*
 */
@interface NSString (Time)

/*
 */
+ (NSString *)elapsedTime:(NSTimeInterval)time;

/*
 */
+ (NSString *)yesterday;

/*
 */
+ (NSString *)today;

/*
 */
+ (NSString *)tomorrow;

/// 时间戳转换成字符串
/// @param stamp 时间戳
+ (NSString *)timeStampToString:(NSInteger)stamp;
@end
