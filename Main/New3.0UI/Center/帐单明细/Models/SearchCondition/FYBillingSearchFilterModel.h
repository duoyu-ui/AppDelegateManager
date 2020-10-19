//
//  FYBillingSearchFilterModel.h
//  ProjectCSHB
//
//  Created by fangyuan on 2020/6/21.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "FYDropDownMenuBasedModel.h"
@class FYBillingQueryModle, FYBillingFilterModel;

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, FYBillingFilterButtonType) {
    FYBillingFilterButtonTypeReset = 100, // 重置
    FYBillingFilterButtonTypeConfirm = 101, // 确定
};

typedef NS_ENUM(NSInteger, FYBillingSearchFilterCellType) {
    FYBillingSearchFilterCellItem = 1000,
    FYBillingSearchFilterCellMoney = 1001,
    FYBillingSearchFilterCellButton = 1002,
};

#define STR_BILLING_FILTER_TITLE_MONEY_MINMAX      NSLocalizedString(@"金额", nil)
#define STR_BILLING_FILTER_TITLE_MONEY_MIN         NSLocalizedString(@"最低金额", nil)
#define STR_BILLING_FILTER_TITLE_MONEY_MAX         NSLocalizedString(@"最高金额", nil)
#define STR_BILLING_FILTER_MONEY_MIN_VALUE         @""
#define STR_BILLING_FILTER_MONEY_MAX_VALUE         @""

#define STR_BILLING_FILTER_CLASS_ID_TRANSFER       @"transfer" // 调账记录

// 定义一个菜单的block
typedef void(^FYBillingFilterModelBlock)(FYBillingFilterModel *itemModel);

@interface FYBillingFilterSubModel : NSObject

@property (nonatomic, copy) NSString *uuid;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *parentId;
@property (nonatomic, copy) NSString *imageUrl;

@property (nonatomic, strong) NSNumber *idAuto;
@property (nonatomic, strong) NSNumber *delFlag;
@property (nonatomic, strong) NSNumber *value;

@end

@interface FYBillingFilterModel : NSObject

@property (nonatomic, copy) NSString *uuid;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *parentId;
@property (nonatomic, copy) NSString *imageUrl;
@property (nonatomic, strong) NSNumber *idAuto;
@property (nonatomic, strong) NSNumber *delFlag;
@property (nonatomic, strong) NSNumber *value;
@property (nonatomic, strong) NSArray<FYBillingFilterSubModel *> *items;

@property (nonatomic, assign) BOOL isSelected;
@property (nonatomic, copy) FYBillingFilterModelBlock didSelectedBlock;

@property (nonatomic, copy) NSString *minMoney;
@property (nonatomic, copy) NSString *maxMoney;
@property (nonatomic, assign) FYBillingFilterButtonType buttonType;

+ (NSMutableArray<FYBillingFilterModel *> *) buildingDataModlesOfMoney;
+ (NSMutableArray<FYBillingFilterModel *> *) buildingDataModlesOfButton;
//
+ (NSMutableArray<FYBillingFilterModel *> *) buildingDataModlesOfTransfer:(NSMutableArray<FYBillingFilterModel *> *)filterItems; // 调账记录

@end


@interface FYBillingSearchFilterModel : FYDropDownMenuBasedModel

@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) BOOL isShowTitle;
@property (nonatomic, assign) FYBillingSearchFilterCellType cellType;
@property (nonatomic, strong) NSArray<FYBillingFilterModel *> *items;

+ (NSMutableArray<FYBillingSearchFilterModel *> *) buildingDataModles:(NSArray<FYBillingQueryModle *> *)arrayOfBillQueryModels
                                                       selectClassIds:(NSArray<NSString *> *)classIds;

@end


NS_ASSUME_NONNULL_END
