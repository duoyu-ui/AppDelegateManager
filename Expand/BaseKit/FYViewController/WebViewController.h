//
//  WebViewController.h
//  Project
//
//  Created by mini on 2018/8/14.
//  Copyright © 2018年 CDJay. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
#import "WebProgressView.h"
#import "FYAssistiveTouchButton.h"
#import "FYWKWebErrorView.h"
#import "FYWKWebView.h"

@interface WebViewController : SuperViewController

@property (nonatomic, assign) BOOL isNavBarHidden; // 是否隐藏导航条（默认NO显示）

@property (nonatomic, assign) BOOL isStatusBarHidden; // 是否隐藏状态栏（默认NO显示）

@property (nonatomic, assign) BOOL isAutoLayoutSafeArea; // 是否自动适配安全区域（iOS11安全区域），默认不适配，全屏显示

@property (nonatomic, assign) BOOL isForceEscapeWebVC; // 是否直接退出网页

@property (nonatomic, assign) NSInteger gameType; // 游戏类型（1：王者棋牌，2：幸运棋牌，3：QG棋牌，4：开元棋牌，5：双赢彩票，6：IM电竞，7：IM体育，8：AG真人，9：AG电子，10：AG捕鱼，11：KG电子）

@property (nonatomic, copy) NSString *url;  // 加载的url

@property (nonatomic, copy) NSString *userid;

@property (nonatomic, strong) FYWKWebView *webView;

@property (nonatomic, strong) FYWKWebErrorView *webErrorView;

@property (nonatomic, strong) FYAssistiveTouchButton *touchButton;

@property (nonatomic, strong) NSArray<NSString *> *touchButtonImages;

@property (nonatomic, strong) DGActivityIndicatorView *activityIndicatorView;

- (void)actionBlock:(DataBlock)block;

- (instancetype)initWithUrl:(NSString *)url;

- (instancetype)initWithHtmlString:(NSString *)string;

/**
 * 加载棋牌游戏
 * @param url 游戏网址
 * @param gameType 游戏类型（1：王者棋牌，2：幸运棋牌，3：QG棋牌，4：开元棋牌，5：双赢彩票，6：IM电竞，7：IM体育，8：AG真人，9：AG电子，10：AG捕鱼，11：KG电子）
 * @return 棋牌游戏
 */
- (instancetype)initWithUrl:(NSString *)url gameType:(NSInteger)gameType;

- (instancetype)initWithUrl:(NSString *)url withBodyDictionary:(NSDictionary *)params;


@end

