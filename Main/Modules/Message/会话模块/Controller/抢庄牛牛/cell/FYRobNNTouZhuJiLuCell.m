//
//  FYRobNNTouZhuJiLuCell.m
//  ProjectCSHB
//
//  Created by 汤姆 on 2019/10/4.
//  Copyright © 2019 CDJay. All rights reserved.
//

#import "FYRobNNTouZhuJiLuCell.h"
@interface FYRobNNTouZhuJiLuCell()

@property (nonatomic, strong) NSMutableArray<UILabel*> *labs;

@end
@implementation FYRobNNTouZhuJiLuCell

- (void)setList:(FYRobNNTouZhuJiLuList *)list{
    _list = list;
    
    NSString *period = [NSString stringWithFormat:@"%@", list.period ? list.period : @""];
    NSString *betting = [NSString stringWithFormat:@"%ld", _list.betting];
    NSString *profitLoss = [NSString stringWithFormat:@"%ld", _list.profitLoss];
    NSMutableArray <NSString*>*titles = [NSMutableArray arrayWithObjects:period, betting, profitLoss, _list.createTime, nil];
    
    if (titles.count == 0) {
        return;
    }
    
    [self.labs enumerateObjectsUsingBlock:^(UILabel *lab, NSUInteger idx, BOOL * _Nonnull stop) {
        lab.text = titles[idx];
        if (idx == 2) {
            if (list.profitLoss > 0) {
                lab.textColor = HexColor(@"#2B7822");;
            }else{
                lab.textColor = HexColor(@"#FE4C56");
            }
        }
    }];
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        CGFloat w = SCREEN_WIDTH / 5;
        for (int i = 0; i < 4; i ++) {
            UILabel *lab = [[UILabel alloc]init];
            lab.textAlignment = NSTextAlignmentCenter;
            lab.font = [UIFont systemFontOfSize:12];
            lab.textColor = UIColor.grayColor;
            [self addSubview:lab];
            [lab mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(w * i);
                make.width.mas_equalTo(i == 3 ? (w * 2):w);
                make.centerY.equalTo(self);
            }];
            [self.labs addObject:lab];
        }
        UIView *lineView = [[UIView alloc]init];
        lineView.backgroundColor = makeColorRgb(226, 226, 226);
        [self addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.right.equalTo(self);
            make.height.mas_equalTo(kLineHeight);
        }];
    }
    return self;
}
- (NSMutableArray<UILabel *> *)labs{
    if (!_labs) {
        _labs = [NSMutableArray arrayWithCapacity:0];
    }
    return _labs;
}
@end
