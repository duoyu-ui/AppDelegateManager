//
//  SSChatRotaryHeaderCell.m
//  ProjectCSHB
//
//  Created by Tom on 2020/6/27.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "SSChatRotaryHeaderCell.h"
@interface SSChatRotaryHeaderCell()
@property (nonatomic , strong) UIView *lineView;
@property (nonatomic , strong) UIImageView *headerImgView;
///官方
@property (nonatomic , strong) UILabel *officialLab;
@property (nonatomic , strong) UILabel *titleLab;
@property (nonatomic , strong) NSMutableArray<UILabel *> *labs;
@end
@implementation SSChatRotaryHeaderCell

- (void)setModel:(FYMessagelLayoutModel *)model{
    [super setModel:model];
    self.mMessageTimeLab.hidden = YES;
     UIImage *image = [UIImage imageNamed:model.message.backImgString];
     UIEdgeInsets insets = UIEdgeInsetsMake(35, 20, 37, 22);
     image = [image resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];
     self.bubbleBackView.image = image;
     self.nicknameLabel.text = NSLocalizedString(@"QG官方小秘书", nil);
    SSChatRotaryHeaderModel *winModel = [SSChatRotaryHeaderModel mj_objectWithKeyValues:[model.message.text mj_JSONObject]];
    self.titleLab.text = winModel.msg.firstObject;
    [self.labs enumerateObjectsUsingBlock:^(UILabel * _Nonnull lab, NSUInteger idx, BOOL * _Nonnull stop) {
        lab.text = winModel.msg[idx + 1];
    }];
    
}
- (void)initChatCellUI{
    [super initChatCellUI];
    [self setSubViews];
}
- (void)setSubViews{
    self.mMessageTimeLab.hidden = YES;
    [self.contentView addSubview:self.headerImgView];
    [self.bubbleBackView addSubview:self.officialLab];
    [self.bubbleBackView addSubview:self.titleLab];
    [self.bubbleBackView addSubview:self.lineView];
    [self.headerImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(40);
        make.top.left.mas_equalTo(10);
    }];
    NSString *text = NSLocalizedString(@"官方", nil);
    CGSize textSize = [text textSizeWithFont:[UIFont systemFontOfSize:10] limitWidth:kScreenWidth * 0.5];
    [self.officialLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(14);
        make.left.equalTo(self.nicknameLabel.mas_right).offset(5);
        make.centerY.equalTo(self.nicknameLabel);
        make.width.mas_equalTo(textSize.width + 10);
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
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(kLineSpacing);
        make.left.mas_equalTo(15);
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
          make.left.equalTo(self.titleLab);
          make.height.mas_equalTo(kLineHeight);
          make.right.mas_equalTo(-10);
          make.top.equalTo(self.titleLab.mas_bottom).offset(kLineSpacing);
      }];
    for (int i = 0; i < 2; i ++) {
        UILabel *lab = [self setLabCent];
        [self.bubbleBackView addSubview:lab];
        [lab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.titleLab);
            make.top.equalTo(self.lineView.mas_bottom).offset(kLineSpacing + i * 20);
        }];
        [self.labs addObj:lab];
    }
}
- (UILabel *)setLabCent{
    UILabel *lab = [[UILabel alloc]init];
    lab.font = [UIFont systemFontOfSize:kCellFont];
    lab.textColor = HexColor(@"#1A1A1A");
    return lab;
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
- (UILabel *)titleLab{
    if (!_titleLab) {
        _titleLab = [[UILabel alloc]init];
        _titleLab.textColor = HexColor(@"#1A1A1A");
        _titleLab.font = [UIFont systemFontOfSize:kCellFont];
    }
    return _titleLab;
}
- (UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc]init];
        _lineView.backgroundColor = HexColor(@"#1A1A1A");
    }
    return _lineView;
}
- (NSMutableArray<UILabel *> *)labs{
    if (!_labs) {
        _labs = [NSMutableArray arrayWithCapacity:0];
    }
    return _labs;
}
@end
@implementation SSChatRotaryHeaderModel
@end
