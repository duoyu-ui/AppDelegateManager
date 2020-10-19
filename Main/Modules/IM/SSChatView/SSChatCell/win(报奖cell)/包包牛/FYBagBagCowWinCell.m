//
//  FYBagBagCowWinCellCell.m
//  ProjectCSHB
//
//  Created by Tom on 2020/7/25.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "FYBagBagCowWinCell.h"

@interface FYBagBagCowWinCell ()

@property (nonatomic , strong) UILabel *winLab;
@end
@implementation FYBagBagCowWinCell
- (void)setList:(SSChatBagBagCowWinData *)list{
    _list = list;
    self.winLab.text = list.money;
    
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = UIColor.whiteColor;
        [self addSubview:self.nickLab];
        [self addSubview:self.numLab];
        [self addSubview:self.winLab];
        [self.nickLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.centerY.equalTo(self);
        }];
        [self.numLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.left.equalTo(self.mas_centerX);
        }];
        [self.winLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.centerY.equalTo(self);
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
- (UILabel *)numLab{
    if (!_numLab) {
        _numLab = [[UILabel alloc]init];
        _numLab.textColor = HexColor(@"#1A1A1A");
        _numLab.font = [UIFont systemFontOfSize:kCellFont];
        _winLab.textAlignment = NSTextAlignmentCenter;
    }
    return _numLab;
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
@end
