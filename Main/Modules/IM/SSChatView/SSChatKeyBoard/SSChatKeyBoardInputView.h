//
//  SSChatKeyBoardInputView.h
//  SSChatView
//
//  Created by soldoros on 2018/9/25.
//  Copyright © 2018年 soldoros. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Define.h"
#import "SSDeviceDefault.h"
//#import "UUProgressHUD.h"
#import "UUAVAudioPlayer.h"
#import "SSChatKeyBoardDatas.h"
#import "SSChatKeyBordView.h"
#import "RecordButton.h"
/**
 聊天界面底部的输入框视图
 */

#define SSChatKeyBoardInputViewH      49     //输入部分的高度
#define SSChatKeyBordBottomHeight     220    //底部视图的高度

// 键盘总高度
#define SSChatKeyBordHeight   SSChatKeyBoardInputViewH + SSChatKeyBordBottomHeight

#define SSChatLineHeight        0.5          //线条高度
#define SSChatBotomTop          FYSCREEN_Height-SSChatBotomHeight-kiPhoneX_Bottom_Height                    //底部视图的顶部
#define SSChatBtnSize           25           //按钮的大小
#define SSChatLeftDistence      5            //左边间隙
#define SSChatRightDistence     5            //左边间隙
#define SSChatBtnDistence       10           //控件之间的间隙
#define SSChatTextHeight        33           //输入框的高度
#define SSChatTextMaxHeight     83           //输入框的最大高度
#define SSChatTextWidth1      FYSCREEN_Width - (SSChatBtnSize * 2 + 4 * SSChatBtnDistence)   //输入框的宽度
#define SSChatTextWidth2      FYSCREEN_Width - (3 * SSChatBtnSize + 5 * SSChatBtnDistence)   //输入框的宽度

#define SSChatTBottomDistence   8            //输入框上下间隙
#define SSChatBBottomDistence   12         //按钮上下间隙

@class SSChatKeyBoardInputView;


@protocol SSChatKeyBoardInputViewDelegate <NSObject>

// 改变输入框的高度，并让控制器弹出键盘
- (void)SSChatKeyBoardInputViewHeight:(CGFloat)keyBoardHeight changeTime:(CGFloat)changeTime;

// 发送文本信息
- (void)onChatKeyBoardInputViewSendText:(NSString *)text;

// 发送语音消息
- (void)SSChatKeyBoardInputViewBtnClick:(SSChatKeyBoardInputView *)view sendVoice:(NSData *)voice time:(NSInteger)second;

// 多功能视图按钮点击回调
- (void)fyChatFunctionBoardClickedItemWithTag:(NSInteger)tag;

// 发送红包
- (void)fyChatKeyBoardClickedCustomButtonRedPacket:(UIButton *)sender;
// 抢庄牛牛、接龙操作
- (void)fyChatKeyBoardClickedCustomButtonSolitaire;
- (void)fyChatKeyBoardClickedCustomButtonRobNiuNiu:(NSInteger)statusOfRobNiuNiu;

@end


@interface SSChatKeyBoardInputView : UIView<UITextViewDelegate,AVAudioRecorderDelegate,SSChatKeyBordViewDelegate> 

@property (nonatomic,assign) id<SSChatKeyBoardInputViewDelegate> delegate;

// 当前的编辑状态（默认 语音 编辑文本 发送表情 其他功能）
@property (nonatomic,assign)SSChatKeyBoardStatus keyBoardStatus;

// 键盘或者 表情视图 功能视图的高度
@property (nonatomic,assign) CGFloat changeTime;
@property (nonatomic,assign) CGFloat keyBoardHieght;

// 传入底部视图进行frame布局
@property (nonatomic,strong) SSChatKeyBordView   *mKeyBordView;

// 顶部线条
//@property (nonatomic,strong) UIView *topLine;

// 当前点击的按钮  左侧按钮 表情按钮  添加按钮
@property (nonatomic,strong) UIButton *currentBtn;
@property (nonatomic,strong) UIButton *mLeftBtn;
@property (nonatomic,strong) UIButton *mSymbolBtn;
@property (nonatomic,strong) UIButton *mAddBtn;
//
@property (nonatomic,strong) UIButton *mCustomBtn;

// 输入框背景 输入框 缓存输入的文字
@property (nonatomic,strong) RecordButton     *mTextBtn;
@property (nonatomic,strong) UITextView   *mTextView;
@property (nonatomic,strong) NSString     *textString;
// 输入框的高度
@property (nonatomic,assign) CGFloat   textH;

// 添加表情
@property (nonatomic,strong) NSObject       *emojiText;

// 录音相关
@property (nonatomic,assign) BOOL      isbeginVoiceRecord;
@property (nonatomic,strong) NSString  *docmentFilePath;


@property (nonatomic, strong) UILabel         *placeHold;
@property (nonatomic, strong) UIButton  *btnSendMessage;
@property (nonatomic, strong) UIButton  *btnChangeVoiceState;

/* */
@property(nonatomic, strong) MessageItem *messageItem;
// 会话类型（单聊、群聊）
@property (nonatomic, assign) FYChatConversationType chatType;
// 群状态（抢庄牛牛、二八杠、龙虎斗、接龙红包）
@property (nonatomic, assign) NSInteger statusOfRobNiuNiu;


- (instancetype)initWithChatType:(FYChatConversationType)chatType messageItem:(MessageItem *)messageItem;

// 键盘归位
-(void)SetSSChatKeyBoardInputViewEndEditing;

/**
 * 添加@ 用户
 * @param userInfo 用户模型
 */
- (void)addMentionedUser:(UserInfo *)userInfo;


@end








