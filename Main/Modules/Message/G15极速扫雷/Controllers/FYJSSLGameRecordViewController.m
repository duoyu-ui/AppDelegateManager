//
//  FYJSSLGameRecordViewController.m
//  ProjectCSHB
//
//  Created by fangyuan on 2020/8/28.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "FYJSSLGameRecordViewController.h"
#import "FYJSSLGameRecordSectionHeader.h"
#import "FYJSSLGameRecordSectionFooter.h"
#import "FYJSSLGameRecordDetailHudView.h"
#import "FYJSSLGameRecordTableViewCell.h"
#import "FYJSSLGameRecordModel.h"

@interface FYJSSLGameRecordViewController () <FYJSSLGameRecordTableViewCellDelegate>
@property(nonatomic, strong) MessageItem *messageItem;
//
@property(nonatomic, strong) FYJSSLGameRecordSectionHeader *tableSectionHeader;
@property(nonatomic, strong) FYJSSLGameRecordSectionFooter *tableSectionFooter;
@end

@implementation FYJSSLGameRecordViewController

#pragma mark - Actions

- (void)didSelectRowAtJSSLGameRecordModel:(FYJSSLGameRecordModel *)model indexPath:(NSIndexPath *)indexPath
{
    NSDictionary *paramerter = [self getRequestParamerter];
    [FYJSSLGameRecordDetailHudView showRecordDetailHudView:model params:paramerter];
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
    [self.tableViewRefresh registerClass:[FYJSSLGameRecordTableViewCell class] forCellReuseIdentifier:[FYJSSLGameRecordTableViewCell reuseIdentifier]];
}


#pragma mark - Network

- (Act)getRequestInfoAct
{
    return ActRequestJsslGameRecords;
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
    FYLog(NSLocalizedString(@"极速扫雷游戏记录 => \n%@", nil), responseDataOrCacheData);
    
    // 请求成功，解析数据
    if (!NET_REQUEST_SUCCESS(responseDataOrCacheData)) {
        self.tableDataRefresh = @[].mutableCopy;
        return self.tableDataRefresh;
    }

    // 组装数据
    NSArray<NSDictionary *> *arrayOfDicts = NET_REQUEST_DATA(responseDataOrCacheData);
    NSMutableArray<FYJSSLGameRecordModel *> *allItemModels = [FYJSSLGameRecordModel mj_objectArrayWithKeyValuesArray:arrayOfDicts];
    
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
    FYJSSLGameRecordTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:[FYJSSLGameRecordTableViewCell reuseIdentifier]];
    if (cell == nil) {
        cell = [[FYJSSLGameRecordTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[FYJSSLGameRecordTableViewCell reuseIdentifier]];
    }
    cell.delegate = self;
    cell.indexPath = indexPath;
    cell.model = self.tableDataRefresh[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.tableViewRefresh fd_heightForCellWithIdentifier:[FYJSSLGameRecordTableViewCell reuseIdentifier] cacheByIndexPath:indexPath configuration:^(FYJSSLGameRecordTableViewCell *cell) {
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
    return [FYJSSLGameRecordSectionHeader headerViewHeight];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return self.tableDataRefresh.count > 0 ? [FYJSSLGameRecordSectionFooter headerViewHeight] : FLOAT_MIN;
}


#pragma mark - Navigation

- (NSString *)prefersNavigationBarTitleViewTitle
{
    return NSLocalizedString(@"游戏记录", nil);
}


#pragma mark - Getter & Setter

- (FYJSSLGameRecordSectionHeader *)tableSectionHeader
{
    if (!_tableSectionHeader) {
        CGRect frame = CGRectMake(0, 0, self.tableViewRefresh.width, [FYJSSLGameRecordSectionHeader headerViewHeight]);
        _tableSectionHeader = [[FYJSSLGameRecordSectionHeader alloc] initWithFrame:frame];
    }
    return _tableSectionHeader;
}

- (FYJSSLGameRecordSectionFooter *)tableSectionFooter
{
    if (!_tableSectionFooter) {
        CGRect frame = CGRectMake(0, 0, self.tableViewRefresh.width, [FYJSSLGameRecordSectionFooter headerViewHeight]);
        _tableSectionFooter = [[FYJSSLGameRecordSectionFooter alloc] initWithFrame:frame title:NSLocalizedString(@"显示近20条游戏记录", nil)];
    }
    return _tableSectionFooter;
}


@end

