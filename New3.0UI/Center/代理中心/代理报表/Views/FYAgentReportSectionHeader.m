//
//  FYAgentReportSectionHeader.m
//  ProjectCSHB
//
//  Created by fangyuan on 2020/6/27.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "FYAgentReportSectionHeader.h"
#import "FYAgentReportViewController.h"
#import "ZJScrollSegmentView.h"

@interface FYAgentReportSectionHeader ()
@property (nonatomic, weak) FYAgentReportViewController *parentViewController;
@property (nonatomic, assign) CGFloat headerViewHeight;
@property (nonatomic, weak) ZJScrollSegmentView *segmentView;
@end

@implementation FYAgentReportSectionHeader

- (instancetype)initWithFrame:(CGRect)frame
             headerViewHeight:(CGFloat)headerViewHeight
         parentViewController:(FYAgentReportViewController *)parentViewController
                  segmentView:(ZJScrollSegmentView *)segmentView
{
    self = [super initWithFrame:frame];
    if (self) {
        _segmentView = segmentView;
        _headerViewHeight = headerViewHeight;
        _parentViewController = parentViewController;
        [self createViewAtuoLayout];
    }
    return self;
}

- (void)createViewAtuoLayout
{
    [self addSubview:self.segmentView];
    [self.segmentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self);
        make.height.mas_equalTo(self.headerViewHeight);
    }];
}


@end
