//
//  FYChatNiuNiuWinCell.m
//  ProjectCSHB
//
//  Created by Tom on 2020/6/27.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "FYChatNiuNiuWinCell.h"
@interface FYChatNiuNiuWinCell()
@property (nonatomic , strong) NSMutableArray <UILabel*>*labs;
@end
@implementation FYChatNiuNiuWinCell

- (void)setList:(FYNiuNiuWinGrabList *)list{
    _list = list;
    [self.labs enumerateObjectsUsingBlock:^(UILabel * _Nonnull lab, NSUInteger idx, BOOL * _Nonnull stop) {
        switch (idx) {
            case 0:
                lab.text = list.nick;
                break;
            case 1:
                lab.text = list.score;
                break;
            case 2:
                lab.text = list.handicap;
                break;
            case 3:
                lab.textColor = list.winMoney >= 0 ? HexColor(@"#CB332D") :HexColor(@"#1A1A1A");
                lab.text = [NSString stringWithFormat:@"%.2lf",list.winMoney];
                break;
            default:
                break;
        }
    }];
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = UIColor.whiteColor;
        [self initSubView];
    }
    return self;
}

- (void)initSubView{
    CGFloat labW = (SCREEN_WIDTH * 0.65 - 25) / 4;
    for (int i = 0; i < 4; i++) {
        UILabel *lab = [self setLabCent];
        if (i == 1 || i == 2 ) {
            lab.textAlignment = NSTextAlignmentCenter;
        }else if(i == 3){
            lab.textAlignment = NSTextAlignmentRight;
        }
        [self addSubview:lab];
        [lab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.left.mas_equalTo(i * labW);
            make.width.mas_equalTo(labW);
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
@end
