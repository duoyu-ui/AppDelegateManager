//
//  FYMultiRowLabel.m
//  ProjectCSHB
//
//  Created by fangyuan on 2020/5/27.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "FYMultiRowLabel.h"

@interface FYMultiRowLabel ()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *contentLabel;
@end


@implementation FYMultiRowLabel

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
            make.bottom.equalTo(self.mas_centerY);
        }];
        
        label;
    });
    self.titleLabel = titleLabel;
    self.titleLabel.mas_key = @"titleLabel";
    
    UILabel *contentLabel = ({
        UILabel *label = [UILabel new];
        [self addSubview:label];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.top.equalTo(self.mas_centerY).offset(5.0f);
        }];
        
        label;
    });
    self.contentLabel = contentLabel;
    self.contentLabel.mas_key = @"contentLabel";
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

- (void)setContent:(NSString *)title
{
    [self.contentLabel setText:title];
}

- (void)setContentFont:(UIFont *)font
{
    [self.contentLabel setFont:font];
}

- (void)setContentColor:(UIColor *)color
{
    [self.contentLabel setTextColor:color];
}

- (void)setContentTextAlignment:(NSTextAlignment)textAlignment
{
    [self.contentLabel setTextAlignment:textAlignment];
}

@end
