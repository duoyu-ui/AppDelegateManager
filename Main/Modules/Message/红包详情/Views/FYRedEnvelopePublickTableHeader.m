//
//  FYRedEnvelopePublickTableHeader.m
//  ProjectCSHB
//
//  Created by fangyuan on 2020/7/23.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "FYRedEnvelopePublickTableHeader.h"
#import "FYRedEnvelopePublickResponse.h"

@implementation FYRedEnvelopePublickTableHeader

/// 刷新红包信息
- (void)refreshWithDetailModel:(FYRedEnvelopePubickDetailModel *)detailModel sumMoney:(CGFloat)sumMoney money:(NSString *)money
{
    if (![detailModel isKindOfClass:[FYRedEnvelopePubickDetailModel class]]) {
        return;
    }
    
    FYRedEnvelopePubickDetailModel *detail = (FYRedEnvelopePubickDetailModel *)detailModel;
    
    if (money.length > 1 ) {
        self.height = [FYRedEnvelopePublickTableHeader headerHeight:self.type] + 30.0f;
        [self.moneyLab mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(40);
        }];
        NSString *absMoney = [NSString stringWithFormat:NSLocalizedString(@"%@元", nil), money];
        NSMutableAttributedString *abs = [[NSMutableAttributedString alloc]initWithString:absMoney];
        [abs addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:13] range:NSMakeRange(absMoney.length - 1, 1)];
        self.moneyLab.attributedText = abs;
        [self layoutIfNeeded];
    }
    
    self.nickLab.text = detail.nick;
    
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
    
    self.overdueTimes = detail.exceptOverdueTimes;
    if (detail.exceptOverdueTimes > 0) {
        self.timeLab.text = [NSString stringWithFormat:NSLocalizedString(@"距离抢包结束: %zd秒", nil), detail.exceptOverdueTimes];
        [self scheduledTimerCountDown];
    } else {
        self.timeLab.text = NSLocalizedString(@"本次红包游戏已截止", nil);
    }
    self.centerLab.text = [NSString stringWithFormat:@"%.2f%@ - %zd%@",detail.money.floatValue,NSLocalizedString(@"元",nil), detail.total,NSLocalizedString(@"包",nil)];
    [self refreshSubViewContent:detail sumMoney:sumMoney];
}

- (void)refreshSubViewContent:(FYRedEnvelopePubickDetailModel *)detail sumMoney:(CGFloat)sumMoney
{
    NSDictionary *dic = [detail.attr mj_JSONObject];
    if (detail.type == GroupTemplate_N06_LongHuDou && detail.exceptOverdueTimes <= 0) {
        self.testimonialsImgView.hidden = NO;
        self.lhhLab.text = detail.bankScoreStr;
    }
    
    switch (detail.type) {
        case GroupTemplate_N00_FuLi:
        case GroupTemplate_N02_NiuNiu:
        case GroupTemplate_N04_RobNiuNiu:
        case GroupTemplate_N05_ErBaGang:
        case GroupTemplate_N06_LongHuDou:
        case GroupTemplate_N07_JieLong:
        case GroupTemplate_N08_ErRenNiuNiu:
            self.leiLab.hidden = YES;
            self.lineView.hidden = YES;
            self.lineView2.hidden = YES;
            break;
        case GroupTemplate_N01_Bomb:
        {
            self.leiLab.hidden = NO;
            self.leiLab.text = NSLocalizedString(@"雷号", nil);
            FYRedEnvelopeLeiNumModel *leiNumModel = [FYRedEnvelopeLeiNumModel mj_objectWithKeyValues:dic];
            UILabel *lab = [self setLeiNumLab];
            lab.text = [NSString stringWithFormat:@"%@",leiNumModel.bombNum];
            [self addSubview:lab];
            [lab mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.height.mas_equalTo(22);
                make.left.mas_equalTo(self.leiLab.mas_right).offset(10);
                make.centerY.equalTo(self.leiLab);
            }];
        }
            break;
        case GroupTemplate_N03_JingQiang:
        case GroupTemplate_N09_SuperBobm:
        {
            self.leiLab.hidden = NO;
            if ([dic[@"type"] integerValue] == 2 && detail.type == GroupTemplate_N03_JingQiang) {
                self.leiLab.text = NSLocalizedString(@"雷号(不中)", nil);
            } else {
                self.leiLab.text = NSLocalizedString(@"雷号", nil);
            }
            NSArray <NSNumber*> *bombList = [NSNumber mj_objectArrayWithKeyValuesArray:dic[@"bombList"]];
            [bombList enumerateObjectsUsingBlock:^(NSNumber * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                UILabel *lab = [self setLeiNumLab];
                lab.text = [NSString stringWithFormat:@"%@",obj];
                [self addSubview:lab];
                [lab mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.width.height.mas_equalTo(22);
                    make.left.mas_equalTo(self.leiLab.mas_right).offset(10 + idx * 27);
                    make.centerY.equalTo(self.leiLab);
                }];
            }];
        }
            break;
        default:
            break;
    }
    
    self.moneyNumLab.text = [NSString stringWithFormat:NSLocalizedString(@"已领取%ld/%ld个, 共%.2f/%.2f元", nil), (detail.total - detail.left), (long)detail.total, sumMoney, detail.money.floatValue];
}

- (UILabel *)setLeiNumLab
{
    UILabel *lab = [[UILabel alloc]init];
    lab.font = [UIFont systemFontOfSize:14];
    lab.layer.masksToBounds = YES;
    lab.layer.cornerRadius = 11;
    lab.backgroundColor = HexColor(@"#CB332D");
    lab.textColor = HexColor(@"#FFFFFF");
    lab.textAlignment = NSTextAlignmentCenter;
    return lab;
}

@end

