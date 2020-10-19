//
//  SSChatKeyBoardInputView+Custom.m
//  ProjectCSHB
//
//  Created by fangyuan on 2020/6/2.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "SSChatKeyBoardInputView+Custom.h"
#import "RobNiuNiuQunModel.h"
#import "FYSolitaireInfoModel.h"

@implementation SSChatKeyBoardInputView (Custom)

// 接龙游戏
- (void)didUpdateChatKeyboardCustomButtonWithSolitaireInfoModel:(FYSolitaireInfoModel *)solitaireInfoModel
{
    BOOL isBank = [APPINFORMATION.userInfo.userId isEqualToString:solitaireInfoModel.groupOwnerId] && (solitaireInfoModel.gameStatus == 1 ||solitaireInfoModel.gameStatus == 0);
    BOOL isHidden = !isBank;
    [self.mCustomBtn setHidden:isHidden];
    [self.mCustomBtn setTitle:NSLocalizedString(@"发", nil) forState:UIControlStateNormal];
    if (isHidden) {
        [UIView animateWithDuration:self.changeTime animations:^{
            [self.mTextBtn setWidth:SSChatTextWidth1];
            [self.mTextView setWidth:SSChatTextWidth1];
        }];
    } else {
        [UIView animateWithDuration:self.changeTime animations:^{
            [self.mTextBtn setWidth:SSChatTextWidth2];
            [self.mTextView setWidth:SSChatTextWidth2];
        }];
    }
}

// 抢庄牛牛
- (void)didUpdateChatKeyboardCustomButtonWithRobNiuNiuQunModel:(RobNiuNiuQunModel *)robNiuNiuModel
{
    self.statusOfRobNiuNiu = robNiuNiuModel.status;
    
    BOOL isBank = [APPINFORMATION.userInfo.userId isEqualToString:robNiuNiuModel.bankerId];
    BOOL isHidden = [self isCustomButtonHiddenForRobNiuNiu:robNiuNiuModel.status isBank:isBank];
    NSString *title = [self titleOfCustomButtonForRobNiuNiu:robNiuNiuModel.status];
    NSString *imageUrl = [self imageUrlOfCustomButtonForRobNiuNiu:robNiuNiuModel.status isBank:isBank];
    [self.mCustomBtn setHidden:isHidden];
    [self.mCustomBtn setTitle:title forState:UIControlStateNormal];
    [self.mCustomBtn setBackgroundImage:[UIImage imageNamed:imageUrl] forState:UIControlStateNormal];
    [self.mCustomBtn setBackgroundImage:[UIImage imageNamed:imageUrl] forState:UIControlStateSelected];
    if (isHidden) {
        [UIView animateWithDuration:self.changeTime animations:^{
            [self.mTextBtn setWidth:SSChatTextWidth1];
            [self.mTextView setWidth:SSChatTextWidth1];
        }];
    } else {
        [UIView animateWithDuration:self.changeTime animations:^{
            [self.mTextBtn setWidth:SSChatTextWidth2];
            [self.mTextView setWidth:SSChatTextWidth2];
        }];
    }
}

/**
 * 判断是否庄家在不同状态是否隐藏按钮
 * @param status 状态 1.连续上庄 2.抢庄 3.投注 4.发包 5.抢包 6.结算
 * @param isBank 是否庄家
 * @return 是否隐藏
 */
- (BOOL)isCustomButtonHiddenForRobNiuNiu:(NSInteger)status isBank:(BOOL)isBank
{
    if (isBank) {
        // 庄家
        switch (status) {
            case 1: // 连续上庄
                return YES;
                break;
            case 2: // 抢庄
                return NO;
                break;
            case 3: // 投注
                return YES;
                break;
            case 4: // 发包
                return NO;
                break;
            case 5: // 抢包
                return YES;
                break;
            case 6: // 结算
                return YES;
                break;
            default:
                return YES;
                break;
        }
    } else {
        switch (status) {
            case 1: // 连续上庄
                return YES;
                break;
            case 2: // 抢庄
                return NO;
                break;
            case 3: // 投注
                return NO;
                break;
            case 4: // 发包
                return YES;
                break;
            case 5: // 抢包
                return YES;
                break;
            case 6: // 结算
                return YES;
                break;
            default:
                return YES;
                break;
        }
    }
}

- (NSString *)titleOfCustomButtonForRobNiuNiu:(NSInteger)status
{
    // 群状态：1.连续上庄 2.抢庄 3.投注 4.发包 5.抢包 6.结算*/
    switch (status) {
        case 1:
            return NSLocalizedString(@"连", nil);
        case 2:
            return NSLocalizedString(@"竟", nil);
        case 3:
            return NSLocalizedString(@"投", nil);
        case 4:
            return NSLocalizedString(@"发", nil);
        case 5:
            return NSLocalizedString(@"抢", nil);
        case 6:
            return NSLocalizedString(@"结", nil);
        default:
            return @"";
            break;
    }
}

/**
 * 判断是否庄家在不同状态是否隐藏按钮
 * @param status 状态 1.连续上庄 2.抢庄 3.投注 4.发包 5.抢包 6.结算
 * @param isBank 是否庄家
 * @return 是否隐藏
 */
- (NSString *)imageUrlOfCustomButtonForRobNiuNiu:(NSInteger)status isBank:(BOOL)isBank
{
    NSString *showTrueImage = @"icon_bg_send_button_red";
    NSString *showFalseImage = @"icon_bg_send_button_gray";
    if (isBank) {
        // 庄家
        switch (status) {
            case 1: // 连续上庄
                return showFalseImage;
                break;
            case 2: // 抢庄
                return showTrueImage;
                break;
            case 3: // 投注
                return showFalseImage;
                break;
            case 4: // 发包
                return showTrueImage;
                break;
            case 5: // 抢包
                return showFalseImage;
                break;
            case 6: // 结算
                return showFalseImage;
                break;
            default:
                return showFalseImage;
                break;
        }
    } else {
        switch (status) {
            case 1: // 连续上庄
                return showFalseImage;
                break;
            case 2: // 抢庄
                return showTrueImage;
                break;
            case 3: // 投注
                return showTrueImage;
                break;
            case 4: // 发包
                return showFalseImage;
                break;
            case 5: // 抢包
                return showFalseImage;
                break;
            case 6: // 结算
                return showFalseImage;
                break;
            default:
                return showFalseImage;
                break;
        }
    }
}


@end

