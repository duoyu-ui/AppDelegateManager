//
//  FYMoneyRecordModel.m
//  ProjectCSHB
//
//  Created by fangyuan on 2020/5/26.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "FYMoneyRecordModel.h"

@implementation FYMoneyRecordModel

+ (NSMutableArray<FYMoneyRecordModel *> *) buildingDataModles
{
    NSMutableArray<FYMoneyRecordModel *> *models = [NSMutableArray array];
    {
        NSArray *titles = @[ NSLocalizedString(@"充值记录", nil),
                             NSLocalizedString(@"提款记录", nil),
                             NSLocalizedString(@"奖金记录", nil),
                             NSLocalizedString(@"盈亏记录", nil),
                             NSLocalizedString(@"佣金记录", nil),
                             NSLocalizedString(@"敬请期待", nil) ];
        NSArray *imageUrls = @[ @"icon_detail_recharge",
                                @"icon_detail_drawings",
                                @"icon_detail_bonus",
                                @"icon_detail_pl",
                                @"icon_detail_commission",
                                @"icon_detail_coming" ];
        NSArray *categorys = @[ @"recharge",
                                @"withdraw",
                                @"reward",
                                @"win_loss",
                                @"commission_in",
                                @"" ];
        for (int index = 0; index < titles.count; index ++) {
            FYMoneyRecordModel *model = [[FYMoneyRecordModel alloc] init];
            [model setTitle:titles[index]];
            [model setImageUrl:imageUrls[index]];
            [model setCategory:categorys[index]];
            [models addObject:model];
        }
    }
    
    return models;
}

@end
