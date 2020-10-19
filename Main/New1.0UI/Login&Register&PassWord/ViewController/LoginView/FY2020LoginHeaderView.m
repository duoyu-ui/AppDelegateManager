//
//  FY2020LoginHeaderView.m
//  FY_OC
//
//  Created by FangYuan on 2020/1/30.
//  Copyright © 2020 FangYuan. All rights reserved.
//

#import "FY2020LoginHeaderView.h"

@implementation FY2020LoginHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self imageView];
        [self buttonAction:self.buttonLeft];
        [self buttonRight];
        [self.buttonLeft setTitle:NSLocalizedString(@"登录", nil) forState:UIControlStateNormal];
        [self.buttonRight setTitle:NSLocalizedString(@"注册", nil) forState:UIControlStateNormal];
    }
    return self;
}

-(void)buttonAction:(UIButton *)sender{
    if (self.currentButton) {
        self.currentButton.selected = NO;
    }
    self.currentButton = sender;
    self.currentButton.selected = YES;
    if (self.buttonCallBack) {
        self.buttonCallBack(sender);
    }
    [self updateIndicator];
}

-(void)updateIndicator{
    if (self.redCenter) {
        self.redCenter.active = NO;
        [self.redIndicator removeConstraint:self.redCenter];
    }
    self.redCenter = [self.redIndicator.centerXAnchor constraintEqualToAnchor:self.currentButton.centerXAnchor];
    self.redCenter.active = YES;
}

- (UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [UIImageView new];
        _imageView.image = [UIImage imageNamed:@"icon_login_top"];
        [self addSubview:_imageView];
        _imageView.translatesAutoresizingMaskIntoConstraints = NO;
        [_imageView.widthAnchor constraintEqualToAnchor:self.widthAnchor].active = YES;
//        CGFloat width = [UIScreen mainScreen].bounds.size.width;
//        [_imageView.widthAnchor constraintEqualToConstant:width].active = YES;
        [_imageView.heightAnchor constraintEqualToAnchor:self.widthAnchor multiplier:(405/719.0)].active = YES;
//        [_imageView.heightAnchor constraintEqualToConstant:100].active = YES;
        [_imageView.topAnchor constraintEqualToAnchor:self.topAnchor].active = YES;
        [_imageView.centerXAnchor constraintEqualToAnchor:self.centerXAnchor].active = YES;
    }
    return _imageView;
}

- (UIButton *)buttonLeft{
    if (!_buttonLeft) {
        _buttonLeft = [UIButton new];
        [self addSubview:_buttonLeft];
        [_buttonLeft addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [_buttonLeft setTitle:NSLocalizedString(@"登录", nil) forState:UIControlStateNormal];
        [_buttonLeft setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
        [_buttonLeft setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        _buttonLeft.translatesAutoresizingMaskIntoConstraints = NO;
        [_buttonLeft.heightAnchor constraintEqualToConstant:35].active = YES;
        [_buttonLeft.topAnchor constraintEqualToAnchor:self.imageView.bottomAnchor].active=YES;
        [_buttonLeft.rightAnchor constraintEqualToAnchor:self.centerXAnchor].active = YES;
        [_buttonLeft.leftAnchor constraintEqualToAnchor:self.leftAnchor].active = YES;
    }
    return _buttonLeft;
}

- (UIButton *)buttonRight{
    if (!_buttonRight) {
        _buttonRight = [UIButton new];
        [self addSubview:_buttonRight];
        [_buttonRight addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [_buttonRight setTitle:NSLocalizedString(@"注册", nil) forState:UIControlStateNormal];
        [_buttonRight setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
        [_buttonRight setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        _buttonRight.selected = NO;
        _buttonRight.translatesAutoresizingMaskIntoConstraints = NO;
        [_buttonRight.heightAnchor constraintEqualToConstant:35].active = YES;
        [_buttonRight.topAnchor constraintEqualToAnchor:self.imageView.bottomAnchor].active=YES;
        [_buttonRight.rightAnchor constraintEqualToAnchor:self.rightAnchor].active = YES;
        [_buttonRight.leftAnchor constraintEqualToAnchor:self.centerXAnchor].active = YES;
    }
    return _buttonRight;
}

- (UIView *)redIndicator{
    if (!_redIndicator) {
        _redIndicator=[UIView new];
        _redIndicator.backgroundColor = [UIColor redColor];
        [self addSubview:_redIndicator];
        _redIndicator.translatesAutoresizingMaskIntoConstraints = NO;
        [_redIndicator.widthAnchor constraintEqualToConstant:15].active = YES;
        [_redIndicator.heightAnchor constraintEqualToConstant:2].active = YES;
        [_redIndicator.topAnchor constraintEqualToAnchor:self.buttonLeft.bottomAnchor].active = YES;
    }
    return _redIndicator;
}

@end
