//
//  FYSuperBombNumberTableViewCell.m
//  ProjectCSHB
//
//  Created by fangyuan on 2019/11/7.
//  Copyright © 2019 Fangyuan. All rights reserved.
//

#import "FYSuperBombNumberTableViewCell.h"
#import "FYSuperBombNumberCell.h"

#define kSpace  15
#define kCollectWidth   260

///按钮间隔
const CGFloat leiInterval = 5;
///左边间隔
const CGFloat LeileftInterval = 60;

#define SendLeiCellW  ((SCREEN_WIDTH - LeileftInterval * 2 - leiInterval * 4) / 5)

static NSString *const kSuperBombNumberCellId = @"kSuperBombNumberCellId";

@interface FYSuperBombNumberTableViewCell()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) NSArray <NSString *>*numbers;

@property (nonatomic, strong) NSMutableArray *recordArray;

@end

@implementation FYSuperBombNumberTableViewCell


#pragma mark - getter

- (NSArray<NSString *> *)numbers {
    
    if (!_numbers) {
        _numbers = @[@"1", @"2", @"3", @"4", @"5",
                     @"6", @"7", @"8", @"9", @"0"];
    }
    return _numbers;
}

- (NSMutableArray *)recordArray {
    
    if (!_recordArray) {
        
        _recordArray = [NSMutableArray array];
    }
    return _recordArray;
}

- (UICollectionView *)collectionView {
    
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        layout.itemSize = CGSizeMake(SendLeiCellW, SendLeiCellW);
        layout.minimumLineSpacing = leiInterval;
        layout.minimumInteritemSpacing = leiInterval/2;
        layout.sectionInset = UIEdgeInsetsMake(leiInterval, leiInterval/2, leiInterval, leiInterval/2);
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        // UICollectionView
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = HexColor(@"#EDEDED");
        [_collectionView registerClass:[FYSuperBombNumberCell class] forCellWithReuseIdentifier:kSuperBombNumberCellId];
        if (@available(iOS 11.0, *)) {
            _collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    return _collectionView;
}

- (UILabel *)titleLabel {
    
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
//        _titleLabel.text = NSLocalizedString(@"雷号", nil);
        _titleLabel.textColor = [UIColor colorWithHexString:@"#333333"];
        _titleLabel.font = [UIFont systemFontOfSize:14];
    }
    return _titleLabel;
}

#pragma mark - life cycle

//- (void)awakeFromNib {
//    [super awakeFromNib];
//    // Initialization code
//    self.backgroundColor = [UIColor whiteColor];
//    self.selectionStyle = UITableViewCellSelectionStyleNone;
//}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = HexColor(@"#EDEDED");
        
        
        [self setupSubview];
    }
    return self;
}

- (void)setupSubview {
    [self addSubview:self.collectionView];

    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self);
        make.centerX.equalTo(self);
        make.left.equalTo(@(LeileftInterval));
    }];
}

#pragma mark - setter

- (void)setModel:(FYSuperBombAttrModel *)model {
    _model = model;
    
    if (model != nil) {
        if (model.sendType == SinglePackage) {
            self.collectionView.allowsMultipleSelection = NO;
        }else if (model.sendType == MultiplePackage) {
            self.collectionView.allowsMultipleSelection = YES;
        }
        
        if (model.isRestSelected) {
            [self.recordArray removeAllObjects];
            [self.collectionView reloadData];
        }
    }
}


#pragma mark - <UICollectionViewDataSource>

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.numbers.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    FYSuperBombNumberCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kSuperBombNumberCellId forIndexPath:indexPath];
    cell.cornerRadius = SendLeiCellW * 0.5;
    if (self.numbers.count > indexPath.row) {
        cell.numberLabel.text = self.numbers[indexPath.row];
    }
    return cell;
}

#pragma mark - <UICollectionViewDeleagte>

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.model.packetCount == nil) {
        [SVProgressHUD showInfoWithStatus:NSLocalizedString(@"请选择包数", nil)];
        return;
    }
    NSInteger maxCount = [self.model.packetCount integerValue];
    if (maxCount < 10) {
        if (self.recordArray.count >= maxCount - 1) {
            [SVProgressHUD showInfoWithStatus:NSLocalizedString(@"雷数不能超过总包数", nil)];
            [self.collectionView deselectItemAtIndexPath:indexPath animated:NO];
            return;
        }
    }else{
        if (self.recordArray.count >= maxCount) {
            [SVProgressHUD showInfoWithStatus:NSLocalizedString(@"雷数不能超过总包数", nil)];
            [self.collectionView deselectItemAtIndexPath:indexPath animated:NO];
            return;
        }
    }
    
    
    if (self.numbers.count > indexPath.row) {
        NSString *number = self.numbers[indexPath.row];
        [self.recordArray addObject:number];
        if (self.delegate && [self.delegate respondsToSelector:@selector(cell:didSelectedAtNumber:)]) {
            [self.delegate cell:self didSelectedAtNumber:number];
        }
    }
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.model.packetCount == nil) {
        [self.collectionView reloadData];
        [SVProgressHUD showInfoWithStatus:NSLocalizedString(@"请选择包数", nil)];
        return;
    }
    
    if (self.numbers.count > indexPath.row) {
        NSString *number = self.numbers[indexPath.row];
        [self.recordArray removeObject:number];
        if (self.delegate && [self.delegate respondsToSelector:@selector(cell:didSelectedAtNumber:)]) {
            [self.delegate cell:self didSelectedAtNumber:number];
        }
    }
}

@end

