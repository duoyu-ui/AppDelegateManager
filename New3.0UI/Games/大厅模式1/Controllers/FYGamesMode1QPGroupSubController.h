//
//  FYGamesMode1QPGroupSubController.h
//  ProjectCSHB
//
//  Created by fangyuan on 2020/7/31.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "FYScrollPageViewController.h"

NS_ASSUME_NONNULL_BEGIN

@protocol FYGamesMode1QPGroupSubControllerDelegate <FYScrollPageViewControllerDelegate>
@optional
- (BOOL)doIsNeedRefreshFromSuperViewController;
@end


@interface FYGamesMode1QPGroupSubController : FYScrollPageViewController <FYGamesMode1QPGroupControllerProtocol>

- (instancetype)initWithTabTitleCode:(NSString *)tabTitleCode tabTypeModel:(FYGamesMode1ClassModel *)tabTypeModel;

@end

NS_ASSUME_NONNULL_END
