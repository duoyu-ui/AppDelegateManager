//
//  FYPayModeModel.m
//  ProjectCSHB
//
//  Created by fangyuan on 2020/5/18.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "FYPayModeModel.h"

@implementation FYPayBankModel
@end

@implementation FYPayModeTypeModel
@end

@implementation FYPayModeModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{
             @"uuid" : @"id",
             @"imageUrl" : @"img"
             };
}

+ (NSMutableArray<FYPayModeModel *> *) buildingDataModles:(NSMutableArray<FYPayModeModel *> *)itemModels
{
    [itemModels enumerateObjectsUsingBlock:^(FYPayModeModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([CFCSysUtil validateStringEmpty:obj.imageUrl]) {
            // 1官方 2VIP 3三方
            if (STR_RECHARGE_CHANNELPAY_TYPE_OFFICIAL == obj.chanelType.integerValue) {
                [obj setImageUrl:@"icon_official"];
            } else if (STR_RECHARGE_CHANNELPAY_TYPE_VIP == obj.chanelType.integerValue) {
                [obj setImageUrl:@"icon_vip"];
            } else if (STR_RECHARGE_CHANNELPAY_TYPE_THIRD == obj.chanelType.integerValue) {
                [obj setImageUrl:@"icon_commonpay"];
            }
        }
    }];
    return itemModels;
}

+ (NSMutableArray<FYPayModeModel *> *) buildingDataModles1
{
    NSMutableArray<FYPayModeModel *> *models = [NSMutableArray array];
    {
        NSArray *titles = @[ NSLocalizedString(@"QG 官方充值", nil),
                             NSLocalizedString(@"VIP 充值", nil) ];
        NSArray *contents = @[ NSLocalizedString(@"单笔限额10-1000元，权益优先，免手续费", nil),
                               NSLocalizedString(@"V单笔限额10-1000元，专享优惠 海量好礼", nil) ];
        NSArray *imageUrls = @[ @"icon_official",
                                @"icon_vip" ];
        for (int index = 0; index < titles.count; index ++) {
            FYPayModeModel *model = [[FYPayModeModel alloc] init];
            [model setTitle:titles[index]];
            [model setChanelRemarks:contents[index]];
            [model setImageUrl:imageUrls[index]];
            [models addObject:model];
        }
    }
    
    return models;
}

+ (NSMutableArray<FYPayModeModel *> *) buildingDataModles2
{
    NSMutableArray<FYPayModeModel *> *models = [NSMutableArray array];
    {
        NSArray *titles = @[ NSLocalizedString(@"牛牛支付", nil),
                             NSLocalizedString(@"TXH 支付宝", nil),
                             NSLocalizedString(@"麒麟支付", nil),
                             NSLocalizedString(@"钱呗", nil),
                             NSLocalizedString(@"FF 支付", nil) ];
        NSArray *contents = @[ NSLocalizedString(@"单笔限额50-1000元", nil),
                               NSLocalizedString(@"单笔限额50-1000元", nil),
                               NSLocalizedString(@"单笔限额50-1000元", nil),
                               NSLocalizedString(@"单笔限额50-1000元", nil),
                               NSLocalizedString(@"V单笔限额10-1000元", nil) ];
        NSArray *imageUrls = @[ @"icon_nnpay",
                                @"icon_commonpay",
                                @"icon_commonpay",
                                @"icon_commonpay",
                                @"icon_commonpay" ];
        for (int index = 0; index < titles.count; index ++) {
            FYPayModeModel *model = [[FYPayModeModel alloc] init];
            [model setTitle:titles[index]];
            [model setChanelRemarks:contents[index]];
            [model setImageUrl:imageUrls[index]];
            [models addObject:model];
        }
    }
    
    return models;
}


@end
