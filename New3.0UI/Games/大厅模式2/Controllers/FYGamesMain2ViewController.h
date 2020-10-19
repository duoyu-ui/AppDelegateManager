//
//  FYGamesMain2ViewController.h
//  ProjectCSHB
//
//  Created by fangyuan on 2020/5/16.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "FYGamesBaseViewController.h"
@class FYGamesTypesModel;

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, FYGamesMain2ProtocolFuncType) {
    FYGamesMain2ProtocolFuncTypeRefreshContent, // 刷新游戏数据
};

@protocol FYGamesMain2ViewControllerProtocol <FYGamesBaseViewControllerProtocol>
@optional
- (void)doReloadForMode2ClassGamesTypeModel:(FYGamesTypesModel *)gamesTypesModel;
- (void)doAnyThingForMode2ClassViewController:(FYGamesMain2ProtocolFuncType)type;
- (void)doRefreshForMode2ClassContentTableScrollToTopAnimated:(BOOL)animated;
@end

@interface FYGamesMain2ViewController : FYGamesBaseViewController

@property (nonatomic, weak) id<FYGamesMain2ViewControllerProtocol> delegate_subclass;

@end

NS_ASSUME_NONNULL_END
