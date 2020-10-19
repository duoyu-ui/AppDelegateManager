//
//  YEBInfoVC.m
//  ProjectXZHB
//
//  Created by fangyuan on 2019/7/23.
//  Copyright © 2019 CDJay. All rights reserved.
//

#import "YEBInfoVC.h"
#import "YEBHelpVC.h"
#import "YEBTransferDetailView.h"
#import "YEBProfitsDetailView.h"
#import "YEBAccountInfoModel.h"
#import "DYWebViewVC.h"

@interface YEBInfoVC ()<UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) DYSliderHeadView *controlView;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, copy) NSArray<UIView *> *datasource;

@end

@implementation YEBInfoVC {

    NSInteger _defaultSelected;
}

+ (instancetype)finalcialInfoVC:(YEBAccountInfoModel *)model {
    
    YEBInfoVC *vc = [YEBInfoVC new];
    vc->_defaultSelected = 0;
    vc.model = model;
    return vc;
}
+ (instancetype)profitInfoVC:(YEBAccountInfoModel *)model {
    
    YEBInfoVC *vc = [YEBInfoVC new];
    vc->_defaultSelected = 1;
    vc.model = model;

    return vc;
}

#pragma mark - Life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupSubView];
}

- (void)setupSubView {
    
    YEBTransferDetailView *detailView = [YEBTransferDetailView new];
    detailView.model = self.model;
    if (_defaultSelected) {
        self.controlView = [[DYSliderHeadView alloc] initWithTitles:@[NSLocalizedString(@"收益详情", nil),NSLocalizedString(@"资金明细", nil)]];
        self.datasource = @[[YEBProfitsDetailView new], detailView];
    } else {
        self.controlView = [[DYSliderHeadView alloc] initWithTitles:@[NSLocalizedString(@"资金明细", nil),NSLocalizedString(@"收益详情", nil)]];
        self.datasource = @[detailView, [YEBProfitsDetailView new]];
    }
  
    self.title = NSLocalizedString(@"我的余额宝", nil);
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"yeb-?"] style:UIBarButtonItemStylePlain target:self action:@selector(helpBtnClick)];
    self.view.backgroundColor = COLOR_TABLEVIEW_BACK_VIEW_BACKGROUND_DEFAULT;
    self.controlView.type = DYSliderHeaderTypeBanScroll;
    kWeakly(self);
    self.controlView.selectIndexBlock = ^(NSInteger idx) {
        [weakself.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:idx inSection:0] atScrollPosition:0 animated:true];
    };
    
    self.controlView.selectColor = kThemeTextColor;
    UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
    layout.minimumLineSpacing = 0;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    self.collectionView.pagingEnabled = YES;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    self.collectionView.scrollEnabled = false;
    [self.view addSubview:self.controlView];
    [self.view addSubview:self.collectionView];
    
    [self.controlView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.offset(0);
        make.height.offset(44);
    }];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.offset(0);
        make.top.equalTo(self.controlView.mas_bottom).offset(0);
    }];
}


- (void)helpBtnClick {
    NSString *urlString = [NSString stringWithFormat:@"%@dist/#/help/?accesstoken=%@&tenant=%@", [AppModel shareInstance].address, [AppModel shareInstance].userInfo.token,kNewTenant];
    FYWebViewController *viewController = [[FYWebViewController alloc] initWithUrl:urlString];
    [viewController setTitle:NSLocalizedString(@"新手帮助", nil)];
    [self.navigationController pushViewController:viewController animated:YES];
}


#pragma mark - <UICollectionViewDataSource>

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.datasource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    if (cell.contentView.subviews.count == 0) {
        UIView *view = self.datasource[indexPath.row];
        [cell.contentView addSubview:view];
        [cell.contentView setBackgroundColor:COLOR_TABLEVIEW_BACK_VIEW_BACKGROUND_DEFAULT];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.offset(0);
        }];
    }
    
    return cell;
}

#pragma mark - <UICollectionDelegate>

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return collectionView.frame.size;
}


@end
