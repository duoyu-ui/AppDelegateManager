//
//  FYLhhTouZhuJiLuCell.m
//  ProjectCSHB
//
//  Created by Tom on 2019/10/26.
//  Copyright © 2019 Fangyuan. All rights reserved.
//

#import "FYLhhTouZhuJiLuCell.h"
@interface FYLhhTouZhuJiLuCell ()
@property (nonatomic, strong) NSMutableArray<UILabel*> *labs;
@end
@implementation FYLhhTouZhuJiLuCell
- (void)setSlist:(FYRobSolitaireTouZhuJiLuList *)slist{
    _slist = slist;
    NSString *min = _slist.moneyType == 0 ? NSLocalizedString(@"\n(最小包)", nil):@"";
    NSString *grabMoney = [NSString stringWithFormat:@"%@%@",_slist.grabMoney,min];
    NSString *gameNumber = [NSString stringWithFormat:@"%ld",_slist.gameNumber];
    NSMutableArray <NSString*>*titles = [NSMutableArray arrayWithObjects:gameNumber,grabMoney,_slist.minPayMoney,_slist.profitMoney,_slist.gameTime, nil];
    if (titles.count == 0) {
           return;
       }
    [self.labs enumerateObjectsUsingBlock:^(UILabel *lab, NSUInteger idx, BOOL * _Nonnull stop) {
           lab.text = titles[idx];
           if (idx == 3) {
               if ([_slist.profitMoney floatValue] > 0.0) {
                   lab.textColor = HexColor(@"#2B7822");;
               }else{
                   lab.textColor = HexColor(@"#FE4C56");
               }
           }
       }];
}
- (void)setList:(FYRobNNTouZhuJiLuList *)list{
    _list = list;
    NSString *period = [NSString stringWithFormat:@"%@", _list.period ? list.period : @""];
     NSString *betting = [NSString stringWithFormat:@"%ld", _list.betting];
     NSString *profitLoss = [NSString stringWithFormat:@"%ld", _list.profitLoss];
     NSMutableArray <NSString*>*titles = [NSMutableArray arrayWithObjects:period, betting,_list.niuStr, profitLoss, _list.createTime, nil];
     
     if (titles.count == 0) {
         return;
     }
     
     [self.labs enumerateObjectsUsingBlock:^(UILabel *lab, NSUInteger idx, BOOL * _Nonnull stop) {
         lab.text = titles[idx];
         if (idx == 3) {
             if (list.profitLoss > 0) {
                 lab.textColor = HexColor(@"#2B7822");;
             }else{
                 lab.textColor = HexColor(@"#FE4C56");
             }
         }
     }];
    
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        CGFloat w = SCREEN_WIDTH / 6;
        for (int i = 0; i < 5; i ++) {
            UILabel *lab = [[UILabel alloc]init];
            lab.textAlignment = NSTextAlignmentCenter;
            lab.lineBreakMode = NSLineBreakByTruncatingTail;
            lab.font = [UIFont systemFontOfSize:12];
            lab.textColor = UIColor.grayColor;
            lab.numberOfLines = 0;
            [self addSubview:lab];
            [lab mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(w * i);
                make.width.mas_equalTo(i == 4 ? (w * 2):w);
                make.centerY.equalTo(self);
            }];
            [self.labs addObject:lab];
        }
        UIView *lineView = [[UIView alloc]init];
        lineView.backgroundColor = makeColorRgb(226, 226, 226);
        [self addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.right.equalTo(self);
            make.height.mas_equalTo(1);
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
