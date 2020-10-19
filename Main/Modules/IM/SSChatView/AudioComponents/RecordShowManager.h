//
//  RecordShowManager.h
//  AudioModel
//
//  Created by Tom on 2020/7/6.
//  Copyright © 2020 Tom. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RecordHeaderDefine.h"
NS_ASSUME_NONNULL_BEGIN

@interface RecordShowManager : NSObject
- (void)updateUIWithRecordState:(RecordState)state;
- (void)showToast:(NSString *)message;
- (void)updatePower:(float)power;
- (void)showRecordCounting:(float)remainTime;
@end

NS_ASSUME_NONNULL_END
