//
//  FYMsgAlertView.m
//  ProjectCSHB
//
//  Created by fangyuan on 2020/5/29.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "FYMsgAlertView.h"

const CGFloat kFYMsgAnimationTimeInterval = 0.3f;

@interface FYMsgAlertView()

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *content;

@property (nonatomic, strong) UIButton *confirmButton;

@property (nonatomic, strong) UIButton *cancleButton;

@end


@implementation FYMsgAlertView

+ (void)alertWithTitle:(NSString *)title content:(NSString *)content confirmBlock:(void(^)(void))confirmBlock cancleBlock:(void(^)(void))cancleBlock
{
    FYMsgAlertView *alertView = [[FYMsgAlertView alloc] initTitle:title content:content confirmBlock:confirmBlock cancleBlock:cancleBlock];
    [alertView setConfirmActionBlock:confirmBlock];
    [alertView setCancleActionBlock:cancleBlock];
    [[UIApplication sharedApplication].delegate.window addSubview:alertView];
}

- (instancetype)initTitle:(NSString *)title content:(NSString *)content confirmBlock:(void(^)(void))confirmBlock cancleBlock:(void(^)(void))cancleBlock
{
    self = [super init];
    if (self) {
        self.title = title;
        self.content = content;
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
    CGFloat alterbgheight = alterbgwidth *0.43f;
    CGFloat buttonWidth = alterbgwidth * 0.33f;
    CGFloat buttonHeight = buttonWidth * 0.30f;
    
    // 背景
    UIView *contentView = [[UIView alloc] init];
    [contentView setCenter:self.center];
    [contentView setBackgroundColor:[UIColor whiteColor]];
    [contentView setBounds:CGRectMake(0, 0, alterbgwidth, alterbgheight)];
    [self addSubview:contentView];
    
    // 标题
    UILabel *titleLabel = ({
        UILabel *label = [UILabel new];
        [contentView addSubview:label];
        [label setText:self.title];
        [label setTextAlignment:NSTextAlignmentCenter];
        [label setTextColor:COLOR_SYSTEM_MAIN_FONT_DEFAULT];
        [label setFont:[UIFont boldSystemFontOfSize:CFC_AUTOSIZING_FONT(16)]];

        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(contentView.mas_bottom).multipliedBy(0.25f);
            make.left.equalTo(contentView.mas_left).offset(margin*1.0f);
            make.right.equalTo(contentView.mas_right).offset(-margin*1.0f);
        }];
        
        label;
    });
    titleLabel.mas_key = @"titleLabel";
    
    // 内容
    UILabel *contentLabel = ({
        UILabel *label = [UILabel new];
        [contentView addSubview:label];
        [label setText:self.content];
        [label setTextAlignment:NSTextAlignmentCenter];
        [label setTextColor:COLOR_SYSTEM_MAIN_FONT_DEFAULT];
        [label setFont:[UIFont systemFontOfSize:CFC_AUTOSIZING_FONT(15)]];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(titleLabel);
            if (VALIDATE_STRING_EMPTY(self.title)) {
                make.centerY.equalTo(contentView.mas_bottom).multipliedBy(0.4f);
            } else {
                make.top.equalTo(titleLabel.mas_bottom).offset(margin);
            }
        }];
        
        label;
    });
    contentLabel.mas_key = @"contentLabel";
    
    // 确认
    UIButton *cancleButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [cancleButton defaultStyleButton];
    [cancleButton.titleLabel setFont:[UIFont boldSystemFontOfSize:CFC_AUTOSIZING_FONT(14.0f)]];
    [cancleButton addTarget:self action:@selector(pressCancleButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [cancleButton setTitle:NSLocalizedString(@"取消", nil) forState:UIControlStateNormal];
    [contentView addSubview:cancleButton];
    [cancleButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(contentView.mas_bottom).offset(-margin*1.5f);
        make.centerX.equalTo(contentView.mas_right).multipliedBy(0.25f);
        make.size.mas_equalTo(CGSizeMake(buttonWidth, buttonHeight));
    }];
    self.cancleButton = cancleButton;
    self.cancleButton.mas_key = @"cancleButton";
    
    // 确认
    UIButton *confirmButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [confirmButton defaultStyleButton];
    [confirmButton.titleLabel setFont:[UIFont boldSystemFontOfSize:CFC_AUTOSIZING_FONT(14.0f)]];
    [confirmButton addTarget:self action:@selector(pressConfirmButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [confirmButton setTitle:NSLocalizedString(@"确认", nil) forState:UIControlStateNormal];
    [contentView addSubview:confirmButton];
    [confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(contentView.mas_bottom).offset(-margin*1.5f);
        make.centerX.equalTo(contentView.mas_right).multipliedBy(0.75f);
        make.size.mas_equalTo(CGSizeMake(buttonWidth, buttonHeight));
    }];
    self.confirmButton = confirmButton;
    self.confirmButton.mas_key = @"confirmButton";
    
    [self showWithAlert:contentView];
}

- (void)pressCancleButtonAction
{
    [self dismissAlert:self.cancleActionBlock];
}

- (void)pressConfirmButtonAction
{
    [self dismissAlert:self.confirmActionBlock];
}

- (void)showWithAlert:(UIView*)alert
{
    CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = kFYMsgAnimationTimeInterval;
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9, 0.9, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    animation.values = values;
    [alert.layer addAnimation:animation forKey:nil];
}

- (void)dismissAlert:(void(^)(void))block;
{
    [UIView animateWithDuration:kFYMsgAnimationTimeInterval animations:^{
        self.transform = (CGAffineTransformMakeScale(1.5, 1.5));
        self.backgroundColor = [UIColor clearColor];
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        //
        if (block) {
            block();
        }
    } ];
    
}


@end

