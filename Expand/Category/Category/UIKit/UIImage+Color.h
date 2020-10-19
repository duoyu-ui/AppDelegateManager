//
//  UIImage+Color.h
//  ProjectCSHB
//
//  Created by fangyuan on 2020/6/21.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (Color)

- (UIImage *)imageWithChangeColor:(UIColor*)tintColor;

- (UIImage *)imageWithGradientTintColor:(UIColor *)tintColor;

@end

NS_ASSUME_NONNULL_END
