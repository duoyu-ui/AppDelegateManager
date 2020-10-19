//
//  FYYEBIconMarkView.h
//  ProjectCSHB
//
//  Created by fangyuan on 2020/5/26.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FYYEBIconMarkView : UIView

- (void)setTitle:(NSString *)title;
- (void)setTitleFont:(UIFont *)font;
- (void)setTitleColor:(UIColor *)color;
- (void)setTitleTextAlignment:(NSTextAlignment)textAlignment;

- (void)setImageUrl:(NSString *)imageUrl;

@end

NS_ASSUME_NONNULL_END
