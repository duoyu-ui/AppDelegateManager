//
//  FYGamesBannerNoticeView.h
//  ProjectCSHB
//
//  Created by fangyuan on 2020/5/16.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FYGamesBaseViewController.h"
@class FYGamesBannerModel, FYGamesNoticeModel, ZJScrollSegmentView;

NS_ASSUME_NONNULL_BEGIN

@interface FYGamesBannerNoticeView : UIView <FYGamesBaseViewControllerProtocol>

- (instancetype)initWithFrame:(CGRect)frame
             headerViewHeight:(CGFloat)headerViewHeight
         parentViewController:(FYGamesBaseViewController *)parentViewController
                  segmentView:(ZJScrollSegmentView *)segmentView
                 bannerModels:(NSMutableArray<FYGamesBannerModel *> *)bannerModels
                 noticeModels:(NSMutableArray<FYGamesNoticeModel *> *)noticeModels;

- (void)adjustWhenControllerViewWillAppera;

@end

NS_ASSUME_NONNULL_END
