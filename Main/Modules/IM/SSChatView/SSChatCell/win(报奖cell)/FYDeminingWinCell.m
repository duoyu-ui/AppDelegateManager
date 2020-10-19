//
//  FYDeminingWinCell.m
//  ProjectCSHB
//
//  Created by Tom on 2020/6/26.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "FYDeminingWinCell.h"
@interface FYDeminingWinCell()
@property (nonatomic , strong) UILabel *nickLab;
@property (nonatomic , strong) UILabel *qLab;
@property (nonatomic , strong) UILabel *moneyLab;
@property (nonatomic , strong) UIImageView *imgView;
@end
@implementation FYDeminingWinCell

- (void)setList:(SSChatDeminingWinGrabList *)list{
    _list = list;
    self.nickLab.text = list.nick;
    if (list.bombFlag) {
        self.imgView.hidden = NO;
        NSString *qm = [NSString stringWithFormat:NSLocalizedString(@"抢%.2lf", nil),list.money];
        NSMutableAttributedString *abs = [[NSMutableAttributedString alloc]initWithString:qm];
        [abs addAttribute:NSForegroundColorAttributeName value:HexColor(@"#CB332D") range:NSMakeRange(qm.length - 1, 1)];
        self.qLab.attributedText = abs;
    }else{
        self.imgView.hidden = YES;
        self.qLab.text = [NSString stringWithFormat:NSLocalizedString(@"抢%.2lf", nil),list.money];
    }
    if ([list.moneyGet hasPrefix:@"-"]) {
        self.moneyLab.textColor = HexColor(@"#1A1A1A");
    }else{
        self.moneyLab.textColor = HexColor(@"#CB332D");
    }
    self.moneyLab.text = list.moneyGet;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = UIColor.whiteColor;
        [self setSubViews];
    }
    return self;
}
- (void)setSubViews{
    [self addSubview:self.nickLab];
    [self addSubview:self.qLab];
    [self addSubview:self.moneyLab];
    [self addSubview:self.imgView];
    CGFloat labw =  (SCREEN_WIDTH * 0.65 - 25)/3;
    [self.nickLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.centerY.equalTo(self);
        make.width.mas_equalTo(labw);
    }];
    [self.qLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nickLab.mas_right).offset(18);
        make.width.lessThanOrEqualTo(@(labw));
    }];
    [self.moneyLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.centerY.equalTo(self);
        make.width.mas_equalTo(labw);
    }];
    [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(13);
        make.centerY.equalTo(self);
        make.left.mas_equalTo(labw * 2);
    }];
}
- (UILabel *)nickLab{
    if (!_nickLab) {
        _nickLab = [[UILabel alloc]init];
        _nickLab.textColor = HexColor(@"#1A1A1A");
        _nickLab.font = [UIFont systemFontOfSize:kCellFont];
    }
    return _nickLab;
    
}
- (UILabel *)qLab{
    if (!_qLab) {
        _qLab = [[UILabel alloc]init];
        _qLab.textColor = HexColor(@"#1A1A1A");
        _qLab.font = [UIFont systemFontOfSize:kCellFont];
//        _qLab.textAlignment = NSTextAlignmentCenter;
    }
    return _qLab;
    
}
- (UILabel *)moneyLab{
    if (!_moneyLab) {
        _moneyLab = [[UILabel alloc]init];
        _moneyLab.textColor = HexColor(@"#1A1A1A");
        _moneyLab.font = [UIFont systemFontOfSize:kCellFont];
        _moneyLab.textAlignment = NSTextAlignmentRight;
    }
    return _moneyLab;
}
- (UIImageView *)imgView{
    if (!_imgView) {
        _imgView = [[UIImageView alloc]init];
        _imgView.hidden = YES;
        [_imgView setImage:[UIImage imageNamed:@"bombFlagIcon"]];
    }
    return _imgView;
}
@end
