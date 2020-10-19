//
//  FYChatRobKeyboardCell.m
//  ProjectCSHB
//
//  Created by 汤姆 on 2019/10/8.
//  Copyright © 2019 Jetter. All rights reserved.
//

#import "FYChatRobKeyboardCell.h"
@interface FYChatRobKeyboardCell()


@end
@implementation FYChatRobKeyboardCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.bgView];
        [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
            make.left.top.mas_equalTo(5);
        }];
        [self.bgView addSubview:self.titleLab];
        [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.bgView);
        }];
        [self.bgView addSubview:self.deleteImge];
        [self.deleteImge mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.bgView);
            make.width.mas_equalTo(38);
            make.height.mas_equalTo(20);
        }];
        
    }
    return self;
}
- (UIImageView *)bgView{
    if (!_bgView) {
        _bgView = [[UIImageView alloc]init];
        _bgView.layer.cornerRadius = 8;
        _bgView.layer.masksToBounds = YES;
    }
    return _bgView;
}
- (UILabel *)titleLab{
    if (!_titleLab) {
        _titleLab = [[UILabel alloc]init];
        _titleLab.textColor = UIColor.blackColor;
    }
    return _titleLab;
}
- (UIImageView *)deleteImge{
    if (!_deleteImge) {
        _deleteImge = [[UIImageView alloc]init];
    }
    return _deleteImge;
}
@end
