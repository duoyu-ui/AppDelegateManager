//
//  FYLaunchristPageFooterView.m
//  ProjectCSHB
//
//  Created by Tom on 2020/1/14.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "FYLaunchristPageFooterView.h"
#import "FYLoginView.h"
@interface FYLaunchristPageFooterView()
///微信登录
@property (nonatomic ,strong)FYLoginView *weiXinLoginView;
///游客登录
@property (nonatomic ,strong)FYLoginView *touristsLoginView;
@property (nonatomic, strong) UIStackView *stackView;
@end
@implementation FYLaunchristPageFooterView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(20);
            make.right.mas_equalTo(-20);
            make.top.mas_equalTo(30);
            make.height.mas_equalTo(20);
        }];
        UIStackView *stackView = [[UIStackView alloc]init];
        stackView.axis = UILayoutConstraintAxisHorizontal;
        stackView.distribution = UIStackViewDistributionFillEqually;
        stackView.spacing = 30;
        stackView.alignment = UIStackViewAlignmentFill;
        [self addSubview:stackView];
        self.stackView = stackView;
        [stackView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(150);
            make.height.mas_equalTo(60);
//            make.center.equalTo(self);
            make.centerX.equalTo(self);
            make.top.mas_equalTo(self.textView.mas_bottom).mas_offset(20);
        }];
        self.hidden = YES;
        [self.weiXinLoginView setImg:[UIImage imageNamed:@"weixin"] title:NSLocalizedString(@"微信登录", nil)];
        [self.touristsLoginView setImg:[UIImage imageNamed:@"followerPlayers"] title:NSLocalizedString(@"游客登录", nil)];
    }
    return self;
}

-(void)updateBottomWeiXingLoginButton{
    NSUserDefaults *userDefault=[NSUserDefaults standardUserDefaults];
    NSInteger isenable = [[userDefault valueForKey:@"enableFlag"] integerValue];
    if (isenable == 1) {
        self.hidden = NO;
        if (self.weiXinLoginView.superview == nil) {
            [self.stackView addArrangedSubview:self.weiXinLoginView];
            WeakSelf
            self.weiXinLoginView.block = ^{
                if ([weakSelf.delegate respondsToSelector:@selector(didSeledWihtIndx:)]) {
                    [weakSelf.delegate didSeledWihtIndx:0];
                }
            };
        }
        
    }else{
        if (self.weiXinLoginView.superview) {
            [self.weiXinLoginView removeFromSuperview];
        }
    }
    
}

-(void)updateBottomTouristsLoginButton{
    if (self.touristsLoginView.superview) {
        [self.touristsLoginView removeFromSuperview];
    }
    [self updateBottomWeiXingLoginButton];
    BOOL isShow=[[[AppModel shareInstance].commonInfo valueForKey:@"try_play_flag"] boolValue];
    if (isShow) {
        self.hidden = NO;
        if (self.touristsLoginView.superview == nil) {
            [self.stackView addArrangedSubview:self.touristsLoginView];
            WeakSelf
            self.touristsLoginView.block = ^{
                if ([weakSelf.delegate respondsToSelector:@selector(didSeledWihtIndx:)]) {
                    [weakSelf.delegate didSeledWihtIndx:1];
                };
            };
        }
    }
//    else{
//        if (self.touristsLoginView.superview) {
//            [self.touristsLoginView removeFromSuperview];
//        }
//    }
}

- (FYLoginView *)weiXinLoginView{
    if (!_weiXinLoginView) {
        _weiXinLoginView = [[FYLoginView alloc]init];
        [_weiXinLoginView setImg:[UIImage imageNamed:@"weixin"] title:NSLocalizedString(@"微信登录", nil)];
    }
    return _weiXinLoginView;
}
- (FYLoginView *)touristsLoginView{
    if (!_touristsLoginView) {
       _touristsLoginView = [[FYLoginView alloc]init];
        [_touristsLoginView setImg:[UIImage imageNamed:@"followerPlayers"] title:NSLocalizedString(@"游客登录", nil)];
    }
    return _touristsLoginView;
}

-(FYTextLineView *)textView{
    if (!_textView) {
        _textView=[FYTextLineView new];
        [self addSubview:_textView];
    }
    return _textView;
}
@end

@implementation FYTextLineView

-(UILabel *)label{
    if (!_label) {
        _label = [UILabel new];
        _label.font = [UIFont systemFontOfSize:14];
        _label.textColor = [UIColor grayColor];
        [self addSubview:_label];
        UIView *left= [UIView new];
        UIView *right = [UIView new];
        left.backgroundColor = [UIColor colorWithWhite:0.85 alpha:1];
        right.backgroundColor = [UIColor colorWithWhite:0.85 alpha:1];
        [self addSubview:left];
        [self addSubview:right];
        [_label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
        }];
        [left mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self);
            make.height.mas_equalTo(1);
            make.right.mas_equalTo(_label.mas_left).mas_offset(-10);
            make.centerY.mas_equalTo(_label.mas_centerY);
        }];
        [right mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_label.mas_right).mas_offset(10);
            make.height.mas_equalTo(1);
            make.right.mas_equalTo(self);
            make.centerY.mas_equalTo(_label.mas_centerY);
        }];
    }
    return _label;
}

@end
