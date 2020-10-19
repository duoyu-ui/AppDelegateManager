//
//  FriendChatInfoHeadCell.m
//  Project
//
//  Created by Mike on 2019/6/25.
//  Copyright © 2019 CDJay. All rights reserved.
//

#import "FriendChatInfoHeadCell.h"
#import "PersonalSignatureModel.h"
#import "FYFriendName.h"
#import "FYContacts.h"


NSString * const kFriendChatInfoHeaderCellId = @"kFriendChatInfoHeaderCellId";


@interface FriendChatInfoHeadCell ()

@property (strong, nonatomic) UILabel *remarkLabel;

@property (strong, nonatomic) UILabel *userNickLabel;

@property (strong, nonatomic) UILabel *userIdLabel;

@property (strong, nonatomic) UIImageView *avartarView;

@end


@implementation FriendChatInfoHeadCell

+ (CGFloat)cellHeightOfTableView
{
    return 80;
}

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    FriendChatInfoHeadCell *cell = [tableView dequeueReusableCellWithIdentifier:kFriendChatInfoHeaderCellId];
    if (!cell) {
        cell = [[FriendChatInfoHeadCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kFriendChatInfoHeaderCellId];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        [self setupSubview];
    }
    return self;
}

- (void)setupSubview {
    
    UIImageView *avartarView = [[UIImageView alloc] init];
    avartarView.layer.cornerRadius = 5;
    avartarView.layer.masksToBounds = YES;
    avartarView.image = [UIImage imageNamed:@"user-default"];
    [self addSubview:avartarView];
    _avartarView = avartarView;
    
    [avartarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(12);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.size.equalTo(@(70));
    }];
    
    UILabel *remarkLabel = [[UILabel alloc] init];
    remarkLabel.font = [UIFont systemFontOfSize:14];
    remarkLabel.textColor = HEXCOLOR(0x333333);
    remarkLabel.numberOfLines = 0;
    remarkLabel.textAlignment = NSTextAlignmentLeft;
    [self addSubview:remarkLabel];
    _remarkLabel = remarkLabel;
    
    [remarkLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(avartarView.mas_top).offset(8);
        make.left.mas_equalTo(avartarView.mas_right).offset(10);
    }];
    
    UILabel *userIdLabel = [[UILabel alloc] init];
    userIdLabel.font = [UIFont systemFontOfSize:13];
    userIdLabel.textColor = HEXCOLOR(0x808080);
    userIdLabel.numberOfLines = 0;
    userIdLabel.textAlignment = NSTextAlignmentLeft;
    [self addSubview:userIdLabel];
    _userIdLabel = userIdLabel;
    
    [userIdLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(avartarView.mas_bottom).offset(-5);
        make.left.mas_equalTo(avartarView.mas_right).offset(12);
    }];
    
    UILabel *userNickLabel = [[UILabel alloc] init];
    userNickLabel.font = [UIFont systemFontOfSize:13];
    userNickLabel.textColor = HEXCOLOR(0x808080);
    userNickLabel.numberOfLines = 0;
    userNickLabel.textAlignment = NSTextAlignmentLeft;
    [self addSubview:userNickLabel];
    _userNickLabel = userNickLabel;
    
    [userNickLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(userIdLabel.mas_top).offset(-5);
        make.left.mas_equalTo(avartarView.mas_right).offset(12);
    }];
    
}

#pragma mark - Setters

- (void)setContacts:(FYContacts *)contacts personalModel:(PersonalSignatureModel *)personalModel
{
    _contacts = contacts;
    _personalModel = personalModel;
    
    [self.avartarView cd_setImageWithURL:contacts.avatar placeholder:@"user-default"];
    NSString *tempNickName = [FYFriendName getName:contacts.userId];
    
    // 备注
    if (VALIDATE_STRING_EMPTY(tempNickName)) {
        if (!VALIDATE_STRING_EMPTY(contacts.friendNick) && contacts.isFriend) {
            self.remarkLabel.text = contacts.friendNick;
        } else {
            self.remarkLabel.text = contacts.nick;
        }
    } else {
        self.remarkLabel.text = tempNickName;
    }
    // 用户昵称
    self.userNickLabel.text = [NSString stringWithFormat:NSLocalizedString(@"昵称: %@", nil), contacts.nick];
    // 用户账号
    if (contacts.isFriend) {
        if (VALIDATE_STRING_EMPTY(personalModel.data.mobile)) {
            self.userIdLabel.text = [NSString stringWithFormat:NSLocalizedString(@"账号: %@", nil), contacts.userId];
        } else {
            self.userIdLabel.text = [NSString stringWithFormat:NSLocalizedString(@"手机: %@", nil), personalModel.data.mobile];
        }
    } else {
        self.userIdLabel.text = [NSString stringWithFormat:NSLocalizedString(@"手机: %@", nil),@"***********"] ;
    }
}


@end

