//
//  FYRedEnvelopePublicViewController.m
//  ProjectCSHB
//
//  Created by fangyuan on 2020/7/23.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "FYRedEnvelopePublicViewController.h"
#import "FYRedEnvelopePublickTableViewCell.h"
#import "FYRedEnvelopePublickTableHeader.h"
#import "FYRedEnvelopePublickResponse.h"

@interface FYRedEnvelopePublicViewController ()
@property (nonatomic, strong) FYRedEnvelopePublickResponse *redEnvelopeResponse;
@property (nonatomic, strong) FYRedEnvelopePublickTableHeader *tableHeaderView;
@end

@implementation FYRedEnvelopePublicViewController

#pragma mark - Life Cycle

- (void)tableViewRefreshSetting:(UITableView * _Nonnull)tableView
{
    [tableView registerClass:[FYRedEnvelopePublickTableViewCell class] forCellReuseIdentifier:[FYRedEnvelopePublickTableViewCell reuseIdentifier]];
}

- (FYRedEnvelopePublickTableHeader *)tableViewRefreshHeaderView
{
    return self.tableHeaderView;
}


#pragma mark - Network

- (Act)getRequestInfoAct
{
    return ActRedpacketDetail;
}

- (NSMutableDictionary *)getRequestParamerter
{
    return @{ @"packetId": self.packetId }.mutableCopy;
}

- (NSMutableArray *)loadNetworkDataResponse:(id)response
{
    FYLog(NSLocalizedString(@"红包详情 => \n%@", nil), response);
    
    if (!NET_REQUEST_SUCCESS(response)) {
        self.tableDataSource = @[].mutableCopy;
        return self.tableDataSource;
    }

    /// 倒计时
    self.redEnvelopeResponse = [FYRedEnvelopePublickResponse mj_objectWithKeyValues:response];
    self.countDownTimes = self.redEnvelopeResponse.data.detail.exceptOverdueTimes;
    [self scheduledTimerCountDown];
    
    /// 抢包钱的总和
    {
        __block NSString *selfMoney;
        __block NSMutableArray<NSString *> *allMoneys = [NSMutableArray array];
        [self.redEnvelopeResponse.data.items enumerateObjectsUsingBlock:^(FYRedEnvelopePubickGrabModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [allMoneys addObj:[obj.money stringByReplacingOccurrencesOfString:@"*" withString:@"0"]];
            if ([obj.userId isEqualToString:APPINFORMATION.userInfo.userId]) {
                selfMoney = obj.money;
            }
        }];
        
        CGFloat sumMoneyValue = [[allMoneys valueForKeyPath:@"@sum.floatValue"] floatValue]; /// 抢包钱的总和
        [self.tableHeaderView refreshWithDetailModel:self.redEnvelopeResponse.data.detail sumMoney:sumMoneyValue money:selfMoney];
    }

    // 配置数据源
    self.tableDataSource = [NSMutableArray array];
    if (self.redEnvelopeResponse.data.items && 0 < self.redEnvelopeResponse.data.items.count) {
        [self.tableDataSource addObjectsFromArray:self.redEnvelopeResponse.data.items];
    }
    return self.tableDataSource;
}

#pragma mark - UITableViewDelegate & UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FYRedEnvelopePublickTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:[FYRedEnvelopePublickTableViewCell reuseIdentifier]];
    if (cell == nil) {
        cell = [[FYRedEnvelopePublickTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[FYRedEnvelopePublickTableViewCell reuseIdentifier]];
    }
    [cell setCellModel:self.tableDataSource[indexPath.row] type:self.type];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [FYRedEnvelopePublickTableViewCell height];
}


#pragma mark - Getter & Setter

- (FYRedEnvelopePublickTableHeader *)tableHeaderView
{
    if (!_tableHeaderView) {
        CGRect frame = CGRectMake(0, 0, self.tableView.width, [FYRedEnvelopePublickTableHeader headerHeight:self.type]);
        _tableHeaderView = [[FYRedEnvelopePublickTableHeader alloc] initWithFrame:frame type:self.type];
    }
    return _tableHeaderView;
}

@end
