//
//  FYAgentRegisterAlertView.m
//  ProjectCSHB
//
//  Created by fangyuan on 2020/5/27.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "FYAgentRegisterAlertView.h"

const CGFloat kAnimationTimeInterval = 0.6f;

@interface FYAgentRegisterAlertView()

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *username;

@property (nonatomic, copy) NSString *password;

@property (nonatomic, strong) UIButton *confirmButton;

@end


@implementation FYAgentRegisterAlertView

+ (void)alertWithTitle:(NSString *)title userName:(NSString *)userName password:(NSString *)password
{
    FYAgentRegisterAlertView *alertView = [[FYAgentRegisterAlertView alloc] initTitle:title userName:userName password:password];
    [[UIApplication sharedApplication].delegate.window addSubview:alertView];
}

+ (void)alertWithTitle:(NSString *)title userName:(NSString *)userName password:(NSString *)password confirmBlock:(void(^)(void))block
{
    FYAgentRegisterAlertView *alertView = [[FYAgentRegisterAlertView alloc] initTitle:title userName:userName password:password];
    [alertView setConfirmActionBlock:block];
    [[UIApplication sharedApplication].delegate.window addSubview:alertView];
}

- (instancetype)initTitle:(NSString *)title userName:(NSString *)userName password:(NSString *)password
{
    self = [super init];
    if (self) {
        self.title = title;
        self.username = userName;
        self.password = password;
        //
        [self setupUI];
    }
    return self;
}

- (void)setupUI
{
    self.frame = [UIScreen mainScreen].bounds;
    self.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5];
    
    CGFloat margin = CFC_AUTOSIZING_MARGIN(MARGIN);
    CGFloat alterbgwidth = self.frame.size.width * 0.8f;
    CGFloat alterbgheight = alterbgwidth *0.65f;
    
    UIFont *titleFont = [UIFont boldSystemFontOfSize:CFC_AUTOSIZING_FONT(13)];
    CGFloat titleWidth = [NSLocalizedString(@"会员用户名", nil) widthWithFont:titleFont constrainedToHeight:CGFLOAT_MAX];
    
    // 背景
    UIView *contentView = [[UIView alloc] init];
    [contentView setCenter:self.center];
    [contentView setBackgroundColor:[UIColor whiteColor]];
    [contentView setBounds:CGRectMake(0, 0, alterbgwidth, alterbgheight)];
    [self addSubview:contentView];

    // 图标
    UIImageView *iconImageView = ({
        UIImageView *imageView = [[UIImageView alloc] init];
        [contentView addSubview:imageView];
        [imageView setImage:[UIImage imageNamed:@"icon_agent_regsuccess"]];
        [imageView setContentMode:UIViewContentModeScaleAspectFill];

        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            CGFloat imageSize = CFC_AUTOSIZING_WIDTH(40.0f);
            make.top.equalTo(contentView.mas_top).offset(margin*3.0f);
            make.left.equalTo(contentView.mas_left).offset(margin*3.0f);
            make.size.mas_equalTo(CGSizeMake(imageSize, imageSize));
        }];
        
        imageView;
    });
    iconImageView.mas_key = @"iconImageView";
    
    // 标题
    UILabel *titleLabel = ({
        UILabel *label = [UILabel new];
        [contentView addSubview:label];
        [label setText:self.title];
        [label setFont:[UIFont boldSystemFontOfSize:CFC_AUTOSIZING_FONT(15)]];
        [label setTextColor:COLOR_SYSTEM_MAIN_FONT_DEFAULT];
        [label setTextAlignment:NSTextAlignmentLeft];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(iconImageView.mas_centerY);
            make.left.equalTo(iconImageView.mas_right).offset(margin*1.0f);
            make.right.equalTo(contentView.mas_right).offset(-margin*1.0f);
        }];
        
        label;
    });
    titleLabel.mas_key = @"titleLabel";
    
    // 提示
    UILabel *tipInfoLabel = ({
        UILabel *label = [UILabel new];
        [contentView addSubview:label];
        [label setText:NSLocalizedString(@"点击下方按钮复制分享给会员", nil)];
        [label setFont:[UIFont systemFontOfSize:CFC_AUTOSIZING_FONT(11)]];
        [label setTextColor:COLOR_SYSTEM_MAIN_FONT_ASSIST_DEFAULT];
        [label setTextAlignment:NSTextAlignmentLeft];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(iconImageView.mas_centerY).offset(margin*0.5f);
            make.left.right.equalTo(titleLabel);
        }];
        
        label;
    });
    tipInfoLabel.mas_key = @"tipInfoLabel";
    
    // 用户名
    UILabel *userNameLabel = ({
        UILabel *titleLabel = [UILabel new];
        [contentView addSubview:titleLabel];
        [titleLabel setText:NSLocalizedString(@"会员用户名", nil)];
        [titleLabel setFont:titleFont];
        [titleLabel setTextColor:COLOR_HEXSTRING(@"#808080")];
        [titleLabel setTextAlignment:NSTextAlignmentLeft];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(iconImageView.mas_bottom).offset(margin*2.0f);
            make.left.equalTo(iconImageView);
            make.width.mas_equalTo(titleWidth);
        }];
        
        UILabel *label = [UILabel new];
        [contentView addSubview:label];
        [label setText:self.username];
        [label setFont:[UIFont boldSystemFontOfSize:CFC_AUTOSIZING_FONT(12)]];
        [label setTextColor:COLOR_SYSTEM_MAIN_FONT_DEFAULT];
        [label setTextAlignment:NSTextAlignmentLeft];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(titleLabel.mas_centerY);
            make.left.equalTo(titleLabel.mas_right).offset(margin*2.0f);
            make.right.equalTo(contentView.mas_right).offset(-margin*1.0f);
        }];
        
        label;
    });
    userNameLabel.mas_key = @"userNameLabel";
    
    // 会员密码
    UILabel *passwordLabel = ({
        UILabel *titleLabel = [UILabel new];
        [contentView addSubview:titleLabel];
        [titleLabel setText:NSLocalizedString(@"会员密码", nil)];
        [titleLabel setFont:titleFont];
        [titleLabel setTextColor:COLOR_HEXSTRING(@"#808080")];
        [titleLabel setTextAlignment:NSTextAlignmentLeft];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(userNameLabel.mas_bottom).offset(margin*1.5f);
            make.left.equalTo(iconImageView);
            make.width.mas_equalTo(titleWidth);
        }];
        
        UILabel *label = [UILabel new];
        [contentView addSubview:label];
        [label setText:self.password];
        [label setFont:[UIFont boldSystemFontOfSize:CFC_AUTOSIZING_FONT(12)]];
        [label setTextColor:COLOR_SYSTEM_MAIN_FONT_DEFAULT];
        [label setTextAlignment:NSTextAlignmentLeft];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(titleLabel.mas_centerY);
            make.left.equalTo(titleLabel.mas_right).offset(margin*2.0f);
            make.right.equalTo(contentView.mas_right).offset(-margin*1.0f);
        }];
        
        label;
    });
    passwordLabel.mas_key = @"passwordLabel";
    
    // 复制按钮
    UIButton *confirmButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [confirmButton setBackgroundColor:[UIColor whiteColor]];
    [confirmButton.titleLabel setFont:[UIFont boldSystemFontOfSize:CFC_AUTOSIZING_FONT(16.0f)]];
    [confirmButton setTitleColor:COLOR_SYSTEM_MAIN_FONT_DEFAULT forState:UIControlStateNormal];
    [confirmButton addTarget:self action:@selector(pressConfirmButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [confirmButton setTitle:NSLocalizedString(@"复制用户名及密码", nil) forState:UIControlStateNormal];
    [contentView addSubview:confirmButton];
    [confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(contentView.mas_bottom).offset(-margin*0.5f);
        make.left.right.equalTo(contentView);
        make.height.mas_equalTo(@(40));
    }];
    self.confirmButton = confirmButton;
    self.confirmButton.mas_key = @"confirmButton";
    
    [self showWithAlert:contentView];
}


- (void)pressConfirmButtonAction
{
    NSString *content = [NSString stringWithFormat:NSLocalizedString(@"账号:%@ 密码:%@", nil), self.username, self.password];
    UIPasteboard *pastboard = [UIPasteboard generalPasteboard];
    pastboard.string = content;
    //
    [self.confirmButton setTitleColor:COLOR_HEXSTRING(@"#57BE6A") forState:UIControlStateNormal];
    [self.confirmButton setTitle:NSLocalizedString(@"复制成功", nil) forState:UIControlStateNormal];
    //
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self dismissAlert];
    });
}

- (void)showWithAlert:(UIView*)alert
{
    CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = kAnimationTimeInterval;
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9, 0.9, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    animation.values = values;
    [alert.layer addAnimation:animation forKey:nil];
}

- (void)dismissAlert
{
    [UIView animateWithDuration:kAnimationTimeInterval animations:^{
        self.transform = (CGAffineTransformMakeScale(1.5, 1.5));
        self.backgroundColor = [UIColor clearColor];
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        //
        if (self.confirmActionBlock) {
            self.confirmActionBlock();
        }
    } ];
    
}


@end

