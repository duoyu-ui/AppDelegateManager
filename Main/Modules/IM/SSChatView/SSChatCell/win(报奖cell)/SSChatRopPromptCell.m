//
//  SSChatRopPromptCell.m
//  ProjectCSHB
//
//  Created by Tom on 2020/6/24.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "SSChatRopPromptCell.h"
@interface SSChatRopPromptCell()
@property (nonatomic , strong) UIImageView *headerImgView;
@property (nonatomic , strong) UILabel *officialLab;
@property (nonatomic , strong) NSMutableArray <UILabel *>*labs;
@property (nonatomic , strong) UIView *lineView;
@property (nonatomic , strong) UIView *lineView1;
@end
@implementation SSChatRopPromptCell

- (void)setModel:(FYMessagelLayoutModel *)model{
    [super setModel:model];
    self.mMessageTimeLab.hidden = YES;
    NSDictionary *dict = [model.message.text mj_JSONObject];
    SSChatRopPromptModel *textMsg = [SSChatRopPromptModel mj_objectWithKeyValues:dict];
    UIImage *image = [UIImage imageNamed:model.message.backImgString];
    UIEdgeInsets insets = UIEdgeInsetsMake(35, 20, 37, 22);
    image = [image resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];
    self.bubbleBackView.image = image;
    self.nicknameLabel.text = NSLocalizedString(@"QG官方小秘书", nil);
    [self setType1WithText:textMsg];
}
///type 1 类型
- (void)setType1WithText:(SSChatRopPromptModel *)text{
    if (text.msg.count < 6) { return;}
    [self.bubbleBackView mas_updateConstraints:^(MASConstraintMaker *make) {
          make.width.mas_equalTo(SCREEN_WIDTH * 0.65);
      }];
    [self.labs enumerateObjectsUsingBlock:^(UILabel * _Nonnull lab, NSUInteger idx, BOOL * _Nonnull stop) {
        if(idx != 1){
            lab.textColor = UIColor.blackColor;
        }
        if (idx == 0) {
            lab.text = text.msg[idx];
        }else if (idx == 1){
            lab.text = [NSString stringWithFormat:@"%@",text.msg[idx]];
            lab.textColor = HexColor(@"#4BBC5A");
            [lab mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(45);
            }];
            [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(20);
                make.height.mas_equalTo(kLineHeight);
                make.right.mas_equalTo(-15);
                make.bottom.equalTo(lab.mas_top).offset(-kLineSpacing);
            }];
        }else if (idx == 2){
            lab.text = text.msg[idx];
            [lab mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(65);
            }];
        }else if (idx == 3){
            lab.text = [NSString stringWithFormat:NSLocalizedString(@"最低金额:         %@", nil),text.msg[idx]];
            [lab mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(85);
            }];
        }else if (idx == 4){
            lab.text = [NSString stringWithFormat:NSLocalizedString(@"买断金额:         %@", nil),text.msg[idx]];
            [lab mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(105);
            }];
        }else if (idx == 5){
            lab.text = [NSString stringWithFormat:NSLocalizedString(@"竟庄限时:         %@秒", nil),text.msg[idx]];
            [lab mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(125);
            }];
        }else if (idx == 6){
            lab.text = text.msg[idx];
            [lab mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(160);
            }];
            [self.lineView1 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(20);
                make.height.mas_equalTo(kLineHeight);
                make.right.mas_equalTo(-15);
                make.bottom.equalTo(lab.mas_top).offset(-kLineSpacing);
            }];
        }
    }];
  
    
}

- (void)initChatCellUI{
    [super initChatCellUI];
    self.mMessageTimeLab.hidden = YES;
    [self.contentView addSubview:self.headerImgView];
    [self.bubbleBackView addSubview:self.officialLab];
    [self.bubbleBackView addSubview:self.lineView];
    [self.bubbleBackView addSubview:self.lineView1];
    [self.headerImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(40);
        make.left.mas_equalTo(10);
        make.top.mas_equalTo(10);
    }];
    [self.nicknameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headerImgView.mas_right).offset(10);
        make.top.equalTo(self.headerImgView);
        make.height.mas_equalTo(12);
    }];
    NSString *text = NSLocalizedString(@"官方", nil);
    CGSize textSize = [text textSizeWithFont:[UIFont systemFontOfSize:10] limitWidth:kScreenWidth * 0.5];
    [self.officialLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(14);
        make.left.equalTo(self.nicknameLabel.mas_right).offset(5);
        make.centerY.equalTo(self.nicknameLabel);
        make.width.mas_equalTo(textSize.width + 10);
    }];
    [self.bubbleBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nicknameLabel.mas_bottom).offset(4);
        make.left.equalTo(self.headerImgView.mas_right).offset(10);
        make.width.mas_equalTo(SCREEN_WIDTH * 0.65);
        make.bottom.mas_equalTo(-10);
    }];
    for (int i = 0; i < 7; i++) {
        UILabel *lab = [self setLabCent];
        [self.bubbleBackView addSubview:lab];
        [lab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(kLineSpacing + i * 20);
            make.left.mas_equalTo(20);
            make.right.equalTo(self.lineView.mas_right);
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
- (NSMutableArray<UILabel *> *)labs{
    if (!_labs) {
        _labs = [NSMutableArray arrayWithCapacity:0];
    }
    return _labs;
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
- (UIImageView *)headerImgView{
    if (!_headerImgView) {
        _headerImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"qgSystemIcon"]];
        _headerImgView.backgroundColor =  [UIColor brownColor];
        _headerImgView.layer.cornerRadius = 5;
        _headerImgView.clipsToBounds = YES;
    }
    return _headerImgView;
}
@end
@implementation SSChatRopPromptModel

@end
