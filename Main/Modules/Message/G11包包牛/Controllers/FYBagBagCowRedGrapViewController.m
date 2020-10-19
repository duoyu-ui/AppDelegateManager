//
//  FYBagBagCowRedGrapViewController.m
//  ProjectCSHB
//
//  Created by fangyuan on 2020/7/23.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "FYBagBagCowRedGrapViewController.h"
#import "FYBagBagCowRedGrapTableViewCell.h"
#import "FYBagBagCowRedGrapTableHeader.h"
#import "FYBagBagCowRedGrapResponse.h"

@interface FYBagBagCowRedGrapViewController ()
@property (nonatomic, strong) FYBagBagCowRedGrapResponse *redEnvelopeResponse;
@property (nonatomic, strong) FYBagBagCowRedGrapTableHeader *tableHeaderView;
@end

@implementation FYBagBagCowRedGrapViewController

#pragma mark - Life Cycle

- (void)tableViewRefreshSetting:(UITableView * _Nonnull)tableView
{
    [tableView registerClass:[FYBagBagCowRedGrapTableViewCell class] forCellReuseIdentifier:[FYBagBagCowRedGrapTableViewCell reuseIdentifier]];
}

- (FYBagBagCowRedGrapTableHeader *)tableViewRefreshHeaderView
{
    return self.tableHeaderView;
}


#pragma mark - Network

- (Act)getRequestInfoAct
{
    return ActRequestBagBagCowGrapDetail;
}

- (NSMutableDictionary *)getRequestParamerter
{
    return @{ @"packetId": self.packetId }.mutableCopy;
}

- (NSMutableArray *)loadNetworkDataResponse:(id)response
{
    FYLog(NSLocalizedString(@"包包牛红包详情 => \n%@", nil), response);
    
    if (!NET_REQUEST_SUCCESS(response)) {
        self.tableDataSource = @[].mutableCopy;
        return self.tableDataSource;
    }

    self.redEnvelopeResponse = [FYBagBagCowRedGrapResponse mj_objectWithKeyValues:response];
    
    /// 倒计时
    if (self.redEnvelopeResponse.data.items.count >= 3) {
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
        [self.redEnvelopeResponse.data.items enumerateObjectsUsingBlock:^(FYBagBagCowRedGrapModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
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
    FYBagBagCowRedGrapTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:[FYBagBagCowRedGrapTableViewCell reuseIdentifier]];
    if (cell == nil) {
        cell = [[FYBagBagCowRedGrapTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[FYBagBagCowRedGrapTableViewCell reuseIdentifier]];
    }
    [cell setCellModel:self.tableDataSource[indexPath.row] type:self.type];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [FYBagBagCowRedGrapTableViewCell height];
}


#pragma mark - Getter & Setter

- (FYBagBagCowRedGrapTableHeader *)tableHeaderView
{
    if (!_tableHeaderView) {
        CGRect frame = CGRectMake(0, 0, self.tableView.width, [FYBagBagCowRedGrapTableHeader headerHeight:self.type]);
        _tableHeaderView = [[FYBagBagCowRedGrapTableHeader alloc] initWithFrame:frame type:self.type];
    }
    return _tableHeaderView;
}


@end

