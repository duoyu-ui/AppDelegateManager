//
//  FYPayModeHeaderView.h
//  ProjectCSHB
//
//  Created by fangyuan on 2020/5/17.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FYPayModel, ZJScrollSegmentView;
@protocol FYRechargeMainViewControllerProtocol;

NS_ASSUME_NONNULL_BEGIN

@interface FYPayModeHeaderView : UIView <FYRechargeMainViewControllerProtocol>

- (instancetype)initWithFrame:(CGRect)frame
             headerViewHeight:(CGFloat)headerViewHeight
                    tabTitles:(NSArray<NSString *> *)tabTitles
                 tabPayModels:(NSArray<FYPayModel *> *)tabPayModels
                  segmentView:(ZJScrollSegmentView *)segmentView
         parentViewController:(UIViewController *)parentViewController;

- (void)setSelectedIndex:(NSInteger)index animated:(BOOL)animated;

@end

NS_ASSUME_NONNULL_END
