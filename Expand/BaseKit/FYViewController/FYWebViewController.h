//
//  FYWebViewController.h
//  Project
//
//  Created by mini on 2018/8/14.
//  Copyright © 2018年 CDJay. All rights reserved.
//

#import "WebViewController.h"

@interface FYWebViewController : WebViewController

@property (nonatomic, assign) BOOL isShowCloseButton;

- (instancetype)initWithUrl:(NSString *)url gameType:(NSInteger)gameType;

@end


