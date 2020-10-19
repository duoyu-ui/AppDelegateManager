//
//  FYChatBaseCell.m
//  SSChatView
//
//  Created by soldoros on 2018/10/9.
//  Copyright © 2018年 soldoros. All rights reserved.
//

#import "FYChatBaseCell.h"
#import "FYIMKitUtil.h"
#import "FYFriendName.h"

@implementation FYChatBaseCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        // Remove touch delay for iOS 7
        for (UIView *view in self.subviews) {
            if([view isKindOfClass:[UIScrollView class]]) {
                ((UIScrollView *)view).delaysContentTouches = NO;
                break;
            }
        }
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = HexColor(@"#EDEDED");
        self.contentView.backgroundColor = HexColor(@"#EDEDED");
        
        [self initChatCellUI];
    }
    
    return self;
}


- (void)initChatCellUI {

    // 创建时间
    _mMessageTimeLab = [UILabel new];
    _mMessageTimeLab.bounds = CGRectMake(0, 0, SSChatTimeWidth, SSChatTimeHeight);
    _mMessageTimeLab.top = SSChatTimeTopOrBottom;
    _mMessageTimeLab.centerX = FYSCREEN_Width*0.5;
    [self.contentView addSubview:_mMessageTimeLab];
    _mMessageTimeLab.textAlignment = NSTextAlignmentCenter;
    _mMessageTimeLab.font = [UIFont systemFontOfSize:SSChatTimeFont];
    _mMessageTimeLab.textColor = [UIColor whiteColor];
    _mMessageTimeLab.backgroundColor = [UIColor colorWithRed:0.788 green:0.788 blue:0.788 alpha:1.000];
    _mMessageTimeLab.clipsToBounds = YES;
    _mMessageTimeLab.layer.cornerRadius = 3;
    
    
    // 创建头像
    UIImage *defaultImage = [UIImage imageNamed:@"user-default"];
    _mHeaderImgView = [[UIImageView alloc] initWithImage:defaultImage];
    _mHeaderImgView.backgroundColor =  [UIColor brownColor];
    _mHeaderImgView.tag = 10;
    [self.contentView addSubview:_mHeaderImgView];
     _mHeaderImgView.layer.cornerRadius = 5;
    _mHeaderImgView.clipsToBounds = YES;
    _mHeaderImgView.userInteractionEnabled = YES;
    
    //点击手势
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onHeaderImageClick:)];
    [_mHeaderImgView addGestureRecognizer:tapGesture];
    
    // 长按手势
    UILongPressGestureRecognizer *longGesture =  [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longGestureAction:)];
    longGesture.minimumPressDuration = 0.5;
    [_mHeaderImgView addGestureRecognizer:longGesture];
    
    
    // 创建昵称
    _nicknameLabel = [UILabel new];
    _nicknameLabel.bounds = CGRectMake(FYChatIconLeftOrRight*2 + SSChatIconWH,SSChatCellTopOrBottom, FYChatNameWidth, FYChatNameHeight);
    [self.contentView addSubview:_nicknameLabel];
    _nicknameLabel.textAlignment = NSTextAlignmentLeft;
    _nicknameLabel.font = [UIFont systemFontOfSize:SSChatTimeFont];
    _nicknameLabel.textColor = [UIColor darkGrayColor];
    
    // 背景按钮
    _bubbleBackView = [[UIImageView alloc] initWithFrame:CGRectZero];
    UITapGestureRecognizer *tap =
    [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bubbleBackViewAction:)];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    [_bubbleBackView addGestureRecognizer:tap];
    _bubbleBackView.userInteractionEnabled = YES;
    [self.contentView addSubview:_bubbleBackView];
    
    // 菊花
    _traningActivityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    [self.contentView addSubview:_traningActivityIndicator];
    _traningActivityIndicator.color = [UIColor darkGrayColor];
    _traningActivityIndicator.hidden = YES;
    
    // 高度 45 + 10 + 名称(12) + 4 + 消息内容高度（？）+ 10
    _errorBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    [_errorBtn setBackgroundImage:[UIImage imageNamed:@"message_ic_warning"] forState:UIControlStateNormal];
    _errorBtn.hidden = YES;
    [_errorBtn addTarget:self action:@selector(onErrorBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_errorBtn];
    
}


- (void)onErrorBtn {
    if(self.delegate && [self.delegate respondsToSelector:@selector(onErrorBtnCell:)]){
        [self.delegate onErrorBtnCell:self.model.message];
    }
}


- (BOOL)canBecomeFirstResponder{
    return YES;
}


-(void)setModel:(FYMessagelLayoutModel *)model
{
    _model = model;
    
    _mMessageTimeLab.hidden = !model.message.showTime;
    _mMessageTimeLab.text = [FYIMKitUtil showTime:model.message.timestamp/1000 showDetail:YES];
    [_mMessageTimeLab sizeToFit];
    _mMessageTimeLab.height = SSChatTimeHeight;
    _mMessageTimeLab.width += 20;
    _mMessageTimeLab.centerX = FYSCREEN_Width*0.5;
    _mMessageTimeLab.top = SSChatTimeTopOrBottom;
    
    self.nicknameLabel.frame = model.nickNameRect;
    if (model.message.messageFrom == FYMessageDirection_SEND) {
        self.nicknameLabel.text = @"";
    } else {
        NSString *nickName=[FYFriendName getName:model.message.user.userId];
        if (nickName.length>0) {
            self.nicknameLabel.text = nickName;
        }else{
            self.nicknameLabel.text = [self loadUserFriendNickWithMessage:model.message];
        }
    }
    
    self.mHeaderImgView.frame = model.headerImgRect;
    
    // 头像设置
    if ([model.message.user.avatar hasPrefix:@"http"]) {
        [self.mHeaderImgView cd_setImageWithURL:model.message.user.avatar placeholder:@"user-default"];
    }else {
        self.mHeaderImgView.hidden = YES;
    }
    
    // 接收
    if (model.message.messageFrom == FYMessageDirection_RECEIVE) {
        _nicknameLabel.textAlignment = NSTextAlignmentLeft;
    } else {
        _nicknameLabel.textAlignment = NSTextAlignmentRight;
    }
}


/// 加载好友备注名
- (NSString *)loadUserFriendNickWithMessage:(FYMessage *)message {
    FYContacts *sesstion = [[IMSessionModule sharedInstance] getSessionWithUserId:message.user.userId];
    if (sesstion.friendNick.length > 0 && ![sesstion.friendNick containsString:@"null"]) {
        return sesstion.friendNick;
    }else {
        return message.user.nick;
    }
}


#pragma mark - Action

/// 消息按钮
-(void)buttonPressed:(UIImageView *)sender
{
    
}

/// 点击头像
- (void)onHeaderImageClick:(id)sender {
    if(self.delegate && [self.delegate respondsToSelector:@selector(didTapCellChatHeaderImg:)]){
        [self.delegate didTapCellChatHeaderImg:self.model.message];
    }
}

// 头像长按手势
- (void)longGestureAction:(UILongPressGestureRecognizer *)longPressGesture {
    // 当识别到长按手势时触发(长按时间到达之后触发)
    if (UIGestureRecognizerStateBegan == longPressGesture.state) {
        if(self.delegate && [self.delegate respondsToSelector:@selector(didLongPressCellChatHeaderImg:)]){
            [self.delegate didLongPressCellChatHeaderImg:self.model.message.user];
        }
    }
}

// 点击消息背景事件
-(void)bubbleBackViewAction:(UIImageView *)sender{
    if(self.delegate && [self.delegate respondsToSelector:@selector(didTapMessageCell:)]){
        [self.delegate didTapMessageCell:self.model.message];
    }
}

@end
