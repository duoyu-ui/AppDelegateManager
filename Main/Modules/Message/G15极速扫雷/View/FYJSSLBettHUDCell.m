//
//  FYJSSLBettHUDCell.m
//  ProjectCSHB
//
//  Created by Tom on 2020/8/28.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "FYJSSLBettHUDCell.h"
#import "FYJSSLDataSource.h"
@interface FYJSSLBettHUDCell()
@property (nonatomic , strong) UIView *lineView;
@property (nonatomic , strong) UIView *lineView1;
@property (nonatomic , strong) UILabel *digitsLab;
@property (nonatomic , strong) UILabel *betNumLab;
@end
@implementation FYJSSLBettHUDCell
- (void)setList:(FYJSSLDataSource *)list{
    _list = list;
    self.betNumLab.text = [NSString stringWithFormat:@"%zd",list.num];
    switch (list.digits) {
        case 0:
            self.digitsLab.text = NSLocalizedString(@"万", nil);
            break;
        case 1:
            self.digitsLab.text = NSLocalizedString(@"千", nil);
            break;
        case 2:
            self.digitsLab.text = NSLocalizedString(@"百", nil);
            break;
        case 3:
            self.digitsLab.text = NSLocalizedString(@"十", nil);
            break;
        case 4:
            self.digitsLab.text = NSLocalizedString(@"个", nil);
            break;
        default:
            break;
    }
}
+ (NSString *)reuseIdentifier{
    return [NSString stringWithFormat:@"%@",self];
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = HexColor(@"#F5F5F5");
        [self addSubview:self.lineView];
        [self addSubview:self.lineView1];
        [self addSubview:self.digitsLab];
        [self addSubview:self.betNumLab];
        [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.right.equalTo(self);
            make.height.mas_equalTo(kLineHeight);
        }];
        [self.lineView1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.bottom.top.equalTo(self);
            make.width.mas_equalTo(kLineHeight);
        }];
        [self.digitsLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.centerY.equalTo(self);
            make.right.equalTo(self.lineView1);
        }];
        [self.betNumLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.centerY.equalTo(self);
            make.left.equalTo(self.lineView1);
        }];
    }
    return self;
}
- (UILabel *)digitsLab{
    if (!_digitsLab) {
        _digitsLab = [[UILabel alloc]init];
        _digitsLab.font = [UIFont systemFontOfSize:13];
        _digitsLab.textAlignment = NSTextAlignmentCenter;
        _digitsLab.textColor = HexColor(@"#666666");
    }
    return _digitsLab;
}
- (UILabel *)betNumLab{
    if (!_betNumLab) {
        _betNumLab = [[UILabel alloc]init];
        _betNumLab.font = [UIFont systemFontOfSize:13];
        _betNumLab.textAlignment = NSTextAlignmentCenter;
        _betNumLab.textColor = HexColor(@"#666666");
    }
    return _betNumLab;
}
- (UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc]init];
        _lineView.backgroundColor = HexColor(@"#D9D9D9");
    }
    return _lineView;
}
- (UIView *)lineView1{
    if (!_lineView1) {
        _lineView1 = [[UIView alloc]init];
        _lineView1.backgroundColor = HexColor(@"#D9D9D9");
    }
    return _lineView1;
}
@end
