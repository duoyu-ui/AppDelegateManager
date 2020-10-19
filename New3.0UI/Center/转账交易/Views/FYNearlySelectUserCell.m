//
//  FYNearlySelectUserCell.m
//  ProjectCSHB
//
//  Created by fangyuan on 2020/7/10.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "FYNearlySelectUserCell.h"

@implementation FYNearlySelectUserCell

-(void)updateUseSelected:(BOOL)isSelected{
    if (isSelected) {
        self.imageSelect.image = [UIImage imageNamed:@"icon_select"];
    }else{
        self.imageSelect.image = [UIImage imageNamed:@"icon_unselect"];
    }
}

-(UIImageView *)imageSelect{
    if (!_imageSelect) {
        _imageSelect = [UIImageView new];
        [self.contentView addSubview:_imageSelect];
        [_imageSelect mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(20);
            make.size.mas_equalTo(CGSizeMake(20, 20));
            make.centerY.mas_equalTo(0);
        }];
    }
    return _imageSelect;
}

- (UIImageView *)imageAvatar{
    if (!_imageAvatar) {
        _imageAvatar=[UIImageView new];
        _imageAvatar.layer.cornerRadius = 2;
        [self.contentView addSubview:_imageAvatar];
        [_imageAvatar mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.imageSelect.mas_right).mas_offset(15);
            make.centerY.mas_equalTo(0);
            make.size.mas_equalTo(CGSizeMake(40.0f, 40.0f));
        }];
    }
    return _imageAvatar;
}

- (UILabel *)labelDetail{
    if (!_labelDetail) {
        _labelDetail=[UILabel new];
        _labelDetail.textColor = COLOR_SYSTEM_MAIN_FONT_ASSIST_DEFAULT;
        _labelDetail.font = FONT_PINGFANG_REGULAR(12);
        [self.contentView addSubview:_labelDetail];
        [_labelDetail mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.imageAvatar.mas_right).mas_offset(15);
            make.top.equalTo(self.labelName.mas_bottom).offset(5);
        }];
    }
    return _labelDetail;
}

- (UILabel *)labelName{
    if (!_labelName) {
        _labelName=[UILabel new];
        _labelName.font=FONT_PINGFANG_REGULAR(14);
        _labelName.textColor = COLOR_SYSTEM_MAIN_FONT_DEFAULT;
        [self.contentView addSubview:_labelName];
        [_labelName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.imageAvatar.mas_right).mas_offset(15);
            make.bottom.equalTo(self.imageAvatar.mas_centerY).offset(-0.25f);
        }];
    }
    return _labelName;
}

@end

