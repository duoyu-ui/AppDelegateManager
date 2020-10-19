//
//  FYRobChatKeyBordCell.m
//  ProjectCSHB
//
//  Created by Tom on 2020/6/25.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "FYRobChatKeyBordCell.h"
@interface FYRobChatKeyBordCell()
@property (nonatomic , strong) UIView *bgView;
@end
@implementation FYRobChatKeyBordCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setSubviews];
    }
    return self;
}

- (void)setSubviews{
    [self.contentView addSubview:self.bgView];
    [self.bgView addSubview:self.numLab];
    [self.bgView addSubview:self.imgView];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.contentView);
        make.top.left.mas_equalTo(2);
    }];
    [self.numLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.bgView);
    }];
    [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.bgView);
        make.width.height.mas_equalTo(45);
    }];
    
}
- (UIView *)bgView{
    if (!_bgView) {
        _bgView = [[UIView alloc]init];
        _bgView.layer.masksToBounds = YES;
        _bgView.layer.cornerRadius = 8;
        _bgView.backgroundColor = UIColor.whiteColor;
    }
    return _bgView;
}

- (UILabel *)numLab{
    if (!_numLab) {
        _numLab = [[UILabel alloc]init];
        _numLab.textColor = UIColor.blackColor;
        _numLab.textAlignment = NSTextAlignmentCenter;
        _numLab.font = [UIFont boldSystemFontOfSize:22];
        _numLab.hidden = YES;
    }
    return _numLab;
}
- (UIImageView *)imgView{
    if (!_imgView) {
        _imgView = [[UIImageView alloc]init];
        _imgView.hidden = YES;
    }
    return _imgView;;
}
@end
