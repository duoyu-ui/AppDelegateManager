//
//  ChatNiuNiuReportContentCell.m
//  Project
//
//  Created by 汤姆 on 2019/9/5.
//  Copyright © 2019 CDJay. All rights reserved.
//

#import "ChatNiuNiuReportContentCell.h"
#import "FYFriendName.h"

@interface ChatNiuNiuReportContentCell()
/** 昵称*/
@property (nonatomic, strong) UILabel *userNameLab;
/** 抢包*/
@property (nonatomic, strong) UILabel *moneyLab;
/** 牛数*/
@property (nonatomic, strong) UILabel *nnLab;
/** 投注*/
@property (nonatomic, strong) UILabel *bettingLab;
/** 盈亏*/
@property (nonatomic, strong) UILabel *lossLab;
@property (nonatomic, strong) NSMutableArray *labs;
/** 庄家*/
@property (nonatomic, strong) UIImageView *zjImage;
@end
@implementation ChatNiuNiuReportContentCell

- (void)setModel:(NiuNiuReportModel *)model{
    _model = model;

    self.zjImage.hidden = !(_model.betting == 0);

    self.moneyLab.text = [NSString stringWithFormat:@"%.2lf",_model.money];
    
    self.nnLab.text = _model.niuStr;
    NSString *userID=[NSString stringWithFormat:@"%ld",model.userId];
    NSString *nickName=[[AppModel shareInstance] getFriendName:userID];
    if (nickName.length > 0) {
        self.userNameLab.text = nickName;
    }else{
        FYContacts *sesstion = [[IMSessionModule sharedInstance] getSessionWithUserId:userID];
        if (sesstion.friendNick.length > 0 && ![sesstion.friendNick containsString:@"null"]) {
            self.userNameLab.text = sesstion.friendNick;
        }else if (_model.betting == 0){
            self.userNameLab.attributedText = [self imageAndText:_model.userName];
        }else{
            self.userNameLab.text = _model.userName;
        }
    }
    
    self.bettingLab.text = _model.betting == 0 ? @"--": [NSString stringWithFormat:@"%ld",(long)_model.betting];
    self.lossLab.text = [NSString stringWithFormat:@"%ld",(long)_model.profitLoss];

}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = UIColor.clearColor;
        [self addSubview:self.userNameLab];
        [self addSubview:self.moneyLab];
        [self addSubview:self.bettingLab];
        [self addSubview:self.nnLab];
        [self addSubview:self.lossLab];
        CGFloat w = (SCREEN_WIDTH - 50 - 40) / 5;

        [self.userNameLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.left.mas_equalTo(15);
            make.width.mas_equalTo(w);
        }];
        [self.moneyLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.left.mas_equalTo(self.userNameLab.mas_right);
            make.width.mas_equalTo(w);
        }];
        [self.nnLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.left.mas_equalTo(self.moneyLab.mas_right);
            make.width.mas_equalTo(w);
        }];
        [self.bettingLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.left.mas_equalTo(self.nnLab.mas_right);
            make.width.mas_equalTo(w);
        }];
        [self.lossLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.left.mas_equalTo(self.bettingLab.mas_right);
            make.width.mas_equalTo(w);
        }];
    }
    return self;
}
- (UILabel *)userNameLab{
    if (!_userNameLab) {
        _userNameLab = [[UILabel alloc]init];
        _userNameLab.font = [UIFont boldSystemFontOfSize:11];
        _userNameLab.textColor = [UIColor whiteColor];
    }
    return _userNameLab;
}
- (UILabel *)moneyLab{
    if (!_moneyLab) {
        _moneyLab = [[UILabel alloc]init];
        _moneyLab.font = [UIFont boldSystemFontOfSize:11];
        _moneyLab.textColor = [UIColor whiteColor];
        _moneyLab.textAlignment = NSTextAlignmentCenter;
    }
    return _moneyLab;
}
- (UILabel *)nnLab{
    if (!_nnLab) {
        _nnLab = [[UILabel alloc]init];
        _nnLab.font = [UIFont boldSystemFontOfSize:11];
        _nnLab.textColor = [UIColor whiteColor];
        _nnLab.textAlignment = NSTextAlignmentCenter;
    }
    return _nnLab;
}
- (UILabel *)lossLab{
    if (!_lossLab) {
        _lossLab = [[UILabel alloc]init];
        _lossLab.font = [UIFont boldSystemFontOfSize:11];
        _lossLab.textColor = [UIColor whiteColor];
        _lossLab.textAlignment = NSTextAlignmentCenter;
    }
    return _lossLab;
}
- (UILabel *)bettingLab{
    if (!_bettingLab) {
        _bettingLab = [[UILabel alloc]init];
        _bettingLab.font = [UIFont boldSystemFontOfSize:11];
        _bettingLab.textColor = [UIColor whiteColor];
        _bettingLab.textAlignment = NSTextAlignmentCenter;
    }
    return _bettingLab;
}
- (UIImageView *)zjImage{
    if (!_zjImage) {
        _zjImage = [[UIImageView alloc]init];
        _zjImage.image = [UIImage imageNamed:@"nnzjicon"];
    }
    return _zjImage;
}
//图文混排
- (NSMutableAttributedString *)imageAndText:(NSString*)text{
    NSMutableAttributedString *att = [[NSMutableAttributedString alloc]initWithString:text];
    // 插入图片附件
    NSTextAttachment *imageAtta = [[NSTextAttachment alloc] init];
    imageAtta.bounds = CGRectMake(0, -3, 15, 13);
    imageAtta.image = [UIImage imageNamed:@"nnzjicon"];
    NSAttributedString *attach = [NSAttributedString attributedStringWithAttachment:imageAtta];
    [att insertAttributedString:attach atIndex:0];
    return att;
}
@end
