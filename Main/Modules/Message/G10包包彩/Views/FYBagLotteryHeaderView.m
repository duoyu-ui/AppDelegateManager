//
//  FYBagLotteryHeaderView.m
//  ProjectCSHB
//
//  Created by Tom on 2020/7/18.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "FYBagLotteryHeaderView.h"
@interface FYBagLotteryHeaderView ()
@property (nonatomic , strong) UILabel *titleLab;
@property (nonatomic , strong) UIView *lineView;
@end
@implementation FYBagLotteryHeaderView
- (void)setConfig:(FYBagLotteryBetConfig *)config{
    _config = config;
    self.titleLab.text = config.title;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//        self.backgroundColor = HexColor(@"#F8F8F8");
        
        [self addSubview:self.titleLab];
        [self addSubview:self.lineView];
        [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
//            make.top.mas_equalTo(10);
        }];
        [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(kLineHeight);
            make.bottom.equalTo(self.mas_bottom).offset(-2);
            make.centerX.equalTo(self);
            make.left.mas_equalTo(4);
        }];
    }
    return self;
}
- (UILabel *)titleLab{
    if (!_titleLab) {
        _titleLab = [[UILabel alloc]init];
        _titleLab.font = FONT_PINGFANG_REGULAR(14);
        _titleLab.textColor = HexColor(@"#6B6B6B");
    }
    return _titleLab;
}
- (UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc]init];
        _lineView.backgroundColor = HexColor(@"#E6E6E6");
    }
    return _lineView;
}
@end
