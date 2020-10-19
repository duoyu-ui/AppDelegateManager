//
//  FYPokerCardView.m
//  ProjectCSHB
//
//  Created by Tom on 2020/8/24.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "FYPokerCardView.h"
@interface FYPokerCardView ()
@property (nonatomic , strong) UILabel *textLab;
@property (nonatomic , strong) UILabel *tipInfoLab;
@property (nonatomic , strong) UIImageView *bgImgView;
@end
@implementation FYPokerCardView
- (void)setTipInfoLabel
{
    
}
- (void)setPokers:(FYBestWinsLossesPokers *)pokers{
    _pokers = pokers;
    self.tipInfoLab.hidden = YES;
    self.textLab.text = pokers.text;
    self.bgImgView.image = pokers.pokersImg;
    if ([pokers.type intValue] == 2 || [pokers.type intValue] == 3) {
        self.textLab.textColor = HexColor(@"#D81E06");
    }else{
        self.textLab.textColor = HexColor(@"#000000");
    }
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColor.whiteColor;
        [self addBoard:1 color:UIColor.blackColor];
        [self addShadowAndRound:2 round:6];
        [self addSubview:self.textLab];
        [self addSubview:self.bgImgView];
        [self addSubview:self.tipInfoLab];
        [self.bgImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.centerX.equalTo(self.mas_right).multipliedBy(0.32);
            make.width.height.equalTo(self.mas_height).multipliedBy(0.6);
        }];
        [self.textLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.centerX.equalTo(self.mas_right).multipliedBy(0.7);
        }];
        [self.tipInfoLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
    }
    return self;
}
- (UILabel *)tipInfoLab{
    if (!_tipInfoLab) {
        _tipInfoLab = [[UILabel alloc]init];
        _tipInfoLab.text = @"？";
        _tipInfoLab.textColor = HexColor(@"#000000");
        _tipInfoLab.font = [UIFont boldSystemFontOfSize:12];
        _tipInfoLab.textAlignment = NSTextAlignmentCenter;
    }
    return _tipInfoLab;
}
- (UILabel *)textLab{
    if (!_textLab) {
        _textLab = [[UILabel alloc]init];
        _textLab.font = [UIFont boldSystemFontOfSize:12];
        _textLab.textAlignment = NSTextAlignmentCenter;
    }
    return _textLab;
}
- (UIImageView *)bgImgView{
    if (!_bgImgView) {
        _bgImgView = [[UIImageView alloc]init];
    }
    return _bgImgView;
}
@end
