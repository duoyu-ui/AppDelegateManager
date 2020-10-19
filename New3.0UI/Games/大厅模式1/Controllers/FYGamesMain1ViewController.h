//
//  FYGamesMain1ViewController.h
//  ProjectCSHB
//
//  Created by fangyuan on 2020/7/27.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "FYGamesBaseViewController.h"
@class FYGamesMode1TypesModel;

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, FYGamesMain1ProtocolFuncType) {
    FYGamesMain1ProtocolFuncTypeRefreshContent, // 刷新游戏数据
};

@protocol FYGamesMain1ViewControllerProtocol <FYGamesBaseViewControllerProtocol>
@optional
- (void)doReloadForMode1ClassGamesTypeModel:(FYGamesMode1TypesModel *)gamesTypeModel;
- (void)doAnyThingForMode1ClassViewController:(FYGamesMain1ProtocolFuncType)type;
- (void)doRefreshForMode1ClassContentTableScrollToTopAnimated:(BOOL)animated;
@end

@interface FYGamesMain1ViewController : FYGamesBaseViewController

@property (nonatomic, weak) id<FYGamesMain1ViewControllerProtocol> delegate_subclass;

@end

NS_ASSUME_NONNULL_END
