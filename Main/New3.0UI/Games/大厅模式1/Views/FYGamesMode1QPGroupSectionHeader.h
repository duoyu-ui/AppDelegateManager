//
//  FYGamesMode1QPGroupSectionHeader.h
//  ProjectCSHB
//
//  Created by fangyuan on 2020/7/31.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FYGamesMode1QPGroupController, ZJScrollSegmentView;

NS_ASSUME_NONNULL_BEGIN

@interface FYGamesMode1QPGroupSectionHeader : UIView

- (instancetype)initWithFrame:(CGRect)frame
             headerViewHeight:(CGFloat)headerViewHeight
         parentViewController:(FYGamesMode1QPGroupController *)parentViewController
                  segmentView:(ZJScrollSegmentView *)segmentView;

@end

NS_ASSUME_NONNULL_END
