//
//  FYBagLotteryRedGrapController.m
//  ProjectCSHB
//
//  Created by fangyuan on 2020/7/24.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "FYBagLotteryRedGrapController.h"
#import "FYBagLotteryRedGrapTableViewCell.h"
#import "FYBagLotteryRedGrapTableHeader.h"
#import "FYBagLotteryRedGrapResponse.h"

@interface FYBagLotteryRedGrapController ()
@property (nonatomic, strong) FYBagLotteryRedGrapResponse *redEnvelopeResponse;
@property (nonatomic, strong) FYBagLotteryRedGrapTableHeader *tableHeaderView;
@end

@implementation FYBagLotteryRedGrapController

#pragma mark - Life Cycle

- (void)tableViewRefreshSetting:(UITableView * _Nonnull)tableView
{
    [tableView registerClass:[FYBagLotteryRedGrapTableViewCell class] forCellReuseIdentifier:[FYBagLotteryRedGrapTableViewCell reuseIdentifier]];
}

- (FYBagLotteryRedGrapTableHeader *)tableViewRefreshHeaderView
{
    return self.tableHeaderView;
}


#pragma mark - Network

- (Act)getRequestInfoAct
{
    return ActRequestBagBagLotteryGrapDetail;
}

- (NSMutableDictionary *)getRequestParamerter
{
    return @{ @"packetId": self.packetId }.mutableCopy;
}

- (NSMutableArray *)loadNetworkDataResponse:(id)response
{
    FYLog(NSLocalizedString(@"包包彩红包详情 => \n%@", nil), response);
    
    if (!NET_REQUEST_SUCCESS(response)) {
        self.tableDataSource = @[].mutableCopy;
        return self.tableDataSource;
    }

    self.redEnvelopeResponse = [FYBagLotteryRedGrapResponse mj_objectWithKeyValues:response];
    
    /// 倒计时
    if (self.redEnvelopeResponse.data.items.count >= 6) {
        self.redEnvelopeResponse.data.overFlag = YES;
        self.countDownTimes = 0;
        [self timerCountDownClear];
    } else {
        self.redEnvelopeResponse.data.overFlag = NO;
        if (self.redEnvelopeResponse.data.exceptOverdueTime > 0) {
            self.countDownTimes = self.redEnvelopeResponse.data.exceptOverdueTime;
            [self scheduledTimerCountDown];
        }
    }
    
    /// 抢包钱的总和
    {
        __block NSMutableArray<NSString *> *allMoneys = [NSMutableArray array];
        [self.redEnvelopeResponse.data.items enumerateObjectsUsingBlock:^(FYBagLotteryRedGrapModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [allMoneys addObj:[obj.money stringByReplacingOccurrencesOfString:@"*" withString:@"0"]];
        }];
        CGFloat sumMoneyValue = [[allMoneys valueForKeyPath:@"@sum.floatValue"] floatValue]; /// 抢包钱的总和
        [self.tableHeaderView refreshWithDetailModel:self.redEnvelopeResponse.data sumMoney:sumMoneyValue money:@""];
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
    FYBagLotteryRedGrapTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:[FYBagLotteryRedGrapTableViewCell reuseIdentifier]];
    if (cell == nil) {
        cell = [[FYBagLotteryRedGrapTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[FYBagLotteryRedGrapTableViewCell reuseIdentifier]];
    }
    [cell setCellModel:self.tableDataSource[indexPath.row] type:self.type];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [FYBagLotteryRedGrapTableViewCell height];
}


#pragma mark - Getter & Setter

- (FYBagLotteryRedGrapTableHeader *)tableHeaderView
{
    if (!_tableHeaderView) {
        CGRect frame = CGRectMake(0, 0, self.tableView.width, [FYBagLotteryRedGrapTableHeader headerHeight:self.type]);
        _tableHeaderView = [[FYBagLotteryRedGrapTableHeader alloc] initWithFrame:frame type:self.type];
    }
    return _tableHeaderView;
}


@end

