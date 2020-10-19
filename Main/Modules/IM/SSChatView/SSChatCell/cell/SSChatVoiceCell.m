//
//  SSChatVoiceCell.m
//  SSChatView
//
//  Created by soldoros on 2018/10/15.
//  Copyright © 2018年 soldoros. All rights reserved.
//

#import "SSChatVoiceCell.h"
#import <PFAudioLib/PFAudio.h>
#import <GMenuController/GMenuController.h>

@interface SSChatVoiceCell ()
@property (nonatomic , weak) NSTimer *timer;
///语音时长
@property (nonatomic , assign) NSInteger voiceDuration;
//文件夹
@property (nonatomic , copy) NSString *document;
@property (nonatomic , strong) NSArray *arr;

@end
@implementation SSChatVoiceCell


-(void)initChatCellUI{
    [super initChatCellUI];
    _mTimeLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 70, 30)];
    _mTimeLab.textAlignment = NSTextAlignmentCenter;
    _mTimeLab.font = [UIFont systemFontOfSize:SSChatVoiceTimeFont];
    _mTimeLab.userInteractionEnabled = YES;
    _mTimeLab.textColor = UIColor.blackColor;
    _mTimeLab.backgroundColor = [UIColor clearColor];

    
    _mVoiceImg = [[UIImageView alloc]initWithFrame:CGRectMake(80, 5, 20, 20)];
    _mVoiceImg.userInteractionEnabled = YES;
    _mVoiceImg.animationDuration = 1;
    _mVoiceImg.animationRepeatCount = 0;
    _mVoiceImg.backgroundColor = [UIColor clearColor];
    
    
    _indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    self.indicator.center=CGPointMake(80, 15);
    
  
    
    [self.bubbleBackView addSubview:_indicator];
    [self.bubbleBackView addSubview:_mVoiceImg];
    [self.bubbleBackView addSubview:_mTimeLab];
    [self.bubbleBackView addSubview:self.dotView];
   
    [self.dotView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(8);
        make.centerY.equalTo(self.bubbleBackView);
    }];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(buttonPressed)];
    [self.bubbleBackView addGestureRecognizer:tap];
    UILongPressGestureRecognizer *gr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];

    [self.bubbleBackView addGestureRecognizer:gr];
    //整个列表只能有一个语音处于播放状态 通知其他正在播放的语音停止
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(UUAVAudioPlayerDidFinishPlay) name:@"VoicePlayHasInterrupt" object:nil];
    
    //红外线感应监听
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(sensorStateChange:)
                                                 name:UIDeviceProximityStateDidChangeNotification
                                               object:nil];
     
    GMenuItem *item = [[GMenuItem alloc] initWithTitle:NSLocalizedString(@"删除", nil)target:self action:@selector(onDeleteMessage)];
    self.arr = @[item];

}
///长按删除
- (void)longPress:(UILongPressGestureRecognizer *) gestureRecognizer {
    if ([gestureRecognizer state] == UIGestureRecognizerStateBegan) {
        [self becomeFirstResponder];
        CGRect rect = [gestureRecognizer view].frame;
        [[GMenuController sharedMenuController] setMenuItems:self.arr];
        [[GMenuController sharedMenuController] setTargetRect:rect inView:self.contentView];
        [[GMenuController sharedMenuController] setMenuVisible:YES];

        
    }
}



-(void)setModel:(FYMessagelLayoutModel *)model{
    [super setModel:model];
    UIImage *image = [UIImage imageNamed:model.message.backImgString];
    image = [image resizableImageWithCapInsets:model.imageInsets resizingMode:UIImageResizingModeStretch];
    self.bubbleBackView.frame = model.bubbleBackViewRect;
    self.bubbleBackView.image = image;
   
    if (model.message.messageFrom == FYMessageDirection_SEND) {
        _mVoiceImg.image = [UIImage imageNamed:@"chat_animation_white3"];
    }else{
        _mVoiceImg.image = [UIImage imageNamed:@"chat_animation3"];
    }
    _mVoiceImg.animationImages = self.model.message.voiceImgs;
    self.voiceDuration = model.message.voiceDuration;
    _mVoiceImg.frame = model.voiceImgRect;
    NSString *times = [NSString stringWithFormat:@"%@\"", model.message.voiceTime];
    _mTimeLab.text = times;
    _mTimeLab.frame = model.voiceTimeLabRect;
    NSDictionary *dict = [model.message.text mj_JSONObject];
    self.dotView.hidden = [dict[@"unRead"] boolValue];
    if (model.message.messageFrom == FYMessageDirection_RECEIVE) {
        [self.dotView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.bubbleBackView.mas_right).offset(5);
        }];
    }else{
        self.dotView.hidden = YES;
    }
    if (model.message.isReceivedMsg) {
           self.errorBtn.hidden = YES;
       } else {
           if (model.message.voice != nil) {
               self.errorBtn.hidden = YES;
           }else {
               if ([self isEqualVoiceUrl:model.message.voiceRemotePath]) {
                   self.errorBtn.hidden = YES;
//                   [self handleJSONWithImageData:model.message.text];
               }
           }
       }
    // 消息加载状态
       BOOL isActivityIndicatorHidden = [self activityIndicatorHidden];
//       NSLog(@"%@",isActivityIndicatorHidden ? @"YES": @"NO");
       [self.traningActivityIndicator setHidden:isActivityIndicatorHidden];
       if (isActivityIndicatorHidden) {
           [self.traningActivityIndicator stopAnimating];
       } else {
           [self.traningActivityIndicator startAnimating];
           [self layoutActivityIndicator];
       }
       
       if (model.message.deliveryState == FYMessageDeliveryStateFailed) {
           [self layoutErrorBtn];
       } else {
           self.errorBtn.hidden = YES;
       }
    
}
- (void)handleJSONWithImageData:(NSString *)json {
    if ([NSString isBlankString:json]) {
        return;
    }
    
    NSDictionary *JSONData = [json mj_JSONObject];
    if (![self isEqualVoiceUrl:JSONData[@"url"]]) {
        NSString *imageUrl = JSONData[@"url"];
        NSLog(@"%@",imageUrl);
//        [self.mImgView cd_setImageWithURL:[NSURL URLWithString:[NSString cdImageLink:imageUrl]] placeholderImage:[UIImage imageNamed:@"common_placeholder"]];
    }
}
- (void)layoutErrorBtn
{
    CGFloat centerX = 0;
    if ((self.model.message.messageFrom == FYMessageDirection_SEND))
    {
        centerX = CGRectGetMinX(self.bubbleBackView.frame) - 8 - CGRectGetWidth(self.traningActivityIndicator.bounds)/2;
        self.errorBtn.center = CGPointMake(centerX,
                                           self.bubbleBackView.center.y);
        self.errorBtn.hidden = NO;
        [self.traningActivityIndicator stopAnimating];
    }
}

- (void)layoutActivityIndicator{
    if (self.traningActivityIndicator.isAnimating) {
        CGFloat centerX = 0;
        if ((self.model.message.messageFrom == FYMessageDirection_SEND))
        {
            centerX = CGRectGetMinX(self.bubbleBackView.frame) - 8 - CGRectGetWidth(self.traningActivityIndicator.bounds)/2;
            self.traningActivityIndicator.center = CGPointMake(centerX,
                                                               self.bubbleBackView.center.y);
        }
    }
}
- (BOOL)isEqualVoiceUrl:(NSString *)url {
    if ([NSString isBlankString:url]) {
        return YES;
    }
    return NO;
}
- (BOOL)activityIndicatorHidden{
    if (self.model.message.isReceivedMsg)
    {
        return self.model.message.deliveryState != FYMessageDeliveryStateDelivering;
    }
    return NO;
}

- (void)onDeleteMessage{
    [[GMenuController sharedMenuController] setMenuVisible:NO];
     if(self.delegate && [self.delegate respondsToSelector:@selector(onDeleteMessageCell:indexPath:)]){
          [self.delegate onDeleteMessageCell:self.model.message indexPath:self.indexPath];
      }
}

//播放音频 暂停音频
-(void)buttonPressed{
    if(!_contentVoiceIsPlaying){
        [[NSNotificationCenter defaultCenter] postNotificationName:@"VoicePlayHasInterrupt" object:nil];
        _contentVoiceIsPlaying = YES;
        [_mVoiceImg startAnimating];
        _audio = [UUAVAudioPlayer sharedInstance];
        _audio.delegate = self;
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.model.message.voiceRemotePath]];
        NSString *palyPath = [NSString stringWithFormat:@"%@/fyPaly.amr",self.document];
        [data writeToFile:palyPath atomically:YES];
        BOOL isWav = [[PFAudio shareInstance] amr2Wav:palyPath isDeleteSourchFile:YES];
        if (isWav) {
            NSFileManager *fileMan = [NSFileManager defaultManager];
            if ([fileMan fileExistsAtPath:self.document]) {
                //取得一个目录下得所有文件名
                NSArray <NSString *>*files = [fileMan subpathsAtPath:self.document];
                [files enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if ([obj hasSuffix:@".wav"]) {
                        NSData *audioData = [fileMan contentsAtPath:[NSString stringWithFormat:@"%@/%@",self.document,obj]];
                        [_audio playSongWithData:audioData];
                    }
                }];
            }
        }
        [self.timer timeInterval];
        self.timer = nil;
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(playAudioCountdown) userInfo:nil repeats:YES];
    }else{
        [self UUAVAudioPlayerDidFinishPlay];
    }
    if ([self.delegate respondsToSelector:@selector(didChatVoiceCell:model:)]) {
        [self.delegate didChatVoiceCell:self model:self.model.message];
    }
}
- (void)playAudioCountdown{
    self.voiceDuration -= 1 ;
    if (self.voiceDuration <= 0) {
        [self.timer timeInterval];
        self.timer = nil;
        [_mVoiceImg stopAnimating];
    }
}

//播放显示开始加载
- (void)UUAVAudioPlayerBeiginLoadVoice{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.indicator startAnimating];
    });
}

//开启红外线感应
- (void)UUAVAudioPlayerBeiginPlay{
    [[UIDevice currentDevice] setProximityMonitoringEnabled:YES];
    [self.indicator stopAnimating];
    
}

//关闭红外线感应
- (void)UUAVAudioPlayerDidFinishPlay{
    [[UIDevice currentDevice] setProximityMonitoringEnabled:NO];
    _contentVoiceIsPlaying = NO;
    [_mVoiceImg stopAnimating];
    [[UUAVAudioPlayer sharedInstance]stopSound];
}

//处理监听触发事件
-(void)sensorStateChange:(NSNotificationCenter *)notification{
    if ([[UIDevice currentDevice] proximityState] == YES){
        NSLog(@"Device is close to user");
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    }
    else{
        NSLog(@"Device is not close to user");
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    }
}

- (NSString *)document{
    if (!_document) {
        _document = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    }
    return _document;
}
- (UIView *)dotView{
    if (!_dotView) {
        _dotView = [[UIView alloc]init];
        _dotView.layer.masksToBounds = YES;
        _dotView.layer.cornerRadius = 4;
        _dotView.backgroundColor = UIColor.redColor;
    }
    return _dotView;
}

@end
