//
//  RecordToastContentView.h
//  AudioModel
//
//  Created by Tom on 2020/7/6.
//  Copyright © 2020 Tom. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
///录音中间的view
@interface RecordToastContentView : UIView

@end
///手指上划 取消发送
@interface RecordingView : RecordToastContentView
- (void)updateWithPower:(float)power;
@end
///松开手指 取消发送
@interface RecordReleaseToCancelView : RecordToastContentView

@end
///松开手指 取消发送
@interface RecordCountingView : RecordToastContentView
- (void)updateWithRemainTime:(float)remainTime;
@end
///说话时间太短
@interface RecordTipView : RecordToastContentView

- (void)showWithMessage:(NSString *)msg;

@end
NS_ASSUME_NONNULL_END
