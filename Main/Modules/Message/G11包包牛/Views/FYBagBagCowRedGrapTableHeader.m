//
//  FYBagBagCowRedGrapTableHeader.m
//  ProjectCSHB
//
//  Created by fangyuan on 2020/7/23.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "FYBagBagCowRedGrapTableHeader.h"
#import "FYBagBagCowRedGrapResponse.h"

@implementation FYBagBagCowRedGrapTableHeader

/// 刷新红包信息
- (void)refreshWithDetailModel:(FYBagBagCowRedGrapData *)detailModel sumMoney:(CGFloat)sumMoney money:(NSString *)money
{
    if (![detailModel isKindOfClass:[FYBagBagCowRedGrapData class]]) {
        return;
    }
    
    FYBagBagCowRedGrapData *detail = (FYBagBagCowRedGrapData *)detailModel;
    
    if (money.length > 1 ) {
        self.height = 320;
        [self.moneyLab mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(40);
        }];
        NSString *absMoney = [NSString stringWithFormat:NSLocalizedString(@"%@元", nil), money];
        NSMutableAttributedString *abs = [[NSMutableAttributedString alloc]initWithString:absMoney];
        [abs addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:13] range:NSMakeRange(absMoney.length - 1, 1)];
        self.moneyLab.attributedText = abs;
        [self layoutIfNeeded];
    }
    
    self.nickLab.text = detail.nickName;
    
    if ([CFCSysUtil validateStringUrl:detail.avatar]) {
        UIImage *placeholderImage = [UIImage imageNamed:ICON_MESSAGE_USER_AVATAR_PLACEHOLDER];
        [self.avatarImgView sd_setImageWithURL:[NSURL URLWithString:detail.avatar] placeholderImage:placeholderImage options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
            
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
        }];
    } else if (!VALIDATE_STRING_EMPTY(detail.avatar) && [UIImage imageNamed:detail.avatar]) {
        [self.avatarImgView setImage:[UIImage imageNamed:detail.avatar]];
    } else {
        [self.avatarImgView setImage:[UIImage imageNamed:ICON_MESSAGE_USER_AVATAR_PLACEHOLDER]];
    }
    
    if (detail.overFlag || detail.items.count >= 3) {
        self.timeLab.text = NSLocalizedString(@"本次红包游戏已截止", nil);
        self.overdueTimes = 0;
        [self.timer invalidate];
    } else {
        if (detail.exceptOverdueTime > 0) {
            self.overdueTimes = detail.exceptOverdueTime;
            self.timeLab.text = [NSString stringWithFormat:NSLocalizedString(@"距离抢包结束: %zd秒", nil), detail.exceptOverdueTime];
            [self scheduledTimerCountDown];
        }
    }
    
    self.centerLab.text = [NSString stringWithFormat:NSLocalizedString(@"%.2f元 - %zd包", nil), detail.totalMoney.floatValue, detail.amount];
    [self refreshSubViewContent:detail sumMoney:sumMoney];
}

- (void)refreshSubViewContent:(FYBagBagCowRedGrapData *)detail sumMoney:(CGFloat)sumMoney
{
    self.leiLab.hidden = YES;
    self.lineView.hidden = YES;
    self.lineView2.hidden = YES;
    
    self.moneyNumLab.text = [NSString stringWithFormat:NSLocalizedString(@"已领取%ld个红包, 共%.2f元, %ld秒被抢完", nil), detail.amount, detail.totalMoney.floatValue, detail.seconds];
}


@end
