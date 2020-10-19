//
//  AddGroupContactCell.m
//  ProjectXZHB
//
//  Created by 汤姆 on 2019/7/30.
//  Copyright © 2019 CDJay. All rights reserved.
//

#import "AddGroupContactCell.h"
#import <SDWebImage.h>

@interface AddGroupContactCell()
/** 头像*/
@property (nonatomic, strong) UIImageView *avatarView;
/** 昵称*/
@property (nonatomic, strong) UILabel *nickLabel;
/** 选择状态*/
@property (nonatomic, strong) UIImageView *selectedView;

@property (nonatomic, strong) UIView *lineView;

@end

@implementation AddGroupContactCell

- (void)setModel:(ContactModel *)model{
    _model = model;
    NSString *nickName=[[AppModel shareInstance] getFriendName:model.userId];
    if (nickName.length < 1) {
        nickName = model.nick;
    }
    self.nickLabel.text = nickName;
    [self.avatarView sd_setImageWithURL:[NSURL URLWithString:model.avatar]
                       placeholderImage:[UIImage imageNamed:@"user-default"]];
    
    if (model.isSelected) {
        self.selectedView.image = [UIImage imageNamed:@"AddGroupIcon_s"];
    }else {
        self.selectedView.image = [UIImage imageNamed:@"AddGroupIcon_n"];
    }
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        [self addSubview:self.avatarView];
        [self addSubview:self.nickLabel];
        [self addSubview:self.selectedView];
        [self addSubview:self.lineView];
        
        [self.avatarView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.left.mas_equalTo(15);
            make.width.height.mas_equalTo(40);
        }];
        
        [self.nickLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.avatarView.mas_right).offset(10);
            make.centerY.equalTo(self);
        }];
        
        [self.selectedView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.right.mas_equalTo(-25);
            make.width.height.mas_equalTo(15);
        }];
        
        [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.nickLabel.mas_left);
            make.right.equalTo(self.selectedView.mas_right);
            make.height.mas_equalTo(0.5);
            make.bottom.equalTo(self);
        }];
    }
    
    return self;
}


#pragma mark - Getter

- (UIImageView *)avatarView {
    if (!_avatarView) {
        _avatarView = [[UIImageView alloc] init];
        _avatarView.layer.masksToBounds = YES;
        _avatarView.layer.cornerRadius = 4;
    }
    return _avatarView;
}


- (UILabel *)nickLabel {
    if (!_nickLabel) {
        _nickLabel = [[UILabel alloc] init];
        _nickLabel.textColor = UIColor.blackColor;
        _nickLabel.font = [UIFont systemFontOfSize2:16];
    }
    return _nickLabel;
}


- (UIImageView *)selectedView {
    if (!_selectedView) {
        _selectedView = [[UIImageView alloc] init];
        
    }
    return _selectedView;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = COLOR_SYSTEM_MAIN_UI_THEME_DEFAULT;
    }
    return _lineView;
}

@end
