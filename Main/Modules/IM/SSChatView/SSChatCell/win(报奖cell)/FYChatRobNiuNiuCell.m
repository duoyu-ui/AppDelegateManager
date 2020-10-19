//
//  FYChatRobNiuNiuCell.m
//  ProjectCSHB
//
//  Created by Tom on 2020/6/28.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "FYChatRobNiuNiuCell.h"
@interface FYChatRobNiuNiuCell()
@property (nonatomic , strong) NSMutableArray<UILabel*> *labs;
@end
@implementation FYChatRobNiuNiuCell

- (void)setList:(FYChatNiuNiuData *)list{
    _list = list;
    [self.labs enumerateObjectsUsingBlock:^(UILabel * _Nonnull lab, NSUInteger idx, BOOL * _Nonnull stop) {
        switch (idx) {
            case 0:
                lab.text = list.name;
                break;
            case 1:
                lab.textAlignment = NSTextAlignmentCenter;
                lab.text = list.str;
                break;
            case 2:
            {
                lab.textAlignment = NSTextAlignmentRight;
                NSString *text = [NSString stringWithFormat:NSLocalizedString(@"%zd倍", nil),[list.handicap integerValue]];
                lab.text = [NSString stringWithFormat:@"%@",text];
            }
                break;
            case 3:
            {
                lab.textAlignment = NSTextAlignmentLeft;
                NSString *text = [NSString stringWithFormat:NSLocalizedString(@"投%@", nil),list.bet];
                lab.text = [NSString stringWithFormat:@"%@",text];
            }
                break;
            case 4:
                lab.textAlignment = NSTextAlignmentRight;
                lab.textColor = [list.money integerValue] > 0 ? HexColor(@"#CB332D") : HexColor(@"#1A1A1A");
                lab.text = list.money;
                break;
            default:
                break;
        }
    }];
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = UIColor.whiteColor;
         CGFloat labw = ((SCREEN_WIDTH * 0.75 - 25) / 5);
        for (int i = 0; i < 5; i ++) {
            UILabel *lab = [self setLabCent];
            [self addSubview:lab];
            [lab mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self);
                make.left.equalTo(self.mas_left).offset(i * labw);
                make.width.mas_equalTo(i == 2 ? (labw - 10) : labw );
            }];
            [self.labs addObj:lab];
        }
    }
    return self;
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
