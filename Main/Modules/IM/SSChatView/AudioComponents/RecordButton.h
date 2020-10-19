//
//  RecordButton.h
//  AudioModel
//
//  Created by Tom on 2020/7/6.
//  Copyright © 2020 Tom. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class RecordButton;
typedef void (^RecordTouchDown)         (RecordButton *recordButton);
typedef void (^RecordTouchUpOutside)    (RecordButton *recordButton);
typedef void (^RecordTouchUpInside)     (RecordButton *recordButton);
typedef void (^RecordTouchDragEnter)    (RecordButton *recordButton);
typedef void (^RecordTouchDragInside)   (RecordButton *recordButton);
typedef void (^RecordTouchDragOutside)  (RecordButton *recordButton);
typedef void (^RecordTouchDragExit)     (RecordButton *recordButton);
///录音按钮
@interface RecordButton : UIButton
@property (nonatomic, copy) RecordTouchDown         recordTouchDownAction;
@property (nonatomic, copy) RecordTouchUpOutside    recordTouchUpOutsideAction;
@property (nonatomic, copy) RecordTouchUpInside     recordTouchUpInsideAction;
@property (nonatomic, copy) RecordTouchDragEnter    recordTouchDragEnterAction;
@property (nonatomic, copy) RecordTouchDragInside   recordTouchDragInsideAction;
@property (nonatomic, copy) RecordTouchDragOutside  recordTouchDragOutsideAction;
@property (nonatomic, copy) RecordTouchDragExit     recordTouchDragExitAction;

/// 松开 结束
- (void)setButtonStateWithRecording;

/// 按住 说话
- (void)setButtonStateWithNormal;
@end

NS_ASSUME_NONNULL_END
