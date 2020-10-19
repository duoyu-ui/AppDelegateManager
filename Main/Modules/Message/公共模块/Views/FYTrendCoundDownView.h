//
//  FYTrendCoundDownView.h
//  ProjectCSHB
//
//  Created by fangyuan on 2020/7/25.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RobNiuNiuQunModel;

NS_ASSUME_NONNULL_BEGIN

@interface FYTrendCoundDownView : UIView

@property (nonatomic, strong) RobNiuNiuQunModel *modelOfRobNiuNiu;

- (void)startTimer;

- (void)stopTimer;

@end

NS_ASSUME_NONNULL_END
