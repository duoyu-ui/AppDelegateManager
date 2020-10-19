//
//  FYBillingRecordSectionHeader.m
//  ProjectCSHB
//
//  Created by fangyuan on 2020/6/21.
//  Copyright © 2020 Fangyuan. All rights reserved.
//
// 账单查询条件
//

#import "FYBillingRecordSectionHeader.h"
#import "FYBillingRecordViewController.h"
#import "FYBillingSearchFilterButtonCell.h"
#import "FYBillingSearchFilterMoneyCell.h"
#import "FYBillingSearchFilterCell.h"
#import "FYBillingSearchClassCell.h"
#import "FYBillingSearchFilterModel.h"
#import "FYBillingSearchClassModel.h"
#import "FYBillingProfitLossModel.h"
#import "FYArrowUpDownButton.h"
#import "FYDropDownMenuView.h"

#define BILLING_SEARCH_BUTTON_TITLE_FONT     [UIFont fontWithName:@"PingFangSC-Regular" size:CFC_AUTOSIZING_FONT(14)]

CGFloat const BILLING_HEADER_HEIGHT_FOR_TOP = 40.0;
CGFloat const BILLING_HEADER_HEIGHT_FOR_BOTTOM = 55.0f;

@interface FYBillingRecordSectionHeader () <FYDropDownMenuViewDelegate>
//
@property (nonatomic, weak) FYBillingRecordViewController *parentViewController;
//
@property (nonnull, nonatomic, strong) UIView *rootTopContainer;
@property (nonnull, nonatomic, strong) UIView *rootBottomContainer;
//
@property (nonatomic, strong) FYArrowUpDownButton *billingClassButton; // 分类
@property (nonatomic, strong) FYDropDownMenuView *billingClassDropDownMenu; // 分类下拉框
//
@property (nonatomic, strong) FYArrowUpDownButton *billingFilterButton; // 筛选
@property (nonatomic, strong) FYDropDownMenuView *billingFilterDropDownMenu; // 筛选下拉框
//
@property (nonatomic, strong) FYArrowUpDownButton *billingDatetimeButton; // 时间
//
@property (nonatomic, strong) UILabel *moneyTotalIncomeLabel; // 收入
@property (nonatomic, strong) UILabel *moneyTotalSpendingLabel; // 支出

@end


@implementation FYBillingRecordSectionHeader


#pragma mark - Life Cycle

+ (CGFloat)headerViewHeight
{
    return BILLING_HEADER_HEIGHT_FOR_TOP + BILLING_HEADER_HEIGHT_FOR_BOTTOM;
}

- (instancetype)initWithFrame:(CGRect)frame delegate:(id<FYBillingRecordSectionHeaderDelegate>)delegate parentVC:(FYBillingRecordViewController *)parentViewController arrayOfBillQueryModels:(NSArray<FYBillingQueryModle *> *)arrayOfBillQueryModels
{
    self = [super initWithFrame:frame];
    if (self) {
        _delegate = delegate;
        _parentViewController = parentViewController;
        _arrayOfBillQueryModels = arrayOfBillQueryModels;
        //
        [self createViewAtuoLayout];
        [self createViewBillingClassDropDownMenu];
        [self createViewBillingFilterDropDownMenu];
    }
    return self;
}

- (void)createViewAtuoLayout
{
    CGFloat margin = CFC_AUTOSIZING_MARGIN(MARGIN);
    CGFloat btnSizeWidth = [FYArrowUpDownButton defaultWidth];
    CGFloat btnSizeHeight = [FYArrowUpDownButton defaultHeight];
    
    // 容器 - 上
    [self addSubview:self.rootTopContainer];
    [self.rootTopContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
        make.height.mas_equalTo(BILLING_HEADER_HEIGHT_FOR_TOP);
    }];
    
    // 容器 - 下
    [self addSubview:self.rootBottomContainer];
    [self.rootBottomContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self);
        make.height.mas_equalTo(BILLING_HEADER_HEIGHT_FOR_BOTTOM);
    }];
    
    // 分类
    [self.rootTopContainer addSubview:self.billingClassButton];
    [self.billingClassButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(btnSizeWidth);
        make.top.equalTo(self.rootTopContainer.mas_top);
        make.left.equalTo(self.rootTopContainer.mas_left);
        make.bottom.equalTo(self.rootTopContainer.mas_bottom);
    }];
    
    // 筛选
    [self.rootTopContainer addSubview:self.billingFilterButton];
    [self.billingFilterButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(btnSizeWidth);
        make.top.equalTo(self.rootTopContainer.mas_top);
        make.left.equalTo(self.billingClassButton.mas_right);
        make.bottom.equalTo(self.rootTopContainer.mas_bottom);
    }];
    
    // 时间
    [self.rootBottomContainer addSubview:self.billingDatetimeButton];
    [self.billingDatetimeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.rootBottomContainer.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(btnSizeWidth, btnSizeHeight));
        make.left.equalTo(self.rootBottomContainer.mas_left).offset(margin*1.0f);
    }];
    
    // 收入
    [self.rootBottomContainer addSubview:self.moneyTotalIncomeLabel];
    [self.moneyTotalIncomeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.rootBottomContainer.mas_centerY);
        make.right.equalTo(self.rootBottomContainer.mas_right).offset(-margin*1.5f);
    }];
    
    // 支出
    [self.rootBottomContainer addSubview:self.moneyTotalSpendingLabel];
    [self.moneyTotalSpendingLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.rootBottomContainer.mas_centerY);
        make.right.equalTo(self.moneyTotalIncomeLabel.mas_right);
    }];
}

- (void)createViewBillingClassDropDownMenu
{
    NSArray<NSString *> *cellClassNames = @[ NSStringFromClass([FYBillingSearchClassCell class]) ];
    self.billingClassDropDownMenu = [FYDropDownMenuView fyDropDownMenuWithSuperView:self.parentViewController.view menuModelsArray:nil menuWidth:SCREEN_WIDTH eachItemHeight:0.0f];
    [self.billingClassDropDownMenu setDelegate:self];
    [self.billingClassDropDownMenu setTriangleY:0.0f];
    [self.billingClassDropDownMenu setIfShouldScroll:NO];
    [self.billingClassDropDownMenu setMenuCornerRadius:0.0f];
    [self.billingClassDropDownMenu setTriangleSize:CGSizeMake(0, 0)];
    [self.billingClassDropDownMenu setMenuAnimateType:FYDropDownMenuViewAnimateType_FallFromTop];
    [self.billingClassDropDownMenu setMenuFrameY:BILLING_HEADER_HEIGHT_FOR_TOP];
    [self.billingClassDropDownMenu setCellClassNames:cellClassNames];
    [self.billingClassDropDownMenu setup];
}

- (void)createViewBillingFilterDropDownMenu
{
    NSArray<NSString *> *cellClassNames = @[
        NSStringFromClass([FYBillingSearchFilterCell class]),
        NSStringFromClass([FYBillingSearchFilterMoneyCell class]),
        NSStringFromClass([FYBillingSearchFilterButtonCell class])
    ];
    self.billingFilterDropDownMenu = [FYDropDownMenuView fyDropDownMenuWithSuperView:self.parentViewController.view menuModelsArray:nil menuWidth:SCREEN_WIDTH eachItemHeight:0.0f];
    [self.billingFilterDropDownMenu setDelegate:self];
    [self.billingFilterDropDownMenu setTriangleY:0.0f];
    [self.billingFilterDropDownMenu setIfShouldScroll:NO];
    [self.billingFilterDropDownMenu setMenuCornerRadius:0.0f];
    [self.billingFilterDropDownMenu setTriangleSize:CGSizeMake(0, 0)];
    [self.billingFilterDropDownMenu setMenuAnimateType:FYDropDownMenuViewAnimateType_FallFromTop];
    [self.billingFilterDropDownMenu setMenuFrameY:BILLING_HEADER_HEIGHT_FOR_TOP];
    [self.billingFilterDropDownMenu setCellClassNames:cellClassNames];
    [self.billingFilterDropDownMenu setup];
}


#pragma mark - FYDropDownMenuViewDelegate

- (void)fyDropDownMenuViewWDidDisappear:(FYDropDownMenuView *)menuView
{
    if (self.billingClassDropDownMenu == menuView) {
        [self.billingClassButton setChangeButtonIndicatorOpen:NO];
    } else if (self.billingFilterDropDownMenu == menuView) {
        [self.billingFilterButton setChangeButtonIndicatorOpen:NO];
    }
}


#pragma mark - FYBillingRecordViewControllerDelegate

- (void)doRefreshSectionHeaderBillingProfitLossModel:(FYBillingProfitLossModel *)billingProfitLossModel
{
    NSString *totalIncome = [NSString stringWithFormat:@"%@ ¥ %.2f",NSLocalizedString(@"收入", nil), fabs(billingProfitLossModel.profitMoney.floatValue)];
    [self.moneyTotalIncomeLabel setText:totalIncome];
    
    NSString *totalSpending = [NSString stringWithFormat:@"%@ ¥ %.2f",NSLocalizedString(@"支出", nil), fabs(billingProfitLossModel.lossMoney.floatValue)];
    [self.moneyTotalSpendingLabel setText:totalSpending];
}

- (void)doRefreshSectionHeaderBillingClassButtonTitle:(NSString *)titleString
{
    if (VALIDATE_STRING_EMPTY(titleString)) {
        return;
    }
    
    [self.billingClassButton setChangeButtonTitleValue:titleString];
}


#pragma mark - Getter & Setter

- (UIView *)rootTopContainer
{
    if (!_rootTopContainer) {
        _rootTopContainer = [[UIView alloc] init];
        [_rootTopContainer setBackgroundColor:[UIColor whiteColor]];
        [_rootTopContainer addBorderWithColor:COLOR_TABLEVIEW_BACK_VIEW_BACKGROUND_DEFAULT cornerRadius:0.0f andWidth:SEPARATOR_LINE_HEIGHT];
    }
    return _rootTopContainer;
}

- (UIView *)rootBottomContainer
{
    if (!_rootBottomContainer) {
        _rootBottomContainer = [[UIView alloc] init];
        [_rootBottomContainer setBackgroundColor:COLOR_TABLEVIEW_BACK_VIEW_BACKGROUND_DEFAULT];
    }
    return _rootBottomContainer;
}

- (UILabel *)moneyTotalIncomeLabel
{
    if (!_moneyTotalIncomeLabel) {
        _moneyTotalIncomeLabel = [[UILabel alloc] init];
        [_moneyTotalIncomeLabel setText:NSLocalizedString(@"收入 ¥ 0.00", nil)];
        [_moneyTotalIncomeLabel setFont:FONT_PINGFANG_REGULAR(13)];
        [_moneyTotalIncomeLabel setTextColor:COLOR_SYSTEM_MAIN_FONT_ASSIST_DEFAULT];
        [_moneyTotalIncomeLabel setTextAlignment:NSTextAlignmentRight];
    }
    return _moneyTotalIncomeLabel;
}

- (UILabel *)moneyTotalSpendingLabel
{
    if (!_moneyTotalSpendingLabel) {
        _moneyTotalSpendingLabel = [[UILabel alloc] init];
        [_moneyTotalSpendingLabel setText:NSLocalizedString(@"支出 ¥ 0.00", nil)];
        [_moneyTotalSpendingLabel setFont:FONT_PINGFANG_REGULAR(13)];
        [_moneyTotalSpendingLabel setTextColor:COLOR_SYSTEM_MAIN_FONT_ASSIST_DEFAULT];
        [_moneyTotalSpendingLabel setTextAlignment:NSTextAlignmentRight];
    }
    return _moneyTotalSpendingLabel;
}

- (FYArrowUpDownButton *)billingClassButton
{
    if (!_billingClassButton) {
        CGFloat btnSizeWidth = [FYArrowUpDownButton defaultWidth];
        CGFloat btnSizeHeight = BILLING_HEADER_HEIGHT_FOR_TOP;
        UIFont *btnFontNor = BILLING_SEARCH_BUTTON_TITLE_FONT;
        UIFont *btnFontSel = BILLING_SEARCH_BUTTON_TITLE_FONT;
        UIColor *btnColorNor = COLOR_SYSTEM_MAIN_FONT_DEFAULT;
        UIColor *btnColorSel = COLOR_SYSTEM_MAIN_UI_THEME_DEFAULT;
        //
        WEAKSELF(weakSelf)
        CGRect frame = CGRectMake(0, 0, btnSizeWidth, btnSizeHeight);
        _billingClassButton = [[FYArrowUpDownButton alloc] initWithFrame:frame
                                                                   title:NSLocalizedString(@"分类", nil)
                                                         titleFontNormal:btnFontNor
                                                         titleFontSelect:btnFontSel
                                                        titleColorNormal:btnColorNor
                                                        titleColorSelect:btnColorSel];
        [_billingClassButton setBackgroundColor:[UIColor whiteColor]];
        [_billingClassButton setDidClickActionBlock:^{
            if ([weakSelf.billingClassDropDownMenu isShowMenu]) {
                [weakSelf.billingClassDropDownMenu dismissMenu:YES];
            } else {
                if ([weakSelf.billingFilterDropDownMenu isShowMenu]) {
                    [weakSelf.billingFilterDropDownMenu dismissMenu:YES then:^{
                        [weakSelf doBillingClassDropDownMenuShow];
                    }];
                } else {
                    [weakSelf doBillingClassDropDownMenuShow];
                }
            }
        }];
    }
    return _billingClassButton;
}

- (FYArrowUpDownButton *)billingFilterButton
{
    if (!_billingFilterButton) {
        CGFloat btnSizeWidth = [FYArrowUpDownButton defaultWidth];
        CGFloat btnSizeHeight = BILLING_HEADER_HEIGHT_FOR_TOP;
        UIFont *btnFontNor = BILLING_SEARCH_BUTTON_TITLE_FONT;
        UIFont *btnFontSel = BILLING_SEARCH_BUTTON_TITLE_FONT;
        UIColor *btnColorNor = COLOR_SYSTEM_MAIN_FONT_DEFAULT;
        UIColor *btnColorSel = COLOR_SYSTEM_MAIN_UI_THEME_DEFAULT;
        //
        WEAKSELF(weakSelf)
        CGRect frame = CGRectMake(0, 0, btnSizeWidth, btnSizeHeight);
        _billingFilterButton = [[FYArrowUpDownButton alloc] initWithFrame:frame
                                                                    title:NSLocalizedString(@"筛选", nil)
                                                          titleFontNormal:btnFontNor
                                                          titleFontSelect:btnFontSel
                                                         titleColorNormal:btnColorNor
                                                         titleColorSelect:btnColorSel];
        [_billingFilterButton setBackgroundColor:[UIColor whiteColor]];
        [_billingFilterButton setDidClickActionBlock:^{
            if ([weakSelf.billingFilterDropDownMenu isShowMenu]) {
                [weakSelf.billingFilterDropDownMenu dismissMenu:YES];
            } else {
                if ([weakSelf.billingClassDropDownMenu isShowMenu]) {
                    [weakSelf.billingClassDropDownMenu dismissMenu:YES then:^{
                        [weakSelf doBillingFilterDropDownMenuShow];
                    }];
                } else {
                    [weakSelf doBillingFilterDropDownMenuShow];
                }
            }
        }];
        [_billingFilterButton setIsCanClickActionBlock:^BOOL{
            NSArray<NSString *> *selectClassIds = nil;
            if (self.delegate && [self.delegate respondsToSelector:@selector(getClassDropDownMenuOfCurrentClassIds)]) {
                selectClassIds = [self.delegate getClassDropDownMenuOfCurrentClassIds];
            }
            if (!selectClassIds || selectClassIds.count <= 0) {
                ALTER_INFO_MESSAGE(NSLocalizedString(@"请先选择分类！", nil))
                return NO;
            }
            return YES;
        }];
    }
    return _billingFilterButton;
}

- (FYArrowUpDownButton *)billingDatetimeButton
{
    if (!_billingDatetimeButton) {
        CGFloat btnSizeWidth = [FYArrowUpDownButton defaultWidth];
        CGFloat btnSizeHeight = [FYArrowUpDownButton defaultHeight];
        UIFont *btnFontNor = BILLING_SEARCH_BUTTON_TITLE_FONT;
        UIFont *btnFontSel = BILLING_SEARCH_BUTTON_TITLE_FONT;
        UIColor *btnColorNor = COLOR_SYSTEM_MAIN_FONT_DEFAULT;
        UIColor *btnColorSel = COLOR_SYSTEM_MAIN_UI_THEME_DEFAULT;
        //
        WEAKSELF(weakSelf)
        CGRect frame = CGRectMake(0, 0, btnSizeWidth, btnSizeHeight);
        _billingDatetimeButton = [[FYArrowUpDownButton alloc] initWithFrame:frame
                                                                      title:NSLocalizedString(@"本月", nil)
                                                            titleFontNormal:btnFontNor
                                                            titleFontSelect:btnFontSel
                                                           titleColorNormal:btnColorNor
                                                           titleColorSelect:btnColorSel];
        [_billingDatetimeButton setBackgroundColor:[UIColor whiteColor]];
        [_billingDatetimeButton addCornerRadius:btnSizeHeight*0.5f];
        [_billingDatetimeButton setDidClickActionBlock:^{
            [weakSelf doBillingSearchDateTimePickerShow];
        }];
    }
    return _billingDatetimeButton;
}


#pragma mark - Private

- (void)doBillingClassDropDownMenuShow
{
    // 当前选中项
    NSArray<NSString *> *selectClassIds = nil;
    if (self.delegate && [self.delegate respondsToSelector:@selector(getClassDropDownMenuOfCurrentClassIds)]) {
        selectClassIds = [self.delegate getClassDropDownMenuOfCurrentClassIds];
    }
    
    // 初始化数据
    WEAKSELF(weakSelf)
    NSArray<NSString *> *selectInitClassIds = (!selectClassIds||selectClassIds.count<=0) ? @[STR_BILLING_CALSS_ALL_UUID] : selectClassIds;
    NSArray<FYBillingSearchClassModel *> *modelsArray = [FYBillingSearchClassModel buildingDataModles:self.arrayOfBillQueryModels];
    [modelsArray enumerateObjectsUsingBlock:^(FYBillingSearchClassModel * _Nonnull sectionModel, NSUInteger idx, BOOL * _Nonnull stop) {
        [sectionModel.items enumerateObjectsUsingBlock:^(FYBillingClassModel * _Nonnull classModel, NSUInteger idx, BOOL * _Nonnull stop) {
            
            // 初始化已选中的分类
            if ([selectInitClassIds containsObject:classModel.uuid]) {
                [classModel setIsSelected:YES];
            } else {
                [classModel setIsSelected:NO];
            }
            
            // 点击选中某分类事件
            [classModel setDidSelectedBlock:^(FYBillingClassModel * _Nonnull itemModel) {
                [weakSelf.billingClassDropDownMenu dismissMenu:YES then:^{
                    // 改变按钮标题
                    [weakSelf.billingClassButton setChangeButtonTitleValue:itemModel.title];
                    // 选中的ID数组
                    __block NSArray<NSString *> *classIds = @[];
                    __block NSArray<NSString *> *filterIds = @[];
                    __block NSArray<NSString *> *queryInfoIds = @[];
                    if (![STR_BILLING_CALSS_ALL_UUID isEqualToString:itemModel.uuid]) {
                        classIds = @[ itemModel.uuid ];
                        queryInfoIds = [FYBillingSearchClassModel getQueryInfoIdsByClassIds:classIds dataModles:weakSelf.arrayOfBillQueryModels];
                    }
                    // 是否改变分类
                    if (![CFCSysUtil validateStrArray:selectClassIds isEqualToStrArray:classIds]) {
                        if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(doRefreshBillingRecordWithClassIds:filterIds:queryInfoIds:)]) {
                            [weakSelf.delegate doRefreshBillingRecordWithClassIds:classIds filterIds:filterIds queryInfoIds:queryInfoIds];
                        }
                    }
                }];
            }];
            
        }];
    }];
    
    // 显示分类弹框
    [self.billingClassDropDownMenu setMenuModelsArray:modelsArray];
    [self.billingClassDropDownMenu setup];
    [self.billingClassDropDownMenu showMenu];
}

- (void)doBillingFilterDropDownMenuShow
{
    // 当前选中的分类
    NSArray<NSString *> *selectClassIds = nil;
    if (self.delegate && [self.delegate respondsToSelector:@selector(getClassDropDownMenuOfCurrentClassIds)]) {
        selectClassIds = [self.delegate getClassDropDownMenuOfCurrentClassIds];
    }
    if (!selectClassIds || selectClassIds.count <= 0) {
        ALTER_INFO_MESSAGE(NSLocalizedString(@"请先选择分类！", nil))
        return;
    }
    
    // 当前选中筛选
    NSArray<NSString *> *selectFilterIds = nil;
    if (self.delegate && [self.delegate respondsToSelector:@selector(getFilterDropDownMenuOfCurrentFilterIds)]) {
        selectFilterIds = [self.delegate getFilterDropDownMenuOfCurrentFilterIds];
    }
    
    // 当前最低金额
    NSString *currentMinMoney = STR_BILLING_FILTER_MONEY_MIN_VALUE;
    if (self.delegate && [self.delegate respondsToSelector:@selector(getFilterDropDownMenuOfCurrentQueryMinMoney)]) {
        currentMinMoney = [self.delegate getFilterDropDownMenuOfCurrentQueryMinMoney];
    }
    
    // 当前最高金额
    NSString *currentMaxMoney = STR_BILLING_FILTER_MONEY_MAX_VALUE;
    if (self.delegate && [self.delegate respondsToSelector:@selector(getFilterDropDownMenuOfCurrentQueryMaxMoney)]) {
        currentMaxMoney = [self.delegate getFilterDropDownMenuOfCurrentQueryMaxMoney];
    }
    
    // 初始化数据
    WEAKSELF(weakSelf)
    NSArray<FYBillingSearchFilterModel *> *modelsArray = [FYBillingSearchFilterModel buildingDataModles:self.arrayOfBillQueryModels selectClassIds:selectClassIds];
    [modelsArray enumerateObjectsUsingBlock:^(FYBillingSearchFilterModel * _Nonnull sectionModel, NSUInteger idx, BOOL * _Nonnull stop) {
        [sectionModel.items enumerateObjectsUsingBlock:^(FYBillingFilterModel * _Nonnull filterModel, NSUInteger idx, BOOL * _Nonnull stop) {
            
            // 初始化已选中的筛选
            if ([selectFilterIds containsObject:filterModel.uuid]) {
                [filterModel setIsSelected:YES];
            } else {
                [filterModel setIsSelected:NO];
            }
            
            // 初始化已设置金额
            if ([STR_BILLING_FILTER_TITLE_MONEY_MIN isEqualToString:filterModel.title]) {
                [filterModel setMinMoney:currentMinMoney];
            } else if ([STR_BILLING_FILTER_TITLE_MONEY_MAX isEqualToString:filterModel.title]) {
                [filterModel setMaxMoney:currentMaxMoney];
            }
            
            // 按钮重置和确定事件
            [filterModel setDidSelectedBlock:^(FYBillingFilterModel * _Nonnull itemModel) {
                /// 筛选 -> 重置
                if (FYBillingFilterButtonTypeReset == itemModel.buttonType) {
                    [modelsArray enumerateObjectsUsingBlock:^(FYBillingSearchFilterModel * _Nonnull resSectonModel, NSUInteger idx, BOOL * _Nonnull stop) {
                        [resSectonModel.items enumerateObjectsUsingBlock:^(FYBillingFilterModel * _Nonnull resFilterModel, NSUInteger idx, BOOL * _Nonnull stop) {
                            [resFilterModel setIsSelected:NO];
                            [resFilterModel setMinMoney:STR_BILLING_FILTER_MONEY_MIN_VALUE];
                            [resFilterModel setMaxMoney:STR_BILLING_FILTER_MONEY_MAX_VALUE];
                        }];
                    }];
                    [weakSelf.billingFilterDropDownMenu reloadMenu];
                }
                /// 筛选 -> 确定
                else if (FYBillingFilterButtonTypeConfirm == itemModel.buttonType) {
                    // 获取当前输入金额
                    __block NSString *queryMinMoney = nil;
                    __block NSString *queryMaxMoney = nil;
                    [modelsArray enumerateObjectsUsingBlock:^(FYBillingSearchFilterModel * _Nonnull resSectonModel, NSUInteger idx, BOOL * _Nonnull stop) {
                        if (FYBillingSearchFilterCellMoney == resSectonModel.cellType) { // 筛选Cell类型 - 金额
                            [resSectonModel.items enumerateObjectsUsingBlock:^(FYBillingFilterModel * _Nonnull resFilterModel, NSUInteger idx, BOOL * _Nonnull stop) {
                               if ([STR_BILLING_FILTER_TITLE_MONEY_MIN isEqualToString:resFilterModel.title]) {
                                   queryMinMoney = resFilterModel.minMoney;
                               } else if ([STR_BILLING_FILTER_TITLE_MONEY_MAX isEqualToString:resFilterModel.title]) {
                                   queryMaxMoney = resFilterModel.maxMoney;
                               }
                            }];
                        }
                    }];
                    
                    // 只输入了一个金额
                    if (!VALIDATE_STRING_EMPTY(queryMinMoney) || !VALIDATE_STRING_EMPTY(queryMaxMoney)) {
                        if (VALIDATE_STRING_EMPTY(queryMinMoney)) {
                            ALTER_INFO_MESSAGE(NSLocalizedString(@"请输入最低金额！", nil))
                            return;
                        }
                        if (VALIDATE_STRING_EMPTY(queryMaxMoney)) {
                            ALTER_INFO_MESSAGE(NSLocalizedString(@"请输入最高金额！", nil))
                            return;
                        }
                    }
                    
                    // 最低金额 <= 最高金额
                    if (!VALIDATE_STRING_EMPTY(queryMinMoney)
                        && !VALIDATE_STRING_EMPTY(queryMaxMoney)
                        && queryMinMoney.floatValue > queryMaxMoney.floatValue) {
                        ALTER_INFO_MESSAGE(NSLocalizedString(@"最高金额必须大于等于最低金额！", nil))
                        return;
                    } else {
                        // 关闭筛选弹框
                        [weakSelf.billingFilterDropDownMenu dismissMenu:YES then:^{
                            // 选中的ID数组
                            __block NSMutableArray<NSString *> *filterIds = @[].mutableCopy;
                            __block NSMutableArray<NSString *> *queryInfoIds = @[].mutableCopy;
                            __block NSMutableArray<NSString *> *allQueryInfoIds = @[].mutableCopy; // 重置清空，默认查询所有
                            [modelsArray enumerateObjectsUsingBlock:^(FYBillingSearchFilterModel * _Nonnull resSectonModel, NSUInteger idx, BOOL * _Nonnull stop) {
                                if (FYBillingSearchFilterCellItem == resSectonModel.cellType) { // 筛选Cell类型 - 项目
                                    [resSectonModel.items enumerateObjectsUsingBlock:^(FYBillingFilterModel * _Nonnull resFilterModel, NSUInteger idx, BOOL * _Nonnull stop) {
                                        if (resFilterModel.isSelected) {
                                            [filterIds addObj:resFilterModel.uuid];
                                            // 如果筛选有下级，则取下一级的 idAuto，否则直接取筛选 idAuto
                                            if (!resFilterModel || resFilterModel.items.count <= 0) {
                                                [queryInfoIds addObj:[NSString stringWithFormat:@"%@", resFilterModel.idAuto]];
                                                [allQueryInfoIds addObj:[NSString stringWithFormat:@"%@", resFilterModel.idAuto]];
                                            } else {
                                                [resFilterModel.items enumerateObjectsUsingBlock:^(FYBillingFilterSubModel * _Nonnull resFilterSubModel, NSUInteger idx, BOOL * _Nonnull stop) {
                                                    [queryInfoIds addObj:[NSString stringWithFormat:@"%@", resFilterSubModel.idAuto]];
                                                    [allQueryInfoIds addObj:[NSString stringWithFormat:@"%@", resFilterSubModel.idAuto]];
                                                }];
                                            }
                                        } else {
                                            // 如果筛选有下级，则取下一级的 idAuto，否则直接取筛选 idAuto
                                            if (!resFilterModel || resFilterModel.items.count <= 0) {
                                                [allQueryInfoIds addObj:[NSString stringWithFormat:@"%@", resFilterModel.idAuto]];
                                            } else {
                                                [resFilterModel.items enumerateObjectsUsingBlock:^(FYBillingFilterSubModel * _Nonnull resFilterSubModel, NSUInteger idx, BOOL * _Nonnull stop) {
                                                    [allQueryInfoIds addObj:[NSString stringWithFormat:@"%@", resFilterSubModel.idAuto]];
                                                }];
                                            }
                                        }
                                    }];
                                }
                            }];
                            
                            // 重置清空，默认查询所有
                            if (queryInfoIds.count <= 0) {
                                queryInfoIds = allQueryInfoIds;
                            }
                                                        
                            // 条件是否改变
                            if (![currentMinMoney isEqualToString:queryMinMoney]
                                || ![currentMaxMoney isEqualToString:queryMaxMoney]
                                || ![CFCSysUtil validateStrArray:selectFilterIds isEqualToStrArray:filterIds]) {
                                if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(doRefreshBillingRecordWithFilterIds:queryInfoIds:queryMinMoney:queryMaxMoney:)]) {
                                    [weakSelf.delegate doRefreshBillingRecordWithFilterIds:filterIds queryInfoIds:queryInfoIds queryMinMoney:queryMinMoney queryMaxMoney:queryMaxMoney];
                                }
                            }
                        }];
                    }
                } /// 筛选 -> 确定
            }];
            
        }];
    }];
    
    // 显示筛选弹框
    [self.billingFilterDropDownMenu setMenuModelsArray:modelsArray];
    [self.billingFilterDropDownMenu setup];
    [self.billingFilterDropDownMenu showMenu];
}

/// 选择时间弹框
- (void)doBillingSearchDateTimePickerShow
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
    
    NSString *currentQueryTime = [[NSDate new] stringFromDateWithFormat:datePickerYearMonthContentFormat];
    if (self.delegate && [self.delegate respondsToSelector:@selector(getCurrentQueryTime)]) {
        currentQueryTime = [self.delegate getCurrentQueryTime];
    }
    
    NSString *currentQueryStartTime = [[NSDate new] stringFromDateWithFormat:datePickerStartEndTimeContentFormat];
    if (self.delegate && [self.delegate respondsToSelector:@selector(getCurrentQueryStartTime)]) {
        currentQueryStartTime = [self.delegate getCurrentQueryStartTime];
    }
    
    NSString *currentQueryEndTime = [[NSDate new] stringFromDateWithFormat:datePickerStartEndTimeContentFormat];
    if (self.delegate && [self.delegate respondsToSelector:@selector(getCurrentQueryEndTime)]) {
        currentQueryEndTime = [self.delegate getCurrentQueryEndTime];
    }
    
    // 初始化数据
    WEAKSELF(weakSelf)
    FYDatePickerViewController *alterDatePick =
    [FYDatePickerViewController datePicker:currentDatePickerTimeType
                                 yearMonth:currentQueryTime
                      yearMonthTitleFormat:datePickerYearMonthTitleFormat
                    yearMonthContentFormat:datePickerYearMonthContentFormat
                                 startTime:currentQueryStartTime
                                   endTime:currentQueryEndTime
                   startEndTimeTitleFormat:datePickerStartEndTimeTitleFormat
                 startEndTimeContentFormat:datePickerStartEndTimeContentFormat];
    [alterDatePick setDismissBlock:^{
        [weakSelf.billingDatetimeButton setChangeButtonIndicatorOpen:NO];
    }];
    [alterDatePick setConfirmActionBlock:^(FYDatePickerTimeType datePickerTimeType, NSString * _Nonnull yearmonth, NSString * _Nonnull yearMonthTitleFormat, NSString * _Nonnull yearMonthContentFormat, NSString * _Nonnull starttime, NSString * _Nonnull endtime, NSString * _Nonnull startEndTimeTitleFormat, NSString * _Nonnull startEndTimeContentFormat) {
        if (FYDatePickerTimeTypeNone != datePickerTimeType) {
            // 改变按钮标题
            NSString *titleString = @"";
            if (FYDatePickerTimeTypeYearMonth == datePickerTimeType) { // 按月查询
                titleString = yearmonth;
            } else if (FYDatePickerTimeTypeStartEndTime == datePickerTimeType) { // 按日查询
                if ([starttime isEqualToString:endtime]) {
                    titleString = [NSString stringWithFormat:@"%@", starttime];
                } else {
                    titleString = [NSString stringWithFormat:NSLocalizedString(@"%@ 至 %@", nil), starttime, endtime];
                }
            }
            [weakSelf.billingDatetimeButton setChangeButtonTitleValue:titleString];
            
            // 条件是否改变
            BOOL isNeedRefresh = NO;
            if (currentDatePickerTimeType != datePickerTimeType
                || ![currentQueryTime isEqualToString:yearmonth]
                || ![currentQueryStartTime isEqualToString:starttime]
                || ![currentQueryEndTime isEqualToString:endtime]) {
                isNeedRefresh = YES;
            }
            
            if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(doRefreshBillingRecordWithDatePickerTimeType:queryTime:queryStartTime:queryEndTime:isNeedRefresh:)]) {
                [weakSelf.delegate doRefreshBillingRecordWithDatePickerTimeType:datePickerTimeType queryTime:yearmonth queryStartTime:starttime queryEndTime:endtime isNeedRefresh:isNeedRefresh];
            }
        }
    }];
    [self.parentViewController presentViewController:alterDatePick animated:YES completion:nil];
}


@end

