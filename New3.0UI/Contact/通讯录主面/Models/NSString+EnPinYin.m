//
//  NSString+EnPinYin.m
//  ProjectCSHB
//
//  Created by fangyuan on 2020/6/15.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "NSString+EnPinYin.h"

@implementation NSString (EnPinYin)

// 汉字、英语 的拼音
- (NSString *)toPinyin
{
    NSMutableString *str = [self mutableCopy];
    CFStringTransform(( CFMutableStringRef)str, NULL, kCFStringTransformMandarinLatin, NO);
    CFStringTransform((CFMutableStringRef)str, NULL, kCFStringTransformStripDiacritics, NO);
    return [[str stringByReplacingOccurrencesOfString:@" " withString:@""] lowercaseString];
}

@end
