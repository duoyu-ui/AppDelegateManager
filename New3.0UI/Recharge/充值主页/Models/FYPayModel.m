//
//  FYPayModel.m
//  ProjectCSHB
//
//  Created by fangyuan on 2020/5/18.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "FYPayModel.h"

@implementation FYPayModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{
             @"title" : @"name",
             @"imageUrl" : @"img"
             };
}

+ (NSMutableArray<FYPayModel *> *) buildingDataModles:(NSMutableArray<FYPayModel *> *)itemModels
{
    [itemModels enumerateObjectsUsingBlock:^(FYPayModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj setImageUrl:NET_URL_APPENDING(obj.imageUrl)];
        if (STR_RECHARGE_CHANNELPAY_MODE_KEY_WECHAT == obj.type.integerValue) {
            [obj setNormalImages:@"icon_wechatpay_unselect"];
            [obj setSelectedImages:@"icon_wechatpay_select"];
        } else if (STR_RECHARGE_CHANNELPAY_MODE_KEY_ALIPAY == obj.type.integerValue) {
            [obj setNormalImages:@"icon_alipay_unselect"];
            [obj setSelectedImages:@"icon_alipay_select"];
        } else if (STR_RECHARGE_CHANNELPAY_MODE_KEY_BANKCARD == obj.type.integerValue) {
            [obj setNormalImages:@"icon_bankcard_unselect"];
            [obj setSelectedImages:@"icon_bankcard_select"];
        } else if (STR_RECHARGE_CHANNELPAY_MODE_KEY_QQPAY == obj.type.integerValue) {
            [obj setNormalImages:@"icon_qqpay_unselect"];
            [obj setSelectedImages:@"icon_qqpay_select"];
        } else if (STR_RECHARGE_CHANNELPAY_MODE_KEY_JDPAY == obj.type.integerValue) {
            [obj setNormalImages:@"icon_jdpay_unselect"];
            [obj setSelectedImages:@"icon_jdpay_select"];
        } else {
            [obj setNormalImages:obj.imageUrl];
            [obj setSelectedImages:obj.imageUrl];
        }
    }];
    return itemModels;
}

+ (NSMutableArray<FYPayModel *> *) buildingDataModles1:(NSArray<FYPayModel *> *)items
{
    NSMutableArray<FYPayModel *> *models = [NSMutableArray array];
    {
        NSArray *titles = @[ NSLocalizedString(@"微信支付", nil), NSLocalizedString(@"支付宝", nil), NSLocalizedString(@"银行卡", nil), NSLocalizedString(@"QQ支付", nil), NSLocalizedString(@"京东支付", nil)];
        NSArray *normalImages = @[ @"icon_wechatpay_unselect",
                                   @"icon_alipay_unselect",
                                   @"icon_bankcard_unselect",
                                   @"icon_qqpay_unselect",
                                   @"icon_jdpay_unselect" ];
        NSArray *selectedImages = @[ @"icon_wechatpay_select",
                                     @"icon_alipay_select",
                                     @"icon_bankcard_select",
                                     @"icon_qqpay_select",
                                     @"icon_jdpay_select" ];
        for (int index = 0; index < titles.count; index ++) {
            FYPayModel *model = [[FYPayModel alloc] init];
            [model setTitle:titles[index]];
            [model setNormalImages:normalImages[index]];
            [model setSelectedImages:selectedImages[index]];
            [models addObject:model];
        }
    }
    
    return models;
}

@end
