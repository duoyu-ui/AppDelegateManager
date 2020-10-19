//
//  FYWKWebView.h
//  ProjectCSHB
//
//  Created by fangyuan on 2020/7/1.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import <WebKit/WebKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^FYWKWebViewHitTestEventBlock)(void);

@interface FYWKWebView : WKWebView

@property (nonatomic, copy) FYWKWebViewHitTestEventBlock hitTestEventBlock;

@end

NS_ASSUME_NONNULL_END
