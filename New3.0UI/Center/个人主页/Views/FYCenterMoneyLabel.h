//
//  FYCenterMoneyLabel.h
//  ProjectCSHB
//
//  Created by fangyuan on 2020/5/19.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FYCenterMoneyLabel : UIView

- (void)setTitle:(NSString *)title;
- (void)setTitleFont:(UIFont *)font;
- (void)setTitleColor:(UIColor *)color;
- (void)setTitleTextAlignment:(NSTextAlignment)textAlignment;

- (void)setMoney:(NSString *)money;
- (void)setMoneyFont:(UIFont *)font;
- (void)setMoneyColor:(UIColor *)color;
- (void)setMoneyTextAlignment:(NSTextAlignment)textAlignment;


@end

NS_ASSUME_NONNULL_END
