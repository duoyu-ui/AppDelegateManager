//
//  FYGamesMode1HBGroupSubController.h
//  ProjectCSHB
//
//  Created by fangyuan on 2020/7/28.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "FYScrollPageViewController.h"

NS_ASSUME_NONNULL_BEGIN

@protocol FYGamesMode1HBGroupSubControllerDelegate <FYScrollPageViewControllerDelegate>
@optional
- (BOOL)doIsNeedRefreshFromSuperViewController;
@end


@interface FYGamesMode1HBGroupSubController : FYScrollPageViewController <FYGamesMode1HBGroupControllerProtocol>

- (instancetype)initWithTabTitleCode:(NSString *)tabTitleCode tabTypeModel:(FYGamesMode1ClassModel *)tabTypeModel;

@end

NS_ASSUME_NONNULL_END
