//
//  FYRedEnvelopeCoreTableHeader.m
//  ProjectCSHB
//
//  Created by Tom on 2020/6/22.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "FYRedEnvelopeCoreTableHeader.h"

@implementation FYRedEnvelopeCoreTableHeader

/// 刷新红包信息
- (void)refreshWithDetailModel:(id)detailModel sumMoney:(CGFloat)sumMoney money:(NSString *)money
{
    // TODO: 创建子类并在子类中处理
}


#pragma mark - Timer

///倒计时
- (void)scheduledTimerCountDown
{
    [self.timer invalidate];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (void)timerAction
{
    self.overdueTimes -= 1;
    if (self.overdueTimes <= 0) {
        NSString *text = NSLocalizedString(@"本次红包游戏已截止", nil);
        CGSize sz = [text textSizeWithFont:[UIFont systemFontOfSize:14] limitWidth:kScreenWidth - 40];
        self.timeLab.text = text;
        [self.timer invalidate];
        [self.timeBgView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@(sz.width + 35));
        }];
    } else {
        NSString *text = [NSString stringWithFormat:NSLocalizedString(@"距离抢包结束: %zd秒", nil),self.overdueTimes];
        CGSize sz = [text textSizeWithFont:[UIFont systemFontOfSize:14] limitWidth:kScreenWidth - 40];
        self.timeLab.text = text;
        [self.timeBgView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@(sz.width + 35));
        }];
    }
}


#pragma mark - Life Cycle

- (instancetype)initWithFrame:(CGRect)frame type:(GroupTemplateType)type
{
    self = [super initWithFrame:frame];
    if (self) {
        _type = type;
        [self setSubViews];
    }
    return self;
}

+ (CGFloat)headerHeight:(GroupTemplateType)type
{
    if (GroupTemplate_N01_Bomb == type
        || GroupTemplate_N03_JingQiang == type
        || GroupTemplate_N09_SuperBobm == type) {
        return 270.0f;
    }
    return 230.0f;
}

- (void)setSubViews
{
    self.backgroundColor = HexColor(@"#FFFFFF");
    [self addSubview:self.avatarImgView];
    [self addSubview:self.nickLab];
    [self addSubview:self.lineView];
    [self addSubview:self.lineView1];
    [self addSubview:self.lineView2];
    [self addSubview:self.moneyNumLab];
    [self addSubview:self.centerLab];
    [self addSubview:self.timeBgView];
    [self addSubview:self.moneyLab];
    [self addSubview:self.leiLab];
    [self.timeBgView addSubview:self.timeImgView];
    [self.timeBgView addSubview:self.timeLab];
    [self addSubview:self.testimonialsImgView];
    [self.testimonialsImgView addSubview:self.lhhLab];
    
    [self.nickLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(35);
        make.centerX.equalTo(self.mas_centerX).offset(15);
    }];
    [self.moneyLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nickLab.mas_bottom).offset(15);
        make.centerX.equalTo(self);
        make.height.mas_equalTo(0);
    }];
    [self.avatarImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.nickLab);
        make.right.equalTo(self.nickLab.mas_left).offset(-10);
        make.width.height.mas_equalTo(20);
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self);
        make.height.mas_equalTo(0.5);
    }];
    [self.lineView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.height.mas_equalTo(3);
        make.bottom.mas_equalTo(-35);
    }];
    [self.leiLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.bottom.equalTo(self.lineView1.mas_top).offset(-10);
    }];
    [self.lineView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.leiLab.mas_top).offset(-15);
        make.height.mas_equalTo(kLineHeight);
        make.left.right.equalTo(self);
    }];
    [self.moneyNumLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.bottom.mas_equalTo(-10);
    }];
    [self.centerLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.moneyLab.mas_bottom).offset(15);
    }];
    [self.timeBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.centerLab.mas_bottom).offset(25);
        make.size.mas_equalTo(CGSizeMake(170, 40));
    }];
    [self.timeImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.timeBgView);
        make.left.mas_equalTo(5);
        make.width.height.mas_equalTo(25);
    }];
    [self.timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.centerY.equalTo(self.timeBgView);
        make.left.equalTo(self.timeImgView.mas_right);
    }];
    [self.testimonialsImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-20);
        make.width.height.mas_equalTo(70);
        make.centerY.equalTo(self).offset(-30);
    }];
    [self.lhhLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.testimonialsImgView);
        make.top.mas_equalTo(12);
    }];
}


#pragma mark - Getter & Setter

- (UIImageView *)avatarImgView{
    if (!_avatarImgView) {
        _avatarImgView = [[UIImageView alloc]init];
        _avatarImgView.layer.cornerRadius = 3;
        _avatarImgView.layer.masksToBounds = YES;
    }
    return _avatarImgView;
}

- (UILabel *)nickLab{
    if (!_nickLab) {
        _nickLab = [[UILabel alloc]init];
        _nickLab.textColor = HexColor(@"#1A1A1A");
        _nickLab.font = [UIFont boldSystemFontOfSize:15];
    }
    return _nickLab;
}

- (UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc]init];
        _lineView.backgroundColor = HexColor(@"#E5E5E5");
    }
    return _lineView;
}

- (UIView *)lineView2{
    if (!_lineView2) {
        _lineView2 = [[UIView alloc]init];
        _lineView2.backgroundColor = HexColor(@"#E5E5E5");
    }
    return _lineView2;
}

- (UIView *)lineView1{
    if (!_lineView1) {
        _lineView1 = [[UIView alloc]init];
        _lineView1.backgroundColor = HexColor(@"#F2F2F2");
    }
    return _lineView1;
}

- (UILabel *)moneyNumLab{
    if (!_moneyNumLab) {
        _moneyNumLab = [[UILabel alloc]init];
        _moneyNumLab.textColor = HexColor(@"#B5B5B5");
        _moneyNumLab.font = [UIFont systemFontOfSize:13];
    }
    return _moneyNumLab;
}

- (UILabel *)centerLab{
   if (!_centerLab) {
        _centerLab = [[UILabel alloc]init];
        _centerLab.textColor = HexColor(@"#BEA475");
        _centerLab.font = [UIFont boldSystemFontOfSize:16];
        _centerLab.hidden = NO;
    }
    return _centerLab;
}

- (UIView *)timeBgView{
    if (!_timeBgView) {
        _timeBgView = [[UIView alloc]init];
        _timeBgView.backgroundColor = HexColor(@"#F7F7F7");
        _timeBgView.layer.masksToBounds = YES;
        _timeBgView.layer.cornerRadius = 3;
    }
    return _timeBgView;
}

- (UIImageView *)timeImgView{
    if (!_timeImgView) {
        _timeImgView = [[UIImageView alloc]init];
        [_timeImgView setImage:[UIImage imageNamed:@"timeImgIcon"]];
    }
    return _timeImgView;
}

- (UILabel *)timeLab {
    if (!_timeLab) {
        _timeLab = [[UILabel alloc]init];
        _timeLab.textColor = HexColor(@"#BEA475");
        _timeLab.font = [UIFont systemFontOfSize:14];
        _timeLab.text = NSLocalizedString(@"本次红包游戏已截止", nil);
        _timeLab.textAlignment = NSTextAlignmentCenter;
    }
    return _timeLab;
}

- (UILabel *)moneyLab {
    if (!_moneyLab) {
        _moneyLab = [[UILabel alloc]init];
        _moneyLab.textColor = HexColor(@"#BEA475");
        _moneyLab.font = [UIFont boldSystemFontOfSize:44];
        _moneyLab.textAlignment = NSTextAlignmentCenter;
    }
    return _moneyLab;
}

- (UIImageView *)testimonialsImgView{
    if (!_testimonialsImgView) {
        _testimonialsImgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"testimonialsIcon"]];
        _testimonialsImgView.hidden = YES;
    }
    return _testimonialsImgView;
}

- (UILabel *)lhhLab{
    if(!_lhhLab){
        _lhhLab = [[UILabel alloc]init];
        _lhhLab.textColor = UIColor.whiteColor;
        _lhhLab.font = [UIFont systemFontOfSize:16];
    }
    return _lhhLab;
}

- (UILabel *)leiLab{
    if(!_leiLab){
        _leiLab = [[UILabel alloc]init];
        _leiLab.textColor = HexColor(@"#1A1A1A");
        _leiLab.font = [UIFont boldSystemFontOfSize:13];
        
    }
    return _leiLab;
}

@end


@implementation FYRedEnvelopeLeiNumModel

@end
