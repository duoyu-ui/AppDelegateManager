//
//  FYBalanceInfoView.m
//  ProjectCSHB
//
//  Created by 汤姆 on 2019/9/28.
//  Copyright © 2019 CDJay. All rights reserved.
//

#import "FYBalanceInfoView.h"


@interface FYBalanceInfoView ()
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic , strong) UIView *middleBgView;
@property (nonatomic , strong) UIButton *dimissBtn;
@property (nonatomic, strong) UIImageView *contentView;
@property (nonatomic, strong) UILabel *yueLab;
@property (nonatomic , strong) UIButton *payBtn;
/// 冻结金额
@property (nonatomic, strong) UILabel *frozenMoneyLab;
/// 余额
@property (nonatomic, strong) UILabel *balanceLab;

@property (nonatomic, strong) FYBalanceInfoModel *info;
@property (nonatomic , strong) UIImageView *rightImgView;
@property (nonatomic, copy) goBalance block;

@end

@implementation FYBalanceInfoView

#pragma mark - life cycle

+ (void)showTitle:(NSString *)title balanceInfo:(FYBalanceInfoModel *)info block:(goBalance)block
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    FYBalanceInfoView *view = [[FYBalanceInfoView alloc] initWithFrame:window.bounds];
    view.title = VALIDATE_STRING_EMPTY(title) ? NSLocalizedString(@"余额", nil) : STR_TRI_WHITE_SPACE(title);
    view.info = info;
    view.block = ^{
        block();
    };
    [window addSubview:view];
}


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // 添加监听通知
        [self addNotifications];
        //
        [self addSubview:self.bgView];
//        [self addSubview:self.middleBgView];
//        [self.middleBgView addSubview:self.dimissBtn];
//        [self.middleBgView addSubview:self.yueLab];
//        [self.middleBgView addSubview:self.payBtn];
//        [self.middleBgView addSubview:self.frozenMoneyLab];
//        [self.middleBgView addSubview:self.rightImgView];
//        [self.middleBgView addSubview:self.balanceLab];
        [self addSubview:self.contentView];
        [self.contentView addSubview:self.dimissBtn];
        [self.contentView addSubview:self.yueLab];
        [self.contentView addSubview:self.payBtn];
        [self.contentView addSubview:self.frozenMoneyLab];
//        [self.contentView addSubview:self.rightImgView];
        [self.contentView addSubview:self.balanceLab];
        [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self);
        }];
//        [self.middleBgView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.center.equalTo(self);
//            make.width.equalTo(@(SCREEN_WIDTH * 0.75));
//            make.height.equalTo(@(SCREEN_WIDTH * 0.65));
//        }];
        CGFloat bil = 721.0 / 900;
        [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(SCREEN_WIDTH * 0.75);
            make.center.equalTo(self);
            make.height.mas_equalTo(SCREEN_WIDTH * 0.75 * bil);
        }];
        [self.dimissBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView.mas_top).offset(15);
            make.right.equalTo(self.contentView.mas_right).offset(-15);
            make.width.height.equalTo(@(40));
        }];
        [self.yueLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.contentView);
            make.top.equalTo(@(25));
        }];
        [self.payBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.contentView);
            make.width.equalTo(self.contentView.mas_width).multipliedBy(0.8);
            make.bottom.equalTo(self.contentView.mas_bottom).offset(-35);
            make.height.equalTo(@(40));
        }];
//        [self.rightImgView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.right.centerY.equalTo(self.middleBgView);
//            make.width.height.equalTo(@(70));
//        }];
        [self.frozenMoneyLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).offset(30);
            make.top.equalTo(self.contentView.mas_centerY).offset(-13);
            make.right.equalTo(self.contentView.mas_right).offset(-100);
        }];
        [self.balanceLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.frozenMoneyLab.mas_top).offset(-10);
            make.left.equalTo(self.frozenMoneyLab);
            make.right.equalTo(self.contentView.mas_right).offset(-100);
        }];
    }
    
    return self;
}

#pragma mark - Public Setter

- (void)setTitle:(NSString *)title
{
    _title = title;
    
    [self.yueLab setText:_title];
}

- (void)setInfo:(FYBalanceInfoModel *)info {
    _info = info;
    
    self.balanceLab.text = [NSString stringWithFormat:NSLocalizedString(@"可用余额:%.2lf元", nil),_info.balance];
    self.frozenMoneyLab.text = [NSString stringWithFormat:NSLocalizedString(@"冻结金额:%0.2lf元", nil),_info.frozenMoney];
}

#pragma mark - Private Getter

- (UIView *)bgView {
    
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = UIColor.blackColor;
        _bgView.alpha = 0.3;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismiss)];
        [_bgView addGestureRecognizer:tap];
    }
    return _bgView;
}
- (UIImageView *)contentView{
    if (!_contentView) {
        _contentView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"balance_bg_icon"]];
        _contentView.userInteractionEnabled = YES;
    }
    return _contentView;
}
- (UILabel *)yueLab {
    
    if (!_yueLab) {
        _yueLab = [[UILabel alloc]init];
        _yueLab.text = NSLocalizedString(@"余额", nil);
        _yueLab.font = [UIFont boldSystemFontOfSize:16];
        _yueLab.textColor = UIColor.blackColor;
    }
    return _yueLab;
}

- (UILabel *)balanceLab {
    if (!_balanceLab) {
        _balanceLab = [[UILabel alloc]init];
        _balanceLab.font = [UIFont boldSystemFontOfSize:14];
        _balanceLab.textColor = HexColor(@"#ec455f");
    }
    return _balanceLab;
}

- (UILabel *)frozenMoneyLab {
    
    if (!_frozenMoneyLab) {
        _frozenMoneyLab = [[UILabel alloc]init];
        _frozenMoneyLab.font = [UIFont boldSystemFontOfSize:14];
//        _frozenMoneyLab.textColor = HexColor(@"#ec455f");
        _frozenMoneyLab.textColor = UIColor.blueColor;
    }
    return _frozenMoneyLab;
}
#pragma mark - Action

- (void)dismiss {
    [UIView animateWithDuration:0.5 animations:^{
        self.bgView.transform = CGAffineTransformMakeScale(0.001, 0.001);
        self.hidden = YES;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}


- (void)rechargeClick {
    if (self.block != nil) {
        self.block();
    }
    
    [self dismiss];
}
- (UIView *)middleBgView{
    if (!_middleBgView) {
        _middleBgView = [[UIView alloc]init];
        [_middleBgView addRound:6];
        _middleBgView.backgroundColor = UIColor.whiteColor;
    }
    return _middleBgView;
}
- (UIButton *)dimissBtn{
    if (!_dimissBtn) {
        _dimissBtn = [[UIButton alloc]init];
        [_dimissBtn setBackgroundImage:[UIImage imageNamed:@"red_dismss_icon"] forState:UIControlStateNormal];
        [_dimissBtn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    }
    return _dimissBtn;
}
- (UIButton *)payBtn{
    if (!_payBtn) {
        _payBtn = [[UIButton alloc]init];
        _payBtn.backgroundColor = HexColor(@"#BD1F23");
        [_payBtn setTitle:NSLocalizedString(@"立即充值", nil) forState:UIControlStateNormal];
        [_payBtn addRound:4];
        _payBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_payBtn setImage:[UIImage imageNamed:@"icon_ye_pay_safety"] forState:UIControlStateNormal];
        [_payBtn addTarget:self action:@selector(rechargeClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _payBtn;
}
- (UIImageView *)rightImgView{
    if (!_rightImgView) {
        _rightImgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"rightImg_ye_icon"]];
    }
    return _rightImgView;
}
#pragma mark - Notification

/// 添加监听通知
- (void)addNotifications
{
    // 余额变动通知
    [NOTIF_CENTER addObserver:self selector:@selector(doNotificationUpdateUserInfoBalance:) name:kNotificationUserInfoBalanceChange object:nil];
}

/// 通知事件处理 - 余额实时变动
- (void)doNotificationUpdateUserInfoBalance:(NSNotification *)notification
{
    NSDictionary *object = (NSDictionary *)notification.object;
    NSString *balance = [object stringForKey:@"balance"];
    NSString *frozenMoney = [object stringForKey:@"frozenMoney"];
    if (VALIDATE_STRING_EMPTY(balance)) {
        return;
    }
    
    WEAKSELF(weakSelf);
    dispatch_main_async_safe((^{
        NSString *formatBalacne = [NSString stringWithFormat:@"%.2lf", balance.floatValue];
        weakSelf.balanceLab.text = [NSString stringWithFormat:NSLocalizedString(@"可用余额:%@元", nil), formatBalacne];
        //
        NSString *formatFrozenMoney = [NSString stringWithFormat:@"%.2lf", frozenMoney.floatValue];
        weakSelf.frozenMoneyLab.text = [NSString stringWithFormat:NSLocalizedString(@"冻结金额:%@元", nil), formatFrozenMoney];
    }));
}

/// 释放资源
- (void)dealloc
{
    [NOTIF_CENTER removeObserver:self];
}


@end

