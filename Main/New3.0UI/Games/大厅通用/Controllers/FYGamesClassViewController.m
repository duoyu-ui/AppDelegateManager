//
//  FYGamesClassViewController.m
//  ProjectCSHB
//
//  Created by fangyuan on 2020/5/16.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "FYGamesClassViewController.h"

NSString *const FYGamesClassParentTableViewDidLeaveFromTopNotification = @"FYGamesClassParentTableViewDidLeaveFromTopNotification";

@interface FYGamesClassViewController () <UIScrollViewDelegate>

@property (nonatomic, assign) CGSize subScrollViewSize;

@end

@implementation FYGamesClassViewController

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 禁止自动适配
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    // 利用通知可以同时修改所有的子控制器的 scrollView 的 contentOffset 为 CGPointZero
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(leaveFromTop)
                                                 name:FYGamesClassParentTableViewDidLeaveFromTopNotification
                                               object:nil];
}

- (void)resetSubScrollViewSize:(CGSize)size
{
    _subScrollViewSize = size;
}

- (void)leaveFromTop
{
    _scrollView.contentOffset = CGPointZero;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = scrollView;
    }

    if (self.delegate && [self.delegate respondsToSelector:@selector(scrollViewIsScrolling:)]) {
        [self.delegate scrollViewIsScrolling:scrollView];
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
