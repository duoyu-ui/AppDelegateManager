//
//  FYBillingSearchClassModel.m
//  ProjectCSHB
//
//  Created by fangyuan on 2020/6/21.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "FYBillingQueryModle.h"
#import "FYBillingSearchClassModel.h"
#import "FYBillingSearchClassCell.h"


@implementation FYBillingClassModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{
             @"uuid" : @"id",
             @"title" : @"label",
             @"imageUrl" : @"linkUrl"
             };
}

+ (NSMutableArray<FYBillingClassModel *> *) buildingDataModlesOfAll
{
    NSMutableArray<FYBillingClassModel *> *models = [NSMutableArray array];
    {
        NSArray<NSString *> *uuids = @[ STR_BILLING_CALSS_ALL_UUID ];
        NSArray<NSString *> *titles = @[ STR_BILLING_CALSS_ALL_TITLE ];
        NSArray<NSString *> *imageUrls = @[ @"icon_billclass_all" ];
        for (NSInteger index = 0; index < titles.count; index ++) {
            FYBillingClassModel *model = [[FYBillingClassModel alloc] init];
            [model setIsSelected:NO];
            [model setUuid:uuids[index]];
            [model setTitle:titles[index]];
            [model setImageUrl:imageUrls[index]];
            [models addObject:model];
        }
    }
    return models;
}

@end


@implementation FYBillingSearchClassModel

+ (NSMutableArray<FYBillingSearchClassModel *> *) buildingDataModles:(NSArray<FYBillingQueryModle *> *)arrayOfBillQueryModels
{
    __block NSMutableArray<FYBillingSearchClassModel *> *models = [NSMutableArray array];
    
    // 全部
    {
        FYBillingSearchClassModel *model = [[FYBillingSearchClassModel alloc] init];
        [model setTitle:STR_BILLING_CALSS_ALL_TITLE];
        [model setIsShowTitle:NO];
        [model setCellClassName:NSStringFromClass([FYBillingSearchClassCell class])];
        [model setItems:[FYBillingClassModel buildingDataModlesOfAll]];
        //
        [models addObj:model];
    }

    // 分类
    [arrayOfBillQueryModels enumerateObjectsUsingBlock:^(FYBillingQueryModle * _Nonnull queryModel, NSUInteger idx, BOOL * _Nonnull stop) {
        // 分类二级
        NSArray<NSDictionary *> *arrayOfDicts = [FYBillingQueryClassModle mj_keyValuesArrayWithObjectArray:queryModel.classItems];
        NSMutableArray<FYBillingClassModel *> *itemClassModels = [FYBillingClassModel mj_objectArrayWithKeyValuesArray:arrayOfDicts];
        // 分类一级
        FYBillingSearchClassModel *model = [[FYBillingSearchClassModel alloc] init];
        [model setTitle:queryModel.title];
        [model setIsShowTitle:YES];
        [model setItems:itemClassModels];
        [model setCellClassName:NSStringFromClass([FYBillingSearchClassCell class])];
        //
        [models addObj:model];
    }];
    
    return models;
}

+ (NSMutableArray<NSString *> *) getClassTitlesByClassIds:(NSArray<NSString *> *)classIds dataModles:(NSArray<FYBillingQueryModle *> *)arrayOfBillQueryModels
{
    __block NSMutableArray<NSString *> *classTitles = [NSMutableArray array];
    
    [arrayOfBillQueryModels enumerateObjectsUsingBlock:^(FYBillingQueryModle * _Nonnull queryModel, NSUInteger idx, BOOL * _Nonnull stop) {
        [queryModel.classItems enumerateObjectsUsingBlock:^(FYBillingQueryClassModle * _Nonnull queryClassModel, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([classIds containsObject:queryClassModel.uuid]) {
                [classTitles addObj:[NSString stringWithFormat:@"%@", queryClassModel.title]];
            }
        }];
    }];
    
    return classTitles;
}

+ (NSMutableArray<NSString *> *) getQueryInfoIdsByClassIds:(NSArray<NSString *> *)classIds dataModles:(NSArray<FYBillingQueryModle *> *)arrayOfBillQueryModels
{
    __block NSMutableArray<NSString *> *queryInfoIds = [NSMutableArray array];
    
    [arrayOfBillQueryModels enumerateObjectsUsingBlock:^(FYBillingQueryModle * _Nonnull queryModel, NSUInteger idx, BOOL * _Nonnull stop) {
        [queryModel.classItems enumerateObjectsUsingBlock:^(FYBillingQueryClassModle * _Nonnull queryClassModel, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([classIds containsObject:queryClassModel.uuid]) {
                [queryClassModel.filterItems enumerateObjectsUsingBlock:^(FYBillingQueryFilterModle * _Nonnull queryFilterModel, NSUInteger idx, BOOL * _Nonnull stop) {
                    // 如果筛选有下级，则取下一级的 idAuto，否则直接取筛选 idAuto
                    if (!queryFilterModel || queryFilterModel.subItems.count <= 0) {
                        [queryInfoIds addObj:[NSString stringWithFormat:@"%@", queryFilterModel.idAuto]];
                    } else {
                        [queryFilterModel.subItems enumerateObjectsUsingBlock:^(FYBillingQueryFilterSubModle * _Nonnull queryFilterSubModel, NSUInteger idx, BOOL * _Nonnull stop) {
                            [queryInfoIds addObj:[NSString stringWithFormat:@"%@", queryFilterSubModel.idAuto]];
                        }];
                    }
                }];
            }
        }];
    }];
    
    return queryInfoIds;
}

@end

