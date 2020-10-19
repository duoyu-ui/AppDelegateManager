//
//  FYRedEnvelopeCoreViewController.h
//  ProjectCSHB
//
//  Created by fangyuan on 2020/7/23.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "CFCBaseCoreViewController.h"
@class FYRedEnvelopeCoreTableHeader;

NS_ASSUME_NONNULL_BEGIN

@interface FYRedEnvelopeCoreViewController : CFCBaseCoreViewController

/// 游戏类型（0：福利群；1：扫雷群；2：牛牛群；3：禁抢；4：抢庄牛牛群；5：二八杠；6：龙虎斗；7：接龙红包；8：二人牛牛；9:超级扫雷；10:包包彩；11:包包牛）
@property(nonatomic, assign) GroupTemplateType type;
/// 红包 ID
@property(nonatomic, copy) NSString *packetId;


/// 列表详情
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *tableDataSource;
/// 倒计时间
@property (nonatomic, assign) NSInteger countDownTimes;

/// 倒计时间
- (void)scheduledTimerCountDown;
- (void)timerCountDownClear;

/// 网络数据
- (Act)getRequestInfoAct;
- (NSMutableDictionary *)getRequestParamerter;
- (NSMutableArray *)loadNetworkDataResponse:(id)response;

/// 设置表格
- (void)tableViewRefreshSetting:(UITableView *)tableView;
- (FYRedEnvelopeCoreTableHeader *)tableViewRefreshHeaderView;
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;

@end

NS_ASSUME_NONNULL_END
