//
//  FYChatJieLongCell.m
//  ProjectCSHB
//
//  Created by Tom on 2020/7/1.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "FYChatJieLongCell.h"
@interface FYChatJieLongCell()
@property (nonatomic , strong) UILabel *nickLab;
@property (nonatomic , strong) UILabel *numLab;
@property (nonatomic , strong) UIImageView *imgView;
@end
@implementation FYChatJieLongCell
- (void)setList:(SSChatJieLongGrabList *)list{
    _list = list;
    self.nickLab.text = list.nick;
    self.numLab.text = list.money;
    if (list.isBest) {
        self.imgView.hidden = NO;
        self.imgView.image = [UIImage imageNamed:@"jieLongLickIcon"];
    }else if (list.isWorst) {
        self.imgView.hidden = NO;
        self.imgView.image = [UIImage imageNamed:@"jieLongWorstIcon"];
    }else{
        self.imgView.hidden = YES;
    }
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = UIColor.whiteColor;
        [self initSubView];
    }
    return self;
}
- (void)initSubView{
    [self addSubview:self.nickLab];
    [self addSubview:self.numLab];
    [self addSubview:self.imgView];
    [self.nickLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.centerY.equalTo(self);
        make.right.equalTo(self.mas_centerX);
    }];
    [self.numLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self.mas_centerX).offset(20);
    }];
    [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(12);
        make.centerY.equalTo(self);
        make.left.equalTo(self.numLab.mas_right).offset(3);
    }];
}
- (UILabel *)nickLab{
    if (!_nickLab) {
        _nickLab = [[UILabel alloc]init];
        _nickLab.textColor = HexColor(@"#1A1A1A");
        _nickLab.font = [UIFont systemFontOfSize:kCellFont];
    }
    return _nickLab;
}
- (UILabel *)numLab{
    if (!_numLab) {
        _numLab = [[UILabel alloc]init];
        _numLab.textColor = HexColor(@"#1A1A1A");
        _numLab.font = [UIFont systemFontOfSize:kCellFont];
    }
    return _numLab;
}
- (UIImageView *)imgView{
    if (!_imgView) {
        _imgView = [[UIImageView alloc]init];
    }
    return _imgView;
}
@end
