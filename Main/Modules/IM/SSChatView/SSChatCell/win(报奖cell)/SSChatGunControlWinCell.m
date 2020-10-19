//
//  FYGunControlWinCell.m
//  ProjectCSHB
//
//  Created by Tom on 2020/6/26.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "SSChatGunControlWinCell.h"
@interface SSChatGunControlWinCell()
@property (nonatomic , strong) UIImageView *headerImgView;
///官方
@property (nonatomic , strong) UILabel *officialLab;
@property (nonatomic , strong) UIView *lineView;
@property (nonatomic , strong) UIView *lineView1;
@property (nonatomic , strong) UILabel *titleLab;
@property (nonatomic , strong) UILabel *dateLab;
@property (nonatomic , strong) NSMutableArray <UILabel *>*labs;
@property (nonatomic , strong) NSMutableArray <UILabel *>*numLabs;
@end
@implementation SSChatGunControlWinCell
- (void)setModel:(FYMessagelLayoutModel *)model{
    [super setModel:model];
    self.mMessageTimeLab.hidden = YES;
    UIImage *image = [UIImage imageNamed:model.message.backImgString];
    UIEdgeInsets insets = UIEdgeInsetsMake(35, 20, 37, 22);
    image = [image resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];
    self.bubbleBackView.image = image;
    self.nicknameLabel.text = NSLocalizedString(@"QG官方小秘书", nil);

    FYGunControlWinModel *winModel = [FYGunControlWinModel mj_objectWithKeyValues:[model.message.text mj_JSONObject]];
    self.titleLab.text = [NSString stringWithFormat:@"%@❤%@",winModel.title.firstObject,winModel.title.lastObject];
    self.dateLab.text = winModel.date;
    [self.numLabs enumerateObjectsUsingBlock:^(UILabel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        switch (idx) {
            case 1:
                obj.text = [NSString stringWithFormat:@"%.2lf",winModel.money];
                break;
            case 2:
            {
                NSString *text = [NSString stringWithFormat:NSLocalizedString(@"%zd包", nil),winModel.count];
                CGSize s = [text textSizeWithFont:[UIFont systemFontOfSize:kCellFont] limitWidth:150];
                obj.text = text;
                [obj mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.width.equalTo(@(s.width));
                }];
            }
                break;
            case 3:
                obj.text = winModel.bomb;
                break;
            case 4:
                obj.text = winModel.type;
                break;
            case 5:
                obj.text = [NSString stringWithFormat:NSLocalizedString(@"%.2lf倍", nil), winModel.handicap];
                break;
            case 6:
                obj.textColor = HexColor(@"#CB332D");
                obj.text = [NSString stringWithFormat:@"%.2lf",winModel.prize];
                break;
            default:
                break;
        }
    }];
    [self.labs enumerateObjectsUsingBlock:^(UILabel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        switch (idx) {
            case 0:
                obj.text = [NSString stringWithFormat:@"@%@",winModel.nick];
            default:
                break;
        }
    }];
}
- (void)initChatCellUI{
    [super initChatCellUI];
    self.mMessageTimeLab.hidden = YES;
    [self.contentView addSubview:self.headerImgView];
    [self.bubbleBackView addSubview:self.officialLab];
    [self.bubbleBackView addSubview:self.dateLab];
    [self.bubbleBackView addSubview:self.titleLab];
    [self.bubbleBackView addSubview:self.lineView];
    [self.bubbleBackView addSubview:self.lineView1];
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
    [self.dateLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-kLineSpacing);
        make.left.mas_equalTo(15);
    }];
    [self.lineView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.equalTo(self.lineView);
        make.height.mas_equalTo(kLineHeight);
        make.bottom.equalTo(self.dateLab.mas_top).offset(-kLineSpacing);
    }];
    NSArray <NSString*>*titleArr = @[@" ",NSLocalizedString(@"发包金额", nil),NSLocalizedString(@"发包数量", nil),NSLocalizedString(@"埋雷号码", nil),NSLocalizedString(@"游戏玩法", nil),NSLocalizedString(@"红包赔率", nil),NSLocalizedString(@"奖励金额", nil)];
    [titleArr enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UILabel *lab = [self setLabCent];
        lab.text = obj;
        if (idx == 0) {
            lab.textColor = HexColor(@"#4BBC5A");
        }
        UILabel *numLab = [self setNumLabCent];
        [self.bubbleBackView addSubview:numLab];
        [self.bubbleBackView addSubview:lab];
        [numLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-10);
            make.top.equalTo(self.lineView.mas_bottom).offset(kLineSpacing + idx * 20);
            make.width.mas_greaterThanOrEqualTo(30);
        }];
        [self.numLabs addObj:numLab];
        [lab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.top.equalTo(self.lineView.mas_bottom).offset(kLineSpacing + idx * 20);
            make.right.equalTo(numLab.mas_left).offset(-5);
        }];
        [self.labs addObj:lab];
    }];
}
- (UILabel *)setNumLabCent{
    UILabel *lab = [[UILabel alloc]init];
    lab.font = [UIFont systemFontOfSize:kCellFont];
    lab.textAlignment = NSTextAlignmentRight;
    lab.textColor = UIColor.blackColor;
    return lab;
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
- (UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc]init];
        _lineView.backgroundColor = HexColor(@"#1A1A1A");
    }
    return _lineView;
}
- (UIView *)lineView1{
    if (!_lineView1) {
        _lineView1 = [[UIView alloc]init];
        _lineView1.backgroundColor = HexColor(@"#1A1A1A");
    }
    return _lineView1;
}
- (UILabel *)titleLab{
    if (!_titleLab) {
        _titleLab = [[UILabel alloc]init];
        _titleLab.textColor = HexColor(@"#1A1A1A");
        _titleLab.font = [UIFont systemFontOfSize:kCellFont];
    }
    return _titleLab;
}
- (UILabel *)dateLab{
    if (!_dateLab) {
        _dateLab = [[UILabel alloc]init];
        _dateLab.textColor = HexColor(@"#1A1A1A");
        _dateLab.font = [UIFont systemFontOfSize:kCellFont];
    }
    return _dateLab;
}
- (NSMutableArray<UILabel *> *)labs{
    if (!_labs) {
        _labs = [NSMutableArray arrayWithCapacity:0];
    }
    return _labs;
}
- (NSMutableArray<UILabel *> *)numLabs{
    if (!_numLabs) {
        _numLabs = [NSMutableArray arrayWithCapacity:0];
    }
    return _numLabs;
}
@end
@implementation FYGunControlWinModel
@end
