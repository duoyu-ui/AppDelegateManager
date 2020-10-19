//
//  FYLanguageConfig.m
//  ProjectCSHB
//
//  Created by Tom on 2020/7/31.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "FYLanguageConfig.h"
static NSString *const FYUserLanguageKey = @"FYUserLanguageKey";
@implementation FYLanguageConfig
+ (void)setUserLanguage:(NSString *)userLanguage{
    //跟随手机系统
      if (!userLanguage.length) {
          [self resetSystemLanguage];
          return;
      }
      //用户自定义
      [[NSUserDefaults standardUserDefaults] setValue:userLanguage forKey:FYUserLanguageKey];
      [[NSUserDefaults standardUserDefaults] setValue:@[userLanguage] forKey:@"AppleLanguages"];
      [[NSUserDefaults standardUserDefaults] synchronize];
}
+ (NSString *)userLanguage
{
    return [[NSUserDefaults standardUserDefaults] valueForKey:FYUserLanguageKey];
}

/**
 重置系统语言
 */
+ (void)resetSystemLanguage
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:FYUserLanguageKey];
    [[NSUserDefaults standardUserDefaults] setValue:nil forKey:@"AppleLanguages"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
@end
