//
//  FYGamesMode2ClassViewController.m
//  ProjectCSHB
//
//  Created by fangyuan on 2020/5/16.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "FYGamesMain2ViewController.h"
#import "FYGamesMode2ClassViewController.h"
#import "FYGamesMode2ClassViewController+EmptyDataSet.h"
#import "FYGamesStatusModel.h"
#import "FYGamesTypesModel.h"
//
#import "FYGamesClassMenuTableViewCell.h"
#import "FYGamesClassMenuModel.h"
//
#import "FYGamesClassContent1HBTableViewCell.h"
#import "FYGamesClassContent1HBModel.h"
//
#import "FYGamesClassContent2QPTableViewCell.h"
#import "FYGamesClassContent2QPModel.h"

#define kLeftTableMenuWidth SCREEN_MIN_LENGTH * 0.25
#define kRightTableContentWidth SCREEN_MIN_LENGTH * 0.75f

@interface FYGamesMode2ClassViewController () <UITableViewDelegate, UITableViewDataSource, FYGamesClassMenuTableViewCellDelegate, FYGamesClassContent1HBTableViewCellDelegate, FYGamesClassContent2QPTableViewCellDelegate, FYGamesMain2ViewControllerProtocol>
@property (nonatomic, strong) UITableView *tableViewMenu;
@property (nonatomic, strong) UITableView *tableViewContent;
@property (nonatomic, strong) EnterPwdBoxView *pwdBoxView;
@property (nonatomic, strong) FYGamesTypesModel *currentGamesTypeModel;
@property (nonatomic, strong) FYGamesClassMenuModel *currentClassMenuModel;
@property (nonatomic, strong) NSNumber *selectedMenuId; // 当前选中左菜单ID
@property (nonatomic, strong) NSMutableArray<FYGamesClassMenuModel *> *arrayOfMenuModels;
@property (nonatomic, strong) NSMutableArray<FYGamesClassContent1HBModel *> *arrayOfContent1HBModels;
@property (nonatomic, strong) NSMutableArray<FYGamesClassContent2QPModel *> *arrayOfContent2QPModels;
@property (nonatomic, strong) NSMutableArray<NSObject *> *arrayOfContentHotModels;

@end

@implementation FYGamesMode2ClassViewController

#pragma mark - Actions

- (void)didSelectRowAtGamesClassMenuModel:(FYGamesClassMenuModel *)model indexPath:(NSIndexPath *)indexPath
{
    WEAKSELF(weakSelf);
    
    //  刷新菜单状态
    __block FYGamesClassMenuModel *selectedClassMenuModel = nil;
    {
        [self.arrayOfMenuModels enumerateObjectsUsingBlock:^(FYGamesClassMenuModel * _Nonnull classMenuModel, NSUInteger idx, BOOL * _Nonnull stop) {
            [classMenuModel setIsSelected:NO];
            // 当前选中菜单项
            if (classMenuModel.uuid.integerValue == model.uuid.integerValue) {
                [classMenuModel setIsSelected:YES];
                selectedClassMenuModel = classMenuModel;
            }
            // 旧的选中菜单项
            else if (classMenuModel.uuid.integerValue == weakSelf.currentClassMenuModel.uuid.integerValue) {
                NSArray<NSIndexPath *> *indexPaths = @[[NSIndexPath indexPathForRow:idx inSection:indexPath.section]];
                dispatch_main_async_safe(^{
                    [weakSelf.tableViewMenu reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
                });
            }
        }];
        [self setSelectedMenuId:selectedClassMenuModel.uuid];
        [self setCurrentClassMenuModel:selectedClassMenuModel];
    }
    
    // 保存选中菜单下标
    if (self.delegate && [self.delegate respondsToSelector:@selector(doSaveClassMenuSelectedIndexToGamesMainVC:selectedMenuId:)]) {
        [self.delegate doSaveClassMenuSelectedIndexToGamesMainVC:self.currentGamesTypeModel.type.stringValue selectedMenuId:selectedClassMenuModel.uuid];
    } else {
        NSAssert(NO, NSLocalizedString(@"[FYGamesMain2ViewController]类必须实现代理方法[doSaveClassMenuSelectedIndexToGamesMainVC:selectedMenuId:]", nil));
    }
    
    // 刷新内容列表
    {
        // 热门游戏
        if (selectedClassMenuModel.isHotGame) {
            if (self.arrayOfContentHotModels.count > 0) {
                [self.tableViewContent reloadData];
            } else {
                [self.tableViewContent reloadData];
                [self setIsEmptyDataSetShouldDisplay:YES];
                [self.tableViewContent reloadEmptyDataSet];
            }
            return;
        }

        [self loadData];
    }
}

- (void)didSelectRowAtGamesClassContent1HBModel:(FYGamesClassContent1HBModel *)model indexPath:(NSIndexPath *)indexPath
{
    // 游客登录，试玩群游客可进入
    if (!model.tryPlayFlag && [APPINFORMATION isGuest]) {
        return;
    }
    
    // 左菜单控制游戏状态（1显示 2隐藏 3维护）
    if (![self doVerifyIsCanPlayGames:model]) {
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
            [self doThroughAccessWay0JoinHBGamesWithObj:model indexPath:indexPath];
        }
    } failure:^(id error) {
        PROGRESS_HUD_DISMISS
        ALTER_HTTP_ERROR_MESSAGE(error)
        FYLog(NSLocalizedString(@"进入游戏出错 => \n%@", nil), error);
    }];
}

- (void)didSelectRowAtGamesClassContent2QPModel:(FYGamesClassContent2QPModel *)model indexPath:(NSIndexPath *)indexPath
{
    WEAKSELF(weakSelf)
    
    if ([APPINFORMATION isGuest]) {
        return;
    }
    
    // 左菜单控制游戏状态（1显示 2隐藏 3维护）
    if (![self doVerifyIsCanPlayGames:model]) {
        return;
    }
    
    // 0:原生游戏（红包游戏），1：自己游戏（QG电子），2：三方游戏（王者棋牌，幸运棋牌，QG棋牌，开元棋牌，双赢彩票...）
    if (1 == model.accessWay.integerValue) {
        // 自己游戏（QG电子）
        NSString *parentId = model.parentId.stringValue;
        [self doCheckVerifyDZQPTypeGamesStatus:parentId then:^(BOOL success, FYGamesStatusModel *gamesStatusModel) {
            if ([weakSelf doVerifyIsCanPlayGames:gamesStatusModel]) {
                // 说明：后台返回的 model.linkUrl 值不完整，会随机性残缺。此处调用接口获取URL，确保游戏地址正确。
                [weakSelf doGeneraterSelfDianZiGamesLoginUrlWithId:model.uuid.stringValue then:^(NSString *url) {
                    [weakSelf doThroughAccessWay1JoinQPGamesWithUrlString:STR_TRI_WHITE_SPACE(url) title:model.gameName];
                }];
            }
        }];
    } else if (2 == model.accessWay.integerValue) {
        // 三方游戏（1：王者棋牌，2：幸运棋牌，3：QG棋牌，4：开元棋牌，5：双赢彩票，6：IM电竞，7：IM体育，8：AG真人，9：AG电子，10：AG捕鱼，11：KG电子）
        [self doVerifyThirdPartyGamesBalanceThen:^(BOOL success) {
            if (success) {
                NSString *parentId = model.parentId.stringValue;
                [weakSelf doCheckVerifyDZQPTypeGamesStatus:parentId then:^(BOOL success, FYGamesStatusModel *gamesStatusModel) {
                    if ([weakSelf doVerifyIsCanPlayGames:gamesStatusModel]) {
                        [weakSelf doGeneraterThirdPartyGamesLoginUrlWithGameId:model.gameId gameType:model.gameType walletId:model.productWallet linkUrl:gamesStatusModel.linkUrl then:^(NSString *url) {
                            [weakSelf doThroughAccessWay2JoinQPGamesWidthUrlString:STR_TRI_WHITE_SPACE(url) gametype:model.gameType title:model.gameName];
                        }];
                    }
                }];
            }
        }];
    }
}

- (void)doThroughAccessWay0JoinHBGamesWithObj:(FYGamesClassContent1HBModel *)model indexPath:(NSIndexPath *)indexPath
{
    // 游客登录，试玩群游客可进入
    if (!model.tryPlayFlag && [APPINFORMATION isGuest]) {
        return;
    }
    
    // 加入群组（无密码）
    [self.tableViewContent setAllowsSelection:NO];
    if (VALIDATE_STRING_EMPTY(model.password)) {
        UINavigationController *navigationController = self.parentViewController.navigationController;
        [FYMSG_PRECISION_MANAGER doTryToJoinGroupOfficeYes:model password:@"" from:navigationController];
        [self.tableViewContent setAllowsSelection:YES];
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
    [self.tableViewContent setAllowsSelection:YES];
}

- (void)doThroughAccessWay1JoinQPGamesWithUrlString:(NSString *)url title:(NSString *)title
{
    [FYAPP_PRECISION_MANAGER doTryWay1JoinQPGamesWithUrl:url title:title from:self.navigationController];
}

- (void)doThroughAccessWay2JoinQPGamesWidthUrlString:(NSString *)url gametype:(NSNumber *)gameType title:(NSString *)title
{
    [FYAPP_PRECISION_MANAGER doTryWay2JoinQPGamesWidthUrl:url gametype:gameType title:title from:self.navigationController];
}


#pragma mark - Life Cycle

- (instancetype)initWithGamesTypeModel:(FYGamesTypesModel *)gamesTypeModel selectedMenuId:(NSNumber *)selectedMenuId delegate:(id<FYGamesClassViewControllerDelegate>)delegate
{
    self = [super init];
    if (self) {
        //
        _isShowLoadingHUD = YES;
        _requestMethod = RequestType_post;
        //
        _isEmptyDataSetShouldDisplay = NO;
        _isEmptyDataSetShouldAllowScroll = YES;
        _isEmptyDataSetShouldAllowImageViewAnimate = YES;
        //
        _selectedMenuId = selectedMenuId;
        _currentGamesTypeModel = gamesTypeModel;
        //
        [self setDelegate:delegate];
        //
        [self setupDefault:gamesTypeModel];
    }
    return self;
}

- (void)setupDefault:(FYGamesTypesModel *)gamesTypeModel
{
    [self setupArrayOfMenuModels:gamesTypeModel];
    
    [self setupArrayOfContentHotModels:gamesTypeModel];
    
    // 热门数据
    if (!self.currentClassMenuModel || self.currentClassMenuModel.isHotGame) {
        if (!self.currentClassMenuModel || self.arrayOfContentHotModels.count <= 0) {
            [self.tableViewContent reloadData];
            [self setIsEmptyDataSetShouldDisplay:YES];
            [self.tableViewContent reloadEmptyDataSet];
        } else {
            [self.tableViewContent reloadData];
        }
        // 结束刷新
        [self loadData];
    }
    // 其它数据
    else {
        [self loadData];
    }
}

- (void)setupArrayOfMenuModels:(FYGamesTypesModel *)gamesTypeModel
{
    NSMutableArray<FYGamesClassMenuModel *> *itemMenuModels = [FYGamesClassMenuModel buildingDataModles:gamesTypeModel];
    if (itemMenuModels.count <= 0) {
        [self setCurrentClassMenuModel:nil];
    } else {
        WEAKSELF(weakSelf)
        __block BOOL isInitSelectdMenu = NO;
        [itemMenuModels enumerateObjectsUsingBlock:^(FYGamesClassMenuModel * _Nonnull classMenuModel, NSUInteger idx, BOOL * _Nonnull stop) {
            [classMenuModel setIsSelected:NO];
            if (weakSelf.selectedMenuId.integerValue == classMenuModel.uuid.integerValue) {
                isInitSelectdMenu = YES;
                [classMenuModel setIsSelected:YES];
                [weakSelf setCurrentClassMenuModel:classMenuModel];
            }
        }];
        if (!isInitSelectdMenu) {
            itemMenuModels = [FYGamesClassMenuModel buildingDataModles:gamesTypeModel];
            [itemMenuModels enumerateObjectsUsingBlock:^(FYGamesClassMenuModel * _Nonnull classMenuModel, NSUInteger idx, BOOL * _Nonnull stop) {
                if (classMenuModel.isSelected) {
                    [weakSelf setSelectedMenuId:classMenuModel.uuid];
                    [weakSelf setCurrentClassMenuModel:classMenuModel];
                }
            }];
        }
    }
    
    [self setArrayOfMenuModels:itemMenuModels];
}

- (void)setupArrayOfContentHotModels:(FYGamesTypesModel *)gamesTypeModel
{
    NSMutableArray<NSObject *> *itemHotGamesContentModels = [NSMutableArray<NSObject *> array];
    if (STR_GAMES_CENTER_CLASS_TYPE_RED_PACKET == gamesTypeModel.type.integerValue) { // 0:原生游戏
        itemHotGamesContentModels = [NSMutableArray arrayWithArray:gamesTypeModel.hotRedHBContents];
    } else { // 1：自己游戏（电子游戏），2：三方游戏（1：王者棋牌，2：幸运棋牌，3：QG棋牌，4：开元棋牌，5：双赢彩票，6：IM电竞，7：IM体育，8：AG真人，9：AG电子，10：AG捕鱼，11：KG电子）
        itemHotGamesContentModels = [NSMutableArray arrayWithArray:gamesTypeModel.hotOtherContents];
    }
    [self setArrayOfContentHotModels:itemHotGamesContentModels];
}

- (void)zj_viewDidLoadForIndex:(NSInteger)index
{
    [self.view addSubview:self.tableViewMenu];
    [self.view addSubview:self.tableViewContent];
    
    // 左菜单-右内容 => 分割线
    UIView *separatorLineView = ({
        UIView *view = [[UIView alloc] init];
        [view setBackgroundColor:COLOR_GAME_MENU_SEPARATOR_LINE];
        [self.view addSubview:view];
        
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.tableViewMenu.mas_top);
            make.left.equalTo(self.tableViewMenu.mas_right).offset(-HEIGHT_GAME_MENU_SEPARATOR_LINE*0.5f);
            make.bottom.equalTo(self.tableViewMenu.mas_bottom);
            make.width.mas_equalTo(HEIGHT_GAME_MENU_SEPARATOR_LINE);
        }];
        
        view;
    });
    separatorLineView.mas_key = @"separatorLineView";
    
    [self setArrayOfContent1HBModels:[FYGamesClassContent1HBModel buildingDataModles]];
}

- (void)resetSubScrollViewSize:(CGSize)size
{
    [super resetSubScrollViewSize:size];
    
    CGRect frame_menu = CGRectMake(0, 0, kLeftTableMenuWidth, size.height);
    [self.tableViewMenu setFrame:frame_menu];
    [self.tableViewMenu setContentSize:frame_menu.size];
    //
    CGRect frame_content = CGRectMake(kLeftTableMenuWidth, 0.0f, kRightTableContentWidth, size.height);
    [self.tableViewContent setFrame:frame_content];
    [self.tableViewContent setContentSize:frame_content.size];
}


#pragma mark - Network

- (Act)getRequestInfoAct
{
    // 红包游戏
    if (STR_GAMES_CENTER_CLASS_TYPE_RED_PACKET == self.currentGamesTypeModel.type.integerValue) {
        return ActRequestlistOfficialGroup;
    }
    // 三方游戏
    return ActRequestGamesQPChildContentList;
}

- (NSMutableDictionary *)getRequestParamerter
{
    // 红包游戏
    if (STR_GAMES_CENTER_CLASS_TYPE_RED_PACKET == self.currentGamesTypeModel.type.integerValue) {
        return @{ @"type" : self.currentClassMenuModel.type }.mutableCopy;
    }
    // 三方游戏
    return @{ @"parentId" : self.currentClassMenuModel.uuid }.mutableCopy;
}

- (void)loadData
{
    [self loadDataProgressHUD:self.isShowLoadingHUD];
}

- (void)loadDataProgressHUD:(BOOL)isShowLoadingHUD
{
    [self viewDidLoadBeforeLoadNetworkDataOrCacheData];
    
    if (!self.currentClassMenuModel || self.currentClassMenuModel.isHotGame) {
        [self viewDidLoadAfterLoadNetworkDataOrCacheData];
        return ;
    }
    
    if (![CFCNetworkReachabilityUtil isNetworkAvailable]) {
        [self.tableViewContent reloadData];
        [self setIsEmptyDataSetShouldDisplay:YES];
        [self.tableViewContent reloadEmptyDataSet];
        [self viewDidLoadAfterLoadNetworkDataOrCacheData];
    } else {
        WEAKSELF(weakSelf)
        [self loadDataProgressHUD:isShowLoadingHUD then:^(BOOL success, NSUInteger count){
            if (success && count > 0) {
                [weakSelf.tableViewContent reloadData];
            } else {
                [weakSelf.tableViewContent reloadData];
                [weakSelf setIsEmptyDataSetShouldDisplay:YES];
                [weakSelf.tableViewContent reloadEmptyDataSet];
            }
            [weakSelf viewDidLoadAfterLoadNetworkDataOrCacheData];
        }];
    }
}

- (void)loadDataProgressHUD:(BOOL)isShowLoadingHUD then:(void (^)(BOOL success, NSUInteger count))then
{
    WEAKSELF(weakSelf);
    
    __block BOOL isSuccess = NO;
    __block NSUInteger listCount = 0;
    __block NSString *showMessage = isShowLoadingHUD ? self.showLoadingMessage : nil;
    
    Act actInfo = [weakSelf getRequestInfoAct];
    NSMutableDictionary *params = [weakSelf getRequestParamerter];
    
    if (ActNil == actInfo) {
        // 刷新界面
        !then ?: then(isSuccess, listCount);
        return ;
    }
    
    FYLog(NSLocalizedString(@"\n请求地址：%@ \n请求参数：%@", nil), [NSString stringWithFormat:@"ActInfo=[%d]", actInfo], params);
    
    if (isShowLoadingHUD) {
        if ([CFCSysUtil validateStringEmpty:showMessage]) {
            PROGRESS_HUD_SHOW
        } else {
            PROGRESS_HUD_SHOW_STATUS(showMessage)
        }
    }

    [NET_REQUEST_MANAGER requestWithAct:actInfo requestType:self.requestMethod parameters:params success:^(id response) {
        NSMutableArray *responseTableData = [weakSelf loadNetworkDataOrCacheData:response];
        listCount = responseTableData.count;
        if (listCount > 0) {
            isSuccess = YES;
            FYLog(NSLocalizedString(@"[%@]加载数据成功", nil), self.currentClassMenuModel.showName);
        } else {
            isSuccess = YES;
            FYLog(NSLocalizedString(@"[%@]没有更多数据", nil), self.currentClassMenuModel.showName);
        }
        !then ?: then(isSuccess, listCount);
        if (isShowLoadingHUD) {
            PROGRESS_HUD_DISMISS
        }
    } failure:^(id error) {
        FYLog(NSLocalizedString(@"[%@]加载数据异常：%@", nil), self.currentClassMenuModel.showName, error);
        !then ?: then(isSuccess, listCount);
        if (isShowLoadingHUD) {
            PROGRESS_HUD_DISMISS
        }
        ALTER_HTTP_ERROR_MESSAGE(error);
    }];

}

- (NSMutableArray *)loadNetworkDataOrCacheData:(id)response
{
    WEAKSELF(weakSelf)
//    FYLog(NSLocalizedString(@"游戏列表[%@] => \n%@", nil), self.currentClassMenuModel.showName, response);
    // 红包游戏
    if (STR_GAMES_CENTER_CLASS_TYPE_RED_PACKET == self.currentGamesTypeModel.type.integerValue) {
        if (!NET_REQUEST_SUCCESS(response)) {
            self.arrayOfContent1HBModels = @[].mutableCopy;
            return self.arrayOfContent1HBModels ;
        }
        NSDictionary *data = NET_REQUEST_DATA(response);
        NSMutableArray<FYGamesClassContent1HBModel *> *itemGamesContentModels = [NSMutableArray array];
        [data[@"skChatGroups"] enumerateObjectsUsingBlock:^(NSDictionary *  _Nonnull dict, NSUInteger idx, BOOL * _Nonnull stop) {
            FYGamesClassContent1HBModel *model = [FYGamesClassContent1HBModel mj_objectWithKeyValues:dict];
            // 以下三个字段，从二级菜单取值。（热门分类，则三级数据自己返回，无取从二级取）
            {
                [model setMenuGameFlag:weakSelf.currentClassMenuModel.gameFlag];
                [model setMenuMaintainEnd:weakSelf.currentClassMenuModel.maintainEnd];
                [model setMenuMaintainStart:weakSelf.currentClassMenuModel.maintainStart];
            }
            [itemGamesContentModels addObj:model];
        }];
        self.arrayOfContent1HBModels = [NSMutableArray<FYGamesClassContent1HBModel *> array];
        if (itemGamesContentModels && 0 < itemGamesContentModels.count) {
          [self.arrayOfContent1HBModels addObjectsFromArray:itemGamesContentModels];
        }
        return self.arrayOfContent1HBModels;
    }
    // 三方游戏
    else {
       if (!NET_REQUEST_SUCCESS(response)) {
            self.arrayOfContent2QPModels = @[].mutableCopy;
            return self.arrayOfContent2QPModels ;
        }
        NSArray *data = NET_REQUEST_DATA(response);
        NSMutableArray<FYGamesClassContent2QPModel *> *itemGamesContentModels = [NSMutableArray array];
        [data enumerateObjectsUsingBlock:^(NSDictionary *  _Nonnull dict, NSUInteger idx, BOOL * _Nonnull stop) {
            FYGamesClassContent2QPModel *model = [FYGamesClassContent2QPModel mj_objectWithKeyValues:dict];
            // 以下三个字段，从二级菜单取值。（热门分类，则三级数据自己返回，无取从二级取）
            {
                [model setMenuGameFlag:weakSelf.currentClassMenuModel.gameFlag];
                [model setMenuMaintainEnd:weakSelf.currentClassMenuModel.maintainEnd];
                [model setMenuMaintainStart:weakSelf.currentClassMenuModel.maintainStart];
            }
            [itemGamesContentModels addObj:model];
        }];
        self.arrayOfContent2QPModels = [NSMutableArray<FYGamesClassContent2QPModel *> array];
        if (itemGamesContentModels && 0 < itemGamesContentModels.count) {
            [self.arrayOfContent2QPModels addObjectsFromArray:itemGamesContentModels];
        }
        return self.arrayOfContent2QPModels;
    }
}

- (void)viewDidLoadBeforeLoadNetworkDataOrCacheData
{
    
}

- (void)viewDidLoadAfterLoadNetworkDataOrCacheData
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(doAnyThingForGamesClassSuperViewController:)]) {
        [self.delegate doAnyThingForGamesClassSuperViewController:FYGamesClassProtocolFuncTypeTableEndRefresh];
    } else {
        NSAssert(NO, NSLocalizedString(@"[FYGamesMain2ViewController]类必须实现代理方法[doAnyThingForGamesClassSuperViewController:]", nil));
    }
}


#pragma mark - FYGamesMain2ViewControllerProtocol

- (void)doAnyThingForMode2ClassViewController:(FYGamesMain2ProtocolFuncType)type
{
    if (FYGamesMain2ProtocolFuncTypeRefreshContent == type) {
        [self loadDataProgressHUD:NO];
    }
}

- (void)doReloadForMode2ClassGamesTypeModel:(FYGamesTypesModel *)gamesTypesModel
{
    [self setCurrentGamesTypeModel:gamesTypesModel];
    [self setupArrayOfMenuModels:gamesTypesModel];
    [self setupArrayOfContentHotModels:gamesTypesModel];
    
    // 刷新菜单数据
    if (!self.arrayOfMenuModels || self.arrayOfMenuModels.count <= 0) {
        [self.tableViewMenu reloadData];
        [self setIsEmptyDataSetShouldDisplay:YES];
        [self.tableViewMenu reloadEmptyDataSet];
    } else {
        [self.tableViewMenu reloadData];
    }
    
    // 刷新内容数据
    if (!self.currentClassMenuModel || self.currentClassMenuModel.isHotGame) {
        if (!self.currentClassMenuModel || self.arrayOfContentHotModels.count <= 0) {
            [self.tableViewContent reloadData];
            [self setIsEmptyDataSetShouldDisplay:YES];
            [self.tableViewContent reloadEmptyDataSet];
        } else {
            [self.tableViewContent reloadData];
        }
    }
}

- (void)doRefreshForMode2ClassContentTableScrollToTopAnimated:(BOOL)animated
{
    if (self.arrayOfMenuModels && self.arrayOfMenuModels.count > 0) {
        [self.tableViewMenu scrollTableToTopAnimated:animated];
    }
    
    // 热门游戏
    if (!self.currentClassMenuModel || self.currentClassMenuModel.isHotGame) {
        if (!self.arrayOfContentHotModels || self.arrayOfContentHotModels.count <= 0) {
            return;
        }
    }
    // 红包游戏
    else if (STR_GAMES_CENTER_CLASS_TYPE_RED_PACKET == self.currentGamesTypeModel.type.integerValue) {
        if (!self.arrayOfContent1HBModels || self.arrayOfContent1HBModels.count <= 0) {
            return;
        }
    }
    // 三方游戏
    else {
        if (!self.arrayOfContent2QPModels || self.arrayOfContent2QPModels.count <= 0) {
            return;
        }
    }
    [self.tableViewContent scrollTableToTopAnimated:animated];
}


#pragma mark - UITableViewDelegate, UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView == _tableViewMenu) {
        return 1;
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == _tableViewMenu) {
        return self.arrayOfMenuModels.count;
    }
    
    // 热门游戏
    if (!self.currentClassMenuModel || self.currentClassMenuModel.isHotGame) {
        return self.arrayOfContentHotModels.count;
    }
    // 红包游戏
    else if (STR_GAMES_CENTER_CLASS_TYPE_RED_PACKET == self.currentGamesTypeModel.type.integerValue) {
        return self.arrayOfContent1HBModels.count;
    }
    // 三方游戏
    return self.arrayOfContent2QPModels.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _tableViewMenu) {
        FYGamesClassMenuTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFIER_GAMES_CLASS_MENU];
        if (cell == nil) {
            cell = [[FYGamesClassMenuTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELL_IDENTIFIER_GAMES_CLASS_MENU];
        }
        cell.delegate = self;
        cell.indexPath = indexPath;
        cell.model = self.arrayOfMenuModels[indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    } else {
        // 热门游戏
        if (!self.currentClassMenuModel || self.currentClassMenuModel.isHotGame) {
            return [self tableView:tableView cellForRowAtIndexPath:indexPath cellModel:self.arrayOfContentHotModels[indexPath.row]];
        }
        // 红包游戏
        else if (STR_GAMES_CENTER_CLASS_TYPE_RED_PACKET == self.currentGamesTypeModel.type.integerValue) {
            return [self tableView:tableView cellForRowAtIndexPath:indexPath cellModel:self.arrayOfContent1HBModels[indexPath.row]];
        }
        // 三方游戏
        else {
            return [self tableView:tableView cellForRowAtIndexPath:indexPath cellModel:self.arrayOfContent2QPModels[indexPath.row]];
        }
    }
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath cellModel:(id)model
{
    if ([model isKindOfClass:[FYGamesClassContent1HBModel class]]) {
        FYGamesClassContent1HBTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFIER_GAMES_CLASS_CONTENT_1_HONGBAO];
        if (cell == nil) {
            cell = [[FYGamesClassContent1HBTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELL_IDENTIFIER_GAMES_CLASS_CONTENT_1_HONGBAO];
        }
        cell.delegate = self;
        cell.indexPath = indexPath;
        cell.model = (FYGamesClassContent1HBModel *)model;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    } else if ([model isKindOfClass:[FYGamesClassContent2QPModel class]]) {
        FYGamesClassContent2QPTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFIER_GAMES_CLASS_CONTENT_2_QIPAI];
        if (cell == nil) {
            cell = [[FYGamesClassContent2QPTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELL_IDENTIFIER_GAMES_CLASS_CONTENT_2_QIPAI];
        }
        cell.delegate = self;
        cell.indexPath = indexPath;
        cell.model = (FYGamesClassContent2QPModel *)model;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    } else {
        return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _tableViewMenu) {
        return GAMES_MALL_MENU_CELL_HEIGHT;
    } else {
        return GAMES_MALL_CONTENT_CELL_HEIGHT;
    }
    return FLOAT_MIN;
}


#pragma mark - Getter & Setter

- (UITableView *)tableViewMenu
{
    if (!_tableViewMenu) {
        CGRect frame = CGRectMake(0.0f, 0.0f, kLeftTableMenuWidth, self.view.bounds.size.height);
        UITableView *tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStyleGrouped];
        [tableView setDelegate:self];
        [tableView setDataSource:self];
        [tableView setEstimatedRowHeight:50.0f];
        [tableView setSectionHeaderHeight:FLOAT_MIN];
        [tableView setSectionFooterHeight:FLOAT_MIN];
        [tableView setShowsVerticalScrollIndicator:NO];
        [tableView setBackgroundColor:[UIColor whiteColor]];
        [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [tableView setTableHeaderView:[[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, FLOAT_MIN)]];
        [tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, FLOAT_MIN)]];
        // [tableView setDecelerationRate:UIScrollViewDecelerationRateFast];
        
        // 设置背景
        UIView *backgroundView = [[UIView alloc] init];
        [backgroundView setBackgroundColor:COLOR_TABLEVIEW_BACK_VIEW_BACKGROUND_DEFAULT];
        [tableView setBackgroundView:backgroundView];
        [tableView setBackgroundColor:COLOR_TABLEVIEW_BACK_VIEW_BACKGROUND_DEFAULT];
        
        //
        [tableView registerClass:[FYGamesClassMenuTableViewCell class] forCellReuseIdentifier:CELL_IDENTIFIER_GAMES_CLASS_MENU];
        _tableViewMenu = tableView;
    }
    return _tableViewMenu;
}

- (UITableView *)tableViewContent
{
    if (!_tableViewContent) {
        CGRect frame = CGRectMake(kLeftTableMenuWidth, 0.0f, kRightTableContentWidth, self.view.bounds.size.height);
        UITableView *tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStyleGrouped];
        [tableView setDelegate:self];
        [tableView setDataSource:self];
        [tableView setEstimatedRowHeight:80.0f];
        [tableView setTableHeaderView:[UIView new]];
        [tableView setTableFooterView:[UIView new]];
        [tableView setSectionHeaderHeight:FLOAT_MIN];
        [tableView setSectionFooterHeight:FLOAT_MIN];
        [tableView setShowsVerticalScrollIndicator:NO];
        [tableView setBackgroundColor:[UIColor whiteColor]];
        [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [tableView setTableHeaderView:[[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, FLOAT_MIN)]];
        [tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, FLOAT_MIN)]];
        // [tableView setDecelerationRate:UIScrollViewDecelerationRateFast];
        
        // 设置背景
        UIView *backgroundView = [[UIView alloc] init];
        [backgroundView setBackgroundColor:COLOR_TABLEVIEW_BACK_VIEW_BACKGROUND_DEFAULT];
        [tableView setBackgroundView:backgroundView];
        [tableView setBackgroundColor:COLOR_TABLEVIEW_BACK_VIEW_BACKGROUND_DEFAULT];
        
        // 空白页展示
        [tableView setEmptyDataSetSource:self];
        [tableView setEmptyDataSetDelegate:self];
        
        //
        [tableView registerClass:[FYGamesClassContent1HBTableViewCell class] forCellReuseIdentifier:CELL_IDENTIFIER_GAMES_CLASS_CONTENT_1_HONGBAO];
        [tableView registerClass:[FYGamesClassContent2QPTableViewCell class] forCellReuseIdentifier:CELL_IDENTIFIER_GAMES_CLASS_CONTENT_2_QIPAI];
        _tableViewContent = tableView;
    }
    return _tableViewContent;
}


#pragma mark - Private

/// 验证游戏状态
- (BOOL)doVerifyIsCanPlayGames:(id)model
{
    if (!model) {
        return NO;
    }
    
    NSNumber *menuGameFlag = nil; // 1显示 2隐藏 3维护
    NSString *menuMaintainEnd = nil; // 维护结束时间
    NSString *menuMaintainStart = nil; // 维护开始时间
    
    // 原生游戏
    if ([model isKindOfClass:[FYGamesClassContent1HBModel class]]) {
        FYGamesClassContent1HBModel *realModel = (FYGamesClassContent1HBModel *)model;
        menuGameFlag = realModel.menuGameFlag;
        menuMaintainEnd = realModel.menuMaintainEnd;
        menuMaintainStart = realModel.menuMaintainStart;
    }
    // 网页游戏
    else if ([model isKindOfClass:[FYGamesClassContent2QPModel class]]) {
        FYGamesClassContent2QPModel *realModel = (FYGamesClassContent2QPModel *)model;
        menuGameFlag = realModel.menuGameFlag;
        menuMaintainEnd = realModel.menuMaintainEnd;
        menuMaintainStart = realModel.menuMaintainStart;
    }
    // 游戏状态
    else if ([model isKindOfClass:[FYGamesStatusModel class]]) {
        FYGamesStatusModel *realModel = (FYGamesStatusModel *)model;
        menuGameFlag = realModel.gameFlag;
        menuMaintainEnd = realModel.maintainEnd;
        menuMaintainStart = realModel.maintainStart;
    }
    
    // 左菜单控制游戏状态（1显示 2隐藏 3维护）
    if (3 == menuGameFlag.integerValue) {
        NSString *message = NSLocalizedString(@"游戏维护中", nil);
        NSString *dateFormate = NSLocalizedString(@"yyyy年MM月dd日 HH时mm分", nil);
        if (!VALIDATE_STRING_EMPTY(menuMaintainStart) && !VALIDATE_STRING_EMPTY(menuMaintainEnd)) {
            NSString *starttime = [FYDateUtil dateFormattingWithDateString:menuMaintainStart dateFormate:kFYDatePickerFormatDateFull toFormate:dateFormate];
            NSString *endtime = [FYDateUtil dateFormattingWithDateString:menuMaintainEnd dateFormate:kFYDatePickerFormatDateFull toFormate:dateFormate];
            message = [NSString stringWithFormat:NSLocalizedString(@"游戏维护中\n维护开始时间：%@\n维护结束时间：%@", nil), starttime, endtime];
        } else if (!VALIDATE_STRING_EMPTY(menuMaintainEnd)) {
            NSString *endtime = [FYDateUtil dateFormattingWithDateString:menuMaintainEnd dateFormate:kFYDatePickerFormatDateFull toFormate:dateFormate];
            message = [NSString stringWithFormat:NSLocalizedString(@"游戏维护中\n维护截止时间：%@", nil), endtime];
        } else if (!VALIDATE_STRING_EMPTY(menuMaintainStart)) {
            NSString *starttime = [FYDateUtil dateFormattingWithDateString:menuMaintainStart dateFormate:kFYDatePickerFormatDateFull toFormate:dateFormate];
            message = [NSString stringWithFormat:NSLocalizedString(@"游戏维护中\n维护开始时间：%@", nil), starttime];
        }
        ALTER_INFO_MESSAGE(message)
        return NO;
    }
    
    return YES;
}

/// 三方游戏余额核实
- (void)doVerifyThirdPartyGamesBalanceThen:(void (^)(BOOL success))then
{
    [FYAPP_PRECISION_MANAGER doTryThirdPartyGamesVerifyBalanceAffirmThen:then];
}

/// 验证检查游戏状态
- (void)doCheckVerifyDZQPTypeGamesStatus:(NSString *)parentId then:(void (^)(BOOL success, FYGamesStatusModel *gamesStatusModel))then
{
    [FYAPP_PRECISION_MANAGER doTryCheckVerifyGamesStatus:parentId then:then];
}

/// 电子游戏登录地址URL
- (void)doGeneraterSelfDianZiGamesLoginUrlWithId:(NSString *)identifier then:(void (^)(NSString *url))then
{
    PROGRESS_HUD_SHOW
    [NET_REQUEST_MANAGER requesGamesSelfDianZiLoginUrlWithId:identifier success:^(id response) {
        PROGRESS_HUD_DISMISS
        FYLog(NSLocalizedString(@"电子游戏登录地址 => \n%@", nil), response);
        if (!NET_REQUEST_SUCCESS(response)) {
           ALTER_HTTP_ERROR_MESSAGE(response)
        } else {
            NSDictionary *data = NET_REQUEST_DATA(response);
            NSString *url = [data stringForKey:@"linkUrl"];
            !then ?: then(url);
        }
    } failure:^(id error) {
        PROGRESS_HUD_DISMISS
        ALTER_HTTP_ERROR_MESSAGE(error)
        FYLog(NSLocalizedString(@"获取电子游戏登录地址出错 => \n%@", nil), error);
    }];
}

/// 三方游戏登录地址URL
- (void)doGeneraterThirdPartyGamesLoginUrlWithGameId:(NSString *)gameId gameType:(NSNumber *)gameType walletId:(NSNumber *)walletId linkUrl:(NSString *)linkUrl then:(void (^)(NSString *url))then
{
    [FYAPP_PRECISION_MANAGER doTryThirdPartyGamesLoginUrlWithGameId:gameId gameType:gameType walletId:walletId linkUrl:linkUrl then:then];
}


@end

