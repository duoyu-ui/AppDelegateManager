//
//  FYDatePickerHeaderView.h
//  ProjectCSHB
//
//  Created by fangyuan on 2020/6/27.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FYArrowUpDownButton.h"
#import "FYDatePickerViewController.h"

NS_ASSUME_NONNULL_BEGIN

#define kFyDatePickerHeaderButtonTitleYesday NSLocalizedString(@"昨日", nil)
#define kFyDatePickerHeaderButtonTitleToday NSLocalizedString(@"今日", nil)
#define kFyDatePickerHeaderButtonTitleWeek NSLocalizedString(@"本周", nil)
#define kFyDatePickerHeaderButtonTitleMonth NSLocalizedString(@"本月", nil)

/// 初始化标题 或 更改时间
static NSString * const kNotificationDatePickerInitButtonTitleOrChangeDateTimeAction = @"kNotificationDatePickerInitButtonTitleOrChangeDateTimeAction";

@protocol FYDatePickerHeaderViewDelegate <NSObject>
@optional
// 选择时间后刷新数据
- (void)doRefreshDatePickerTimeType:(FYDatePickerTimeType)datePickerTimeType
                datePickerYearMonth:(NSString *)datePickerYearMonth
                datePickerStartTime:(NSString *)datePickerStartTime
                  datePickerEndTime:(NSString *)datePickerEndTime
                      isNeedRefresh:(BOOL)isNeedRefresh;
// 选择时间按钮标题
- (void)doDatePickerDateTimeButtonTitle:(NSString *)titleString;
- (NSString *)getCurrentDatePickerrButtonTitle;
// 获取已选择时间信息
- (FYDatePickerTimeType)getCurrentDatePickerTimeType;
- (NSString *)getCurrentDatePickerYearMonthTitleFormat;
- (NSString *)getCurrentDatePickerYearMonthContentFormat;
- (NSString *)getCurrentDatePickerStartEndTimeTitleFormat;
- (NSString *)getCurrentDatePickerStartEndTimeContentFormat;
- (NSString *)getCurrentDatePickerYearMonth;
- (NSString *)getCurrentDatePickerStartTime;
- (NSString *)getCurrentDatePickerEndTime;

@end


@interface FYDatePickerHeaderView : UIView
//
@property (nonatomic, strong) UIView *dateTimeContainer; // 时间选择区容器
@property (nonatomic, strong) FYArrowUpDownButton *dateTimeArrowButton; // 时间选择 - 按月选择 or 按日选择
@property (nonatomic, strong) NSMutableArray<UILabel *> *dateTimeBtnLabels; // 时间按钮 - 昨日、今日、本周、本月
@property (nonatomic, strong) NSMutableArray<NSString *> *dateTimeBtnTitles; // 时间按钮 - 昨日、今日、本周、本月
//
@property (nonatomic, weak) UIViewController *parentViewController;
@property (nonatomic, weak) id<FYDatePickerHeaderViewDelegate> delegate;


+ (CGFloat)headerViewHeight;

+ (CGFloat)buttonWidthOfTime;

+ (CGFloat)buttonHeightOfTime;

- (instancetype)initWithFrame:(CGRect)frame delegate:(id<FYDatePickerHeaderViewDelegate>)delegate parentVC:(UIViewController *)parentViewController;

- (void)createViewAtuoLayout;

- (void)createViewDateTimeAtuoLayout;

@end

NS_ASSUME_NONNULL_END

