//
//  FYBankerView.m
//  ProjectCSHB
//
//  Created by 汤姆 on 2019/10/2.
//  Copyright © 2019 CDJay. All rights reserved.
//

#import "FYBankerView.h"
//#import "NSTimer+dy_extension.h"
#define fyBankConetH (([UIApplication sharedApplication].statusBarFrame.size.height == 20 ? 0 : 34) + 95)
@interface FYBankerView()
@property (nonatomic, strong) UIView *bgView;
/** 连续上庄*/
@property (nonatomic, strong) UIButton *robBtn;
/** 放弃*/
@property (nonatomic, strong) UIButton *cancelBtn;

@property (nonatomic, strong) UILabel *szLab;

@property (nonatomic , strong) UIView *conetView;
@property (nonatomic , strong) UIView *robView;
/** 模型*/
@property (nonatomic, strong) FYBankerModel *model;

@property (nonatomic , assign) CGFloat banker;
@property (nonatomic, copy) giveUpContinueBlock block;
@end
@implementation FYBankerView
+ (void)showBankerModel:(FYBankerModel*)model view:(UIView*)view block:(giveUpContinueBlock)block{
//    FYBankerView *bview = [[FYBankerView alloc]initWithFrame:view.bounds];
//    bview.model = model;
//    bview.block = ^(NSInteger money) {
//        block(money);
//    };
//    [view addSubview:bview];
//    [bview showView];
    FYBankerView *bview = [self sharedView];
    [bview showView];
    bview.frame = view.bounds;
    [view addSubview:bview];
    bview.model = model;
    bview.block = ^(NSInteger money) {
        block(money);
    };
}

- (void)setModel:(FYBankerModel *)model{
    _model = model;
    if (_model.currBanker == 0) {
        self.szLab.text = [NSString stringWithFormat:NSLocalizedString(@"上庄金额: %.2lf", nil),_model.lastBanker];
        self.banker = _model.lastBanker;
    }else{
        self.szLab.text = [NSString stringWithFormat:NSLocalizedString(@"连续上庄金额: %.2lf", nil),_model.currBanker];
        self.banker = _model.currBanker;
    }
}
+ (instancetype)sharedView
{
    static dispatch_once_t once;
    static FYBankerView *sharedView;
    dispatch_once(&once, ^ {
        sharedView = [[FYBankerView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    });
    return sharedView;
}
+ (void)show{
    [[self sharedView] showView];
}
//- (instancetype)initWithFrame:(CGRect)frame
//{
//    self = [super initWithFrame:frame];
//    if (self) {
//        [self addSubview:self.bgView];
//        [self addSubview:self.conetView];
//        [self.conetView addSubview:self.robView];
//        [self.robView addSubview:self.szLab];
//        [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.edges.mas_equalTo(self);
//        }];
//        self.conetView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, fyBankConetH);
//        [self.robView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.top.right.equalTo(self.conetView);
//            make.height.mas_equalTo(25);
//        }];
//        [self.szLab mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.mas_equalTo(15);
//            make.centerY.equalTo(self.robView);
//        }];
//        [self.conetView addSubview:self.robBtn];
//        [self.conetView addSubview:self.cancelBtn];
//        CGFloat btnW = (SCREEN_WIDTH - 30) / 2;
//        [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.mas_equalTo(10);
//            make.top.equalTo(self.robView.mas_bottom).offset(15);
//            make.width.mas_equalTo(btnW);
//            make.height.mas_equalTo(45);
//        }];
//        [self.robBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.width.mas_equalTo(btnW);
//            make.height.mas_equalTo(45);
//            make.centerY.equalTo(self.cancelBtn);
//            make.right.mas_equalTo(-10);
//        }];
//    }
//    return self;
//}
- (void)initSubView{
    [self addSubview:self.bgView];
    [self addSubview:self.conetView];
    [self.conetView addSubview:self.robView];
    [self.robView addSubview:self.szLab];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
    self.conetView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, fyBankConetH);
    [self.robView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.conetView);
        make.height.mas_equalTo(25);
    }];
    [self.szLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.centerY.equalTo(self.robView);
    }];
    [self.conetView addSubview:self.robBtn];
    [self.conetView addSubview:self.cancelBtn];
    CGFloat btnW = (SCREEN_WIDTH - 30) / 2;
    [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.top.equalTo(self.robView.mas_bottom).offset(15);
        make.width.mas_equalTo(btnW);
        make.height.mas_equalTo(45);
    }];
    [self.robBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(btnW);
        make.height.mas_equalTo(45);
        make.centerY.equalTo(self.cancelBtn);
        make.right.mas_equalTo(-10);
    }];
}
- (void)showView{
    [self removeFromSuperview];
    [self initSubView];
    self.alpha = 1;
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
    [UIView animateWithDuration:0.35 animations:^{
        self.conetView.frame = CGRectMake(0, SCREEN_HEIGHT - fyBankConetH, SCREEN_WIDTH, fyBankConetH);
        [self layoutIfNeeded];
    }];
}
- (UIView *)bgView{
    if (!_bgView) {
        _bgView = [[UIView alloc]init];
        _bgView.backgroundColor = UIColor.clearColor;
//        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismiss)];
//        [_bgView addGestureRecognizer:tap];
    }
    return _bgView;
}

- (UILabel *)szLab{
    if (!_szLab) {
        _szLab = [[UILabel alloc]init];
        _szLab.font = [UIFont boldSystemFontOfSize:16];
        _szLab.textColor = HexColor(@"#1A1A1A");
    }
    return _szLab;
}

- (UIButton *)robBtn{
    if (!_robBtn) {
        _robBtn = [[UIButton alloc]init];
        [_robBtn setTitle:NSLocalizedString(@"上庄", nil) forState:UIControlStateNormal];
        [_robBtn setTitleColor:HexColor(@"#202020") forState:UIControlStateNormal];
        [_robBtn setBackgroundImage:[UIImage imageNamed:@"robChatKeyNormalIcon"] forState:UIControlStateNormal];
        
        _robBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [_robBtn addTarget:self action:@selector(toRob) forControlEvents:UIControlEventTouchUpInside];
    }
    return _robBtn;
}
- (UIButton *)cancelBtn{
    if (!_cancelBtn) {
        _cancelBtn = [[UIButton alloc]init];
        [_cancelBtn setTitle:NSLocalizedString(@"放弃", nil) forState:UIControlStateNormal];
        [_cancelBtn setTitleColor:HexColor(@"#202020") forState:UIControlStateNormal];
        [_cancelBtn setBackgroundImage:[UIImage imageNamed:@"robChatKeyNormalIcon"] forState:UIControlStateNormal];
        _cancelBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        
        [_cancelBtn addTarget:self action:@selector(cancelRob) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelBtn;
}
- (UIView *)robView{
    if (!_robView) {
        _robView = [[UIView alloc]init];
        _robView.backgroundColor = HexColor(@"#F6F6F6");
    }
    return _robView;
}

- (UIView *)conetView{
    if (!_conetView) {
        _conetView = [[UIView alloc]init];
        _conetView.backgroundColor = HexColor(@"#EEEEEE");
    }
    return _conetView;
}
- (void)cancelRob{

    if (self.block != nil) {
        self.block(0);
    }
    [self dismiss];
}
//连续上庄
- (void)toRob{
    if (self.block != nil) {
        self.block(self.banker);
    }
    [self dismiss];
}
+ (void)bankDismiss{
    [[self sharedView] dismiss];
}
- (void)dismiss{
    [UIView animateWithDuration:0.35 animations:^{
        self.bgView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT);
        self.conetView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, fyBankConetH);
        [self.conetView layoutIfNeeded];
    } completion:^(BOOL finished) {
        self.alpha = 0;
        [self removeFromSuperview];
    }];
}
@end
