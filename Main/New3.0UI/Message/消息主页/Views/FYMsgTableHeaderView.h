//
//  FYMsgTableHeaderView.h
//  ProjectCSHB
//
//  Created by fangyuan on 2020/5/28.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FYMessageMainViewController.h"
@class FYMsgNoticeModel, FYMessageMainViewController;

NS_ASSUME_NONNULL_BEGIN

@protocol FYMsgTableHeaderViewDelegate <NSObject>
@optional
- (void)didSearchActionFromMsgTableHeaderView;
@end

@interface FYMsgTableHeaderView : UIView <FYMessageMainViewControllerProtocol>

@property (nonatomic, weak) id<FYMsgTableHeaderViewDelegate> delegate;


- (instancetype)initWithFrame:(CGRect)frame headerHeight:(CGFloat)headerHeight delegate:(id<FYMsgTableHeaderViewDelegate>)delegate parentViewController:(FYMessageMainViewController *)parentViewController;

@end

NS_ASSUME_NONNULL_END
