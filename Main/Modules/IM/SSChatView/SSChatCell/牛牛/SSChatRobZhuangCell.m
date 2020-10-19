//
//  SSChatRobZhuangCell.m
//  Project
//
//  Created by 汤姆 on 2019/9/6.
//  Copyright © 2019 CDJay. All rights reserved.
//

#import "SSChatRobZhuangCell.h"
@interface SSChatRobZhuangCell()
@property (nonatomic, strong) UIImageView *robImageV;

@property (nonatomic, strong) UILabel *robLab;
@end
@implementation SSChatRobZhuangCell


-(void)initChatCellUI {
    [super initChatCellUI];
    [self initSubviews];
}

- (void)initSubviews{
    [self.contentView addSubview:self.robImageV];
    [self.robImageV addSubview:self.robLab];
    [self.robImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(60);
        make.top.equalTo(self.nicknameLabel.mas_bottom).offset(5);
        make.width.mas_equalTo(146);
        make.height.mas_equalTo(33);
    }];
    [self.robLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.robImageV);
        make.centerX.equalTo(self.robImageV.mas_centerX).offset(-10);
    }];
}
- (void)setModel:(FYMessagelLayoutModel *)model{
    [super setModel:model];
    
    if (model.message.messageFrom == FYMessageDirection_RECEIVE ) {//接收
        self.robImageV.image = [UIImage imageNamed:@"robImageLeft"];
        [self.robImageV mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(60);
            make.top.equalTo(self.nicknameLabel.mas_bottom).offset(5);
            make.width.mas_equalTo(146);
            make.height.mas_equalTo(33);
        }];
    }else {
        [self.robImageV mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.mHeaderImgView.mas_left).offset(-10);
            make.bottom.equalTo(self.mHeaderImgView.mas_bottom);
            make.width.mas_equalTo(146);
            make.height.mas_equalTo(33 );
        }];
        self.robImageV.image = [UIImage imageNamed:@"robImageRight"];
        [self.robLab mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.robImageV.mas_centerX).offset(10);
        }];
    }
    self.robLab.text = [NSString stringWithFormat:NSLocalizedString(@"%@抢庄", nil),model.message.cowcowRewardInfoDict[@"money"]];
}
- (UIImageView *)robImageV{
    if (!_robImageV) {
        _robImageV = [[UIImageView alloc]init];
    }
    return _robImageV;
}
- (UILabel *)robLab{
    if (!_robLab) {
        _robLab = [[UILabel alloc]init];
        _robLab.font = [UIFont fontWithName:@"BernardMT-Condensed" size:15.0f];
        _robLab.textColor = UIColor.whiteColor;
    }
    return _robLab;
}
@end
