//
//  FYCenterMoneyLabel.m
//  ProjectCSHB
//
//  Created by fangyuan on 2020/5/19.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "FYCenterMoneyLabel.h"

@interface FYCenterMoneyLabel ()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *moneyLabel;
@end


@implementation FYCenterMoneyLabel

#pragma mark - Life Cycle

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self createViewAtuoLayout];
    }
    return self;
}

- (void)createViewAtuoLayout
{
    UILabel *titleLabel = ({
        UILabel *label = [UILabel new];
        [self addSubview:label];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.top.equalTo(self.mas_centerY).offset(2.5f);
        }];
        
        label;
    });
    self.titleLabel = titleLabel;
    self.titleLabel.mas_key = @"titleLabel";
    
    UILabel *moneyLabel = ({
        UILabel *label = [UILabel new];
        [self addSubview:label];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.bottom.equalTo(self.mas_centerY);
        }];
        
        label;
    });
    self.moneyLabel = moneyLabel;
    self.moneyLabel.mas_key = @"moneyLabel";
}


- (void)setTitle:(NSString *)title
{
    [self.titleLabel setText:title];
}

- (void)setTitleFont:(UIFont *)font
{
    [self.titleLabel setFont:font];
}

- (void)setTitleColor:(UIColor *)color
{
    [self.titleLabel setTextColor:color];
}

- (void)setTitleTextAlignment:(NSTextAlignment)textAlignment
{
    [self.titleLabel setTextAlignment:textAlignment];
}

- (void)setMoney:(NSString *)title
{
    [self.moneyLabel setText:title];
}

- (void)setMoneyFont:(UIFont *)font
{
    [self.moneyLabel setFont:font];
}

- (void)setMoneyColor:(UIColor *)color
{
    [self.moneyLabel setTextColor:color];
}

- (void)setMoneyTextAlignment:(NSTextAlignment)textAlignment
{
    [self.moneyLabel setTextAlignment:textAlignment];
}

@end
