//
//  RecordHeaderDefine.h
//  AudioModel
//
//  Created by Tom on 2020/7/6.
//  Copyright © 2020 Tom. All rights reserved.
//

#ifndef RecordHeaderDefine_h
#define RecordHeaderDefine_h

typedef NS_ENUM(NSInteger, RecordState){
    ///初始状态
    RecordState_Normal,
    ///正在录音
    RecordState_Recording,
    ///上滑取消（也在录音状态，UI显示有区别）
    RecordState_ReleaseToCancel,
    ///最后10s倒计时（也在录音状态，UI显示有区别）
    RecordState_RecordCounting,
    ///录音时间太短（录音结束了）
    RecordState_RecordTooShort,
};


#endif /* RecordHeaderDefine_h */
