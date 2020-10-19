//
//  FYBagLotteryBetCountdownView.m
//  ProjectCSHB
//
//  Created by Tom on 2020/7/22.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "FYBagLotteryBetCountdownView.h"
@interface FYBagLotteryBetCountdownView()
@property (nonatomic , strong) UIImageView *imgView;

/* 倒计时 */
@property (nonatomic, assign) NSInteger endTime;
///倒计时文本
@property (nonatomic , strong) UILabel *djsLab;
@property (nonatomic, weak) NSTimer *timer;
@end
@implementation FYBagLotteryBetCountdownView
- (void)setModel:(RobNiuNiuQunModel *)model{
    _model = model;
    NSLog(@"%ld",(long)model.endTime);
    self.endTime = model.endTime;
      NSString *text = [NSString stringWithFormat:NSLocalizedString(@"距离%@结束 %@", nil),[self getGroupStatus:model.status],[self timeMinuteAndSecond:model.endTime]];

      self.djsLab.attributedText = [self setTextABSWithText:text length:[self timeMinuteAndSecond:self.endTime].length];
      [self.timer invalidate];
      self.timer = nil;
      self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(endTimeDjis) userInfo:nil repeats:YES];
      [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = HexColor(@"#C5C5C5");
        [self initView];
    }
    return self;
}
- (void)initView{
    [self addSubview:self.imgView];
    [self addSubview:self.djsLab];
    [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(25);
        make.centerY.equalTo(self);
        make.left.mas_equalTo(8);
    }];
    [self.djsLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.imgView.mas_right).offset(5);
        make.centerY.equalTo(self.imgView);
    }];
}
///倒计时
- (void)endTimeDjis{
    if (self.endTime >= 0) {
        NSString *text = [NSString stringWithFormat:NSLocalizedString(@"距离%@结束 %@", nil),[self getGroupStatus:self.model.status],[self timeMinuteAndSecond:self.endTime]];
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
- (void)stopTime{
    [self.timer invalidate];
    self.timer = nil;
}
///设置分秒
- (NSString *)timeMinuteAndSecond:(NSInteger)endTime{
    NSString *str_minute = [NSString stringWithFormat:@"%02ld",(endTime%3600)/60];//分
    NSString *str_second = [NSString stringWithFormat:@"%02ld",endTime%60];//秒
   return [NSString stringWithFormat:@"%@:%@",str_minute,str_second];
}
//包包彩游戏周期：3.投注 4.发包 5.抢包 6.结算
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
- (UILabel *)djsLab{
    if (!_djsLab) {
        _djsLab = [[UILabel alloc]init];
        _djsLab.font = [UIFont systemFontOfSize:14];
        _djsLab.textColor = HexColor(@"#1A1A1A");
    }
    return _djsLab;
}
@end
