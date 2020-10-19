//
//  FYBagLotteryRecordController.m
//  ProjectCSHB
//
//  Created by fangyuan on 2020/7/24.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "FYBagLotteryRecordController.h"
#import "FYBagLotteryRecordSectionHeader.h"
#import "FYBagLotteryRecordSectionFooter.h"
#import "FYBagLotteryRecordTableViewCell.h"
#import "FYBagLotteryRecordModel.h"
#import "FYBagLotteryGroupInfoModel.h"
#import "FYBagLotteryRedGrapController.h"

@interface FYBagLotteryRecordController () <FYBagLotteryRecordTableViewCellDelegate>
@property(nonatomic, strong) FYBagLotteryGroupInfoModel *groupInfoModel;
@property(nonatomic, strong) MessageItem *messageItem;
//
@property(nonatomic, strong) FYBagLotteryRecordSectionHeader *tableSectionHeader;
@property(nonatomic, strong) FYBagLotteryRecordSectionFooter *tableSectionFooter;
@end

@implementation FYBagLotteryRecordController

#pragma mark - Actions

- (void)didSelectRowAtBagLotteryRecordModel:(FYBagLotteryRecordModel *)model indexPath:(NSIndexPath *)indexPath
{
    FYBagLotteryRedGrapController *VC = [[FYBagLotteryRedGrapController alloc]init];
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
    [self.tableViewRefresh registerClass:[FYBagLotteryRecordTableViewCell class] forCellReuseIdentifier:[FYBagLotteryRecordTableViewCell reuseIdentifier]];
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
    return ActRequestBagBagLotteryGameRecords;
}

- (NSMutableDictionary *)getRequestParamerter
{
    return @{
        @"oddVersion":self.groupInfoModel.oddsVerion,
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
    [self loadRequestOtherDataThen:^(BOOL success, FYBagLotteryGroupInfoModel *model) {
        if (self.isShowLoadingHUD) {
            PROGRESS_HUD_DISMISS
        }
        !then ?: then();
    }];
}

- (void)loadRequestOtherDataThen:(void (^)(BOOL success, FYBagLotteryGroupInfoModel *model))then
{
    WEAKSELF(weakSelf)
    NSDictionary *parameters = @{
        @"groupId":self.messageItem.groupId,
        @"userId":APPINFORMATION.userInfo.userId
    };
    [NET_REQUEST_MANAGER requestWithAct:ActRequestBagBagLotteryInfo parameters:parameters success:^(id response) {
        FYLog(NSLocalizedString(@"包包彩群信息 => %@", nil), response);
        if (!NET_REQUEST_SUCCESS(response)) {
            !then ?: then(NO,nil);
        } else {
            NSDictionary *dicts = NET_REQUEST_DATA(response);
            FYBagLotteryGroupInfoModel *groupInfoModel = [FYBagLotteryGroupInfoModel mj_objectWithKeyValues:dicts];
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
    FYLog(NSLocalizedString(@"包包彩游戏记录 => \n%@", nil), responseDataOrCacheData);
    
    // 请求成功，解析数据
    if (!NET_REQUEST_SUCCESS(responseDataOrCacheData)) {
        self.tableDataRefresh = @[].mutableCopy;
        return self.tableDataRefresh;
    }

    // 组装数据
    NSArray<NSDictionary *> *arrayOfDicts = NET_REQUEST_DATA(responseDataOrCacheData);
    NSMutableArray<FYBagLotteryRecordModel *> *allItemModels = [FYBagLotteryRecordModel mj_objectArrayWithKeyValuesArray:arrayOfDicts];
    
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
    FYBagLotteryRecordTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:[FYBagLotteryRecordTableViewCell reuseIdentifier]];
    if (cell == nil) {
        cell = [[FYBagLotteryRecordTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[FYBagLotteryRecordTableViewCell reuseIdentifier]];
    }
    cell.delegate = self;
    cell.indexPath = indexPath;
    cell.model = self.tableDataRefresh[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.tableViewRefresh fd_heightForCellWithIdentifier:[FYBagLotteryRecordTableViewCell reuseIdentifier] cacheByIndexPath:indexPath configuration:^(FYBagLotteryRecordTableViewCell *cell) {
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
    return [FYBagLotteryRecordSectionHeader headerViewHeight];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return self.tableDataRefresh.count > 0 ? [FYBagLotteryRecordSectionFooter headerViewHeight] : FLOAT_MIN;
}


#pragma mark - Navigation

- (NSString *)prefersNavigationBarTitleViewTitle
{
    return NSLocalizedString(@"游戏记录", nil);
}


#pragma mark - Getter & Setter

- (FYBagLotteryRecordSectionHeader *)tableSectionHeader
{
    if (!_tableSectionHeader) {
        CGRect frame = CGRectMake(0, 0, self.tableViewRefresh.width, [FYBagLotteryRecordSectionHeader headerViewHeight]);
        _tableSectionHeader = [[FYBagLotteryRecordSectionHeader alloc] initWithFrame:frame];
    }
    return _tableSectionHeader;
}

- (FYBagLotteryRecordSectionFooter *)tableSectionFooter
{
    if (!_tableSectionFooter) {
        CGRect frame = CGRectMake(0, 0, self.tableViewRefresh.width, [FYBagLotteryRecordSectionFooter headerViewHeight]);
        _tableSectionFooter = [[FYBagLotteryRecordSectionFooter alloc] initWithFrame:frame title:NSLocalizedString(@"显示近20条游戏记录", nil)];
    }
    return _tableSectionFooter;
}


@end

