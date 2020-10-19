//
//  RecordView.m
//  AudioModel
//
//  Created by Tom on 2020/7/6.
//  Copyright © 2020 Tom. All rights reserved.
//

#import "RecordView.h"
#import "RecordToastContentView.h"
@interface RecordView ()
@property (nonatomic, strong) RecordingView *recodingView;
@property (nonatomic, strong) RecordReleaseToCancelView *releaseToCancelView;
@property (nonatomic, strong) RecordCountingView *countingView;
@property (nonatomic, assign) RecordState currentState;
@end
@implementation RecordView
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self setUp];
    }
    return self;
}

- (void)setUp
{
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];

    self.recodingView = [[RecordingView alloc] init];
    [self addSubview:self.recodingView];
    self.recodingView.hidden = YES;

    self.releaseToCancelView = [[RecordReleaseToCancelView alloc] init];
    [self addSubview:self.releaseToCancelView];
    self.releaseToCancelView.hidden = YES;
    
    self.countingView = [[RecordCountingView alloc] init];
    [self addSubview:self.countingView];
    self.countingView.hidden = YES;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    self.layer.cornerRadius = 6;
    self.clipsToBounds = YES;
    self.recodingView.frame = self.bounds;
    self.releaseToCancelView.frame = self.bounds;
    self.countingView.frame = self.bounds;
}
- (void)updatePower:(float)power
{
    if (self.currentState != RecordState_Recording) {
        return;
    }
    [self.recodingView updateWithPower:power];
}

- (void)updateWithRemainTime:(float)remainTime
{
    if (self.currentState != RecordState_RecordCounting || self.releaseToCancelView.hidden == false) {
        return;
    }
    [self.countingView updateWithRemainTime:remainTime];
}

- (void)updateUIWithRecordState:(RecordState)state
{
    self.currentState = state;
    if (state == RecordState_Normal) {//初始状态
        self.recodingView.hidden = YES;
        self.releaseToCancelView.hidden = YES;
        self.countingView.hidden = YES;
    }else if (state == RecordState_Recording){//正在录音
        self.recodingView.hidden = NO;
        self.releaseToCancelView.hidden = YES;
        self.countingView.hidden = YES;
    }else if (state == RecordState_ReleaseToCancel){//上滑取消（也在录音状态，UI显示有区别）
        self.recodingView.hidden = YES;
        self.releaseToCancelView.hidden = NO;
        self.countingView.hidden = YES;
    }else if (state == RecordState_RecordCounting){//最后10s倒计时（也在录音状态，UI显示有区别）
        self.recodingView.hidden = YES;
        self.releaseToCancelView.hidden = YES;
        self.countingView.hidden = NO;
    }else if (state == RecordState_RecordTooShort){//录音时间太短（录音结束了）
        self.recodingView.hidden = YES;
        self.releaseToCancelView.hidden = YES;
        self.countingView.hidden = YES;
    }
}

@end
