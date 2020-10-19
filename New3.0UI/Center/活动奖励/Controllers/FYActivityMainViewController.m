//
//  FYActivityMainViewController.m
//  ProjectCSHB
//
//  Created by fangyuan on 2020/5/26.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "FYActivityMainViewController.h"
#import "FYActivityTableViewCell.h"
#import "FYActivityModel.h"
//
#import "ActivityDetail1ViewController.h"
#import "ActivityDetail2ViewController.h"

@interface FYActivityMainViewController () <FYActivityTableViewCellDelegate>

@end

@implementation FYActivityMainViewController

#pragma mark - Actions

- (void)didSelectRowAtActivityModel:(FYActivityModel *)model
{
    NSInteger type = model.type.integerValue;
    NSDictionary *dict = [model mj_keyValues];
    if (type == RewardType_bzsz
        || type == RewardType_ztlsyj
        || type == RewardType_yqhycz
        || type == RewardType_czjl
        || type == RewardType_zcdljl) { // 6000豹子顺子奖励 5000直推流水佣金 1110邀请好友充值 1100充值奖励 2100注册登录奖励
        ActivityDetail1ViewController *VC = [[ActivityDetail1ViewController alloc] init];
        [VC setTop:YES];
        [VC setInfoDic:dict];
        [VC setHiddenNavBar:YES];
        [VC setImageUrl:model.bodyImg];
        [VC setTitle:model.mainTitle];
        [VC setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:VC animated:YES];
    } else if (type == RewardType_fbjl
               ||type == RewardType_qbjl
               ||type == RewardType_jjj) { // 3000发包奖励 4000抢包奖励 7000救济金
        ActivityDetail2ViewController *VC = [[ActivityDetail2ViewController alloc] init];
        [VC setInfoDic:dict];
        [VC setTitle:model.mainTitle];
        [VC setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:VC animated:YES];
    }else if (type == RewardType_xydzp){
        WebViewController *web = [[WebViewController alloc]initWithUrl:model.linkUrl];
        [web setTitle:model.mainTitle];
        [web setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:web animated:YES];
    } else {
        if (model.linkUrl != nil && [model.linkUrl hasPrefix:@"http"]) {
            WebViewController *web = [[WebViewController alloc]initWithUrl:model.linkUrl];
            [web setTitle:model.mainTitle];
            [web setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:web animated:YES];
        }else{
            ImageDetailViewController *VC = [[ImageDetailViewController alloc] init];
            [VC setHiddenNavBar:YES];
            [VC setImageUrl:VALIDATE_STRING_EMPTY(model.bodyImg)?@"":model.bodyImg];
            [VC setTitle:model.mainTitle];
            [VC setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:VC animated:YES];
        }
    }
}


#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
}

- (void)tableViewRefreshRegisterClass:(UITableView *)tableView
{
    [self.tableViewRefresh registerClass:[FYActivityTableViewCell class] forCellReuseIdentifier:CELL_IDENTIFIER_ACTIVITY_TABLEVIEW_CELL];
}


#pragma mark - Network

- (Act)getRequestInfoAct
{
    return ActRequestActivityList2;
}

- (NSMutableDictionary *)getRequestParamerter
{
    return @{ @"size": @"20",
              @"sort": @"id",
              @"isAsc": @"false",
              @"current": @"1"
    }.mutableCopy;
}

- (NSMutableArray *)loadNetworkDataOrCacheData:(id)responseDataOrCacheData isCacheData:(BOOL)isCacheData
{
    FYLog(NSLocalizedString(@"优惠活动 => \n%@", nil), responseDataOrCacheData);
    
    // 请求成功，解析数据
    WEAKSELF(weakSelf);
    if (!NET_REQUEST_SUCCESS(responseDataOrCacheData)) {
        weakSelf.tableDataRefresh = @[].mutableCopy;
        return weakSelf.tableDataRefresh;
    }

    /////////////////////////////////////////////////////////////////
    // A、组装数据 -> 开始
    /////////////////////////////////////////////////////////////////
    
    __block NSMutableArray<FYActivityModel *> *allItemModels = [NSMutableArray<FYActivityModel *> array];
    NSDictionary *data = NET_REQUEST_DATA(responseDataOrCacheData);
    [data[@"records"] enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull dict, NSUInteger idx, BOOL * _Nonnull stop) {
        FYActivityModel *model = [FYActivityModel mj_objectWithKeyValues:dict];
        [allItemModels addObj:model];
    }];
    
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
    return self.tableDataRefresh.count > 0 ? 1 : 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (!self.tableDataRefresh || self.tableDataRefresh.count <= 0) {
        return 0;
    }
    return self.tableDataRefresh.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!self.tableDataRefresh
        || self.tableDataRefresh.count <= 0
        || self.tableDataRefresh.count <= indexPath.row) {
        return nil;
    }
    
    FYActivityTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFIER_ACTIVITY_TABLEVIEW_CELL];
    if (cell == nil) {
        cell = [[FYActivityTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELL_IDENTIFIER_ACTIVITY_TABLEVIEW_CELL];
    }
    cell.delegate = self;
    cell.model = self.tableDataRefresh[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!self.tableDataRefresh
        || self.tableDataRefresh.count <= 0
        || self.tableDataRefresh.count <= indexPath.row) {
        return FLOAT_MIN;
    }
    
    return [self.tableViewRefresh fd_heightForCellWithIdentifier:CELL_IDENTIFIER_ACTIVITY_TABLEVIEW_CELL cacheByIndexPath:indexPath configuration:^(FYActivityTableViewCell *cell) {
        cell.model = self.tableDataRefresh[indexPath.row];
    }];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (!self.tableDataRefresh
        || self.tableDataRefresh.count <= 0) {
        return nil;
    }
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableViewRefresh.frame.size.width, CFC_AUTOSIZING_MARGIN(MARGIN))];
    [headerView setBackgroundColor:COLOR_TABLEVIEW_HEADER_VIEW_BACKGROUND_DEFAULT];
    return headerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (!self.tableDataRefresh
        || self.tableDataRefresh.count <= 0) {
        return nil;
    }
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableViewRefresh.frame.size.width, CFC_AUTOSIZING_MARGIN(MARGIN))];
    [footerView setBackgroundColor:COLOR_TABLEVIEW_FOOTER_VIEW_BACKGROUND_DEFAULT];
    return footerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (!self.tableDataRefresh
        || self.tableDataRefresh.count <= 0) {
        return FLOAT_MIN;
    }
    
    return CFC_AUTOSIZING_MARGIN(MARGIN);
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (!self.tableDataRefresh
        || self.tableDataRefresh.count <= 0) {
        return FLOAT_MIN;
    }
    
    return FLOAT_MIN;
}



#pragma mark - Navigation

- (NSString *)prefersNavigationBarTitleViewTitle
{
    return STR_NAVIGATION_BAR_TITLE_YOUHUI_ACTIVITY;
}


@end

