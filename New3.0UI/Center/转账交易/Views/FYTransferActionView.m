//
//  FYTransferActionView.m
//  ProjectCSHB
//
//  Created by Tom on 2020/5/28.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "FYTransferActionView.h"

@implementation FYTransferActionView

-(UIImageView *)imageView{
    if (!_imageView) {
        _imageView=[UIImageView new];
        [self addSubview:_imageView];
        [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(42, 42));
            make.centerX.mas_equalTo(0);
            make.bottom.mas_equalTo(self.mas_centerY).offset(10);
        }];
    }
    return _imageView;
}

-(UILabel *)labelName{
    if (!_labelName) {
        _labelName=[UILabel new];
        _labelName.font = [UIFont systemFontOfSize:16];
        _labelName.textColor = [UIColor blackColor];
        [self addSubview:_labelName];
        [_labelName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.imageView.mas_bottom);
            make.bottom.mas_equalTo(-10);
            make.centerX.mas_equalTo(0);
        }];
    }
    return _labelName;
}



@end
