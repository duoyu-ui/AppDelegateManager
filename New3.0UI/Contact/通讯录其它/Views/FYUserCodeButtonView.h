//
//  FYUserCodeButtonView.h
//  ProjectCSHB
//
//  Created by Tom on 2020/5/21.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FYUserCodeButtonView : UIView

@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) void(^doUserCodeActionBlock)(void);

- (instancetype)initWithFrame:(CGRect)frame username:(NSString *)username;

+ (CGFloat)heightOfUserCodeView;
+ (CGFloat)heightOfUserCodeViewButton;
+ (CGFloat)heightOfUserCodeViewSpline;

@end

NS_ASSUME_NONNULL_END
