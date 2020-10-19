//
//  FYGamesMode1HBGroupSubController.m
//  ProjectCSHB
//
//  Created by fangyuan on 2020/7/28.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "FYScrollPageViewController.h"
#import "FYGamesMode1HBGroupController.h"
#import "FYGamesMode1HBGroupSubController.h"
#import "FYGamesMode1HBGroupSubTableViewCell.h"
#import "FYGamesMode1HBGroupSubModel.h"
#import "FYGamesMode1ClassModel.h"

@interface FYGamesMode1HBGroupSubController () <FYGamesMode1HBGroupSubTableViewCellDelegate>
@property (nonatomic, copy) NSString *tabTitleCode;
@property (nonatomic, strong) FYGamesMode1ClassModel *tabTypeModel;
@property (nonatomic, strong) EnterPwdBoxView *pwdBoxView;
@end

@implementation FYGamesMode1HBGroupSubController

#pragma mark - Actions

- (void)didSelectRowAtGamesMode1HBGroupSubModel:(FYGamesMode1HBGroupSubModel *)model indexPath:(NSIndexPath *)indexPath
{
    // 游客登录，试玩群游客可进入
    if (!model.tryPlayFlag && [APPINFORMATION isGuest]) {
        return;
    }
    
    // 左菜单控制游戏状态
    if (![self doVerifyIsCanPlayGames:model tabTypeModel:self.tabTypeModel]) {
        return;
    }
    
    // 检查验证红包游戏
    PROGRESS_HUD_SHOW
    [NET_REQUEST_MANAGER requestChatGroupOfficeVerifyJoinWithGroupId:model.groupId success:^(id response) {
        PROGRESS_HUD_DISMISS
        FYLog(NSLocalizedString(@"红包游戏 => \n%@", nil), response);
        if (![CFCSysUtil validateNetRequestResult:response]) {
           ALTER_HTTP_MESSAGE(response)
        } else {
            [self doThroughAccessWay0JoinHBGamesWithModel:model indexPath:indexPath];
        }
    } failure:^(id error) {
        PROGRESS_HUD_DISMISS
        ALTER_HTTP_ERROR_MESSAGE(error)
        FYLog(NSLocalizedString(@"进入游戏出错 => \n%@", nil), error);
    }];
}

/// 验证游戏状态
- (BOOL)doVerifyIsCanPlayGames:(FYGamesMode1HBGroupSubModel *)model tabTypeModel:(FYGamesMode1ClassModel *)tabTypeModel
{
    if (tabTypeModel.openFlag.boolValue && tabTypeModel.powerFlag.boolValue) {
        if (tabTypeModel.maintainFlag.boolValue) {
            NSString *message = [NSString stringWithFormat:NSLocalizedString(@"游戏维护中...\n%@", nil), tabTypeModel.maintTotalTime];
            ALTER_INFO_MESSAGE(message)
            return NO;
        } else {
            return YES;
        }
    } else {
        ALTER_INFO_MESSAGE(NSLocalizedString(@"敬请期待", nil))
        return NO;
    }
}

- (void)doThroughAccessWay0JoinHBGamesWithModel:(FYGamesMode1HBGroupSubModel *)model indexPath:(NSIndexPath *)indexPath
{
    // 游客登录，试玩群游客可进入
    if (!model.tryPlayFlag && [APPINFORMATION isGuest]) {
        return;
    }
    
    // 加入群组（无密码）
    [self.tableViewRefresh setAllowsSelection:NO];
    if (VALIDATE_STRING_EMPTY(model.password)) {
        UINavigationController *navigationController = self.parentViewController.navigationController;
        [FYMSG_PRECISION_MANAGER doTryToJoinGroupOfficeYes:model password:@"" from:navigationController];
        [self.tableViewRefresh setAllowsSelection:YES];
        return;
    }
    
    // 加入群组（有密码）
    WEAKSELF(weakSelf);
    self.pwdBoxView = [[EnterPwdBoxView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [self.pwdBoxView setJoinGroupBtnBlock:^(NSString * _Nonnull password) {
        UINavigationController *navigationController = weakSelf.parentViewController.navigationController;
        [FYMSG_PRECISION_MANAGER doTryToJoinGroupOfficeYes:model password:password from:navigationController];
        [weakSelf.pwdBoxView remover];
    }];
    [self.pwdBoxView showInView:self.view];
    [self.tableViewRefresh setAllowsSelection:YES];
}


#pragma mark - Life Cycle

- (instancetype)initWithTabTitleCode:(NSString *)tabTitleCode tabTypeModel:(FYGamesMode1ClassModel *)tabTypeModel
{
    self = [super init];
    if (self) {
        _tabTitleCode = tabTitleCode;
        _tabTypeModel = tabTypeModel;
        //
        self.hasRefreshFooter = NO;
        self.isAutoLayoutSafeAreaBottom = NO;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // 页面是否已经生成显示过
    if (!self.isShowLoadingHUD) {
        // 页面已经生成显示过，判断是否需要刷新
        id<FYGamesMode1HBGroupSubControllerDelegate> delegate_original = (id<FYGamesMode1HBGroupSubControllerDelegate>)self.delegate;
        if (delegate_original && [delegate_original respondsToSelector:@selector(doIsNeedRefreshFromSuperViewController)]) {
            if ([delegate_original doIsNeedRefreshFromSuperViewController]) {
                [self setIsShowLoadingHUD:YES];
                [self loadData];
            }
        }
    }
}

- (void)resetSubScrollViewSize:(CGSize)size
{
    [super resetSubScrollViewSize:size];
    
    CGRect frame = CGRectMake(0, 0, size.width, size.height);
    [self.tableViewRefresh setFrame:frame];
    [self.tableViewRefresh setContentSize:frame.size];
}

- (UITableViewStyle)tableViewRefreshStyle
{
    return UITableViewStylePlain;
}

- (void)tableViewRefreshRegisterClass:(UITableView *)tableView
{
    [self.tableViewRefresh registerClass:[FYGamesMode1HBGroupSubTableViewCell class] forCellReuseIdentifier:[FYGamesMode1HBGroupSubTableViewCell reuseIdentifier]];
}


#pragma mark - Network

- (Act)getRequestInfoAct
{
    return ActRequestlistOfficialGroup;
}

- (NSMutableDictionary *)getRequestParamerter
{
    return @{ @"type" : self.tabTitleCode }.mutableCopy;
}

- (NSMutableArray *)loadNetworkDataOrCacheData:(id)responseDataOrCacheData isCacheData:(BOOL)isCacheData
{
    FYLog(NSLocalizedString(@"官方游戏 => \n%@", nil), responseDataOrCacheData);
    
    // 请求成功，解析数据
    if (!NET_REQUEST_SUCCESS(responseDataOrCacheData)) {
        self.tableDataRefresh = @[].mutableCopy;
        return self.tableDataRefresh;
    }

    // 组装数据
    NSDictionary *data = NET_REQUEST_DATA(responseDataOrCacheData);
    NSMutableArray<FYGamesMode1HBGroupSubModel *> *allItemModels = [NSMutableArray array];
    [data[@"skChatGroups"] enumerateObjectsUsingBlock:^(NSDictionary *  _Nonnull dict, NSUInteger idx, BOOL * _Nonnull stop) {
        FYGamesMode1HBGroupSubModel *model = [FYGamesMode1HBGroupSubModel mj_objectWithKeyValues:dict];
        [allItemModels addObj:model];
    }];

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
    id<FYGamesMode1HBGroupSubControllerDelegate> delegate_original = (id<FYGamesMode1HBGroupSubControllerDelegate>)self.delegate;
    if (delegate_original && [delegate_original respondsToSelector:@selector(doAnyThingForSuperViewController:)]) {
        [delegate_original doAnyThingForSuperViewController:FYScrollPageForSuperViewTypeTableEndRefresh];
    }
}


#pragma mark - FYGamesMode1HBGroupControllerProtocol

- (void)doRefreshForHBGroupSubController:(NSString *)tabTitleCode
{
    [self setTabTitleCode:tabTitleCode];
    //
    [self loadData];
}

- (void)doRefreshForHBGroupSubContentTableScrollToTopAnimated:(BOOL)animated
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
    FYGamesMode1HBGroupSubTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[FYGamesMode1HBGroupSubTableViewCell reuseIdentifier]];
    if (cell == nil) {
        cell = [[FYGamesMode1HBGroupSubTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[FYGamesMode1HBGroupSubTableViewCell reuseIdentifier]];
    }
    cell.delegate = self;
    cell.indexPath = indexPath;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setModel:self.tableDataRefresh[indexPath.row] typeModel:self.tabTypeModel];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [FYGamesMode1HBGroupSubTableViewCell height];
}


@end

