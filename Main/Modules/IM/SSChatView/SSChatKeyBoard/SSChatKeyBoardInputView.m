//
//  SSChatKeyBoardInputView.m
//  SSChatView
//
//  Created by soldoros on 2018/9/25.
//  Copyright © 2018年 soldoros. All rights reserved.
//

#import "SSChatKeyBoardInputView.h"
#import <PFAudioLib/PFAudio.h>
#import "RecorderTool.h"
#import "RecordShowManager.h"
#define kFakeTimerDuration       1
#define kMaxRecordDuration       60     //最长录音时长
#define kRemainCountingDuration  10     //剩余多少秒开始倒计时
@interface SSChatKeyBoardInputView()<RecorderProcessDelegate>
@property (nonatomic, strong) RecordShowManager *voiceRecordCtrl;
@property (nonatomic, assign) RecordState currentRecordState;
@property (nonatomic, strong) NSTimer *fakeTimer;
@property (nonatomic, assign) float duration;
@property (nonatomic, assign) BOOL canceled;
@property (nonatomic, strong) RecorderTool *recorderTool;
/// 音的设置项,录音参数设置
@property (nonatomic , strong) NSDictionary *configDic;
///doc文件目录
@property (nonatomic , copy) NSString *document;
@end
@implementation SSChatKeyBoardInputView

- (instancetype)initWithChatType:(FYChatConversationType)chatType messageItem:(MessageItem *)messageItem
{
    self = [super init];
    if (self) {
        self.chatType = chatType;
        self.messageItem = messageItem;
        //
        self.backgroundColor =  SSChatCellColor;
        self.frame = CGRectMake(0, FYSCREEN_Height-SSChatKeyBoardInputViewH-kiPhoneX_Bottom_Height, FYSCREEN_Width, SSChatKeyBoardInputViewH);
        
        _keyBoardStatus = SSChatKeyBoardStatusDefault;
        _keyBoardHieght = 0;
        _changeTime = 0.25;
        _textH = SSChatTextHeight;
        
//        _topLine = [[UIView alloc]initWithFrame:CGRectMake(0, 0, FYSCREEN_Width, 0.5)];
//        _topLine.backgroundColor = CellLineColor;
//        [self addSubview:_topLine];
        
        // 左侧按钮
        _mLeftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _mLeftBtn.bounds = CGRectMake(0, 0, SSChatBtnSize, SSChatBtnSize);
        _mLeftBtn.left   = SSChatBtnDistence;
        _mLeftBtn.bottom  = self.height - SSChatBBottomDistence;
        _mLeftBtn.tag  = 10;
        [self addSubview:_mLeftBtn];
        [_mLeftBtn setBackgroundImage:[UIImage imageNamed:@"icon_yuying"] forState:UIControlStateNormal];
        [_mLeftBtn setBackgroundImage:[UIImage imageNamed:@"icon_shuru"] forState:UIControlStateSelected];
        _mLeftBtn.selected = NO;
        [_mLeftBtn addTarget:self action:@selector(btnPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        // 添加按钮
        _mAddBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _mAddBtn.bounds = CGRectMake(0, 0, SSChatBtnSize, SSChatBtnSize);
        _mAddBtn.right = FYSCREEN_Width - SSChatBtnDistence;
        _mAddBtn.bottom  = self.height - SSChatBBottomDistence;
        _mAddBtn.tag  = 12;
        _mAddBtn.selected = NO;
        [self addSubview:_mAddBtn];
        [_mAddBtn setBackgroundImage:[UIImage imageNamed:@"icon_tianjia"] forState:UIControlStateNormal];
        [_mAddBtn setBackgroundImage:[UIImage imageNamed:@"icon_tianjia"] forState:UIControlStateSelected];
        _mAddBtn.selected = NO;
        [_mAddBtn addTarget:self action:@selector(btnPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        
        // 红包、抢庄、投注、发包
        BOOL isHiddeCustomBtn = NO;
        {
            CGFloat mCustomBtnWidth = SSChatBtnSize;
            NSString *customBtnImageUrl = @"icon_bg_send_button_redpacket";
            if (FYConversationType_GROUP == self.chatType) {
                if (GroupTemplate_N00_FuLi == self.messageItem.type) {
                    // 判断是否自建群，是否是群主
                    if (!self.messageItem.officeFlag && self.messageItem.userId != APPINFORMATION.userInfo.userId) {
                        isHiddeCustomBtn = YES;
                        mCustomBtnWidth = 0.0f;
                    }
                }
                // 抢庄牛牛、二八杠、龙虎斗、接龙红包
                else if (GroupTemplate_N04_RobNiuNiu == self.messageItem.type
                         || GroupTemplate_N05_ErBaGang == self.messageItem.type
                         || GroupTemplate_N06_LongHuDou == self.messageItem.type
                         || GroupTemplate_N07_JieLong == self.messageItem.type
                         || GroupTemplate_N10_BagLottery == self.messageItem.type
                         || GroupTemplate_N11_BagBagCow == self.messageItem.type
                         ||GroupTemplate_N14_BestNiuNiu == self.messageItem.type) {
                    customBtnImageUrl = @"icon_bg_send_button_red";
                }
            } else {
                isHiddeCustomBtn = YES;
                mCustomBtnWidth = 0.0f;
            }
            _mCustomBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            _mCustomBtn.bounds = CGRectMake(0, 0, mCustomBtnWidth, SSChatBtnSize);
            _mCustomBtn.right = _mAddBtn.left - SSChatBtnDistence;
            _mCustomBtn.bottom  = self.height - SSChatBBottomDistence;
            _mCustomBtn.backgroundColor = [UIColor whiteColor];
            _mCustomBtn.tag  = 13;
            [self addSubview:_mCustomBtn];
            [_mCustomBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:CFC_AUTOSIZING_FONT(15.0f)]];
            [_mCustomBtn setBackgroundImage:[UIImage imageNamed:customBtnImageUrl] forState:UIControlStateNormal];
            [_mCustomBtn setBackgroundImage:[UIImage imageNamed:customBtnImageUrl] forState:UIControlStateHighlighted|UIControlStateSelected];
            _mCustomBtn.selected = NO;
            [_mCustomBtn addTarget:self action:@selector(btnPressed:) forControlEvents:UIControlEventTouchUpInside];
        }

        // 语音按钮 输入框
        CGFloat mTextBtnWidth = isHiddeCustomBtn ? SSChatTextWidth1 : SSChatTextWidth2;
//        CGFloat mTextBtnWidth = SSChatTextWidth1;
        _mTextBtn = [RecordButton buttonWithType:UIButtonTypeSystem];
        _mTextBtn.bounds = CGRectMake(0, 0, mTextBtnWidth, SSChatTextHeight);
//        _mTextBtn.left = SSChatBtnDistence;
        _mTextBtn.left = _mLeftBtn.right+SSChatBtnDistence;
        _mTextBtn.bottom = self.height - SSChatTBottomDistence;
        _mTextBtn.backgroundColor = [UIColor whiteColor];
//        _mTextBtn.layer.borderWidth = 0.5;
//        _mTextBtn.layer.borderColor = CellLineColor.CGColor;
        _mTextBtn.clipsToBounds = YES;
        _mTextBtn.layer.cornerRadius = 3;
        [self addSubview:_mTextBtn];
        _mTextBtn.userInteractionEnabled = YES;
        _mTextBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
        [_mTextBtn setTitleColor:makeColorRgb(100, 100, 100) forState:UIControlStateNormal];
        [_mTextBtn setTitle:NSLocalizedString(@"按住 说话", nil) forState:UIControlStateNormal];
        
        _mTextView = [[UITextView alloc]init];
        _mTextView.frame = _mTextBtn.bounds;
        _mTextView.textContainerInset = UIEdgeInsetsMake(7.5, 5, 5, 5);
        _mTextView.delegate = self;
        [_mTextBtn addSubview:_mTextView];
        _mTextView.backgroundColor = [UIColor whiteColor];
        _mTextView.returnKeyType = UIReturnKeySend;
        _mTextView.font = [UIFont systemFontOfSize:15];
        _mTextView.showsHorizontalScrollIndicator = NO;
        _mTextView.showsVerticalScrollIndicator = NO;
        _mTextView.enablesReturnKeyAutomatically = YES;
        _mTextView.scrollEnabled = NO;
        
        _mKeyBordView = [[SSChatKeyBordView alloc]initWithFrame:CGRectMake(0, self.height, FYSCREEN_Width, SSChatKeyBordHeight)];
        _mKeyBordView.delegate = self;
        [self addSubview:_mKeyBordView];
        // 表情按钮
        _mSymbolBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        _mSymbolBtn.backgroundColor = [UIColor whiteColor];
        _mSymbolBtn.tag  = 11;
        if (self.chatType == FYConversationType_GROUP) {
            _mSymbolBtn.alpha = 0.3;
            [_mTextView addSubview:_mSymbolBtn];
            [_mSymbolBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(_mTextBtn.mas_right).offset(-SSChatBtnDistence);
                make.width.height.mas_equalTo(SSChatBtnSize - 5);
                make.centerY.equalTo(_mTextView.mas_centerY);
            }];
        }else{
            [self addSubview:_mSymbolBtn];
            _mSymbolBtn.alpha = 1.0;
            [_mSymbolBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.height.mas_equalTo(SSChatBtnSize);
                make.centerY.equalTo(_mAddBtn);
                make.right.equalTo(_mAddBtn.mas_left).offset(-SSChatBtnDistence);
            }];
            [_mTextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(_mLeftBtn.mas_right).offset(SSChatBtnDistence);
                make.top.mas_equalTo(SSChatBtnDistence);
                make.right.equalTo(_mSymbolBtn.mas_left).offset(-SSChatBtnDistence);
                make.bottom.mas_equalTo(-SSChatBtnDistence);
            }];;
        }
        [_mSymbolBtn setBackgroundImage:[UIImage imageNamed:@"icon_biaoqing"] forState:UIControlStateNormal];
        [_mSymbolBtn setBackgroundImage:[UIImage imageNamed:@"icon_shuru"] forState:UIControlStateSelected];
        _mSymbolBtn.selected = NO;
        [_mSymbolBtn addTarget:self action:@selector(btnPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        // 键盘显示 回收的监听
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChange:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChange:) name:UIKeyboardWillHideNotification object:nil];
        [self toDoRecord];
    }
    return self;
}
#pragma mark - 录音全部状态的监听 以及视图的构建 切换
-(void)toDoRecord
{
    self.recorderTool = [RecorderTool sharedRecorder];
    self.recorderTool.delegate = self;
    __weak typeof(self) weak_self = self;
    //手指按下
    _mTextBtn.recordTouchDownAction = ^(RecordButton *sender){
        //如果用户没有开启麦克风权限,不能让其录音
        if (![weak_self canRecord]) return;
        
        NSLog(NSLocalizedString(@"开始录音", nil));
        if (sender.highlighted) {
            sender.highlighted = YES;
            [sender setButtonStateWithRecording];
        }
        [weak_self.recorderTool startRecording];
        weak_self.currentRecordState = RecordState_Recording;
        [weak_self dispatchVoiceState];
    };
    
    //手指抬起
    _mTextBtn.recordTouchUpInsideAction = ^(RecordButton *sender){
        NSLog(NSLocalizedString(@"完成录音", nil));
        [sender setButtonStateWithNormal];
        [weak_self.recorderTool stopRecording];
        weak_self.currentRecordState = RecordState_Normal;
        [weak_self dispatchVoiceState];
    };
    
    //手指滑出按钮
    _mTextBtn.recordTouchUpOutsideAction = ^(RecordButton *sender){
        NSLog(NSLocalizedString(@"取消录音", nil));
        [sender setButtonStateWithNormal];
        weak_self.currentRecordState = RecordState_Normal;
        [weak_self dispatchVoiceState];
    };
    
    //中间状态  从 TouchDragInside ---> TouchDragOutside
    _mTextBtn.recordTouchDragExitAction = ^(RecordButton *sender){
        weak_self.currentRecordState = RecordState_ReleaseToCancel;
        [weak_self dispatchVoiceState];
    };
    
    //中间状态  从 TouchDragOutside ---> TouchDragInside
    _mTextBtn.recordTouchDragEnterAction = ^(RecordButton *sender){
        NSLog(NSLocalizedString(@"继续录音", nil));
        weak_self.currentRecordState = RecordState_Recording;
        [weak_self dispatchVoiceState];
    };
}

- (void)startFakeTimer
{
    if (_fakeTimer) {
        [_fakeTimer invalidate];
        _fakeTimer = nil;
    }
    self.duration = 0;
    self.fakeTimer = [NSTimer scheduledTimerWithTimeInterval:kFakeTimerDuration target:self selector:@selector(onFakeTimerTimeOut) userInfo:nil repeats:YES];
    [_fakeTimer fire];
}

- (void)stopFakeTimer
{
    if (_fakeTimer) {
        [_fakeTimer invalidate];
        _fakeTimer = nil;
    }
}

- (void)onFakeTimerTimeOut
{
    self.duration += kFakeTimerDuration;
    NSLog(@"%f",self.duration);
    float remainTime = kMaxRecordDuration - self.duration;
    if ((int)remainTime == 0) {
        self.currentRecordState = RecordState_Normal;
        [self dispatchVoiceState];
    }else if ([self shouldShowCounting]) {
        self.currentRecordState = RecordState_RecordCounting;
        [self dispatchVoiceState];
        [self.voiceRecordCtrl showRecordCounting:remainTime];
    }else{
        [self.recorderTool.recorder updateMeters];
        float level = 0.0f;                // The linear 0.0 .. 1.0 value we need.
        
        float minDecibels = -80.0f; // Or use -60dB, which I measured in a silent room.
        float decibels = [self.recorderTool.recorder peakPowerForChannel:0];
        if (decibels < minDecibels){
            level = 0.0f;
        }else if (decibels >= 0.0f){
            level = 1.0f;
        }else{
            float   root            = 2.0f;
            float   minAmp          = powf(10.0f, 0.05f * minDecibels);
            float   inverseAmpRange = 1.0f / (1.0f - minAmp);
            float   amp             = powf(10.0f, 0.05f * decibels);
            float   adjAmp          = (amp - minAmp) * inverseAmpRange;
            level = powf(adjAmp, 1.0f / root);
        }
        
        [self.voiceRecordCtrl updatePower:level];
    }
}
- (BOOL)shouldShowCounting
{
    if (self.duration >= (kMaxRecordDuration - kRemainCountingDuration) && self.duration < kMaxRecordDuration && self.currentRecordState != RecordState_ReleaseToCancel) {
        return YES;
    }
    return NO;
}

- (void)resetState
{
    [self stopFakeTimer];
    
    self.canceled = YES;
}

- (void)dispatchVoiceState
{
    if (_currentRecordState == RecordState_Recording) {
        self.canceled = NO;
        [self startFakeTimer];
    }else if (_currentRecordState == RecordState_Normal){
        [self resetState];
    }
    [self.voiceRecordCtrl updateUIWithRecordState:_currentRecordState];
}

- (RecordShowManager *)voiceRecordCtrl
{
    if (_voiceRecordCtrl == nil) {
        _voiceRecordCtrl = [RecordShowManager new];
    }
    return _voiceRecordCtrl;
}

//判断是否允许使用麦克风7.0新增的方法requestRecordPermission
-(BOOL)canRecord{
    __block BOOL bCanRecord = YES;
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    if ([audioSession respondsToSelector:@selector(requestRecordPermission:)]) {
        [audioSession performSelector:@selector(requestRecordPermission:) withObject:^(BOOL granted) {
            if (granted) {
                bCanRecord = YES;
            }
            else {
                bCanRecord = NO;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [SVProgressHUD showInfoWithStatus:NSLocalizedString(@"app需要访问您的麦克风。\n请启用麦克风-设置/隐私/麦克风", nil)];
                });
            }
        }];
    }
    return bCanRecord;
}
- (void)endRecorder:(NSData *)audioData{
//    [self endConvertWithData:audioData];
    NSLog(@"duration:%lf",self.duration);
    if(_delegate && [_delegate respondsToSelector:@selector(SSChatKeyBoardInputViewBtnClick:sendVoice:time:)]){
        [self.delegate SSChatKeyBoardInputViewBtnClick:self sendVoice:audioData time:self.duration+1];
    }
}
#pragma mark - 录音分割线
// 开始布局就把底部的表情和多功能放在输入框底部了 这里需要对点击界外事件做处理
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    if(point.y>SSChatKeyBoardInputViewH){
        UIView *hitView = [super hitTest:point withEvent:event];
        
        NSMutableArray *array = [NSMutableArray new];

        if(_mKeyBordView.type == KeyBordViewFouctionAdd){
            for(UIView * view in _mKeyBordView.functionView.mScrollView.subviews){
                [array addObjectsFromArray:view.subviews];
            }
        }
        else if(_mKeyBordView.type == KeyBordViewFouctionSymbol){
            
            CGPoint buttonPoint = [_mKeyBordView.symbolView.footer.sendButton convertPoint:point fromView:self];
        if(CGRectContainsPoint(_mKeyBordView.symbolView.footer.sendButton.bounds, buttonPoint)) {
                [array addObject:_mKeyBordView.symbolView.footer.sendButton];
            }
            else{
                CGPoint footerPoint = [_mKeyBordView.symbolView.footer.emojiFooterScrollView convertPoint:point fromView:self];
            if(CGRectContainsPoint(_mKeyBordView.symbolView.footer.emojiFooterScrollView.bounds, footerPoint)) {
                    [array addObjectsFromArray: _mKeyBordView.symbolView.footer.emojiFooterScrollView.subviews];
                }
                else{
                    [array addObjectsFromArray: _mKeyBordView.symbolView.collectionView.subviews];
                }
            }
        }
        
        for(UIView *subView in array) {
            
            CGPoint myPoint = [subView convertPoint:point fromView:self];
            if(CGRectContainsPoint(subView.bounds, myPoint)) {
                hitView = subView;
                break;
            }
        }
      
        return hitView;
    }
    else{
        return [super hitTest:point withEvent:event];
    }
}

//键盘显示监听事件
- (void)keyboardWillChange:(NSNotification *)noti{
   
    _changeTime  = [[noti userInfo][UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    CGFloat height = [[[noti userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;

    if(noti.name == UIKeyboardWillHideNotification){
        height = kiPhoneX_Bottom_Height;
        if(_keyBoardStatus == SSChatKeyBoardStatusSymbol ||
           _keyBoardStatus == SSChatKeyBoardStatusAdd){
            height = kiPhoneX_Bottom_Height+SSChatKeyBordHeight;
        } else {
            _mKeyBordView.mCoverView.hidden = NO;
            _keyBoardStatus = SSChatKeyBoardStatusDefault;
        }
    } else {
        
        self.keyBoardStatus = SSChatKeyBoardStatusEdit;
        self.currentBtn.selected = NO;
        
        if(height==kiPhoneX_Bottom_Height || height==0) height = _keyBoardHieght;
    }
    
    self.keyBoardHieght = height;
}

//弹起的高度
-(void)setKeyBoardHieght:(CGFloat)keyBoardHieght{
    
    if(keyBoardHieght == _keyBoardHieght){
        return;
    }
    
    _keyBoardHieght = keyBoardHieght;
    [self setNewSizeWithController];

    [UIView animateWithDuration:_changeTime animations:^{
        if(self.keyBoardStatus == SSChatKeyBoardStatusDefault ||
           self.keyBoardStatus == SSChatKeyBoardStatusVoice ||
           self.keyBoardStatus == SSChatKeyBoardStatusCustom){
            self.bottom = FYSCREEN_Height-kiPhoneX_Bottom_Height;
        }else{
            self.bottom = FYSCREEN_Height-self.keyBoardHieght;
        }
    } completion:nil];
    
}


//设置默认状态
-(void)setKeyBoardStatus:(SSChatKeyBoardStatus)keyBoardStatus{
    _keyBoardStatus = keyBoardStatus;
    
    if(_keyBoardStatus == SSChatKeyBoardStatusDefault
       || _keyBoardStatus == SSChatKeyBoardStatusCustom){
        self.currentBtn.selected = NO;
        self.mTextView.hidden = NO;
        self.mKeyBordView.mCoverView.hidden = NO;
    }
}


//视图归位 设置默认状态 设置弹起的高度
-(void)SetSSChatKeyBoardInputViewEndEditing
{
    if(self.keyBoardStatus != SSChatKeyBoardStatusVoice
       && self.keyBoardStatus != SSChatKeyBoardStatusCustom){
        self.keyBoardStatus = SSChatKeyBoardStatusDefault;
        [self endEditing:YES];
        self.keyBoardHieght = 0.0;
    }
}


// 语音10  表情11 添加12 其他功能13
-(void)btnPressed:(UIButton *)sender {
   
    [[UUAVAudioPlayer sharedInstance] stopSound];

    switch (self.keyBoardStatus) {
            
            //默认在底部状态
        case SSChatKeyBoardStatusDefault:{
            if(sender.tag==10){
                self.keyBoardStatus = SSChatKeyBoardStatusVoice;
                self.currentBtn = sender;
                self.currentBtn.selected = YES;
                self.mTextView.hidden = YES;
                _mKeyBordView.mCoverView.hidden = NO;
                self.keyBoardHieght = 0.0;
                [self setNewSizeWithBootm:SSChatTextHeight];
            }
            else if (sender.tag==11){///表情
                self.keyBoardStatus = SSChatKeyBoardStatusSymbol;
                self.currentBtn.selected = NO;
                self.currentBtn = sender;
                self.currentBtn.selected = YES;
                _mKeyBordView.mCoverView.hidden = YES;
                _mKeyBordView.type = KeyBordViewFouctionSymbol;
                [self.mTextView resignFirstResponder];
                self.keyBoardHieght = kiPhoneX_Bottom_Height+SSChatKeyBordHeight;
                [self setNewSizeWithBootm:_textH];
            }
            else if (sender.tag==12){
                self.keyBoardStatus = SSChatKeyBoardStatusAdd;
                self.currentBtn = sender;
                self.currentBtn.selected = YES;
                _mKeyBordView.type = KeyBordViewFouctionAdd;
                _mKeyBordView.mCoverView.hidden = YES;
                self.keyBoardHieght = kiPhoneX_Bottom_Height+SSChatKeyBordHeight;
                [self setNewSizeWithBootm:_textH];
            } else {
                self.keyBoardStatus = SSChatKeyBoardStatusCustom;
                self.currentBtn = sender;
                self.currentBtn.selected = YES;
                self.keyBoardHieght = 0.0;
                [self setNewSizeWithBootm:_textH];
                [self buttonClickChatKeyBoardCustomButton:sender];
            }
        }
            break;
            
            //在输入语音的状态
        case SSChatKeyBoardStatusVoice:{
            if(sender.tag==10){
                self.keyBoardStatus = SSChatKeyBoardStatusEdit;
                self.currentBtn.selected = NO;
                self.mTextView.hidden = NO;
                _mKeyBordView.mCoverView.hidden = NO;
                [self.mTextView becomeFirstResponder];
                [self setNewSizeWithBootm:_textH];
                
            }else if (sender.tag==11){
                self.keyBoardStatus = SSChatKeyBoardStatusSymbol;
                self.currentBtn.selected = NO;
                self.currentBtn = sender;
                self.currentBtn.selected = YES;
                _mKeyBordView.mCoverView.hidden = YES;
                self.mTextView.hidden = NO;
                _mKeyBordView.type = KeyBordViewFouctionSymbol;
                self.keyBoardHieght = kiPhoneX_Bottom_Height+SSChatKeyBordHeight;
                [self setNewSizeWithBootm:_textH];
            }else if (sender.tag==12){
                self.keyBoardStatus = SSChatKeyBoardStatusAdd;
                self.currentBtn.selected = NO;
                self.currentBtn = sender;
                self.currentBtn.selected = YES;
                _mKeyBordView.mCoverView.hidden = YES;
                self.mTextView.hidden = NO;
                _mKeyBordView.type = KeyBordViewFouctionAdd;
                self.keyBoardHieght = kiPhoneX_Bottom_Height+SSChatKeyBordHeight;
                [self setNewSizeWithBootm:_textH];
            }  else {
                self.keyBoardStatus = SSChatKeyBoardStatusCustom;
                self.currentBtn = sender;
                self.currentBtn.selected = YES;
                self.keyBoardHieght = 0.0;
                [self setNewSizeWithBootm:SSChatTextHeight];
                [self buttonClickChatKeyBoardCustomButton:sender];
            }
            [self textViewDidChange:self.mTextView];
        }
            break;
            
            //在编辑文本的状态
        case SSChatKeyBoardStatusEdit:{
            if(sender.tag==10){
                self.keyBoardStatus = SSChatKeyBoardStatusVoice;
                self.currentBtn.selected = NO;
                self.currentBtn = sender;
                self.currentBtn.selected = YES;
                _mKeyBordView.mCoverView.hidden = NO;
                self.mTextView.hidden = YES;
                [self.mTextView endEditing:YES];
                [self setNewSizeWithBootm:SSChatTextHeight];
            }else if (sender.tag==11){
                self.keyBoardStatus = SSChatKeyBoardStatusSymbol;
                self.currentBtn.selected = NO;
                self.currentBtn = sender;
                self.currentBtn.selected = YES;
                _mKeyBordView.mCoverView.hidden = YES;
                [self.mTextView resignFirstResponder];
                self.keyBoardHieght = kiPhoneX_Bottom_Height+SSChatKeyBordHeight;
                _mKeyBordView.type = KeyBordViewFouctionSymbol;
                
            }else if(sender.tag==12) {
                self.keyBoardStatus = SSChatKeyBoardStatusAdd;
                self.currentBtn.selected = NO;
                self.currentBtn = sender;
                self.currentBtn.selected = YES;
                _mKeyBordView.mCoverView.hidden = YES;
                _mKeyBordView.type = KeyBordViewFouctionAdd;
                [self.mTextView endEditing:YES];
            } else {
                self.keyBoardStatus = SSChatKeyBoardStatusCustom;
                self.currentBtn.selected = NO;
                self.currentBtn = sender;
                self.currentBtn.selected = YES;
                _mKeyBordView.mCoverView.hidden = NO;
                [self setNewSizeWithBootm:SSChatTextHeight];
                [self buttonClickChatKeyBoardCustomButton:sender];
            }
        }
            break;
            
            //在选择表情的状态
        case SSChatKeyBoardStatusSymbol:{
            if(sender.tag==10){
                self.keyBoardStatus = SSChatKeyBoardStatusVoice;
                self.currentBtn.selected = NO;
                self.currentBtn = sender;
                self.currentBtn.selected = YES;
                _mKeyBordView.mCoverView.hidden = NO;
                self.mTextView.hidden = YES;
                self.keyBoardHieght = kiPhoneX_Bottom_Height;

                [self setNewSizeWithBootm:SSChatTextHeight];
            }else if (sender.tag==11){
                self.keyBoardStatus = SSChatKeyBoardStatusEdit;
                self.currentBtn.selected = NO;
                _mKeyBordView.mCoverView.hidden = NO;
                [self.mTextView becomeFirstResponder];
                
            }else if(sender.tag==12){
                self.keyBoardStatus = SSChatKeyBoardStatusAdd;
                self.currentBtn.selected = NO;
                self.currentBtn = sender;
                self.currentBtn.selected = YES;
                _mKeyBordView.mCoverView.hidden = YES;
                _mKeyBordView.type = KeyBordViewFouctionAdd;
            } else {
                self.keyBoardStatus = SSChatKeyBoardStatusCustom;
                self.currentBtn.selected = NO;
                self.currentBtn = sender;
                self.currentBtn.selected = YES;
                _mKeyBordView.mCoverView.hidden = NO;
                self.keyBoardHieght = kiPhoneX_Bottom_Height;
                [self setNewSizeWithBootm:SSChatTextHeight];
                [self buttonClickChatKeyBoardCustomButton:sender];
            }
        }
            
            break;
            
            //在选择其他功能的状态
        case SSChatKeyBoardStatusAdd:{
            if(sender.tag==10){
                self.keyBoardStatus = SSChatKeyBoardStatusVoice;
                self.currentBtn.selected = NO;
                self.currentBtn = sender;
                self.currentBtn.selected = YES;
                _mKeyBordView.mCoverView.hidden = NO;
                self.mTextView.hidden = YES;
                self.keyBoardHieght = kiPhoneX_Bottom_Height;

                [self setNewSizeWithBootm:SSChatTextHeight];
            }else if (sender.tag==11){
                self.keyBoardStatus = SSChatKeyBoardStatusSymbol;
                self.currentBtn.selected = NO;
                self.currentBtn = sender;
                self.currentBtn.selected = YES;
                _mKeyBordView.mCoverView.hidden = YES;
                self.mTextView.hidden = NO;
                self.keyBoardHieght = kiPhoneX_Bottom_Height+_mKeyBordView.height;
                _mKeyBordView.type = KeyBordViewFouctionSymbol;
            }else if(sender.tag==12){
                [self.mTextView becomeFirstResponder];
                _mKeyBordView.mCoverView.hidden = YES;
            } else {
                self.keyBoardStatus = SSChatKeyBoardStatusCustom;
                self.currentBtn.selected = NO;
                self.currentBtn = sender;
                self.currentBtn.selected = YES;
                _mKeyBordView.mCoverView.hidden = NO;
                self.keyBoardHieght = kiPhoneX_Bottom_Height;
                [self setNewSizeWithBootm:SSChatTextHeight];
                [self buttonClickChatKeyBoardCustomButton:sender];
            }
        }
            break;
            
            // 自定义状态
        case SSChatKeyBoardStatusCustom:{
            if(sender.tag==10){
                self.keyBoardStatus = SSChatKeyBoardStatusVoice;
                self.currentBtn.selected = NO;
                self.currentBtn = sender;
                self.currentBtn.selected = YES;
                self.mTextView.hidden = YES;
                _mKeyBordView.mCoverView.hidden = NO;
                self.keyBoardHieght = 0.0;
                [self setNewSizeWithBootm:SSChatTextHeight];
            }
            else if (sender.tag==11){
                self.keyBoardStatus = SSChatKeyBoardStatusSymbol;
                self.currentBtn.selected = NO;
                self.currentBtn = sender;
                self.currentBtn.selected = YES;
                _mKeyBordView.mCoverView.hidden = YES;
                _mKeyBordView.type = KeyBordViewFouctionSymbol;
                [self.mTextView resignFirstResponder];
                self.keyBoardHieght = kiPhoneX_Bottom_Height+SSChatKeyBordHeight;
                [self setNewSizeWithBootm:_textH];
            }
            else if (sender.tag==12){
                self.keyBoardStatus = SSChatKeyBoardStatusAdd;
                self.currentBtn.selected = NO;
                self.currentBtn = sender;
                self.currentBtn.selected = YES;
                _mKeyBordView.type = KeyBordViewFouctionAdd;
                _mKeyBordView.mCoverView.hidden = YES;
                self.keyBoardHieght = kiPhoneX_Bottom_Height+SSChatKeyBordHeight;
                [self setNewSizeWithBootm:_textH];
            } else {
                self.keyBoardStatus = SSChatKeyBoardStatusCustom;
                self.currentBtn = sender;
                self.currentBtn.selected = YES;
                self.keyBoardHieght = 0.0;
                [self setNewSizeWithBootm:SSChatTextHeight];
                [self buttonClickChatKeyBoardCustomButton:sender];
            }
        }
            break;
            
        default:
            break;
    }
    
}


//添加表情来了
-(void)setEmojiText:(NSObject *)emojiText{
    _emojiText = emojiText;
    
    //删除表情字符串
    if ([emojiText isEqual: DeleteButtonId]) {
        [[SSChartEmotionImages ShareSSChartEmotionImages] deleteEmtionString:_mTextView];
    }
    //系统自带表情直接拼接
    else if (![_emojiText isKindOfClass:[UIImage class]]) {
        [self.mTextView replaceRange:self.mTextView.selectedTextRange withText:(NSString *)_emojiText];
    }
    //其他的表情用可变字符来处理
    else {
        NSString * emtionString = [[SSChartEmotionImages ShareSSChartEmotionImages] emotionStringWithImg:(UIImage *)_emojiText];
        self.mTextView.text = [NSString stringWithFormat:@"%@%@",_mTextView.text, emtionString];
    }
    
    [self textViewDidChange:_mTextView];
}



//设置所有控件新的尺寸位置
-(void)setNewSizeWithBootm:(CGFloat)height{
   
    [self setNewSizeWithController];
    
    [UIView animateWithDuration:0.25 animations:^{
        self.mTextView.height = height;
        self.height = 8 + 8 + self.mTextView.height;
        
        self.mTextBtn.height = self.mTextView.height;
        self.mTextBtn.bottom = self.height-SSChatTBottomDistence;
        self.mTextView.top = 0;
        self.mLeftBtn.bottom = self.height-SSChatBBottomDistence;
        self.mAddBtn.bottom = self.height-SSChatBBottomDistence;
//        self.mSymbolBtn.bottom = self.mTextView.height-SSChatBBottomDistence;
        self.mSymbolBtn.centerY = self.mTextView.centerY;
        self.mKeyBordView.top = self.height;
        
        if(self.keyBoardStatus == SSChatKeyBoardStatusDefault ||
           self.keyBoardStatus == SSChatKeyBoardStatusVoice ||
           self.keyBoardStatus == SSChatKeyBoardStatusCustom){
            self.bottom = FYSCREEN_Height-kiPhoneX_Bottom_Height;
        }else{
            self.bottom = FYSCREEN_Height-self.keyBoardHieght;
        }
        
    } completion:^(BOOL finished) {
        [self.mTextView.superview layoutIfNeeded];
    }];
}

//设置键盘和表单位置
-(void)setNewSizeWithController{
    
    CGFloat changeTextViewH = fabs(_textH - SSChatTextHeight);
    if(self.mTextView.hidden == YES) changeTextViewH = 0;
    CGFloat changeH = _keyBoardHieght + changeTextViewH;
    
//    SSDeviceDefault *device = [SSDeviceDefault shareCKDeviceDefault];
    if(kiPhoneX_Bottom_Height != 0 && _keyBoardHieght!=0){
        changeH -= kiPhoneX_Bottom_Height;
    }
    
    if(_delegate && [_delegate respondsToSelector:@selector(SSChatKeyBoardInputViewHeight:changeTime:)]){
        [_delegate SSChatKeyBoardInputViewHeight:changeH changeTime:_changeTime];
    }
}

//拦截发送按钮
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    if(text.length==0){
        [[SSChartEmotionImages ShareSSChartEmotionImages] deleteEmtionString:self.mTextView];
        [self textViewDidChange:self.mTextView];
        return YES;
    }
    
    if ([text isEqualToString:@"\n"]) {
        [self startSendMessage];
        return NO;
    }
    
    return YES;
}

//开始发送消息
-(void)startSendMessage{
    NSString *message = [_mTextView.attributedText string];
    NSString *newMessage = [message stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if(message.length==0){
       
    }
    else if(_delegate && [_delegate respondsToSelector:@selector(onChatKeyBoardInputViewSendText:)]){
        [_delegate onChatKeyBoardInputViewSendText:newMessage];
    }
    
    _mTextView.text = @"";
    _textString = _mTextView.text;
    _mTextView.contentSize = CGSizeMake(_mTextView.contentSize.width, 30);
    [_mTextView setContentOffset:CGPointZero animated:YES];
    [_mTextView scrollRangeToVisible:_mTextView.selectedRange];
    _mKeyBordView.symbolView.footer.sendButton.enabled = NO;
    
    _textH = SSChatTextHeight;
    [self setNewSizeWithBootm:_textH];
}


//监听输入框的操作 输入框高度动态变化
- (void)textViewDidChange:(UITextView *)textView{
    
    _textString = textView.text;
    
    NSString *message = [_textString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if(message.length==0 || message==nil){
        _mKeyBordView.symbolView.footer.sendButton.enabled = NO;
    }else{
        _mKeyBordView.symbolView.footer.sendButton.enabled = YES;
    }

    
    //获取到textView的最佳高度
    NSInteger height = ceilf([textView sizeThatFits:CGSizeMake(textView.width, MAXFLOAT)].height);

    if(height>SSChatTextMaxHeight){
        height = SSChatTextMaxHeight;
        textView.scrollEnabled = YES;
    }
    else if(height<SSChatTextHeight){
        height = SSChatTextHeight;
        textView.scrollEnabled = NO;
    }
    else{
        textView.scrollEnabled = NO;
    }

    if(_textH != height){
        _textH = height;
        [self setNewSizeWithBootm:height];
    }
    else{
        [textView scrollRangeToVisible:NSMakeRange(textView.text.length, 2)];
    }
}


#pragma SSChatKeyBordSymbolViewDelegate 底部视图按钮点击回调
//发送200  多功能点击10+
-(void)fyChatFunctionBoardClickedItemWithTag:(NSInteger)tag type:(KeyBordViewFouctionType)type{
    if(tag==200){
        [self startSendMessage];
    }else if(tag<200 || tag>=2000){
        if(_delegate && [_delegate respondsToSelector:@selector(fyChatFunctionBoardClickedItemWithTag:)]){
            [_delegate fyChatFunctionBoardClickedItemWithTag:tag];
        }
    }
}

#pragma mark - SSChatKeyBordViewDelegate

//点击表情
- (void)SSChatKeyBordSymbolViewBtnClick:(NSObject *)emojiText {
    
    self.emojiText = emojiText;
}

- (void)SSChatKeyBordSymbolViewDidDeleteBackward:(BOOL)isBackward {
    
    [self.mTextView deleteBackward];
}
/**
 添加@ 用户
 
 @param userInfo 用户模型
 */
- (void)addMentionedUser:(UserInfo *)userInfo {
    self.mTextView.text = [NSString stringWithFormat:@"%@@%@ ",_mTextView.text, userInfo.nick];
    [self textViewDidChange:_mTextView];
}

// 自定义按钮事件（红包、抢庄、投注、发包）
- (void)buttonClickChatKeyBoardCustomButton:(UIButton *)sender
{
    if (FYConversationType_GROUP == self.chatType) {
        if (GroupTemplate_N04_RobNiuNiu == self.messageItem.type
            || GroupTemplate_N05_ErBaGang == self.messageItem.type
            || GroupTemplate_N06_LongHuDou == self.messageItem.type
            || GroupTemplate_N10_BagLottery == self.messageItem.type
            || GroupTemplate_N11_BagBagCow == self.messageItem.type
            || GroupTemplate_N14_BestNiuNiu == self.messageItem.type) {
            // 抢庄牛牛、二八杠、龙虎斗,包包彩,包包牛
            if(self.delegate && [self.delegate respondsToSelector:@selector(fyChatKeyBoardClickedCustomButtonRobNiuNiu:)]){
                [self.delegate fyChatKeyBoardClickedCustomButtonRobNiuNiu:self.statusOfRobNiuNiu];
            }
        } else if (GroupTemplate_N07_JieLong == self.messageItem.type) {
            // 接龙红包
            if(self.delegate && [self.delegate respondsToSelector:@selector(fyChatKeyBoardClickedCustomButtonSolitaire)]){
                [self.delegate fyChatKeyBoardClickedCustomButtonSolitaire];
            }
        } else {
            // 发红包
            if(self.delegate && [self.delegate respondsToSelector:@selector(fyChatKeyBoardClickedCustomButtonRedPacket:)]){
                [self.delegate fyChatKeyBoardClickedCustomButtonRedPacket:sender];
            }
        }
    } else {
        // 个人聊天没有此操作
    }
}

@end

