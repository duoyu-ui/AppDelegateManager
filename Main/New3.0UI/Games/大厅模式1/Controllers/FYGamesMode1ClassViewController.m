//
//  FYGamesMode1ClassViewController.m
//  ProjectCSHB
//
//  Created by fangyuan on 2020/7/27.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "FYGamesMain1ViewController.h"
#import "FYGamesMode1ClassViewController.h"
#import "FYGamesMode1ClassViewController+EmptyDataSet.h"
#import "FYGamesMode1StatusModel.h"
#import "FYGamesMode1TypesModel.h"
//
#import "FYGamesMode1HBGroupController.h"
#import "FYGamesMode1QPGroupController.h"
#import "FYGamesMode1ClassMinCollectionCell.h"
#import "FYGamesMode1ClassMaxCollectionCell.h"
#import "FYGamesMode1ClassModel.h"

@interface FYGamesMode1ClassViewController () <FYGamesMain1ViewControllerProtocol, UICollectionViewDataSource, UICollectionViewDelegate>
@property (nonatomic, assign) CGSize scrollViewSize;
@property (nonatomic, strong) UICollectionView *collectionViewRefresh;
@property (nonatomic, strong) FYGamesMode1TypesModel *currentGamesTypesModel;
@property (nonatomic, strong) NSMutableArray<FYGamesMode1ClassModel *> *arrayOfDataSource;
@end

@implementation FYGamesMode1ClassViewController

#pragma mark - Life Cycle

- (instancetype)initWithGamesTypeModel:(FYGamesMode1TypesModel *)gamesTypeModel delegate:(id<FYGamesClassViewControllerDelegate>)delegate
{
    self = [super init];
    if (self) {
        [self setDelegate:delegate];
        //
        _isEmptyDataSetShouldDisplay = NO;
        _isEmptyDataSetShouldAllowScroll = YES;
        _isEmptyDataSetShouldAllowImageViewAnimate = YES;
        //
        _currentGamesTypesModel = gamesTypeModel;
        //
        [self doReloadForMode1ClassGamesTypeModel:gamesTypeModel];
    }
    return self;
}

- (void)zj_viewDidLoadForIndex:(NSInteger)index
{
    [self createUICollection:YES];
}

- (void)resetSubScrollViewSize:(CGSize)size
{
    [super resetSubScrollViewSize:size];
    
    _scrollViewSize = size;
}

- (void)createUICollection:(BOOL)force
{
    if (force && self.collectionViewRefresh) {
        [self.collectionViewRefresh removeFromSuperview];
        [self setCollectionViewRefresh:nil];
    }
    
    if (self.collectionViewRefresh && !force) {
        return;
    }
    
    UICollectionViewLayout *layout = [self collectionViewLayout];
    CGRect frame = CGRectMake(0.0f, 0.0f, self.scrollViewSize.width, self.scrollViewSize.height);
    self.collectionViewRefresh = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:layout];
    [self.view addSubview:self.collectionViewRefresh];
    [self.collectionViewRefresh setDelegate:self];
    [self.collectionViewRefresh setDataSource:self];
    [self.collectionViewRefresh setShowsVerticalScrollIndicator:YES];
    [self.collectionViewRefresh setBackgroundColor:COLOR_TABLEVIEW_BACK_VIEW_BACKGROUND_DEFAULT];
    
    [self.collectionViewRefresh setEmptyDataSetSource:self];
    [self.collectionViewRefresh setEmptyDataSetDelegate:self];
    
    UIView *backgroundView = [[UIView alloc] init];
    [backgroundView setBackgroundColor:COLOR_TABLEVIEW_BACK_VIEW_BACKGROUND_DEFAULT];
    [self.collectionViewRefresh setBackgroundView:backgroundView];
    
    [self.collectionViewRefresh registerClass:[FYGamesMode1ClassMinCollectionCell class]
                   forCellWithReuseIdentifier:[FYGamesMode1ClassMinCollectionCell reuseIdentifier]];
    [self.collectionViewRefresh registerClass:[FYGamesMode1ClassMaxCollectionCell class]
                   forCellWithReuseIdentifier:[FYGamesMode1ClassMaxCollectionCell reuseIdentifier]];
}

- (UICollectionViewLayout *)collectionViewLayout
{
    CGFloat margin = CFC_AUTOSIZING_WIDTH(0.0f);
    if (self.currentGamesTypesModel.iconSize.boolValue) {
        margin = CFC_AUTOSIZING_WIDTH(MARGIN*0.75f);
    }
    CFCCollectionRefreshViewWaterFallLayout *flowLayout = [[CFCCollectionRefreshViewWaterFallLayout alloc] init];
    flowLayout.delegate = self;
    flowLayout.margin = margin;
    flowLayout.sectionInset = UIEdgeInsetsMake(margin, margin, margin, margin);
    return flowLayout;
}


#pragma mark - FYGamesMain1ViewControllerProtocol

- (void)doReloadForMode1ClassGamesTypeModel:(FYGamesMode1TypesModel *)gamesTypeModel
{
    if (self.currentGamesTypesModel
        && self.currentGamesTypesModel.iconSize.boolValue != gamesTypeModel.iconSize.boolValue) {
        [self setCurrentGamesTypesModel:gamesTypeModel];
        [self createUICollection:YES];
    }
    
    [self setCurrentGamesTypesModel:gamesTypeModel];
    [self setArrayOfDataSource:[NSMutableArray arrayWithArray:gamesTypeModel.list]];
    
    if (!self.arrayOfDataSource || self.arrayOfDataSource.count <= 0) {
        [self.collectionViewRefresh reloadData];
        [self setIsEmptyDataSetShouldDisplay:YES];
        [self.collectionViewRefresh reloadEmptyDataSet];
    } else {
        [self.collectionViewRefresh reloadData];
    }
    
    [self doTableViewEndRefresh];
}

- (void)doAnyThingForMode1ClassViewController:(FYGamesMain1ProtocolFuncType)type
{
    // 与主页同一个请求接口，无需再次请求数据，直接结束加载动画
    if (FYGamesMain1ProtocolFuncTypeRefreshContent == type) {
        [self doTableViewEndRefresh];
    }
}

- (void)doRefreshForMode1ClassContentTableScrollToTopAnimated:(BOOL)animated
{
    if (self.arrayOfDataSource && self.arrayOfDataSource.count > 0) {
        [self.collectionViewRefresh scrollToTopAnimated:animated];
    }
}

- (void)doTableViewEndRefresh
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(doAnyThingForGamesClassSuperViewController:)]) {
        [self.delegate doAnyThingForGamesClassSuperViewController:FYGamesClassProtocolFuncTypeTableEndRefresh];
    } else {
        NSAssert(NO, NSLocalizedString(@"[FYGamesMain2ViewController]类必须实现代理方法[doAnyThingForGamesClassSuperViewController:]", nil));
    }
}


#pragma mark - CFCCollectionRefreshViewWaterFallLayoutDelegate

- (NSInteger)numberOfColumnsInSectionForIndexPath:(NSIndexPath *)indexPath
{
    if (self.currentGamesTypesModel.iconSize.boolValue) {
        return 1;
    } else {
        return 4;
    }
}

- (CGFloat)heightOfCellItemForCollectionViewAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.currentGamesTypesModel.iconSize.boolValue) {
        NSInteger column = [self numberOfColumnsInSectionForIndexPath:indexPath];
        CFCCollectionRefreshViewWaterFallLayout *layout = (CFCCollectionRefreshViewWaterFallLayout *)[self collectionViewLayout];
        CGFloat width = (SCREEN_MIN_LENGTH - (column * layout.margin));
        return width * (260.0f/1010.0f);
    } else {
        NSInteger column = [self numberOfColumnsInSectionForIndexPath:indexPath];
        CFCCollectionRefreshViewWaterFallLayout *layout = (CFCCollectionRefreshViewWaterFallLayout *)[self collectionViewLayout];
        CGFloat width = (SCREEN_MIN_LENGTH - (column * layout.margin)) / column;
        return width * 1.1f;
    }
}


#pragma mark - UICollectionViewDelegate & UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    if (self.arrayOfDataSource && self.arrayOfDataSource.count > 0) {
        return 1;
    }
    return 0;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (self.arrayOfDataSource && self.arrayOfDataSource.count > 0) {
        return self.arrayOfDataSource.count;
    }
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (!self.arrayOfDataSource || self.arrayOfDataSource.count <= 0) {
        return nil;
    }
    
    if (self.currentGamesTypesModel.iconSize.boolValue) {
        FYGamesMode1ClassMaxCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[FYGamesMode1ClassMaxCollectionCell reuseIdentifier] forIndexPath:indexPath];
        if (!cell) {
            cell = [[FYGamesMode1ClassMaxCollectionCell alloc] init];
        }
        cell.model = self.arrayOfDataSource[indexPath.row];
        return cell;
    } else {
        FYGamesMode1ClassMinCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[FYGamesMode1ClassMinCollectionCell reuseIdentifier] forIndexPath:indexPath];
        if (!cell) {
            cell = [[FYGamesMode1ClassMinCollectionCell alloc] init];
        }
        cell.model = self.arrayOfDataSource[indexPath.row];
        return cell;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row >= self.arrayOfDataSource.count) {
        ALTER_INFO_MESSAGE(NSLocalizedString(@"数据错误", nil))
        return;
    }

   if (STR_GAMES_CENTER_CLASS_TYPE_RED_PACKET == self.currentGamesTypesModel.type.integerValue) {
       // 原生游戏
       [self didSelectRowOfGamesClass1HBAtIndexPath:indexPath];
   } else {
       // 网页游戏
       [self didSelectRowOfGamesClass2QPAtIndexPath:indexPath];
   }
}


#pragma mark - Private

- (void)didSelectRowOfGamesClass1HBAtIndexPath:(NSIndexPath *)indexPath
{
    FYGamesMode1ClassModel *classModel = [self.arrayOfDataSource objectAtIndex:indexPath.row];
    [self doCheckVerifyGamesStatusWithId:classModel.uuid.stringValue then:^(BOOL success, FYGamesMode1StatusModel *gamesStatusModel) {
        if ([self doCheckIsCanPlayGames:gamesStatusModel]) {
            [self doThroughAccessWay0JoinHBGamesController:classModel];
        }
    }];
}

- (void)didSelectRowOfGamesClass2QPAtIndexPath:(NSIndexPath *)indexPath
{
    FYGamesMode1ClassModel *classModel = [self.arrayOfDataSource objectAtIndex:indexPath.row];
    if (STR_GAMES_CENTER_CLASS_TYPE_DIANZI_SHUIGUOYXJ == classModel.uuid.integerValue
        || STR_GAMES_CENTER_CLASS_TYPE_DIANZI_XINGYUNDZP == classModel.uuid.integerValue
        || STR_GAMES_CENTER_CLASS_TYPE_DIANZI_BENCHIBAOMA == classModel.uuid.integerValue) {
        [self doCheckVerifyGamesStatusWithId:classModel.uuid.stringValue then:^(BOOL success, FYGamesMode1StatusModel *gamesStatusModel) {
            if ([self doCheckIsCanPlayGames:gamesStatusModel]) {
                // 1：自己游戏（QG电子）=> if (1 == classModel.accessWay.integerValue)
                [self doThroughAccessWay1JoinQPGamesWithUrlString:STR_TRI_WHITE_SPACE(gamesStatusModel.linkUrl) title:gamesStatusModel.showName];
            }
        }];
    } else {
        // 2：三方游戏（王者棋牌，幸运棋牌，QG棋牌，开元棋牌，双赢彩票...）=> if (2 == classModel.accessWay.integerValue)
        [self doThroughAccessWay2JoinQPGamesController:classModel];
    }
}


#pragma mark -

- (void)doThroughAccessWay0JoinHBGamesController:(FYGamesMode1ClassModel *)model
{
    FYGamesMode1HBGroupController *VC = [[FYGamesMode1HBGroupController alloc] initWithGroupDataSource:self.arrayOfDataSource selectedGroupModel:model gamesTypesModel:self.currentGamesTypesModel];
    [self.navigationController pushViewController:VC animated:YES];
}

- (void)doThroughAccessWay1JoinQPGamesWithUrlString:(NSString *)url title:(NSString *)title
{
    [FYAPP_PRECISION_MANAGER doTryWay1JoinQPGamesWithUrl:url title:title from:self.navigationController];
}

- (void)doThroughAccessWay2JoinQPGamesController:(FYGamesMode1ClassModel *)model
{
    FYGamesMode1QPGroupController *VC = [[FYGamesMode1QPGroupController alloc] initWithGroupDataSource:self.arrayOfDataSource selectedGroupModel:model gamesTypesModel:self.currentGamesTypesModel];
    [self.navigationController pushViewController:VC animated:YES];
}


#pragma mark -

- (BOOL)doCheckIsCanPlayGames:(FYGamesMode1StatusModel *)gamesStatusModel
{
    if (!gamesStatusModel) {
        ALTER_INFO_MESSAGE(NSLocalizedString(@"游戏数据错误", nil))
        return NO;
    }
    if (gamesStatusModel.openFlag.boolValue && gamesStatusModel.powerFlag.boolValue) {
        if (gamesStatusModel.maintainFlag.boolValue) {
            NSString *message = [NSString stringWithFormat:NSLocalizedString(@"游戏维护中...\n%@", nil), gamesStatusModel.maintTotalTime];
            ALTER_INFO_MESSAGE(message)
            return NO;
        } else {
            return YES;
        }
    } else {
        ALTER_INFO_MESSAGE(NSLocalizedString(@"敬请期待", nil))
        return NO;
    }
    return NO;
}

/// 验证检查游戏状态
- (void)doCheckVerifyGamesStatusWithId:(NSString *)parentId then:(void (^)(BOOL success, FYGamesMode1StatusModel *gamesStatusModel))then
{
    PROGRESS_HUD_SHOW
    [NET_REQUEST_MANAGER requestGameCheckStatusWithId:parentId success:^(id response) {
        PROGRESS_HUD_DISMISS
        FYLog(NSLocalizedString(@"游戏状态 => \n%@", nil), response);
        if (![CFCSysUtil validateNetRequestResult:response]) {
            ALTER_HTTP_MESSAGE(response)
            !then ?: then(NO,nil);
        } else {
            NSDictionary *data = NET_REQUEST_DATA(response);
            FYGamesMode1StatusModel *gamesStatusModel = [FYGamesMode1StatusModel mj_objectWithKeyValues:data];
            !then ?: then(YES,gamesStatusModel);
        }
    } fail:^(id error) {
        PROGRESS_HUD_DISMISS
        ALTER_HTTP_ERROR_MESSAGE(error)
        FYLog(NSLocalizedString(@"获取游戏状态数据出错 => \n%@", nil), error);
    }];
}


@end

