//
//  FYBagLotteryBetCollectionViewCell.m
//  ProjectCSHB
//
//  Created by Tom on 2020/7/18.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "FYBagLotteryBetCollectionViewCell.h"
@interface FYBagLotteryBetCollectionViewCell()
@property (nonatomic , strong) UIView *bgView;
@property (nonatomic , strong) UILabel *nameLab;
@property (nonatomic , strong) UILabel *betLab;
@property (nonatomic , strong) UIImageView *selectedImgView;
@end

@implementation FYBagLotteryBetCollectionViewCell

- (void)setList:(FYBagLotteryBetList *)list
{
    _list = list;
    self.nameLab.text = list.name;
    if ([list.bet containsaString:@"."]) {
        CGFloat bet = [list.bet floatValue];
        self.betLab.text = [NSString stringWithFormat:@"%.2lf",bet];
    }else{
        self.betLab.text = list.bet;
    }
    self.selectedImgView.image = list.selected  ? [UIImage imageNamed:@"bagLotteryBg_selected_Icon"] : [UIImage new];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubview];
    }
    return self;
}

- (void)initSubview
{
    self.contentView.backgroundColor = UIColor.clearColor;
    [self.contentView addSubview:self.bgView];
    [self.bgView addSubview:self.nameLab];
    [self.bgView addSubview:self.betLab];
    [self.bgView addSubview:self.selectedImgView];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.contentView);
        make.top.left.mas_equalTo(0);
        make.bottom.mas_equalTo(-7);
    }];
    [self.nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.bgView);
        make.centerX.equalTo(self.bgView.mas_right).multipliedBy(0.4f);
    }];
    [self.betLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bgView.mas_top).offset(5);
        make.right.equalTo(self.bgView.mas_right).multipliedBy(0.9f);
    }];
    [self.selectedImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.equalTo(self.bgView);
        make.size.mas_equalTo(CGSizeMake(25, 17));
    }];
 
}

- (UILabel *)nameLab{
    if (!_nameLab) {
        _nameLab = [[UILabel alloc]init];
        _nameLab.textColor = HexColor(@"#333333");
        _nameLab.font = FONT_PINGFANG_SEMI_BOLD(16);
    }
    return _nameLab;
}
- (UILabel *)betLab{
    if (!_betLab) {
        _betLab = [[UILabel alloc]init];
        _betLab.textColor = HexColor(@"#C5C5C5");
        _betLab.font = FONT_PINGFANG_SEMI_BOLD(11);
    }
    return _betLab;
}
- (UIImageView *)selectedImgView{
    if (!_selectedImgView) {
        _selectedImgView = [[UIImageView alloc]init];
    }
    return _selectedImgView;
}
- (UIView *)bgView{
    if (!_bgView) {
        _bgView = [[UIView alloc]init];
        _bgView.layer.cornerRadius = 4;
        _bgView.layer.masksToBounds = NO;
        _bgView.backgroundColor = UIColor.whiteColor;
        _bgView.layer.shadowColor = HexColor(@"#D1D1D1").CGColor;//shadowColor阴影颜色
        _bgView.layer.shadowOffset = CGSizeMake(0,2);//shadowOffset阴影偏移,x向右偏移4，y向下偏移4，默认(0, -3),这个跟shadowRadius配合使用
//        _bgView.layer.shadowOpacity = 0.5;//阴影透明度，默认0
        _bgView.layer.shadowRadius = 0;//阴影半径，默认3
     
    }
    return _bgView;
}

@end
