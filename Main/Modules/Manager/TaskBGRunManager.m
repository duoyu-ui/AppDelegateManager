//
//  TaskBGRunManager.m
//  ProjectCSHB
//
//  Created by fangyuan on 2020/3/17.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "TaskBGRunManager.h"
#import <AVFoundation/AVFoundation.h>

static NSInteger _circulaDuration = 5; // 循环时间

@interface TaskBGRunManager () <AVAudioPlayerDelegate>
@property (nonatomic, strong) NSTimer *timerTask;
@property (nonatomic, strong) AVAudioPlayer *audioPlayer;
@property (nonatomic, unsafe_unretained) UIBackgroundTaskIdentifier backgroundTaskIdentifier;
@end

@implementation TaskBGRunManager {
    CFRunLoopRef _runloopRef;
    dispatch_queue_t _queue;
}

+ (instancetype)sharedTaskBGRunManager {
    static dispatch_once_t onceToken;
    static TaskBGRunManager *instance = nil;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] initInPrivate];
    });
    return instance;
}

- (instancetype)initInPrivate {
    self = [super init];
    if (self) {
        [self setupAudioSession];
        _queue = dispatch_queue_create("com.xmfm.audio.inbackground", NULL);
    }
    return self;
}

- (instancetype)init {
    return nil;
}

- (instancetype)copy {
    return nil;
}

/**
 * 启动后台运行
 */
- (void)startBackgroundTaskRun
{
    if ([self.audioPlayer play]){
        NSLog(@"Success started playing...");
    } else {
        NSLog(@"Failed started playing...");
    }
    [self applyforBackgroundTask];
    dispatch_async(_queue, ^{
        self->_runloopRef = CFRunLoopGetCurrent();
        self.timerTask = [[NSTimer alloc] initWithFireDate:[NSDate date]
                                                  interval:_circulaDuration
                                                    target:self
                                                  selector:@selector(startAudioPlay)
                                                  userInfo:nil
                                                   repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:self.timerTask forMode:NSDefaultRunLoopMode];
        CFRunLoopRun();
    });
}

/**
 * 停止后台运行
 */
- (void)stopBackgroundTaskRun
{
    if (self.timerTask) {
        CFRunLoopStop(_runloopRef);
        // 关闭定时器即可
        [self.timerTask invalidate];
        self.timerTask = nil;
        [self.audioPlayer stop];
    }
    if (_backgroundTaskIdentifier) {
        [[UIApplication sharedApplication] endBackgroundTask:_backgroundTaskIdentifier];
        _backgroundTaskIdentifier = UIBackgroundTaskInvalid;
    }
}

/**
 * 申请后台
 */
- (void)applyforBackgroundTask
{
    WEAKSELF(weakSelf);
    _backgroundTaskIdentifier =[[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [[UIApplication sharedApplication] endBackgroundTask:weakSelf.backgroundTaskIdentifier];
            weakSelf.backgroundTaskIdentifier = UIBackgroundTaskInvalid;
        });
    }];
}

/**
 * 创建音频Session
*/
- (void)setupAudioSession
{
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    // 设置后台播放
    NSError *audioSessionError = nil;
    if ([audioSession setCategory:AVAudioSessionCategoryPlayback withOptions:AVAudioSessionCategoryOptionMixWithOthers error:&audioSessionError]){
        NSLog(@"Successfully set the audio session.");
    } else {
        NSLog(@"Error setCategory AVAudioSession: %@", audioSessionError);
    }
    // 启动 AudioSession，如果一个前台app正在播放音频则可能会启动失败
    NSError *activeSetError = nil;
    [audioSession setActive:YES error:&activeSetError];
    if (activeSetError) {
        NSLog(@"Error activating AVAudioSession: %@", activeSetError);
    }
    // 静音文件
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"backvoice" ofType:@"mp3"];
    NSData *fileData = [NSData dataWithContentsOfFile:filePath];
    NSError *error = nil;
    self.audioPlayer = [[AVAudioPlayer alloc] initWithData:fileData error:&error];
    if (self.audioPlayer != nil){
        [self.audioPlayer setDelegate:self];
        [self.audioPlayer setNumberOfLoops:-1]; // 循环播放
        [self.audioPlayer setVolume:0.01]; // 0.0~1.0,默认为1.0
        [self.audioPlayer prepareToPlay];
    }
}

/**
 * 检测后台运行时间
 */
- (void)startAudioPlay
{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSTimeInterval backgroundTimeRemaining =[[UIApplication sharedApplication] backgroundTimeRemaining];
        if (backgroundTimeRemaining == DBL_MAX) {
            NSLog(NSLocalizedString(@"后台继续活跃呢", nil));
            // [self.audioPlayer stop];
        } else if (backgroundTimeRemaining < 61.0) {
            NSLog(NSLocalizedString(@"后台快被杀死了", nil));
            if ([self.audioPlayer play]){
                NSLog(@"Success started playing...");
            } else {
                NSLog(@"Failed to started playing...");
            }
            [self applyforBackgroundTask];
        }
    });
}

@end

