//
//  FYGamesClassViewController.h
//  ProjectCSHB
//
//  Created by fangyuan on 2020/5/16.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "CFCBaseCoreViewController.h"
#import "ZJScrollPageViewDelegate.h"

NS_ASSUME_NONNULL_BEGIN

UIKIT_EXTERN NSString * const FYGamesClassParentTableViewDidLeaveFromTopNotification;

typedef NS_ENUM(NSInteger, FYGamesClassProtocolFuncType) {
    FYGamesClassProtocolFuncTypeTableEndRefresh, // 结束刷新
};

@protocol FYGamesClassViewControllerDelegate <NSObject>
@optional
- (void)scrollViewIsScrolling:(UIScrollView *)scrollView;
///
- (void)doAnyThingForGamesClassSuperViewController:(FYGamesClassProtocolFuncType)type;
/// 大厅模式二
- (void)doSaveClassMenuSelectedIndexToGamesMainVC:(NSString *)type selectedMenuId:(NSNumber *)menuId;
@end

@interface FYGamesClassViewController : CFCBaseCoreViewController <ZJScrollPageViewChildVcDelegate>
@property (nonatomic, weak) id<FYGamesClassViewControllerDelegate> delegate;
@property (nonatomic, strong) UIScrollView *scrollView;
- (void)resetSubScrollViewSize:(CGSize)size;
@end

NS_ASSUME_NONNULL_END
