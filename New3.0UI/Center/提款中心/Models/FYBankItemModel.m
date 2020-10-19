//
//  FYBankItemModel.m
//  ProjectCSHB
//
//  Created by fangyuan on 2020/6/9.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "FYBankItemModel.h"

@implementation FYBankItemModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{
             @"uuid" : @"id"
             };
}

- (UIImage *)bankCardImage
{

    UIImage *image = nil;

    NSString *image_name = [NSString stringWithFormat:@"%@.png", self.title];

    NSString *resourcePath = [[NSBundle mainBundle] resourcePath];

    NSString *bundlePath = [resourcePath stringByAppendingPathComponent:@"BankIcons.bundle"];

    NSString *image_path = [bundlePath stringByAppendingPathComponent:image_name];;

    image = [[UIImage alloc] initWithContentsOfFile:image_path];

    return image;

}


@end
