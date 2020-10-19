//
//  FYPokerHistoryHubCell.m
//  ProjectCSHB
//
//  Created by Tom on 2020/8/26.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "FYPokerHistoryHubCell.h"
#import "FYPokerCardView.h"
@interface FYPokerHistoryHubCell ()
@property (nonatomic , strong) UILabel *gameNumberLab;
///牛数
@property (nonatomic , strong) UILabel *niuNumLab;
@property (nonatomic , strong) UILabel *otherLab;
@property (nonatomic , strong) NSMutableArray<FYPokerCardView*> *cardViewArr;

@property (nonatomic , strong) NSMutableArray<UILabel*> *sizeLabArr;
@end
@implementation FYPokerHistoryHubCell
- (void)setList:(FYBestNiuNiuHistoryData *)list{
    _list = list;
    NSArray<FYBestNiuNiuHistoryResult *>* result = [FYBestNiuNiuHistoryResult mj_objectArrayWithKeyValuesArray:list.result];
    switch (list.state) {
        case BestNiuNiuHistoryCardState://牌面
        {
            self.niuNumLab.text = list.cattleNum;
            self.niuNumLab.hidden = NO;
            NSString *winText = list.other == 1 ? NSLocalizedString(@"蓝方", nil) :NSLocalizedString(@"红方", nil);
               UIColor *winColor = list.other == 1 ? HexColor(@"#3875F6"):HexColor(@"#E75E58");
               NSString *absText = [NSString stringWithFormat:@"%@%@",winText,NSLocalizedString(@"胜", nil)];
               NSMutableAttributedString *abs = [[NSMutableAttributedString alloc]initWithString:absText];
               [abs addAttribute:NSForegroundColorAttributeName value:winColor range:NSMakeRange(0, winText.length)];
               self.otherLab.attributedText = abs;
            self.otherLab.hidden = NO;
            [self.cardViewArr enumerateObjectsUsingBlock:^(FYPokerCardView *cardView, NSUInteger idx, BOOL * _Nonnull stop) {
                FYBestWinsLossesPokers *poker = [[FYBestWinsLossesPokers alloc]init];
                poker.type = result[idx].type;
                poker.text = result[idx].text;
                cardView.hidden = NO;
                cardView.pokers = poker;
            }];
            [self.sizeLabArr enumerateObjectsUsingBlock:^(UILabel *lab, NSUInteger idx, BOOL * _Nonnull stop) {
                lab.hidden = YES;
            }];
        }
            break;
        case BestNiuNiuHistorysize://大小
        {
            self.niuNumLab.hidden = YES;
            self.otherLab.hidden = YES;
            [self.sizeLabArr enumerateObjectsUsingBlock:^(UILabel *lab, NSUInteger idx, BOOL * _Nonnull stop) {
                lab.hidden = NO;
                lab.text = result[idx].bigSmall;
                if ([result[idx].bigSmall isEqualToString:NSLocalizedString(@"大", nil)]) {
                    lab.backgroundColor = HexColor(@"#CB332D");
                }else{
                    lab.backgroundColor = HexColor(@"#3875F6");
                }
            }];
            [self.cardViewArr enumerateObjectsUsingBlock:^(FYPokerCardView *cardView, NSUInteger idx, BOOL * _Nonnull stop) {
                cardView.hidden = YES;
            }];
        }
            break;
        case BestNiuNiuHistorySingle://单双
        {
            self.niuNumLab.hidden = YES;
            self.otherLab.hidden = YES;
            [self.sizeLabArr enumerateObjectsUsingBlock:^(UILabel *lab, NSUInteger idx, BOOL * _Nonnull stop) {
                lab.hidden = NO;
                lab.text = result[idx].singleDouble;
                if ([result[idx].singleDouble isEqualToString:NSLocalizedString(@"双", nil)]) {
                    lab.backgroundColor = HexColor(@"#CB332D");
                }else{
                    lab.backgroundColor = HexColor(@"#3875F6");
                }
            }];
            [self.cardViewArr enumerateObjectsUsingBlock:^(FYPokerCardView *cardView, NSUInteger idx, BOOL * _Nonnull stop) {
                cardView.hidden = YES;
            }];
        }
            break;
        default:
            break;
    }
    self.gameNumberLab.text = list.gameNumber;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = UIColor.whiteColor;
        [self initSubView];
    }
    return self;
}
- (void)initSubView{
    [self addSubview:self.gameNumberLab];
    [self addSubview:self.niuNumLab];
    [self addSubview:self.otherLab];
    [self addSubview:self.gameNumberLab];
    [self.gameNumberLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.centerY.equalTo(self);
        make.width.mas_equalTo(kScreenWidth / 4);
    }];
    [self.niuNumLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.right.mas_equalTo(-20);
    }];
    [self.otherLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.right.equalTo(self.niuNumLab.mas_left).offset(-20);
    }];
    for (int i = 0; i < 5; i++) {
        FYPokerCardView *cardView = [[FYPokerCardView alloc]init];
        cardView.hidden = YES;
        [self addSubview:cardView];
        [self.cardViewArr addObj:cardView];
        [cardView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.width.mas_equalTo(27);
            make.height.mas_equalTo(18);
            make.left.mas_equalTo(i * 30 + (kScreenWidth / 4));
        }];
        //大小
        UILabel *sizeLab = [[UILabel alloc]init];
        sizeLab.hidden = YES;
        [sizeLab addRound:6];
        sizeLab.textAlignment = NSTextAlignmentCenter;
        sizeLab.font = [UIFont systemFontOfSize:11];
        sizeLab.textColor = UIColor.whiteColor;
        [self addSubview:sizeLab];
        [sizeLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.width.mas_equalTo(27);
            make.height.mas_equalTo(18);
            make.left.mas_equalTo(i * 30 + (kScreenWidth / 4));
        }];
        [self.sizeLabArr addObj:sizeLab];
    }
}
- (UILabel *)gameNumberLab{
    if (!_gameNumberLab) {
        _gameNumberLab = [[UILabel alloc]init];
        _gameNumberLab.textColor = UIColor.blackColor;
        _gameNumberLab.font = [UIFont systemFontOfSize:15];
        _gameNumberLab.textAlignment = NSTextAlignmentCenter;
    }
    return _gameNumberLab;
}
- (UILabel *)niuNumLab{
    if (!_niuNumLab) {
        _niuNumLab = [[UILabel alloc]init];
        _niuNumLab.textColor = UIColor.blackColor;
        _niuNumLab.font = [UIFont systemFontOfSize:15];
        _niuNumLab.textAlignment = NSTextAlignmentRight;
    }
    return _niuNumLab;
}
- (UILabel *)otherLab{
    if (!_otherLab) {
        _otherLab = [[UILabel alloc]init];
        _otherLab.textColor = UIColor.blackColor;
        _otherLab.font = [UIFont systemFontOfSize:15];
        _otherLab.textAlignment = NSTextAlignmentRight;
    }
    return _otherLab;
}
- (NSMutableArray<FYPokerCardView *> *)cardViewArr{
    if (!_cardViewArr) {
        _cardViewArr = [NSMutableArray<FYPokerCardView*> array];
    }
    return _cardViewArr;
}
- (NSMutableArray<UILabel *> *)sizeLabArr{
    if (!_sizeLabArr) {
        _sizeLabArr = [NSMutableArray<UILabel*> array];
    }
    return _sizeLabArr;
}
@end
