//
//  AddGroupContactHeadeerViewCell.m
//  Project
//
//  Created by 汤姆 on 2019/7/30.
//  Copyright © 2019 CDJay. All rights reserved.
//

#import "AddGroupContactHeadeerViewCell.h"
#import <SDWebImage.h>


@interface AddGroupContactHeadeerViewCell()
/// 头像
@property (nonatomic, strong) UIImageView *avatarView;

@end

@implementation AddGroupContactHeadeerViewCell

- (void)setModel:(ContactModel *)model{
    _model = model;
    
     [self.avatarView sd_setImageWithURL:[NSURL URLWithString:_model.avatar] placeholderImage:[UIImage imageNamed:@"addGroupContactAvatar_icon"]];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.avatarView];
        [self.avatarView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
    }
    return self;
}

- (UIImageView *)avatarView {
    
    if (!_avatarView) {
        _avatarView = [[UIImageView alloc]init];
        _avatarView.layer.masksToBounds = YES;
        _avatarView.layer.cornerRadius = 4;
    }
    return _avatarView;
}

@end
