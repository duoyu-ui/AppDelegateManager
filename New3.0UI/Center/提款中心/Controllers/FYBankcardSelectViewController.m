//
//  FYBankcardSelectViewController.m
//  ProjectCSHB
//
//  Created by fangyuan on 2020/6/19.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "FYBankcardSelectViewController.h"
#import "FYBindBankCardNullTableViewCell.h"
#import "FYBankCardSelectTableViewCell.h"
#import "FYBankCardFuncTableViewCell.h"
#import "FYMyBankCardModel.h"
#import "FYBankItemModel.h"
//
#import "FYAddBankcardViewController.h"
#import "FYBankcardUnBindViewController.h"


@interface FYBankcardSelectViewController () <FYBankCardSelectTableViewCellDelegate, FYBankCardFuncTableViewCellDelegate, FYBindBankCardNullTableViewCellDelegate>

@end


@implementation FYBankcardSelectViewController


#pragma mark - Actions

/// 导航返回
- (void)pressNavigationBarLeftButtonItem:(id)sender
{
    NSMutableArray<FYMyBankCardModel *> *sectionModel = [self.tableDataRefresh objectAtIndex:0];
    if (!self.currentBankCardModel || sectionModel.count < 1) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

/// 添加银行卡
- (void)pressNavigationBarRightButtonItem:(id)sender
{
    FYAddBankcardViewController *VC = [[FYAddBankcardViewController alloc] init];
    [VC setIsFromPersonSetting:self.isFromPersonSetting];
    [VC setFinishAddBankItemModelBlock:^FYAddBankCardResType(FYBankItemModel * _Nullable bankCardModel) {
        // 选择银行卡 -> 添加银行卡 -> 提现页面
        if (!self.currentBankCardModel) {
            [APPINFORMATION.userInfo setIsTiedCard:YES];
            !self.selectedMyBankCardBlock ?: self.selectedMyBankCardBlock(nil, YES); // 刷新提现界面银行卡数据
            return FYAddBankCardResSelectBankCardToWithdraw;
        }
        
        // 选择银行卡 -> 添加银行卡 -> 选择银行卡
        if (!VALIDATE_STRING_EMPTY(bankCardModel.code)) {
            [self.tableViewRefresh.mj_header beginRefreshing];
        }
        return FYAddBankCardResSelectBankCardToBackSelf;
    }];
    [self.navigationController pushViewController:VC animated:YES];
}

/// 空白提示 - 添加银行卡
- (void)didBindAddCardAtBankCardModel:(FYMyBankCardModel *)model indexPath:(NSIndexPath *)indexPath
{
    [self pressNavigationBarRightButtonItem:nil];
}

/// 选中银行卡
- (void)didSelectRowAtBankCardModel:(FYMyBankCardModel *)model indexPath:(NSIndexPath *)indexPath
{
    if (self.isFromPersonSetting) {
        return;
    }
    
    // 刷新界面
    [self.tableDataRefresh enumerateObjectsUsingBlock:^(NSMutableArray<FYMyBankCardModel *> * _Nonnull sectionModels, NSUInteger idx, BOOL * _Nonnull stop) {
        [sectionModels enumerateObjectsUsingBlock:^(FYMyBankCardModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (model.uuid.integerValue != obj.uuid.integerValue) {
                [obj setIsSelected:NO];
            } else {
                [obj setIsSelected:YES];
            }
        }];
    }];
    [self.tableViewRefresh reloadData];
    
    // 返回提现
    [self setCurrentBankCardModel:model];
    !self.selectedMyBankCardBlock ?: self.selectedMyBankCardBlock(self.currentBankCardModel, NO);
    [self.navigationController popViewControllerAnimated:YES];
}

/// 解除绑定
- (void)didSelectRowAtFunctionBankCardModel:(FYMyBankCardModel *)model indexPath:(NSIndexPath *)indexPath
{
    NSMutableArray<FYMyBankCardModel *> *sectionModel = [self.tableDataRefresh objectAtIndex:0];
    if (sectionModel.count < 1) {
        ALTER_INFO_MESSAGE(NSLocalizedString(@"已解绑所有银行卡", nil))
        return;
    }
    
    WEAKSELF(weakSelf)
    FYBankcardUnBindViewController *VC = [[FYBankcardUnBindViewController alloc] initWithBankCardModel:self.currentBankCardModel];
    [VC setFinishUnBindMyBankCardBlock:^(FYMyBankCardModel * _Nullable bankCardModel, NSMutableArray<FYMyBankCardModel *> * _Nullable bankCardModels) {
        [weakSelf setCurrentBankCardModel:bankCardModel];
        !weakSelf.selectedMyBankCardBlock ?: weakSelf.selectedMyBankCardBlock(bankCardModel, NO);
        if (bankCardModels.count > 0) {
            [weakSelf.tableDataRefresh replaceObjectAtIndex:0 withObject:bankCardModels];
        } else {
            [weakSelf setTableDataRefresh:[FYMyBankCardModel buildingDataModlesForSelect:bankCardModels selectedModel:nil isFromPersonSetting:weakSelf.isFromPersonSetting then:nil]];
        }
        dispatch_main_async_safe(^{
            [weakSelf.tableViewRefresh reloadData];
        });
    }];
    [self.navigationController pushViewController:VC animated:YES];
}


#pragma mark - Life Cycle

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.hasRefreshFooter = NO;
        self.isFromPersonSetting  = NO;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // 隐藏导航栏底线
    [self.navigationBarHairlineImageView setHidden:YES];
}

- (instancetype)initWithBankCardModel:(FYMyBankCardModel *)bankCardModel
{
    self = [self init];
    if (self) {
        self.currentBankCardModel = bankCardModel;
    }
    return self;
}

- (void)tableViewRefreshRegisterClass:(UITableView *)tableView
{
    [self.tableViewRefresh registerClass:[FYBankCardFuncTableViewCell class] forCellReuseIdentifier:[FYBankCardFuncTableViewCell reuseIdentifier]];
    [self.tableViewRefresh registerClass:[FYBankCardSelectTableViewCell class] forCellReuseIdentifier:[FYBankCardSelectTableViewCell reuseIdentifier]];
    [self.tableViewRefresh registerClass:[FYBindBankCardNullTableViewCell class] forCellReuseIdentifier:[FYBindBankCardNullTableViewCell reuseIdentifier]];
}


#pragma mark - Network

- (Act)getRequestInfoAct
{
    return ActRequestMyBankList;
}

- (NSMutableDictionary *)getRequestParamerter
{
    return @{ }.mutableCopy;
}

- (NSMutableArray *)loadNetworkDataOrCacheData:(id)responseDataOrCacheData isCacheData:(BOOL)isCacheData
{
    FYLog(NSLocalizedString(@"银行卡 => \n%@", nil), responseDataOrCacheData);
    
    // 请求成功，解析数据
    WEAKSELF(weakSelf);
    if (!NET_REQUEST_SUCCESS(responseDataOrCacheData)) {
        weakSelf.tableDataRefresh = @[].mutableCopy;
        return weakSelf.tableDataRefresh;
    }

    // 获取绑定的银行卡列表
    NSMutableArray<FYMyBankCardModel *> *bankCardModels = [NSMutableArray<FYMyBankCardModel *> array];
    NSDictionary *data = NET_REQUEST_DATA(responseDataOrCacheData);
    NSArray<NSDictionary *> *arrayOfDicts = [data arrayForKey:@"paymentList"];
    if ([arrayOfDicts isKindOfClass:[NSArray class]]) {
        bankCardModels = [FYMyBankCardModel mj_objectArrayWithKeyValuesArray:arrayOfDicts];
    }
    
    // 获取绑定的银行卡列表
    weakSelf.tableDataRefresh = [FYMyBankCardModel buildingDataModlesForSelect:bankCardModels selectedModel:self.currentBankCardModel isFromPersonSetting:self.isFromPersonSetting then:^(FYMyBankCardModel * selectedBankCardModel) {
        // currentBankCardModel 为空，说明没有银行卡，第一次添加的银行卡，默认选中
        if (selectedBankCardModel && !weakSelf.currentBankCardModel) {
            [APPINFORMATION.userInfo setIsTiedCard:YES];
            [weakSelf setCurrentBankCardModel:selectedBankCardModel];
            !weakSelf.selectedMyBankCardBlock ?: weakSelf.selectedMyBankCardBlock(selectedBankCardModel,YES);
        }
    }];

    return weakSelf.tableDataRefresh;
}


#pragma mark - UITableViewDelegate, UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.tableDataRefresh.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSMutableArray<FYMyBankCardModel *> *sectionModel = [self.tableDataRefresh objectAtIndex:section];
    return sectionModel.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableArray<FYMyBankCardModel *> *sectionModel = [self.tableDataRefresh objectAtIndex:indexPath.section];
    FYMyBankCardModel *myBankCardModel = [sectionModel objectAtIndex:indexPath.row];
    
    switch (myBankCardModel.cellType) {
        case FYMyBankCardCellTypeCard: {
            FYBankCardSelectTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:[FYBankCardSelectTableViewCell reuseIdentifier]];
            if (cell == nil) {
                cell = [[FYBankCardSelectTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[FYBankCardSelectTableViewCell reuseIdentifier]];
            }
            cell.delegate = self;
            cell.indexPath = indexPath;
            cell.model = myBankCardModel;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
            break;
        case FYMyBankCardCellTypeUnBind: {
            FYBankCardFuncTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:[FYBankCardFuncTableViewCell reuseIdentifier]];
            if (cell == nil) {
                cell = [[FYBankCardFuncTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[FYBankCardFuncTableViewCell reuseIdentifier]];
            }
            cell.delegate = self;
            cell.indexPath = indexPath;
            cell.model = myBankCardModel;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
            break;
        case FYMyBankCardCellTypeNull: {
            FYBindBankCardNullTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:[FYBindBankCardNullTableViewCell reuseIdentifier]];
            if (cell == nil) {
                cell = [[FYBindBankCardNullTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[FYBindBankCardNullTableViewCell reuseIdentifier]];
            }
            cell.delegate = self;
            cell.indexPath = indexPath;
            cell.model = myBankCardModel;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
            break;
        default:
            break;
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableArray<FYMyBankCardModel *> *sectionModel = [self.tableDataRefresh objectAtIndex:indexPath.section];
    FYMyBankCardModel *myBankCardModel = [sectionModel objectAtIndex:indexPath.row];
    
    switch (myBankCardModel.cellType) {
        case FYMyBankCardCellTypeCard: {
            return [self.tableViewRefresh fd_heightForCellWithIdentifier:[FYBankCardSelectTableViewCell reuseIdentifier] cacheByIndexPath:indexPath configuration:^(FYBankCardSelectTableViewCell *cell) {
                cell.model = myBankCardModel;
            }];
        };
        case FYMyBankCardCellTypeUnBind: {
            return [self.tableViewRefresh fd_heightForCellWithIdentifier:[FYBankCardFuncTableViewCell reuseIdentifier] cacheByIndexPath:indexPath configuration:^(FYBankCardFuncTableViewCell *cell) {
                cell.model = myBankCardModel;
            }];
        };
        case FYMyBankCardCellTypeNull: {
            return [self.tableViewRefresh fd_heightForCellWithIdentifier:[FYBindBankCardNullTableViewCell reuseIdentifier] cacheByIndexPath:indexPath configuration:^(FYBindBankCardNullTableViewCell *cell) {
                cell.model = self.tableDataRefresh[indexPath.row];
            }];
        }
        default:
            break;
    }
    
    return FLOAT_MIN;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableViewRefresh.frame.size.width, SEPARTOR_MARGIN_HEIGHT)];
    [headerView setBackgroundColor:COLOR_TABLEVIEW_HEADER_VIEW_BACKGROUND_DEFAULT];
    return headerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableViewRefresh.frame.size.width, SEPARTOR_MARGIN_HEIGHT)];
    [footerView setBackgroundColor:COLOR_TABLEVIEW_FOOTER_VIEW_BACKGROUND_DEFAULT];
    return footerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return SEPARTOR_MARGIN_HEIGHT;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return FLOAT_MIN;
}


#pragma mark - Navigation

- (NSString *)prefersNavigationBarTitleViewTitle
{
    return STR_NAVIGATION_BAR_TITLE_WITHDRAW_BANKCARD_SELECT;
}

- (CGFloat)prefersNavigationBarHairlineHeight
{
    return NAVIGATION_BAR_HAIR_LINE_HEIGHT_ZERO;
}

- (CFCNavBarButtonItemType)prefersNavigationBarRightButtonItemType
{
    return CFCNavBarButtonItemTypeCustom;
}

- (NSString *)prefersNavigationBarRightButtonItemImageNormal
{
    return @"icon_bankcard_add";
}


@end

