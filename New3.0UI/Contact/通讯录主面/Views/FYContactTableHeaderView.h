//
//  FYContactTableHeaderView.h
//  ProjectCSHB
//
//  Created by fangyuan on 2020/6/15.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FYContactMainViewController;

NS_ASSUME_NONNULL_BEGIN

@protocol FYContactTableHeaderViewDelegate <NSObject>
@optional
- (void)didSearchActionFromContactTableHeaderView;
@end


@interface FYContactTableHeaderView : UIView

@property (nonatomic, weak) id<FYContactTableHeaderViewDelegate> delegate;


- (instancetype)initWithFrame:(CGRect)frame headerHeight:(CGFloat)headerHeight delegate:(id<FYContactTableHeaderViewDelegate>)delegate parentViewController:(FYContactMainViewController *)parentViewController;

@end

NS_ASSUME_NONNULL_END
