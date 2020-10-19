//
//  NSBundle+FYUtils.h
//  ProjectCSHB
//
//  Created by Tom on 2020/7/31.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSBundle (FYUtils)
+ (BOOL)isChineseLanguage;

+ (NSString *)currentLanguage;
@end

NS_ASSUME_NONNULL_END
