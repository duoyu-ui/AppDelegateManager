//
//  FYAgentRuleSectionHeader.h
//  ProjectCSHB
//
//  Created by fangyuan on 2020/7/29.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FYAgentRuleViewController, ZJScrollSegmentView;

NS_ASSUME_NONNULL_BEGIN

@interface FYAgentRuleSectionHeader : UIView

- (instancetype)initWithFrame:(CGRect)frame
             headerViewHeight:(CGFloat)headerViewHeight
         parentViewController:(FYAgentRuleViewController *)parentViewController
                  segmentView:(ZJScrollSegmentView *)segmentView;

@end

NS_ASSUME_NONNULL_END
