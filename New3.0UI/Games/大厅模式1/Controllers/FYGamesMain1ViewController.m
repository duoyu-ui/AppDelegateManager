//
//  FYGamesMain1ViewController.m
//  ProjectCSHB
//
//  Created by fangyuan on 2020/7/27.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "FYGamesMain1ViewController.h"
#import "FYGamesMode1ClassViewController.h"
#import "FYGamesMode1TypesModel.h"
#import "FYGamesBannerModel.h"
#import "FYGamesNoticeModel.h"

@interface FYGamesMain1ViewController () <FYGamesClassViewControllerDelegate>
@property (nonatomic, strong) NSMutableArray<NSString *> *tabClassCSSFlags; // 内容展示样式标识(0:小图/1大图)
@property (nonatomic, strong) NSMutableArray<FYGamesMode1TypesModel *> *tabGamesTypeModels; // 一级菜单模型
@end

@implementation FYGamesMain1ViewController

#pragma mark - Actions

/// 刷新大厅
- (void)pressNavigationBarRightButtonItem:(id)sender
{
    [super pressNavigationBarRightButtonItem:sender];
    
    if (self.isLoadingSuccess) {
        /// 子类Table置顶后，重载页面数据
        [self doTableViewBeginRefreshing];
    }
}

/// 刷新错误
- (void)pressReloadErrorViewAction
{
    [super pressReloadErrorViewAction];
    
    [self reloadMainUITable:YES];
}


#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self reloadMainUITable:YES];
}

- (void)reloadMainUITable:(BOOL)force
{
    // 请求数据
    WEAKSELF(weakSelf);
    [self loadDataProgressHUD:YES then:^(BOOL isLoadBannerSuccess, BOOL isLoadNoticeSuccess, BOOL isLoadGamesSuccess, NSMutableArray<FYGamesBannerModel *> *itemBannerModels, NSMutableArray<FYGamesNoticeModel *> *itemNoticeModels, NSMutableArray<FYGamesMode1TypesModel *> *itemGamesTypeModels) {
        // 游戏分类数据
        {
            __block NSMutableArray<NSString *> *tabTitles = [[NSMutableArray<NSString *> alloc] init];
            __block NSMutableArray<NSString *> *tabTitleCodes = [[NSMutableArray<NSString *> alloc] init];
            __block NSMutableArray<NSString *> *tabClassCSSFlags = [[NSMutableArray<NSString *> alloc] init];
            [itemGamesTypeModels enumerateObjectsUsingBlock:^(FYGamesMode1TypesModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [tabTitles addObj:obj.title];
                [tabTitleCodes addObj:obj.type.stringValue]; // 1:红包 2:棋牌 3:电子 4:彩票 5:电竞 6:体育 7:真人
                [tabClassCSSFlags addObj:obj.iconSize.stringValue]; // 内容展示样式标识(0:小图/1大图)
            }];
            [weakSelf setTabTitles:tabTitles];
            [weakSelf setTabTitleCodes:tabTitleCodes];
            [weakSelf setTabClassCSSFlags:tabClassCSSFlags];
            [weakSelf setTabGamesTypeModels:itemGamesTypeModels];
            // 根据数据处理一级菜单高度
            if (!tabTitles || tabTitles.count < 2) {
                weakSelf.tableSectionHeaderHeight -= [[self class] heightOfHeaderSegment];
            }
        }
        
        // 广告通知数据
        {
            // 广告横幅 + 通知公告
            [weakSelf setArrayOfBannerModels:itemBannerModels];
            [weakSelf setArrayOfNoticeModels:itemNoticeModels];
            // 根据数据处理广告+通知区域高度
            if (!itemBannerModels || itemBannerModels.count <= 0) {
                weakSelf.tableSectionHeaderHeight = weakSelf.tableSectionHeaderHeight - [[self class] heightOfHeaderBanner];
            }
            if (!itemNoticeModels || itemNoticeModels.count <= 0) {
                weakSelf.tableSectionHeaderHeight = weakSelf.tableSectionHeaderHeight - [[self class] heightOfHeaderNotice];
            }
        }
        
        // 根据数据创建表格（必须在拿到数据后才能操作）
        [weakSelf.view addSubview:weakSelf.tableView];
        
        // 通知公告信息开始动画
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (self.delegate_header && [self.delegate_header respondsToSelector:@selector(doRefreshBannerNoticeViewWithBannerModels:noticeModels:)]) {
                [self.delegate_header doRefreshBannerNoticeViewWithBannerModels:itemBannerModels noticeModels:itemNoticeModels];
            }
        });
        
        // 弹出通知公司信息窗口
        if (isLoadNoticeSuccess && FY_APPLICAION_MANAGER.isShowSystemNoticeAlterView) {
            FY_APPLICAION_MANAGER.isShowSystemNoticeAlterView = NO;
            [weakSelf doToShowSystemNoticeAlterView:itemNoticeModels];
        }
    }];
}


#pragma mark - Network

- (void)loadData
{
    WEAKSELF(weakSelf)
    [self loadDataProgressHUD:NO then:^(BOOL isLoadBannerSuccess, BOOL isLoadNoticeSuccess, BOOL isLoadGamesSuccess, NSMutableArray<FYGamesBannerModel *> *itemBannerModels, NSMutableArray<FYGamesNoticeModel *> *itemNoticeModels, NSMutableArray<FYGamesMode1TypesModel *> *itemGamesTypeModels) {
        // 结束表格刷新动画（加载数据失败后，FYGamesMode2ClassViewController不会请求数据，则动画不会自动消失）
        if (!isLoadGamesSuccess) {
            [weakSelf.tableView.mj_header endRefreshing];
        }
        
        // 刷新广告通知数据
        if (isLoadBannerSuccess || isLoadNoticeSuccess) {
            if (weakSelf.delegate_header && [weakSelf.delegate_header respondsToSelector:@selector(doRefreshBannerNoticeViewWithBannerModels:noticeModels:)]) {
                [weakSelf.delegate_header doRefreshBannerNoticeViewWithBannerModels:itemBannerModels noticeModels:itemNoticeModels];
            }
        }
        
        // 更新游戏菜单信息（如：二级菜单的信息变动需要更新到三级页面）
        [weakSelf setTabGamesTypeModels:itemGamesTypeModels];
        
        // 获取最新一级菜单标题、代号
        __block NSMutableArray<NSString *> *tabTitles = [[NSMutableArray<NSString *> alloc] init];
        __block NSMutableArray<NSString *> *tabTitleCodes = [[NSMutableArray<NSString *> alloc] init];
        __block NSMutableArray<NSString *> *tabClassCSSFlags = [[NSMutableArray<NSString *> alloc] init];
        [itemGamesTypeModels enumerateObjectsUsingBlock:^(FYGamesMode1TypesModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [tabTitles addObj:obj.title];
            [tabTitleCodes addObj:obj.type.stringValue]; // 1:红包 2:棋牌 3:电子 4:彩票 5:电竞 6:体育 7:真人
            [tabClassCSSFlags addObj:obj.iconSize.stringValue]; // 内容展示样式标识(0:小图/1大图)
        }];
        
        // 一级菜单是否改变（显示、隐藏）
        if (![CFCSysUtil validateStrArray:weakSelf.tabTitleCodes isEqualToStrArray:tabTitleCodes]
            || ![CFCSysUtil validateStrArray:weakSelf.tabClassCSSFlags isEqualToStrArray:tabClassCSSFlags]) {
            NSString *selecedTabCode = [weakSelf.tabTitleCodes objectAtIndex:weakSelf.segmentSelectedIndex];
            NSInteger selectedTabIndex = [tabTitleCodes indexOfObject:selecedTabCode];
            if (selectedTabIndex == NSNotFound) {
                [weakSelf setSegmentSelectedIndex:0];
            } else {
                [weakSelf setSegmentSelectedIndex:selectedTabIndex];
            }
            //
            [weakSelf setTabTitles:tabTitles];
            [weakSelf setTabTitleCodes:tabTitleCodes];
            [weakSelf setTabClassCSSFlags:tabClassCSSFlags];
            //
            [weakSelf.segmentView reloadTitlesWithNewTitles:tabTitles];
            [weakSelf.contentView reload]; // 删除所有子页面并重新创建
            [weakSelf.segmentView setSelectedIndex:weakSelf.segmentSelectedIndex animated:NO];
        } else {
            // 重载游戏子级页面
            if (weakSelf.delegate_subclass && [weakSelf.delegate_subclass respondsToSelector:@selector(doReloadForMode1ClassGamesTypeModel:)]) {
                FYGamesMode1TypesModel *gamesTypeModel = [weakSelf.tabGamesTypeModels objectAtIndex:weakSelf.segmentSelectedIndex];
                [weakSelf.delegate_subclass doReloadForMode1ClassGamesTypeModel:gamesTypeModel];
            }
            // 加载请求游戏列表
            if (weakSelf.delegate_subclass && [weakSelf.delegate_subclass respondsToSelector:@selector(doAnyThingForMode1ClassViewController:)]) {
                [weakSelf.delegate_subclass doAnyThingForMode1ClassViewController:FYGamesMain1ProtocolFuncTypeRefreshContent];
            }
        }
    }];
}

- (void)loadDataProgressHUD:(BOOL)isShowLoadingHUD then:(void (^)(BOOL isLoadBannerSuccess, BOOL isLoadNoticeSuccess, BOOL isLoadGamesSuccess, NSMutableArray<FYGamesBannerModel *> *itemBannerModels, NSMutableArray<FYGamesNoticeModel *> *itemNoticeModels, NSMutableArray<FYGamesMode1TypesModel *> *itemGamesTypeModels))then
{
    if (isShowLoadingHUD) {
        [self setActivityStartAnimating];
    }
    
    // 广告横幅
    [self loadRequestDataBannersThen:^(BOOL isLoadBannerSuccess, NSMutableArray<FYGamesBannerModel *> *itemBannerModels) {
        
        // 通知公告
        [self loadRequestDataNoticesThen:^(BOOL isLoadNoticeSuccess, NSMutableArray<FYGamesNoticeModel *> *itemNoticeModels) {
            
            // 一级分类 + 二级分类
            [self loadRequestDataGamesClassListThen:^(BOOL isLoadGamesSuccess, NSMutableArray<FYGamesMode1TypesModel *> *itemGamesTypeModels) {
                
                if (isShowLoadingHUD) {
                    [self setActivityStopAnimating];
                }
                [self setIsLoadingSuccess:YES];
                
                !then ?: then(isLoadBannerSuccess,isLoadNoticeSuccess,isLoadGamesSuccess,itemBannerModels,itemNoticeModels,itemGamesTypeModels);
                
            }];
            
        }];
        
    }];
}

- (void)loadRequestDataGamesClassListThen:(void (^)(BOOL success, NSMutableArray<FYGamesMode1TypesModel *> *itemGamesTypeModels))then
{
    [NET_REQUEST_MANAGER requestGameTypesSuccess:^(id response) {
        FYLog(NSLocalizedString(@"游戏大厅数据 => \n%@", nil), response);
        if (!NET_REQUEST_SUCCESS(response)) {
           !then ?: then(YES,nil);
        } else {
            NSArray *arrayOfDicts = NET_REQUEST_DATA(response);
            if ([arrayOfDicts isKindOfClass:[NSArray class]]) {
                NSMutableArray<FYGamesMode1TypesModel *> *itemGamesTypeModels = [FYGamesMode1TypesModel mj_objectArrayWithKeyValuesArray:arrayOfDicts];
                if (itemGamesTypeModels.count > 0) {
                    !then ?: then(YES,itemGamesTypeModels);
                } else {
                    !then ?: then(NO,itemGamesTypeModels);
                }
            } else {
                !then ?: then(NO,nil);
            }
        }
    } fail:^(id error) {
        ALTER_HTTP_ERROR_MESSAGE(error)
        FYLog(NSLocalizedString(@"获取游戏大厅数据出错 => \n%@", nil), error);
        !then ?: then(NO,nil);
    }];
}


#pragma mark - ZJScrollPageViewDelegate

- (NSInteger)numberOfChildViewControllers
{
    return [super numberOfChildViewControllers];
}

- (UIViewController<ZJScrollPageViewChildVcDelegate> *)childViewController:(UIViewController<ZJScrollPageViewChildVcDelegate> *)reuseViewController forIndex:(NSInteger)index
{
    UIViewController<ZJScrollPageViewChildVcDelegate> *childViewController = reuseViewController;
    
    if (!childViewController) {
        FYGamesMode1TypesModel *gamesTypeModel = [self.tabGamesTypeModels objectAtIndex:index];
        childViewController = [[FYGamesMode1ClassViewController alloc] initWithGamesTypeModel:gamesTypeModel delegate:self];
        if ([childViewController isKindOfClass:[FYGamesClassViewController class]]) {
            FYGamesClassViewController *viewController = (FYGamesClassViewController *)childViewController;
            [viewController setDelegate:self];
            [viewController resetSubScrollViewSize:CGSizeMake(self.view.bounds.size.width, self.view.bounds.size.height-self.tableSectionHeaderHeight)];
        } else {
            NSString *message = [NSString stringWithFormat:NSLocalizedString(@"[%@]基类必须是[FYGamesClassViewController]，请进行修改。", nil), self.tabTitles[index]];
            NSAssert(NO, message);
        }
    }
    
    // 保存当前选中的游戏分类下标
    [self setSegmentSelectedIndex:index];
    
    FYGamesMode1ClassViewController<FYGamesMain1ViewControllerProtocol> *viewController = (FYGamesMode1ClassViewController<FYGamesMain1ViewControllerProtocol> *)childViewController;
    self.delegate_subclass = viewController;
    
    return childViewController;
}


#pragma mark - FYGamesClassViewControllerDelegate

- (void)doAnyThingForGamesClassSuperViewController:(FYGamesClassProtocolFuncType)type
{
    if (FYGamesClassProtocolFuncTypeTableEndRefresh == type) {
        [self.tableView.mj_header endRefreshing];
    }
}


#pragma mark - Notification

/// 游戏大厅广告
- (void)doNotifiGamesMallSdShowHide:(NSNotification *)notification
{
    // 无有动画刷新
    [self loadData];
}

/// 刷新游戏大厅
- (void)doNotifiReloadGamesMallData:(NSNotification *)notification
{
    // 下拉动画刷新
    [self doTableViewBeginRefreshing];
}

/// 刷新群组信息（显示、隐藏、维护）
- (void)doNotifiRefreshGamesGroupInfo:(NSNotification *)notification
{
    // 下拉动画刷新
    [self doTableViewBeginRefreshing];
}

/// 系统消息或通知公告
- (void)doNotifiRefreshSysMsgOrNotice:(NSNotification *)notification
{
    // 无有动画刷新
    [self loadData];
}


#pragma mark - Private

- (void)doTableViewBeginRefreshing
{
    WEAKSELF(weakSelf)
    dispatch_main_async_safe(^{
        if (weakSelf.delegate_subclass && [weakSelf.delegate_subclass respondsToSelector:@selector(doRefreshForMode1ClassContentTableScrollToTopAnimated:)]) {
            [weakSelf.delegate_subclass doRefreshForMode1ClassContentTableScrollToTopAnimated:NO];
        }
        [weakSelf.tableView scrollTableToTopAnimated:NO];
        [weakSelf.tableView.mj_header beginRefreshing];
    });
}


@end

