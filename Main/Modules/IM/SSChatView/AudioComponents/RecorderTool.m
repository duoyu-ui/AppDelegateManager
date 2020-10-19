//
//  RecorderTool.m
//  AudioModel
//
//  Created by Tom on 2020/7/7.
//  Copyright © 2020 Tom. All rights reserved.
//

#import "RecorderTool.h"
#import <PFAudioLib/PFAudio.h>
#define SecretTrainRecordFielName @"fy.pcm"
@interface RecorderTool()<AVAudioRecorderDelegate, AVAudioPlayerDelegate>
//录音文件地址
@property (nonatomic, strong) NSURL *recordFileUrl;

@property (nonatomic, strong) AVAudioSession *session;

@property (nonatomic , strong) NSDictionary *configDic;

@property (nonatomic , strong) NSString *document;
@end
@implementation RecorderTool

static RecorderTool *instance = nil;
#pragma mark - 单例
+ (instancetype)sharedRecorder
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (instance == nil) {
            instance = [[self alloc] init];
        }
    });
    return instance;
}

- (void)startRecording
{
    // 录音时停止播放 删除曾经生成的文件
    [self stopPlaying];
    [self destructionRecordingFile];
    // 真机环境下需要的代码
    self.session = [AVAudioSession sharedInstance];
    [self.session setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    [self.recorder record];
}

- (void)updateImage{
    [self.recorder updateMeters];
    
    double lowPassResults = pow(10, (0.05 * [self.recorder peakPowerForChannel:0]));
    float result  = 10 * (float)lowPassResults;
    //NSLog(@"%f", result);
    int no = 0;
    if (result > 0 && result <= 1.3) {
        no = 1;
    } else if (result > 1.3 && result <= 2) {
        no = 2;
    } else if (result > 2 && result <= 3.0) {
        no = 3;
    } else if (result > 3.0 && result <= 3.0) {
        no = 4;
    } else if (result > 5.0 && result <= 10) {
        no = 5;
    } else if (result > 10 && result <= 40) {
        no = 6;
    } else if (result > 40) {
        no = 7;
    }
    NSLog(@"no : %d",no);

}
- (void)stopRecording{
    if ([self.recorder isRecording])
    {
        [self.recorder stop];
    }
}
- (void)playRecordingFile{
    [self.recorder stop];// 播放时停止录音
    // 正在播放就返回
    if ([self.player isPlaying])
    {
        return;
    }
    NSError * error;
    self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:self.recordFileUrl error:&error];
    self.player.delegate = self;
    [self.session setCategory:AVAudioSessionCategoryPlayback error:nil];
    [self.player play];
}

- (void)stopPlaying{
    [self.player stop];
}

#pragma mark - 懒加载
- (AVAudioRecorder *)recorder {
    if (!_recorder) {
        // 1.获取沙盒地址
        NSString *filePath = [self.document stringByAppendingPathComponent:SecretTrainRecordFielName];
        self.recordFileUrl = [NSURL fileURLWithPath:filePath];
        NSLog(@"filePath:%@", filePath);
        _recorder = [[AVAudioRecorder alloc] initWithURL:self.recordFileUrl settings:self.configDic error:NULL];
        _recorder.delegate = self;
        _recorder.meteringEnabled = YES;
        
        [_recorder prepareToRecord];
    }
    return _recorder;
}
/// setting : 录音的设置项,录音参数设置
- (NSDictionary *)configDic{
    if (!_configDic) {
        _configDic = @{
            // 编码格式 音频格式
            AVFormatIDKey : [NSNumber numberWithInt:kAudioFormatLinearPCM],
            // 录音采样率(Hz) 如：AVSampleRateKey==8000/44100/96000（影响音频的质量）
            AVSampleRateKey : [NSNumber numberWithInteger:8000],
            // 通道数
            AVNumberOfChannelsKey : [NSNumber numberWithInt:2],
            // 线性音频的位深度  8、16、24、32
            AVLinearPCMBitDepthKey : [NSNumber numberWithInt:16],
            // 录音质量
            AVEncoderAudioQualityKey : [NSNumber numberWithInt:AVAudioQualityHigh],
        };
    }
    return _configDic;
}
- (NSString *)document{
    if (!_document) {
        _document = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    }
    return _document;
}
- (void)destructionRecordingFile
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (self.recordFileUrl)
    {
        [fileManager removeItemAtURL:self.recordFileUrl error:NULL];
    }
}

#pragma mark - AVAudioRecorderDelegate
- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag{
    [self.session setActive:NO withOptions:AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation error:nil];
    [PFAudio shareInstance].attrs = self.configDic;
    BOOL isAmr = [[PFAudio shareInstance] pcm2Amr:self.recordFileUrl.path isDeleteSourchFile:YES];
       if (isAmr) {
           NSFileManager *fm = [NSFileManager defaultManager];
           if([fm fileExistsAtPath:self.document]){
               //取得一个目录下得所有文件名
               NSArray <NSString *>*fileArr = [fm contentsOfDirectoryAtPath:self.document error:nil];
               [fileArr enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                   if ([obj hasSuffix:@".amr"]) {
                       NSData *audioData = [fm contentsAtPath:[NSString stringWithFormat:@"%@/%@",self.document,obj]];
                       if (audioData) {
                           if ([self.delegate respondsToSelector:@selector(endRecorder:)]) {
                               [self.delegate endRecorder:audioData];
                           }
                       }
                   }
               }];
           }
       }
}
- (void)audioRecorderEncodeErrorDidOccur:(AVAudioRecorder *)recorder error:(NSError *)error{
    [self.session setActive:NO withOptions:AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation error:nil];
}
#pragma mark - AVAudioPlayerDelegate
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{

}

@end
