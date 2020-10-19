
//
//  FYPockerView.m
//  ProjectCSHB
//
//  Created by Tom on 2020/8/24.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "FYPockerView.h"

@interface FYPockerView ()
@property (nonatomic , strong) UIImageView *bgImgView;

@end
@implementation FYPockerView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubview];
    }
    return self;
}
- (void)setImgViewImgWithPokers:(FYBestWinsLossesPokers *)pokers flopType:(NSInteger)flopType{
    self.flopType = flopType;
    if (flopType == 0) {//反面
        self.imgView.image = [UIImage imageNamed:@"back_poker_icon"];
        self.pokerView.hidden = YES;
        self.imgView.hidden = NO;
    } else {
        self.pokerView.pokers = pokers;
        self.pokerView.hidden = NO;
        self.imgView.hidden = YES;
    }
}
- (void)initSubview{
    self.backgroundColor = UIColor.clearColor;
    [self.imgView addBoard:1 color:UIColor.blackColor];
    [self.imgView addShadowAndRound:2 round:6];
    
    [self addSubview:self.bgImgView];
    [self.bgImgView addSubview:self.pokerView];
    [self.bgImgView addSubview:self.imgView];
    [self.bgImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [self.pokerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}
- (UIImageView *)bgImgView{
    if (!_bgImgView) {
        _bgImgView = [[UIImageView alloc]init];
        _bgImgView.image = [UIImage imageNamed:@"back_poker_icon"];
    }
    return _bgImgView;
}
- (UIImageView *)imgView{
    if (!_imgView) {
        _imgView = [[UIImageView alloc]init];
        _imgView.image = [UIImage imageNamed:@"back_poker_icon"];
        _imgView.hidden = YES;
    }
    return _imgView;
}
- (FYPokerCardView *)pokerView{
    if (!_pokerView) {
        _pokerView = [[FYPokerCardView alloc]init];
    }
    return _pokerView;
}
@end
