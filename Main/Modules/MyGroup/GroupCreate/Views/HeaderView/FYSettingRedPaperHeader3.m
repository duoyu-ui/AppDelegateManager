
//
//  FYSettingRedPaperHeader3.m
//  ProjectCSHB
//
//  Created by fangyuan on 2019/10/20.
//  Copyright © 2019 Fangyuan. All rights reserved.
//  扫雷红包设置

#import "FYSettingRedPaperHeader3.h"
#import "FYRedPaperNumberCell.h"

#define kSpace  20

@interface FYSettingRedPaperHeader3()<UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subtitleLab;
@property (nonatomic, strong) UIView *lineView;

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *layout;

@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) NSString *currentRedNum;

@end

@implementation FYSettingRedPaperHeader3

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        
        [self addSubview:self.titleLabel];
        [self addSubview:self.subtitleLab];
        [self addSubview:self.collectionView];
        [self addSubview:self.lineView];
        
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.equalTo(self).offset(12);
        }];
        
        [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.left.right.equalTo(self);
            make.height.equalTo(@0.7);
        }];
        
        [self.subtitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.lineView.mas_bottom).offset(12);
            make.left.equalTo(self.titleLabel);
        }];
        
        CGFloat w = SCREEN_WIDTH * 0.3;
        [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.right.mas_equalTo(self);
            make.width.equalTo(@(w));
            make.height.equalTo(@42);
        }];
    }
    return self;
}

#pragma mark - Setter public

- (void)setPacketList:(NSArray *)packetList {
    _packetList = packetList;
    
    if (self.dataSource.count) {
        [self.dataSource removeAllObjects];
    }
    
    if (packetList.count) {
        [self.dataSource addObjectsFromArray:packetList];
    }
    
    [self.collectionView reloadData];
}

- (void)setSelectedNum:(NSString *)selectedNum {
    _selectedNum = selectedNum;
    
    self.currentRedNum = selectedNum;
    [self.collectionView reloadData];
}

#pragma mark - Getter private

- (NSMutableArray *)dataSource {
    
    if (!_dataSource) {
        
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (UIView *)lineView {
    
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = [UIColor colorWithHexString:@"#ebebeb"];
    }
    return _lineView;
}

- (UILabel *)titleLabel {
    
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = NSLocalizedString(@"发包数量", nil);
        _titleLabel.font = [UIFont systemFontOfSize:15];
        _titleLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    }
    return _titleLabel;
}

- (UILabel *)subtitleLab {
    
    if (!_subtitleLab) {
        _subtitleLab = [[UILabel alloc] init];
        _subtitleLab.text = NSLocalizedString(@"发包金额范围", nil);
        _subtitleLab.font = [UIFont systemFontOfSize:15];
        _subtitleLab.textColor = [UIColor colorWithHexString:@"#333333"];
    }
    return _subtitleLab;
}

- (UICollectionViewFlowLayout *)layout {
    
    if (!_layout) {
        _layout = [[UICollectionViewFlowLayout alloc]init];
        _layout.itemSize = CGSizeMake(28, 28);
        _layout.minimumLineSpacing = kSpace;
        _layout.minimumInteritemSpacing = kSpace;
        //_layout.sectionInset = UIEdgeInsetsMake(0, 15, 0, 15);
        _layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    }
    return _layout;
}

- (UICollectionView *)collectionView {
    
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.layout];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.allowsMultipleSelection = NO;
        [_collectionView registerClass:[FYRedPaperNumberCell class] forCellWithReuseIdentifier:@"kNumberReuseIdentifier"];
    }
    return _collectionView;
}

#pragma mark - UICollectionViewDataSource && Delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    FYRedPaperNumberCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"kNumberReuseIdentifier" forIndexPath:indexPath];
    if (self.dataSource.count > indexPath.row) {
        NSString *packetNum = [NSString stringWithFormat:@"%@", self.dataSource[indexPath.row]];
        if (self.currentRedNum.length && self.currentRedNum == packetNum) {
            cell.selected = YES;
        }
        cell.numberLabel.text = packetNum;
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.dataSource.count > indexPath.row) {
        self.currentRedNum = [NSString stringWithFormat:@"%@", self.dataSource[indexPath.row]];
        if (self.didPacketBlock) {
            self.didPacketBlock(self.currentRedNum);
        }
    }
    
    [self.collectionView reloadData];
}

@end

