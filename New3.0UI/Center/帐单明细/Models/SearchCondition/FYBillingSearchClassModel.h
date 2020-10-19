//
//  FYBillingSearchClassModel.h
//  ProjectCSHB
//
//  Created by fangyuan on 2020/6/21.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "FYDropDownMenuBasedModel.h"
@class FYBillingQueryModle, FYBillingClassModel;

NS_ASSUME_NONNULL_BEGIN

#define STR_BILLING_CALSS_ALL_UUID                 @"STR_BILLING_CALSS_ALL_UUID"
#define STR_BILLING_CALSS_ALL_TITLE                NSLocalizedString(@"全部", nil)

// 定义一个菜单的block
typedef void(^FYBillingClassModelBlock)(FYBillingClassModel *itemModel);


@interface FYBillingClassModel : NSObject

@property (nonatomic, copy) NSString *uuid;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *parentId;
@property (nonatomic, copy) NSString *imageUrl;
@property (nonatomic, strong) NSNumber *idAuto;
@property (nonatomic, strong) NSNumber *delFlag;
@property (nonatomic, strong) NSNumber *value;

@property (nonatomic, assign) BOOL isSelected;
@property (nonatomic, copy) FYBillingClassModelBlock didSelectedBlock;

+ (NSMutableArray<FYBillingClassModel *> *) buildingDataModlesOfAll;

@end


@interface FYBillingSearchClassModel : FYDropDownMenuBasedModel

@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) BOOL isShowTitle;
@property (nonatomic, strong) NSArray<FYBillingClassModel *> *items;

+ (NSMutableArray<FYBillingSearchClassModel *> *) buildingDataModles:(NSArray<FYBillingQueryModle *> *)arrayOfBillQueryModels;

+ (NSMutableArray<NSString *> *) getClassTitlesByClassIds:(NSArray<NSString *> *)classIds dataModles:(NSArray<FYBillingQueryModle *> *)arrayOfBillQueryModels;

+ (NSMutableArray<NSString *> *) getQueryInfoIdsByClassIds:(NSArray<NSString *> *)classIds dataModles:(NSArray<FYBillingQueryModle *> *)arrayOfBillQueryModels;

@end

NS_ASSUME_NONNULL_END
