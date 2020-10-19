//
//  FYYEBIconMarkView.m
//  ProjectCSHB
//
//  Created by fangyuan on 2020/5/26.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "FYYEBIconMarkView.h"

@interface FYYEBIconMarkView ()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *imageView;
@end

@implementation FYYEBIconMarkView

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
            make.top.equalTo(self.mas_centerY).offset(5.0f);
        }];
        
        label;
    });
    self.titleLabel = titleLabel;
    self.titleLabel.mas_key = @"titleLabel";
    
    UIImageView *imageView = ({
        UIImageView *imageView = [UIImageView new];
        [self addSubview:imageView];
        [imageView setContentMode:UIViewContentModeScaleAspectFit];
        
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.bottom.equalTo(self.mas_centerY);
            make.width.height.equalTo(self.mas_height).multipliedBy(0.43f);
        }];
        
        imageView;
    });
    self.imageView = imageView;
    self.imageView.mas_key = @"imageView";
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

- (void)setImageUrl:(NSString *)imageUrl
{
    [self.imageView setImage:[UIImage imageNamed:imageUrl]];
}

@end
