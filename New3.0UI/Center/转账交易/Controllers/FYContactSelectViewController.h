//
//  FYContactSelectViewController.h
//  ProjectCSHB
//
//  Created by Tom on 2020/5/28.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "CFCTableRefreshViewController.h"
#import "FYMobileContactInformation.h"

NS_ASSUME_NONNULL_BEGIN

@interface FYContactSelectViewController : CFCTableRefreshViewController

@property (nonatomic, copy) void(^selectViewResult)(FYContactMainModel *model);

@end

NS_ASSUME_NONNULL_END
