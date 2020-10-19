//
//  FYBagLotteryResultsCell.m
//  ProjectCSHB
//
//  Created by Tom on 2020/7/22.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "FYBagLotteryResultsCell.h"
@interface FYBagLotteryResultsCell()
@property (nonatomic , strong) UILabel *nickLab;
@property (nonatomic , strong) UILabel *moneyStrLab;
@end
@implementation FYBagLotteryResultsCell
- (void)setList:(SSChatBagLotteryResultsOpen *)list{
    _list = list;
    self.nickLab.text = list.nick;
    self.moneyStrLab.text = list.moneyStr;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = UIColor.whiteColor;
        [self addSubview:self.nickLab];
        [self addSubview:self.moneyStrLab];
        [self.nickLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.centerY.equalTo(self);
            make.right.equalTo(self.mas_centerX);
        }];
        [self.moneyStrLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.centerY.equalTo(self);
            make.left.equalTo(self.mas_centerX);
        }];
    }
    return self;
}
- (UILabel *)nickLab{
    if (!_nickLab) {
        _nickLab = [[UILabel alloc]init];
        _nickLab.textColor = HexColor(@"#1A1A1A");
        _nickLab.font = [UIFont systemFontOfSize:kCellFont];
    }
    return _nickLab;
}
- (UILabel *)moneyStrLab{
    if (!_moneyStrLab) {
        _moneyStrLab = [[UILabel alloc]init];
        _moneyStrLab.textColor = HexColor(@"#1A1A1A");
        _moneyStrLab.font = [UIFont systemFontOfSize:kCellFont];
        _moneyStrLab.textAlignment = NSTextAlignmentRight;
    }
    return _moneyStrLab;
}
@end
