//
//  FYChatRobKeyboard.m
//  ProjectCSHB
//
//  Created by 汤姆 on 2019/10/7.
//  Copyright © 2019 Jetter. All rights reserved.
//

#import "FYChatRobKeyboard.h"
#import "FYChatRobDigital.h"
#import "FYChatRobMoney.h"
@interface FYChatRobKeyboard()<FYChatRobKeyboardViewOutputDelegate>

@property (nonatomic, strong) UIView *backdropView;
/**
 键盘容器
 */
@property (nonatomic, strong) UIView *containerView;
/** 数字键盘*/
@property (nonatomic, strong) FYChatRobDigital *digitalKeyboard;
@property (nonatomic, strong) FYChatRobMoney *moneyKeyboard;

@property (nonatomic, strong) UIView *textView;

@property (nonatomic, strong) UILabel *yueLab;

@property (nonatomic, strong) UILabel *outputLab;

@property (nonatomic, strong)NSMutableArray *nums;

/** 3:投注,2:抢庄*/
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, assign) NSInteger gameType;

/// 选中-龙虎和
@property (nonatomic, assign) NSInteger selecLhhType;
/*龙虎斗高度*/
@property (nonatomic, assign) CGFloat lhdH;
/// 龙虎和的容器view
@property (nonatomic, strong)UIView *lhhContainerView;
@property (nonatomic, strong) UIButton *selecBtn;
@property (nonatomic, weak) id<FYChatRobKeyboardDelegate> delegate;

@end
@implementation FYChatRobKeyboard

+ (void)showPayKeyboardViewAnimate:(id<FYChatRobKeyboardDelegate>)delegate keyDict:(NSDictionary *)dict balance:(NSString*)balance status:(NSInteger)status gameType:(NSInteger)gameType{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    FYChatRobKeyboard *keyboard = [[FYChatRobKeyboard alloc] initWithFrame:window.bounds];
    keyboard.status = status;
    keyboard.delegate = delegate;
    keyboard.gameType = gameType;
    keyboard.moneyKeyboard.dict = dict;
    keyboard.moneyKeyboard.type = status;
    keyboard.moneyKeyboard.input = status == 2 ? NSLocalizedString(@"抢庄", nil) : NSLocalizedString(@"投注", nil);
    keyboard.digitalKeyboard.type = status;
    keyboard.digitalKeyboard.input = status == 2 ? NSLocalizedString(@"抢庄", nil) : NSLocalizedString(@"投注", nil);
    keyboard.yueLab.text = [NSString stringWithFormat:NSLocalizedString(@"余额:%@", nil),balance];
    [window addSubview:keyboard];
    [keyboard showNumKeyboardViewAnimate];
}

- (void)setStatus:(NSInteger)status{
    _status = status;
}
- (void)setGameType:(NSInteger)gameType{
    _gameType = gameType;

}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.backdropView];
        [self addSubview:self.containerView];
        //内容视图高
        self.containerView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_WIDTH);
        [self.containerView addSubview:self.digitalKeyboard];
        [self.containerView addSubview:self.textView];
        [self.containerView addSubview:self.moneyKeyboard];
        [self.containerView addSubview:self.lhhContainerView];
        //输入框部分高
        self.textView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 78);
        [self.textView addSubview:self.yueLab];
        [self.textView addSubview:self.outputLab];
        [self.yueLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.textView);
            make.height.mas_equalTo(15);
            make.bottom.equalTo(self.textView.mas_bottom).offset(-10);
        }];
        [self.outputLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.equalTo(self.textView);
            make.bottom.equalTo(self.yueLab.mas_top);
        }];
        self.selecLhhType = -1;
        NSArray <NSString *>*lhhArr = @[NSLocalizedString(@"龙", nil),NSLocalizedString(@"虎", nil),NSLocalizedString(@"和", nil)];
        CGFloat btnw = SCREEN_WIDTH / 3 - 10;
        [lhhArr enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.layer.masksToBounds = YES;
            btn.layer.cornerRadius = 8;
            btn.tag = idx;
            [btn setBackgroundImage:[UIImage imageNamed:@"iconBtnLhh_n"] forState:UIControlStateNormal];
            [btn setBackgroundImage:[UIImage imageNamed:@"iconBtnLhh_n"] forState:UIControlStateHighlighted];
            [btn setBackgroundImage:[UIImage imageNamed:@"iconBtnLhh_s"] forState:UIControlStateDisabled];
            [btn setTitle:obj forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor hex:@"#fd5a41"] forState:UIControlStateNormal];
            [btn setTitleColor:UIColor.whiteColor forState:UIControlStateDisabled];
            btn.layer.borderWidth = 1;
            btn.layer.borderColor = [UIColor hex:@"#fd5a41"].CGColor;
            btn.titleLabel.font = [UIFont systemFontOfSize:24];
            [btn addTarget:self action:@selector(lhhClick:) forControlEvents:UIControlEventTouchUpInside];
            [self.lhhContainerView addSubview:btn];
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self.lhhContainerView);
                make.top.mas_equalTo(5);
                make.width.mas_equalTo(btnw);
                make.left.mas_equalTo((btnw  + 10) * idx + 5);
            }];
        }];
        
        // 添加监听通知
        {
            [self addNotifications];
        }
    }
    return self;
}
- (void)lhhClick:(UIButton *)btn{
    self.selecBtn.enabled = YES;
    btn.enabled = NO;
    self.selecBtn = btn;
    self.selecLhhType = btn.tag;
}
- (void)showNumKeyboardViewAnimate {
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
    self.backdropView.alpha = 1.0;
    self.lhdH = 0;
    //龙虎斗并且是投注
    if (self.gameType == 6 && self.status == 3) {
        self.lhdH = KeyboardH / 5;
    }
    CGFloat spaceY = SCREEN_HEIGHT - SCREEN_WIDTH - self.lhdH;
    [UIView animateWithDuration:0.35 animations:^{
        self.containerView.frame = CGRectMake(0, spaceY, SCREEN_WIDTH, SCREEN_WIDTH + self.lhdH);
        self.digitalKeyboard.y += self.lhdH;
        self.moneyKeyboard.y += self.lhdH;
    }];
    self.lhhContainerView.frame = CGRectMake(0, 80, SCREEN_WIDTH, self.lhdH);
}

- (void)dismiss {
    [UIView animateWithDuration:0.35 animations:^{
        self.containerView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_WIDTH + self.lhdH);
    } completion:^(BOOL finished) {
        self.backdropView.alpha = 0;
        [self removeFromSuperview];
    }];
}
#pragma mark - 懒加载
- (UIView *)backdropView{
    if (!_backdropView) {
        _backdropView = [[UIView alloc]initWithFrame:self.bounds];
        _backdropView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
        _backdropView.alpha = 0.0;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismiss)];
        [_backdropView addGestureRecognizer:tap];
    }
    return _backdropView;
}

- (UIView *)containerView{
    if (!_containerView) {//内容视图,
        _containerView = [[UIView alloc]init];
        _containerView.backgroundColor = UIColor.whiteColor;
    }
    return _containerView;
}


- (FYChatRobDigital *)digitalKeyboard{
    if (!_digitalKeyboard) {
        _digitalKeyboard = [[FYChatRobDigital alloc]initWithFrame:CGRectMake(SCREEN_WIDTH, 80, SCREEN_WIDTH, SCREEN_WIDTH - 80)];
        _digitalKeyboard.delegate = self;
    }
    return _digitalKeyboard;
}
- (FYChatRobMoney *)moneyKeyboard{
    if (!_moneyKeyboard) {
        _moneyKeyboard = [[FYChatRobMoney alloc]initWithFrame:CGRectMake(0, 80, SCREEN_WIDTH, SCREEN_WIDTH - 80)];
        _moneyKeyboard.delegate = self;
    }
    return _moneyKeyboard;
}
- (UIView *)textView{
    if (!_textView) {
        _textView = [[UIView alloc]init];
        _textView.backgroundColor = [UIColor hex:@"#f2f2f2"];
    }
    return _textView;
}
- (UILabel *)yueLab{
    if (!_yueLab) {
        _yueLab = [[UILabel alloc]init];
        _yueLab.font = [UIFont systemFontOfSize:12];
        _yueLab.textAlignment = NSTextAlignmentCenter;
        _yueLab.textColor = HexColor(@"#ff783d");
    }
    return _yueLab;
}
- (UILabel *)outputLab{
    if (!_outputLab) {
        _outputLab = [[UILabel alloc]init];
        _outputLab.font = [UIFont boldSystemFontOfSize:32];
        _outputLab.text = NSLocalizedString(@"请输入金额", nil);
        _outputLab.textAlignment = NSTextAlignmentCenter;
        _outputLab.textColor = UIColor.grayColor;
    }
    return _outputLab;
}

- (NSMutableArray *)nums{
    if (!_nums) {
        _nums = [NSMutableArray arrayWithCapacity:0];
    }
    return _nums;
}
- (UIView *)lhhContainerView{
    if (!_lhhContainerView) {
        _lhhContainerView = [[UIView alloc]init];
    }
    return _lhhContainerView;
}
#pragma mark - 代理
/**
 删除
 */
- (void)chatRobKeyboardDelete:(NSInteger)keyType{
    switch (keyType) {
        case 1://数字键盘
        {
            [self.nums removeLastObject];
            if (self.nums.count == 0) {
                self.outputLab.textColor = UIColor.grayColor;
                self.outputLab.text = NSLocalizedString(@"请输入金额", nil);
            }else{
                NSString *str = [self.nums componentsJoinedByString:@""];
                self.outputLab.text = [NSString stringWithFormat:@"%@",str];
               self.outputLab.textColor = HexColor(@"#ff312c");
            }
        }
            break;
        case 2://货币键盘
        {
            self.outputLab.textColor = UIColor.grayColor;
            self.outputLab.text = NSLocalizedString(@"请输入金额", nil);
        }
            break;
        default:
            break;
    }
}

/**
 手动输入,快捷输入
 */
- (void)chatRobKeyboardInput:(NSInteger)keyType{
    switch (keyType) {
        case 1:
        {
            self.outputLab.textColor = UIColor.grayColor;
            self.outputLab.text = NSLocalizedString(@"请输入金额", nil);
            [self.nums removeAllObjects];
            [UIView animateWithDuration:0.25 animations:^{
                self.digitalKeyboard.frame = CGRectMake(SCREEN_WIDTH, 80 + self.lhdH, SCREEN_WIDTH, SCREEN_WIDTH - 80);
                self.moneyKeyboard.frame = CGRectMake(0, 80 + self.lhdH, SCREEN_WIDTH, SCREEN_WIDTH - 80);
            }];
        }
            break;
        case 2:
        {
            self.outputLab.textColor = UIColor.grayColor;
            self.outputLab.text = NSLocalizedString(@"请输入金额", nil);
            [UIView animateWithDuration:0.25 animations:^{
                self.digitalKeyboard.frame = CGRectMake(0, 80 + self.lhdH, SCREEN_WIDTH, SCREEN_WIDTH - 80);
                self.moneyKeyboard.frame = CGRectMake(-SCREEN_WIDTH, 80 + self.lhdH, SCREEN_WIDTH, SCREEN_WIDTH - 80);
            }];
        }
            break;
        default:
            break;
    }
}
/**
 抢庄投注
 
 @param type 2: 抢庄 ,3: 投注
 */
- (void)chatRobKeyboardType:(NSInteger)type keyType:(NSInteger)keyType{
    if (![self.outputLab.text isEqualToString:NSLocalizedString(@"请输入金额", nil)]) {
        if ([self.delegate respondsToSelector:@selector(chatRobKeyboardaAmount:type:betAttr:)]) {
            [self.delegate chatRobKeyboardaAmount:self.outputLab.text type:type betAttr:self.selecLhhType];
        }
    }
    [self dismiss];
}

/**
 键盘输出的值
 
 @param num 值
 */
- (void)chatRobKeyboardNum:(NSString*)num row:(NSInteger)row keyType:(NSInteger)keyType{
    if (self.nums.count >= 12) {
        return;
    }
    switch (keyType) {
        case 1:
        {
            [self.nums addObject:num];
            if (self.nums.count == 1 && [num isEqualToString:@"0"]) {
                [self.nums removeAllObjects];
            }
            if (self.nums.count == 0) {
                self.outputLab.textColor = UIColor.grayColor;
                self.outputLab.text = NSLocalizedString(@"请输入金额", nil);
            }else{
                NSString *str = [self.nums componentsJoinedByString:@""];
                self.outputLab.text = [NSString stringWithFormat:@"%@",str];
                self.outputLab.textColor = HexColor(@"#ff312c");
            }
        }
            break;
        case 2:
        {
            if (self.status == 2) {//抢庄
                if (row == 9) {
                    NSInteger value = [self.outputLab.text integerValue] + [num integerValue];
                    self.outputLab.text = [NSString stringWithFormat:@"%ld",value];
                }else{
                    self.outputLab.text = num;
                    
                }
            }else if(self.status == 3){//投注
                self.outputLab.text = num;
            }
            self.outputLab.textColor = HexColor(@"#ff312c");
        }
            break;
        default:
            break;
    }
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
    if (VALIDATE_STRING_EMPTY(balance)) {
        return;
    }
    
    WEAKSELF(weakSelf);
    dispatch_main_async_safe((^{
        NSString *formatBalacne = [NSString stringWithFormat:NSLocalizedString(@"余额:%0.2f", nil), balance.floatValue];
        [weakSelf.yueLab setText:formatBalacne];
    }));
}

/// 释放资源
- (void)dealloc
{
    [NOTIF_CENTER removeObserver:self];
}


@end
