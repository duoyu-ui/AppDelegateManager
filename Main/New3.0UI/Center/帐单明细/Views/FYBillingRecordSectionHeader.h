//
//  FYBillingRecordSectionHeader.h
//  ProjectCSHB
//
//  Created by fangyuan on 2020/6/21.
//  Copyright © 2020 Fangyuan. All rights reserved.
//
// 账单查询条件
//

#import <UIKit/UIKit.h>
#import "FYDatePickerViewController.h"
#import "FYBillingRecordViewController.h"

@class FYBillingQueryModle, FYBillingClassModel, FYBillingFilterModel, FYBillingRecordViewController;

NS_ASSUME_NONNULL_BEGIN

@protocol FYBillingRecordSectionHeaderDelegate <NSObject>
@optional
//
- (void)doRefreshBillingRecordWithClassIds:(NSArray<NSString *> *)classIds
                                 filterIds:(NSArray<NSString *> *)filterIds
                              queryInfoIds:(NSArray<NSString *> *)queryInfoIds;
- (void)doRefreshBillingRecordWithFilterIds:(NSArray<NSString *> *)filterIds
                               queryInfoIds:(NSArray<NSString *> *)queryInfoIds
                              queryMinMoney:(NSString *)queryMinMoney
                              queryMaxMoney:(NSString *)queryMaxMoney;
- (void)doRefreshBillingRecordWithDatePickerTimeType:(FYDatePickerTimeType)datePickerTimeType
                                           queryTime:(NSString *)queryTime
                                      queryStartTime:(NSString *)queryStartTime
                                        queryEndTime:(NSString *)queryEndTime
                                       isNeedRefresh:(BOOL)isNeedRefresh;
//
- (NSArray<NSString *> *)getClassDropDownMenuOfCurrentClassIds;
- (NSArray<NSString *> *)getFilterDropDownMenuOfCurrentFilterIds;
- (NSString *)getFilterDropDownMenuOfCurrentQueryMinMoney;
- (NSString *)getFilterDropDownMenuOfCurrentQueryMaxMoney;
//
- (FYDatePickerTimeType)getCurrentDatePickerTimeType;
- (NSString *)getCurrentDatePickerYearMonthTitleFormat;
- (NSString *)getCurrentDatePickerYearMonthContentFormat;
- (NSString *)getCurrentDatePickerStartEndTimeTitleFormat;
- (NSString *)getCurrentDatePickerStartEndTimeContentFormat;
//
- (NSString *)getCurrentQueryStartTime;
- (NSString *)getCurrentQueryEndTime;
- (NSString *)getCurrentQueryTime;

@end


@interface FYBillingRecordSectionHeader : UIView <FYBillingRecordViewControllerDelegate>

@property (nonatomic, weak) id<FYBillingRecordSectionHeaderDelegate> delegate;

@property (nonatomic, strong) NSArray<FYBillingQueryModle *> *arrayOfBillQueryModels;


+ (CGFloat)headerViewHeight;

- (instancetype)initWithFrame:(CGRect)frame delegate:(id<FYBillingRecordSectionHeaderDelegate>)delegate parentVC:(FYBillingRecordViewController *)parentViewController arrayOfBillQueryModels:(NSArray<FYBillingQueryModle *> *)arrayOfBillQueryModels;

@end

NS_ASSUME_NONNULL_END

