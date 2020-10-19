//
//  FYSearchBarView.h
//  ProjectCSHB
//
//  Created by fangyuan on 2020/7/8.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FYSearchBarView : UIView

@property (nonatomic, copy) NSString *searchPlaceholder;
@property (nonatomic, copy) void(^searchActionBlock)(void);

- (instancetype)initWithFrame:(CGRect)frame searchPlaceholder:(NSString *)searchPlaceholder;

+ (CGFloat)heightOfSearchBar;
+ (CGFloat)heightOfSearchBarButton;
+ (CGFloat)heightOfSearchBarSpline;

@end

NS_ASSUME_NONNULL_END
