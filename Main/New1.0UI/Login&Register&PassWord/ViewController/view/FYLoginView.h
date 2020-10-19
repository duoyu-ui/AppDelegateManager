//
//  FYLoginView.h
//  ProjectCSHB
//
//  Created by Tom on 2020/1/14.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^clickEvent)(void);
@interface FYLoginView : UIView
- (void)setImg:(UIImage *)img title:(NSString *)title;
@property (nonatomic ,copy)clickEvent block;
@end

NS_ASSUME_NONNULL_END
