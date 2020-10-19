//
//  FYRedEnvelopePublickTableViewCell.m
//  ProjectCSHB
//
//  Created by Tom on 2020/6/22.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "FYRedEnvelopePublickTableViewCell.h"
#import "FYRedEnvelopePublickResponse.h"

@interface FYRedEnvelopePublickTableViewCell()

@end

@implementation FYRedEnvelopePublickTableViewCell

/// 游戏类型（0：福利群；1：扫雷群；2：牛牛群；3：禁抢；4：抢庄牛牛群；5：二八杠；6：龙虎斗；7：接龙红包；8：二人牛牛；9:超级扫雷；10:包包彩；11:包包牛）
- (void)setCellModel:(id)cellModel type:(GroupTemplateType)type
{
    if (![cellModel isKindOfClass:[FYRedEnvelopePubickGrabModel class]]) {
        return;
    }
    
    FYRedEnvelopePubickGrabModel *model = (FYRedEnvelopePubickGrabModel *)cellModel;
    
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
    
    self.nickLab.text = model.nick;
    self.timeLab.text = model.createTime;
    
    NSString *money = [NSString stringWithFormat:@"%@%@",model.money,NSLocalizedString(@"元", nil)];
    if (model.bombFlag) {
        NSMutableAttributedString *abs = [[NSMutableAttributedString alloc]initWithString:money];
        [abs addAttribute:NSForegroundColorAttributeName value:HexColor(@"#CB332D") range:NSMakeRange( money.length - 2 , 1)];
        self.moneyLab.attributedText = abs;
    } else {
        self.moneyLab.text = money;
    }
    
    if([model.userId isEqualToString:[AppModel shareInstance].userInfo.userId]) { //自己的抢包的话,标红处理
        self.nickLab.textColor = HexColor(@"#E16754");
    } else {
        self.nickLab.textColor = HexColor(@"#1A1A1A");
    }
    
    if (model.best) {
        self.bestLuckLab.text = NSLocalizedString(@"手气最佳", nil);
        self.bestLuckLab.textColor = HexColor(@"#FFB21D");
        [self.luckImgView setImage:[UIImage imageNamed:@"luck_icon"]];
    } else if(model.worst) {
        self.bestLuckLab.text = NSLocalizedString(@"手气最差", nil);
        self.bestLuckLab.textColor = HexColor(@"#");
        [self.luckImgView setImage:[UIImage imageNamed:@"worstIcon"]];
    } else {
        self.bestLuckLab.hidden = YES;
        self.luckImgView.hidden = YES;
    }
    
    self.leiImgView.hidden = !model.bombFlag;
    self.bankerLab.hidden = !model.banker;
    switch (type) {
        case GroupTemplate_N02_NiuNiu:
        case GroupTemplate_N04_RobNiuNiu:
        case GroupTemplate_N08_ErRenNiuNiu:{//牛牛
            self.cowLab.hidden = NO;
            self.cowImgView.hidden = NO;
            self.cowLab.text = model.scoreStr;
            [self.cowImgView setImage:[UIImage imageNamed:[self getNiuNiuNum:model.score]]];
        }
            break;
        case GroupTemplate_N05_ErBaGang:///二八杠
        {
            self.cowLab.hidden = NO;
            self.cowImgView.hidden = NO;
            self.cowLab.text = model.scoreStr;
            [self.cowImgView setImage:[UIImage imageNamed:[self getErBaGangScore:model.score]]];
        }
            break;
        case GroupTemplate_N06_LongHuDou:///龙虎和
        {
            self.cowImgView.hidden = NO;
            [self.cowImgView setImage:[UIImage imageNamed:[self getDragonAndTiger:model.score]]];
        }
            break;
        default:
            break;
    }
}

///龙虎和
- (NSString *)getDragonAndTiger:(int)score
{
    switch (score) {
        case 0://龙
            return @"dragonIcon";
            break;
        case 1://虎
            return @"tigerIcon";
            break;
        case 2://和
            return @"andValueIcon";
            break;
        default:
            return @"";
            break;
    }
}

- (NSString *)getErBaGangScore:(int)score
{
    switch (score) {
        case 0:
            return @"erbaIcon_0";
            break;
        case 1:
            return @"erbaIcon_1";
            break;
        case 2:
            return @"erbaIcon_2";
            break;
        case 3:
            return @"erbaIcon_3";
            break;
        case 4:
            return @"erbaIcon_4";
            break;
        case 5:
            return @"erbaIcon_5";
            break;
        case 6:
            return @"erbaIcon_6";
            break;
        case 7:
            return @"erbaIcon_7";
            break;
        case 8:
            return @"erbaIcon_8";
            break;
        case 9:
            return @"erbaIcon_9";
            break;
        default:
            return @"erbaIcon_p";
            break;
    }
}

///牛牛图片
- (NSString *)getNiuNiuNum:(int)score
{
    switch (score) {
        case 0:
            return @"cow_0";
            break;
        case 1:
            return @"cow_1";
            break;
        case 2:
            return @"cow_2";
            break;
        case 3:
            return @"cow_3";
            break;
        case 4:
            return @"cow_4";
            break;
        case 5:
            return @"cow_5";
            break;
        case 6:
            return @"cow_6";
            break;
        case 7:
            return @"cow_7";
            break;
        case 8:
            return @"cow_8";
            break;
        case 9:
            return @"cow_9";
            break;
        default:
            return @"cow_10";
            break;
    }
}

@end
