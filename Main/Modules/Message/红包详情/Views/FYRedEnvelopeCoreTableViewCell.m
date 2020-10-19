//
//  FYRedEnvelopeCoreTableViewCell.m
//  ProjectCSHB
//
//  Created by fangyuan on 2020/7/23.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "FYRedEnvelopeCoreTableViewCell.h"
#import "FYRedEnvelopePublickResponse.h"

@implementation FYRedEnvelopeCoreTableViewCell

+ (NSString *)reuseIdentifier
{
    return NSStringFromClass(self);
}

+ (CGFloat)height
{
    return CFC_AUTOSIZING_WIDTH(60.0f);
}

- (void)setCellModel:(id)cellModel type:(GroupTemplateType)type
{
    // TODO: 创建子类并在子类中处理
}


#pragma mark - Life Cycle

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setSubViews];
    }
    return self;
}

- (void)setSubViews{
    self.backgroundColor = HexColor(@"#FFFFFF");
    [self addSubview:self.avatarImgView];
    [self addSubview:self.nickLab];
    [self addSubview:self.lineView];
    [self addSubview:self.timeLab];
    [self addSubview:self.moneyLab];
    [self addSubview:self.bestLuckLab];
    [self addSubview:self.luckImgView];
    [self addSubview:self.leiImgView];
    [self addSubview:self.bankerLab];
    [self addSubview:self.cowLab];
    [self addSubview:self.cowImgView];
    [self.avatarImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.mas_equalTo(15);
        make.width.height.mas_equalTo(35);
    }];
    [self.nickLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.avatarImgView.mas_top);
        make.left.equalTo(self.avatarImgView.mas_right).offset(10);
    }];
    [self.bankerLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.nickLab);
        make.left.equalTo(self.nickLab.mas_right).offset(3);
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.right.equalTo(self);
        make.height.mas_equalTo(kLineHeight);
        make.left.equalTo(self.nickLab.mas_left);
    }];
    [self.timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nickLab);
        make.bottom.equalTo(self.avatarImgView.mas_bottom);
    }];
    [self.moneyLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.top.equalTo(self.avatarImgView.mas_top);
    }];
    [self.cowImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.moneyLab);
        make.right.mas_equalTo(-110);
        make.width.height.mas_equalTo(15);
    }];
    [self.cowLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.cowImgView);
        make.left.equalTo(self.cowImgView.mas_right).offset(2);
    }];
    [self.bestLuckLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.bottom.equalTo(self.avatarImgView.mas_bottom);
    }];
    [self.luckImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.bestLuckLab);
        make.right.equalTo(self.bestLuckLab.mas_left).offset(-3);
        make.width.height.mas_equalTo(20);
    }];
    [self.leiImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(15);
        make.centerY.equalTo(self.moneyLab);
        make.right.mas_equalTo(-110);
    }];
}
- (UIImageView *)avatarImgView{
    if (!_avatarImgView) {
        _avatarImgView = [[UIImageView alloc]init];
    }
    return _avatarImgView;
}
- (UILabel *)nickLab{
    if (!_nickLab) {
        _nickLab = [[UILabel alloc]init];
        _nickLab.textColor = HexColor(@"#1A1A1A");
        _nickLab.font = [UIFont boldSystemFontOfSize:13];
    }
    return _nickLab;
}
- (UILabel *)timeLab{
    if (!_timeLab) {
        _timeLab = [[UILabel alloc]init];
        _timeLab.textColor = HexColor(@"#B3B3B3");
        _timeLab.font = [UIFont systemFontOfSize:11];
    }
    return _timeLab;
}
- (UILabel *)moneyLab{
    if (!_moneyLab) {
        _moneyLab = [[UILabel alloc]init];
        _moneyLab.textColor = HexColor(@"#1A1A1A");
        _moneyLab.font = [UIFont boldSystemFontOfSize:13];
    }
    return _moneyLab;
}
- (UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc]init];
        _lineView.backgroundColor = HexColor(@"#E5E5E5");
    }
    return _lineView;
}
- (UILabel *)bestLuckLab{
    if (!_bestLuckLab) {
        _bestLuckLab = [[UILabel alloc]init];
        _bestLuckLab.textColor = HexColor(@"#FFB21D");
        _bestLuckLab.font = [UIFont boldSystemFontOfSize:11];
        //        _bestLuckLab.hidden = YES;
    }
    return _bestLuckLab;
}
- (UIImageView *)luckImgView{
    if (!_luckImgView) {
        _luckImgView = [[UIImageView alloc]init];
        //        _luckImgView.hidden = YES;
    }
    return _luckImgView;
}
- (UIImageView *)leiImgView{
    if (!_leiImgView) {
        _leiImgView = [[UIImageView alloc]init];
        _leiImgView.image = [UIImage imageNamed:@"bombFlagIcon"];
        //        _leiImgView.hidden = YES;
    }
    return _leiImgView;
}
- (UILabel *)bankerLab{
    if (!_bankerLab) {
        _bankerLab = [[UILabel alloc]init];
        _bankerLab.textColor = HexColor(@"#FFFFFF");
        _bankerLab.text = NSLocalizedString(@"庄家", nil);
        _bankerLab.layer.masksToBounds = YES;
        _bankerLab.layer.cornerRadius = 2;
        _bankerLab.backgroundColor = HexColor(@"#E16754");
        _bankerLab.font = [UIFont systemFontOfSize:8];
        //        _bankerLab.hidden = YES;
    }
    return _bankerLab;
}
- (UILabel *)cowLab{
    if (!_cowLab) {
        _cowLab = [[UILabel alloc]init];
        _cowLab.textColor = HexColor(@"#CB332D");
        _cowLab.font = [UIFont systemFontOfSize:11];
        _cowLab.hidden = YES;
    }
    return _cowLab;
}
- (UIImageView *)cowImgView{
    if (!_cowImgView) {
        _cowImgView = [[UIImageView alloc]init];
        _cowImgView.hidden = YES;
    }
    return _cowImgView;
}

@end
