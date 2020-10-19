//
//  FYAgentRuleSub3ViewController.m
//  ProjectCSHB
//
//  Created by fangyuan on 2020/7/29.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "FYAgentRuleViewController.h"
#import "FYAgentRuleSub3ViewController.h"
#import "FYAgentRuleSub3SectionFooter.h"
#import "FYAgentRuleTableViewCell.h"
#import "FYAgentRuleModel.h"

@interface FYAgentRuleSub3ViewController ()
@property(nonatomic, strong) FYAgentRuleSub3SectionFooter *tableSectionFooter;
@end

@implementation FYAgentRuleSub3ViewController

#pragma mark - Life Cycle

- (instancetype)initWithTabTitleCode:(NSString *)tabTitleCode
{
    self = [super initWithTabTitleCode:tabTitleCode];
    if (self) {
        self.hasRefreshFooter = NO;
        self.hasTableViewRefresh = YES;
        self.isAutoLayoutSafeAreaBottom = NO;
    }
    return self;
}

- (void)resetSubScrollViewSize:(CGSize)size
{
    [super resetSubScrollViewSize:size];
    
    CGRect frame = CGRectMake(0, 0, size.width, size.height);
    [self.tableViewRefresh setFrame:frame];
    [self.tableViewRefresh setContentSize:frame.size];
}

- (void)tableViewRefreshRegisterClass:(UITableView *)tableView
{
    [self.tableViewRefresh registerClass:[FYAgentRuleTableViewCell class] forCellReuseIdentifier:[FYAgentRuleTableViewCell reuseIdentifier]];
}


#pragma mark - Network

- (Act)getRequestInfoAct
{
    return ActRequesAgentBackWaterRuleInfo;
}

- (NSMutableDictionary *)getRequestParamerter
{
    return @{}.mutableCopy;
}

- (NSMutableArray *)loadNetworkDataOrCacheData:(id)responseDataOrCacheData isCacheData:(BOOL)isCacheData
{
    FYLog(NSLocalizedString(@"代理规则 => \n%@", nil), responseDataOrCacheData);
    
    // 请求成功，解析数据
    if (!NET_REQUEST_SUCCESS(responseDataOrCacheData)) {
        self.tableDataRefresh = @[].mutableCopy;
        return self.tableDataRefresh;
    }

    // 组装数据
    NSArray<NSDictionary *> *arrayOfDicts = NET_REQUEST_DATA(responseDataOrCacheData);
    NSMutableArray<FYAgentRuleModel *> *allItemModels = [FYAgentRuleModel mj_objectArrayWithKeyValuesArray:arrayOfDicts];

    // 配置数据源
    if (0 == self.offset) {
        self.tableDataRefresh = [NSMutableArray array];
        if (allItemModels && 0 < allItemModels.count) {
            [self.tableDataRefresh addObjectsFromArray:allItemModels];
        }
    } else {
        if (allItemModels && 0 < allItemModels.count) {
            [self.tableDataRefresh addObjectsFromArray:allItemModels];
        }
    }

    return self.tableDataRefresh;
}

- (void)viewDidLoadAfterLoadNetworkDataOrCacheData
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(doAnyThingForSuperViewController:)]) {
        [self.delegate doAnyThingForSuperViewController:FYScrollPageForSuperViewTypeTableEndRefresh];
    }
}


#pragma mark - FYAgentRuleViewControllerProtocol

- (void)doRefreshForAgentRuleSubController:(NSString *)tabTitleCode
{
    [self loadData];
}

- (void)doRefreshForAgentRuleSubContentTableScrollToTopAnimated:(BOOL)animated
{
   [self scrollTableToTopAnimated:animated];
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
    FYAgentRuleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[FYAgentRuleTableViewCell reuseIdentifier]];
    if (cell == nil) {
        cell = [[FYAgentRuleTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[FYAgentRuleTableViewCell reuseIdentifier]];
    }
    cell.indexPath = indexPath;
    cell.model = self.tableDataRefresh[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [FYAgentRuleTableViewCell height];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return self.tableDataRefresh.count > 0 ? self.tableSectionFooter : [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return self.tableDataRefresh.count > 0 ? [FYAgentRuleSub3SectionFooter headerViewHeight] : FLOAT_MIN;
}


#pragma mark - Getter & Setter

- (FYAgentRuleSub3SectionFooter *)tableSectionFooter
{
    if (!_tableSectionFooter) {
        CGRect frame = CGRectMake(0, 0, self.tableViewRefresh.width, [FYAgentRuleSub3SectionFooter headerViewHeight]);
        _tableSectionFooter = [[FYAgentRuleSub3SectionFooter alloc] initWithFrame:frame title:NSLocalizedString(@"注：此处为全局统一返水比例，不展示个人返水比例。", nil)];
    }
    return _tableSectionFooter;
}

@end

