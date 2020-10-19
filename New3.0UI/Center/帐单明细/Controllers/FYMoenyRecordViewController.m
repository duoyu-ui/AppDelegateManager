//
//  FYMoenyRecordViewController.m
//  ProjectCSHB
//
//  Created by fangyuan on 2020/5/26.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "FYMoenyRecordViewController.h"
#import "FYMoneyRecordCollectionCell.h"
#import "FYMoneyRecordModel.h"

@interface FYMoenyRecordViewController () <FYMoneyRecordCollectionCellDelegate>

@end

@implementation FYMoenyRecordViewController

#pragma mark - Actions

- (void)didSelectRowAtMoneyRecordModel:(FYMoneyRecordModel *)model indexPath:(NSIndexPath *)indexPath
{
    if (VALIDATE_STRING_EMPTY(model.category)) {
        ALTER_INFO_MESSAGE(NSLocalizedString(@"敬请期待", nil))
        return;
    }
    
    MeMoneyDetailsShowController *VC = [[MeMoneyDetailsShowController alloc] init];
    [VC setTitle:model.title];
    [VC setCategory:model.category];
    [self.navigationController pushViewController:VC animated:YES];
}


#pragma mark - Life Cycle

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.hasRefreshHeader = NO;
        self.hasRefreshFooter = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
 
    [self setCollectionViewDataRefresh:[FYMoneyRecordModel buildingDataModles]];
    [self.collectionViewRefresh reloadData];
}

#pragma mark - UICollectionView

- (UICollectionViewLayout *)collectionViewLayout
{
    CGFloat margin = CFC_AUTOSIZING_WIDTH(0.0f);
    CFCCollectionRefreshViewWaterFallLayout *flowLayout = [[CFCCollectionRefreshViewWaterFallLayout alloc] init];
    flowLayout.delegate = self;
    flowLayout.margin = margin;
    flowLayout.sectionInset = UIEdgeInsetsMake(margin, margin, margin, margin);
    return flowLayout;
}

- (CFCCollectionViewLayoutType)collectionViewLayoutType
{
    return CFCCollectionViewLayoutTypeWaterFallLayout;
}

- (void)collectionViewRefreshSetting:(UICollectionView *)collectionView
{
    [self.collectionViewRefresh setShowsVerticalScrollIndicator:NO];
}

- (void)collectionViewRefreshRegisterClass:(UICollectionView *)collectionView
{
    [super collectionViewRefreshRegisterClass:collectionView];
    
    [self.collectionViewRefresh registerClass:[FYMoneyRecordCollectionCell class]
                   forCellWithReuseIdentifier:[FYMoneyRecordCollectionCell reuseIdentifier]];
}


#pragma mark - CFCCollectionRefreshViewWaterFallLayoutDelegate

/// 自定义表格每一个分组的列数
- (NSInteger)numberOfColumnsInSectionForIndexPath:(NSIndexPath *)indexPath
{
    return 2;
}

// 自定义表格每一行的高度
- (CGFloat)heightOfCellItemForCollectionViewAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger column = [self numberOfColumnsInSectionForIndexPath:indexPath];
    CFCCollectionRefreshViewWaterFallLayout *layout = (CFCCollectionRefreshViewWaterFallLayout *)[self collectionViewLayout];
    CGFloat width = (SCREEN_WIDTH - (column * layout.margin)) / column;
    return width * 0.35f;
}


#pragma mark - UICollectionViewDataSource UICollectionViewDelegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    if (self.collectionViewDataRefresh && self.collectionViewDataRefresh.count > 0) {
        return 1;
    }
    return 0;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (self.collectionViewDataRefresh && self.collectionViewDataRefresh.count > 0) {
        return self.collectionViewDataRefresh.count;
    }
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (!self.collectionViewDataRefresh
        || self.collectionViewDataRefresh.count <= 0) {
        return nil;
    }
    
    FYMoneyRecordCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[FYMoneyRecordCollectionCell reuseIdentifier] forIndexPath:indexPath];
    if (!cell) {
        cell = [[FYMoneyRecordCollectionCell alloc] init];
    }
    cell.delegate = self;
    cell.indexPath = indexPath;
    cell.model = self.collectionViewDataRefresh[indexPath.row];
    return cell;
}


#pragma mark - Navigation

- (NSString *)prefersNavigationBarTitleViewTitle
{
    return STR_NAVIGATION_BAR_TITLE_MONEY_DETAIL_RECORD;
}


@end

