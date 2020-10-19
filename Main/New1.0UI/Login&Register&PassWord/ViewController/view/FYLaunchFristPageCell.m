//
//  FYLaunchFristPageCell.m
//  ProjectCSHB
//
//  Created by Tom on 2020/1/14.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "FYLaunchFristPageCell.h"
#import "FYLaunchPageModel.h"
@interface FYLaunchFristPageCell()
@property (nonatomic ,strong)UILabel *titleLab;
@property (nonatomic ,strong)UIView *backView;
@end
@implementation FYLaunchFristPageCell
- (void)setModel:(FYLaunchPageModel *)model{
    _model = model;
    self.titleLab.textColor = _model.titleColor;
    self.titleLab.text = _model.title;
    self.backView.backgroundColor = _model.backgroundColor;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = UIColor.clearColor;
        [self.contentView addSubview:self.backView];
        [self.backView addSubview:self.titleLab];
        [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
            make.left.mas_equalTo(15);
            make.top.mas_equalTo(5);
        }];
        [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
        }];
        
    }
    return self;
}
- (UILabel *)titleLab{
    if (!_titleLab) {
        _titleLab = [[UILabel alloc]init];
        _titleLab.font = [UIFont systemFontOfSize:18];
    }
    return _titleLab;
}
- (UIView *)backView{
    if (!_backView) {
        _backView = [[UIView alloc]init];
        _backView.layer.masksToBounds = YES;
        _backView.layer.cornerRadius = 4;
    }
    return _backView;
}
@end
