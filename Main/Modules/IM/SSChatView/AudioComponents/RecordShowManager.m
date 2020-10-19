//
//  RecordShowManager.m
//  AudioModel
//
//  Created by Tom on 2020/7/6.
//  Copyright © 2020 Tom. All rights reserved.
//

#import "RecordShowManager.h"
#import "RecordView.h"
#import "RecordToastContentView.h"
@interface RecordShowManager()

@property (nonatomic, strong) RecordView *voiceRecordView;
@property (nonatomic, strong) RecordTipView *tipView;
@end
@implementation RecordShowManager

- (void)updatePower:(float)power{
    [self.voiceRecordView updatePower:power];
}
- (void)showRecordCounting:(float)remainTime{
    [self.voiceRecordView updateWithRemainTime:remainTime];
}
- (void)showToast:(NSString *)message{
    if (self.tipView.superview == nil) {
        [[UIApplication sharedApplication].keyWindow addSubview:self.tipView];
        [self.tipView showWithMessage:message];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.tipView removeFromSuperview];
        });
    }
}
- (void)updateUIWithRecordState:(RecordState)state
{
    if (state == RecordState_Normal) {
        if (self.voiceRecordView.superview) {
            [self.voiceRecordView removeFromSuperview];
        }
        return;
    }
    if (self.voiceRecordView.superview == nil) {
        [[UIApplication sharedApplication].keyWindow addSubview:self.voiceRecordView];
    }
    
    [self.voiceRecordView updateUIWithRecordState:state];
}

- (RecordView *)voiceRecordView
{
    if (_voiceRecordView == nil) {
        _voiceRecordView = [RecordView new];
        _voiceRecordView.frame = CGRectMake(0, 0, 150, 150);
        _voiceRecordView.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2, [UIScreen mainScreen].bounds.size.height/2);
    }
    return _voiceRecordView;
}

- (RecordTipView *)tipView
{
    if (_tipView == nil) {
        _tipView = [RecordTipView new];
        _tipView.frame = CGRectMake(0, 0, 150, 150);
        _tipView.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2, [UIScreen mainScreen].bounds.size.height/2);
    }
    return _tipView;
}
@end
