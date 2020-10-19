//
//  FYBaseCoreViewController.h
//  ProjectCSHB
//
//  Created by fangyuan on 2020/5/22.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "CFCNavBarViewController.h"
@class BannerItem;

NS_ASSUME_NONNULL_BEGIN

@interface FYBaseCoreViewController : CFCNavBarViewController

@property (nonatomic, copy) void(^__nullable dismissCompleted)(id __nullable obj);

- (void)fromBannerPushToVCWithBannerItem:(BannerItem*)item isFromLaunchBanner:(BOOL)isFromLaunchBanner;

@end

NS_ASSUME_NONNULL_END
