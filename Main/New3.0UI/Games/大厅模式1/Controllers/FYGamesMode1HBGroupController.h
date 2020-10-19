//
//  FYGamesMode1HBGroupController.h
//  ProjectCSHB
//
//  Created by fangyuan on 2020/7/28.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "CFCBaseCoreViewController.h"
@class FYGamesMode1TypesModel, FYGamesMode1ClassModel;

NS_ASSUME_NONNULL_BEGIN

@protocol FYGamesMode1HBGroupControllerProtocol <NSObject>
@optional
- (void)doRefreshForHBGroupSubController:(NSString *)tabTitleCode;
- (void)doRefreshForHBGroupSubContentTableScrollToTopAnimated:(BOOL)animated;

@end

@interface FYGamesMode1HBGroupController : CFCBaseCoreViewController

@property (nonatomic, weak) id<FYGamesMode1HBGroupControllerProtocol> delegate_subclass;

- (instancetype)initWithGroupDataSource:(NSMutableArray<FYGamesMode1ClassModel *> *)groupDataSource selectedGroupModel:(FYGamesMode1ClassModel *)selectedGroupModel gamesTypesModel:(FYGamesMode1TypesModel *)gamesTypesModel;

/// 头部高度
+ (CGFloat)heightOfHeaderSpline;
+ (CGFloat)heightOfHeaderSegment;

@end

NS_ASSUME_NONNULL_END
