//
//  FYCenterMainViewController.m
//  ProjectCSHB
//
//  Created by fangyuan on 2020/5/14.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "FYCenterMainViewController+EmptyDataSet.h"
#import "FYCenterMainViewController.h"
#import "FYCenterTableSectionHeader.h"
#import "FYCenterTableHeaderView.h"
#import "FYCenterMenuAgentTableViewCell.h"
#import "FYCenterMenuServiceTableViewCell.h"
#import "FYCenterMenuReportTableViewCell.h"
#import "FYCenterMenuSectionModel.h"
// 跳转
#import "FYVIPRuleViewController.h"  // VIP会员
#import "FYYEBViewController.h"  // 余额宝
#import "FYAddBankcardViewController.h" // 添加银行卡
#import "FYWithdrawMoneyViewController.h" // 提款中心
#import "FYTransferMoneyViewController.h" // 转账交易
#import "FYActivityMainViewController.h" // 活动奖励
#import "FYBillingRecordViewController.h" // 账单明细
#import "FYPersonStaticViewController.h" // 个人汇总
#import "FYUserQRCodeViewController.h" // 二维码
#import "FYAgentCenterViewController.h" // 代理中心
#import "FYAgentOpenAccountViewController.h" // 代理开户
#import "FYAgentReferralsViewController.h" // 我的下线
#import "FYAgentReportViewController.h" // 代理报表
#import "FYGameReportViewController.h" // 游戏报表
#import "FYAgentRuleViewController.h" // 代理规则
#import "CopyViewController.h"  // 推广文案


@interface FYCenterMainViewController () <FYCenterTableHeaderViewDelegate, FYCenterMenuServiceTableViewCellDelegate, FYCenterMenuAgentTableViewCellDelegate, FYCenterMenuReportTableViewCellDelegate>
//
@property (assign, nonatomic) CGFloat tableHeaderHeight;
@property (strong, nonatomic) FYCenterTableHeaderView *tableHeaderView;

@end


@implementation FYCenterMainViewController

#pragma mark - Actions

/// 系统设置
- (void)pressNavBarButtonActionSetting:(id)sender
{
    SystemSettingsController *viewController = [[SystemSettingsController alloc] init];
    [self.navigationController pushViewController:viewController animated:YES];
}

/// 联系客服
- (void)pressNavBarButtonActionCustomer:(id)sender
{
    NSString *urlString = [AppModel shareInstance].commonInfo[@"pop"];
    FYWebViewController *viewController = [[FYWebViewController alloc] initWithUrl:urlString];
    [viewController setTitle:NSLocalizedString(@"在线客服", nil)];
    [self.navigationController pushViewController:viewController animated:YES];
}

/// 二维码
- (void)pressNavBarButtonActionMyQRCode:(id)sender
{
    FYUserQRCodeViewController *viewController = [[FYUserQRCodeViewController alloc] init];
    [self.navigationController pushViewController:viewController animated:YES];
}

/// 版本更新
- (void)pressNavBarButtonActionVersion:(id)sender
{
    NSString *systemVersion = [FUNCTION_MANAGER getApplicationVersion];
    NSString *serviceVersion = [APPINFORMATION.commonInfo stringForKey:@"ios.version"];
    //
    NSCharacterSet *characterSet = [NSCharacterSet characterSetWithCharactersInString:@"Vv.\n"];
    NSString *systemVersion1 = [[systemVersion componentsSeparatedByCharactersInSet:characterSet] componentsJoinedByString:@""];
    NSString *serviceVersion1 = [[serviceVersion componentsSeparatedByCharactersInSet:characterSet] componentsJoinedByString:@""];
    //
    if (systemVersion1.floatValue >= serviceVersion1.floatValue) {
        
        NSString *messge =[NSString stringWithFormat:@"%@ V%@", NSLocalizedString(@"已是最新版本QG", nil),systemVersion];
        ALTER_INFO_MESSAGE(messge)
    } else {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"更新最新版本", nil) message:nil preferredStyle:UIAlertControllerStyleAlert];
        // 取消
        UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"取消", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"确定", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSString *downloadpath = [APPINFORMATION.commonInfo stringForKey:@"ios.download.path"];
            if (VALIDATE_STRING_EMPTY(downloadpath)) {
                ALTER_INFO_MESSAGE(NSLocalizedString(@"下载地址出错", nil))
            } else {
                FYLog(NSLocalizedString(@"下载地址：%@", nil), downloadpath);
                if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:downloadpath]]){
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:downloadpath]];
                } else {
                    ALTER_INFO_MESSAGE(NSLocalizedString(@"打开下载地址出错", nil))
                }
            }
        }];
        [alertController addAction:cancleAction];
        [alertController addAction:confirmAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

/// 个人信息
- (void)pressNavBarButtonActionUserHeader
{
    if ([[AppModel shareInstance] isGuest]) {
        return;
    }
    
    PersonalSettingsController *viewController = [[PersonalSettingsController alloc] init];
    [self.navigationController pushViewController:viewController animated:YES];
}

/// VIP规则
- (void)pressNavBarButtonActionUserVIP
{
    FYVIPRuleViewController *viewController = [[FYVIPRuleViewController alloc] init];
    [self.navigationController pushViewController:viewController animated:YES];
}


#pragma mark - Actions Cell

/// 我的服务
- (void)didSelectRowAtMyServiceMenuItemModel:(FYCenterMenuItemModel *)model indexPath:(NSIndexPath *)indexPath
{
   if ([[AppModel shareInstance] isGuest]) {
        return;
    }
    
    // 提款中心
    if ([STR_CENTER_MENU_ITEM_TIKUANZHONGXIN isEqualToString:model.title]) {
        if (!APPINFORMATION.userInfo.isBindMobile) {
            [self doToShowBindPhoneViewController];
            return;
        }
        if (APPINFORMATION.userInfo.isTiedCard) {
            FYWithdrawMoneyViewController *viewController = [[FYWithdrawMoneyViewController alloc] init];
            [self.navigationController pushViewController:viewController animated:YES];
        } else {
            FYAddBankcardViewController *VC = [[FYAddBankcardViewController alloc] init];
            [VC setFinishAddBankItemModelBlock:^FYAddBankCardResType(FYBankItemModel * _Nullable bankCardModel) {
                [APPINFORMATION.userInfo setIsTiedCard:YES];
                return FYAddBankCardResMyCenterToWithdraw; // 个人中心 -> 添加银行卡 -> 提现页面
            }];
            [self.navigationController pushViewController:VC animated:YES];
        }
    }
    // 转账交易
    else if ([STR_CENTER_MENU_ITEM_ZHUANZHANGJIAOYI isEqualToString:model.title]) {
        FYTransferMoneyViewController *viewController = [[FYTransferMoneyViewController alloc] init];
        [self.navigationController pushViewController:viewController animated:YES];
    }
    // 优惠活动
    else if ([STR_CENTER_MENU_ITEM_HUODONGJIANGLI isEqualToString:model.title]) {
        FYActivityMainViewController *viewController = [[FYActivityMainViewController alloc] init];
        [self.navigationController pushViewController:viewController animated:YES];
    }
    // 账单明细
    else if ([STR_CENTER_MENU_ITEM_ZHANGDANMINGXI isEqualToString:model.title]) {
#if 1
        FYBillingRecordViewController *viewController = [[FYBillingRecordViewController alloc] init];
        [self.navigationController pushViewController:viewController animated:YES];
#else
        FYMoenyRecordViewController *viewController = [[FYMoenyRecordViewController alloc] init];
        [self.navigationController pushViewController:viewController animated:YES];
#endif
    }
    // 余额宝
    else if ([STR_CENTER_MENU_ITEM_YUEBAO isEqualToString:model.title]) {
        FYYEBViewController *viewController = [[FYYEBViewController alloc] init];
        [self.navigationController pushViewController:viewController animated:YES];
    }
    // 二维码
    else if ([STR_CENTER_MENU_ITEM_ERWEIMA isEqualToString:model.title]) {
        FYUserQRCodeViewController *viewController = [[FYUserQRCodeViewController alloc] init];
        [self.navigationController pushViewController:viewController animated:YES];
    }
    // 分享赚钱
    else if ([STR_CENTER_MENU_ITEM_FENXIANGZHUANQINA isEqualToString:model.title]) {
        ShareDetailViewController *viewController = [[ShareDetailViewController alloc] init];
        [self.navigationController pushViewController:viewController animated:YES];
    }
    // 新手教程
    else if ([STR_CENTER_MENU_ITEM_XINSHOUJIAOCHENG isEqualToString:model.title]) {
        HelpCenterWebController *viewController = [[HelpCenterWebController alloc] initWithUrl:@""];
        [self.navigationController pushViewController:viewController animated:YES];
    }
    // 个人汇总
    else if ([STR_CENTER_MENU_ITEM_PERSON_STATIC isEqualToString:model.title]) {
        FYPersonStaticViewController *viewController = [[FYPersonStaticViewController alloc] init];
        [self.navigationController pushViewController:viewController animated:YES];
    }
}

/// 代理中心
- (void)didSelectRowAtMyAgentMenuItemModel:(FYCenterMenuItemModel *)model indexPath:(NSIndexPath *)indexPath
{
    if ([[AppModel shareInstance] isGuest]) {
        return;
    }
    
    // 申请代理
    if ([STR_CENTER_MENU_ITEM_SHENQINGDAILI isEqualToString:model.title]
        || [STR_CENTER_MENU_ITEM_SHENQINGDAILI_YES isEqualToString:model.title]) {
        if (1 == APPINFORMATION.userInfo.agentFlag) {
            AlertViewCus *view = [AlertViewCus createInstanceWithView:nil];
            [view showWithText:NSLocalizedString(@"您已经是代理", nil) button:NSLocalizedString(@"好的", nil) callBack:nil];
            return;
        }
        
        WEAKSELF(weakSelf)
        AccountDeleteTipPopUpView* popupView = [[AccountDeleteTipPopUpView alloc]init];
        [popupView showInApplicationKeyWindow];
        [popupView richElementsInViewWithModel:NSLocalizedString(@"是否提交申请？", nil)];
        [popupView actionBlock:^(id data) {
            [weakSelf doApplyToBeAgent];
        }];
    }
    // 代理开户
    else if ([STR_CENTER_MENU_ITEM_DALIKAIHU isEqualToString:model.title]) {
        if (0 == APPINFORMATION.userInfo.agentFlag) {
            ALTER_INFO_MESSAGE(NSLocalizedString(@"点击左边按钮申请代理", nil))
        } else {
            FYAgentOpenAccountViewController *viewController = [[FYAgentOpenAccountViewController alloc] init];
            [self.navigationController pushViewController:viewController animated:YES];
        }
    }
    // 我的下线
    else if ([STR_CENTER_MENU_ITEM_WODEXIAXIAN isEqualToString:model.title]) {
        NSString *currentUserId = [NSString stringWithFormat:@"%@", APPINFORMATION.userInfo.userId];
        FYAgentReferralsViewController *VC = [[FYAgentReferralsViewController alloc] initWithSearchMemberKey:currentUserId isFromMineCenter:YES];
        [self.navigationController pushViewController:VC animated:YES];
    }
    // 代理报表
    else if ([STR_CENTER_MENU_ITEM_DAILIBAOBIAO isEqualToString:model.title]) {
        NSString *currentUserId = [NSString stringWithFormat:@"%@", APPINFORMATION.userInfo.userId];
        FYAgentReportViewController *VC = [[FYAgentReportViewController alloc] initWithSearchMemberKey:currentUserId isFromMineCenter:YES];
        [self.navigationController pushViewController:VC animated:YES];
    }
    // 代理规则
    else if ([STR_CENTER_MENU_ITEM_DAILIGUIZE isEqualToString:model.title]) {
        FYAgentRuleViewController *VC = [[FYAgentRuleViewController alloc] init];
        [self.navigationController pushViewController:VC animated:YES];
    }
    // 推广文案
    else if ([STR_CENTER_MENU_ITEM_TUIGUANWENAN isEqualToString:model.title]) {
        CopyViewController *VC = [[CopyViewController alloc] init];
        [VC setTitle:NSLocalizedString(@"推广文案", nil)];
        [self.navigationController pushViewController:VC animated:YES];
    }
    // 复制推广链接
    else if ([STR_CENTER_MENU_ITEM_FUZHITUIGLINKURL isEqualToString:model.title]) {
        NSString *shareLinkUrl = [NSString stringWithFormat:@"%@?code=%@",APPINFORMATION.address,APPINFORMATION.userInfo.invitecode];
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = shareLinkUrl;
        NSString *message = [NSString stringWithFormat:NSLocalizedString(@"%@\n复制链接成功", nil), shareLinkUrl];
        ALTER_INFO_MESSAGE(message)
    }
    // 复制邀请码
    else if ([STR_CENTER_MENU_ITEM_FUZHIYAOQINGMA isEqualToString:model.title]) {
        NSString *content = APPINFORMATION.userInfo.invitecode;
        if (!VALIDATE_STRING_EMPTY(content)) {
            UIPasteboard *pastboard = [UIPasteboard generalPasteboard];
            pastboard.string = content;
            NSString *message = [NSString stringWithFormat:NSLocalizedString(@"邀请码：%@\n复制邀请码成功", nil), content];
            ALTER_INFO_MESSAGE(message)
        } else {
            ALTER_INFO_MESSAGE(NSLocalizedString(@"邀请码为空", nil))
        }
    }
    // 代理中心
    else if ([STR_CENTER_MENU_ITEM_DAILIZHONGXING isEqualToString:model.title]) {
        FYAgentCenterViewController *viewController = [[FYAgentCenterViewController alloc] init];
        [self.navigationController pushViewController:viewController animated:YES];
    }
}

/// 游戏报表
- (void)didSelectRowAtReportModel:(FYCenterMenuReportModel *)reportModel itemModel:(FYCenterMenuItemModel *)model
{
    if ([[AppModel shareInstance] isGuest]) {
        return;
    }
    
    if (!model.openFlag.boolValue) {
        ALTER_INFO_MESSAGE(NSLocalizedString(@"暂未开放!", nil))
        return;
    }

    FYGameReportViewController *viewController = [[FYGameReportViewController alloc] initWithGameType:reportModel.type gameSubType:model.type];
    [viewController setTitle:[NSString stringWithFormat:NSLocalizedString(@"%@报表", nil), model.name]];
    [self.navigationController pushViewController:viewController animated:YES];
}


#pragma mark - Life Cycle

- (instancetype)init
{
    self = [super init];
    if (self) {
        if (CFC_IS_IPHONE_X_OR_GREATER) {
            if (CFC_IS_IPHONE_XS) {
                _tableHeaderHeight = STATUS_NAVIGATION_BAR_HEIGHT + CFC_AUTOSIZING_WIDTH(140.0f);
            } else {
                _tableHeaderHeight = STATUS_NAVIGATION_BAR_HEIGHT + CFC_AUTOSIZING_WIDTH(150.0f);
            }
        } else {
            if (CFC_IS_IPHONE_6) {
                _tableHeaderHeight = STATUS_NAVIGATION_BAR_HEIGHT + CFC_AUTOSIZING_WIDTH(140.0f);
            } else {
                _tableHeaderHeight = STATUS_NAVIGATION_BAR_HEIGHT + CFC_AUTOSIZING_WIDTH(150.0f);
            }
        }
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
}

- (void)createUIRefreshTable:(BOOL)force
{
    // 是否创建表格
    if (!self.hasTableViewRefresh) {
        return;
    }
    
    // 表格已经存在则无需创建，直接返回；否则强制创建表格
    if (self.tableViewRefresh && !force) {
        return;
    }
    
    // 强制创建表格
    if (force && self.tableViewRefresh) {
        [self.tableViewRefresh removeFromSuperview];
        [self setTableViewRefresh:nil];
    }
    
    // 表格已经存在则无需创建，直接返回；否则强制创建表格
    if (self.tableViewRefresh && !force) {
        return;
    }
    
    // 创建表格
    {
        // 设置表格
        self.tableViewRefresh = [[UITableView alloc] initWithFrame:CGRectZero style:[self tableViewRefreshStyle]];
        self.tableViewRefresh.delegate = self;
        self.tableViewRefresh.dataSource = self;
        self.tableViewRefresh.estimatedRowHeight = 200;
        // 设置后在 iPhone5 上报错
        self.tableViewRefresh.sectionHeaderHeight = FLOAT_MIN;
        self.tableViewRefresh.sectionFooterHeight = FLOAT_MIN;
        self.tableViewRefresh.fd_debugLogEnabled = YES;
        self.tableViewRefresh.showsVerticalScrollIndicator = NO;
        self.tableViewRefresh.backgroundColor = [UIColor whiteColor];
        self.tableViewRefresh.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:self.tableViewRefresh];
        
        // 空白页展示
        self.tableViewRefresh.emptyDataSetSource = self;
        self.tableViewRefresh.emptyDataSetDelegate = self;
        
        // 表格大小
        [self.tableViewRefresh mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view.mas_left);
            make.right.equalTo(self.view.mas_right);
            make.top.equalTo(self.view.mas_top).offset(-STATUS_BAR_HEIGHT);
            if (CFC_IS_IPHONE_X_OR_GREATER) {
                if (@available(iOS 11.0, *)) {
                    if (self.isAutoLayoutSafeAreaBottom) {
                        make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
                    } else {
                        make.bottom.equalTo(self.view.mas_bottom);
                    }
                } else {
                    make.bottom.equalTo(self.view.mas_bottom);
                }
            } else {
                make.bottom.equalTo(self.view.mas_bottom);
            }
        }];
        
        // 设置背景
        UIView *backgroundView = [[UIView alloc] init];
        [backgroundView setBackgroundColor:COLOR_TABLEVIEW_BACK_VIEW_BACKGROUND_DEFAULT];
        [self.tableViewRefresh setBackgroundView:backgroundView];
        [self.tableViewRefresh setBackgroundColor:COLOR_TABLEVIEW_BACK_VIEW_BACKGROUND_DEFAULT];
        
        // 表头表尾
        [self.tableViewRefresh setTableHeaderView:self.tableHeaderView];
        [self.tableViewRefresh setTableFooterView:[[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, FLOAT_MIN)]];
        
        // 下拉刷新
        if (self.hasRefreshHeader) {
            CFCRefreshHeader *refreshHeader = [CFCRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
            [refreshHeader setTitle:CFCRefreshAutoHeaderIdleText forState:MJRefreshStateIdle];
            [refreshHeader setTitle:CFCRefreshAutoHeaderPullingText forState:MJRefreshStatePulling];
            [refreshHeader setTitle:CFCRefreshAutoHeaderRefreshingText forState:MJRefreshStateRefreshing];
            [refreshHeader.stateLabel setTextColor:COLOR_HEXSTRING(CFCRefreshAutoHeaderColor)];
            [refreshHeader.stateLabel setFont:[UIFont systemFontOfSize:CFC_AUTOSIZING_FONT(CFCRefreshAutoFooterFontSize)]];
            [refreshHeader setBackgroundColor:COLOR_TABLEVIEW_BACK_VIEW_BACKGROUND_DEFAULT];
            [self setTableViewRefreshHeader:refreshHeader];
            [self.tableViewRefresh setMj_header:refreshHeader];
        }
        
        // 设置 UITableView
        [self tableViewRefreshSetting:self.tableViewRefresh];
        
        // 必须被注册到 UITableView 中
        [self tableViewRefreshRegisterClass:self.tableViewRefresh];
    }
}

- (void)tableViewRefreshRegisterClass:(UITableView *)tableView
{
    [self.tableViewRefresh registerClass:[FYCenterMenuAgentTableViewCell class] forCellReuseIdentifier:[FYCenterMenuAgentTableViewCell reuseIdentifier]];
    [self.tableViewRefresh registerClass:[FYCenterMenuServiceTableViewCell class] forCellReuseIdentifier:[FYCenterMenuServiceTableViewCell reuseIdentifier]];
    [self.tableViewRefresh registerClass:[FYCenterMenuReportTableViewCell class] forCellReuseIdentifier:[FYCenterMenuReportTableViewCell reuseIdentifier]];
}

- (BOOL)shouldAutomaticallyForwardAppearanceMethods
{
    return NO;
}


#pragma mark - Network

- (void)loadData
{
    [self loadRequestUserInfoThen:^{
        // 刷新用户信息
        if (self.delegate_header && [self.delegate_header respondsToSelector:@selector(doAnyThingForCenterTableHeaderView:)]) {
            [self.delegate_header doAnyThingForCenterTableHeaderView:FYCenterMainProtocolFuncTypeRefreshHeaderData];
        }
        // 加载报表信息
        [super loadData];
    }];
}

- (Act)getRequestInfoAct
{
    return ActRequestListUserActivity;
}

- (NSMutableDictionary *)getRequestParamerter
{
    return @{ }.mutableCopy;
}

- (void)loadRequestUserInfoThen:(void (^)(void))then
{
    [NET_REQUEST_MANAGER requestUpdateUserInfoWithSuccess:^(id response) {
        FYLog(NSLocalizedString(@"用户数据 => \n%@", nil), response);
        !then ?: then();
    } failure:^(id error) {
        ALTER_HTTP_ERROR_MESSAGE(error)
        FYLog(NSLocalizedString(@"获取用户信息异常！ => \n%@", nil), error);
        !then ?: then();
    }];
}

- (NSMutableArray *)loadNetworkDataOrCacheData:(id)responseDataOrCacheData isCacheData:(BOOL)isCacheData
{
    FYLog(NSLocalizedString(@"个人中心 => \n%@", nil), responseDataOrCacheData);
    
    // 请求成功，解析数据
    WEAKSELF(weakSelf);
    if (!NET_REQUEST_SUCCESS(responseDataOrCacheData)) {
        weakSelf.tableDataRefresh = [FYCenterMenuSectionModel buildingDataModles];
        return weakSelf.tableDataRefresh;
    }
    
    /////////////////////////////////////////////////////////////////
    // A、组装数据 -> 开始
    /////////////////////////////////////////////////////////////////
    
    NSMutableArray<FYCenterMenuSectionModel *> *allItemModels = [NSMutableArray array];
    // 我的服务
    [allItemModels addObject:[FYCenterMenuSectionModel buildingDataModlesForMyService]];
    // 代理中心
    [allItemModels addObject:[FYCenterMenuSectionModel buildingDataModlesForAgentCenter]];
    // 游戏报表
    {
        __block NSMutableArray<FYCenterMenuReportModel *> *gameReportModels = [NSMutableArray<FYCenterMenuReportModel *> array];
        NSArray *data = NET_REQUEST_DATA(responseDataOrCacheData);
        if ([data isKindOfClass:[NSArray class]]) {
            [data enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull dict, NSUInteger idx, BOOL * _Nonnull stop) {
                FYCenterMenuReportModel *model = [FYCenterMenuReportModel mj_objectWithKeyValues:dict];
                [gameReportModels addObject:model];
            }];
            if (gameReportModels.count > 0) {
                FYCenterMenuSectionModel *itemGameReportSectionModel = [[FYCenterMenuSectionModel alloc] init];
                [itemGameReportSectionModel setTitle:NSLocalizedString(@"游戏报表", nil)];
                [itemGameReportSectionModel setList:gameReportModels];
                [allItemModels addObject:itemGameReportSectionModel];
            }
        }
    }
    
    /////////////////////////////////////////////////////////////////
    // A、组装数据 -> 结束
    /////////////////////////////////////////////////////////////////
    
    
    /////////////////////////////////////////////////////////////////
    // B、配置数据源  -> 开始
    /////////////////////////////////////////////////////////////////
    
    weakSelf.tableDataRefresh = [NSMutableArray array];
    if (allItemModels && 0 < allItemModels.count) {
        [weakSelf.tableDataRefresh addObjectsFromArray:allItemModels];
    }
    
    /////////////////////////////////////////////////////////////////
    // B、配置数据源  -> 结束
    /////////////////////////////////////////////////////////////////
    
    return weakSelf.tableDataRefresh;
}


#pragma mark - UITableViewDelegate, UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.tableDataRefresh && self.tableDataRefresh.count > 0) {
        return self.tableDataRefresh.count;
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (!self.tableDataRefresh
        || self.tableDataRefresh.count <= 0
        || self.tableDataRefresh.count <= section
        || ![self.tableDataRefresh[section] isKindOfClass:[FYCenterMenuSectionModel class]]) {
        return 0;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!self.tableDataRefresh
        || self.tableDataRefresh.count <= 0
        || self.tableDataRefresh.count <= indexPath.section
        || ![self.tableDataRefresh[indexPath.section] isKindOfClass:[FYCenterMenuSectionModel class]]) {
        return nil;
    }
    
    switch (indexPath.section) {
            // 我的服务
        case FYCenterMainTableSectionMyService: {
            FYCenterMenuSectionModel *sectionModel = self.tableDataRefresh[indexPath.section];
            FYCenterMenuServiceTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:[FYCenterMenuServiceTableViewCell reuseIdentifier]];
            if (cell == nil) {
                cell = [[FYCenterMenuServiceTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[FYCenterMenuServiceTableViewCell reuseIdentifier]];
            }
            cell.delegate = self;
            cell.indexPath = indexPath;
            cell.model = sectionModel;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
            // 代理中心
        case FYCenterMainTableSectionMyAgentCenter: {
            FYCenterMenuSectionModel *sectionModel = self.tableDataRefresh[indexPath.section];
            FYCenterMenuAgentTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:[FYCenterMenuAgentTableViewCell reuseIdentifier]];
            if (cell == nil) {
                cell = [[FYCenterMenuAgentTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[FYCenterMenuAgentTableViewCell reuseIdentifier]];
            }
            cell.delegate = self;
            cell.model = sectionModel;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
            // 游戏报表
        case FYCenterMainTableSectionMyGameReport: {
            FYCenterMenuSectionModel *sectionModel = self.tableDataRefresh[indexPath.section];
            FYCenterMenuReportTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:[FYCenterMenuReportTableViewCell reuseIdentifier]];
            if (cell == nil) {
                cell = [[FYCenterMenuReportTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[FYCenterMenuReportTableViewCell reuseIdentifier]];
            }
            cell.delegate = self;
            cell.model = sectionModel;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        default: {
            return nil;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!self.tableDataRefresh
        || self.tableDataRefresh.count <= 0
        || self.tableDataRefresh.count <= indexPath.section
        || ![self.tableDataRefresh[indexPath.section] isKindOfClass:[FYCenterMenuSectionModel class]]) {
        return FLOAT_MIN;
    }
    
    switch (indexPath.section) {
            // 我的服务
        case FYCenterMainTableSectionMyService: {
            return [self.tableViewRefresh fd_heightForCellWithIdentifier:[FYCenterMenuServiceTableViewCell reuseIdentifier] cacheByIndexPath:indexPath configuration:^(FYCenterMenuServiceTableViewCell *cell) {
                FYCenterMenuSectionModel *sectionModel = self.tableDataRefresh[indexPath.section];
                cell.model = sectionModel;
            }];
        }
            // 代理中心
        case FYCenterMainTableSectionMyAgentCenter: {
            return [self.tableViewRefresh fd_heightForCellWithIdentifier:[FYCenterMenuAgentTableViewCell reuseIdentifier] cacheByIndexPath:indexPath configuration:^(FYCenterMenuAgentTableViewCell *cell) {
                FYCenterMenuSectionModel *sectionModel = self.tableDataRefresh[indexPath.section];
                cell.model = sectionModel;
            }];
        }
            // 游戏报表
        case FYCenterMainTableSectionMyGameReport: {
            return [self.tableViewRefresh fd_heightForCellWithIdentifier:[FYCenterMenuReportTableViewCell reuseIdentifier] cacheByIndexPath:indexPath configuration:^(FYCenterMenuReportTableViewCell *cell) {
                FYCenterMenuSectionModel *sectionModel = self.tableDataRefresh[indexPath.section];
                cell.model = sectionModel;
            }];
        }
        default: {
            return FLOAT_MIN;
        }
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (!self.tableDataRefresh
        || self.tableDataRefresh.count <= 0
        || self.tableDataRefresh.count <= section
        || ![self.tableDataRefresh[section] isKindOfClass:[FYCenterMenuSectionModel class]]) {
        return nil;
    }
    
    switch (section) {
            // 我的服务
        case FYCenterMainTableSectionMyService: {
            UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableViewRefresh.frame.size.width, CFC_AUTOSIZING_MARGIN(MARGIN))];
            [headerView setBackgroundColor:COLOR_TABLEVIEW_HEADER_VIEW_BACKGROUND_DEFAULT];
            return headerView;
        }
            // 代理中心
        case FYCenterMainTableSectionMyAgentCenter: {
            
        }
            // 游戏报表
        case FYCenterMainTableSectionMyGameReport: {
            
        }
        default: {
            CGFloat tabSectionHeight = CFC_AUTOSIZING_WIDTH(45.0f);
            FYCenterMenuSectionModel *sectionModel = self.tableDataRefresh[section];
            FYCenterTableSectionHeader *headerView = [[FYCenterTableSectionHeader alloc] initWithFrame:CGRectMake(0, 0, self.tableViewRefresh.frame.size.width, tabSectionHeight) title:sectionModel.title headerHeight:tabSectionHeight];
            return headerView;
        }
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (!self.tableDataRefresh
        || self.tableDataRefresh.count <= 0
        || self.tableDataRefresh.count <= section
        || ![self.tableDataRefresh[section] isKindOfClass:[FYCenterMenuSectionModel class]]) {
        return nil;
    }
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableViewRefresh.frame.size.width, CFC_AUTOSIZING_MARGIN(MARGIN))];
    [footerView setBackgroundColor:COLOR_TABLEVIEW_FOOTER_VIEW_BACKGROUND_DEFAULT];
    return footerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (!self.tableDataRefresh
        || self.tableDataRefresh.count <= 0
        || self.tableDataRefresh.count <= section
        || ![self.tableDataRefresh[section] isKindOfClass:[FYCenterMenuSectionModel class]]) {
        return FLOAT_MIN;
    }
    
    switch (section) {
            // 我的服务
        case FYCenterMainTableSectionMyService: {
            return FLOAT_MIN;
        }
            // 代理中心
        case FYCenterMainTableSectionMyAgentCenter: {
            
        }
            // 游戏报表
        case FYCenterMainTableSectionMyGameReport: {
            
        }
        default: {
            return CFC_AUTOSIZING_WIDTH(45.0f);
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (!self.tableDataRefresh
        || self.tableDataRefresh.count <= 0
        || self.tableDataRefresh.count <= section
        || ![self.tableDataRefresh[section] isKindOfClass:[FYCenterMenuSectionModel class]]) {
        return FLOAT_MIN;
    }
    
    return CFC_AUTOSIZING_MARGIN(MARGIN);
}


#pragma mark - Navigation

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (BOOL)prefersNavigationBarHidden
{
    return YES;
}

- (NSString *)prefersNavigationBarTitleViewTitle
{
    return STR_NAVIGATION_BAR_TITLE_CENTER;
}


#pragma mark - Getter & Setter

- (FYCenterTableHeaderView *)tableHeaderView
{
    if (!_tableHeaderView) {
        _tableHeaderView = [[FYCenterTableHeaderView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.tableHeaderHeight) headerHeight:self.tableHeaderHeight parentViewController:self];
        _tableHeaderView.delegate = self;
        self.delegate_header = _tableHeaderView;
    }
    return _tableHeaderView;
}


#pragma mark - Private

- (void)doApplyToBeAgent
{
    WEAKSELF(weakSelf)
    PROGRESS_HUD_SHOW
    [NET_REQUEST_MANAGER askForToBeAgentWithSuccess:^(id response) {
        PROGRESS_HUD_DISMISS
        NSString* alterMsg = [response objectForKey:@"alterMsg"];
        if (![FunctionManager isEmpty:alterMsg]) {
            AccountDeleteTipPopUpView* popupView = [[AccountDeleteTipPopUpView alloc]init];
            [popupView showInApplicationKeyWindow];
            [popupView richElementsInViewWithModel:alterMsg];
            [popupView actionBlock:^(id data) {
                
            }];
        }
        [weakSelf loadRequestUserInfoThen:^{
            if(1 == APPINFORMATION.userInfo.agentFlag) {
                FYCenterMenuSectionModel *agentSection = [FYCenterMenuSectionModel buildingDataModlesForAgentCenter];
                [weakSelf.tableDataRefresh replaceObjectAtIndex:1 withObject:agentSection];
                dispatch_main_async_safe(^{
                    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:1];
                    [weakSelf.tableViewRefresh reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                });
            }
        }];
    } fail:^(id error) {
        PROGRESS_HUD_DISMISS
        ALTER_HTTP_ERROR_MESSAGE(error)
    }];
}

- (void)doToShowBindPhoneViewController
{
    FYPresentAlertViewController *alterVC = [FYPresentAlertViewController alertControllerWithContent:NSLocalizedString(@"请先绑定手机号", nil)];
    [alterVC setAlertTextAlignment:FYPresentAlertTextAlignmentCenter];
    [alterVC setConfirmActionBlock:^{
        FY2020ForgetController *viewController = [[FY2020ForgetController alloc] init];
        [viewController setTitle:NSLocalizedString(@"绑定手机", nil)];
        [viewController setIsNeedChangeNavigation:YES];
        [self.navigationController pushViewController:viewController animated:YES];
    }];
    [[FunctionManager getAppRootViewController] presentViewController:alterVC animated:YES completion:nil];
}


@end

