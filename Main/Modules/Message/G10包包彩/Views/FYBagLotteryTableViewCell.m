//
//  FYBagLotteryTableViewCell.m
//  ProjectCSHB
//
//  Created by Tom on 2020/7/18.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "FYBagLotteryTableViewCell.h"
@interface FYBagLotteryTableViewCell()
@property (nonatomic , strong) UILabel *titleLab;
@end
@implementation FYBagLotteryTableViewCell

-(void)setList:(FYBagLotteryBetListData *)list{
    _list = list;
    self.titleLab.text = list.title;
    
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initSubview];
    }
    return self;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated{
    self.titleLab.highlighted = selected;
}
- (void)initSubview{
    self.backgroundColor = HexColor(@"#F8F8F8");
    [self addSubview:self.titleLab];
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
    }];
    
}
- (UILabel *)titleLab{
    if (!_titleLab) {
        _titleLab = [[UILabel alloc]init];
        _titleLab.textColor = HexColor(@"#333333");
        _titleLab.highlightedTextColor = HexColor(@"#CB332D");
        _titleLab.textAlignment = NSTextAlignmentCenter;
        _titleLab.font = FONT_PINGFANG_REGULAR(15);
    }
    return _titleLab;
}
@end
