//
//  FYBindBankcardViewController.m
//  ProjectCSHB
//
//  Created by fangyuan on 2020/6/8.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "FYBindBankcardViewController.h"
#import "FYBindBankCardTableViewCell.h"
#import "FYBindBankAddCardTableViewCell.h"
#import "FYBindBankCardNullTableViewCell.h"
#import "FYBindBankCardTableSectionHeader.h"
#import "FYMyBankCardModel.h"
#import "FYBankItemModel.h"
//
#import "FYAddBankcardViewController.h"


@interface FYBindBankcardViewController () <FYBindBankCardTableViewCellDelegate, FYBindBankAddCardTableViewCellDelegate, FYBindBankCardNullTableViewCellDelegate>

@end


@implementation FYBindBankcardViewController

/// 导航返回
- (void)pressNavigationBarLeftButtonItem:(id)sender
{
    if (!self.currentBankCardModel || self.tableDataRefresh.count <= 1) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

/// 选中银行卡
- (void)didSelectRowAtBankCardModel:(FYMyBankCardModel *)model indexPath:(NSIndexPath *)indexPath
{
    // 刷新界面
    [self.tableDataRefresh enumerateObjectsUsingBlock:^(FYMyBankCardModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (model.uuid.integerValue != obj.uuid.integerValue) {
            [obj setIsSelected:NO];
        } else {
            [obj setIsSelected:YES];
        }
    }];
    [self.tableViewRefresh reloadData];
    
    // 返回提现
    [self setCurrentBankCardModel:model];
    !self.selectedMyBankCardBlock ?: self.selectedMyBankCardBlock(self.currentBankCardModel, NO);
    [self.navigationController popViewControllerAnimated:YES];
}

// 添加银行卡
- (void)didBindAddCardAtBankCardModel:(FYMyBankCardModel *)model indexPath:(NSIndexPath *)indexPath
{
    FYAddBankcardViewController *VC = [[FYAddBankcardViewController alloc] init];
    [VC setFinishAddBankItemModelBlock:^FYAddBankCardResType(FYBankItemModel * _Nullable bankCardModel) {
        // 选择银行卡 -> 添加银行卡 -> 提现页面
        if (!self.currentBankCardModel) {
            [APPINFORMATION.userInfo setIsTiedCard:YES];
            !self.selectedMyBankCardBlock ?: self.selectedMyBankCardBlock(nil, YES); // 刷新提现界面银行卡数据
            return FYAddBankCardResSelectBankCardToWithdraw;
        }
        
        // 绑定银行卡 -> 添加银行卡 -> 绑定银行卡
        if (!VALIDATE_STRING_EMPTY(bankCardModel.code)) {
            [self.tableViewRefresh.mj_header beginRefreshing];
        }
        return FYAddBankCardResSelectBankCardToBackSelf;
    }];
    [self.navigationController pushViewController:VC animated:YES];
}

/// 解除绑定
- (void)didUnBindCardAtBankCardModel:(FYMyBankCardModel *)model indexPath:(NSIndexPath *)indexPath
{
    WEAKSELF(weakSelf)
    AlertViewCus *alertView = [AlertViewCus createInstanceWithView:nil];
    [alertView.textLabel setFont:[UIFont systemFontOfSize:16]];
    [alertView showWithText:NSLocalizedString(@"确定解绑银行卡？", nil) button1:NSLocalizedString(@"取消", nil) button2:NSLocalizedString(@"确认", nil) callBack:^(id object) {
        NSInteger tag = [object integerValue];
        if (tag == 1) {
            [self doUnBindBankCardWithBankCardModel:model then:^(BOOL success) {
                if (success) {
                    ALTER_INFO_MESSAGE(NSLocalizedString(@"解绑成功", nil))
                    FYMyBankCardModel *delModel = [weakSelf.tableDataRefresh objectAtIndex:indexPath.row];
                    [weakSelf.tableDataRefresh removeObjectAtIndex:indexPath.row];
                    if (weakSelf.tableDataRefresh.count <= 1) { // 已经没有绑定的银行卡了
                        [APPINFORMATION.userInfo setIsTiedCard:NO];
                        [weakSelf setCurrentBankCardModel:nil];
                        [weakSelf setTableDataRefresh:[FYMyBankCardModel buildingDataModles:nil selectedModel:nil then:nil]];
                        !weakSelf.selectedMyBankCardBlock ?: weakSelf.selectedMyBankCardBlock(nil,YES);
                    } else {
                        if (delModel.isSelected) { // 解绑的是选中状态的银行卡
                            // 默认选中第一个
                            FYMyBankCardModel *defBankCarModel = self.tableDataRefresh.firstObject;
                            [defBankCarModel setIsSelected:YES];
                            [weakSelf setCurrentBankCardModel:defBankCarModel];
                        }
                        !weakSelf.selectedMyBankCardBlock ?: weakSelf.selectedMyBankCardBlock(weakSelf.currentBankCardModel,YES);
                    }
                    [weakSelf.tableViewRefresh reloadData];
                } else {
                    ALTER_INFO_MESSAGE(NSLocalizedString(@"解绑失败", nil))
                }
            }];
        }
    }];
}


#pragma mark - Life Cycle

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.hasRefreshFooter = NO;
    }
    return self;
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
    [self.tableViewRefresh registerClass:[FYBindBankCardTableViewCell class] forCellReuseIdentifier:CELL_IDENTIFIER_BIND_BANKCARD_TABLEVIEW_CELL];
    [self.tableViewRefresh registerClass:[FYBindBankAddCardTableViewCell class] forCellReuseIdentifier:CELL_IDENTIFIER_BIND_BANKADDCARD_TABLEVIEW_CELL];
    [self.tableViewRefresh registerClass:[FYBindBankCardNullTableViewCell class] forCellReuseIdentifier:CELL_IDENTIFIER_BIND_BANKCARD_NULL_TABLEVIEW_CELL];
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

    __block NSMutableArray<FYMyBankCardModel *> *bankCardModels = [NSMutableArray<FYMyBankCardModel *> array];
    NSDictionary *data = NET_REQUEST_DATA(responseDataOrCacheData);
    [[data arrayForKey:@"paymentList"] enumerateObjectsUsingBlock:^(NSDictionary *dict, NSUInteger idx, BOOL * _Nonnull stop) {
        FYMyBankCardModel *model = [FYMyBankCardModel mj_objectWithKeyValues:dict];
        [bankCardModels addObj:model];
    }];
    
    // 获取绑定的银行卡列表
    weakSelf.tableDataRefresh = [FYMyBankCardModel buildingDataModles:bankCardModels selectedModel:self.currentBankCardModel then:^(FYMyBankCardModel * selectedBankCardModel) {
        // 没有银行卡 selectedBankCardModel 为空，否则不为空
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.tableDataRefresh.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FYMyBankCardModel *model = self.tableDataRefresh[indexPath.row];
    
    switch (model.cellType) {
        case FYMyBankCardCellTypeNull: {
            FYBindBankCardNullTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFIER_BIND_BANKCARD_NULL_TABLEVIEW_CELL];
            if (cell == nil) {
                cell = [[FYBindBankCardNullTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELL_IDENTIFIER_BIND_BANKCARD_NULL_TABLEVIEW_CELL];
            }
            cell.delegate = self;
            cell.indexPath = indexPath;
            cell.model = model;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
            break;
        case FYMyBankCardCellTypeCard: {
            FYBindBankCardTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFIER_BIND_BANKCARD_TABLEVIEW_CELL];
            if (cell == nil) {
                cell = [[FYBindBankCardTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELL_IDENTIFIER_BIND_BANKCARD_TABLEVIEW_CELL];
            }
            cell.delegate = self;
            cell.indexPath = indexPath;
            cell.model = model;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
            break;
        case FYMyBankCardCellTypeAddCard: {
            FYBindBankAddCardTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFIER_BIND_BANKADDCARD_TABLEVIEW_CELL];
            if (cell == nil) {
                cell = [[FYBindBankAddCardTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELL_IDENTIFIER_BIND_BANKADDCARD_TABLEVIEW_CELL];
            }
            cell.delegate = self;
            cell.indexPath = indexPath;
            cell.model = model;
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
    FYMyBankCardModel *model = self.tableDataRefresh[indexPath.row];
    
    switch (model.cellType) {
        case FYMyBankCardCellTypeNull: {
            return [self.tableViewRefresh fd_heightForCellWithIdentifier:CELL_IDENTIFIER_BIND_BANKCARD_NULL_TABLEVIEW_CELL cacheByIndexPath:indexPath configuration:^(FYBindBankCardNullTableViewCell *cell) {
                cell.model = self.tableDataRefresh[indexPath.row];
            }];
        }
            break;
        case FYMyBankCardCellTypeCard: {
            return [self.tableViewRefresh fd_heightForCellWithIdentifier:CELL_IDENTIFIER_BIND_BANKCARD_TABLEVIEW_CELL cacheByIndexPath:indexPath configuration:^(FYBindBankCardTableViewCell *cell) {
                cell.model = self.tableDataRefresh[indexPath.row];
            }];
        }
            break;
        case FYMyBankCardCellTypeAddCard: {
            return [self.tableViewRefresh fd_heightForCellWithIdentifier:CELL_IDENTIFIER_BIND_BANKADDCARD_TABLEVIEW_CELL cacheByIndexPath:indexPath configuration:^(FYBindBankAddCardTableViewCell *cell) {
                cell.model = self.tableDataRefresh[indexPath.row];
            }];
        }
            break;
        default:
            break;
    }
    
    return FLOAT_MIN;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (self.tableDataRefresh.count <= 1) {
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableViewRefresh.frame.size.width, CFC_AUTOSIZING_MARGIN(MARGIN))];
         [headerView setBackgroundColor:COLOR_TABLEVIEW_HEADER_VIEW_BACKGROUND_DEFAULT];
         return headerView;
    }
    
    CGFloat tabSectionHeight = CFC_AUTOSIZING_WIDTH(60.0f);
    FYBindBankCardTableSectionHeader *headerView = [[FYBindBankCardTableSectionHeader alloc] initWithFrame:CGRectMake(0, 0, self.tableViewRefresh.frame.size.width, tabSectionHeight) title:@"" headerHeight:tabSectionHeight];
    return headerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableViewRefresh.frame.size.width, CFC_AUTOSIZING_MARGIN(MARGIN))];
    [footerView setBackgroundColor:COLOR_TABLEVIEW_FOOTER_VIEW_BACKGROUND_DEFAULT];
    return footerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (self.tableDataRefresh.count <= 1) {
        return FLOAT_MIN;
    }
    return  CFC_AUTOSIZING_WIDTH(60.0f);
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return FLOAT_MIN;
}


#pragma mark - Navigation

- (NSString *)prefersNavigationBarTitleViewTitle
{
    return STR_NAVIGATION_BAR_TITLE_WITHDRAW_BINDBANKCARD;
}


#pragma mark - Private

- (void)doUnBindBankCardWithBankCardModel:(FYMyBankCardModel *)bankCardModel then:(void (^)(BOOL success))then
{
    PROGRESS_HUD_SHOW
    [NET_REQUEST_MANAGER getUnbindBankcardWhitPaymentId:bankCardModel.uuid.stringValue success:^(id response) {
        PROGRESS_HUD_DISMISS
        FYLog(NSLocalizedString(@"解绑银行卡成功 => \n%@", nil), response);
        if (!NET_REQUEST_SUCCESS(response)) {
            !then ?: then(NO);
        } else {
            !then ?: then(YES);
        }
    } fail:^(id error) {
        PROGRESS_HUD_DISMISS
        ALTER_HTTP_ERROR_MESSAGE(error)
        FYLog(NSLocalizedString(@"解绑银行卡失败 => \n%@", nil), error);
        !then ?: then(NO);
    }];
}


@end

