//
//  FYLoginView.m
//  ProjectCSHB
//
//  Created by Tom on 2020/1/14.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "FYLoginView.h"
@interface FYLoginView()
@property (nonatomic ,strong)UIImageView *iconView;
@property (nonatomic ,strong)UILabel *titleLab;
@end
@implementation FYLoginView
- (void)setImg:(UIImage *)img title:(NSString *)title{
    self.iconView.image = img;
    self.titleLab.text = title;
}
- (void)loginClick{
    if (self.block != nil) {
        self.block();
    }
}
- (void)makeUI{
    [self addSubview:self.iconView];
    [self addSubview:self.titleLab];
    [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.centerX.equalTo(self);
        make.width.height.mas_equalTo(40);
    }];
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.iconView.mas_bottom).offset(5);
    }];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self makeUI];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(loginClick)];
        [self addGestureRecognizer:tap];
    }
    return self;
}
//- (void)layoutSubviews{
//    [super layoutSubviews];
//    [self makeUI];
//}
- (UIImageView *)iconView{
    if (!_iconView) {
        _iconView = [[UIImageView alloc]init];
    }
    return _iconView;
}
- (UILabel *)titleLab{
    if (!_titleLab) {
        _titleLab = [[UILabel alloc]init];
        _titleLab.font = [UIFont systemFontOfSize:13];
        _titleLab.textColor = UIColor.grayColor;
    }
    return _titleLab;
}
@end
