//
//  EnvelopAnimationView.m
//  Project
//
//  Created by mini on 2018/8/13.
//  Copyright © 2018年 CDJay. All rights reserved.
//

#import "RedEnvelopeAnimationView.h"
//#import "EnvelopBackImg.h"


@interface RedEnvelopeAnimationView()<CAAnimationDelegate>
@property (nonatomic , strong) UIImageView *redImageView;
//@property (nonatomic,strong) EnvelopBackImg *redView;
@property (nonatomic,strong) UIControl *backControl;
@property (nonatomic,strong) UIImageView *headIcon;
@property (nonatomic,strong) UIButton *openBtn;
@property (nonatomic,strong) UILabel *redDescLabel;
@property (nonatomic,strong) UILabel *contentLabel;
@property (nonatomic,strong) UIButton *detailButton;
@property (nonatomic,strong) UIButton *closeButton;
@property (nonatomic,strong) UILabel *nameLabel;
@property (nonatomic , strong) RedEnvelopeModel *model;
@property (nonatomic , strong) NSDictionary *errorDict;
@end

@implementation RedEnvelopeAnimationView


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {

        [self initSubviews];
    }
    return self;
}

#pragma mark - subView
- (void)initSubviews {
    
    _backControl = [[UIControl alloc]initWithFrame:self.bounds];
    [self addSubview:_backControl];
    _backControl.backgroundColor = ApHexColor(@"#FFFFFF", 0.8);
    [_backControl addTarget:self action:@selector(onbackControl) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.redImageView];
    [self addSubview:self.closeButton];
    [self.redImageView addSubview:self.openBtn];
    [self.redImageView addSubview:self.headIcon];
    [self.redImageView addSubview:self.nameLabel];
    [self.redImageView addSubview:self.detailButton];
    [self.redImageView addSubview:self.contentLabel];
    [self.redImageView addSubview:self.redDescLabel];
    CGFloat pro = 1387.0 / 861.0;
    CGFloat imageViewW = SCREEN_WIDTH * 0.80;
    CGFloat imageViewH = imageViewW * pro;
    CGFloat btnSize = imageViewW * 0.3;
    [self.redImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(imageViewW, imageViewH));
    }];
    [self.closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(35);
        make.centerX.equalTo(self);
        make.top.equalTo(self.redImageView.mas_bottom).offset(30);
    }];
    [self.openBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(btnSize);
        make.centerX.equalTo(self.redImageView.mas_centerX);
        make.centerY.equalTo(self.redImageView.mas_bottom).offset(-imageViewH * 0.2);
    }];
    [self.headIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(imageViewW * 0.1);
        make.centerX.equalTo(self.redImageView);
        make.top.mas_equalTo(70);
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.redImageView);
        make.top.equalTo(self.headIcon.mas_bottom).offset(20);
        make.width.mas_equalTo(imageViewW * 0.9);
    }];
    [self.detailButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.redImageView);
        make.height.mas_equalTo(20);
        make.bottom.equalTo(self.redImageView.mas_bottom).offset(-20);
        make.width.mas_equalTo(110);
    }];
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.redImageView);
        make.top.equalTo(self.nameLabel.mas_bottom).offset(15);
        make.width.mas_equalTo(imageViewW * 0.9);
    }];
    [self.redDescLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.redImageView);
        make.top.equalTo(self.contentLabel.mas_bottom).offset(10);
        make.width.mas_equalTo(imageViewW * 0.9);
    }];
}

- (void)actionCloseButton {
    [self disMissRedView];
}

-(void)tapActionView:(UITapGestureRecognizer *)tap {
    [self disMissRedView];
  
}
- (void)animation {
    [self.openBtn setBackgroundImage:[UIImage imageNamed:@"mees_money_icon"] forState:UIControlStateNormal];
    [self.openBtn.layer addAnimation:[self confirmViewRotateInfo] forKey:@"transform"];
}

- (void)remoAnimation {
    [self.openBtn.layer removeAllAnimations];
    [self disMissRedView];
    if (self.animationBlock) {
        self.animationBlock();
    }
}

- (void)actionDetail {
    [self disMissRedView];
    
    if (self.detailBlock) {
        self.detailBlock();
    }
}

- (void)openRedPacketAction {
    [self animation];
    if (self.openBtnBlock) {
        self.openBtnBlock();
    }
}

- (void)showInView:(UIView *)view{
    if (self == nil) {
        return;
    }
    self.redImageView.transform = CGAffineTransformMakeScale(0.4, 0.4);
    self.redImageView.alpha = 0.0;
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    _backControl.alpha = 0.0;
    [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:0.5 options:0 animations:^{
        // 放大
        self.redImageView.transform = CGAffineTransformMakeScale(1, 1);
        self->_backControl.alpha = 0.6;
        self.redImageView.alpha = 1.0;
        
    } completion:nil];
    
}

- (CAKeyframeAnimation *)confirmViewRotateInfo{
    CAKeyframeAnimation *theAnimation = [CAKeyframeAnimation animation];
    
    theAnimation.values = [NSArray arrayWithObjects:
                           [NSValue valueWithCATransform3D:CATransform3DMakeRotation(0, 0, 0.5, 0)],
                           [NSValue valueWithCATransform3D:CATransform3DMakeRotation(M_PI, 0, 0.5, 0)],
                           [NSValue valueWithCATransform3D:CATransform3DMakeRotation(M_PI*2, 0, 0.5, 0)],
                           nil];
    
    theAnimation.cumulative = YES;
    theAnimation.duration = 0.9f;
    theAnimation.repeatCount = 100;
    theAnimation.removedOnCompletion = YES;
    theAnimation.fillMode = kCAFillModeForwards;
    theAnimation.delegate = self;
    
    return theAnimation;
}

//- (NSString *)typeString:(NSInteger)type{
//    switch (type) {
//        case 0:
//            return NSLocalizedString(@"福利红包", nil);
//            break;
//        case 1:
//            return NSLocalizedString(@"扫雷红包", nil);
//            break;
//        case 2:
//            return NSLocalizedString(@"牛牛红包", nil);
//            break;
//        case 3:
//            return NSLocalizedString(@"禁抢红包", nil);
//            break;
//        case 4:
//            return NSLocalizedString(@"比分红包", nil);
//            break;
//        case 5:
//            return NSLocalizedString(@"比分红包", nil);
//            break;
//        case 7:
//            return NSLocalizedString(@"接龙红包", nil);
//            break;
//        case 8:
//            return NSLocalizedString(@"二人牛牛红包", nil);
//            break;
//        case 9:
//            return NSLocalizedString(@"超级扫雷红包", nil);
//            break;
//        default:
//            break;
//    }
//    return nil;
//}

- (void)updateView:(id)obj response:(id)response rpOverdueTime:(NSString *)rpOverdueTime {

    self.model = [RedEnvelopeModel mj_objectWithKeyValues:obj];
  
    [self.headIcon cd_setImageWithURL:[NSURL URLWithString:[NSString cdImageLink:self.model.avatar]] placeholderImage:[UIImage imageNamed:@"user-default"]];
    
    NSString *nickName=[[AppModel shareInstance] getFriendName:self.model.userId];
    if (nickName.length < 1) {
        nickName = self.model.nick;
    }
    self.nameLabel.text = nickName;
    
    if (response != nil) {//红包错误
        if (GroupTemplate_N10_BagLottery == self.model.type) {
            self.contentLabel.font = [UIFont systemFontOfSize:18];
            self.contentLabel.text = [response stringForKey:NET_REQUEST_KEY_MESS_ALTER];
            self.openBtn.hidden = YES;
            [self.openBtn.layer removeAllAnimations];
            self.redDescLabel.hidden = YES;
            return;
        } else {
            self.contentLabel.font = [UIFont systemFontOfSize:18];
            if (self.model.status == 1) {
                self.contentLabel.text = NSLocalizedString(@"红包已抢完", nil);
            } else {
                self.contentLabel.text = NSLocalizedString(@"发包流水,抢包流水不符合要求", nil);
            }
            self.openBtn.hidden = YES;
            [self.openBtn.layer removeAllAnimations];
            self.redDescLabel.hidden = YES;
            return;
        }
    } else {
        self.contentLabel.text = [self contentType:self.model.type status:self.model.status left:self.model.left time:self.model.exceptOverdueTimes overFlag:self.model.overFlag];
        self.redDescLabel.hidden = [self descLabWithtType:self.model.type left:self.model.left overFlag:self.model.overFlag];
    }
    
    if (self.model.type == 3){ // 禁抢红包
        self.openBtn.hidden = YES;
        self.redDescLabel.text = NSLocalizedString(@"红包已抢完", nil);
    } else {
        self.openBtn.hidden = [self hiddenWithType:self.model.type status:self.model.status left:self.model.left overFlag:self.model.overFlag];
        self.redDescLabel.text = [self textWithtType:self.model.type status:self.model.status];
    }
}

- (NSString *)contentType:(NSInteger)type status:(NSInteger)status left:(NSInteger)left time:(NSInteger)time overFlag:(BOOL)overFlag{
    if (GroupTemplate_N10_BagLottery == type) {
        if (status == 1) {
            return NSLocalizedString(@"红包已抢", nil);
        } else if (status == 2) {
            return NSLocalizedString(@"红包已抢完", nil);
        } else if (status == 3) {
            return NSLocalizedString(@"红包已过期", nil);
        } else {
            return NSLocalizedString(@"恭喜发财，大吉大利", nil);
        }
    } else {
        if (status == 1) {//正常
            if (left == 0 || time <= 0 || overFlag == YES) {
                return NSLocalizedString(@"红包已抢完", nil);
            } else {
                switch (type) {
                    case 2:
                    case 4:
                    case 5:
                    case 6:
                    case 8:
                        return NSLocalizedString(@"抢包金额不归入账户", nil);
                        break;
                    default:
                        return NSLocalizedString(@"恭喜发财，大吉大利", nil);
                        break;
                }
            }
        } else {//游戏截止
            return NSLocalizedString(@"红包已抢完", nil);
        }
    }
}
- (NSString *)textWithtType:(NSInteger)type status:(NSInteger)status{
    if (status == 2) {
        return @"";
    }else{
        switch (type) {
            case 2:
            case 4:
            case 5:
            case 6:
            case 8:
                return NSLocalizedString(@"仅做点数比较使用", nil);
                break;
            default:
                return @"";
                break;
        }
    }
}
- (BOOL)descLabWithtType:(NSInteger)type left:(NSInteger)left overFlag:(BOOL)overFlag{
    switch (type) {
        case 2:
        case 4:
        case 5:
        case 6:
        case 8:
            if (left == 0 || overFlag == YES) {
                return YES;
            }else{
                return NO;
            }
            break;
        default:
            return YES;
            break;
    }
}
///开按钮 是否隐藏或者显示
- (BOOL)hiddenWithType:(NSInteger)type status:(NSInteger)status left:(NSInteger)left overFlag:(BOOL)overFlag{
    if (GroupTemplate_N10_BagLottery == type) {
        if (overFlag == YES) {
            return YES;
        } else {
            if (status == 0) {
                return NO;
            } else {
                return YES;
            }
        }
        return NO;
    } else {
        if (overFlag == YES) {
            return YES;
        }else{
            if (status == 1 && left != 0) {
                return NO;
            }else{
                return YES;
            }
        }
    }
}

- (void)onbackControl {
    [self disMissRedView];

}

- (void)disMissRedView {

    if (self.disMissRedBlock) {
        self.disMissRedBlock();
    }
    [UIView animateWithDuration:0.25 animations:^{
        self.redImageView.transform = CGAffineTransformMakeScale(0.2, 0.2);
        self.redImageView.alpha = 0.0;
    } completion:^(BOOL finished) {
        if (finished) {
            [self removeFromSuperview];
        }
    }];
}
- (UIImageView *)redImageView{
    if (!_redImageView) {
        _redImageView = [[UIImageView alloc]init];
        [_redImageView setImage:[UIImage imageNamed:@"qianghbaoBg_icon"]];
        _redImageView.contentMode = UIViewContentModeScaleToFill;
        _redImageView.userInteractionEnabled = YES;
    }
    return _redImageView;
}
- (UIButton *)openBtn{
    if (!_openBtn) {
        _openBtn = [[UIButton alloc]init];
        [_openBtn setBackgroundImage:[UIImage imageNamed:@"mess_open"] forState:UIControlStateNormal];
        [_openBtn addTarget:self action:@selector(openRedPacketAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _openBtn;
}
- (UIImageView *)headIcon{
    if (!_headIcon) {
        _headIcon = [[UIImageView alloc]init];
        _headIcon.layer.masksToBounds = YES;
        _headIcon.layer.cornerRadius = 3;
    }
    return _headIcon;
}
- (UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc]init];
        _nameLabel.textColor = HexColor(@"#FAE3B7");
        _nameLabel.font = [UIFont systemFontOfSize:16];
        _nameLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _nameLabel;
}
- (UIButton *)closeButton{
    if (!_closeButton) {
        _closeButton = [[UIButton alloc]init];
        [_closeButton setBackgroundImage:[UIImage imageNamed:@"red_closeIcon"] forState:UIControlStateNormal];
        [_closeButton addTarget:self action:@selector(actionCloseButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeButton;
}
- (UIButton *)detailButton{
    if (!_detailButton) {
        _detailButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [_detailButton setTitle:NSLocalizedString(@"查看领取详情 >", nil) forState:UIControlStateNormal];
        [_detailButton setTitleColor:HexColor(@"#FAE3B7") forState:UIControlStateNormal];
        _detailButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [_detailButton addTarget:self action:@selector(actionDetail) forControlEvents:UIControlEventTouchUpInside];
    }
    return _detailButton;
}
- (UILabel *)contentLabel{
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc]init];
        _contentLabel.font = [UIFont systemFontOfSize:24];
        _contentLabel.textColor = HexColor(@"#FAE3B7");
        _contentLabel.text = NSLocalizedString(@"恭喜发财，大吉大利", nil);
        _contentLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _contentLabel;
}
- (UILabel *)redDescLabel{
    if (!_redDescLabel) {
        _redDescLabel = [[UILabel alloc]init];
        _redDescLabel.font = [UIFont systemFontOfSize:15];
        _redDescLabel.textAlignment = NSTextAlignmentCenter;
        _redDescLabel.textColor = HexColor(@"#FAE3B7");
        _redDescLabel.hidden = YES;
    }
    return _redDescLabel;
}
@end
@implementation RedEnvelopeModel
@end
