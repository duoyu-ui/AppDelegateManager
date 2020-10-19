//
//  FYIndexViewHeaderView.h
//  ProjectCSHB
//
//  Created by fangyuan on 2020/6/15.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FYIndexViewHeaderView : UITableViewHeaderFooterView

+ (CGFloat)headerViewHeight;
+ (NSString *)reuseID;

- (void)configWithTitle:(NSString *)title;

@end

NS_ASSUME_NONNULL_END
