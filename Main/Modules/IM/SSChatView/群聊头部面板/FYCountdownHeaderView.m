//
//  FYCountdownHeaderView.m
//  ProjectCSHB
//
//  Created by Tom on 2020/6/30.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "FYCountdownHeaderView.h"
@interface FYCountdownHeaderView()
@property (nonatomic , strong) UIImageView *imgView;
@property (nonatomic , strong) UIView *bgView;
/* 倒计时 */
@property (nonatomic, assign) NSInteger endTime;
///倒计时文本
@property (nonatomic , strong) UILabel *djsLab;
@property (nonatomic, weak) NSTimer *timer;
@end
@implementation FYCountdownHeaderView
- (void)setModelOfNiuNiu:(RobNiuNiuQunModel *)modelOfNiuNiu{
    _modelOfNiuNiu = modelOfNiuNiu;
    self.endTime = _modelOfNiuNiu.endTime;
    NSString *text = [NSString stringWithFormat:NSLocalizedString(@"距离%@结束 %@", nil),[self getGroupStatus:modelOfNiuNiu.status],[self timeMinuteAndSecond:modelOfNiuNiu.endTime]];
    CGSize textSize = [text sizeWithFont:[UIFont systemFontOfSize:14] constrainedToWidth:SCREEN_WIDTH * 0.6];
    [self.bgView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(textSize.width + 25 + 25);
    }];
    self.djsLab.attributedText = [self setTextABSWithText:text length:[self timeMinuteAndSecond:self.endTime].length];
    [self startTimer];
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    return self;
}
- (void)initView{
    [self addSubview:self.bgView];
    [self.bgView addSubview:self.imgView];
    [self.bgView addSubview:self.djsLab];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.equalTo(self);
        make.width.mas_equalTo(175);
    }];
    [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(25);
        make.centerY.equalTo(self.bgView);
        make.left.mas_equalTo(8);
    }];
    [self.djsLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.imgView.mas_right).offset(5);
        make.centerY.equalTo(self.imgView);
        make.right.equalTo(self.bgView.mas_right);
    }];
}
- (void)layoutSubviews{
    [super layoutSubviews];
    self.bgView.layer.mask = [self setViewRoundedWithView:self.bgView];
}
///画半圆
- (CAShapeLayer *)setViewRoundedWithView:(UIView *)view{
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:view.bounds byRoundingCorners:UIRectCornerTopRight|UIRectCornerBottomRight cornerRadii:CGSizeMake(16.0,16.0)];
    CAShapeLayer *mask = [[CAShapeLayer alloc] init];
    mask.frame = view.bounds;
    mask.path = path.CGPath;
    view.layer.mask = mask;
    return mask;
}
///倒计时
- (void)endTimeDjis{
    if (self.endTime >= 0) {
        NSString *text = [NSString stringWithFormat:NSLocalizedString(@"距离%@结束 %@", nil),[self getGroupStatus:self.modelOfNiuNiu.status],[self timeMinuteAndSecond:self.endTime]];
        CGSize textSize = [text sizeWithFont:[UIFont systemFontOfSize:14] constrainedToWidth:SCREEN_WIDTH * 0.7];
        [self.bgView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(textSize.width + 25 + 25);
        }];
        self.djsLab.attributedText = [self setTextABSWithText:text length:[self timeMinuteAndSecond:self.endTime].length];
        self.endTime--;
    } else {
        [self.timer invalidate];
    }
}
///设置分秒颜色
- (NSMutableAttributedString *)setTextABSWithText:(NSString *)text length:(NSInteger)length{
    NSMutableAttributedString *abs = [[NSMutableAttributedString alloc]initWithString:text];
    [abs addAttribute:NSForegroundColorAttributeName value:HexColor(@"#38AAF6") range:NSMakeRange(text.length - length, length)];
    return abs;
}

///倒计时
- (void)startTimer
{
    [self.timer invalidate];
    self.timer = nil;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(endTimeDjis) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}
- (void)stopTimer{
    [self.timer invalidate];
    self.timer = nil;
}

///设置分秒
- (NSString *)timeMinuteAndSecond:(NSInteger)endTime{
    NSString *str_minute = [NSString stringWithFormat:@"%02ld",(endTime%3600)/60];//分
    NSString *str_second = [NSString stringWithFormat:@"%02ld",endTime%60];//秒
   return [NSString stringWithFormat:@"%@:%@",str_minute,str_second];
}
//游戏周期：1:上庄 2:抢庄 3.投注 4.发包 5.抢包 6.结算
// 其余群状态
- (NSString *)getGroupStatus:(NSInteger)status
{
    switch (status) {
        case 1:
            return NSLocalizedString(@"上庄", nil);
            break;
        case 2:
            return NSLocalizedString(@"抢庄", nil);
            break;
        case 3:
            return NSLocalizedString(@"投注", nil);
            break;
        case 4:
            return NSLocalizedString(@"发包", nil);
            break;
        case 5:
            return NSLocalizedString(@"抢包", nil);
            break;
        case 6:
            return NSLocalizedString(@"结算", nil);
            break;
        case 7:
            return NSLocalizedString(@"停用", nil);
            break;
        default:
            return nil;
            break;
    }
}
- (UIImageView *)imgView{
    if (!_imgView) {
        _imgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"countdownIcon"]];
    }
    return _imgView;
}
- (UIView *)bgView{
    if (!_bgView) {
        _bgView = [[UIView alloc]init];
        _bgView.backgroundColor = UIColor.whiteColor;
    }
    return _bgView;
}
- (UILabel *)djsLab{
    if (!_djsLab) {
        _djsLab = [[UILabel alloc]init];
        _djsLab.font = [UIFont systemFontOfSize:14];
        _djsLab.textColor = HexColor(@"#1A1A1A");
    }
    return _djsLab;
}
@end
