//
//  FYBillingDetailsViewController.m
//  ProjectCSHB
//
//  Created by fangyuan on 2020/6/20.
//  Copyright © 2020 Fangyuan. All rights reserved.
//
// 账单详情
//

#import "FYBillingDetailsViewController.h"
#import "FYBillingDetailsTableViewCell.h"
#import "FYBillingDetailsModel.h"

@interface FYBillingDetailsViewController ()

@end


@implementation FYBillingDetailsViewController


#pragma mark - Life Cycle

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self loadNetworkDataOrCacheData:[NSNull null] isCacheData:NO];
    [self.tableViewRefresh reloadData];
}

- (UITableViewStyle)tableViewRefreshStyle
{
    return UITableViewStylePlain;
}

- (void)tableViewRefreshRegisterClass:(UITableView *)tableView
{
    [self.tableViewRefresh registerClass:[FYBillingDetailsTableViewCell class] forCellReuseIdentifier:[FYBillingDetailsTableViewCell reuseIdentifier]];
}


#pragma mark - Network

- (Act)getRequestInfoAct
{
    return ActNil;
}

- (NSMutableDictionary *)getRequestParamerter
{
    return @{ }.mutableCopy;
}

- (NSMutableArray *)loadNetworkDataOrCacheData:(id)responseDataOrCacheData isCacheData:(BOOL)isCacheData
{
    // 初始化数据源
    self.tableDataRefresh = [NSMutableArray array];

    self.tableDataRefresh  = @[ [FYBillingDetailsModel new] ].mutableCopy;
    
    return self.tableDataRefresh;
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
    FYBillingDetailsTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:[FYBillingDetailsTableViewCell reuseIdentifier]];
    if (cell == nil) {
        cell = [[FYBillingDetailsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[FYBillingDetailsTableViewCell reuseIdentifier]];
    }
    cell.model = self.tableDataRefresh[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.tableViewRefresh fd_heightForCellWithIdentifier:[FYBillingDetailsTableViewCell reuseIdentifier] cacheByIndexPath:indexPath configuration:^(FYBillingDetailsTableViewCell *cell) {
        cell.model = self.tableDataRefresh[indexPath.row];
    }];
}


#pragma mark - Navigation

- (NSString *)prefersNavigationBarTitleViewTitle
{
    return STR_NAVIGATION_BAR_TITLE_BILLING_DETAILS;
}


@end

