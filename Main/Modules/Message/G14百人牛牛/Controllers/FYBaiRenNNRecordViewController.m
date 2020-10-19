//
//  FYBaiRenNNRecordViewController.m
//  ProjectCSHB
//
//  Created by fangyuan on 2020/8/26.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "FYBaiRenNNRecordViewController.h"
#import "FYBaiRenNNRecordSectionHeader.h"
#import "FYBaiRenNNRecordSectionFooter.h"
#import "FYBaiRenNNRecordDetailHudView.h"
#import "FYBaiRenNNRecordTableViewCell.h"
#import "FYBaiRenNNGroupInfoModel.h"
#import "FYBaiRenNNRecordModel.h"

@interface FYBaiRenNNRecordViewController () <FYBaiRenNNRecordTableViewCellDelegate>
@property(nonatomic, strong) FYBaiRenNNGroupInfoModel *groupInfoModel;
@property(nonatomic, strong) MessageItem *messageItem;
//
@property(nonatomic, strong) FYBaiRenNNRecordSectionHeader *tableSectionHeader;
@property(nonatomic, strong) FYBaiRenNNRecordSectionFooter *tableSectionFooter;
@end

@implementation FYBaiRenNNRecordViewController

#pragma mark - Actions

- (void)didSelectRowAtBaiRenNNRecordModel:(FYBaiRenNNRecordModel *)model indexPath:(NSIndexPath *)indexPath
{
    NSDictionary *paramerter = [self getRequestParamerter];
    [FYBaiRenNNRecordDetailHudView showRecordDetailHudView:model params:paramerter];
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
    [self.tableViewRefresh registerClass:[FYBaiRenNNRecordTableViewCell class] forCellReuseIdentifier:[FYBaiRenNNRecordTableViewCell reuseIdentifier]];
}


#pragma mark - Network

- (void)loadData
{
    [self loadRequestDataThen:^{
        [super loadData];
    }];
}

- (Act)getRequestInfoAct
{
    return ActRequestBestNiuNiuGameRecords;
}

- (NSMutableDictionary *)getRequestParamerter
{
    return @{
        @"oddVersion":self.groupInfoModel.gameVersion,
        @"gameNumber":self.groupInfoModel.gameNumber,
        @"groupId":self.messageItem.groupId,
        @"userId":APPINFORMATION.userInfo.userId
    }.mutableCopy;
}

- (void)loadRequestDataThen:(void (^)(void))then
{
    if (self.isShowLoadingHUD) {
        PROGRESS_HUD_SHOW
    }
    [self loadRequestOtherDataThen:^(BOOL success, FYBaiRenNNGroupInfoModel *model) {
        if (self.isShowLoadingHUD) {
            PROGRESS_HUD_DISMISS
        }
        !then ?: then();
    }];
}

- (void)loadRequestOtherDataThen:(void (^)(BOOL success, FYBaiRenNNGroupInfoModel *model))then
{
    WEAKSELF(weakSelf)
    NSDictionary *parameters = @{
        @"groupId":self.messageItem.groupId,
        @"userId":APPINFORMATION.userInfo.userId
    };
    [NET_REQUEST_MANAGER requestWithAct:ActRequestBestNiuNiuInfo parameters:parameters success:^(id response) {
        FYLog(NSLocalizedString(@"百人牛牛群信息 => %@", nil), response);
        if (!NET_REQUEST_SUCCESS(response)) {
            !then ?: then(NO,nil);
        } else {
            NSDictionary *dicts = NET_REQUEST_DATA(response);
            FYBaiRenNNGroupInfoModel *groupInfoModel = [FYBaiRenNNGroupInfoModel mj_objectWithKeyValues:dicts];
            weakSelf.groupInfoModel = groupInfoModel;
            !then ?: then(YES,groupInfoModel);
        }
    } failure:^(id error) {
        !then ?: then(NO,nil);
        [[FunctionManager sharedInstance] handleFailResponse:error];
    }];
}

- (NSMutableArray *)loadNetworkDataOrCacheData:(id)responseDataOrCacheData isCacheData:(BOOL)isCacheData
{
    FYLog(NSLocalizedString(@"百人牛牛游戏记录 => \n%@", nil), responseDataOrCacheData);
    
    // 请求成功，解析数据
    if (!NET_REQUEST_SUCCESS(responseDataOrCacheData)) {
        self.tableDataRefresh = @[].mutableCopy;
        return self.tableDataRefresh;
    }

    // 组装数据
    NSArray<NSDictionary *> *arrayOfDicts = NET_REQUEST_DATA(responseDataOrCacheData);
    NSMutableArray<FYBaiRenNNRecordModel *> *allItemModels = [FYBaiRenNNRecordModel mj_objectArrayWithKeyValuesArray:arrayOfDicts];
    
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
    FYBaiRenNNRecordTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:[FYBaiRenNNRecordTableViewCell reuseIdentifier]];
    if (cell == nil) {
        cell = [[FYBaiRenNNRecordTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[FYBaiRenNNRecordTableViewCell reuseIdentifier]];
    }
    cell.delegate = self;
    cell.indexPath = indexPath;
    cell.model = self.tableDataRefresh[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.tableViewRefresh fd_heightForCellWithIdentifier:[FYBaiRenNNRecordTableViewCell reuseIdentifier] cacheByIndexPath:indexPath configuration:^(FYBaiRenNNRecordTableViewCell *cell) {
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
    return [FYBaiRenNNRecordSectionHeader headerViewHeight];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return self.tableDataRefresh.count > 0 ? [FYBaiRenNNRecordSectionFooter headerViewHeight] : FLOAT_MIN;
}


#pragma mark - Navigation

- (NSString *)prefersNavigationBarTitleViewTitle
{
    return NSLocalizedString(@"游戏记录", nil);
}


#pragma mark - Getter & Setter

- (FYBaiRenNNRecordSectionHeader *)tableSectionHeader
{
    if (!_tableSectionHeader) {
        CGRect frame = CGRectMake(0, 0, self.tableViewRefresh.width, [FYBaiRenNNRecordSectionHeader headerViewHeight]);
        _tableSectionHeader = [[FYBaiRenNNRecordSectionHeader alloc] initWithFrame:frame];
    }
    return _tableSectionHeader;
}

- (FYBaiRenNNRecordSectionFooter *)tableSectionFooter
{
    if (!_tableSectionFooter) {
        CGRect frame = CGRectMake(0, 0, self.tableViewRefresh.width, [FYBaiRenNNRecordSectionFooter headerViewHeight]);
        _tableSectionFooter = [[FYBaiRenNNRecordSectionFooter alloc] initWithFrame:frame title:NSLocalizedString(@"显示近20条游戏记录", nil)];
    }
    return _tableSectionFooter;
}


@end

