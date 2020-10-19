//
//  SSChatSystemWinCell.m
//  ProjectCSHB
//
//  Created by Tom on 2020/6/23.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "SSChatSystemWinCell.h"
@interface SSChatSystemWinCell()
@property (nonatomic , strong) UIImageView *headerImgView;
///官方
@property (nonatomic , strong) UILabel *officialLab;
@property (nonatomic , strong) UIView *lineView;
@property (nonatomic , strong) UILabel *titleLab;
@property (nonatomic , strong) UILabel *userLab;
@property (nonatomic , strong) UILabel *awardLab;
@property (nonatomic , strong) UILabel *moneydLab;
@end
@implementation SSChatSystemWinCell

- (void)setModel:(FYMessagelLayoutModel *)model{
    [super setModel:model];
    UIImage *image = [UIImage imageNamed:model.message.backImgString];
    UIEdgeInsets insets = UIEdgeInsetsMake(35, 20, 37, 22);
    image = [image resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];
    self.bubbleBackView.image = image;
    self.nicknameLabel.text = NSLocalizedString(@"QG官方小秘书", nil);
    NSData *jsonData = [model.message.text dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
    SSChatSystemWinModel *winModel = [SSChatSystemWinModel mj_objectWithKeyValues:dic];
    self.titleLab.text = [NSString stringWithFormat:@"%@❤%@",winModel.title.firstObject,winModel.title.lastObject];
    self.userLab.text = [NSString stringWithFormat:@"@%@",winModel.user];
    self.moneydLab.text = [NSString stringWithFormat:NSLocalizedString(@"抢包金额：%.2lf", nil),winModel.money];
    self.awardLab.text = [NSString stringWithFormat:NSLocalizedString(@"获得奖励：%.2lf", nil),winModel.award];
    self.mMessageTimeLab.hidden = !model.message.showTime;
    if (!model.message.showTime) {
        [self.headerImgView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(10);
        }];
    }
}
- (void)initChatCellUI{
    [super initChatCellUI];
    [self.contentView addSubview:self.headerImgView];
    [self.bubbleBackView addSubview:self.officialLab];
    [self.bubbleBackView addSubview:self.lineView];
    [self.bubbleBackView addSubview:self.titleLab];
    [self.bubbleBackView addSubview:self.userLab];
    [self.bubbleBackView addSubview:self.moneydLab];
    [self.bubbleBackView addSubview:self.awardLab];
    [self.headerImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(40);
        make.left.mas_equalTo(10);
        make.top.equalTo(self.mMessageTimeLab.mas_bottom).offset(10);
    }];
    [self.nicknameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headerImgView.mas_right).offset(10);
        make.top.equalTo(self.headerImgView);
        make.height.mas_equalTo(12);
    }];
    [self.bubbleBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nicknameLabel.mas_bottom).offset(4);
        make.left.equalTo(self.headerImgView.mas_right).offset(10);
        make.width.mas_equalTo(SCREEN_WIDTH * 0.65);
        make.bottom.mas_equalTo(-10);
    }];
    NSString *text = NSLocalizedString(@"官方", nil);
    CGSize textSize = [text textSizeWithFont:[UIFont systemFontOfSize:10] limitWidth:kScreenWidth * 0.5];
    [self.officialLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(14);
        make.left.equalTo(self.nicknameLabel.mas_right).offset(5);
        make.centerY.equalTo(self.nicknameLabel);
        make.width.mas_equalTo(textSize.width + 10);
    }];
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.lineView);
        make.top.equalTo(self.bubbleBackView.mas_top).offset(kLineSpacing);
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(kLineHeight);
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-15);
        make.top.equalTo(self.titleLab.mas_bottom).offset(kLineSpacing);
    }];
    [self.userLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLab);
        make.top.equalTo(self.lineView.mas_bottom).offset(kLineSpacing);
    }];
    [self.moneydLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLab);
        make.top.equalTo(self.userLab.mas_bottom).offset(kLineSpacing);
    }];
    [self.awardLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLab);
        make.top.equalTo(self.moneydLab.mas_bottom).offset(kLineSpacing);
    }];
}
- (UIImageView *)headerImgView{
    if (!_headerImgView) {
        _headerImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"qgSystemIcon"]];
        _headerImgView.backgroundColor =  [UIColor brownColor];
        _headerImgView.layer.cornerRadius = 5;
        _headerImgView.clipsToBounds = YES;
        
    }
    return _headerImgView;
}
- (UILabel *)officialLab{
    if (!_officialLab) {
        _officialLab = [[UILabel alloc]init];
        _officialLab.text = NSLocalizedString(@"官方", nil);
        _officialLab.textColor = HexColor(@"#FFFFFF");
        _officialLab.backgroundColor = HexColor(@"#E75E58");
        _officialLab.layer.masksToBounds = YES;
        _officialLab.textAlignment = NSTextAlignmentCenter;
        _officialLab.layer.cornerRadius = 7;
        _officialLab.font = [UIFont systemFontOfSize:10];
    }
    return _officialLab;
}
- (UIView *)lineView{
    if(!_lineView){
        _lineView = [[UIView alloc]init];
        _lineView.backgroundColor = HexColor(@"#1A1A1A");
    }
    return _lineView;
}
- (UILabel *)titleLab{
    if (!_titleLab) {
        _titleLab = [[UILabel alloc]init];
        _titleLab.textColor = HexColor(@"#1A1A1A");
        _titleLab.font = [UIFont systemFontOfSize:kCellFont];
    }
    return _titleLab;
}
- (UILabel *)userLab{
    if (!_userLab) {
           _userLab = [[UILabel alloc]init];
           _userLab.textColor = HexColor(@"#4BBC5A");
           _userLab.font = [UIFont systemFontOfSize:kCellFont];
       }
       return _userLab;
}
- (UILabel *)moneydLab{
    if (!_moneydLab) {
         _moneydLab = [[UILabel alloc]init];
         _moneydLab.textColor = HexColor(@"#1A1A1A");
         _moneydLab.font = [UIFont systemFontOfSize:kCellFont];
     }
     return _moneydLab;
}
- (UILabel *)awardLab{
    if (!_awardLab) {
          _awardLab = [[UILabel alloc]init];
          _awardLab.textColor = HexColor(@"#1A1A1A");
          _awardLab.font = [UIFont systemFontOfSize:kCellFont];
      }
      return _awardLab;
}
@end
@implementation SSChatSystemWinModel
@end
