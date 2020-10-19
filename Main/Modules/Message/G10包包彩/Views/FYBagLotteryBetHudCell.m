//
//  FYBagLotteryBetHudCell.m
//  ProjectCSHB
//
//  Created by Tom on 2020/7/21.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "FYBagLotteryBetHudCell.h"
@interface FYBagLotteryBetHudCell()

@property (nonatomic , strong) UIView *lineView;
@property (nonatomic , strong) UIView *lineView1;
@property (nonatomic , strong) UIView *lineView2;
@property (nonatomic , strong) UILabel *moneyLab;
@property (nonatomic , strong) UILabel *betLab;
@property (nonatomic , strong) UILabel *configLab;
@end
@implementation FYBagLotteryBetHudCell
- (void)setHudData:(FYBagLotteryBetHudData *)list money:(NSString *)money{
  
    self.moneyLab.text = [NSString stringWithFormat:NSLocalizedString(@"%@元", nil),money];
    
    self.configLab.text = [NSString stringWithFormat:@"%@/%@",list.config,list.name];
    NSString *bet = [NSString string];
    if ([list.bet containsaString:@"."]) {
        bet = [NSString stringWithFormat:NSLocalizedString(@"%.2lf", nil),[list.bet floatValue]];
    }else{
        bet = [NSString stringWithFormat:NSLocalizedString(@"%@", nil),list.bet];
    }
    NSMutableAttributedString *abs = [[NSMutableAttributedString alloc]initWithString:bet];
    [abs addAttribute:NSForegroundColorAttributeName value:HexColor(@"#CB332D") range:NSMakeRange(0, bet.length)];
    self.betLab.attributedText = abs;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = HexColor(@"#F5F5F5");
        CGFloat labW = (SCREEN_WIDTH * 0.75 / 4);
        [self addSubview:self.lineView];
        [self addSubview:self.moneyLab];
        [self addSubview:self.lineView1];
        [self addSubview:self.lineView2];
        [self addSubview:self.betLab];
        [self addSubview:self.configLab];
        [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.right.equalTo(self);
            make.height.mas_equalTo(kLineHeight);
        }];
        [self.lineView1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.bottom.top.equalTo(self);
            make.width.mas_equalTo(kLineHeight);
        }];
        [self.lineView2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.top.equalTo(self);
            make.right.mas_equalTo(-labW);
            make.width.mas_equalTo(kLineHeight);
        }];
        [self.configLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.centerY.equalTo(self);
            make.right.equalTo(self.lineView1.mas_left);
        }];
        [self.moneyLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.left.equalTo(self.lineView1.mas_right);
            make.right.equalTo(self.lineView2.mas_left);
        }];
        [self.betLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.centerY.equalTo(self);
            make.left.equalTo(self.lineView2.mas_right);
        }];

    }
    return self;
}

- (UILabel *)moneyLab{
    if (!_moneyLab) {
        _moneyLab = [[UILabel alloc]init];
        _moneyLab.font = [UIFont systemFontOfSize:13];
        _moneyLab.textAlignment = NSTextAlignmentCenter;
        _moneyLab.textColor = HexColor(@"#666666");
    }
    return _moneyLab;
}
- (UILabel *)betLab{
    if (!_betLab) {
        _betLab = [[UILabel alloc]init];
        _betLab.font = [UIFont systemFontOfSize:13];
        _betLab.textAlignment = NSTextAlignmentCenter;
        _betLab.textColor = HexColor(@"#666666");
    }
    return _betLab;
}
- (UILabel *)configLab{
    if (!_configLab) {
        _configLab = [[UILabel alloc]init];
        _configLab.font = [UIFont systemFontOfSize:13];
        _configLab.textAlignment = NSTextAlignmentCenter;
        _configLab.textColor = HexColor(@"#666666");
    }
    return _configLab;
}
- (UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc]init];
        _lineView.backgroundColor = HexColor(@"#D9D9D9");
    }
    return _lineView;
}
- (UIView *)lineView1{
    if (!_lineView1) {
        _lineView1 = [[UIView alloc]init];
        _lineView1.backgroundColor = HexColor(@"#D9D9D9");
    }
    return _lineView1;
}
- (UIView *)lineView2{
    if (!_lineView2) {
        _lineView2 = [[UIView alloc]init];
        _lineView2.backgroundColor = HexColor(@"#D9D9D9");
    }
    return _lineView2;
}
@end
