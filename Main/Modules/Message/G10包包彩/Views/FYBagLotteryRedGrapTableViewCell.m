//
//  FYBagLotteryRedGrapTableViewCell.m
//  ProjectCSHB
//
//  Created by fangyuan on 2020/7/24.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "FYBagLotteryRedGrapTableViewCell.h"
#import "FYBagLotteryRedGrapResponse.h"

@implementation FYBagLotteryRedGrapTableViewCell

/// 游戏类型（0：福利群；1：扫雷群；2：牛牛群；3：禁抢；4：抢庄牛牛群；5：二八杠；6：龙虎斗；7：接龙红包；8：二人牛牛；9:超级扫雷；10:包包彩；11:包包牛）
- (void)setCellModel:(id)cellModel type:(GroupTemplateType)type
{
    if (![cellModel isKindOfClass:[FYBagLotteryRedGrapModel class]]) {
        return;
    }
    
    FYBagLotteryRedGrapModel *model = (FYBagLotteryRedGrapModel *)cellModel;
    
    if ([CFCSysUtil validateStringUrl:model.avatar]) {
        UIImage *placeholderImage = [UIImage imageNamed:ICON_MESSAGE_USER_AVATAR_PLACEHOLDER];
        [self.avatarImgView sd_setImageWithURL:[NSURL URLWithString:model.avatar] placeholderImage:placeholderImage options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
            
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
        }];
    } else if (!VALIDATE_STRING_EMPTY(model.avatar) && [UIImage imageNamed:model.avatar]) {
        [self.avatarImgView setImage:[UIImage imageNamed:model.avatar]];
    } else {
        [self.avatarImgView setImage:[UIImage imageNamed:ICON_MESSAGE_USER_AVATAR_PLACEHOLDER]];
    }
    
    self.nickLab.text = model.nickName;
    self.timeLab.text = model.createTime;
    
    NSString *money = [NSString stringWithFormat:NSLocalizedString(@"%@元", nil), model.money];
    self.moneyLab.text = money;
    
    self.bestLuckLab.hidden = YES;
    self.luckImgView.hidden = YES;
    self.leiImgView.hidden = YES;
    self.bankerLab.hidden = YES;
    self.cowLab.hidden = YES;
    self.cowImgView.hidden = YES;
}

@end
