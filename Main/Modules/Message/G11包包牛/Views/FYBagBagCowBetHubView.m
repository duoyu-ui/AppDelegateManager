//
//  FYBagBagCowBetHubView.m
//  ProjectCSHB
//
//  Created by Tom on 2020/7/25.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "FYBagBagCowBetHubView.h"
static CGFloat tfBackViewHeight = 55.0;
static CGFloat cowBetKeyboardHigh = 425.0;
@interface FYBagBagCowBetHubView()
@property (nonatomic , strong) UIView *bgView;
@property (nonatomic , strong) UIView *contentView;
@property (nonatomic , strong) UITextField *tf;
@property (nonatomic , strong) UIView *tfBackView;
@property (nonatomic , strong) UIView *tfInputView;
@property (nonatomic , strong) UIButton *selecteBtn;
@property (nonatomic , strong) UIButton *selecteNumBtn;
@property (nonatomic , strong) UIView *lineView;
@property (nonatomic , strong) UIView *lineView1;
@property (nonatomic , copy)bagBagCowGoBet block;
@property (nonatomic , assign) NSInteger betAttr;
@end
@implementation FYBagBagCowBetHubView

+ (void)showHubViewWithList:(NSString *)list block:(bagBagCowGoBet)block{
    FYBagBagCowBetHubView *hubView = [[FYBagBagCowBetHubView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    hubView.block = ^(NSInteger betAttr, NSString * _Nonnull money, BOOL isPay) {
        block(betAttr,money,isPay);
    };

    [hubView showHubViewList:list];
    [[UIApplication sharedApplication].keyWindow addSubview:hubView];
}
- (void)showHubViewList:(NSString *)list{
    NSArray <NSString*>*nums = [list componentsSeparatedByString:@","];
    CGFloat btnW = (SCREEN_WIDTH - 35) / 4;
    [nums enumerateObjectsUsingBlock:^(NSString *num, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx < 4) {
            UIButton *numBtn = [[UIButton alloc]init];
            numBtn.layer.cornerRadius = 6;
            numBtn.layer.masksToBounds = NO;
            numBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
            [numBtn setTitle:num forState:UIControlStateNormal];
            [numBtn setTitleColor:HexColor(@"#333333") forState:UIControlStateNormal];
            [numBtn setTitleColor:HexColor(@"#CB332D") forState:UIControlStateSelected];
            [numBtn setBackgroundImage:[UIImage imageNamed:@"robChatKeyNormalIcon"] forState:UIControlStateNormal];
            [numBtn setBackgroundImage:[UIImage imageNamed:@"robChatKeyNormalIcon"] forState:UIControlStateHighlighted];
            [numBtn setBackgroundImage:[UIImage imageNamed:@"robChatKeyNormalIcon"] forState:UIControlStateSelected];
            [numBtn setBackgroundImage:[UIImage imageNamed:@"robChatKeyNormalIcon"] forState:UIControlStateSelected|UIControlStateHighlighted];
            numBtn.tag = idx;
            [self.tfInputView addSubview:numBtn];
            [numBtn addTarget:self action:@selector(selectedNum:) forControlEvents:UIControlEventTouchUpInside];
            [numBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.tfInputView.mas_left).offset(10 + idx *(btnW + 5));
                make.top.mas_equalTo(80);
                make.height.mas_equalTo(50);
                make.width.mas_equalTo(btnW);
            }];
        }
    }];
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubview];
    }
    return self;
}
- (void)initSubview{
    [self addSubview:self.bgView];
    [self addSubview:self.contentView];
    [self.contentView addSubview:self.tfBackView];
    [self.tfBackView addSubview:self.tf];
    [self.tfInputView addSubview:self.lineView];
    [self.tfInputView addSubview:self.lineView1];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self);
        make.height.mas_equalTo(cowBetKeyboardHigh + kBottomSafeHeight);
    }];
    [self.tfBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.centerX.equalTo(self.contentView);
        make.height.mas_equalTo(tfBackViewHeight);
    }];
    [self.tf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.tfBackView);
        make.top.left.mas_equalTo(10);
    }];
    [self.tf becomeFirstResponder];
    //数字键盘 220高 输入框55 剩余150高
    CGFloat middle = 150;
    NSArray <NSString *>*nums = @[@"1",@"2",@"3",@"numDeleteIcon",@"4",@"5",@"6",NSLocalizedString(@"充值", nil),@"7",@"8",@"9",NSLocalizedString(@"投注", nil),@"cancelKeyboardIcon",@"0",NSLocalizedString(@"加倍", nil)];
    CGFloat btnW = (SCREEN_WIDTH - 35) / 5.5;
    CGFloat btnH = 50;
    int colCount = 4;
    [nums enumerateObjectsUsingBlock:^(NSString *title, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton *btn = [[UIButton alloc]init];
        btn.layer.cornerRadius = 6;
        btn.layer.masksToBounds = NO;
        btn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
        btn.tag = idx;
        switch (idx) {
            case 3:
            case 12:
                [btn setImage:[UIImage imageNamed:title] forState:UIControlStateNormal];
                [btn setImage:[UIImage imageNamed:title] forState:UIControlStateHighlighted];
                break;
            default:
                [btn setTitle:title forState:UIControlStateNormal];
                [btn setTitleColor:HexColor(@"#333333") forState:UIControlStateNormal];
                break;
        }
        if ([title isEqualToString:NSLocalizedString(@"投注", nil)]) {
            btn.backgroundColor = HexColor(@"#CB332D");
            [btn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        }else{
            [btn setBackgroundImage:[UIImage imageNamed:@"robChatKeyNormalIcon"] forState:UIControlStateNormal];
            [btn setBackgroundImage:[UIImage imageNamed:@"robChatKeyNormalIcon"] forState:UIControlStateHighlighted];
        }
        [self.tfInputView addSubview:btn];
        [btn addTarget:self action:@selector(digitalKeyboard:) forControlEvents:UIControlEventTouchUpInside];
        NSInteger row = idx / colCount;//按钮所在行
        NSInteger col = idx % colCount;//按钮所在列
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(col == 3 ? btnW : btnW * 1.5);
            make.height.mas_equalTo(idx == 11 ? btnH * 2 + 5 :btnH);
            make.left.equalTo(self.tfInputView.mas_left).offset(10 + col * (btnW * 1.5 + 5));
            make.top.equalTo(self.tfInputView.mas_top).offset(middle + row * (btnH + 5));
        }];
    }];
    CGFloat betBtnW = (SCREEN_WIDTH - 30) / 3;
    NSArray <NSString*>*betArr = @[NSLocalizedString(@"庄", nil),NSLocalizedString(@"闲", nil),NSLocalizedString(@"和", nil)];
    [betArr enumerateObjectsUsingBlock:^(NSString *bet, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton *betBtn = [[UIButton alloc]init];
        betBtn.layer.cornerRadius = 6;
        betBtn.layer.masksToBounds = NO;
        betBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
        [betBtn setTitle:bet forState:UIControlStateNormal];
        [betBtn setTitleColor:HexColor(@"#333333") forState:UIControlStateNormal];
        betBtn.tag = idx;
        [betBtn addTarget:self action:@selector(selectedBet:) forControlEvents:UIControlEventTouchUpInside];
        [betBtn setBackgroundImage:[UIImage imageNamed:@"robChatKeyNormalIcon"] forState:UIControlStateNormal];
        [betBtn setBackgroundImage:[UIImage imageNamed:@"robChatKeyNormalIcon"] forState:UIControlStateHighlighted];
        [betBtn setBackgroundImage:[UIImage imageNamed:@"robChatKeySeletIcon"] forState:UIControlStateSelected];
        [betBtn setBackgroundImage:[UIImage imageNamed:@"robChatKeySeletIcon"] forState:UIControlStateSelected|UIControlStateHighlighted];
        [self.tfInputView addSubview:betBtn];
        [betBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(betBtnW);
            make.left.equalTo(self.tfInputView.mas_left).offset(10 + idx * (betBtnW + 5));
            make.top.equalTo(self.tfInputView.mas_top).offset(10);
            make.height.mas_equalTo(btnH);
        }];
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.tfInputView);
        make.height.mas_equalTo(kLineHeight);
        make.top.mas_equalTo(70);
    }];
    [self.lineView1 mas_makeConstraints:^(MASConstraintMaker *make) {
           make.left.right.equalTo(self.tfInputView);
           make.height.mas_equalTo(kLineHeight);
           make.top.mas_equalTo(70*2);
       }];
}
- (void)selectedBet:(UIButton *)sender{//庄闲和
    if (sender != self.selecteBtn){//按钮单选
        self.selecteBtn.selected = NO;
        self.selecteBtn = sender;
    }
    self.selecteBtn.selected = YES;
    self.betAttr = sender.tag;
}
- (void)selectedNum:(UIButton*)sender{//单注
    if (sender != self.selecteNumBtn){//按钮单选
        self.selecteNumBtn.selected = NO;
        self.selecteNumBtn = sender;
    }
    self.selecteNumBtn.selected = YES;
    self.tf.text = sender.titleLabel.text;
}
- (void)digitalKeyboard:(UIButton *)btn{
    NSString *num = [NSString string];
    switch (btn.tag) {
        case 0:
            num = @"1";
            break;
        case 1:
            num = @"2";
            break;
        case 2:
            num = @"3";
            break;
        case 3://删除
            [self.tf deleteBackward];
            break;
        case 4:
            num = @"4";
            break;
        case 5:
            num = @"5";
            break;
        case 6:
            num = @"6";
            break;
        case 7://充值
        {
            if (self.block != nil) {
                self.block(0, @"",YES);
            }
            [self dismissHudView];
        }
            break;
        case 8:
            num = @"7";
            break;
        case 9:
            num = @"8";
            break;
        case 10:
            num = @"9";
            break;
        case 11://投注
        {
            if (self.block != nil) {
                self.block(self.betAttr, self.tf.text,NO);
            }
            [self dismissHudView];
        }
            break;
        case 12://消失
            [self dismissHudView];
            break;
        case 13:
            num = @"0";
            break;
        case 14://加倍
            self.tf.text = [NSString stringWithFormat:@"%zd",[self.tf.text integerValue] * 2];
            break;
        default:
            break;
    }
    [self.tf insertText:num];
}
- (void)dismissHudView{
    [UIView animateWithDuration:0.35 animations:^{
        [self.tf resignFirstResponder];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
   
}
- (UIView *)bgView{
    if (!_bgView) {
        _bgView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissHudView)];
        [_bgView addGestureRecognizer:tap];
    }
    return _bgView;
}
- (UITextField *)tf{
    if (!_tf) {
        _tf = [[UITextField alloc]init];
        _tf.backgroundColor = UIColor.whiteColor;
        _tf.textColor = UIColor.blackColor;
        NSString *text = NSLocalizedString(@"请输入金额", nil);
        NSMutableAttributedString *abs = [[NSMutableAttributedString alloc]initWithString:text];
        [abs addAttribute:NSForegroundColorAttributeName value:HexColor(@"#C5C5C5") range:NSMakeRange(0, text.length)];
        _tf.attributedPlaceholder = abs;
        _tf.inputView = self.tfInputView;
        _tf.font = [UIFont systemFontOfSize:15];
        _tf.layer.masksToBounds = YES;
        _tf.layer.cornerRadius = 4;
        _tf.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 15, 15)];
        _tf.leftViewMode = UITextFieldViewModeAlways;
        _tf.clearButtonMode = UITextFieldViewModeAlways;
    }
    return _tf;
}
- (UIView *)tfInputView{
    if (!_tfInputView) {
        _tfInputView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, cowBetKeyboardHigh + kBottomSafeHeight - tfBackViewHeight)];
        _tfInputView.backgroundColor = HexColor(@"#EEEEEE");
    }
    return _tfInputView;
}
- (UIView *)tfBackView{
    if (!_tfBackView) {
        _tfBackView = [[UIView alloc]init];
        _tfBackView.backgroundColor = HexColor(@"#F6F6F6");
    }
    return _tfBackView;
}
- (UIView *)contentView{
    if (!_contentView) {
        _contentView = [[UIView alloc]init];
        _contentView.backgroundColor = HexColor(@"#EEEEEE");
    }
    return _contentView;
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
@end
