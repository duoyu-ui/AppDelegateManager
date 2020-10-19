//
//  FYGamesMode1HBGroupSectionHeader.m
//  ProjectCSHB
//
//  Created by fangyuan on 2020/7/28.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "FYGamesMode1HBGroupSectionHeader.h"
#import "FYGamesMode1HBGroupController.h"
#import "ZJScrollSegmentView.h"

@interface FYGamesMode1HBGroupSectionHeader ()
@property (nonatomic, weak) FYGamesMode1HBGroupController *parentViewController;
@property (nonatomic, weak) ZJScrollSegmentView *segmentView;
@property (nonatomic, assign) CGFloat splineHeight;
@property (nonatomic, assign) CGFloat segmentViewHeight;
@property (nonatomic, assign) CGFloat headerViewHeight;
@end

@implementation FYGamesMode1HBGroupSectionHeader

- (instancetype)initWithFrame:(CGRect)frame
             headerViewHeight:(CGFloat)headerViewHeight
         parentViewController:(FYGamesMode1HBGroupController *)parentViewController
                  segmentView:(ZJScrollSegmentView *)segmentView
{
    self = [super initWithFrame:frame];
    if (self) {
        _segmentView = segmentView;
        _headerViewHeight = headerViewHeight;
        _splineHeight = [FYGamesMode1HBGroupController heightOfHeaderSpline];
        _segmentViewHeight = [FYGamesMode1HBGroupController heightOfHeaderSegment];
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

