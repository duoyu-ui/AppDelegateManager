//
//  UIImage+None.m
//  ProjectCSHB
//
//  Created by fangyuan on 2020/8/30.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "UIImage+None.h"
#import <objc/runtime.h>

@implementation UIImage (None)

+ (void)load {
    Method imageNamed = class_getClassMethod(self,@selector(imageNamed:));
    Method looha_ImageNamed =class_getClassMethod(self,@selector(looha_none_imageNamed:));
    method_exchangeImplementations(imageNamed, looha_ImageNamed);
}

+ (instancetype)looha_none_imageNamed:(NSString*)name{
    if (![[self class] validateStringEmpty:name]) { // 判断是否为空的方法，不提供，自行搞定
      return  [self looha_none_imageNamed:name];
    } else {
        return nil;
    }
}

+ (BOOL)validateStringEmpty:(NSString *)value
{
    if (nil == value
        || [@"NULL" isEqualToString:value]
        || [value isEqualToString:@"<null>"]
        || [value isEqualToString:@"(null)"]
        || [value isEqualToString:@"null"]) {
        return YES;
    }
    // 删除两端的空格和回车
    NSString *str = [value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    return (str.length <= 0);
}

@end

