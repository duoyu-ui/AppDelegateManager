//
//  FYJSSLGameCell.m
//  ProjectCSHB
//
//  Created by Tom on 2020/8/26.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "FYJSSLGameCell.h"
@interface FYJSSLGameCell ()
@property (nonatomic , strong) UIImageView *imgView;
@property (nonatomic , strong) UILabel *titleLab;
@end
@implementation FYJSSLGameCell

- (void)setList:(FYJSSLDataSource *)list{
    _list = list;
    if (list.isSelected) {
        self.imgView.image = list.imgSel;
    }else{
        self.imgView.image = list.imgNor;
    }
    self.titleLab.text = [NSString stringWithFormat:@"%zd",list.num];
    
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColor.whiteColor;
        [self addSubview:self.imgView];
        [self.imgView addSubview:self.titleLab];
        [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
            make.width.height.equalTo(self.mas_width).offset(-15);
        }];
        [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.imgView);
            make.bottom.equalTo(self.imgView.mas_bottom).offset(-5);
        }];
    }
    return self;
}
- (UIImageView *)imgView{
    if (!_imgView) {
        _imgView = [[UIImageView alloc]init];
    }
    return _imgView;
}
- (UILabel *)titleLab{
    if (!_titleLab) {
        _titleLab = [[UILabel alloc]init];
        _titleLab.textColor = UIColor.whiteColor;
        _titleLab.font = FONT_PINGFANG_BOLD(16);
    }
    return _titleLab;
}
@end
