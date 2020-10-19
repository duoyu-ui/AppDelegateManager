//
//  FYTrendCoundDownView.m
//  ProjectCSHB
//
//  Created by fangyuan on 2020/7/25.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "FYTrendCoundDownView.h"
#import "RobNiuNiuQunModel.h"

@interface FYTrendCoundDownView ()
@property (nonatomic, strong) UIView *container;
@property (nonatomic, strong) UIImageView *imageView;
///倒计时文本
@property (nonatomic, strong) UILabel *countDownLabel;
/* 倒计时 */
@property (nonatomic, assign) NSInteger endTime;
@property (nonatomic, weak) NSTimer *timer;
@end

@implementation FYTrendCoundDownView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    return self;
}

- (void)initView
{
    [self addSubview:self.container];
    [self.container addSubview:self.imageView];
    [self.container addSubview:self.countDownLabel];
    
    [self.container mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(self);
    }];
    
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(25);
        make.centerY.equalTo(self.container);
        make.left.equalTo(self.container);
    }];
    
    [self.countDownLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.imageView.mas_right).offset(5);
        make.centerY.equalTo(self.imageView);
        make.right.equalTo(self.container.mas_right);
    }];
}

- (void)setModelOfRobNiuNiu:(RobNiuNiuQunModel *)modelOfRobNiuNiu
{
    _modelOfRobNiuNiu = modelOfRobNiuNiu;
    
    self.endTime = self.modelOfRobNiuNiu.endTime;
    
    NSString *text = [NSString stringWithFormat:NSLocalizedString(@"距离%ld期%@结束 %@", nil), self.modelOfRobNiuNiu.gameNumber, [self getGroupStatus:self.modelOfRobNiuNiu.status], [self timeMinuteAndSecond:self.modelOfRobNiuNiu.endTime]];
    self.countDownLabel.attributedText = [self setTextABSWithText:text length:[self timeMinuteAndSecond:self.endTime].length];
    
    [self startTimer];
}

///倒计时
- (void)endTimeDjis
{
    if (self.endTime >= 0) {
        NSString *text = [NSString stringWithFormat:NSLocalizedString(@"距离%ld期%@结束 %@", nil), self.modelOfRobNiuNiu.gameNumber, [self getGroupStatus:self.modelOfRobNiuNiu.status], [self timeMinuteAndSecond:self.endTime]];
        self.countDownLabel.attributedText = [self setTextABSWithText:text length:[self timeMinuteAndSecond:self.endTime].length];
        self.endTime --;
    } else {
        [self.timer invalidate];
    }
}

///设置分秒颜色
- (NSMutableAttributedString *)setTextABSWithText:(NSString *)text length:(NSInteger)length
{
    NSMutableAttributedString *abs = [[NSMutableAttributedString alloc] initWithString:text];
    [abs addAttribute:NSForegroundColorAttributeName value:HexColor(@"#38AAF6") range:NSMakeRange(text.length - length, length)];
    return abs;
}

///倒计时
- (void)startTimer
{
    [self.timer invalidate];
    self.timer = nil;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(endTimeDjis) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (void)stopTimer
{
    [self.timer invalidate];
    self.timer = nil;
}

///设置分秒
- (NSString *)timeMinuteAndSecond:(NSInteger)endTime
{
    NSString *str_minute = [NSString stringWithFormat:@"%02ld",(endTime%3600)/60];//分
    NSString *str_second = [NSString stringWithFormat:@"%02ld",endTime%60];//秒
   return [NSString stringWithFormat:@"%@:%@",str_minute,str_second];
}

- (UIView *)container
{
    if (!_container) {
        _container = [[UIView alloc] init];
        _container.backgroundColor = UIColor.whiteColor;
    }
    return _container;
}

- (UIImageView *)imageView
{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"countdownIcon"]];
    }
    return _imageView;
}

- (UILabel *)countDownLabel
{
    if (!_countDownLabel) {
        _countDownLabel = [[UILabel alloc] init];
        _countDownLabel.font = FONT_PINGFANG_REGULAR(15);
        _countDownLabel.textColor = HexColor(@"#1A1A1A");
    }
    return _countDownLabel;
}


#pragma mark - Priavte

// 游戏群状态周期：3.投注 4.发包 5.抢包 6.结算
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

@end
