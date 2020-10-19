//
//  FYGroupTypeAlertView.m
//  ProjectCSHB
//
//  Created by fangyuan on 2019/10/19.
//  Copyright © 2019 Fangyuan. All rights reserved.
//

#import "FYGroupTypeAlertView.h"
#import "FYGroupTypeAlertCell.h"

#define kSpace  8
#define kWidth  SCREEN_WIDTH * 0.9

@interface FYGroupTypeAlertView()<UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *layout;

@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *doneButton;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIView *windowView;

@property (nonatomic, strong) NSArray *dataSource;
@property (nonatomic, copy) DidSelectedInfoBlock selectedBlock;

@end

@implementation FYGroupTypeAlertView

#pragma mark - lazy

- (UICollectionView *)collectionView {
    
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:self.layout];
        [_collectionView registerClass:[FYGroupTypeAlertCell class] forCellWithReuseIdentifier:@"kGroupTypeAlertCellId"];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.allowsMultipleSelection = NO;
    }
    return _collectionView;
}


- (UICollectionViewFlowLayout *)layout {
    
    if (!_layout) {
        _layout = [[UICollectionViewFlowLayout alloc]init];
        _layout.minimumLineSpacing = kSpace;
        _layout.minimumInteritemSpacing = kSpace;
        _layout.sectionInset = UIEdgeInsetsMake(kSpace, kSpace, kSpace, kSpace);
        _layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    }
    return _layout;
}

- (UILabel *)titleLabel {
    
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor colorWithHexString:@"#333333"];
        _titleLabel.font = [UIFont systemFontOfSize:17];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.text = NSLocalizedString(@"选择群类型", nil);
    }
    return _titleLabel;
}

- (UIView *)lineView {
    
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = [UIColor colorWithHexString:@"#ebebeb"];
    }
    return _lineView;
}

- (UIView *)windowView {
    
    if (!_windowView) {
        _windowView = [[UIView alloc] init];
        _windowView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(remover)];
        [_windowView addGestureRecognizer:tap];
        _windowView.userInteractionEnabled = YES;
    }
    return _windowView;
}

- (UIView *)contentView {
    
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
        _contentView.backgroundColor = [UIColor whiteColor];
        _contentView.layer.cornerRadius = 10;
        _contentView.layer.masksToBounds = YES;
    }
    return _contentView;
}

- (UIButton *)doneButton {
    
    if (!_doneButton) {
        _doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_doneButton setTitle:NSLocalizedString(@"确认", nil) forState:UIControlStateNormal];
        [_doneButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        UIImage *image1 = [UIImage imageFromColor:COLOR_SYSTEM_MAIN_UI_THEME_DEFAULT];
        UIImage *image2 = [UIImage imageFromColor:[COLOR_SYSTEM_MAIN_UI_THEME_DEFAULT colorWithAlphaComponent:0.3]];
        [_doneButton setBackgroundImage:image1 forState:UIControlStateNormal];
        [_doneButton setBackgroundImage:image2 forState:UIControlStateDisabled];
        _doneButton.titleLabel.font = [UIFont boldSystemFontOfSize2:16];
        [_doneButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
        _doneButton.enabled = NO;
    }
    return _doneButton;
}


#pragma mark - Life cycle

- (instancetype)initGroupTypeWithData:(NSArray *)dataSource selectedBlock:(DidSelectedInfoBlock)block {
    
    if (self = [super init]) {
        self.selectedBlock = block;
        
        self.frame = [UIApplication sharedApplication].keyWindow.frame;
        self.backgroundColor = [UIColor clearColor];
        
        [self makeSubview];
        if (dataSource.count) {
            self.dataSource = dataSource;
        }
        
        [self.collectionView reloadData];
    }
    return self;
}


- (void)makeSubview {
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    
    [self addSubview:self.windowView];
    [self addSubview:self.contentView];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.lineView];
    [self.contentView addSubview:self.doneButton];
    [self.contentView addSubview:self.collectionView];
    
    [self.windowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(kWidth));
        make.height.equalTo(@293);
        make.centerX.equalTo(self);
        make.centerY.equalTo(self);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.contentView);
        make.height.equalTo(@58);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom);
        make.left.right.equalTo(self.contentView);
        make.height.equalTo(@0.75);
    }];
    
    [self.doneButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.contentView);
        make.height.equalTo(@42);
    }];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView);
        make.bottom.equalTo(self.doneButton.mas_top);
        make.top.equalTo(self.lineView.mas_bottom).offset(0.75);
    }];
}

#pragma mark - Action

- (void)show {
    self.windowView.alpha = 0.0;
    self.contentView.transform = CGAffineTransformMakeScale(0.01, 0.01);
    self.contentView.alpha = 0.0;
    // 放大
    [UIView animateWithDuration:0.3 animations:^{
        self.contentView.transform = CGAffineTransformMakeScale(1, 1);
        self.contentView.alpha = 1.0;
        self.windowView.alpha = 1.0;
    } completion:nil];
}

- (void)remover {
    [UIView animateWithDuration:0.3 animations:^{
        self.windowView.alpha = 0.0;
        self.contentView.transform = CGAffineTransformMakeScale(0.01,0.01);
        self.contentView.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)dismiss {
    if (self.selectedBlock && self.selectedModel != nil) {
        self.selectedBlock(self.selectedModel);
    }
    
    [self remover];
}

#pragma mark - UICollectionViewDataSource && Delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    FYGroupTypeAlertCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"kGroupTypeAlertCellId" forIndexPath:indexPath];
    if (self.dataSource.count > indexPath.row) {
        FYRedPacketListModel *dataModel = self.dataSource[indexPath.row];
        if (dataModel.Id == self.selectedModel.Id) {
            cell.selected = YES;
        }
        cell.model = dataModel;
    }
    self.doneButton.enabled = self.selectedModel != nil;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.dataSource.count > indexPath.row) {
        FYRedPacketListModel *dataModel = self.dataSource[indexPath.row];
        if (dataModel.powerFlag && dataModel.openFlag) {
            self.selectedModel = dataModel;
        }else {
            [SVProgressHUD showInfoWithStatus:NSLocalizedString(@"游戏暂未开放，敬请期待!", nil)];
        }
        
        [self.collectionView reloadData];
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat itemWidth = (kWidth - 4 * kSpace) / 3;
    return CGSizeMake(itemWidth, 43);
}

@end
