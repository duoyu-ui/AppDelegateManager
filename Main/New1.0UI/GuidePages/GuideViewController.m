
//
//  GuideViewController.m
//  Project
//
//  Created by mac on 2018/8/28.
//  Copyright © 2018年 CDJay. All rights reserved.
//  新特性引导页

#import "GuideViewController.h"
#import "GuideInfoPagerCell.h"

static NSString *const kGuideCellIdentifier = @"kGuideCellIdentifier";

@interface GuideViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) UIButton *skipButton;

@property (nonatomic, strong) NSArray *dataSource;

@end

@implementation GuideViewController

#pragma mark - lazy

- (NSArray *)dataSource {
    
    if (!_dataSource) {
        
        _dataSource = @[@"guide0", @"guide1", @"guide2"];
    }
    return _dataSource;
}

#pragma mark - Navigation
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupSubview];
    [self makeLayout];
}

- (void)setupSubview {
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.itemSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT);
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    
    _collectionView = [[UICollectionView alloc]initWithFrame:self.view.bounds collectionViewLayout:layout];
    [self.view addSubview:_collectionView];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.pagingEnabled = YES;
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.showsVerticalScrollIndicator = NO;
    _collectionView.showsHorizontalScrollIndicator = NO;
    [_collectionView registerClass:[GuideInfoPagerCell class] forCellWithReuseIdentifier:kGuideCellIdentifier];
    
    UIButton *skipButton = [UIButton new];
    [self.view addSubview:skipButton];
    skipButton.titleLabel.font = [UIFont systemFontOfSize2:15];
    skipButton.backgroundColor = COLOR_X(244, 112, 35);
    [skipButton setTitle:NSLocalizedString(@"立即加入", nil) forState:UIControlStateNormal];
    [skipButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    skipButton.layer.cornerRadius = 12;
    skipButton.layer.borderColor = [UIColor whiteColor].CGColor;
    skipButton.layer.borderWidth = 1.0f;
    [skipButton addTarget:self action:@selector(doneAction) forControlEvents:UIControlEventTouchUpInside];
    _skipButton = skipButton;
    
    [skipButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_right).offset(-15);
        make.bottom.equalTo(self.view.mas_bottom).offset(-20);
        make.height.equalTo(@(42));
        make.width.equalTo(@90);
    }];
}


- (void)makeLayout {
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

#pragma mark - <UICollectionViewDataSource && Delegate>

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    GuideInfoPagerCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kGuideCellIdentifier forIndexPath:indexPath];
    if (self.dataSource.count > indexPath.row) {
        cell.image = self.dataSource[indexPath.row];
    }
    return cell;
}

#pragma mark - Action

- (void)doneAction {
    [[NSUserDefaults standardUserDefaults] setObject:@(YES) forKey:[NSString appVersion]];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[AppModel shareInstance] restRootAnimation:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
