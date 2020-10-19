//
//  RecorderTool.h
//  AudioModel
//
//  Created by Tom on 2020/7/7.
//  Copyright © 2020 Tom. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
NS_ASSUME_NONNULL_BEGIN

@protocol RecorderProcessDelegate <NSObject>
@optional
/// 完成录音
- (void)endRecorder:(NSData*)audioData;
@end
@interface RecorderTool : NSObject
//录音工具的单例
+ (instancetype)sharedRecorder;

//开始录音
- (void)startRecording;

//停止录音
- (void)stopRecording;

//播放录音文件
- (void)playRecordingFile;

//停止播放录音文件
- (void)stopPlaying;

//销毁录音文件
- (void)destructionRecordingFile;

//录音对象
@property (nonatomic, strong) AVAudioRecorder *recorder;

//播放器对象
@property (nonatomic, strong) AVAudioPlayer *player;

//更新图片的代理
@property (nonatomic, weak) id<RecorderProcessDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
