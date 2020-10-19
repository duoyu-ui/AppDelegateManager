//
//  FYGamesMode1ClassViewController.h
//  ProjectCSHB
//
//  Created by fangyuan on 2020/7/27.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "FYGamesClassViewController.h"
#import "CFCCollectionRefreshViewController.h"
#import "CFCCollectionRefreshViewWaterFallLayout.h"
@class FYGamesMode1TypesModel;

NS_ASSUME_NONNULL_BEGIN

@interface FYGamesMode1ClassViewController : FYGamesClassViewController <UICollectionViewDelegateFlowLayout, CFCCollectionRefreshViewWaterFallLayoutDelegate>

@property (nonatomic, assign) BOOL isEmptyDataSetShouldDisplay;
@property (nonatomic, assign) BOOL isEmptyDataSetShouldAllowScroll;
@property (nonatomic, assign) BOOL isEmptyDataSetShouldAllowImageViewAnimate;

- (instancetype)initWithGamesTypeModel:(FYGamesMode1TypesModel *)gamesTypeModel delegate:(id<FYGamesClassViewControllerDelegate>)delegate;

@end

NS_ASSUME_NONNULL_END
