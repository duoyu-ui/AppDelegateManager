//
//  FYGamesBannerModel.m
//  ProjectCSHB
//
//  Created by fangyuan on 2020/5/15.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "FYGamesBannerModel.h"

@implementation FYGamesBannerModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{
             @"uuid" : @"id",
             @"title" : @"name",
             @"imageUrl" : @"advPicUrl"
             };
}

+ (NSMutableArray<FYGamesBannerModel *> *) buildingDataModles
{
    NSMutableArray<FYGamesBannerModel *> *models = [NSMutableArray array];
    {
        NSArray *titles = @[ NSLocalizedString(@"循环广告1", nil),
                             NSLocalizedString(@"循环广告2", nil),
                             NSLocalizedString(@"循环广告3", nil),
                             NSLocalizedString(@"循环广告4", nil) ];
        NSArray *images = @[ @"icon_banner_01",
                             @"icon_banner_02",
                             @"icon_banner_03",
                             @"icon_banner_04" ];
        for (int index = 0; index < titles.count; index ++) {
            FYGamesBannerModel *model = [[FYGamesBannerModel alloc] init];
            [model setTitle:titles[index]];
            [model setImageUrl:images[index]];
            [models addObject:model];
        }
    }
    
    return models;
}

@end
