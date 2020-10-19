//
//  FYDatePickerViewController.m
//  ProjectCSHB
//
//  Created by fangyuan on 2020/6/23.
//  Copyright © 2020 Fangyuan. All rights reserved.
//
// 时间选择器
//

#import "FYDatePickerViewController.h"

#define STR_DATEPICKERTIMETYPE_TITLE_YEARMONTH         NSLocalizedString(@"按月选择", nil)
#define STR_DATEPICKERTIMETYPE_TITLE_STARTENDTIME      NSLocalizedString(@"按日选择", nil)

#define STR_TITLE_YEARMONTH              NSLocalizedString(@"选择月份", nil)
#define STR_TITLE_START                  NSLocalizedString(@"开始时间", nil)
#define STR_TITLE_END                    NSLocalizedString(@"结束时间", nil)

#define STR_DATETIME_MINIMUM_DATE        @"2015-01-01 00:00:00"
#define COLOR_DATEPICKER_SPLITLINE       COLOR_HEXSTRING(@"#B8B8B8")
#define COLOR_TOP_SPLITLINE_NORMAL       COLOR_HEXSTRING(@"#B8B8B8")
#define COLOR_TOP_SPLITLINE_SELECT       COLOR_SYSTEM_MAIN_UI_THEME_DEFAULT


@interface FYDatePickerViewController () <PGDatePickerDelegate>
// 标题分割线高
@property (nonatomic, assign) CGFloat topSplitLineHeight;

// 日期类型区域
@property (nonatomic, strong) UILabel *datePickerTimeTypeLabel;
@property (nonatomic, strong) UIView *datePickerTimeTypeChangeView;
@property (nonatomic, assign) BOOL isYearMonthDatePickerTimeType; // 日期类型选择，当前是否为按月选择类型

// 按月选择类型区域
@property (nonatomic, strong) UIView *containerOfYearMonth;
@property (nonatomic, strong) UILabel *topTitleLabelOfYearMonth;
@property (nonatomic, strong) UIView *topSplitLineOfYearMonth;
@property (nonatomic, strong) PGDatePicker *datePickerOfYearMonth;

// 按日选择类型区域
@property (nonatomic, strong) UIView *containerOfStartEnd;
@property (nonatomic, strong) UILabel *topBeginTitleLabelOfStartEnd;
@property (nonatomic, strong) UILabel *topFinishTitleLabelOfStartEnd;
@property (nonatomic, strong) UIView *topBeginSplitLineOfStartEnd;
@property (nonatomic, strong) UIView *topFinishSplitLineOfStartEnd;
@property (nonatomic, strong) PGDatePicker *datePickerOfStartEnd;
@property (nonatomic, assign) BOOL isBeginTimeOfStartEnd;

// 当前选中结果
@property (nonatomic, assign) FYDatePickerTimeType currentDatePickerTimeType;
@property (nonatomic, copy) NSString *currentYearmonth;
@property (nonatomic, copy) NSString *currentStarttime;
@property (nonatomic, copy) NSString *currentEndtime;

// 初始化结果
@property (nonatomic, assign) FYDatePickerTimeType datePickerTimeType;
@property (nonatomic, copy) NSString *yearmonth;
@property (nonatomic, copy) NSString *starttime;
@property (nonatomic, copy) NSString *endtime;
@property (nonatomic, copy) NSString *yearMonthTitleFormat;
@property (nonatomic, copy) NSString *yearMonthContentFormat;
@property (nonatomic, copy) NSString *startEndTimeTitleFormat;
@property (nonatomic, copy) NSString *startEndTimeContentFormat;

@end


@implementation FYDatePickerViewController


#pragma mark - Actions

- (void)pressNavBarButtonActionCancle:(id)sender
{
    if (self.dismissBlock) {
        self.dismissBlock();
    }
    [self dismissViewControllerAnimated:YES completion:^{
        if (self.cancleActionBlock) {
            self.cancleActionBlock();
        }
    }];
}

- (void)pressNavBarButtonActionConfirm:(id)sender
{
    // 取消删除
    if (FYDatePickerTimeTypeNone == self.currentDatePickerTimeType) {
        
    }
    // 按月选择
    else if (FYDatePickerTimeTypeYearMonth == self.currentDatePickerTimeType) {
        if (VALIDATE_STRING_EMPTY(self.currentYearmonth)) {
            ALTER_INFO_MESSAGE(NSLocalizedString(@"请选择月份", nil))
            return;
        }
    }
    // 按日选择
    else if (FYDatePickerTimeTypeStartEndTime == self.currentDatePickerTimeType) {
        if (VALIDATE_STRING_EMPTY(self.currentStarttime) && VALIDATE_STRING_EMPTY(self.currentEndtime)) {
            ALTER_INFO_MESSAGE(NSLocalizedString(@"请选择日期", nil))
            return;
        }
        if (!VALIDATE_STRING_EMPTY(self.currentStarttime) && !VALIDATE_STRING_EMPTY(self.currentEndtime)) {
            NSInteger res = [FYDateUtil compareDate:self.currentStarttime withDate:self.currentEndtime formate:self.startEndTimeContentFormat];
            if (res < 0) { // 开始日期 > 结束日期
                NSString *tempStarttime = self.currentStarttime;
                self.currentStarttime = self.currentEndtime;
                self.currentEndtime = tempStarttime;
            }
        } else if (!VALIDATE_STRING_EMPTY(self.currentStarttime)) {
            NSDate *dateOfStart = [NSDate dateWithString:self.currentStarttime formatString:self.startEndTimeContentFormat];
            NSDate *dateOfEnd = [FYDateUtil returnDate24Clock:dateOfStart];
            self.currentEndtime = [FYDateUtil dateFormattingWithDate:dateOfEnd toFormate:self.startEndTimeContentFormat];
        } else if (!VALIDATE_STRING_EMPTY(self.currentEndtime)) {
            NSDate *dateOfEnd = [NSDate dateWithString:self.currentEndtime formatString:self.startEndTimeContentFormat];
            NSDate *dateOfStart = [FYDateUtil returnDate00Clock:dateOfEnd];
            self.currentStarttime = [FYDateUtil dateFormattingWithDate:dateOfStart toFormate:self.startEndTimeContentFormat];
        }
    }
    
    if (self.dismissBlock) {
        self.dismissBlock();
    }
    
    WEAKSELF(weakSelf)
    [self dismissViewControllerAnimated:YES completion:^{
        if (self.confirmActionBlock) {
            if (FYDatePickerTimeTypeNone == weakSelf.currentDatePickerTimeType) {
                weakSelf.confirmActionBlock(FYDatePickerTimeTypeNone, @"", weakSelf.yearMonthTitleFormat, weakSelf.yearMonthContentFormat, @"", @"", weakSelf.startEndTimeTitleFormat, weakSelf.startEndTimeContentFormat);
            } else if (FYDatePickerTimeTypeYearMonth == weakSelf.currentDatePickerTimeType) {
                weakSelf.confirmActionBlock(FYDatePickerTimeTypeYearMonth, weakSelf.currentYearmonth,  weakSelf.yearMonthTitleFormat, weakSelf.yearMonthContentFormat, @"", @"", weakSelf.startEndTimeTitleFormat, weakSelf.startEndTimeContentFormat);
            } else if (FYDatePickerTimeTypeStartEndTime == weakSelf.currentDatePickerTimeType) {
                weakSelf.confirmActionBlock(FYDatePickerTimeTypeStartEndTime, @"",  weakSelf.yearMonthTitleFormat, weakSelf.yearMonthContentFormat, weakSelf.currentStarttime, weakSelf.currentEndtime, weakSelf.startEndTimeTitleFormat, weakSelf.startEndTimeContentFormat);
            }
        }
    }];
}


#pragma mark - Life Cycle

+ (instancetype)datePicker:(FYDatePickerTimeType)datePickerTimeType
                 yearMonth:(NSString *)yearMonth
      yearMonthTitleFormat:(NSString *)yearMonthTitleFormat
    yearMonthContentFormat:(NSString *)yearMonthContentFormat
                 startTime:(NSString *)starttime
                   endTime:(NSString *)endtime
   startEndTimeTitleFormat:(NSString *)startEndTimeTitleFormat
 startEndTimeContentFormat:(NSString *)startEndTimeContentFormat
{
    FYDatePickerViewController *instance =
    [[FYDatePickerViewController alloc] initWithDatePickerTimeType:datePickerTimeType
                                                         yearMonth:yearMonth
                                              yearMonthTitleFormat:yearMonthTitleFormat
                                            yearMonthContentFormat:yearMonthContentFormat
                                                         startTime:starttime
                                                           endTime:endtime
                                           startEndTimeTitleFormat:startEndTimeTitleFormat
                                         startEndTimeContentFormat:startEndTimeContentFormat];
    return instance;
}

- (instancetype)initWithDatePickerTimeType:(FYDatePickerTimeType)datePickerTimeType
                                 yearMonth:(NSString *)yearMonth
                      yearMonthTitleFormat:(NSString *)yearMonthTitleFormat
                    yearMonthContentFormat:(NSString *)yearMonthContentFormat
                                 startTime:(NSString *)starttime
                                   endTime:(NSString *)endtime
                   startEndTimeTitleFormat:(NSString *)startEndTimeTitleFormat
                 startEndTimeContentFormat:(NSString *)startEndTimeContentFormat
{
    self = [super init];
    if (self) {
        _yearmonth = yearMonth;
        _starttime = starttime;
        _endtime = endtime;
        _yearMonthTitleFormat = yearMonthTitleFormat;
        _yearMonthContentFormat = yearMonthContentFormat;
        _startEndTimeTitleFormat = startEndTimeTitleFormat;
        _startEndTimeContentFormat = startEndTimeContentFormat;
        _datePickerTimeType = datePickerTimeType;

        _topSplitLineHeight = 1.0f;
        _currentDatePickerTimeType = datePickerTimeType;
        _isBeginTimeOfStartEnd = YES; // 按日选择类型，当前是否为选择开始日期
        _isYearMonthDatePickerTimeType = (FYDatePickerTimeTypeYearMonth == datePickerTimeType) ? YES : NO;
        
        [self setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
        [self setModalPresentationStyle:UIModalPresentationOverFullScreen];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self viewDidLoadOfTimeType];
    [self viewDidLoadOfYearMonth];
    [self viewDidLoadOfStartEndTime];
    [self viewDidLoadDefaultValue];
}

- (void)viewDidLoadOfTimeType
{
    CGFloat margin = CFC_AUTOSIZING_MARGIN(MARGIN);
    CGFloat datePickerTimeTypeHeight = 60.0f;
    CGFloat datePickerTimeTypeButtonHeight = 28.0f;
    CGFloat imageHeight = datePickerTimeTypeButtonHeight * 0.5f;
    CGFloat imageWidth = imageHeight * 1.714285f;
    CGFloat left_right_gap = margin * 1.5f;
    
    // 容器
    [self.view addSubview:self.datePickerTimeTypeChangeView];
    [self.datePickerTimeTypeChangeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.naviStatusBarCustomView.mas_bottom);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(datePickerTimeTypeHeight);
    }];
    
    // 按钮 - 容器
    UIView *datePickerTimeTypeButton = [UIView new];
    [self.datePickerTimeTypeChangeView addSubview:datePickerTimeTypeButton];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pressDatePickerTimeTypeChangeView:)];
    [datePickerTimeTypeButton addGestureRecognizer:tapGesture];
    [datePickerTimeTypeButton setBackgroundColor:COLOR_HEXSTRING(@"#F5F5F5")];
    [datePickerTimeTypeButton addBorderWithColor:COLOR_HEXSTRING(@"#B8B8B8") cornerRadius:datePickerTimeTypeButtonHeight*0.5f andWidth:1.0f];
    [datePickerTimeTypeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.datePickerTimeTypeChangeView.mas_centerY);
        make.left.equalTo(self.datePickerTimeTypeChangeView.mas_left).offset(left_right_gap);
        make.height.mas_equalTo(datePickerTimeTypeButtonHeight);
    }];
    
    // 按钮 - 标题
    [datePickerTimeTypeButton addSubview:self.datePickerTimeTypeLabel];
    [self.datePickerTimeTypeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(datePickerTimeTypeButton.mas_left).offset(margin*1.5f);
        make.top.bottom.equalTo(datePickerTimeTypeButton);
    }];
    
    // 按钮 - 图标
    UIImageView *imageView = [[UIImageView alloc] init];
    [datePickerTimeTypeButton addSubview:imageView];
    [imageView setUserInteractionEnabled:YES];
    [imageView setContentMode:UIViewContentModeScaleAspectFit];
    [imageView setImage:[UIImage imageNamed:@"icon_searchtime_change"]];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.datePickerTimeTypeLabel.mas_right).offset(margin*0.7f);
        make.centerY.equalTo(self.datePickerTimeTypeLabel.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(imageHeight, imageWidth));
    }];
    
    // 按钮宽度
    [datePickerTimeTypeButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(imageView.mas_right).offset(left_right_gap);
    }];
}

- (void)viewDidLoadOfYearMonth
{
    CGFloat margin = CFC_AUTOSIZING_MARGIN(MARGIN);
    CGFloat left_right_gap = margin*1.5f;
    
    // 按月选择
    [self.view addSubview:self.containerOfYearMonth];
    [self.containerOfYearMonth setHidden:!self.isYearMonthDatePickerTimeType];
    [self.containerOfYearMonth mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.datePickerTimeTypeChangeView.mas_bottom).offset(margin*2.0f);
        make.width.equalTo(self.view.mas_width);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    
    // 时间标题
    [self.containerOfYearMonth addSubview:self.topTitleLabelOfYearMonth];
    [self.topTitleLabelOfYearMonth mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.containerOfYearMonth);
        make.left.equalTo(self.containerOfYearMonth.mas_left).offset(left_right_gap);
        make.right.equalTo(self.containerOfYearMonth.mas_right).offset(-left_right_gap);
    }];
    
    // 上分割线
    [self.containerOfYearMonth addSubview:self.topSplitLineOfYearMonth];
    [self.topSplitLineOfYearMonth mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topTitleLabelOfYearMonth.mas_bottom).offset(margin*0.5f);
        make.left.equalTo(self.containerOfYearMonth.mas_left).offset(left_right_gap);
        make.right.equalTo(self.containerOfYearMonth.mas_right).offset(-left_right_gap);
        make.height.mas_equalTo(self.topSplitLineHeight);
    }];
    
    // 清空按钮
    UIImageView *clearBtnOfYearMouth = ({
        CGFloat size = CFC_AUTOSIZING_WIDTH(40.0f);
        UIView *container = [[UIView alloc] init];
        [self.containerOfYearMonth addSubview:container];
        [container mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.topSplitLineOfYearMonth.mas_bottom);
            make.right.equalTo(self.containerOfYearMonth.mas_right);
            make.size.mas_equalTo(CGSizeMake(size, size));
        }];

        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pressClearBtnOfYearMouthView:)];
        [container addGestureRecognizer:tapGesture];
        
        CGFloat imageSizeH = CFC_AUTOSIZING_WIDTH(16.0f);
        CGFloat imageSizeW = imageSizeH*0.894736f;
        CGFloat offset = (size-imageSizeW)*0.5f;
        UIImageView *imageView = [[UIImageView alloc] init];
        [container addSubview:imageView];
        [imageView setUserInteractionEnabled:YES];
        [imageView setImage:[UIImage imageNamed:@"icon_searchtime_clear"]];
        [imageView setContentMode:UIViewContentModeScaleAspectFit];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(container.mas_right).offset(-offset);
            make.centerY.equalTo(container.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(imageSizeW, imageSizeH));
        }];
        
        imageView;
    });
    clearBtnOfYearMouth.mas_key = @"clearBtnOfYearMouth";
    
    // 日期选择
    [self.containerOfYearMonth addSubview:self.datePickerOfYearMonth];
    [self.datePickerOfYearMonth mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.containerOfYearMonth);
        make.top.equalTo(clearBtnOfYearMouth.mas_bottom).offset(margin*1.5f);
        make.width.equalTo(self.containerOfYearMonth.mas_width).multipliedBy(0.9f);
        make.height.equalTo(self.containerOfYearMonth.mas_width).multipliedBy(0.5f);
    }];
    
}

- (void)viewDidLoadOfStartEndTime
{
    CGFloat margin = CFC_AUTOSIZING_MARGIN(MARGIN);
    CGFloat left_right_gap = margin*1.5f;
    
    // 按日选择
    [self.view addSubview:self.containerOfStartEnd];
    [self.containerOfStartEnd setHidden:self.isYearMonthDatePickerTimeType];
    [self.containerOfStartEnd mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.datePickerTimeTypeChangeView.mas_bottom).offset(margin*2.0f);
        make.width.equalTo(self.view.mas_width);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    
    // 中间分割
    UILabel *middleTitleLabel = ({
        UILabel *label = [UILabel new];
        [self.containerOfStartEnd addSubview:label];
        [label setText:NSLocalizedString(@"至", nil)];
        [label setFont:FONT_PINGFANG_REGULAR(16)];
        [label setTextColor:COLOR_SYSTEM_MAIN_FONT_ASSIST_DEFAULT];
        [label setTextAlignment:NSTextAlignmentCenter];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.containerOfStartEnd);
            make.centerX.equalTo(self.containerOfStartEnd.mas_centerX);
        }];
        
        label;
    });
    middleTitleLabel.mas_key = @"middleTitleLabel";
    
    // 按日选择 - 开始时间
    [self.containerOfStartEnd addSubview:self.topBeginTitleLabelOfStartEnd];
    [self.topBeginTitleLabelOfStartEnd mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.containerOfStartEnd);
        make.left.equalTo(self.containerOfStartEnd.mas_left).offset(left_right_gap);
        make.right.equalTo(middleTitleLabel.mas_left).offset(-left_right_gap);
    }];
    
    // 按日选择 - 结束时间
    [self.containerOfStartEnd addSubview:self.topFinishTitleLabelOfStartEnd];
    [self.topFinishTitleLabelOfStartEnd mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.containerOfStartEnd);
        make.left.equalTo(middleTitleLabel.mas_right).offset(left_right_gap);
        make.right.equalTo(self.containerOfStartEnd.mas_right).offset(-left_right_gap);
    }];
    
    // 按日选择 - 开始时间 - 上分割线
    [self.containerOfStartEnd addSubview:self.topBeginSplitLineOfStartEnd];
    [self.topBeginSplitLineOfStartEnd mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topBeginTitleLabelOfStartEnd.mas_bottom).offset(margin*0.5f);
        make.left.equalTo(self.topBeginTitleLabelOfStartEnd.mas_left);
        make.right.equalTo(self.topBeginTitleLabelOfStartEnd.mas_right);
        make.height.mas_equalTo(self.topSplitLineHeight);
    }];
    
    // 按日选择 - 结束时间 - 上分割线
    [self.containerOfStartEnd addSubview:self.topFinishSplitLineOfStartEnd];
    [self.topFinishSplitLineOfStartEnd mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topFinishTitleLabelOfStartEnd.mas_bottom).offset(margin*0.5f);
        make.left.equalTo(self.topFinishTitleLabelOfStartEnd.mas_left);
        make.right.equalTo(self.topFinishTitleLabelOfStartEnd.mas_right);
        make.height.mas_equalTo(self.topSplitLineHeight);
    }];
    
    // 清空按钮
    UIImageView *clearBtnOfYearMouth = ({
        CGFloat size = CFC_AUTOSIZING_WIDTH(40.0f);
        UIView *container = [[UIView alloc] init];
        [self.containerOfStartEnd addSubview:container];
        [container mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.topFinishSplitLineOfStartEnd.mas_bottom);
            make.right.equalTo(self.containerOfStartEnd.mas_right);
            make.size.mas_equalTo(CGSizeMake(size, size));
        }];

        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pressClearBtnOfStartEndView:)];
        [container addGestureRecognizer:tapGesture];
        
        CGFloat imageSizeH = CFC_AUTOSIZING_WIDTH(16.0f);
        CGFloat imageSizeW = imageSizeH*0.894736f;
        CGFloat offset = (size-imageSizeW)*0.5f;
        UIImageView *imageView = [[UIImageView alloc] init];
        [container addSubview:imageView];
        [imageView setUserInteractionEnabled:YES];
        [imageView setImage:[UIImage imageNamed:@"icon_searchtime_clear"]];
        [imageView setContentMode:UIViewContentModeScaleAspectFit];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(container.mas_right).offset(-offset);
            make.centerY.equalTo(container.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(imageSizeW, imageSizeH));
        }];
        
        imageView;
    });
    clearBtnOfYearMouth.mas_key = @"clearBtnOfYearMouth";
    
    // 日期选择
    [self.containerOfStartEnd addSubview:self.datePickerOfStartEnd];
    [self.datePickerOfStartEnd mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.containerOfStartEnd);
        make.top.equalTo(clearBtnOfYearMouth.mas_bottom).offset(margin*1.5f);
        make.width.equalTo(self.containerOfStartEnd.mas_width).multipliedBy(0.9f);
        make.height.equalTo(self.containerOfStartEnd.mas_width).multipliedBy(0.5f);
    }];
}

/// 初始化默认值
- (void)viewDidLoadDefaultValue
{
    // 类型标题
    if (self.isYearMonthDatePickerTimeType) {
        [self.datePickerTimeTypeLabel setText:STR_DATEPICKERTIMETYPE_TITLE_YEARMONTH];
    } else {
        [self.datePickerTimeTypeLabel setText:STR_DATEPICKERTIMETYPE_TITLE_STARTENDTIME];
    }
    
    // 按月选择
    {
        [self setupDatePickerModel:self.datePickerOfYearMonth dateformat:self.yearMonthContentFormat];
        [self setupYearMonthValue];
    }
    
    // 按日选择
    {
        [self setupDatePickerModel:self.datePickerOfStartEnd dateformat:self.startEndTimeContentFormat];
        if (self.isBeginTimeOfStartEnd) {
            NSString *dateBeginString = [[NSDate new] stringFromDateWithFormat:self.startEndTimeContentFormat];
            if (!VALIDATE_STRING_EMPTY(self.starttime)) {
                [self setCurrentStarttime:self.starttime];
                dateBeginString = self.starttime;
            }
            NSDate *dateOfBegin = [NSDate dateFromString:dateBeginString andFormat:self.startEndTimeContentFormat];
            NSString *dateOfBeginTitle = [dateOfBegin stringFromDateWithFormat:self.startEndTimeTitleFormat];
            [self.topBeginTitleLabelOfStartEnd setText:dateOfBeginTitle];
            [self.topBeginTitleLabelOfStartEnd setTextColor:COLOR_SYSTEM_MAIN_UI_THEME_DEFAULT];
            [self.topBeginSplitLineOfStartEnd setBackgroundColor:COLOR_TOP_SPLITLINE_SELECT];
            //
            NSString *dateOfFinishTitle = STR_TITLE_END;
            if (!VALIDATE_STRING_EMPTY(self.endtime)) {
                NSDate *dateOfFinish = [NSDate dateFromString:self.endtime andFormat:self.startEndTimeContentFormat];
                NSString *dateOfFinishString = [dateOfFinish stringFromDateWithFormat:self.startEndTimeTitleFormat];
                if (![dateOfBeginTitle isEqualToString:dateOfFinishString]) {
                    dateOfFinishTitle = dateOfFinishString;
                    [self setCurrentEndtime:self.endtime];
                }
            }
            [self.topFinishTitleLabelOfStartEnd setText:dateOfFinishTitle];
            [self.topFinishTitleLabelOfStartEnd setTextColor:COLOR_SYSTEM_MAIN_FONT_ASSIST_DEFAULT];
            [self.topFinishSplitLineOfStartEnd setBackgroundColor:COLOR_TOP_SPLITLINE_NORMAL];
            //
            [self.datePickerOfStartEnd setHidden:NO];
            [self.datePickerOfStartEnd setDate:dateOfBegin animated:YES];
        } else {
            NSString *dateBeginString = STR_TITLE_START;
            if (!VALIDATE_STRING_EMPTY(self.starttime)) {
                dateBeginString = self.starttime;
                [self setCurrentStarttime:self.starttime];
                NSDate *dateOfBegin = [NSDate dateFromString:dateBeginString andFormat:self.startEndTimeContentFormat];
                [self.topBeginTitleLabelOfStartEnd setText:[dateOfBegin stringFromDateWithFormat:self.startEndTimeTitleFormat]];
            } else {
                [self.topBeginTitleLabelOfStartEnd setText:dateBeginString];
            }
            [self.topBeginTitleLabelOfStartEnd setTextColor:COLOR_SYSTEM_MAIN_FONT_ASSIST_DEFAULT];
            [self.topBeginSplitLineOfStartEnd setBackgroundColor:COLOR_TOP_SPLITLINE_NORMAL];
            //
            NSString *dateFinishString = [[NSDate new] stringFromDateWithFormat:self.startEndTimeContentFormat];
            if (!VALIDATE_STRING_EMPTY(self.endtime)) {
                dateFinishString = self.endtime;
                [self setCurrentEndtime:self.endtime];
            }
            NSDate *dateOfFinish = [NSDate dateFromString:dateFinishString andFormat:self.startEndTimeContentFormat];
            [self.topFinishTitleLabelOfStartEnd setText:[dateOfFinish stringFromDateWithFormat:self.startEndTimeTitleFormat]];
            [self.topFinishTitleLabelOfStartEnd setTextColor:COLOR_SYSTEM_MAIN_UI_THEME_DEFAULT];
            [self.topFinishSplitLineOfStartEnd setBackgroundColor:COLOR_TOP_SPLITLINE_SELECT];
            //
            [self.datePickerOfStartEnd setHidden:NO];
            [self.datePickerOfStartEnd setDate:dateOfFinish animated:YES];
        }
    }
}

/// 初始化按月选择默认值
- (void)setupYearMonthValue
{
    NSString *dateString = [[NSDate new] stringFromDateWithFormat:self.yearMonthContentFormat];
    if (!VALIDATE_STRING_EMPTY(self.yearmonth)) {
        dateString = self.yearmonth;
    }
    NSDate *selectDate = [NSDate dateFromString:dateString andFormat:self.yearMonthContentFormat];
    [self.topTitleLabelOfYearMonth setText:[selectDate stringFromDateWithFormat:self.yearMonthTitleFormat]];
    [self.topTitleLabelOfYearMonth setTextColor:COLOR_SYSTEM_MAIN_UI_THEME_DEFAULT];
    [self.topSplitLineOfYearMonth setBackgroundColor:COLOR_TOP_SPLITLINE_SELECT];
    //
    [self.datePickerOfYearMonth setHidden:NO];
    [self.datePickerOfYearMonth setDate:selectDate animated:YES];
}

/// 初始化按日选择默认值
- (void)setupStartEndTimeValue
{
    // 按日选择 - 开始时间
    if (self.isBeginTimeOfStartEnd) {
        NSString *dateString = [[NSDate new] stringFromDateWithFormat:self.startEndTimeContentFormat];
        if (!VALIDATE_STRING_EMPTY(self.starttime)) {
            dateString = self.starttime;
        }
        if (!VALIDATE_STRING_EMPTY(self.currentStarttime)) {
            dateString = self.currentStarttime;
        }
        NSDate *selectDate = [NSDate dateFromString:dateString andFormat:self.startEndTimeContentFormat];
        NSString *selectDateTitle = [selectDate stringFromDateWithFormat:self.startEndTimeTitleFormat];
        [self.topBeginTitleLabelOfStartEnd setText:selectDateTitle];
        [self.topBeginTitleLabelOfStartEnd setTextColor:COLOR_SYSTEM_MAIN_UI_THEME_DEFAULT];
        [self.topBeginSplitLineOfStartEnd setBackgroundColor:COLOR_TOP_SPLITLINE_SELECT];
        //
        [self.topFinishTitleLabelOfStartEnd setTextColor:COLOR_SYSTEM_MAIN_FONT_ASSIST_DEFAULT];
        [self.topFinishSplitLineOfStartEnd setBackgroundColor:COLOR_TOP_SPLITLINE_NORMAL];
        //
        [self.datePickerOfStartEnd setHidden:NO];
        [self.datePickerOfStartEnd setDate:selectDate animated:YES];
    }
    // 按日选择 - 结束时间
    else {
        NSString *dateString = [[NSDate new] stringFromDateWithFormat:self.startEndTimeContentFormat];
        if (!VALIDATE_STRING_EMPTY(self.endtime)) {
            dateString = self.endtime;
        }
        if (!VALIDATE_STRING_EMPTY(self.currentEndtime)) {
            dateString = self.currentEndtime;
        }
        NSDate *selectDate = [NSDate dateFromString:dateString andFormat:self.startEndTimeContentFormat];
        NSString *selectDateTitle = [selectDate stringFromDateWithFormat:self.startEndTimeTitleFormat];
        [self.topFinishTitleLabelOfStartEnd setText:selectDateTitle];
        [self.topFinishTitleLabelOfStartEnd setTextColor:COLOR_SYSTEM_MAIN_UI_THEME_DEFAULT];
        [self.topFinishSplitLineOfStartEnd setBackgroundColor:COLOR_TOP_SPLITLINE_SELECT];
        //
        [self.topBeginTitleLabelOfStartEnd setTextColor:COLOR_SYSTEM_MAIN_FONT_ASSIST_DEFAULT];
        [self.topBeginSplitLineOfStartEnd setBackgroundColor:COLOR_TOP_SPLITLINE_NORMAL];
        //
        [self.datePickerOfStartEnd setHidden:NO];
        [self.datePickerOfStartEnd setDate:selectDate animated:YES];
    }
}


#pragma mark - PGDatePickerDelegate

- (void)datePicker:(PGDatePicker *)datePicker didSelectDate:(NSDateComponents *)dateComponents
{
    if (80000 == datePicker.tag) { // 按月选择
        NSDate *selectDate = [[self class] datePickerSelectDate:[FYDateUtil getDateWithDateComponents:dateComponents]
                                                     dateformat:self.yearMonthContentFormat
                                                   dateTimeType:FYDatePickerTimeTypeYearMonth
                                          isBeginTimeOfStartEnd:self.isBeginTimeOfStartEnd];
        NSString *yearMonth = [selectDate stringFromDateWithFormat:self.yearMonthContentFormat];
        NSString *yearMonthTitle = [selectDate stringFromDateWithFormat:self.yearMonthTitleFormat];
        [self setCurrentYearmonth:yearMonth];
        [self.topTitleLabelOfYearMonth setText:yearMonthTitle];
    } else if (80001 == datePicker.tag) { // 按日选择
        // 按日选择 - 开始时间
        if (self.isBeginTimeOfStartEnd) {
            NSDate *selectDate = [[self class] datePickerSelectDate:[FYDateUtil getDateWithDateComponents:dateComponents]
                                                         dateformat:self.startEndTimeContentFormat
                                                       dateTimeType:FYDatePickerTimeTypeStartEndTime
                                              isBeginTimeOfStartEnd:self.isBeginTimeOfStartEnd];
            NSString *startTime = [selectDate stringFromDateWithFormat:self.startEndTimeContentFormat];
            NSString *startTimeTitle = [selectDate stringFromDateWithFormat:self.startEndTimeTitleFormat];
            //
            [self setCurrentStarttime:startTime];
            [self.topBeginTitleLabelOfStartEnd setText:startTimeTitle];
        }
        // 按日选择 - 结束时间
        else {
            NSDate *selectDate = [[self class] datePickerSelectDate:[FYDateUtil getDateWithDateComponents:dateComponents]
                                                         dateformat:self.startEndTimeContentFormat
                                                       dateTimeType:FYDatePickerTimeTypeStartEndTime
                                              isBeginTimeOfStartEnd:self.isBeginTimeOfStartEnd];
            NSString *endTime = [selectDate stringFromDateWithFormat:self.startEndTimeContentFormat];
            NSString *endTimeTitle = [selectDate stringFromDateWithFormat:self.startEndTimeTitleFormat];
            //
            [self setCurrentEndtime:endTime];
            [self.topFinishTitleLabelOfStartEnd setText:endTimeTitle];
        }
    }
}


#pragma mark - Navigation

- (CFCNavBarType)preferredNavigationBarType
{
    return CFCNavBarTypeCustom;
}

- (NSString *)prefersNavigationBarTitleViewTitle
{
    return NSLocalizedString(@"选择时间", nil);
}

- (UIView *)createNavigationBarLeftButtonItem
{
    NSString *cancleTile = NSLocalizedString(@"取消", nil);
    NSRange range = NSMakeRange(0, cancleTile.length);
    UIColor *cancleColor = COLOR_SYSTEM_MAIN_UI_THEME_DEFAULT;
    UIButton *buttonCancle = [self createButtonWithTitle:cancleTile
                                                  target:self
                                                  action:@selector(pressNavBarButtonActionCancle:)
                                              offsetType:CFCNavBarButtonOffsetTypeNone];
    [buttonCancle setFrame:CGRectMake(10, 8, 50, 28)];
    NSMutableAttributedString *attributedNormalTitle = [[NSMutableAttributedString alloc] initWithString:cancleTile];
    [attributedNormalTitle addAttribute:NSForegroundColorAttributeName value:cancleColor range:range];
    NSMutableAttributedString *attributedSelectTitle = [[NSMutableAttributedString alloc] initWithString:cancleTile];
    [attributedSelectTitle addAttribute:NSForegroundColorAttributeName value:cancleColor range:range];
    [buttonCancle setAttributedTitle:attributedNormalTitle forState:UIControlStateNormal];
    [buttonCancle setAttributedTitle:attributedSelectTitle forState:UIControlStateHighlighted];
    
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(buttonCancle.frame)+10.0f, NAVIGATION_BAR_HEIGHT)];
    [leftView addSubview:buttonCancle];
    
    return leftView;
}

- (UIView *)createNavigationBarRightButtonItem
{
    NSString *confirmTitle = NSLocalizedString(@"完成", nil);
    NSRange range = NSMakeRange(0, confirmTitle.length);
    UIColor *cancleColor = [UIColor whiteColor];
    UIButton *buttonConfirm = [self createButtonWithTitle:confirmTitle
                                                  target:self
                                                  action:@selector(pressNavBarButtonActionConfirm:)
                                              offsetType:CFCNavBarButtonOffsetTypeNone];
    [buttonConfirm defaultStyleButton];
    [buttonConfirm setFrame:CGRectMake(0, 8, 50, 28)];
    NSMutableAttributedString *attributedNormalTitle = [[NSMutableAttributedString alloc] initWithString:confirmTitle];
    [attributedNormalTitle addAttribute:NSForegroundColorAttributeName value:cancleColor range:range];
    NSMutableAttributedString *attributedSelectTitle = [[NSMutableAttributedString alloc] initWithString:confirmTitle];
    [attributedSelectTitle addAttribute:NSForegroundColorAttributeName value:cancleColor range:range];
    [buttonConfirm setAttributedTitle:attributedNormalTitle forState:UIControlStateNormal];
    [buttonConfirm setAttributedTitle:attributedSelectTitle forState:UIControlStateHighlighted];
    
    UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(buttonConfirm.frame)+10.0f, NAVIGATION_BAR_HEIGHT)];
    [rightView addSubview:buttonConfirm];
    
    return rightView;
}


#pragma mark - Getter & Setter

- (UIView *)datePickerTimeTypeChangeView {
    if (!_datePickerTimeTypeChangeView) {
        _datePickerTimeTypeChangeView = [[UIView alloc] init];
    }
    return _datePickerTimeTypeChangeView;
}

- (UILabel *)datePickerTimeTypeLabel
{
    if (!_datePickerTimeTypeLabel) {
        _datePickerTimeTypeLabel = [[UILabel alloc] init];
        [_datePickerTimeTypeLabel setUserInteractionEnabled:YES];
        [_datePickerTimeTypeLabel setFont:FONT_PINGFANG_SEMI_BOLD(13)];
        [_datePickerTimeTypeLabel setTextAlignment:NSTextAlignmentLeft];
        [_datePickerTimeTypeLabel setTextColor:COLOR_SYSTEM_MAIN_FONT_DEFAULT];
        [_datePickerTimeTypeLabel setText:STR_DATEPICKERTIMETYPE_TITLE_YEARMONTH];
    }
    return _datePickerTimeTypeLabel;
}

#pragma mark -

- (UIView *)containerOfYearMonth {
    if (!_containerOfYearMonth) {
        _containerOfYearMonth = [[UIView alloc] init];
    }
    return _containerOfYearMonth;
}

- (UILabel *)topTitleLabelOfYearMonth
{
    if (!_topTitleLabelOfYearMonth) {
        _topTitleLabelOfYearMonth = [[UILabel alloc] init];
        [_topTitleLabelOfYearMonth setUserInteractionEnabled:YES];
        [_topTitleLabelOfYearMonth setText:STR_TITLE_YEARMONTH];
        [_topTitleLabelOfYearMonth setFont:FONT_PINGFANG_REGULAR(15)];
        [_topTitleLabelOfYearMonth setTextColor:COLOR_SYSTEM_MAIN_FONT_ASSIST_DEFAULT];
        [_topTitleLabelOfYearMonth setTextAlignment:NSTextAlignmentCenter];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pressTopTileLabelOfYearMonth:)];
        [_topTitleLabelOfYearMonth addGestureRecognizer:tapGesture];
    }
    return _topTitleLabelOfYearMonth;
}

- (UIView *)topSplitLineOfYearMonth {
    if (!_topSplitLineOfYearMonth) {
        _topSplitLineOfYearMonth = [[UIView alloc] init];
        [_topSplitLineOfYearMonth setBackgroundColor:COLOR_TOP_SPLITLINE_NORMAL];
    }
    return _topSplitLineOfYearMonth;
}

- (PGDatePicker *)datePickerOfYearMonth
{
    if (!_datePickerOfYearMonth) {
        _datePickerOfYearMonth = [[PGDatePicker alloc] init];
        [_datePickerOfYearMonth setTag:80000];
        [_datePickerOfYearMonth setDelegate:self];
        [_datePickerOfYearMonth setAutoSelected:YES];
        [_datePickerOfYearMonth setIsCycleScroll:NO];
        [_datePickerOfYearMonth setIsHiddenMiddleText:NO];
        [_datePickerOfYearMonth setDatePickerMode:PGDatePickerModeYearAndMonth];
        [_datePickerOfYearMonth setDatePickerType:PGDatePickerTypeLine];
        [_datePickerOfYearMonth setTextColorOfSelectedRow:COLOR_SYSTEM_MAIN_FONT_DEFAULT];
        [_datePickerOfYearMonth setLineBackgroundColor:COLOR_DATEPICKER_SPLITLINE];
        //
        NSDate *minimumDate = [NSDate dateFromString:STR_DATETIME_MINIMUM_DATE andFormat:kNSDateFormatDateFullNormal];
        NSDate *maximumDate = [FYDateUtil returnToDay24Clock];
        [_datePickerOfYearMonth setMinimumDate:minimumDate];
        [_datePickerOfYearMonth setMaximumDate:maximumDate];
    }
    return _datePickerOfYearMonth;
}



#pragma mark -

- (UIView *)containerOfStartEnd {
    if (!_containerOfStartEnd) {
        _containerOfStartEnd = [[UIView alloc] init];
    }
    return _containerOfStartEnd;
}

- (UILabel *)topBeginTitleLabelOfStartEnd
{
    if (!_topBeginTitleLabelOfStartEnd) {
        _topBeginTitleLabelOfStartEnd = [[UILabel alloc] init];
        [_topBeginTitleLabelOfStartEnd setUserInteractionEnabled:YES];
        [_topBeginTitleLabelOfStartEnd setText:STR_TITLE_START];
        [_topBeginTitleLabelOfStartEnd setFont:FONT_PINGFANG_REGULAR(15)];
        [_topBeginTitleLabelOfStartEnd setTextColor:COLOR_SYSTEM_MAIN_FONT_ASSIST_DEFAULT];
        [_topBeginTitleLabelOfStartEnd setTextAlignment:NSTextAlignmentCenter];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pressTopBeginTileLabelOfStartEnd:)];
        [_topBeginTitleLabelOfStartEnd addGestureRecognizer:tapGesture];
    }
    return _topBeginTitleLabelOfStartEnd;
}

- (UILabel *)topFinishTitleLabelOfStartEnd
{
    if (!_topFinishTitleLabelOfStartEnd) {
        _topFinishTitleLabelOfStartEnd = [[UILabel alloc] init];
        [_topFinishTitleLabelOfStartEnd setUserInteractionEnabled:YES];
        [_topFinishTitleLabelOfStartEnd setText:STR_TITLE_END];
        [_topFinishTitleLabelOfStartEnd setFont:FONT_PINGFANG_REGULAR(15)];
        [_topFinishTitleLabelOfStartEnd setTextColor:COLOR_SYSTEM_MAIN_FONT_ASSIST_DEFAULT];
        [_topFinishTitleLabelOfStartEnd setTextAlignment:NSTextAlignmentCenter];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pressTopFinishTileLabelOfStartEnd:)];
        [_topFinishTitleLabelOfStartEnd addGestureRecognizer:tapGesture];
    }
    return _topFinishTitleLabelOfStartEnd;
}

- (UIView *)topBeginSplitLineOfStartEnd {
    if (!_topBeginSplitLineOfStartEnd) {
        _topBeginSplitLineOfStartEnd = [[UIView alloc] init];
        [_topBeginSplitLineOfStartEnd setBackgroundColor:COLOR_TOP_SPLITLINE_NORMAL];
    }
    return _topBeginSplitLineOfStartEnd;
}

- (UIView *)topFinishSplitLineOfStartEnd {
    if (!_topFinishSplitLineOfStartEnd) {
        _topFinishSplitLineOfStartEnd = [[UIView alloc] init];
        [_topFinishSplitLineOfStartEnd setBackgroundColor:COLOR_TOP_SPLITLINE_NORMAL];
    }
    return _topFinishSplitLineOfStartEnd;
}

- (PGDatePicker *)datePickerOfStartEnd
{
    if (!_datePickerOfStartEnd) {
        _datePickerOfStartEnd = [[PGDatePicker alloc] init];
        [_datePickerOfStartEnd setTag:80001];
        [_datePickerOfStartEnd setDelegate:self];
        [_datePickerOfStartEnd setAutoSelected:YES];
        [_datePickerOfStartEnd setIsCycleScroll:NO];
        [_datePickerOfStartEnd setIsHiddenMiddleText:NO];
        [_datePickerOfStartEnd setDatePickerMode:PGDatePickerModeDate];
        [_datePickerOfStartEnd setDatePickerType:PGDatePickerTypeLine];
        [_datePickerOfStartEnd setTextColorOfSelectedRow:COLOR_SYSTEM_MAIN_FONT_DEFAULT];
        [_datePickerOfStartEnd setLineBackgroundColor:COLOR_DATEPICKER_SPLITLINE];
        //
        NSDate *minimumDate = [NSDate dateFromString:STR_DATETIME_MINIMUM_DATE andFormat:kNSDateFormatDateFullNormal];
        NSDate *maximumDate = [FYDateUtil returnToDay24Clock];
        [_datePickerOfStartEnd setMinimumDate:minimumDate];
        [_datePickerOfStartEnd setMaximumDate:maximumDate];
    }
    return _datePickerOfStartEnd;
}


#pragma mark - Priavte

/// 切换查询类型（按月选择 - 按日选择）
- (void)pressDatePickerTimeTypeChangeView:(UITapGestureRecognizer *)gesture
{
    self.isYearMonthDatePickerTimeType = !self.isYearMonthDatePickerTimeType;
    
    // 当前类型
    if (self.isYearMonthDatePickerTimeType) {
        self.currentDatePickerTimeType = FYDatePickerTimeTypeYearMonth;
    } else {
        self.currentDatePickerTimeType = FYDatePickerTimeTypeStartEndTime;
    }
    
    // 按钮标题
    NSString *titleString = self.isYearMonthDatePickerTimeType ? STR_DATEPICKERTIMETYPE_TITLE_YEARMONTH : STR_DATEPICKERTIMETYPE_TITLE_STARTENDTIME;
    [self.datePickerTimeTypeLabel setText:titleString];
    
    // 按月选择
    [self.containerOfYearMonth setHidden:!self.isYearMonthDatePickerTimeType];
    
    // 按日选择
    [self.containerOfStartEnd setHidden:self.isYearMonthDatePickerTimeType];
}

/// 按月选择 - 点击标题
- (void)pressTopTileLabelOfYearMonth:(UITapGestureRecognizer *)gesture
{
    [self setCurrentDatePickerTimeType:FYDatePickerTimeTypeYearMonth];
    //
    [self setupYearMonthValue];
}

/// 按月选择 - 清空操作
- (void)pressClearBtnOfYearMouthView:(UITapGestureRecognizer *)gesture
{
    [self setCurrentDatePickerTimeType:FYDatePickerTimeTypeNone];
    //
    [self.datePickerOfYearMonth setHidden:YES];
    [self.topTitleLabelOfYearMonth setText:STR_TITLE_YEARMONTH];
    [self.topTitleLabelOfYearMonth setTextColor:COLOR_SYSTEM_MAIN_FONT_ASSIST_DEFAULT];
    [self.topSplitLineOfYearMonth setBackgroundColor:COLOR_TOP_SPLITLINE_NORMAL];
}

/// 按日选择 - 开始时间 - 点击标题
- (void)pressTopBeginTileLabelOfStartEnd:(UITapGestureRecognizer *)gesture
{
    [self setCurrentDatePickerTimeType:FYDatePickerTimeTypeStartEndTime];
    //
    [self setIsBeginTimeOfStartEnd:YES];
    [self setupStartEndTimeValue];
}

/// 按日选择 - 结束时间 - 点击标题
- (void)pressTopFinishTileLabelOfStartEnd:(UITapGestureRecognizer *)gesture
{
    [self setCurrentDatePickerTimeType:FYDatePickerTimeTypeStartEndTime];
    //
    [self setIsBeginTimeOfStartEnd:NO];
    [self setupStartEndTimeValue];
}

/// 按日选择 - 清空操作
- (void)pressClearBtnOfStartEndView:(UITapGestureRecognizer *)gesture
{
    [self setCurrentDatePickerTimeType:FYDatePickerTimeTypeNone];
    //
    [self setCurrentEndtime:@""];
    [self setCurrentStarttime:@""];
    [self.datePickerOfStartEnd setHidden:YES];
    [self.topBeginTitleLabelOfStartEnd setText:STR_TITLE_START];
    [self.topBeginTitleLabelOfStartEnd setTextColor:COLOR_SYSTEM_MAIN_FONT_ASSIST_DEFAULT];
    [self.topBeginSplitLineOfStartEnd setBackgroundColor:COLOR_TOP_SPLITLINE_NORMAL];
    [self.topFinishTitleLabelOfStartEnd setText:STR_TITLE_END];
    [self.topFinishTitleLabelOfStartEnd setTextColor:COLOR_SYSTEM_MAIN_FONT_ASSIST_DEFAULT];
    [self.topFinishSplitLineOfStartEnd setBackgroundColor:COLOR_TOP_SPLITLINE_NORMAL];
}

- (void)setupDatePickerModel:(PGDatePicker *)datePicker dateformat:(NSString *)dateformat
{
    if ([kFYDatePickerFormatYear isEqualToString:dateformat]) { // 年
        [datePicker setDatePickerMode:PGDatePickerModeYear];
    } else if ([kFYDatePickerFormatYearAndMonth isEqualToString:dateformat]) { // 年月
        [datePicker setDatePickerMode:PGDatePickerModeYearAndMonth];
    } else if ([kFYDatePickerFormatDate isEqualToString:dateformat]) { // 年月日
        [datePicker setDatePickerMode:PGDatePickerModeDate];
    } else if ([kFYDatePickerFormatDateHour isEqualToString:dateformat]) { // 年月日时
        [datePicker setDatePickerMode:PGDatePickerModeDateHour];
    } else if ([kFYDatePickerFormatDateHourMinute isEqualToString:dateformat]) { // 年月日时分
        [datePicker setDatePickerMode:PGDatePickerModeDateHourMinute];
    } else if ([kFYDatePickerFormatDateHourMinuteSecond isEqualToString:dateformat]) { // 年月日时分秒
        [datePicker setDatePickerMode:PGDatePickerModeDateHourMinuteSecond];
    } else if ([kFYDatePickerFormatMonthDay isEqualToString:dateformat]) { //月日
        [datePicker setDatePickerMode:PGDatePickerModeMonthDay];
    } else if ([kFYDatePickerFormatMonthDayHour isEqualToString:dateformat]) { //月日时
        [datePicker setDatePickerMode:PGDatePickerModeMonthDayHour];
    } else if ([kFYDatePickerFormatMonthDayHourMinute isEqualToString:dateformat]) { //月日时分
        [datePicker setDatePickerMode:PGDatePickerModeMonthDayHourMinute];
    } else if ([kFYDatePickerFormatMonthDayHourMinuteSecond isEqualToString:dateformat]) { //月日时分秒
        [datePicker setDatePickerMode:PGDatePickerModeMonthDayHourMinuteSecond];
    } else if ([kFYDatePickerFormatTime isEqualToString:dateformat]) { //时分
        [datePicker setDatePickerMode:PGDatePickerModeTime];
    } else if ([kFYDatePickerFormatTimeAndSecond isEqualToString:dateformat]) { //时分秒
        [datePicker setDatePickerMode:PGDatePickerModeTimeAndSecond];
    } else if ([kFYDatePickerFormatMinuteAndSecond isEqualToString:dateformat]) { //分秒
        [datePicker setDatePickerMode:PGDatePickerModeMinuteAndSecond];
    } else { // 年月日时分秒
        [datePicker setDatePickerMode:PGDatePickerModeDateHourMinuteSecond];
    }
}

+ (NSDate *)datePickerSelectDate:(NSDate *)date
                      dateformat:(NSString *)dateformat
                    dateTimeType:(FYDatePickerTimeType)datePickerTimeType
           isBeginTimeOfStartEnd:(BOOL)isBeginTimeOfStartEnd
{
    // 按月选择
    if (FYDatePickerTimeTypeYearMonth == datePickerTimeType) {
        if ([kFYDatePickerFormatYear isEqualToString:dateformat]) { // 年
            date = [FYDateUtil returnDate00Clock:date];
        } else if ([kFYDatePickerFormatYearAndMonth isEqualToString:dateformat]) { // 年月
            date = [FYDateUtil returnDate00Clock:date];
        } else if ([kFYDatePickerFormatDate isEqualToString:dateformat]) { // 年月日
            date = [FYDateUtil returnDate00Clock:date];
        } else if ([kFYDatePickerFormatDateHour isEqualToString:dateformat]) { // 年月日时
            date = [FYDateUtil returnDateClock:date hour:YES minute:NO second:NO];
        } else if ([kFYDatePickerFormatDateHourMinute isEqualToString:dateformat]) { // 年月日时分
            date = [FYDateUtil returnDateClock:date hour:YES minute:YES second:NO];
        } else if ([kFYDatePickerFormatDateHourMinuteSecond isEqualToString:dateformat]) { // 年月日时分秒
            date = [FYDateUtil returnDateClock:date hour:YES minute:YES second:YES];
        } else if ([kFYDatePickerFormatMonthDay isEqualToString:dateformat]) { //月日
            date = [FYDateUtil returnDate00Clock:date];
        } else if ([kFYDatePickerFormatMonthDayHour isEqualToString:dateformat]) { //月日时
            date = [FYDateUtil returnDateClock:date hour:YES minute:NO second:NO];
        } else if ([kFYDatePickerFormatMonthDayHourMinute isEqualToString:dateformat]) { //月日时分
            date = [FYDateUtil returnDateClock:date hour:YES minute:YES second:NO];
        } else if ([kFYDatePickerFormatMonthDayHourMinuteSecond isEqualToString:dateformat]) { //月日时分秒
            date = [FYDateUtil returnDateClock:date hour:YES minute:YES second:YES];
        } else if ([kFYDatePickerFormatTime isEqualToString:dateformat]) { //时分
            date = [FYDateUtil returnDateClock:date hour:YES minute:YES second:NO];
        } else if ([kFYDatePickerFormatTimeAndSecond isEqualToString:dateformat]) { //时分秒
            date = [FYDateUtil returnDateClock:date hour:YES minute:YES second:YES];
        } else if ([kFYDatePickerFormatMinuteAndSecond isEqualToString:dateformat]) { //分秒
            date = [FYDateUtil returnDateClock:date hour:NO minute:YES second:YES];
        } else { // 年月日时分秒
            date = [FYDateUtil returnDateClock:date hour:YES minute:YES second:YES];
        }
    }
    // 按日选择
    else if (FYDatePickerTimeTypeStartEndTime == datePickerTimeType) {
        // 按日选择 - 开始时间
        if (isBeginTimeOfStartEnd) {
            if ([kFYDatePickerFormatYear isEqualToString:dateformat]) { // 年
                date = [FYDateUtil returnDate00Clock:date];
            } else if ([kFYDatePickerFormatYearAndMonth isEqualToString:dateformat]) { // 年月
                date = [FYDateUtil returnDate00Clock:date];
            } else if ([kFYDatePickerFormatDate isEqualToString:dateformat]) { // 年月日
                date = [FYDateUtil returnDate00Clock:date];
            } else if ([kFYDatePickerFormatDateHour isEqualToString:dateformat]) { // 年月日时
                date = [FYDateUtil returnDateClock:date hour:YES minute:NO second:NO];
            } else if ([kFYDatePickerFormatDateHourMinute isEqualToString:dateformat]) { // 年月日时分
                date = [FYDateUtil returnDateClock:date hour:YES minute:YES second:NO];
            } else if ([kFYDatePickerFormatDateHourMinuteSecond isEqualToString:dateformat]) { // 年月日时分秒
                date = [FYDateUtil returnDateClock:date hour:YES minute:YES second:YES];
            } else if ([kFYDatePickerFormatMonthDay isEqualToString:dateformat]) { //月日
                date = [FYDateUtil returnDate00Clock:date];
            } else if ([kFYDatePickerFormatMonthDayHour isEqualToString:dateformat]) { //月日时
                date = [FYDateUtil returnDateClock:date hour:YES minute:NO second:NO];
            } else if ([kFYDatePickerFormatMonthDayHourMinute isEqualToString:dateformat]) { //月日时分
                date = [FYDateUtil returnDateClock:date hour:YES minute:YES second:NO];
            } else if ([kFYDatePickerFormatMonthDayHourMinuteSecond isEqualToString:dateformat]) { //月日时分秒
                date = [FYDateUtil returnDateClock:date hour:YES minute:YES second:YES];
            } else if ([kFYDatePickerFormatTime isEqualToString:dateformat]) { //时分
                date = [FYDateUtil returnDateClock:date hour:YES minute:YES second:NO];
            } else if ([kFYDatePickerFormatTimeAndSecond isEqualToString:dateformat]) { //时分秒
                date = [FYDateUtil returnDateClock:date hour:YES minute:YES second:YES];
            } else if ([kFYDatePickerFormatMinuteAndSecond isEqualToString:dateformat]) { //分秒
                date = [FYDateUtil returnDateClock:date hour:NO minute:YES second:YES];
            } else { // 年月日时分秒
                date = [FYDateUtil returnDateClock:date hour:YES minute:YES second:YES];
            }
        }
        // 按日选择 - 结束时间
        else {
            if ([kFYDatePickerFormatYear isEqualToString:dateformat]) { // 年
                date = [FYDateUtil returnDate24Clock:date];
            } else if ([kFYDatePickerFormatYearAndMonth isEqualToString:dateformat]) { // 年月
                date = [FYDateUtil returnDate24Clock:date];
            } else if ([kFYDatePickerFormatDate isEqualToString:dateformat]) { // 年月日
                date = [FYDateUtil returnDate24Clock:date];
            } else if ([kFYDatePickerFormatDateHour isEqualToString:dateformat]) { // 年月日时
                date = [FYDateUtil returnDateClock:date hour:YES minute:NO second:NO];
            } else if ([kFYDatePickerFormatDateHourMinute isEqualToString:dateformat]) { // 年月日时分
                date = [FYDateUtil returnDateClock:date hour:YES minute:YES second:NO];
            } else if ([kFYDatePickerFormatDateHourMinuteSecond isEqualToString:dateformat]) { // 年月日时分秒
                date = [FYDateUtil returnDateClock:date hour:YES minute:YES second:YES];
            } else if ([kFYDatePickerFormatMonthDay isEqualToString:dateformat]) { //月日
                date = [FYDateUtil returnDate24Clock:date];
            } else if ([kFYDatePickerFormatMonthDayHour isEqualToString:dateformat]) { //月日时
                date = [FYDateUtil returnDateClock:date hour:YES minute:NO second:NO];
            } else if ([kFYDatePickerFormatMonthDayHourMinute isEqualToString:dateformat]) { //月日时分
                date = [FYDateUtil returnDateClock:date hour:YES minute:YES second:NO];
            } else if ([kFYDatePickerFormatMonthDayHourMinuteSecond isEqualToString:dateformat]) { //月日时分秒
                date = [FYDateUtil returnDateClock:date hour:YES minute:YES second:YES];
            } else if ([kFYDatePickerFormatTime isEqualToString:dateformat]) { //时分
                date = [FYDateUtil returnDateClock:date hour:YES minute:YES second:NO];
            } else if ([kFYDatePickerFormatTimeAndSecond isEqualToString:dateformat]) { //时分秒
                date = [FYDateUtil returnDateClock:date hour:YES minute:YES second:YES];
            } else if ([kFYDatePickerFormatMinuteAndSecond isEqualToString:dateformat]) { //分秒
                date = [FYDateUtil returnDateClock:date hour:NO minute:YES second:YES];
            } else { // 年月日时分秒
                date = [FYDateUtil returnDateClock:date hour:YES minute:YES second:YES];
            }
        }
    }
    
    return date;
}


@end

