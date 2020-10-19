//
//  SSChatBastNiuNiuWinCell.m
//  ProjectCSHB
//
//  Created by Tom on 2020/8/25.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "SSChatBastNiuNiuWinCell.h"
#import "FYPokerCardView.h"
@interface SSChatBastNiuNiuWinCell()
@property (nonatomic , strong) UIImageView *headerImgView;
///官方
@property (nonatomic , strong) UILabel *officialLab;
@property (nonatomic , strong) UILabel *titleLab;
@property (nonatomic , strong) UIView *lineView;
@property (nonatomic , strong) UIView *lineView1;
@property (nonatomic , strong) UILabel *winLab;
@property (nonatomic , strong) NSMutableArray <UILabel*>*labs;
@property (nonatomic , strong) NSMutableArray<FYPokerCardView*> *cardViewArr;
@end
@implementation SSChatBastNiuNiuWinCell
- (void)setModel:(FYMessagelLayoutModel *)model{
    [super setModel:model];
    self.mMessageTimeLab.hidden = YES;
    SSChatBastNiuNiuWinModel *winModel = [SSChatBastNiuNiuWinModel mj_objectWithKeyValues:[model.message.text mj_JSONObject]];
    self.titleLab.text = [NSString stringWithFormat:@"%@❤%@",winModel.msg.firstObject,winModel.msg[1]];
    UIImage *image = [UIImage imageNamed:model.message.backImgString];
    UIEdgeInsets insets = UIEdgeInsetsMake(35, 20, 37, 22);
    image = [image resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];
    self.bubbleBackView.image = image;
    self.nicknameLabel.text = NSLocalizedString(@"QG官方小秘书", nil);
    NSString *winText = [winModel.msg.lastObject integerValue] == 1 ? NSLocalizedString(@"蓝方", nil) :NSLocalizedString(@"红方", nil);
    UIColor *winColor = [winModel.msg.lastObject integerValue] == 1 ? HexColor(@"#3875F6"):HexColor(@"#E75E58");
    NSString *absText = [NSString stringWithFormat:@"%@%@",winText,NSLocalizedString(@"胜", nil)];
    NSMutableAttributedString *abs = [[NSMutableAttributedString alloc]initWithString:absText];
    [abs addAttribute:NSForegroundColorAttributeName value:winColor range:NSMakeRange(0, winText.length)];
    self.winLab.attributedText = abs;
    NSArray <NSString*>*cardArr = [winModel.msg[(winModel.msg.count - 2)] componentsSeparatedByString:@","];
    NSMutableArray <FYBestWinsLossesPokers*>*pokers = [NSMutableArray array];
    [cardArr enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSArray <NSString*>*cards = [obj componentsSeparatedByString:@"|"];
        FYBestWinsLossesPokers *poker = [[FYBestWinsLossesPokers alloc]init];
        poker.text = cards.firstObject;
        poker.type = cards.lastObject;
        [pokers addObj:poker];
    }];
    [self.cardViewArr enumerateObjectsUsingBlock:^(FYPokerCardView *cardView, NSUInteger idx, BOOL * _Nonnull stop) {
        cardView.pokers = pokers[idx];
    }];
    [self.labs enumerateObjectsUsingBlock:^(UILabel * _Nonnull lab, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx == 0) {
            lab.textColor = HexColor(@"#00C52E");
        }else{
            lab.textColor = HexColor(@"#1A1A1A");
        }
        lab.text = winModel.msg[idx + 2];
    }];
}
- (void)initChatCellUI{
    [super initChatCellUI];
    self.mMessageTimeLab.hidden = YES;
    [self.contentView addSubview:self.headerImgView];
    [self.bubbleBackView addSubview:self.officialLab];
    [self.bubbleBackView addSubview:self.titleLab];
    [self.bubbleBackView addSubview:self.lineView];
    [self.bubbleBackView addSubview:self.lineView1];
    [self.bubbleBackView addSubview:self.winLab];
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
    [self.winLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.lineView);
        make.width.mas_equalTo(SCREEN_WIDTH * 0.65 - 30 * 5 - 25);
        make.bottom.mas_equalTo(self.bubbleBackView.mas_bottom).offset(-kLineSpacing);
    }];
    [self.lineView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.lineView);
        make.height.mas_equalTo(kLineHeight);
        make.bottom.equalTo(self.winLab.mas_top).offset(-kLineSpacing);
    }];
    
    for (int i = 0; i < 4; i++) {
        UILabel *lab = [self setLabCent];
        [self.bubbleBackView addSubview:lab];
        [lab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.titleLab.mas_left);
            make.top.equalTo(self.lineView.mas_bottom).offset(kLineSpacing + i * 20);
            make.right.equalTo(self.lineView);
        }];
        [self.labs addObj:lab];
    }
    for (int i = 0; i < 5; i++) {
        FYPokerCardView *cardView = [[FYPokerCardView alloc]init];
        [self.bubbleBackView addSubview:cardView];
        [cardView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(27);
            make.left.equalTo(self.lineView.mas_left).offset(i * (27 + 3));
            make.height.mas_equalTo(20);
            make.centerY.equalTo(self.winLab.mas_centerY);
        }];
        [self.cardViewArr addObj:cardView];
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
- (UILabel *)winLab{
    if (!_winLab) {
        _winLab = [[UILabel alloc]init];
        _winLab.textColor = HexColor(@"#1A1A1A");
        _winLab.font = [UIFont systemFontOfSize:kCellFont];
        _winLab.textAlignment = NSTextAlignmentRight;
    }
    return _winLab;
}
- (NSMutableArray<UILabel *> *)labs{
    if (!_labs) {
        _labs = [NSMutableArray arrayWithCapacity:0];
    }
    return _labs;
}
- (NSMutableArray<FYPokerCardView *> *)cardViewArr{
    if (!_cardViewArr) {
        _cardViewArr = [NSMutableArray<FYPokerCardView*> array];
    }
    return _cardViewArr;
}
@end
@implementation SSChatBastNiuNiuWinModel
@end
