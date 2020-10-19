//
//  ShareListCell.m
//  Project
//
//  Created by fy on 2019/1/3.
//  Copyright © 2019 CDJay. All rights reserved.
//

#import "ShareListCell.h"

@implementation ShareListCell

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    return self;
}

-(void)initView{
    self.contentView.backgroundColor = [UIColor clearColor];
    self.conView = [[UIView alloc] init];
    self.conView.backgroundColor = [UIColor whiteColor];
    self.conView.layer.masksToBounds = YES;
    self.conView.layer.cornerRadius = 6.0;
    self.conView.layer.borderColor = HexColor(@"#E6E6E6").CGColor;
    self.conView.layer.borderWidth = 0.5;
    [self.contentView addSubview:self.conView];
    [self.conView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    
    
    
    
    
    

    UIButton *numBtn = [[UIButton alloc] init];
    [numBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    numBtn.titleLabel.font = [UIFont systemFontOfSize:11];
    numBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.conView addSubview:numBtn];
    [numBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.conView).offset(0);
        make.left.equalTo(self.conView).offset(7);
        make.width.equalTo(@50);
        make.height.equalTo(@27);
    }];
    [numBtn setBackgroundImage:[UIImage imageNamed:@"copyTagBg"] forState:UIControlStateNormal];
    self.numBtn = numBtn;
    
    UIImageView *starView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pingfen"]];
    starView.contentMode = UIViewContentModeScaleAspectFit;
    [self.conView addSubview:starView];
    [starView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.numBtn);
            make.right.equalTo(self.conView).offset(-7);
        make.height.equalTo(@15);
    }];
    
    UIView* redView = [[UIView alloc]init];
    redView.backgroundColor = HEXCOLOR(0xfd4c56);//
    [self.conView addSubview:redView];
    [redView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.conView).offset(0);
        make.bottom.equalTo(self.conView).offset(0);
        make.height.equalTo(@46);
    }];
    
    self.scanBtn = [[UIButton alloc] init];
    [self.scanBtn setTitleColor:HEXCOLOR(0xffffff) forState:UIControlStateNormal];
    [self.scanBtn setImage:[UIImage imageNamed:@"chakan"] forState:UIControlStateNormal];
    self.scanBtn.titleLabel.font = [UIFont systemFontOfSize2:13];
    [self.conView addSubview:self.scanBtn];
    [self.scanBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.conView).offset(-8);
        make.centerY.equalTo(redView);
    }];
    [self.scanBtn layoutButtonWithEdgeInsetsStyle:GLButtonEdgeInsetsStyleLeft imageTitleSpace:3];
    
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.textColor = HEXCOLOR(0xffffff);
    titleLabel.font = [UIFont boldSystemFontOfSize2:15];
    [self.conView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.conView).offset(8);
        make.centerY.equalTo(redView);
        make.right.equalTo(self.scanBtn.mas_left).offset(-8);
    }];
    self.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    self.titleLabel = titleLabel;
    
    UIImageView *iconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"discover_bjsc"]];
//    iconView.layer.masksToBounds = YES;
//    iconView.layer.cornerRadius = 5.0;
//    iconView.contentMode = UIViewContentModeScaleAspectFill;
    iconView.backgroundColor = Color_6;
    [self.conView addSubview:iconView];
    [iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(starView);
        make.top.equalTo(self.numBtn.mas_bottom).offset(7);
        make.left.equalTo(self.numBtn);
        make.bottom.equalTo(redView.mas_top).offset(-7);
    }];
    self.iconView = iconView;
}

@end
