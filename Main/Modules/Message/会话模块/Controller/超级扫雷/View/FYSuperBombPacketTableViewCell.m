//
//  FYSuperBombPacketTableViewCell.m
//  ProjectCSHB
//
//  Created by fangyuan on 2019/11/7.
//  Copyright © 2019 Fangyuan. All rights reserved.
//

#import "FYSuperBombPacketTableViewCell.h"
#import "FYSuperBombNumberCell.h"

#define kSpace  15
#define kCollectWidth   260

static NSString *const kSuperBombPacketCellId = @"kSuperBombPacketCellId";

@interface FYSuperBombPacketTableViewCell()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UILabel *subtitleLab;

@property (nonatomic, strong) NSArray *dataSource;
@property (nonatomic , strong) UIView *bgView;
///选择埋雷数字
@property (nonatomic , strong) UILabel *leiNumLab;
///虚线
@property (nonatomic , strong) UIImageView *leftLineImgView;
@property (nonatomic , strong) UIImageView *rightLineImgView;
@end

@implementation FYSuperBombPacketTableViewCell


#pragma mark - getter

- (UICollectionView *)collectionView {
    
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        layout.itemSize = CGSizeMake(33, 33);
        layout.minimumLineSpacing = kSpace/2;
        layout.minimumInteritemSpacing = kSpace/2;
        layout.sectionInset = UIEdgeInsetsMake(10, kSpace, kSpace/2, kSpace);
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        // UICollectionView
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.semanticContentAttribute = UISemanticContentAttributeForceRightToLeft;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = HexColor(@"#FFFFFF");
        [_collectionView registerClass:[FYSuperBombNumberCell class] forCellWithReuseIdentifier:kSuperBombPacketCellId];
        if (@available(iOS 11.0, *)) {
            _collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    return _collectionView;
}


- (UILabel *)titleLabel {
    
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = NSLocalizedString(@"红包个数", nil);
        _titleLabel.textColor = [UIColor colorWithHexString:@"#333333"];
        _titleLabel.font = [UIFont systemFontOfSize:14];
    }
    return _titleLabel;
}

- (UILabel *)subtitleLab {
    
    if (!_subtitleLab) {
        _subtitleLab = [[UILabel alloc] init];
        _subtitleLab.text = NSLocalizedString(@"包", nil);
        _subtitleLab.textColor = [UIColor colorWithHexString:@"#333333"];
        _subtitleLab.font = [UIFont systemFontOfSize:14];
    }
    return _subtitleLab;
}
- (UIView *)bgView{
    if (!_bgView) {
        _bgView = [[UIView alloc]init];
        _bgView.layer.masksToBounds = YES;
        _bgView.layer.cornerRadius = 4;
        _bgView.backgroundColor = [UIColor whiteColor];
    }
    return _bgView;
    
}
- (UILabel *)leiNumLab{
    if (!_leiNumLab) {
         _leiNumLab = [[UILabel alloc]init];
         _leiNumLab.textColor = HexColor(@"#333333");
         _leiNumLab.text = NSLocalizedString(@"选择埋雷数字", nil);
         _leiNumLab.font = [UIFont systemFontOfSize:15];
     }
     return _leiNumLab;
}
- (UIImageView *)leftLineImgView{
    if (!_leftLineImgView) {
        _leftLineImgView = [[UIImageView alloc]init];
    }
    return _leftLineImgView;
}
- (UIImageView *)rightLineImgView{
    if (!_rightLineImgView) {
        _rightLineImgView = [[UIImageView alloc]init];
    }
    return _rightLineImgView;
}
#pragma mark - life cycle

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = HexColor(@"#EDEDED");
//        self.contentView.backgroundColor = [UIColor whiteColor];
        
        [self setupSubview];
    }
    return self;
}

- (void)setupSubview {
    [self addSubview:self.bgView];
    [self.bgView addSubview:self.titleLabel];
    [self.bgView addSubview:self.collectionView];
    [self.bgView addSubview:self.subtitleLab];
    [self addSubview:self.leiNumLab];
    [self addSubview:self.leftLineImgView];
    [self addSubview:self.rightLineImgView];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.top.mas_equalTo(self).offset(20);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH - 60, 55));
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView).offset(12);
        make.centerY.equalTo(self.bgView);
    }];
    
    [self.subtitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bgView).offset(-12);
        make.centerY.equalTo(self.bgView);
    }];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel.mas_right).offset(10);
        make.right.equalTo(self.subtitleLab.mas_left).offset(-5);
        make.height.centerY.equalTo(self.bgView);
    }];
    [self.leiNumLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.bgView.mas_bottom).offset(20);
    }];
    [self.leftLineImgView mas_makeConstraints:^(MASConstraintMaker *make) {
           make.centerY.mas_equalTo(self.leiNumLab);
           make.left.mas_equalTo(30);
           make.right.mas_equalTo(self.leiNumLab.mas_left).offset(-30);
           make.height.mas_equalTo(2);
       }];
       [self.rightLineImgView  mas_makeConstraints:^(MASConstraintMaker *make) {
              make.centerY.mas_equalTo(self.leiNumLab);
              make.right.mas_equalTo(-30);
              make.left.mas_equalTo(self.leiNumLab.mas_right).offset(30);
              make.height.mas_equalTo(2);
          }];
}

#pragma mark - setter

- (void)setPackets:(NSArray *)packets {
    _packets = packets;
    
    self.dataSource = [[packets reverseObjectEnumerator] allObjects];
    [self.collectionView reloadData];
}
- (void)layoutSubviews{
    [super layoutSubviews];
    self.leftLineImgView.image = [self drawLineOfDashByImageView:self.leftLineImgView];
    self.rightLineImgView.image = [self drawLineOfDashByImageView:self.rightLineImgView];
}
#pragma mark - <UICollectionViewDataSource>

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    FYSuperBombNumberCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kSuperBombPacketCellId forIndexPath:indexPath];
    if (self.dataSource.count > indexPath.row) {
        NSString *packect = self.dataSource[indexPath.row];
        cell.numberLabel.text = packect;
        if (self.selectedPacket == packect) {
            cell.selected = YES;
        }
    }
    return cell;
}

#pragma mark - <UICollectionViewDeleagte>

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.dataSource.count > indexPath.row) {
        self.selectedPacket = self.dataSource[indexPath.row];
        if (self.delegate && [self.delegate respondsToSelector:@selector(cell:didSelectedAtPacket:)]) {
            [self.delegate cell:self didSelectedAtPacket:self.selectedPacket];
        }
        
        [self.collectionView reloadData];
    }
}
/**
 *  通过 Quartz 2D 在 UIImageView 绘制虚线
 *
 *  param imageView 传入要绘制成虚线的imageView
 *  return
 */

- (UIImage *)drawLineOfDashByImageView:(UIImageView *)imageView {
    // 开始划线 划线的frame
    UIGraphicsBeginImageContext(imageView.frame.size);

    [imageView.image drawInRect:CGRectMake(0, 0, imageView.frame.size.width, imageView.frame.size.height)];

    // 获取上下文
    CGContextRef line = UIGraphicsGetCurrentContext();

    // 设置线条终点的形状
    CGContextSetLineCap(line, kCGLineCapRound);
    // 设置虚线的长度 和 间距
    CGFloat lengths[] = {4,4};

    CGContextSetStrokeColorWithColor(line, HexColor(@"#C2C2C2").CGColor);
    // 开始绘制虚线
    CGContextSetLineDash(line, 0, lengths, 2);

    CGContextMoveToPoint(line, 0.0, 2.0);

    CGContextAddLineToPoint(line, 300, 2.0);

    CGContextStrokePath(line);

    // UIGraphicsGetImageFromCurrentImageContext()返回的就是image
    return UIGraphicsGetImageFromCurrentImageContext();
}
@end

