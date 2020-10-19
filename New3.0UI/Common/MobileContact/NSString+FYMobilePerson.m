//
//  NSString+FYMobilePerson.m
//  ProjectCSHB
//
//  Created by fangyuan on 2020/7/12.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "NSString+FYMobilePerson.h"

@implementation NSString (FYMobilePerson)

+ (NSString *)fy_filterSpecialString:(NSString *)string
{
    if (string == nil)
    {
        return @"";
    }
    
    string = [string stringByReplacingOccurrencesOfString:@"+86" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@"-" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@"(" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@")" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@" " withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@" " withString:@""];
    return string;
}

+ (NSString *)fy_pinyinForString:(NSString *)string
{
    if (string.length == 0)
    {
        return nil;
    }
    
    NSMutableString *mutableString = [NSMutableString stringWithString:string];
    CFStringTransform((CFMutableStringRef)mutableString, NULL, kCFStringTransformToLatin, false);
    NSMutableString *pinyinString = [[mutableString stringByFoldingWithOptions:NSDiacriticInsensitiveSearch locale:[NSLocale currentLocale]] mutableCopy];
  
    NSString *str = [string substringToIndex:1];
    
    // 多音字处理 http://blog.csdn.net/qq_29307685/article/details/51532147
    if ([str isEqualToString:NSLocalizedString(@"长", nil)])
    {
        [pinyinString replaceCharactersInRange:NSMakeRange(0, 5) withString:@"chang"];
    }
    if ([str isEqualToString:NSLocalizedString(@"沈", nil)])
    {
        [pinyinString replaceCharactersInRange:NSMakeRange(0, 4) withString:@"shen"];
    }
    if ([str isEqualToString:NSLocalizedString(@"厦", nil)])
    {
        [pinyinString replaceCharactersInRange:NSMakeRange(0, 3) withString:@"xia"];
    }
    if ([str isEqualToString:NSLocalizedString(@"地", nil)])
    {
        [pinyinString replaceCharactersInRange:NSMakeRange(0, 2) withString:@"di"];
    }
    if ([str isEqualToString:NSLocalizedString(@"重", nil)])
    {
        [pinyinString replaceCharactersInRange:NSMakeRange(0, 5) withString:@"chong"];
    }
   
    return [[pinyinString lowercaseString] copy];
}

@end

