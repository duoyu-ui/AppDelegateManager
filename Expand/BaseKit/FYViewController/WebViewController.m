//
//  WebViewController.m
//  Project
//
//  Created by mini on 2018/8/14.
//  Copyright © 2018年 CDJay. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController () <WKUIDelegate, WKNavigationDelegate, WKScriptMessageHandler, UINavigationBarDelegate, FYAssistiveTouchButtonDelegate>

@property (nonatomic, copy) ActionBlock block;

@property (nonatomic, strong) UIButton *buttonFloatQuit;

@property (nonatomic, strong) WebProgressView *progress;

@property (nonatomic, strong) NSString *htmlString;

@property (nonatomic, strong) NSDictionary *params;

@property (nonatomic, strong) UIColor *navStatusBarColor; // 状态栏颜色

@property (nonatomic, assign) BOOL isLoadFinishOnce; // 是否已经完成一次

@property (nonatomic, assign) NSInteger requestReloadCount; // 加载失败，重新刷新加载次数，大于2次退出

@end

@implementation WebViewController

#pragma mark - Action

/// 打开 Safari 浏览器
- (void)pressOpenSafariAction
{
    if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:_url]]){
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:_url]];
    }
}

/// 返回退出游戏事件
- (void)pressQuitExitAction
{
    // 删除加载菊花动画
    [self setActivityStopAnimating];
    [self setRequestReloadCount:INTMAX_MAX];
    
    // 验证是否为三方游戏（三方游戏 gameType 大于等于1）
    if (self.gameType >= 1) {
        WEAKSELF(weakSelf)
        
        NSString *userId = self.userid;
        if (userId == nil) {
            userId = @"";
        }

        PROGRESS_HUD_SHOW
        [NET_REQUEST_MANAGER requestGamesThirdPartyLogoutWithParameters:@{ @"userId" : userId } gameType:self.gameType success:^(id response) {
            PROGRESS_HUD_DISMISS
            FYLog(NSLocalizedString(@"三方游戏退出 => \n%@", nil), response);
            if ([self isCanPopViewController:response]) {
                [weakSelf popViewController];
            }
        } failure:^(id error) {
            PROGRESS_HUD_DISMISS
            FYLog(NSLocalizedString(@"三方游戏退出异常 => \n%@", nil), [error mj_JSONString]);
            if ([self isCanPopViewController:error]) {
                [weakSelf popViewController];
            }
        }];
    } else {
        // 一般网址浏览，不需要调用退出接口，直接退出
        [self popViewController];
    }
}

/// 点击刷新网址
- (void)pressWebRefreshAction
{
    // 删除错误提示页面
    [self setDeleteWKWebErrorView];
    // 显示加载动画菊花
    [self setActivityStartAnimating];
    
    // 重新加载请求
    [self setRequestReloadCount:0];
    [self requestURL];
}

- (BOOL)isCanPopViewController:(id)object
{
    // 游戏未结束，请勿退出；正在游戏中，不允许退出
    NSDictionary *dict =(NSDictionary *)object;
    NSString *msg = [dict stringForKey:NET_REQUEST_KEY_MESS_ALTER];
    if ([msg containsString:NSLocalizedString(@"退出", nil)]) { // 游戏中，只能弹提示，不能关闭
        ALTER_INFO_MESSAGE(msg)
        return NO;
    }
    return YES;
}

- (void)popViewController
{
    // 辅助按钮复位
    /*
    {
        APPUSERDEFAULTS.touchButtonOriginX = [NSNumber numberWithFloat:SCREEN_MIN_LENGTH-FULL_SUSPEND_BALL_SIZE];
        APPUSERDEFAULTS.touchButtonOriginY = [NSNumber numberWithFloat:STATUS_BAR_HEIGHT];
    }
    */
    //
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark -

/// 悬浮按钮 - 主页
- (void)pressTouchBtnHome
{
    [self requestURL];
}

/// 悬浮按钮 - 后退
- (void)pressTouchBtnGoBack
{
    if (self.webView.canGoBack) {
        [self.webView goBack];
    }  else {
        [self pressQuitExitAction];
    }
}

/// 悬浮按钮 - 前进
- (void)pressTouchBtnGoForward
{
    if ([self.webView canGoForward]) {
        [self.webView goForward];
    } else {
        [self.webView reload];
    }
}

/// 悬浮按钮 - 刷新
- (void)pressTouchBtnRefresh
{
    [self.webView reload];
}

/// 悬浮按钮 - 关闭
- (void)pressTouchBtnExit
{
    [self pressQuitExitAction];
}


#pragma mark -

- (void)removeAndBack
{
    if (self.isForceEscapeWebVC) {
        [self popViewController];
        if (self.block) {
            self.block(@1);
        }
    } else {
        if ([_webView canGoBack]) {
            [_webView goBack];
        } else {
            [self popViewController];
            if (self.block) {
                self.block(@1);
            }
        }
    }
}

- (void)actionBlock:(ActionBlock)block
{
    self.block = block;
}


#pragma mark - Life cycle

- (instancetype)initWithUrl:(NSString *)url
{
    self = [super init];
    if (self) {
        _url = url;
        [self defaultInitSetting];
    }
    return self;
}

- (instancetype)initWithUrl:(NSString *)url gameType:(NSInteger)gameType {
    self = [super init];
    if (self) {
        _url = url;
        _gameType = gameType;
        [self defaultInitSetting];
    }
    return self;
}

- (instancetype)initWithUrl:(NSString *)url withBodyDictionary:(NSDictionary*)params{
    self = [super init];
    if (self) {
        _url = url;
        _params = params;
        [self defaultInitSetting];
    }
    return self;
}

- (instancetype)initWithHtmlString:(NSString *)string
{
    self = [super init];
    if (self) {
        _htmlString = string;
        [self defaultInitSetting];
    }
    return self;
}

- (void)defaultInitSetting
{
    _isLoadFinishOnce = NO;
    _requestReloadCount = 0;
    _navStatusBarColor = [self prefersStatusBarColor];
}

#pragma mark -

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setubSubViews];
    
    [self requestURL];
    
    [self setupBackPopGesture];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    // 调整适配悬浮按钮位置
    self.touchButton.x = APPUSERDEFAULTS.touchButtonOriginX.floatValue;
    self.touchButton.y = APPUSERDEFAULTS.touchButtonOriginY.floatValue;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // 设置导航条状态栏标签栏背景色
    [self setNaviStatusBarTabBarBackgroundColor];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    if (_progress) {
        [_progress removeFromSuperview];
    }
}

- (void)setubSubViews
{
    UIBarButtonItem *safariItem = [self createBarButtonItemWithImage:@"icon_safari"
                                                              action:@selector(pressOpenSafariAction)
                                                          offsetType:CFCNavBarButtonOffsetTypeRight];
    self.navigationItem.rightBarButtonItems = @[safariItem];
    
    WKWebViewConfiguration *wkConfiguration = [[WKWebViewConfiguration alloc] init];
    [wkConfiguration.userContentController addScriptMessageHandler:self name:@"exitGame"];
    
    // WebView
    _webView = [[FYWKWebView alloc] initWithFrame:self.view.bounds configuration:wkConfiguration];
    _webView.UIDelegate = self;
    _webView.navigationDelegate = self;
    _webView.allowsBackForwardNavigationGestures = NO; // 是否允许手势，后退前进等操作
    _webView.scrollView.bounces = YES; // 是否允许拖动效果
    _webView.backgroundColor = CDCOLOR(245, 245, 245);
    [self.view addSubview:_webView];
    
    // 内容显示适配
    if (@available(iOS 11.0, *)) {
        self.webView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        // Fallback on earlier versions
    }
    
    CGRect frame = self.navigationController.navigationBar.bounds;
    _progress = [[WebProgressView alloc] initWithFrame:CGRectMake(0, frame.size.height-2, frame.size.width, 2)];
    [_progress setProgressColor:COLOR_SYSTEM_MAIN_UI_THEME_DEFAULT];
    [self.navigationController.navigationBar addSubview:_progress];
    [_progress setProgress:0 animated:NO];
    
    // KVO 这里只是监听 title、estimatedProgress 属性，分别用于判断获取页面标题、当前页面载入进度
    [_webView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:nil];
    [_webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    
    // Layout
    if (CFC_IS_IPHONE_X_OR_GREATER) {
        if (self.isAutoLayoutSafeArea) {
            if (self.isNavBarHidden && !self.isStatusBarHidden) {
                [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.right.equalTo(self.view);
                    make.top.equalTo(self.view.mas_top).offset(STATUS_BAR_HEIGHT);
                    make.bottom.equalTo(self.view.mas_bottom).offset(-TAB_BAR_DANGER_HEIGHT);
                }];
            } else {
                [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.right.equalTo(self.view);
                    make.top.equalTo(self.view.mas_top);
                    make.bottom.equalTo(self.view.mas_bottom).offset(-TAB_BAR_DANGER_HEIGHT);
                }];
            }
        } else {
            if (self.isNavBarHidden && !self.isStatusBarHidden) {
                [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.right.bottom.equalTo(self.view);
                    make.top.equalTo(self.view.mas_top).offset(STATUS_BAR_HEIGHT);
                }];
            } else {
                [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.edges.equalTo(self.view);
                }];
            }
        }
    } else {
        if (self.isNavBarHidden && !self.isStatusBarHidden) {
            [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.bottom.equalTo(self.view);
                make.top.equalTo(self.view.mas_top).offset(STATUS_BAR_HEIGHT);
            }];
        } else {
            [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self.view);
            }];
        }
    }
    
    // Navbar  Hidden
    if (self.isNavBarHidden) {
#if 0
        [self setupQuitButton];
#else
        [self setupTouchButton];
#endif
    }
    
    // ShowProgessHUD
    [self setActivityStartAnimating];
}

- (void)setupQuitButton
{    
    UIButton *buttonFloatQuit = [UIButton buttonWithType:UIButtonTypeCustom];
    [buttonFloatQuit addTarget:self action:@selector(pressQuitExitAction) forControlEvents:UIControlEventTouchUpInside];
    [buttonFloatQuit setBackgroundImage:[UIImage imageNamed:@"suspension_icon"] forState:UIControlStateNormal];
    [buttonFloatQuit setClipsToBounds:YES];
    [buttonFloatQuit setAlpha:0.8];
    [buttonFloatQuit setTag:10086];
    [self.view addSubview:buttonFloatQuit];
    [self setButtonFloatQuit:buttonFloatQuit];
    [buttonFloatQuit mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).offset(-30);
        make.top.mas_equalTo(STATUS_BAR_HEIGHT+30);
        make.width.height.mas_equalTo(50);
    }];
    
    if (FYWebGameQGQiPaiType == self.gameType) {
        [buttonFloatQuit setHidden:YES];
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [buttonFloatQuit setAlpha:0.3];
    });
    
    // 添加移动的手势
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(quitFloatButtonMovePanGesture:)];
    [buttonFloatQuit addGestureRecognizer:pan];
}

- (void)setupTouchButton
{
    // 辅助悬浮按钮
    {
        CGFloat touchBtnsize = FULL_SUSPEND_BALL_SIZE;
        CGRect frame = CGRectMake(APPUSERDEFAULTS.touchButtonOriginX.floatValue,
                                  APPUSERDEFAULTS.touchButtonOriginY.floatValue,
                                  touchBtnsize,
                                  touchBtnsize);
        FYAssistiveTouchButton *touchButton  = [[FYAssistiveTouchButton alloc] initWithFrame:frame];
        [self setTouchButton:touchButton];
        [self.view addSubview:touchButton];
        [self.view bringSubviewToFront:touchButton];
        
        [touchButton setDelegate:self];
        [touchButton setImages:self.touchButtonImages];
        [touchButton setRadius:touchBtnsize/2.0f];
        [touchButton setCanClickTempOn:YES]; // 开启背景遮幕
        [touchButton setWannaToClickTempDismiss:YES]; // 点击屏幕消失，需要设置canClickTempOn
        [touchButton setSpreadButtonOpenViscousity:YES]; // 开启粘滞功能
        [touchButton setWannaToScaleSpreadButtonEffect:NO];
        [touchButton setAutoAdjustToFitSubItemsPosition:YES];
        [touchButton setNormalImage:[UIImage imageNamed:ICON_WEB_VIEW_BUTTON_TOUCH_NORMAL]];
        [touchButton setSelectImage:[UIImage imageNamed:ICON_WEB_VIEW_BUTTON_TOUCH_SELECT]];
    }

    // 浏览器事件处理
    WEAKSELF(weakSelf)
    [self.webView setHitTestEventBlock:^{
        [weakSelf.touchButton hitTestWithEventToShrinkCloseHandle];
    }];
}

/// 三方游戏不能右滑返回，需要调用退出接口
- (void)setupBackPopGesture
{
    // 三方游戏（1：王者棋牌，2：幸运棋牌，3：QG棋牌，4：开元棋牌，5：双赢彩票 。。。）
    if (self.gameType >= 1) {
        [self setFd_interactivePopDisabled:YES];
        [self setFd_interactivePopMaxAllowedInitialDistanceToLeftEdge:FULLSCREEN_POP_GESTURE_MAX_DISTANCE_TO_LEFT_EDGE];
    }
}


#pragma mark - Request

- (void)requestURL
{
    if (_url.length) {
        [self loadUrl];
    }
    else if (_htmlString) {
        [self loadHtml];
    }
    else if (_url.length > 0 && _params) {
        [self postUrl];
    }
    
    [self requestTimeout];
}

- (void)requestTimeout
{
    // 设置加载完成一次为NO
    self.isLoadFinishOnce = NO;
    
    WEAKSELF(weakSelf)
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(NET_REQUEST_TIMEOUTINTERVAL * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (!weakSelf.isLoadFinishOnce) { // 是否加载完成，没有加载完成，重新加载
            if ([weakSelf isShowProgressHUD]) {
                [weakSelf.webView stopLoading];
                [weakSelf setActivityStopAnimating];
            }
            if (weakSelf.requestReloadCount < 1) {
                weakSelf.requestReloadCount += 1;
                [weakSelf requestURL];
            } else {
                [weakSelf setInsertWKWebErrorView];
            }
        }
    });
}

- (void)loadUrl
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:_url]];
//    [request setTimeoutInterval:NET_REQUEST_TIMEOUTINTERVAL];
    [self.webView loadRequest:request];
}

- (void)loadHtml
{
    [_webView loadHTMLString:_htmlString baseURL:nil];
}

- (void)postUrl
{
    NSURL *url = [NSURL URLWithString:_url];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url];
    [request setHTTPMethod:@"POST"];
    request.timeoutInterval = NET_REQUEST_TIMEOUTINTERVAL;
    
    NSData * bodyData = [NSJSONSerialization dataWithJSONObject:_params options:NSJSONWritingPrettyPrinted error:nil];
    [request setHTTPBody:bodyData];
    
    // 设置请求头
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:[AppModel shareInstance].userInfo.fullToken forHTTPHeaderField:@"Authorization"];
    [request setValue:GetUserDefaultWithKey(@"mobile") forHTTPHeaderField:@"userName"];
    [request setValue:[[FunctionManager sharedInstance] getApplicationVersion] forHTTPHeaderField:@"appVersion"];
    [request setValue:kNewTenant forHTTPHeaderField:@"tenant"];
    [request setValue:@"APP" forHTTPHeaderField:@"type"];
    [_webView loadRequest:request];
}



#pragma mark - <FYAssistiveTouchButtonDelegate>

- (void)touchButton:(FYAssistiveTouchButton *)touchButton didSelectedAtIndex:(NSUInteger)index withSelectedButton:(UIButton *)button
{
    if (self.touchButtonImages.count <= index) {
        return;
    }
    
    NSString *imageName = [self.touchButtonImages objectAtIndex:index];
    if ([ICON_WEB_VIEW_BUTTON_HOME isEqualToString:imageName]) {
        // 主页
        [self pressTouchBtnHome];
    } else if ([ICON_WEB_VIEW_BUTTON_REFRESH isEqualToString:imageName]) {
        // 刷新
        [self pressTouchBtnRefresh];
    } else if ([ICON_WEB_VIEW_BUTTON_RETURN_BACK isEqualToString:imageName]) {
        // 后退
        [self pressTouchBtnGoBack];
    } else if ([ICON_WEB_VIEW_BUTTON_EXIT isEqualToString:imageName]) {
        // 关闭
        [self pressTouchBtnExit];
    }
}


#pragma mark - <KVO>

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    if ([keyPath isEqualToString:@"title"]) {
        
        if (VALIDATE_STRING_EMPTY(self.title)) {
            NSString *title = self.webView.title;
            [self setTitle:title];
            [self setNavigationBarTitleViewTitle:title];
        }
        
    } else if ([keyPath isEqualToString:@"estimatedProgress"]) {
        
        [_progress setProgress:_webView.estimatedProgress animated:YES];
        
        if (_webView.estimatedProgress >= 1.0f) {
            /*
             * 添加一个简单的动画，将 progress 的 Height 变为 1.4 倍
             * 动画时长0.25s，延时0.3s后开始动画
             * 动画结束后将 progress 隐藏
             */
            __weak __typeof(&*self)weakSelf = self;
            [UIView animateWithDuration:0.25f delay:0.5f options:UIViewAnimationOptionCurveEaseOut animations:^{
                weakSelf.progress.transform = CGAffineTransformMakeScale(1.0f, 1.25f);
            } completion:^(BOOL finished) {
                // 动画结束后将progressView隐藏
                weakSelf.progress.hidden = YES;
                // 根据网页设置导航条状态栏标签栏背景色
                [weakSelf setNaviStatusBarTabBarBackgroundColor];
            }];
        }
        
    } else {
        
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        
    }
}

#pragma mark - <WKScriptMessageHandler>
/** web页回调处理  */
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message
{
    if ([message.name isEqualToString:@"exitGame"]) {
        [self pressQuitExitAction];
    }
}

#pragma mark - <WKNavigationDelegate>

// 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation
{
    FYLog(NSLocalizedString(@"开始加载网页[%@] => [第%ld次]", nil), self.title, self.requestReloadCount);
    
    // 开始加载网页时展示出progressView
    [self.progress setHidden:NO];
    // 开始加载网页时默认加载进度
    [self.progress setProgress:0.2f animated:YES];
    // 开始加载网页的时候将progressView的Height恢复为1.5倍
    [self.progress setTransform:CGAffineTransformMakeScale(1.0f, 1.5f)];
    // 防止progressView被网页挡住
    [self.navigationController.navigationBar bringSubviewToFront:self.progress];
    
    // 网页开始加载进度动画
    [self setActivityStartAnimating];
    
    // 删除错误提示页面
    [self setDeleteWKWebErrorView];
}

// 当内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation
{
    FYLog(NSLocalizedString(@"响应的内容到达主页面的时候响应，刚准备开始渲染页面应用[%@] => [第%ld次]", nil), self.title, self.requestReloadCount);
}

/// 网页内容被终止
- (void)webViewWebContentProcessDidTerminate:(WKWebView *)webView
{
    FYLog(NSLocalizedString(@"当WEB视图的网页内容被终止时调用[%@] => [第%ld次]", nil), self.title, self.requestReloadCount);
}

// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    FYLog(NSLocalizedString(@"网页加载完成[%@] => 加载状态[%d] => [第%ld次]", nil), self.title, !webView.isLoading, self.requestReloadCount);
    
    if (!webView.isLoading) {
        
        FYLog(NSLocalizedString(@"网页已经完全加载完成[%@] => 加载状态[%d] => [第%ld次]", nil), self.title, !webView.isLoading, self.requestReloadCount);
        
        // 加载完成一次（成功）
        self.isLoadFinishOnce = YES;
        
        // 加载完成删除加载动画
        [self setActivityStopAnimating];
        
        // 根据网页设置导航条状态栏标签栏背景色
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self setNaviStatusBarTabBarBackgroundColor];
        });
    }
}


// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error
{
    FYLog(NSLocalizedString(@"网页加载失败[%@] => [第%ld次] 失败原因\n%@", nil), self.title, self.requestReloadCount,error);
  
    self.navigationItem.title = NSLocalizedString(@"加载失败，请检查网络", nil);
    
    // 加载完成一次（成功）
    self.isLoadFinishOnce = YES;
    
    // 加载失败同样需要隐藏 progress
    [self.progress setHidden:YES];
    
    // 加载失败删除加载动画
    [self setActivityStopAnimating];
    
    // 加载失败显示错误信息
    [self setInsertWKWebErrorView];
}

/// 页面在跳转过程中出现错误
- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error
{
    FYLog(NSLocalizedString(@"当一个正在提交的页面在跳转过程中出现错误时调用这个方法[%@] => [第%ld次]", nil), self.title, self.requestReloadCount);
}

/// 接收到服务器跳转请求之后调用
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation
{
    FYLog(NSLocalizedString(@"重定向的时候，接收到服务器跳转请求之后[%@] => [第%ld次]", nil), self.title, self.requestReloadCount);
}

/// 在收到响应后，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler
{
    FYLog(NSLocalizedString(@"在收到响应后，决定是否跳转[%@] => [第%ld次]", nil), self.title, self.requestReloadCount);
    
    // 根据网页设置导航条状态栏标签栏背景色
    [self setNaviStatusBarTabBarBackgroundColor];
    
    decisionHandler(WKNavigationResponsePolicyAllow);
}
- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential *_Nullable))completionHandler
{
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
        if (challenge.previousFailureCount == 0) {
            NSURLCredential *credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
            completionHandler(NSURLSessionAuthChallengeUseCredential, credential);
        } else {
            completionHandler(NSURLSessionAuthChallengeCancelAuthenticationChallenge, nil);
        }
    }
}
/// 在发送请求之前，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
    FYLog(NSLocalizedString(@"在发送请求之前，决定是否跳转[%@] => [%@] => [第%ld次]", nil), self.title, navigationAction.request.URL, self.requestReloadCount);
    
    // ------  对alipays:相关的scheme处理 -------
    // 若遇到支付宝相关scheme，则跳转到本地支付宝App
    NSString *reqUrl = navigationAction.request.URL.absoluteString;
    
    if ([reqUrl hasPrefix:@"alipays://"] || [reqUrl hasPrefix:@"alipay://"]) {
        // 跳转支付宝App
        if (@available(iOS 10.0, *)) {
            [[UIApplication sharedApplication] openURL:navigationAction.request.URL options:@{} completionHandler:^(BOOL success) {
                if (!success) {
                    [self alertControllerWithMessage:NSLocalizedString(@"未检测到支付宝客户端，请您安装后重试。", nil)];
                }
            }];
        } else {
            // Fallback on earlier versions
            BOOL success = [[UIApplication sharedApplication]openURL:navigationAction.request.URL];
            if (!success) {
                [self alertControllerWithMessage:NSLocalizedString(@"未检测到支付宝客户端，请您安装后重试。", nil)];
            }
            
        }
        decisionHandler(WKNavigationActionPolicyCancel);
        return;
    }
    
    //跳转到微信
    if ([navigationAction.request.URL.scheme isEqualToString:@"weixin"]){
        if ([navigationAction.request.URL.host isEqualToString:@"wap"]) {
            if ([navigationAction.request.URL.relativePath isEqualToString:@"/pay"]) {
                if (@available(iOS 10.0, *)) {
                    [[UIApplication sharedApplication]openURL:navigationAction.request.URL options:@{} completionHandler:^(BOOL success) {
                        if (!success) {
                            SVP_ERROR_STATUS(NSLocalizedString(@"请先安装微信", nil));
                        }
                    }];
                } else {
                    BOOL success = [[UIApplication sharedApplication]openURL:navigationAction.request.URL];
                    if (!success) {
                        SVP_ERROR_STATUS(NSLocalizedString(@"请先安装微信", nil));
                    }
                }
            }
            
        }
        decisionHandler(WKNavigationActionPolicyCancel);
        return;
    }
    
    // 根据网页设置导航条状态栏标签栏背景色
    [self setNaviStatusBarTabBarBackgroundColor];
    
    // 确认可以跳转
    decisionHandler(WKNavigationActionPolicyAllow);
}

- (void)alertControllerWithMessage:(NSString *)message
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"温馨提示", nil) message:message preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"立即安装", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        // NOTE: 跳转itune下载支付宝App
        NSString *urlString = @"https://itunes.apple.com/cn/app/zhi-fu-bao-qian-bao-yu-e-bao/id333206289?mt=8";
        NSURL *downloadURL = [NSURL URLWithString:urlString];
        [[UIApplication sharedApplication] openURL:downloadURL];
    }]];
    
    [self presentViewController:alertController animated:YES completion:nil];
}


#pragma mark - WKUIDelegate

//// Alert弹窗
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:nil message:message ? : @"" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * action = [UIAlertAction actionWithTitle:NSLocalizedString(@"确认", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler();
    }];
    [alertController addAction:action];
    [self presentViewController:alertController animated:YES completion:nil];
}

//// Confirm弹框
- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL))completionHandler {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:message ? : @"" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"取消", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(NO);
    }];
    
    UIAlertAction * confirmAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"确认", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(YES);
    }];
    
    [alertController addAction:cancelAction];
    [alertController addAction:confirmAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

//// TextInput弹框
- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * _Nullable))completionHandler {
    
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:prompt message:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.text = defaultText;
    }];
    UIAlertAction * action = [UIAlertAction actionWithTitle:NSLocalizedString(@"完成", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(alertController.textFields[0].text ? : @"");
    }];
    [alertController addAction:action];
    
    [self presentViewController:alertController animated:YES completion:nil];
}


- (void)dealloc
{
    [_progress removeFromSuperview];
    [_webView removeObserver:self forKeyPath:@"estimatedProgress"];
}


#pragma mark - Navigation

- (BOOL)prefersStatusBarHidden
{
    if (self.isNavBarHidden) {
        return self.isStatusBarHidden;
    }
    return NO;
}

- (BOOL)prefersNavigationBarHidden
{
    return self.isNavBarHidden;
}


#pragma mark - Getter & Setter

- (NSArray<NSString *> *)touchButtonImages;
{
    if(!_touchButtonImages) {
        _touchButtonImages = @[
            ICON_WEB_VIEW_BUTTON_EXIT,
            ICON_WEB_VIEW_BUTTON_RETURN_BACK,
            ICON_WEB_VIEW_BUTTON_REFRESH,
            ICON_WEB_VIEW_BUTTON_HOME
        ];
    }
    return _touchButtonImages;
}

- (DGActivityIndicatorView *)activityIndicatorView
{
    if (!_activityIndicatorView) {
        CGFloat activityIndicatorSize = CFC_AUTOSIZING_WIDTH(60.0f);
        _activityIndicatorView = [[DGActivityIndicatorView alloc]
                                  initWithType:DGActivityIndicatorAnimationTypeBallSpinFadeLoader
                                  tintColor:COLOR_UIWEBVIEW_ACTIVITY_INDICATOR_BACKGROUND
                                  size:activityIndicatorSize];
        [self.view insertSubview:_activityIndicatorView aboveSubview:self.webView];
        [_activityIndicatorView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view.mas_centerX);
            make.centerY.equalTo(self.view.mas_centerY);
        }];
    }
    return _activityIndicatorView;
}


#pragma mark - Private

/// 移动退出按钮位置手势
- (void)quitFloatButtonMovePanGesture:(UIPanGestureRecognizer *)pan
{
    self.buttonFloatQuit.alpha = 0.8;
    
    CGPoint translation = [pan translationInView:self.view];
    CGFloat centerX = pan.view.center.x + translation.x;
    CGFloat thecenter = 0;
    
    pan.view.center = CGPointMake(centerX,pan.view.center.y + translation.y );
    
    [pan setTranslation:CGPointZero inView:self.view];
    CGPoint point = [pan translationInView:self.buttonFloatQuit];
    CGFloat width = [UIScreen mainScreen] .bounds.size.width;
    CGFloat height = [UIScreen mainScreen] .bounds.size.height;
    CGRect originalFrame = self.buttonFloatQuit.frame;
    if (originalFrame.origin.x >= 0 && originalFrame.origin.x + originalFrame.size.width <= width) {
        originalFrame.origin.x += point.x;
    }
    if (originalFrame.origin.y >= 0 && originalFrame.origin.y + originalFrame.size.height <= height){
        originalFrame.origin.y += point.y;
    }
    self.buttonFloatQuit.frame = originalFrame;
    [pan setTranslation:CGPointZero inView:self.buttonFloatQuit];
    if (pan.state == UIGestureRecognizerStateBegan) {
        self.buttonFloatQuit.enabled = NO;
    } else if (pan.state == UIGestureRecognizerStateChanged){
        
    } else {
        CGRect frame = self.buttonFloatQuit.frame;
        //是否越界
        BOOL isOver = NO;
        if (frame.origin.x < 0) {
            frame.origin.x = 40;
            isOver = YES;
        }else if (frame.origin.x + frame.size.width > width){
            frame.origin.x = width - frame.size.width - 40;
            isOver = YES;
        }else if (frame.origin.y < 0) {
            frame.origin.y = 40;
            isOver = YES;
        }else if(frame.origin.y + frame.size.height > height) {
            frame.origin.y = height - frame.size.height - 40;
            isOver = YES;
        }
        if(centerX > SCREEN_WIDTH/2) {
            thecenter = SCREEN_WIDTH - 40;
        }else {
            thecenter = 40;
        }
        
        [UIView animateWithDuration:0.3 animations:^{
            pan.view.center = CGPointMake(thecenter, pan.view.center.y + translation.y);
        }];
        
        if (isOver) {
            [UIView animateWithDuration:0.3 animations:^{
                self.buttonFloatQuit.frame = frame;
            }];
        }
        self.buttonFloatQuit.enabled = YES;
    }
    
    if (self.buttonFloatQuit.isEnabled) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.buttonFloatQuit.alpha = 0.3;
        });
    }
}

- (BOOL)isCurrentViewControllerVisible
{
    return (self.isViewLoaded && self.view.window);
}

/// 设置导航条状态栏标签栏背景色
- (void)setNaviStatusBarTabBarBackgroundColor
{
    // 导航栏白色则返回
    if (self.webView.isLoading || !self.isLoadFinishOnce) {
        return;
    }
    
    // 当前是否为顶页面
    if (![self isCurrentViewControllerVisible]) {
        return;
    }
    
    // 双赢彩票
    if (FYWebGameShuangYingCaiPiaoType == self.gameType) {
        [self setNaviStatusBarTabBarBackgroundColorOfShuangYingCaiPiao];
    } else {
        
    }
}

/// 双赢彩票
- (void)setNaviStatusBarTabBarBackgroundColorOfShuangYingCaiPiao
{
    // 根据屏幕颜色设置导航栏颜色
    CGPoint startPoint = CGPointMake(1, STATUS_BAR_HEIGHT+1.0f);
    CGPoint endPoint = CGPointMake(SCREEN_WIDTH-1, STATUS_BAR_HEIGHT+1.0f);
    UIColor *navBarColor1 = [self getPixelColorAtLocation:startPoint];
    UIColor *navBarColor2 = [self getPixelColorAtLocation:endPoint];
    if ([self isEqualColor:navBarColor1 withColor:COLOR_HEXSTRING(@"#FFFFFF")]) {
        navBarColor1 = COLOR_RGBA(125, 202, 254, 255);
    }
    if ([self isEqualColor:navBarColor2 withColor:COLOR_HEXSTRING(@"#FFFFFF")]) {
        navBarColor2 = COLOR_RGBA(46, 105, 169, 255);
    }
    
    // 设置导航状态栏的颜色
    [self.naviStatusBarCustomView az_setGradientBackgroundWithColors:@[navBarColor1,navBarColor2] locations:nil startPoint:CGPointMake(0, 1) endPoint:CGPointMake(1,1)];
    
    // IPhoneX机型底部区域
    if (CFC_IS_IPHONE_X_OR_GREATER) {
        CGPoint point = CGPointMake(SCREEN_WIDTH*0.5f, SCREEN_MAX_LENGTH-TAB_BAR_DANGER_HEIGHT-1.5f);
        UIColor *tabBarColor = [self getPixelColorAtLocation:point];
        UIView *bottomSafeView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, TAB_BAR_DANGER_HEIGHT)];
        [self.view addSubview:bottomSafeView];
        [bottomSafeView setBackgroundColor:tabBarColor];
        [bottomSafeView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self.view);
            make.height.mas_equalTo(TAB_BAR_DANGER_HEIGHT);
        }];
    }
}

/// 网页开始加载菊花动画 - 开始
- (void)setActivityStartAnimating
{
    if (![self isShowProgressHUD]) {
        return;
    }
    
    [self.activityIndicatorView startAnimating];
}

/// 网页开始加载菊花动画 - 结束
- (void)setActivityStopAnimating
{
    if (![self isShowProgressHUD]) {
        return;
    }
    
    [self.activityIndicatorView stopAnimating];
    [self.activityIndicatorView removeFromSuperview];
    [self setActivityIndicatorView:nil];
}

/// 加载错误提示页面
- (void)setInsertWKWebErrorView
{
    [self setDeleteWKWebErrorView];
    
    WEAKSELF(weakSelf);
    CGRect frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-STATUS_NAVIGATION_BAR_HEIGHT);
    if (self.isNavBarHidden) {
        if (self.isStatusBarHidden) {
            frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        } else {
            frame = CGRectMake(0, STATUS_BAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT-STATUS_BAR_HEIGHT);
        }
    } else {
       frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-STATUS_NAVIGATION_BAR_HEIGHT);
    }
    FYWKWebErrorView *webErrorView = [[FYWKWebErrorView alloc] initWithFrame:frame];
    [webErrorView setRefreshBlock:^{
        [weakSelf pressWebRefreshAction];
    }];
    [self setWebErrorView:webErrorView];
    [self.view insertSubview:webErrorView aboveSubview:self.webView];
}

/// 删除错误提示页面
- (void)setDeleteWKWebErrorView
{
    [self.webErrorView removeFromSuperview];
    [self setWebErrorView:nil];
}

/// 是否需要显示菊花
- (BOOL)isShowProgressHUD
{
    /*
    // 1：王者棋牌，2：幸运棋牌，3：QG棋牌，4：开元棋牌，5：双赢彩票，6：IM电竞，7：IM体育，8：AG真人，9：AG电子，10：AG捕鱼，11：KG电子
    if (FYWebGameWangZeQiPaiType == self.gameType // 1、王者棋牌
        || FYWebGameXingYunQiPaiType == self.gameType // 2、幸运棋牌
        || FYWebGameQGQiPaiType == self.gameType // 3、QG棋牌
        || FYWebGameKaiYuanQiPaiType == self.gameType // 4、开元棋牌
        || FYWebGameShuangYingCaiPiaoType == self.gameType // 5、双赢彩票
        || FYWebGameIMElectronicSportsType == self.gameType // 6、IM电竞
        || FYWebGameIMSportsType == self.gameType // 7、IM体育
        || FYWebGameAGMortalPeopleType == self.gameType // 8、AG真人
        || FYWebGameAGElectronicType == self.gameType // 9、AG电子
        || FYWebGameAGCatchFishType == self.gameType // 10、AG捕鱼
        || FYWebGameKGElectronicType == self.gameType) { // 11、KG电子
        return YES;
    }
    */
    
    return YES;
}


@end


