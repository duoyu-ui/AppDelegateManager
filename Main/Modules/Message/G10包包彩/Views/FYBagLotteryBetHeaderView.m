//
//  FYBagLotteryBetHeaderView.m
//  ProjectCSHB
//
//  Created by Tom on 2020/7/20.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "FYBagLotteryBetHeaderView.h"
#import "FYNperHaederView.h"
@interface FYBagLotteryBetHeaderView()<FYIMGroupChatHeaderViewDelegate>
/* 群聊头部面板 - 控件 */
@property(nonatomic, strong) FYIMGroupChatHeaderView *groupHearderView;

@end
@implementation FYBagLotteryBetHeaderView

- (void)setBalance:(NSString *)balance{
    _balance = balance;
    self.groupHearderView.balance = balance;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
       
        [self initSubview];
    }
    return self;
}
- (void)initSubview{
    [self addSubview:self.groupHearderView];
    self.groupHearderView.hidden = NO;
    [self.groupHearderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
        make.height.mas_equalTo(40);
    }];
}
- (FYIMGroupChatHeaderView *)groupHearderView{
    if (!_groupHearderView) {
        _groupHearderView = [[FYIMGroupChatHeaderView alloc]initWithGroupTemplateType:14];
        _groupHearderView.delegate = self;
    }
    return _groupHearderView;
}
#pragma mark - FYIMGroupChatHeaderViewDelegate
// 群组头部事件 - 查看余额
- (void)groupHeaderView:(FYIMGroupChatHeaderView *)headerView didActionOfCheckBalance:(UILabel *)balanceLabel{
    if ([self.delegate respondsToSelector:@selector(didActionOfCheckBalance)]) {
        [self.delegate didActionOfCheckBalance];
    }
}

// 群组头部事件 - 充值操作
- (void)groupHeaderView:(FYIMGroupChatHeaderView *)headerView didActionOfRecharge:(UIButton *)button{
    if ([self.delegate respondsToSelector:@selector(didActionOfRecharge)]) {
        [self.delegate didActionOfRecharge];
    }
}

// 群组头部事件 - 玩法操作
- (void)groupHeaderView:(FYIMGroupChatHeaderView *)headerView didActionOfPlayRule:(UIButton *)button{
    if ([self.delegate respondsToSelector:@selector(didActionOfPlayRule)]) {
        [self.delegate didActionOfPlayRule];
    }
}

// 群组头部事件 - 分享操作
- (void)groupHeaderView:(FYIMGroupChatHeaderView *)headerView didActionOfShare:(UIButton *)button{
    
    if ([self.delegate respondsToSelector:@selector(didActionOfShare)]) {
        [self.delegate didActionOfShare];
    }
}
@end
