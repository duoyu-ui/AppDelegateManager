//
//  FYWKWebErrorView.h
//  ProjectCSHB
//
//  Created by fangyuan on 2020/6/30.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^FKWKWebErrorViewBlock)(void);

@interface FYWKWebErrorView : UIView

@property (nonatomic, copy) FKWKWebErrorViewBlock refreshBlock;

+ (instancetype)shareWKWebErrorView;

@end

NS_ASSUME_NONNULL_END
