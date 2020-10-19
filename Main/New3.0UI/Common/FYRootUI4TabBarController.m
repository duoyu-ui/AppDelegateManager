//
//  FYRootUI4TabBarController.m
//  ProjectCSHB
//
//  Created by fangyuan on 2020/5/14.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "FYRootUI4TabBarController.h"
#import "FYMessageMainViewController.h"
#import "FYContactMainViewController.h"
#import "FYGamesMain1ViewController.h"
#import "FYGamesMain2ViewController.h"
#import "FYRechargeMainViewController.h"
#import "FYCenterMainViewController.h"
@interface FYRootUI4TabBarController ()

@end

@implementation FYRootUI4TabBarController


#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (self.viewControllers.count > TABBAR_INDEX_GAMEHALL) {
        [self setSelectedIndex:TABBAR_INDEX_GAMEHALL];
    }
    
    // 设置 tabbar 顶部 Line 阴影
    {
        // 移除线条
        [self.tabBar setBackgroundImage:[UIImage new]];
        [self.tabBar setShadowImage:[UIImage new]];
        // 添加阴影
        [self.tabBar.layer setShadowColor:COLOR_RGB(217, 217, 217).CGColor];
        [self.tabBar.layer setShadowOffset:CGSizeMake(0, -3)];
        [self.tabBar.layer setShadowOpacity:0.4f];
    }

    // 角标背景色
    [self.tabBar setBadgeBackgroundColor:COLOR_RGB(203, 51, 45)];
    
    // 加载系统消息
    [FYMSG_PRECISION_MANAGER doTryInitializeUnReadMessageThen:^{
        [self doTryRefreshTabbarBadgeValue]; // 刷新显示 tabbar 角标
    }];
    
    // 添加通知监听
    [self addNotifications];
}

- (void)addChildControllers
{
    // 消息
    [self addChildNavigationController:[CFCNavigationController class]
                    rootViewController:[FYMessageMainViewController class]
                       navigationTitle:STR_NAVIGATION_BAR_TITLE_MESSAGE
                       tabBarItemTitle:NSLocalizedString(@"消息", nil)
                 tabBarNormalImageName:ICON_TAB_BAR_ITEM_MESSAGE_NORMAL
                 tabBarSelectImageName:ICON_TAB_BAR_ITEM_MESSAGE_SELECT
                     tabBarItemEnabled:YES];
    
    // 充值
    [self addChildNavigationController:[CFCNavigationController class]
                    rootViewController:[FYRechargeMainViewController class]
                       navigationTitle:STR_NAVIGATION_BAR_TITLE_RECHARGE
                       tabBarItemTitle:NSLocalizedString(@"充值", nil)
                 tabBarNormalImageName:ICON_TAB_BAR_ITEM_RECHARGE_NORMAL
                 tabBarSelectImageName:ICON_TAB_BAR_ITEM_RECHARGE_SELECT
                     tabBarItemEnabled:YES];

    // 游戏大厅
    if (FYGameAppConfigStyleMode1 == [APPINFORMATION getGameAppConfigStyle]) {
        [self addChildNavigationController:[CFCNavigationController class]
                        rootViewController:[FYGamesMain1ViewController class]
                           navigationTitle:STR_NAVIGATION_BAR_TITLE_GAMES
                           tabBarItemTitle:NSLocalizedString(@"游戏大厅", nil)
                     tabBarNormalImageName:ICON_TAB_BAR_ITEM_GAMES_NORMAL
                     tabBarSelectImageName:ICON_TAB_BAR_ITEM_GAMES_SELECT
                         tabBarItemEnabled:YES];
    } else {
        [self addChildNavigationController:[CFCNavigationController class]
                        rootViewController:[FYGamesMain2ViewController class]
                           navigationTitle:STR_NAVIGATION_BAR_TITLE_GAMES
                           tabBarItemTitle:NSLocalizedString(@"游戏大厅", nil)
                     tabBarNormalImageName:ICON_TAB_BAR_ITEM_GAMES_NORMAL
                     tabBarSelectImageName:ICON_TAB_BAR_ITEM_GAMES_SELECT
                         tabBarItemEnabled:YES];
    }
    // 通讯录
    [self addChildNavigationController:[CFCNavigationController class]
                    rootViewController:[FYContactMainViewController class]
                       navigationTitle:STR_NAVIGATION_BAR_TITLE_CONTACT
                       tabBarItemTitle:NSLocalizedString(@"通讯录", nil)
                 tabBarNormalImageName:ICON_TAB_BAR_ITEM_CONTACT_NORMAL
                 tabBarSelectImageName:ICON_TAB_BAR_ITEM_CONTACT_SELECT
                     tabBarItemEnabled:YES];
    // 个人
    [self addChildNavigationController:[CFCNavigationController class]
                    rootViewController:[FYCenterMainViewController class]
                       navigationTitle:STR_NAVIGATION_BAR_TITLE_CENTER
                       tabBarItemTitle:NSLocalizedString(@"我的", nil)
                 tabBarNormalImageName:ICON_TAB_BAR_ITEM_CENTER_NORMAL
                 tabBarSelectImageName:ICON_TAB_BAR_ITEM_CENTER_SELECT
                     tabBarItemEnabled:YES];
}


#pragma mark - UITabBarControllerDelegate

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    return YES;
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    FYLog(@"%@", viewController.title);
}


#pragma mark - Notification

- (void)addNotifications
{
    // 后台 - 未读取消息数有变更
    [NOTIF_CENTER addObserver:self selector:@selector(doNotifiUnreadMsgNumberChange:) name:kNotificationMsgUnreadMessageNumberChange object:nil];
    
    // 后台 - 通讯录新好友申请
    [NOTIF_CENTER addObserver:self selector:@selector(doNotifiNewFriendInvitation:) name:kNotificationNewFriendInvitation object:nil];
}

/// 后台 - 未读取消息数有变更
- (void)doNotifiUnreadMsgNumberChange:(NSNotification *)notification
{
    [self doTryRefreshTabbarBadgeValue];
}

/// 后台 - 通讯录新好友申请
- (void)doNotifiNewFriendInvitation:(NSNotification *)notification
{
    [self doTryRefreshTabbarBadgeValue];
}

- (void)removeObservers
{
    [NOTIF_CENTER removeObserver:self];
}

- (void)dealloc
{
    [self removeObservers];
}


#pragma mark - Private

/// 刷新底部角标数字值
- (void)doTryRefreshTabbarBadgeValue
{
    // 设置角标 - 未读消息
    if ([[IMMessageModule sharedInstance] allUnreadMesagges] > 0) {
        NSInteger allUnredMessage = [[IMMessageModule sharedInstance] allUnreadMesagges];
        dispatch_main_async_safe(^{
            [self.tabBar setBadgeNumberValue:allUnredMessage atIndex:TABBAR_INDEX_MESSAGE];
        });
    } else {
        dispatch_main_async_safe(^{
            [self.tabBar setBadgeNumberValue:0 atIndex:TABBAR_INDEX_MESSAGE];
        });
    }
    
    // 设置角标 - 通讯录
    if ([[IMContactsModule sharedInstance] allVerifyEntities].count > 0) {
        NSInteger allVerifyEntities = [[IMContactsModule sharedInstance] allVerifyEntities].count;
        dispatch_main_async_safe(^{
            [self.tabBar setBadgeNumberValue:allVerifyEntities atIndex:TABBAR_INDEX_CONTACTS];
        });
    } else {
        dispatch_main_async_safe(^{
            [self.tabBar setBadgeNumberValue:0 atIndex:TABBAR_INDEX_CONTACTS];
        });
    }
}


@end

