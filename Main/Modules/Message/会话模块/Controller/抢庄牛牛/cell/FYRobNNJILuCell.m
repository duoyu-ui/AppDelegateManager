//
//  FYRobNNJILuCell.m
//  ProjectCSHB
//
//  Created by 汤姆 on 2019/10/3.
//  Copyright © 2019 CDJay. All rights reserved.
//

#import "FYRobNNJILuCell.h"
@interface FYRobNNJILuCell()

@property (nonatomic, strong) NSMutableArray <UILabel*>*labs;
@end
@implementation FYRobNNJILuCell
- (void)setModel:(FYRobNNJiLuRecords *)model{
    _model = model;
    NSMutableArray *arr = [NSMutableArray arrayWithObjects:_model.period,_model.userName,_model.niuStr,_model.result, nil];
    if (arr.count == 0) {
        return;
    }
    [self.labs enumerateObjectsUsingBlock:^(UILabel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.text = arr[idx];
    }];
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        CGFloat w = SCREEN_WIDTH / 4;
        for (int i = 0;i < 4 ; i++) {
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
