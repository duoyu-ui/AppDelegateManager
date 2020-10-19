//
//  FYWKWebView.m
//  ProjectCSHB
//
//  Created by fangyuan on 2020/7/1.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "FYWKWebView.h"

@implementation FYWKWebView

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    if (self.hitTestEventBlock) {
        self.hitTestEventBlock();
    }
    return [super hitTest:point withEvent:event];
}

@end
