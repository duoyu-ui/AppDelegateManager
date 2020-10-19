//
//  FYGamesMode1QPGroupSubController.m
//  ProjectCSHB
//
//  Created by fangyuan on 2020/7/31.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "FYGamesMode1QPGroupController.h"
#import "FYGamesMode1QPGroupSubController.h"
#import "FYGamesMode1QPGroupSubTableViewCell.h"
#import "FYGamesMode1QPGroupSubModel.h"
#import "FYGamesMode1ClassModel.h"
#import "FYGamesStatusModel.h"

@interface FYGamesMode1QPGroupSubController () <FYGamesMode1QPGroupSubTableViewCellDelegate>
@property (nonatomic, copy) NSString *tabTitleCode;
@property (nonatomic, strong) FYGamesMode1ClassModel *tabTypeModel;
@end

@implementation FYGamesMode1QPGroupSubController

#pragma mark - Actions

- (void)didSelectRowAtGamesMode1QPGroupSubModel:(FYGamesMode1QPGroupSubModel *)model indexPath:(NSIndexPath *)indexPath
{
    WEAKSELF(weakSelf)
    [FYAPP_PRECISION_MANAGER doTryThirdPartyGamesVerifyBalanceAffirmThen:^(BOOL success) {
        if (success) {
            NSString *parentId = model.parentId.stringValue;
            [FYAPP_PRECISION_MANAGER doTryCheckVerifyGamesStatus:parentId then:^(BOOL success, FYGamesStatusModel *gamesStatusModel) {
                if ([weakSelf doVerifyIsCanPlayGames:gamesStatusModel]) {
                    [FYAPP_PRECISION_MANAGER doTryThirdPartyGamesLoginUrlWithGameId:model.gameId gameType:model.gameType walletId:model.productWallet linkUrl:gamesStatusModel.linkUrl then:^(NSString *url) {
                        [FYAPP_PRECISION_MANAGER doTryWay2JoinQPGamesWidthUrl:STR_TRI_WHITE_SPACE(url) gametype:model.gameType title:model.gameName from:weakSelf.navigationController];
                    }];
                }
            }];
        }
    }];
}

/// 验证游戏状态
- (BOOL)doVerifyIsCanPlayGames:(id)model
{
    if (!model) {
        return NO;
    }
    
    NSNumber *menuGameFlag = nil; // 1显示 2隐藏 3维护
    NSString *menuMaintainEnd = nil; // 维护结束时间
    NSString *menuMaintainStart = nil; // 维护开始时间
    
    // 网页游戏
    if ([model isKindOfClass:[FYGamesMode1QPGroupSubModel class]]) {
        FYGamesMode1QPGroupSubModel *realModel = (FYGamesMode1QPGroupSubModel *)model;
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
        id<FYGamesMode1QPGroupSubControllerDelegate> delegate_original = (id<FYGamesMode1QPGroupSubControllerDelegate>)self.delegate;
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
    [self.tableViewRefresh registerClass:[FYGamesMode1QPGroupSubTableViewCell class] forCellReuseIdentifier:[FYGamesMode1QPGroupSubTableViewCell reuseIdentifier]];
}


#pragma mark - Network

- (Act)getRequestInfoAct
{
    return ActRequestGamesQPChildContentList;
}

- (NSMutableDictionary *)getRequestParamerter
{
    return @{ @"oldParentId" : self.tabTitleCode }.mutableCopy;
}

- (NSMutableArray *)loadNetworkDataOrCacheData:(id)responseDataOrCacheData isCacheData:(BOOL)isCacheData
{
    FYLog(NSLocalizedString(@"三方游戏 => \n%@", nil), responseDataOrCacheData);
    
    // 请求成功，解析数据
    if (!NET_REQUEST_SUCCESS(responseDataOrCacheData)) {
        self.tableDataRefresh = @[].mutableCopy;
        return self.tableDataRefresh;
    }

    // 组装数据
    NSArray<NSDictionary *> *arrayOfDicts = NET_REQUEST_DATA(responseDataOrCacheData);
    NSMutableArray<FYGamesMode1QPGroupSubModel *> *allItemModels = [FYGamesMode1QPGroupSubModel mj_objectArrayWithKeyValuesArray:arrayOfDicts];

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
    id<FYGamesMode1QPGroupSubControllerDelegate> delegate_original = (id<FYGamesMode1QPGroupSubControllerDelegate>)self.delegate;
    if (delegate_original && [delegate_original respondsToSelector:@selector(doAnyThingForSuperViewController:)]) {
        [delegate_original doAnyThingForSuperViewController:FYScrollPageForSuperViewTypeTableEndRefresh];
    }
}


#pragma mark - FYGamesMode1QPGroupControllerProtocol

- (void)doRefreshForQPGroupSubController:(NSString *)tabTitleCode
{
    [self setTabTitleCode:tabTitleCode];
    //
    [self loadData];
}

- (void)doRefreshForQPGroupSubContentTableScrollToTopAnimated:(BOOL)animated
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
    FYGamesMode1QPGroupSubTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[FYGamesMode1QPGroupSubTableViewCell reuseIdentifier]];
    if (cell == nil) {
        cell = [[FYGamesMode1QPGroupSubTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[FYGamesMode1QPGroupSubTableViewCell reuseIdentifier]];
    }
    cell.delegate = self;
    cell.indexPath = indexPath;
    cell.model = self.tableDataRefresh[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [FYGamesMode1QPGroupSubTableViewCell height];
}


@end

