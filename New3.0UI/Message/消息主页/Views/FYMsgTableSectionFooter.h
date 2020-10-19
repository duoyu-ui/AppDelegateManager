//
//  FYMsgTableSectionFooter.h
//  ProjectCSHB
//
//  Created by fangyuan on 2020/5/30.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FYMessageMainViewController;

NS_ASSUME_NONNULL_BEGIN

@interface FYMsgTableSectionFooter : UIView

- (instancetype)initWithFrame:(CGRect)frame
                        title:(NSString *)title
                 footerHeight:(CGFloat)footerHeight
         parentViewController:(FYMessageMainViewController *)parentViewController;

@end

NS_ASSUME_NONNULL_END
