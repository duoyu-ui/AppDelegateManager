//
//  FYDatePickerHeaderView.m
//  ProjectCSHB
//
//  Created by fangyuan on 2020/6/27.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "FYDatePickerHeaderView.h"

#define FONT_DATEPICKER_HEADER_BUTTON_TITLE_NORMAL          FONT_PINGFANG_REGULAR(14)
#define FONT_DATEPICKER_HEADER_BUTTON_TITLE_SELECT          FONT_PINGFANG_REGULAR(14)
#define COLOR_DATEPICKER_HEADER_BUTTON_TITLE_NORMAL         COLOR_HEXSTRING(@"#6B6B6B")
#define COLOR_DATEPICKER_HEADER_BUTTON_TITLE_SELECT         COLOR_SYSTEM_MAIN_UI_THEME_DEFAULT

#define FONT_DATEPICKER_BUTTON_ARROW_TITLE_NORMAL           FONT_PINGFANG_REGULAR(14)
#define FONT_DATEPICKER_BUTTON_ARROW_TITLE_SELECT           FONT_PINGFANG_REGULAR(14)
#define COLOR_DATEPICKER_BUTTON_ARROW_TITLE_NORMAL          COLOR_SYSTEM_MAIN_FONT_DEFAULT
#define COLOR_DATEPICKER_BUTTON_ARROW_TITLE_SELECT          COLOR_SYSTEM_MAIN_UI_THEME_DEFAULT

CGFloat const kFyDatePickerHeaderDateTimeAreaHeight = 45.0f; // 时间区域高度

@interface FYDatePickerHeaderView ()

@end

@implementation FYDatePickerHeaderView

#pragma mark - Life Cycle

+ (CGFloat)headerViewHeight
{
    return kFyDatePickerHeaderDateTimeAreaHeight;
}

/// 右侧按钮宽度
+ (CGFloat)buttonWidthOfTime
{
    if (SCREEN_MIN_LENGTH <= 375.0f) {
        return 40.0f;
    }
    return 50.0f;
}

/// 右侧按钮高度
+ (CGFloat)buttonHeightOfTime
{
    return 25.0f;
}

/// 右侧按钮间隔
+ (CGFloat)buttonMarginOfTime
{
    CGFloat margin = CFC_AUTOSIZING_MARGIN(MARGIN);
    if (SCREEN_MIN_LENGTH <= 375.0f) {
        return margin*0.35f;
    }
    return margin*0.5f;
}

- (instancetype)initWithFrame:(CGRect)frame delegate:(id<FYDatePickerHeaderViewDelegate>)delegate parentVC:(UIViewController *)parentViewController
{
    self = [super initWithFrame:frame];
    if (self) {
        _delegate = delegate;
        _parentViewController = parentViewController;
        //
        [self addNotifications];
        //
        [self createViewAtuoLayout];
    }
    return self;
}

- (void)createViewAtuoLayout
{
    // 时间容器
    [self addSubview:self.dateTimeContainer];
    [self.dateTimeContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
        make.height.mas_equalTo(kFyDatePickerHeaderDateTimeAreaHeight);
    }];
    
    // 时间控件
    [self createViewDateTimeAtuoLayout];
}

- (void)createViewDateTimeAtuoLayout
{
    CGFloat margin = CFC_AUTOSIZING_MARGIN(MARGIN);
    CGFloat left_right_margin = margin;
    
    // 按钮 - 时间选择
    [self.dateTimeContainer addSubview:self.dateTimeArrowButton];
    [self.dateTimeArrowButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.dateTimeContainer.mas_centerY);
        make.size.mas_equalTo(CGSizeMake([FYArrowUpDownButton defaultWidth], [FYArrowUpDownButton defaultHeight]));
        make.left.equalTo(self.dateTimeContainer.mas_left).offset(left_right_margin);
    }];
    
    // 昨日、今日、本周、本月
    {
        UIFont *btnFontNor = FONT_DATEPICKER_HEADER_BUTTON_TITLE_NORMAL;
        UIColor *btnColorNor = COLOR_DATEPICKER_HEADER_BUTTON_TITLE_NORMAL;
        CGFloat btnItemMargin = [[self class] buttonMarginOfTime];
        CGFloat btnSizeWidth = [[self class] buttonWidthOfTime];
        CGFloat btnSizeHeight = [[self class] buttonHeightOfTime];
        
        UILabel *lastBtnItemLabel = nil;
        _dateTimeBtnLabels = @[].mutableCopy;
        _dateTimeBtnTitles = @[ kFyDatePickerHeaderButtonTitleMonth,
                                kFyDatePickerHeaderButtonTitleWeek,
                                kFyDatePickerHeaderButtonTitleToday,
                                kFyDatePickerHeaderButtonTitleYesday ].mutableCopy;
        for (NSInteger index = 0; index < self.dateTimeBtnTitles.count; index ++) {
            lastBtnItemLabel = ({
                UILabel *label = [UILabel new];
                [self.dateTimeContainer addSubview:label];
                [label setTag:80000+index];
                [label setFont:btnFontNor];
                [label setTextColor:btnColorNor];
                [label setUserInteractionEnabled:YES];
                [label setText:self.dateTimeBtnTitles[index]];
                [label setTextAlignment:NSTextAlignmentCenter];
                [label setBackgroundColor:[UIColor whiteColor]];
                [label addCornerRadius:btnSizeHeight*0.5f];
                
                UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doPressDateTimeButtonLabel:)];
                [label addGestureRecognizer:tapGesture];
                
                [label mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.width.equalTo(@(btnSizeWidth));
                    make.height.equalTo(@(btnSizeHeight));
                    
                    if (!lastBtnItemLabel) {
                        make.centerY.equalTo(self.dateTimeContainer.mas_centerY);
                        make.right.equalTo(self.dateTimeContainer.mas_right).offset(-left_right_margin);
                    } else {
                        make.top.equalTo(lastBtnItemLabel.mas_top);
                        make.right.equalTo(lastBtnItemLabel.mas_left).offset(-btnItemMargin);
                    }
                }];
                
                label;
            });
            lastBtnItemLabel.mas_key = [NSString stringWithFormat:@"btnItemLabel%ld", index];
            
            [_dateTimeBtnLabels addObj:lastBtnItemLabel];
        }
    }
    
    // 时间区域默认设置
    [self createViewDateTimeDefSetting];
}

- (void)createViewDateTimeDefSetting
{
    NSString *titleString = @"";
    if (self.delegate && [self.delegate respondsToSelector:@selector(getCurrentDatePickerrButtonTitle)]) {
        titleString = [self.delegate getCurrentDatePickerrButtonTitle];
    }
    if (VALIDATE_STRING_EMPTY(titleString)) {
        return;
    }
    
    FYDatePickerTimeType currentDatePickerTimeType = FYDatePickerTimeTypeNone;
    if (self.delegate && [self.delegate respondsToSelector:@selector(getCurrentDatePickerTimeType)]) {
        currentDatePickerTimeType = [self.delegate getCurrentDatePickerTimeType];
    }

    NSString *datePickerStartEndTimeTitleFormat = kFYDatePickerFormatYearMonthDay;
    if (self.delegate && [self.delegate respondsToSelector:@selector(getCurrentDatePickerStartEndTimeTitleFormat)]) {
        datePickerStartEndTimeTitleFormat = [self.delegate getCurrentDatePickerStartEndTimeTitleFormat];
    }
    
    NSString *datePickerStartEndTimeContentFormat = datePickerStartEndTimeTitleFormat;
    if (self.delegate && [self.delegate respondsToSelector:@selector(getCurrentDatePickerStartEndTimeContentFormat)]) {
        datePickerStartEndTimeContentFormat = [self.delegate getCurrentDatePickerStartEndTimeContentFormat];
    }
    
    NSString *currentDatePickerStartTime = [[FYDateUtil returnToDay00Clock] stringFromDateWithFormat:datePickerStartEndTimeContentFormat];
    if (self.delegate && [self.delegate respondsToSelector:@selector(getCurrentDatePickerStartTime)]) {
        currentDatePickerStartTime = [self.delegate getCurrentDatePickerStartTime];
    }
    
    NSString *currentDatePickerEndTime = [[FYDateUtil returnToDay24Clock] stringFromDateWithFormat:datePickerStartEndTimeContentFormat];
    if (self.delegate && [self.delegate respondsToSelector:@selector(getCurrentDatePickerEndTime)]) {
        currentDatePickerEndTime = [self.delegate getCurrentDatePickerEndTime];
    }
    
    // 改变按钮标题
    {
        NSNumber *hidden = [NSNumber numberWithBool:NO];
        if (FYDatePickerTimeTypeYearMonth == currentDatePickerTimeType) { // 按月选择
            hidden = [NSNumber numberWithBool:NO];
        } else if (FYDatePickerTimeTypeStartEndTime == currentDatePickerTimeType) { // 按日选择
            NSString *startTitleString = [FYDateUtil dateFormattingWithDateString:currentDatePickerStartTime dateFormate:datePickerStartEndTimeContentFormat toFormate:datePickerStartEndTimeTitleFormat];
            NSString *endTitleString = [FYDateUtil dateFormattingWithDateString:currentDatePickerEndTime dateFormate:datePickerStartEndTimeContentFormat toFormate:datePickerStartEndTimeTitleFormat];
            if ([startTitleString isEqualToString:endTitleString]) {
                hidden = [NSNumber numberWithBool:NO];
            } else {
                hidden = [NSNumber numberWithBool:YES];
            }
        }
        {
            NSDictionary *object = @{
                @"hidden": hidden,
                @"title": titleString,
                @"isAction": [NSNumber numberWithBool:NO] // 初始化操作
            };
            [NOTIF_CENTER postNotificationName:kNotificationDatePickerInitButtonTitleOrChangeDateTimeAction object:object];
        }
    }
}


#pragma mark - Getter & Setter

- (UIView *)dateTimeContainer
{
    if (!_dateTimeContainer) {
        _dateTimeContainer = [[UIView alloc] init];
        [_dateTimeContainer setBackgroundColor:COLOR_TABLEVIEW_BACK_VIEW_BACKGROUND_DEFAULT];
    }
    return _dateTimeContainer;
}

- (FYArrowUpDownButton *)dateTimeArrowButton
{
    if (!_dateTimeArrowButton) {
        CGFloat btnSizeWidth = [FYArrowUpDownButton defaultWidth];
        CGFloat btnSizeHeight = [FYArrowUpDownButton defaultHeight];
        UIFont *btnFontNor = FONT_DATEPICKER_BUTTON_ARROW_TITLE_NORMAL;
        UIFont *btnFontSel = FONT_DATEPICKER_BUTTON_ARROW_TITLE_SELECT;
        UIColor *btnColorNor = COLOR_DATEPICKER_BUTTON_ARROW_TITLE_NORMAL;
        UIColor *btnColorSel = COLOR_DATEPICKER_BUTTON_ARROW_TITLE_SELECT;
        //
        WEAKSELF(weakSelf)
        CGRect frame = CGRectMake(0, 0, btnSizeWidth, btnSizeHeight);
        _dateTimeArrowButton = [[FYArrowUpDownButton alloc] initWithFrame:frame
                                                                    title:kFyDatePickerHeaderButtonTitleMonth
                                                          titleFontNormal:btnFontNor
                                                          titleFontSelect:btnFontSel
                                                         titleColorNormal:btnColorNor
                                                         titleColorSelect:btnColorSel];
        [_dateTimeArrowButton setBackgroundColor:[UIColor whiteColor]];
        [_dateTimeArrowButton addCornerRadius:btnSizeHeight*0.5f];
        [_dateTimeArrowButton setDidClickActionBlock:^{
            [weakSelf doPressDateTimeArrowButtonAction];
        }];
    }
    return _dateTimeArrowButton;
}


#pragma mark - Notification

/// 添加监听通知
- (void)addNotifications
{
    [NOTIF_CENTER addObserver:self selector:@selector(doNotificationInitButtonTitleOrChangeDateTime:) name:kNotificationDatePickerInitButtonTitleOrChangeDateTimeAction object:nil];
}

/// 通知事件处理 -时间变动
- (void)doNotificationInitButtonTitleOrChangeDateTime:(NSNotification *)notification
{
    NSDictionary *object = (NSDictionary *)notification.object;
    
    // 按钮标题
    NSString *titleString = [object stringForKey:@"title"];
    if (!VALIDATE_STRING_EMPTY(titleString)) {
        WEAKSELF(weakSelf);
        dispatch_main_async_safe((^{
            [weakSelf.dateTimeArrowButton setChangeButtonTitleValue:titleString];
        }));
        if (self.delegate && [self.delegate respondsToSelector:@selector(doDatePickerDateTimeButtonTitle:)]) {
            [self.delegate doDatePickerDateTimeButtonTitle:titleString];
        }
        
        BOOL isHidden = [object boolForKey:@"hidden"];
        if (isHidden) {
            // 隐藏左侧按钮
            UILabel *btnMonthLabel = [weakSelf.dateTimeBtnLabels objectAtIndex:0];
            [btnMonthLabel setHidden:YES];
            [btnMonthLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(0.0f);
            }];
            //
            UILabel *btnWeekLabel = [weakSelf.dateTimeBtnLabels objectAtIndex:1];
            [btnWeekLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(btnMonthLabel.mas_left).offset(0.0f);
            }];
        } else {
            // 显示左侧按钮
            CGFloat btnSizeWidth = [[self class] buttonWidthOfTime];
            CGFloat btnItemMargin = [[self class] buttonMarginOfTime];
            
            UILabel *btnMonthLabel = [self.dateTimeBtnLabels objectAtIndex:0];
            [btnMonthLabel setHidden:NO];
            [btnMonthLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(btnSizeWidth);
            }];
            
            UILabel *btnWeekLabel = [self.dateTimeBtnLabels objectAtIndex:1];
            [btnWeekLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(btnMonthLabel.mas_left).offset(-btnItemMargin);
            }];
        }
    }
    
    /// 刷新数据
    BOOL isAction = [object boolForKey:@"isAction"];
    if (isAction) {
        FYDatePickerTimeType datePickerTimeType = [object integerForKey:@"datePickerTimeType"];
        NSString *yearmonth = [object stringForKey:@"yearmonth"];
        NSString *starttime = [object stringForKey:@"starttime"];
        NSString *endtime = [object stringForKey:@"endtime"];
        [self doRefreshWithDatePickerTimeType:datePickerTimeType yearMonth:yearmonth startTime:starttime endTime:endtime];
    }
}

/// 释放资源
- (void)dealloc
{
    [NOTIF_CENTER removeObserver:self];
}


#pragma mark - Private

- (void)doPressDateTimeButtonLabel:(UITapGestureRecognizer *)gesture
{
    UIView *itemView = (UIView*)gesture.view;
    
    NSUInteger index = itemView.tag - 80000;
    
    if (index >= self.dateTimeBtnTitles.count) {
        FYLog(NSLocalizedString(@"数组越界，请检测代码。", nil));
        return;
    }
    
    // 改变按钮标题
    NSString *btnTitle = [self.dateTimeBtnTitles objectAtIndex:index];
    
    // 开始结束时间
    {
        NSDate *dateOfStart = [NSDate new];
        NSDate *dateOfEnd = [NSDate new];
        FYDatePickerTimeType datePickerTimeType = FYDatePickerTimeTypeStartEndTime;
        if ([kFyDatePickerHeaderButtonTitleYesday isEqualToString:btnTitle]) { // 昨日
            NSDate *yesterday =[NSDate yesterday];
            dateOfStart = [FYDateUtil returnDate00Clock:yesterday];
            dateOfEnd = [FYDateUtil returnDate24Clock:yesterday];
            datePickerTimeType = FYDatePickerTimeTypeStartEndTime;
        } else if ([kFyDatePickerHeaderButtonTitleToday isEqualToString:btnTitle]) { // 今日
            NSDate *today =[NSDate today];
            dateOfStart = [FYDateUtil returnDate00Clock:today];
            dateOfEnd = [FYDateUtil returnDate24Clock:today];
            datePickerTimeType = FYDatePickerTimeTypeStartEndTime;
        } else if ([kFyDatePickerHeaderButtonTitleWeek isEqualToString:btnTitle]) { // 本周
            NSDate *today = [NSDate today];
            dateOfStart = [FYDateUtil returnDate00Clock:[FYDateUtil getFirstDateOfWeekFromDate:today]];
            dateOfEnd = [FYDateUtil returnDate24Clock:[FYDateUtil getLastDateOfWeekFromDate:today]];
            datePickerTimeType = FYDatePickerTimeTypeStartEndTime;
        } else if ([kFyDatePickerHeaderButtonTitleMonth isEqualToString:btnTitle]) { // 本月
            NSDate *today = [NSDate today];
            dateOfStart = [FYDateUtil returnDate00Clock:[FYDateUtil getFirstDateOfMonthFromDate:today]];
            dateOfEnd = [FYDateUtil returnDate24Clock:[FYDateUtil getLastDateOfMonthFromDate:today]];
            datePickerTimeType = FYDatePickerTimeTypeYearMonth;
        }
        
        NSString *yearmonth = @"";
        NSString *starttime = @"";
        NSString *endtime = @"";
        if (FYDatePickerTimeTypeYearMonth == datePickerTimeType) { // 按月选择
            NSString *datePickerYearMonthContentFormat = kFYDatePickerFormatYearMonth;
            if (self.delegate && [self.delegate respondsToSelector:@selector(getCurrentDatePickerYearMonthContentFormat)]) {
                datePickerYearMonthContentFormat = [self.delegate getCurrentDatePickerYearMonthContentFormat];
            }
            NSDate *selectDate = [FYDatePickerViewController datePickerSelectDate:dateOfStart
                                                                       dateformat:datePickerYearMonthContentFormat
                                                                     dateTimeType:datePickerTimeType
                                                            isBeginTimeOfStartEnd:NO];
            yearmonth = [selectDate stringFromDateWithFormat:datePickerYearMonthContentFormat];
        } else if (FYDatePickerTimeTypeStartEndTime == datePickerTimeType) { // 按日选择
            NSString *datePickerStartEndTimeContentFormat = kFYDatePickerFormatYearMonthDay;
            if (self.delegate && [self.delegate respondsToSelector:@selector(getCurrentDatePickerStartEndTimeContentFormat)]) {
                datePickerStartEndTimeContentFormat = [self.delegate getCurrentDatePickerStartEndTimeContentFormat];
            }
            NSDate *selectDateOfStart = [FYDatePickerViewController datePickerSelectDate:dateOfStart
                                                                              dateformat:datePickerStartEndTimeContentFormat
                                                                            dateTimeType:datePickerTimeType
                                                                   isBeginTimeOfStartEnd:YES];
            NSDate *selectDateOfEnd = [FYDatePickerViewController datePickerSelectDate:dateOfEnd
                                                                            dateformat:datePickerStartEndTimeContentFormat
                                                                          dateTimeType:datePickerTimeType
                                                                 isBeginTimeOfStartEnd:NO];
            starttime = [selectDateOfStart stringFromDateWithFormat:datePickerStartEndTimeContentFormat];
            endtime = [selectDateOfEnd stringFromDateWithFormat:datePickerStartEndTimeContentFormat];
        }
        
        NSDictionary *object = @{
            @"title": btnTitle,
            @"hidden": [NSNumber numberWithBool:NO],
            @"isAction": [NSNumber numberWithBool:YES],  // 选择时间操作
            @"datePickerTimeType": [NSNumber numberWithInteger:datePickerTimeType],
            @"yearmonth": yearmonth,
            @"starttime": starttime,
            @"endtime": endtime
        };
        [NOTIF_CENTER postNotificationName:kNotificationDatePickerInitButtonTitleOrChangeDateTimeAction object:object];
    }
}

/// 选择时间弹框
- (void)doPressDateTimeArrowButtonAction
{
    FYDatePickerTimeType currentDatePickerTimeType = FYDatePickerTimeTypeNone;
    if (self.delegate && [self.delegate respondsToSelector:@selector(getCurrentDatePickerTimeType)]) {
        currentDatePickerTimeType = [self.delegate getCurrentDatePickerTimeType];
    }
    
    NSString *datePickerYearMonthTitleFormat = kFYDatePickerFormatYearMonth;
    if (self.delegate && [self.delegate respondsToSelector:@selector(getCurrentDatePickerYearMonthTitleFormat)]) {
        datePickerYearMonthTitleFormat = [self.delegate getCurrentDatePickerYearMonthTitleFormat];
    }
    
    NSString *datePickerYearMonthContentFormat = datePickerYearMonthTitleFormat;
    if (self.delegate && [self.delegate respondsToSelector:@selector(getCurrentDatePickerYearMonthContentFormat)]) {
        datePickerYearMonthContentFormat = [self.delegate getCurrentDatePickerYearMonthContentFormat];
    }
    
    NSString *datePickerStartEndTimeTitleFormat = kFYDatePickerFormatYearMonthDay;
    if (self.delegate && [self.delegate respondsToSelector:@selector(getCurrentDatePickerStartEndTimeTitleFormat)]) {
        datePickerStartEndTimeTitleFormat = [self.delegate getCurrentDatePickerStartEndTimeTitleFormat];
    }
    
    NSString *datePickerStartEndTimeContentFormat = datePickerStartEndTimeTitleFormat;
    if (self.delegate && [self.delegate respondsToSelector:@selector(getCurrentDatePickerStartEndTimeContentFormat)]) {
        datePickerStartEndTimeContentFormat = [self.delegate getCurrentDatePickerStartEndTimeContentFormat];
    }
    
    NSString *currentDatePickerYearMonth = [[FYDateUtil returnToDay00Clock] stringFromDateWithFormat:datePickerYearMonthContentFormat];
    if (self.delegate && [self.delegate respondsToSelector:@selector(getCurrentDatePickerYearMonth)]) {
        currentDatePickerYearMonth = [self.delegate getCurrentDatePickerYearMonth];
    }
    
    NSString *currentDatePickerStartTime = [[FYDateUtil returnToDay00Clock] stringFromDateWithFormat:datePickerStartEndTimeContentFormat];
    if (self.delegate && [self.delegate respondsToSelector:@selector(getCurrentDatePickerStartTime)]) {
        currentDatePickerStartTime = [self.delegate getCurrentDatePickerStartTime];
    }
    
    NSString *currentDatePickerEndTime = [[FYDateUtil returnToDay24Clock] stringFromDateWithFormat:datePickerStartEndTimeContentFormat];
    if (self.delegate && [self.delegate respondsToSelector:@selector(getCurrentDatePickerEndTime)]) {
        currentDatePickerEndTime = [self.delegate getCurrentDatePickerEndTime];
    }
    
    // 初始化数据
    WEAKSELF(weakSelf)
    FYDatePickerViewController *alterDatePick =
    [FYDatePickerViewController datePicker:currentDatePickerTimeType
                                 yearMonth:currentDatePickerYearMonth
                      yearMonthTitleFormat:datePickerYearMonthTitleFormat
                    yearMonthContentFormat:datePickerYearMonthContentFormat
                                 startTime:currentDatePickerStartTime
                                   endTime:currentDatePickerEndTime
                   startEndTimeTitleFormat:datePickerStartEndTimeTitleFormat
                 startEndTimeContentFormat:datePickerStartEndTimeContentFormat];
    [alterDatePick setDismissBlock:^{
        [weakSelf.dateTimeArrowButton setChangeButtonIndicatorOpen:NO];
    }];
    [alterDatePick setConfirmActionBlock:^(FYDatePickerTimeType datePickerTimeType, NSString * _Nonnull yearmonth, NSString * _Nonnull yearMonthTitleFormat, NSString * _Nonnull yearMonthContentFormat, NSString * _Nonnull starttime, NSString * _Nonnull endtime, NSString * _Nonnull startEndTimeTitleFormat, NSString * _Nonnull startEndTimeContentFormat) {
        if (FYDatePickerTimeTypeNone != datePickerTimeType) {
            // 改变按钮标题
            {
                NSString *titleString = @"";
                NSNumber *hidden = [NSNumber numberWithBool:NO];
                if (FYDatePickerTimeTypeYearMonth == datePickerTimeType) { // 按月选择
                    titleString = [FYDateUtil dateFormattingWithDateString:yearmonth dateFormate:yearMonthContentFormat toFormate:yearMonthTitleFormat];
                    hidden = [NSNumber numberWithBool:NO];
                } else if (FYDatePickerTimeTypeStartEndTime == datePickerTimeType) { // 按日选择
                    NSString *startTitleString = [FYDateUtil dateFormattingWithDateString:starttime dateFormate:startEndTimeContentFormat toFormate:startEndTimeTitleFormat];
                    NSString *endTitleString = [FYDateUtil dateFormattingWithDateString:endtime dateFormate:startEndTimeContentFormat toFormate:startEndTimeTitleFormat];
                    if ([startTitleString isEqualToString:endTitleString]) {
                        titleString = [NSString stringWithFormat:@"%@", startTitleString];
                        hidden = [NSNumber numberWithBool:NO];
                    } else {
                        titleString = [NSString stringWithFormat:NSLocalizedString(@"%@ 至 %@", nil), startTitleString, endTitleString];
                        hidden = [NSNumber numberWithBool:YES];
                    }
                }
                {
                    NSDictionary *object = @{
                        @"hidden": hidden,
                        @"title": titleString,
                        @"isAction": [NSNumber numberWithBool:YES], // 选择时间操作
                        @"datePickerTimeType": [NSNumber numberWithInteger:datePickerTimeType],
                        @"yearmonth": yearmonth,
                        @"starttime": starttime,
                        @"endtime": endtime
                    };
                    [NOTIF_CENTER postNotificationName:kNotificationDatePickerInitButtonTitleOrChangeDateTimeAction object:object];
                }
            }
        }
    }];
    [self.parentViewController presentViewController:alterDatePick animated:YES completion:nil];
}

- (void)doRefreshWithDatePickerTimeType:(FYDatePickerTimeType)datePickerTimeType yearMonth:(NSString *)yearmonth startTime:(NSString *)starttime endTime:(NSString *)endtime
{
    FYDatePickerTimeType currentDatePickerTimeType = FYDatePickerTimeTypeNone;
    if (self.delegate && [self.delegate respondsToSelector:@selector(getCurrentDatePickerTimeType)]) {
        currentDatePickerTimeType = [self.delegate getCurrentDatePickerTimeType];
    }
    
    NSString *datePickerYearMonthContentFormat = kFYDatePickerFormatYearMonth;
    if (self.delegate && [self.delegate respondsToSelector:@selector(getCurrentDatePickerYearMonthContentFormat)]) {
        datePickerYearMonthContentFormat = [self.delegate getCurrentDatePickerYearMonthContentFormat];
    }
    
    NSString *datePickerStartEndTimeContentFormat = kFYDatePickerFormatYearMonthDay;
    if (self.delegate && [self.delegate respondsToSelector:@selector(getCurrentDatePickerStartEndTimeContentFormat)]) {
        datePickerStartEndTimeContentFormat = [self.delegate getCurrentDatePickerStartEndTimeContentFormat];
    }
    
    NSString *currentDatePickerYearMonth = [[FYDateUtil returnToDay00Clock] stringFromDateWithFormat:datePickerYearMonthContentFormat];
    if (self.delegate && [self.delegate respondsToSelector:@selector(getCurrentDatePickerYearMonth)]) {
        currentDatePickerYearMonth = [self.delegate getCurrentDatePickerYearMonth];
    }
    
    NSString *currentDatePickerStartTime = [[FYDateUtil returnToDay00Clock] stringFromDateWithFormat:datePickerStartEndTimeContentFormat];
    if (self.delegate && [self.delegate respondsToSelector:@selector(getCurrentDatePickerStartTime)]) {
        currentDatePickerStartTime = [self.delegate getCurrentDatePickerStartTime];
    }
    
    NSString *currentDatePickerEndTime = [[FYDateUtil returnToDay24Clock] stringFromDateWithFormat:datePickerStartEndTimeContentFormat];
    if (self.delegate && [self.delegate respondsToSelector:@selector(getCurrentDatePickerEndTime)]) {
        currentDatePickerEndTime = [self.delegate getCurrentDatePickerEndTime];
    }
    
    // 条件是否改变
    BOOL isNeedRefresh = NO;
    if (currentDatePickerTimeType != datePickerTimeType
        || ![currentDatePickerYearMonth isEqualToString:yearmonth]
        || ![currentDatePickerStartTime isEqualToString:starttime]
        || ![currentDatePickerEndTime isEqualToString:endtime]) {
        isNeedRefresh = YES;
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(doRefreshDatePickerTimeType:datePickerYearMonth:datePickerStartTime:datePickerEndTime:isNeedRefresh:)]) {
        [self.delegate doRefreshDatePickerTimeType:datePickerTimeType datePickerYearMonth:yearmonth datePickerStartTime:starttime datePickerEndTime:endtime isNeedRefresh:isNeedRefresh];
    }
}


@end

