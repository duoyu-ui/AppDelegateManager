//
//  FYGamesMode1HBGroupSectionHeader.h
//  ProjectCSHB
//
//  Created by fangyuan on 2020/7/28.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FYGamesMode1HBGroupController, ZJScrollSegmentView;

NS_ASSUME_NONNULL_BEGIN

@interface FYGamesMode1HBGroupSectionHeader : UIView

- (instancetype)initWithFrame:(CGRect)frame
             headerViewHeight:(CGFloat)headerViewHeight
         parentViewController:(FYGamesMode1HBGroupController *)parentViewController
                  segmentView:(ZJScrollSegmentView *)segmentView;

@end

NS_ASSUME_NONNULL_END
