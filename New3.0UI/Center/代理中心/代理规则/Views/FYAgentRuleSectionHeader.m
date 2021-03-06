//
//  FYAgentRuleSectionHeader.m
//  ProjectCSHB
//
//  Created by fangyuan on 2020/7/29.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "FYAgentRuleSectionHeader.h"
#import "FYAgentRuleViewController.h"
#import "ZJScrollSegmentView.h"

@interface FYAgentRuleSectionHeader ()
@property (nonatomic, weak) FYAgentRuleViewController *parentViewController;
@property (nonatomic, weak) ZJScrollSegmentView *segmentView;
@property (nonatomic, assign) CGFloat splineHeight;
@property (nonatomic, assign) CGFloat segmentViewHeight;
@property (nonatomic, assign) CGFloat headerViewHeight;
@end

@implementation FYAgentRuleSectionHeader

- (instancetype)initWithFrame:(CGRect)frame
             headerViewHeight:(CGFloat)headerViewHeight
         parentViewController:(FYAgentRuleViewController *)parentViewController
                  segmentView:(ZJScrollSegmentView *)segmentView
{
    self = [super initWithFrame:frame];
    if (self) {
        _segmentView = segmentView;
        _headerViewHeight = headerViewHeight;
        _splineHeight = [FYAgentRuleViewController heightOfHeaderSpline];
        _segmentViewHeight = [FYAgentRuleViewController heightOfHeaderSegment];
        _parentViewController = parentViewController;
        [self createViewAtuoLayout];
    }
    return self;
}

- (void)createViewAtuoLayout
{
    UIView *splineTop = ({
        UIView *view = [[UIView alloc] init];
        [view setBackgroundColor:COLOR_TABLEVIEW_SEPARATOR_LINE_DEFAULT];
        [self addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.equalTo(self);
            make.height.mas_equalTo(self.splineHeight);
        }];
        
        view;
    });
    splineTop.mas_key = @"splineTop";
    
    [self addSubview:self.segmentView];
    [self.segmentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(splineTop.mas_bottom);
        make.left.right.equalTo(self);
        make.height.mas_equalTo(self.segmentViewHeight);
    }];
    
    UIView *splineBottom = ({
        UIView *view = [[UIView alloc] init];
        [view setBackgroundColor:COLOR_TABLEVIEW_SEPARATOR_LINE_DEFAULT];
        [self addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self);
            make.height.mas_equalTo(self.splineHeight);
        }];
        
        view;
    });
    splineBottom.mas_key = @"splineBottom";
}


@end

