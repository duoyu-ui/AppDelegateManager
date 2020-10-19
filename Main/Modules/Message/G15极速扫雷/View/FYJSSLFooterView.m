//
//  FYJSSLFooterView.m
//  ProjectCSHB
//
//  Created by Tom on 2020/8/26.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "FYJSSLFooterView.h"
@interface FYJSSLFooterView ()<UITextFieldDelegate>
@property (nonatomic , strong) UIView *topView;
///赔率
@property (nonatomic , strong) UILabel *oddsLab;
@property (nonatomic , strong) UILabel *oddsNumLab;
@property (nonatomic , strong) UIView *bottomView;
@property (nonatomic , strong) UIButton *selecteBtn;
@property (nonatomic , strong) UILabel *gongLab;
@property (nonatomic , strong) UIButton *deleteBtn;

@end
@implementation FYJSSLFooterView
- (void)setOdds:(NSString *)odds{
    _odds = odds;
    NSString *multiple = NSLocalizedString(@"倍", nil);
    NSMutableAttributedString *abs = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@%@",odds,multiple]];
    [abs addAttribute:NSForegroundColorAttributeName value:UIColor.blackColor range:NSMakeRange(abs.length - multiple.length, multiple.length)];
    self.oddsNumLab.attributedText = abs;
}
- (void)setSingleMoneyTips:(NSString *)singleMoneyTips{
    _singleMoneyTips = singleMoneyTips;
    ///数组逆序,用来布局按钮,从右边开始布局
    NSArray <NSString*>*tips = [[[singleMoneyTips componentsSeparatedByString:@","] reverseObjectEnumerator] allObjects];
    CGFloat btnW = 35;
    [tips enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag = idx;
        [self.bottomView addSubview:btn];
        [btn setTitle:obj forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:@"bagLotteryBet_btn_nor"] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:@"bagLotteryBet_btn_sel"] forState:UIControlStateSelected];
        btn.titleLabel.font = [UIFont systemFontOfSize:12];
        [btn setTitleColor:HexColor(@"#000000") forState:UIControlStateNormal];
        [btn setTitleColor:HexColor(@"#FFFFFF") forState:UIControlStateSelected];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.bottomView);
            make.width.height.mas_equalTo(btnW);
            make.right.equalTo(self.bottomView.mas_right).offset(-10 - idx * (btnW + 8));
        }];
        [btn addTarget:self action:@selector(selectedTips:) forControlEvents:UIControlEventTouchUpInside];
    }];
    
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = HexColor(@"#EEEEEE");
        [self initSubview];
    }
    return self;
}
- (void)initSubview{
    [self addSubview:self.topView];
    [self addSubview:self.bottomView];
    [self.topView addSubview:self.tf];
    [self.topView addSubview:self.deleteBtn];
    [self.topView addSubview:self.betBtn];
    [self.bottomView addSubview:self.gongLab];
    [self.bottomView addSubview:self.moneyLab];
    [self.bottomView addSubview:self.oddsLab];
    [self.bottomView addSubview:self.oddsNumLab];
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
        make.height.mas_equalTo(45);
    }];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(self.topView.mas_bottom).offset(10);
        make.height.mas_equalTo(45);
    }];
    [self.tf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.topView);
        make.top.mas_equalTo(5);
        make.left.mas_equalTo(10);
        make.width.equalTo(@(kScreenWidth * 0.65));
    }];
    [self.deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.topView);
        make.width.height.mas_equalTo(self.tf.mas_height);
        make.left.equalTo(self.tf.mas_right).offset(10);
    }];

    [self.betBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.centerY.equalTo(self.tf);
        make.right.equalTo(self.topView.mas_right).offset(-10);
        make.left.equalTo(self.deleteBtn.mas_right).offset(10);
    }];
    [self.gongLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bottomView);
        make.left.mas_equalTo(10);
    }];
    [self.moneyLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bottomView);
        make.left.equalTo(self.gongLab.mas_right).offset(2);
    }];
    [self.oddsLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.gongLab.mas_left);
        make.top.equalTo(self.gongLab.mas_bottom).offset(5);
    }];
    [self.oddsNumLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.oddsLab.mas_right).offset(2);
        make.centerY.equalTo(self.oddsLab);
    }];
}
#pragma mark - event
- (void)selectedTips:(UIButton *)sender{
    if (sender != self.selecteBtn){//按钮单选
        self.selecteBtn.selected = NO;
        self.selecteBtn = sender;
    }
    self.selecteBtn.selected = YES;
    self.tf.text = sender.titleLabel.text;
    if ([self.delegate respondsToSelector:@selector(jsslBetSeletWithMoney:)]) {
        [self.delegate jsslBetSeletWithMoney:self.tf.text];
       }
}
- (void)bagLotteryDelete{
    if ([self.delegate respondsToSelector:@selector(jsslBetDelete)]) {
        [self.delegate jsslBetDelete];
    }
}
- (void)bagLotteryBet{
    if ([self.delegate respondsToSelector:@selector(jsslBetWithMoney:)]) {
        [self.delegate jsslBetWithMoney:self.tf.text];
    }
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    if ([self.delegate respondsToSelector:@selector(jsslBetSeletWithMoney:)]) {
        [self.delegate jsslBetSeletWithMoney:self.tf.text];
    }
}
#pragma mark - 懒加载
- (UIView *)topView{
    if (!_topView) {
        _topView = [[UIView alloc]init];
        _topView.backgroundColor = HexColor(@"#F6F6F6");
    }
    return _topView;
}
- (UITextField *)tf{
    if (!_tf) {
        _tf = [[UITextField alloc]init];
        _tf.backgroundColor = HexColor(@"#FFFFFF");
        _tf.layer.masksToBounds = YES;
        _tf.layer.cornerRadius = 4;
        NSString *placeholder = NSLocalizedString(@"请输入单注金额", nil);
        NSMutableAttributedString *abs = [[NSMutableAttributedString alloc]initWithString:placeholder];
        [abs addAttribute:NSForegroundColorAttributeName value:HexColor(@"#C5C5C5") range:NSMakeRange(0, placeholder.length)];
        _tf.attributedPlaceholder = abs;
        _tf.font = [UIFont systemFontOfSize:15];
        _tf.textColor = UIColor.blackColor;
        _tf.leftViewMode = UITextFieldViewModeAlways;
        _tf.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, 10)];
        _tf.keyboardType = UIKeyboardTypeNumberPad;
        _tf.delegate = self;
    }
    return _tf;
}
- (UIButton *)deleteBtn{
    if (!_deleteBtn) {
        _deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_deleteBtn setImage:[UIImage imageNamed:@"bagLotteryBetDelete_icon"] forState:UIControlStateNormal];
        [_deleteBtn setBackgroundImage:[UIImage imageNamed:@"bagLotteryBetDelete_back_icon"] forState:UIControlStateNormal];
        [_deleteBtn addTarget:self action:@selector(bagLotteryDelete) forControlEvents:UIControlEventTouchUpInside];
    }
    return _deleteBtn;
}
- (UIButton *)betBtn{
    if (!_betBtn) {
        _betBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_betBtn setBackgroundImage:[UIImage imageNamed:@"bagLotteryBet_back_icon_nor"] forState:UIControlStateDisabled];
        [_betBtn setBackgroundImage:[UIImage imageNamed:@"bagLotteryBet_back_icon_sel"] forState:UIControlStateNormal];
        [_betBtn setTitle:NSLocalizedString(@"投注", nil) forState:UIControlStateNormal];
        _betBtn.titleLabel.font = FONT_PINGFANG_BOLD(15);
        [_betBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_betBtn addTarget:self action:@selector(bagLotteryBet) forControlEvents:UIControlEventTouchUpInside];
        _betBtn.enabled = NO;
    }
    return _betBtn;
}
- (UIView *)bottomView{
    if (!_bottomView) {
        _bottomView = [[UIView alloc]init];
    }
    return _bottomView;
}
- (UILabel *)gongLab{
    if (!_gongLab) {
        _gongLab = [[UILabel alloc]init];
        _gongLab.font = FONT_PINGFANG_BOLD(13);
        _gongLab.textColor = UIColor.blackColor;
        _gongLab.text = NSLocalizedString(@"共", nil);
    }
    return _gongLab;
}
- (UILabel *)moneyLab{
    if (!_moneyLab) {
        _moneyLab = [[UILabel alloc]init];
        _moneyLab.font = FONT_PINGFANG_BOLD(13);
        _moneyLab.textColor = HexColor(@"#CB332D");
        _moneyLab.text = @"0";
    }
    return _moneyLab;
}
- (UILabel *)oddsLab{
    if (!_oddsLab) {
        _oddsLab = [[UILabel alloc]init];
        _oddsLab.font = FONT_PINGFANG_BOLD(13);
        _oddsLab.textColor = UIColor.blackColor;
        _oddsLab.text = NSLocalizedString(@"赔率", nil);
    }
    return _oddsLab;
}
- (UILabel *)oddsNumLab{
    if (!_oddsNumLab) {
        _oddsNumLab = [[UILabel alloc]init];
        _oddsNumLab.font = FONT_PINGFANG_BOLD(13);
        _oddsNumLab.textColor = HexColor(@"#CB332D");
        _oddsNumLab.text = @"0.00";
    }
    return _oddsNumLab;
}
@end
