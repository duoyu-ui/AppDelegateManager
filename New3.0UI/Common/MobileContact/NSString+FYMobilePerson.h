//
//  NSString+FYMobilePerson.h
//  ProjectCSHB
//
//  Created by fangyuan on 2020/7/12.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (FYMobilePerson)

/**
 * 去除手机号的特殊字段
 * @param string 手机号
 * @return 处理过的手机号
 */
+ (NSString *)fy_filterSpecialString:(NSString *)string;

/**
 * 字符串转拼音
 * @param string 字符串
 * @return 拼音
 */
+ (NSString *)fy_pinyinForString:(NSString *)string;

@end

NS_ASSUME_NONNULL_END
