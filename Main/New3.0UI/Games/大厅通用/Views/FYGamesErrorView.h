//
//  FYGamesErrorView.h
//  ProjectCSHB
//
//  Created by fangyuan on 2020/7/28.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^FYGamesErrorViewBlock)(void);

@interface FYGamesErrorView : UIView

@property (nonatomic, copy) FYGamesErrorViewBlock refreshBlock;

+ (instancetype)shareWKWebErrorView;

@end

NS_ASSUME_NONNULL_END
