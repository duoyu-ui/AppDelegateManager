//
//  FYLanguageModel.m
//  ProjectCSHB
//
//  Created by Tom on 2020/7/31.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "FYLanguageModel.h"

@implementation FYLanguageModel
+ (NSString *)palyLanguageConfigType:(GroupTemplateType)type{
    NSString *ruleUrl = [NSString string];
    NSString *code = [NSString string];
    if ([[NSBundle currentLanguage] hasPrefix:@"en"]) {//英语
        code = @"en_US";
    }else{
        code = @"zh_CN";
    }
    switch (type) {
        case GroupTemplate_N01_Bomb://扫雷
            ruleUrl = @"dist/#/saolei?code=";
            break;
        case GroupTemplate_N02_NiuNiu://牛牛
            ruleUrl = @"dist/#/niuniu?code=";
            break;
        case GroupTemplate_N03_JingQiang://禁抢
            ruleUrl = @"dist/#/jinqiang?code=";
            break;
        case GroupTemplate_N04_RobNiuNiu://抢庄牛牛
            ruleUrl = @"dist/#/niuniubanker?code=";
            break;
        case GroupTemplate_N05_ErBaGang://二八杠
            ruleUrl = @"dist/#/twoBars?code=";
            break;
        case GroupTemplate_N06_LongHuDou://龙虎斗
            ruleUrl = @"dist/#/longTiger?code=";
            break;
        case GroupTemplate_N07_JieLong://接龙
            ruleUrl = @"dist/#/jielong?code=";
            break;
        case GroupTemplate_N08_ErRenNiuNiu://二人牛牛
            ruleUrl = @"dist/#/twoniuniu?code=";
            break;
        case GroupTemplate_N09_SuperBobm://超级扫雷
            ruleUrl = @"dist/#/supersaolei?code=";
            break;
        case GroupTemplate_N10_BagLottery://包包彩
            ruleUrl = @"dist/#/baobaocai?code=";
            break;
        case GroupTemplate_N11_BagBagCow://包包牛
            ruleUrl = @"dist/#/baobaoniu?code=";
            break;
        case GroupTemplate_N14_BestNiuNiu://百人牛牛
            ruleUrl = @"dist/#/bainiu?code=";
            break;
        case GroupTemplate_N15_MineClearance:
            ruleUrl = @"dist/#/jisusaolei?code=";
            break;
        default:
            break;
    }
       NSString *url = [NSString stringWithFormat:@"%@%@%@",[AppModel shareInstance].address,ruleUrl,code];
    return url;
}
@end
