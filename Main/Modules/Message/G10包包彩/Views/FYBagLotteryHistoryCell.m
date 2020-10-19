//
//  FYBagLotteryHistoryCell.m
//  ProjectCSHB
//
//  Created by Tom on 2020/7/22.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "FYBagLotteryHistoryCell.h"
@interface FYBagLotteryHistoryCell()
//期数
@property (nonatomic , strong) UILabel *nperLab;

@property (nonatomic , strong) NSMutableArray <UILabel*>*labArr;
@property (nonatomic , strong) NSMutableArray <UILabel*>*labCowArr;
@end
@implementation FYBagLotteryHistoryCell
- (void)setList:(FYBegLotteryHistoryData *)list{
    _list = list;
    self.nperLab.text = [NSString stringWithFormat:NSLocalizedString(@"%@期", nil),list.gameNumber];
    [self.labCowArr enumerateObjectsUsingBlock:^(UILabel *lab, NSUInteger idx, BOOL * _Nonnull stop) {
        lab.hidden = YES;
    }];
    NSArray <NSString*>*winNumbers = [list.winNumbers componentsSeparatedByString:@","];
    [self.labArr enumerateObjectsUsingBlock:^(UILabel *lab, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx == 6) {
            self.labArr[6].text = list.typeName;
        }else{
            if (winNumbers.count > idx) {
                lab.hidden = NO;
                lab.backgroundColor = [FYBegLotteryTool setLabBackgroundColor:winNumbers[idx]];
                lab.text = winNumbers[idx];
            }else{
                lab.hidden = YES;
            }
        }
    }];
}
- (void)setCowList:(FYBagBagCowRecordData *)cowList{
    _cowList = cowList;
    self.nperLab.text = [NSString stringWithFormat:NSLocalizedString(@"%zd期", nil),cowList.gameNumber];
    [self.labArr enumerateObjectsUsingBlock:^(UILabel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.hidden = YES;
    }];
    [self.labCowArr enumerateObjectsUsingBlock:^(UILabel *lab, NSUInteger idx, BOOL * _Nonnull stop) {
        switch (idx) {
            case 0:
                lab.text = [NSString stringWithFormat:NSLocalizedString(@"庄|%@", nil),[FYBagBagCowTool setCowNumber:cowList.bankerNumber]];
                break;
            case 1:
                lab.text = [NSString stringWithFormat:NSLocalizedString(@"闲|%@", nil),[FYBagBagCowTool setCowNumber:cowList.playerNumber]];
                break;
            case 2:
                lab.attributedText = [FYBagBagCowTool setWinner:cowList.winner];
                break;
            default:
                break;
        }
    }];
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = UIColor.whiteColor;
        
        [self addSubview:self.nperLab];
        [self addSubview:self.hubBtn];
        [self.nperLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(12);
            make.centerY.equalTo(self);
        }];
        [self.hubBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(self.mas_height);
            make.centerY.equalTo(self);
            make.right.equalTo(self.mas_right);
        }];
        for (int i = 0; i < 7; i++) {
            UILabel *lab = [[UILabel alloc]init];
            if (i < 6) {
                lab.layer.masksToBounds = YES;
                lab.layer.cornerRadius = 5;
                lab.layer.borderColor = HexColor(@"#202020").CGColor;
                lab.layer.borderWidth = 1.5;
                lab.textColor = UIColor.whiteColor;
            }else{
                lab.textColor = HexColor(@"#333333");
            }
            lab.font = [UIFont boldSystemFontOfSize:16];
            lab.textAlignment = NSTextAlignmentCenter;
            [self addSubview:lab];
            [lab mas_makeConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(25);
                if (i < 6) {
                    make.width.mas_equalTo(25);
                    make.left.equalTo(self.nperLab.mas_right).offset(10 + i * 29);
                }else{
                    make.left.equalTo(self.nperLab.mas_right).offset(10 + i * 31);
                }
                make.centerY.equalTo(self);
            }];
            [self.labArr addObj:lab];
        }
        UIView *lineView = [[UIView alloc]init];
        lineView.backgroundColor = HexColor(@"#D9D9D9");
        [self addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.right.equalTo(self);
            make.height.mas_equalTo(kLineHeight);
        }];
        for (int i = 0; i < 3; i++) {
            UILabel *lab = [[UILabel alloc]init];
            lab.font = [UIFont systemFontOfSize:16];
            lab.textAlignment = NSTextAlignmentCenter;
            lab.textColor = HexColor(@"#333333");
            [self addSubview:lab];
            [self.labCowArr addObj:lab];
            [lab mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self);
                make.left.equalTo(self.nperLab.mas_right).offset(20 + i * 75);
                make.width.mas_equalTo(70);
            }];
        }
    }
    return self;
}

- (UILabel *)nperLab{
    if (!_nperLab) {
        _nperLab = [[UILabel alloc]init];
        _nperLab.textColor = HexColor(@"#333333");
        _nperLab.font = [UIFont systemFontOfSize:15];
    }
    return _nperLab;
}
- (NSMutableArray<UILabel *> *)labArr{
    if (!_labArr) {
        _labArr = [NSMutableArray array];
    }
    return _labArr;
}
- (NSMutableArray<UILabel *> *)labCowArr{
    if (!_labCowArr) {
        _labCowArr = [NSMutableArray array];
    }
    return _labCowArr;
}
- (UIButton *)hubBtn{
    if (!_hubBtn) {
        _hubBtn = [[UIButton alloc]init];
        [_hubBtn setImage:[UIImage imageNamed:@"download_under_icon"] forState:UIControlStateNormal];
        _hubBtn.layer.anchorPoint = CGPointMake(0.5, 0.5);
        _hubBtn.transform = CGAffineTransformRotate(_hubBtn.transform, M_PI);
    }
    return _hubBtn;
}
@end
