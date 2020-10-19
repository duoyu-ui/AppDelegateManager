//
//  FYGamesMode2ClassViewController.h
//  ProjectCSHB
//
//  Created by fangyuan on 2020/5/16.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "FYGamesClassViewController.h"
@class FYGamesTypesModel;

NS_ASSUME_NONNULL_BEGIN

@interface FYGamesMode2ClassViewController : FYGamesClassViewController

@property (nonatomic, assign) BOOL isShowLoadingHUD;
@property (nonatomic, assign) RequestType requestMethod;
@property (nonatomic, strong) NSString *showLoadingMessage;
@property (nonatomic, assign) BOOL isEmptyDataSetShouldDisplay;
@property (nonatomic, assign) BOOL isEmptyDataSetShouldAllowScroll;
@property (nonatomic, assign) BOOL isEmptyDataSetShouldAllowImageViewAnimate;

- (instancetype)initWithGamesTypeModel:(FYGamesTypesModel *)gamesTypeModel selectedMenuId:(NSNumber *)selectedMenuId delegate:(id<FYGamesClassViewControllerDelegate>)delegate;

@end

NS_ASSUME_NONNULL_END
