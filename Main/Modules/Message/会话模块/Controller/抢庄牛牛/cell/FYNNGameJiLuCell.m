//
//  FYNNGameJiLuCell.m
//  ProjectCSHB
//
//  Created by 汤姆 on 2019/10/4.
//  Copyright © 2019 CDJay. All rights reserved.
//

#import "FYNNGameJiLuCell.h"
@interface FYNNGameJiLuCell()

@property (nonatomic, strong) NSMutableArray<UILabel*> *labs;
@end
@implementation FYNNGameJiLuCell
- (void)setList:(FYNNGameJiLuList *)list{
    _list = list;
    
    NSMutableArray <NSString *>*titles = [NSMutableArray arrayWithObjects:_list.userName,_list.money,_list.niuStr,_list.betting,_list.profitLoss, nil];
    if (titles.count == 0) {
        return;
    }
    [self.labs enumerateObjectsUsingBlock:^(UILabel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.text = titles[idx];
        
        if (idx == 4) {
            if ([list.profitLoss integerValue] >= 0) {
                obj.textColor = HexColor(@"#2B7822");
            }else{
                obj.textColor = HexColor(@"#FE4C56");
            }
        }
    }];
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        CGFloat w = SCREEN_WIDTH / 5;
        for (int i = 0; i < 5; i ++) {
            UILabel *lab = [[UILabel alloc]init];
            lab.textAlignment = NSTextAlignmentCenter;
            lab.font = [UIFont systemFontOfSize:12];
            lab.textColor = UIColor.grayColor;
            [self addSubview:lab];
            [lab mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(w * i);
                make.width.mas_equalTo(w);
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
