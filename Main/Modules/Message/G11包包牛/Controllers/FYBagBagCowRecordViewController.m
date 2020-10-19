//
//  FYBagBagCowRecordViewController.m
//  ProjectCSHB
//
//  Created by fangyuan on 2020/7/22.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "FYBagBagCowRecordViewController.h"
#import "FYBagBagCowRecordSectionHeader.h"
#import "FYBagBagCowRecordSectionFooter.h"
#import "FYBagBagCowRecordTableViewCell.h"
#import "FYBagBagCowRecordModel.h"
#import "FYBagBagCowRedGrapViewController.h"

@interface FYBagBagCowRecordViewController () <FYBagBagCowRecordTableViewCellDelegate>
@property(nonatomic, strong) MessageItem *messageItem;
@property(nonatomic, strong) FYBagBagCowRecordSectionHeader *tableSectionHeader;
@property(nonatomic, strong) FYBagBagCowRecordSectionFooter *tableSectionFooter;
@end

@implementation FYBagBagCowRecordViewController

#pragma mark - Actions

- (void)didSelectRowAtBagBagCowRecordModel:(FYBagBagCowRecordModel *)model indexPath:(NSIndexPath *)indexPath
{
    FYBagBagCowRedGrapViewController *VC = [[FYBagBagCowRedGrapViewController alloc]init];
    VC.type = self.messageItem.type;
    VC.packetId = model.uuid;
    [self.navigationController pushViewController:VC animated:YES];
}


#pragma mark - Life Cycle

- (instancetype)initWithMessageItem:(MessageItem *)messageItem
{
    self = [super init];
    if (self) {
        _messageItem = messageItem;
        self.hasRefreshFooter = NO;
    }
    return self;
}

- (void)tableViewRefreshRegisterClass:(UITableView *)tableView
{
    [self.tableViewRefresh registerClass:[FYBagBagCowRecordTableViewCell class] forCellReuseIdentifier:[FYBagBagCowRecordTableViewCell reuseIdentifier]];
}


#pragma mark - Network

- (Act)getRequestInfoAct
{
    return ActRequestBagBagCowRecords;
}

- (NSMutableDictionary *)getRequestParamerter
{
    return @{
        @"chatId":self.messageItem.groupId,
        @"userId":APPINFORMATION.userInfo.userId
    }.mutableCopy;
}

- (NSMutableArray *)loadNetworkDataOrCacheData:(id)responseDataOrCacheData isCacheData:(BOOL)isCacheData
{
    FYLog(NSLocalizedString(@"包包牛游戏记录 => \n%@", nil), responseDataOrCacheData);
    
    // 请求成功，解析数据
    if (!NET_REQUEST_SUCCESS(responseDataOrCacheData)) {
        self.tableDataRefresh = @[].mutableCopy;
        return self.tableDataRefresh;
    }

    // 组装数据
    NSArray<NSDictionary *> *arrayOfDicts = NET_REQUEST_DATA(responseDataOrCacheData);
    NSMutableArray<FYBagBagCowRecordModel *> *allItemModels = [FYBagBagCowRecordModel mj_objectArrayWithKeyValuesArray:arrayOfDicts];
    
    // 配置数据源
    self.tableDataRefresh = [NSMutableArray array];
    if (allItemModels && 0 < allItemModels.count) {
        [self.tableDataRefresh addObjectsFromArray:allItemModels];
    }
    return self.tableDataRefresh;
}


#pragma mark - UITableViewDelegate & UITableViewDataSource

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
    FYBagBagCowRecordTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:[FYBagBagCowRecordTableViewCell reuseIdentifier]];
    if (cell == nil) {
        cell = [[FYBagBagCowRecordTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[FYBagBagCowRecordTableViewCell reuseIdentifier]];
    }
    cell.delegate = self;
    cell.indexPath = indexPath;
    cell.model = self.tableDataRefresh[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.tableViewRefresh fd_heightForCellWithIdentifier:[FYBagBagCowRecordTableViewCell reuseIdentifier] cacheByIndexPath:indexPath configuration:^(FYBagBagCowRecordTableViewCell *cell) {
        cell.model = self.tableDataRefresh[indexPath.row];
    }];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return self.tableSectionHeader;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return self.tableDataRefresh.count > 0 ? self.tableSectionFooter : [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return [FYBagBagCowRecordSectionHeader headerViewHeight];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return self.tableDataRefresh.count > 0 ? [FYBagBagCowRecordSectionFooter headerViewHeight] : FLOAT_MIN;
}


#pragma mark - Navigation

- (NSString *)prefersNavigationBarTitleViewTitle
{
    return STR_NAVIGATION_BAR_TITLE_BAGBAGCOW_RECORDS;
}


#pragma mark - Getter & Setter

- (FYBagBagCowRecordSectionHeader *)tableSectionHeader
{
    if (!_tableSectionHeader) {
        CGRect frame = CGRectMake(0, 0, self.tableViewRefresh.width, [FYBagBagCowRecordSectionHeader headerViewHeight]);
        _tableSectionHeader = [[FYBagBagCowRecordSectionHeader alloc] initWithFrame:frame];
    }
    return _tableSectionHeader;
}

- (FYBagBagCowRecordSectionFooter *)tableSectionFooter
{
    if (!_tableSectionFooter) {
        CGRect frame = CGRectMake(0, 0, self.tableViewRefresh.width, [FYBagBagCowRecordSectionFooter headerViewHeight]);
        _tableSectionFooter = [[FYBagBagCowRecordSectionFooter alloc] initWithFrame:frame title:NSLocalizedString(@"显示近20条游戏记录", nil)];
    }
    return _tableSectionFooter;
}


@end

