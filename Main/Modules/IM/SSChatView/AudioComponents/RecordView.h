//
//  RecordView.h
//  AudioModel
//
//  Created by Tom on 2020/7/6.
//  Copyright © 2020 Tom. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RecordHeaderDefine.h"
NS_ASSUME_NONNULL_BEGIN

@interface RecordView : UIView
- (void)updateUIWithRecordState:(RecordState)state;
- (void)updatePower:(float)power;
- (void)updateWithRemainTime:(float)remainTime;
@end

NS_ASSUME_NONNULL_END
