//
//  FYWebViewController.m
//  Project
//
//  Created by mini on 2018/8/14.
//  Copyright © 2018年 CDJay. All rights reserved.
//

#import "FYWebViewController.h"

@implementation FYWebViewController

#pragma mark - Actions

- (void)pressNavBarButtonActionNavBack:(id)sender
{
    if (self.webView.canGoBack) {
        [self.webView goBack];
    }  else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)pressNavBarButtonActionClose:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - Life Cycle

- (instancetype)initWithUrl:(NSString *)url gameType:(NSInteger)gameType
{
    self = [super initWithUrl:url gameType:gameType];
    if (self) {
        [self defaultSetting];
    }
    return self;
}

- (void)defaultSetting
{
    _isShowCloseButton = NO;
    
    // 1：自己游戏（QG电子）
    if (self.gameType == FYWebGameSelfDianZiType) {
        // 全屏显示（隐藏导航条、隐藏状态栏）
        [self setIsNavBarHidden:YES];
        [self setIsStatusBarHidden:YES];
        [self setIsAutoLayoutSafeArea:NO];
    }
    // 2：三方游戏（1：王者棋牌，2：幸运棋牌，3：QG棋牌，4：开元棋牌，5：双赢彩票，6：IM电竞，7：IM体育，8：AG真人，9：AG电子，10：AG捕鱼，11：KG电子）
    else {
        if (FYWebGameShuangYingCaiPiaoType == self.gameType) { // 5：双赢彩票
            // 全屏显示（隐藏导航条、显示状态栏）
            [self setIsNavBarHidden:YES];
            [self setIsStatusBarHidden:NO];
            [self setIsAutoLayoutSafeArea:YES];
        } else {
            // 全屏显示（隐藏导航条、隐藏状态栏）
            [self setIsNavBarHidden:YES];
            [self setIsStatusBarHidden:YES];
            [self setIsAutoLayoutSafeArea:NO];
        }
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CGFloat navWidth = CFC_AUTOSIZING_WIDTH(NAVIGATION_BAR_BUTTON_MAX_WIDTH);
    UIView *navBarItemView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, navWidth, NAVIGATION_BAR_HEIGHT)];
    
    // 返回
    UIFont *titleFont = [self prefersNavigationBarRightButtonItemTitleFont];
    UIColor *titleNormalColor = [self prefersNavigationBarRightButtonItemTitleColorNormal];
    UIColor *titleSelectColor = [self prefersNavigationBarRightButtonItemTitleColorSelect];
    NSString *iconNameNormal = ICON_NAVIGATION_BAR_BUTTON_BLACK_ARROW;
    NSString *iconNameSelect = ICON_NAVIGATION_BAR_BUTTON_BLACK_ARROW;
    UIButton *button = (UIButton *)[self createNavigationBarButtonItemTypeDefaultTitle:@""
                                                                             titleFont:titleFont
                                                                      titleNormalColor:titleNormalColor
                                                                      titleSelectColor:titleSelectColor
                                                                        iconNameNormal:iconNameNormal
                                                                        iconNameSelect:iconNameSelect
                                                                                action:@selector(pressNavBarButtonActionNavBack:)
                                                                                target:self];
    [navBarItemView addSubview:button];
    [button setFrame:CGRectMake(0, 0, navWidth, NAVIGATION_BAR_HEIGHT)];
    
    // 关闭
    if (self.isShowCloseButton) {
        [navBarItemView setFrame:CGRectMake(0, 0, navWidth*1.7f, NAVIGATION_BAR_HEIGHT)];
        [button setFrame:CGRectMake(0, 0, navWidth*0.7f, NAVIGATION_BAR_HEIGHT)];
        UIButton *button1 = [self createButtonWithImage:ICON_NAVIGATION_BAR_BUTTON_CLOSE_BLACK
                                                target:self
                                                action:@selector(pressNavBarButtonActionClose:)
                                            offsetType:CFCNavBarButtonOffsetTypeLeft
                                             imageSize:NAVIGATION_BAR_BUTTON_IMAGE_SIZE*0.68f];
        [navBarItemView addSubview:button1];
        [button1 setFrame:CGRectMake(navWidth*0.7, 0, navWidth, NAVIGATION_BAR_HEIGHT)];
    }
    
    //
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:navBarItemView];
}


#pragma mark - Navigation

- (UIStatusBarStyle)preferredStatusBarStyle
{
    if (self.gameType == FYWebGameSelfDianZiType) {
        // 1：自己游戏（QG电子）
        return UIStatusBarStyleDefault;
    } else if (self.gameType >= 1) {
        // 2：三方游戏（1：王者棋牌，2：幸运棋牌，3：QG棋牌，4：开元棋牌，5：双赢彩票，6：IM电竞，7：IM体育，8：AG真人，9：AG电子，10：AG捕鱼，11：KG电子）
        if (FYWebGameShuangYingCaiPiaoType == self.gameType) { // 5：双赢彩票
            return UIStatusBarStyleLightContent;
        } else {
            return UIStatusBarStyleDefault;
        }
    }
    
    return UIStatusBarStyleDefault;
}



@end



