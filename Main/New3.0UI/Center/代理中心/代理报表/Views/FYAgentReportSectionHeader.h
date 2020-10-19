//
//  FYAgentReportSectionHeader.h
//  ProjectCSHB
//
//  Created by fangyuan on 2020/6/27.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FYAgentReportViewController, ZJScrollSegmentView;

NS_ASSUME_NONNULL_BEGIN

@interface FYAgentReportSectionHeader : UIView

- (instancetype)initWithFrame:(CGRect)frame
             headerViewHeight:(CGFloat)headerViewHeight
         parentViewController:(FYAgentReportViewController *)parentViewController
                  segmentView:(ZJScrollSegmentView *)segmentView;

@end

NS_ASSUME_NONNULL_END

