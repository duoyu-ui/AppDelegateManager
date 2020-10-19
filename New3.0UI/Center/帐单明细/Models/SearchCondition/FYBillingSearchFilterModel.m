//
//  FYBillingSearchFilterModel.m
//  ProjectCSHB
//
//  Created by fangyuan on 2020/6/21.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "FYBillingQueryModle.h"
#import "FYBillingSearchFilterModel.h"
#import "FYBillingSearchFilterCell.h"
#import "FYBillingSearchFilterMoneyCell.h"
#import "FYBillingSearchFilterButtonCell.h"

@implementation FYBillingFilterSubModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{
             @"uuid" : @"id",
             @"title" : @"label",
             @"imageUrl" : @"linkUrl"
             };
}

@end

@implementation FYBillingFilterModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{
             @"uuid" : @"id",
             @"title" : @"label",
             @"imageUrl" : @"linkUrl",
             @"items" : @"children"
             };
}

+ (NSDictionary *)mj_objectClassInArray
{
    return @{
        @"items" : @"FYBillingFilterSubModel"
    };
}

+ (NSMutableArray<FYBillingFilterModel *> *) buildingDataModlesOfMoney
{
    NSMutableArray<FYBillingFilterModel *> *models = [NSMutableArray array];
    {
        NSArray<NSString *> *titles = @[ STR_BILLING_FILTER_TITLE_MONEY_MIN,
                                         STR_BILLING_FILTER_TITLE_MONEY_MAX ];
        for (NSInteger index = 0; index < titles.count; index ++) {
            FYBillingFilterModel *model = [[FYBillingFilterModel alloc] init];
            [model setIsSelected:NO];
            [model setTitle:titles[index]];
            [model setMinMoney:STR_BILLING_FILTER_MONEY_MIN_VALUE];
            [model setMaxMoney:STR_BILLING_FILTER_MONEY_MAX_VALUE];
            [models addObject:model];
        }
    }
    return models;
}

+ (NSMutableArray<FYBillingFilterModel *> *) buildingDataModlesOfButton
{
    NSMutableArray<FYBillingFilterModel *> *models = [NSMutableArray array];
    {
        {
            FYBillingFilterModel *model = [[FYBillingFilterModel alloc] init];
            [model setTitle:NSLocalizedString(@"重置", nil)];
            [model setButtonType:FYBillingFilterButtonTypeReset];
            [models addObject:model];
        }
        {
            FYBillingFilterModel *model = [[FYBillingFilterModel alloc] init];
            [model setTitle:NSLocalizedString(@"确定", nil)];
            [model setButtonType:FYBillingFilterButtonTypeConfirm];
            [models addObject:model];
        }
    }
    return models;
}

/// 调账记录
+ (NSMutableArray<FYBillingFilterModel *> *) buildingDataModlesOfTransfer:(NSMutableArray<FYBillingFilterModel *> *)filterItems
{
    NSMutableArray<FYBillingFilterModel *> *models = [NSMutableArray array];
    if (filterItems.count  > 0) {
        FYBillingFilterModel *filterModel = filterItems.firstObject;
        NSDictionary *filterDict = [filterModel mj_keyValues];
        {
            FYBillingFilterModel *model = [FYBillingFilterModel mj_objectWithKeyValues:filterDict];
            [model setTitle:NSLocalizedString(@"调增", nil)];
            [model setUuid:@"2"]; // 通过 filterIds 来传 adjustmentFlag 值到主页面
            [models addObject:model];
        }
        {
            FYBillingFilterModel *model = [FYBillingFilterModel mj_objectWithKeyValues:filterDict];
            [model setTitle:NSLocalizedString(@"调减", nil)];
            [model setUuid:@"1"]; // 通过 filterIds 来传 adjustmentFlag 值到主页面
            [models addObject:model];
        }
    }
    return models;
}

@end


@implementation FYBillingSearchFilterModel

+ (NSMutableArray<FYBillingSearchFilterModel *> *) buildingDataModles:(NSArray<FYBillingQueryModle *> *)arrayOfBillQueryModels
                                                       selectClassIds:(NSArray<NSString *> *)classIds
{
    __block NSMutableArray<FYBillingSearchFilterModel *> *models = [NSMutableArray array];
    
    // 筛选
    [arrayOfBillQueryModels enumerateObjectsUsingBlock:^(FYBillingQueryModle * _Nonnull queryModel, NSUInteger idx, BOOL * _Nonnull stop) {
        [queryModel.classItems enumerateObjectsUsingBlock:^(FYBillingQueryClassModle * _Nonnull queryClassModel, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([classIds containsObject:queryClassModel.uuid]) {
                // 筛选二级
                NSArray<NSDictionary *> *arrayOfDicts = [FYBillingQueryFilterModle mj_keyValuesArrayWithObjectArray:queryClassModel.filterItems];
                NSMutableArray<FYBillingFilterModel *> *itemFilterModels = [FYBillingFilterModel mj_objectArrayWithKeyValuesArray:arrayOfDicts];
                [itemFilterModels enumerateObjectsUsingBlock:^(FYBillingFilterModel * _Nonnull filterModel, NSUInteger idx, BOOL * _Nonnull stop) {
                    [filterModel setImageUrl:@"icon_billfilter_select_mark"];
                }];
                
                // 调账记录（特殊处理）
                if ([STR_BILLING_FILTER_CLASS_ID_TRANSFER isEqualToString:queryClassModel.uuid]) {
                    itemFilterModels = [FYBillingFilterModel buildingDataModlesOfTransfer:itemFilterModels];
                }
                
                // 筛选一级
                FYBillingSearchFilterModel *model = [[FYBillingSearchFilterModel alloc] init];
                [model setTitle:queryClassModel.title];
                [model setIsShowTitle:YES];
                [model setItems:itemFilterModels];
                [model setCellType:FYBillingSearchFilterCellItem];
                [model setCellClassName:NSStringFromClass([FYBillingSearchFilterCell class])];
                //
                [models addObj:model];
            }
        }];
    }];
    
    // 金额
    {
        FYBillingSearchFilterModel *model = [[FYBillingSearchFilterModel alloc] init];
        [model setTitle:STR_BILLING_FILTER_TITLE_MONEY_MINMAX];
        [model setIsShowTitle:YES];
        [model setCellType:FYBillingSearchFilterCellMoney];
        [model setCellClassName:NSStringFromClass([FYBillingSearchFilterMoneyCell class])];
        [model setItems:[FYBillingFilterModel buildingDataModlesOfMoney]];
        //
        [models addObj:model];
    }
    
    // 按钮
    {
        FYBillingSearchFilterModel *model = [[FYBillingSearchFilterModel alloc] init];
        [model setCellType:FYBillingSearchFilterCellButton];
        [model setCellClassName:NSStringFromClass([FYBillingSearchFilterButtonCell class])];
        [model setItems:[FYBillingFilterModel buildingDataModlesOfButton]];
        //
        [models addObj:model];
    }
    return models;
}


@end

