//
//  FYLaunchFristPageCell.h
//  ProjectCSHB
//
//  Created by Tom on 2020/1/14.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class FYLaunchPageModel;
@interface FYLaunchFristPageCell : UITableViewCell
//@property (nonatomic ,copy)NSString *title;
@property (nonatomic ,strong)FYLaunchPageModel *model;
@end

NS_ASSUME_NONNULL_END
