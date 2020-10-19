//
//  FYGamesMode1QPGroupController.h
//  ProjectCSHB
//
//  Created by fangyuan on 2020/7/31.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "CFCBaseCoreViewController.h"
@class FYGamesMode1TypesModel, FYGamesMode1ClassModel;

NS_ASSUME_NONNULL_BEGIN

@protocol FYGamesMode1QPGroupControllerProtocol <NSObject>
@optional
- (void)doRefreshForQPGroupSubController:(NSString *)tabTitleCode;
- (void)doRefreshForQPGroupSubContentTableScrollToTopAnimated:(BOOL)animated;

@end

@interface FYGamesMode1QPGroupController : CFCBaseCoreViewController

@property (nonatomic, weak) id<FYGamesMode1QPGroupControllerProtocol> delegate_subclass;

- (instancetype)initWithGroupDataSource:(NSMutableArray<FYGamesMode1ClassModel *> *)groupDataSource selectedGroupModel:(FYGamesMode1ClassModel *)selectedGroupModel gamesTypesModel:(FYGamesMode1TypesModel *)gamesTypesModel;

/// 头部高度
+ (CGFloat)heightOfHeaderSpline;
+ (CGFloat)heightOfHeaderSegment;

@end

NS_ASSUME_NONNULL_END
