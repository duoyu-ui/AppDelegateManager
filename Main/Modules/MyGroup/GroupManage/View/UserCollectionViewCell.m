//
//  UserCollectionViewCell.m
//  Project
//
//  Created by mini on 2018/8/16.
//  Copyright © 2018年 CDJay. All rights reserved.
//

#import "UserCollectionViewCell.h"

@interface UserCollectionViewCell()

@property (nonatomic, strong) UIImageView *avatarImageView;

@property (nonatomic, strong) UILabel *nameLabel;

@end

@implementation UserCollectionViewCell
    
#pragma mark - getter

- (UIImageView *)avatarImageView {
    
    if (!_avatarImageView) {
        _avatarImageView = [[UIImageView alloc] init];
        _avatarImageView.userInteractionEnabled = YES;
        _avatarImageView.layer.cornerRadius = 5;
        _avatarImageView.layer.masksToBounds = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(avatarTapAction)];
        _avatarImageView.userInteractionEnabled = YES;
        [_avatarImageView addGestureRecognizer:tap];
    }
    return _avatarImageView;
}

- (UILabel *)nameLabel {
    
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.textColor = Color_3;
        _nameLabel.font = [UIFont systemFontOfSize2:13];
        _nameLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _nameLabel;
}

#pragma mark - life cycle

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubview];
    }
    return self;
}

- (void)avatarTapAction {
    NSInteger tag = self.avatarImageView.tag;
    if (self.block != nil) {
        self.block(tag);
    }
}

- (void)setupSubview {
    [self.contentView addSubview:self.avatarImageView];
    [self.contentView addSubview:self.nameLabel];
    
    [self.avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.width.height.equalTo(@(CD_Scal(42, 667)));
        make.top.equalTo(self.contentView.mas_top).offset(CD_Scal(16, 667));
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.avatarImageView.mas_bottom).offset(CD_Scal(6, 667));
        make.centerX.equalTo(self.contentView);
        make.width.equalTo(@70);
    }];
}

#pragma mark - setter

- (void)setModel:(GroupInfoUserModel *)model{
    _model = model;
    
    NSString *nickName=[[AppModel shareInstance] getFriendName:model.userId];
    if (nickName.length>0) {
        self.nameLabel.text = nickName;
    }else{
        if ([NSString isBlankString:model.friendNick]) {
            self.nameLabel.text = model.nick;
        }else {
            self.nameLabel.text = model.friendNick;
        }
    }
    
    if ([model.avatar hasPrefix:@"http"]) {
        [self.avatarImageView cd_setImageWithURL:[NSURL URLWithString:[NSString cdImageLink:model.avatar]] placeholderImage:[UIImage imageNamed:@"user-default"]];
    }else {
        self.avatarImageView.image = [UIImage imageNamed:model.avatar];
        
        if ([_model.avatar isEqualToString:@"group_+"]) {
            self.avatarImageView.tag = 100000;
        }else if ([_model.avatar isEqualToString:@"group_-"]){
            self.avatarImageView.tag = 100001;
        }
    }
}


@end
