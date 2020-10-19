//
//  FYRechargePayMoreViewController.m
//  ProjectCSHB
//
//  Created by fangyuan on 2020/5/18.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "FYRechargePayMoreViewController.h"
#import "FYPayModeTableSectionHeader.h"
#import "FYPayModeTableViewCell.h"
#import "FYPayModeSectionModel.h"
#import "FYPayModeModel.h"
// 跳转
#import "FYRechargeVerifyViewController.h"
#import "FYRechargeMoneyViewController.h"


@interface FYRechargePayMoreViewController () <FYPayModeTableViewCellDelegate>

@property (nonatomic, copy) NSString *tabPayCode;

@end

@implementation FYRechargePayMoreViewController

#pragma mark - Actions

- (void)didSelectRowAtPayModeModel:(FYPayModeModel *)model indexPath:(NSIndexPath *)indexPath
{
    if ([APPINFORMATION isGuest]) {
        return;
    }
    
    if (STR_RECHARGE_CHANNELPAY_TYPE_OFFICIAL == model.chanelType.integerValue) { // 官方
        FYRechargeVerifyViewController *viewController = [[FYRechargeVerifyViewController alloc] initWithPayModeModel:model];
        [self.navigationController pushViewController:viewController animated:YES];
    } else if (STR_RECHARGE_CHANNELPAY_TYPE_VIP == model.chanelType.integerValue) { // VIP
        FYRechargeMoneyViewController *viewController = [[FYRechargeMoneyViewController alloc] initWithPayModeModel:model];
        [self.navigationController pushViewController:viewController animated:YES];
    } else if (STR_RECHARGE_CHANNELPAY_TYPE_THIRD== model.chanelType.integerValue) { // 三方
        FYRechargeMoneyViewController *viewController = [[FYRechargeMoneyViewController alloc] initWithPayModeModel:model];
        [self.navigationController pushViewController:viewController animated:YES];
    }
}


#pragma mark - Life Cycle

- (instancetype)initWithTabPayCode:(NSString *)tabPayCode
{
    self = [super init];
    if (self) {
        _tabPayCode = tabPayCode;
    }
    return self;
}

- (UITableViewStyle)tableViewRefreshStyle
{
    return UITableViewStylePlain;
}

- (void)tableViewRefreshRegisterClass:(UITableView *)tableView
{
    [self.tableViewRefresh registerClass:[FYPayModeTableViewCell class] forCellReuseIdentifier:CELL_IDENTIFIER_PAY_MODE_TABLEVIEW_CELL];
}


#pragma mark - Network

- (Act)getRequestInfoAct
{
    return ActRequestRechargePayModeMethods;
}

- (NSMutableDictionary *)getRequestParamerter
{
    return @{ @"type" : self.tabPayCode }.mutableCopy;
}

- (NSMutableArray *)loadNetworkDataOrCacheData:(id)responseDataOrCacheData isCacheData:(BOOL)isCacheData
{
    FYLog(NSLocalizedString(@"所有通道[%@] => \n%@", nil), self.tabPayCode, responseDataOrCacheData);
    
    // 请求成功，解析数据
    WEAKSELF(weakSelf);
    if (!NET_REQUEST_SUCCESS(responseDataOrCacheData)) {
        weakSelf.tableDataRefresh = @[].mutableCopy;
        return weakSelf.tableDataRefresh;
    }

    /////////////////////////////////////////////////////////////////
    // A、组装数据 -> 开始
    /////////////////////////////////////////////////////////////////
    
    NSMutableArray<FYPayModeSectionModel *> *allItemModels = [NSMutableArray array];
    __block NSMutableArray<FYPayModeModel *> *officialModels = [NSMutableArray<FYPayModeModel *> array];
    __block NSMutableArray<FYPayModeModel *> *extensionModels = [NSMutableArray<FYPayModeModel *> array];
    NSDictionary *data = NET_REQUEST_DATA(responseDataOrCacheData);
    [data enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, NSArray<NSDictionary *> *  _Nonnull array, BOOL * _Nonnull stop) {
        [array enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull dict, NSUInteger idx, BOOL * _Nonnull stop) {
            FYPayModeModel *model = [FYPayModeModel mj_objectWithKeyValues:dict];
            if ([@"adviceChanels" isEqualToString:key]) {
                // 官方渠道
                [officialModels addObj:model];
            } else {
                // 更多渠道
                [extensionModels addObj:model];
            }
        }];
    }];
    if (officialModels.count > 0) {
        FYPayModeSectionModel *model = [[FYPayModeSectionModel alloc] init];
        [model setTitle:NSLocalizedString(@"推荐渠道", nil)];
        [model setList:[FYPayModeModel buildingDataModles:officialModels]];
        [allItemModels addObject:model];
    }
    if (extensionModels.count > 0) {
        FYPayModeSectionModel *model = [[FYPayModeSectionModel alloc] init];
        [model setTitle:NSLocalizedString(@"更多渠道", nil)];
        [model setList:[FYPayModeModel buildingDataModles:extensionModels]];
        [allItemModels addObject:model];
    }
    
    /////////////////////////////////////////////////////////////////
    // A、组装数据 -> 结束
    /////////////////////////////////////////////////////////////////
    
    
    /////////////////////////////////////////////////////////////////
    // B、配置数据源  -> 开始
    /////////////////////////////////////////////////////////////////
    
    weakSelf.tableDataRefresh = [NSMutableArray array];
    if (allItemModels && 0 < allItemModels.count) {
      [weakSelf.tableDataRefresh addObjectsFromArray:allItemModels];
    }

    /////////////////////////////////////////////////////////////////
    // B、配置数据源  -> 结束
    /////////////////////////////////////////////////////////////////
    
    return weakSelf.tableDataRefresh;
}


#pragma mark - UITableViewDelegate, UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.tableDataRefresh && self.tableDataRefresh.count > 0) {
        return self.tableDataRefresh.count;
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (!self.tableDataRefresh
        || self.tableDataRefresh.count <= 0
        || self.tableDataRefresh.count <= section
        || ![self.tableDataRefresh[section] isKindOfClass:[FYPayModeSectionModel class]]) {
        return 0;
    }
    
    FYPayModeSectionModel *sectionModel = self.tableDataRefresh[section];
    return sectionModel.list.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!self.tableDataRefresh
        || self.tableDataRefresh.count <= 0
        || self.tableDataRefresh.count <= indexPath.section
        || ![self.tableDataRefresh[indexPath.section] isKindOfClass:[FYPayModeSectionModel class]]) {
        return nil;
    }
    
    FYPayModeSectionModel *sectionModel = self.tableDataRefresh[indexPath.section];
    FYPayModeTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFIER_PAY_MODE_TABLEVIEW_CELL];
    if (cell == nil) {
        cell = [[FYPayModeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELL_IDENTIFIER_PAY_MODE_TABLEVIEW_CELL];
    }
    cell.delegate = self;
    cell.indexPath = indexPath;
    cell.model = sectionModel.list[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!self.tableDataRefresh
        || self.tableDataRefresh.count <= 0
        || self.tableDataRefresh.count <= indexPath.section
        || ![self.tableDataRefresh[indexPath.section] isKindOfClass:[FYPayModeSectionModel class]]) {
        return FLOAT_MIN;
    }
    
    return [self.tableViewRefresh fd_heightForCellWithIdentifier:CELL_IDENTIFIER_PAY_MODE_TABLEVIEW_CELL cacheByIndexPath:indexPath configuration:^(FYPayModeTableViewCell *cell) {
        FYPayModeSectionModel *sectionModel = self.tableDataRefresh[indexPath.section];
        cell.model = sectionModel.list[indexPath.row];
    }];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (!self.tableDataRefresh
        || self.tableDataRefresh.count <= 0
        || self.tableDataRefresh.count <= section
        || ![self.tableDataRefresh[section] isKindOfClass:[FYPayModeSectionModel class]]) {
        return nil;
    }
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableViewRefresh.frame.size.width, CFC_AUTOSIZING_MARGIN(MARGIN))];
     [headerView setBackgroundColor:COLOR_TABLEVIEW_HEADER_VIEW_BACKGROUND_DEFAULT];
     return headerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (!self.tableDataRefresh
        || self.tableDataRefresh.count <= 0
        || self.tableDataRefresh.count <= section
        || ![self.tableDataRefresh[section] isKindOfClass:[FYPayModeSectionModel class]]) {
        return nil;
    }
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableViewRefresh.frame.size.width, CFC_AUTOSIZING_MARGIN(MARGIN))];
    [footerView setBackgroundColor:COLOR_TABLEVIEW_FOOTER_VIEW_BACKGROUND_DEFAULT];
    return footerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (!self.tableDataRefresh
        || self.tableDataRefresh.count <= 0
        || self.tableDataRefresh.count <= section
        || ![self.tableDataRefresh[section] isKindOfClass:[FYPayModeSectionModel class]]) {
        return FLOAT_MIN;
    }
    
    return FLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (!self.tableDataRefresh
        || self.tableDataRefresh.count <= 0
        || self.tableDataRefresh.count <= section
        || ![self.tableDataRefresh[section] isKindOfClass:[FYPayModeSectionModel class]]) {
        return FLOAT_MIN;
    }
    
    return FLOAT_MIN;
}


#pragma mark - Navigation

- (NSString *)prefersNavigationBarTitleViewTitle
{
    return STR_NAVIGATION_BAR_TITLE_RECHARGE_PAY_MODE_MORE;
}


@end

