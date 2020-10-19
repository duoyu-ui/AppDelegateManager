//
//  FYPayModeScrollTab.m
//  ProjectCSHB
//
//  Created by fangyuan on 2020/5/17.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "FYPayModeScrollTab.h"

@implementation FYPayModeScrollTabConfig

- (instancetype)init;
{
    self = [super init];
    if (!self) {
        return nil;
    }
    
    // defaults
    _font = [UIFont systemFontOfSize:13.0f];
    _itemPad = 0.f;
    _itemWidth = 80.f;
    _selectedTextColor = [UIColor redColor];
    _unselectedTextColor = [UIColor darkGrayColor];
    _selectedBackgroundColor = [UIColor lightGrayColor];
    _unselectedBackgroundColor = [UIColor grayColor];
    _underlineIndicatorColor = self.selectedTextColor;
    
    _coverHeight = 30.0f;
    _coverBorder = 1.0f;
    _coverCornerRadius = 15.f;
    _coverBorderColor = [UIColor blackColor];
    _coverBackgroundColor = [UIColor redColor];
    
    _coverGradualChangeColor = NO;
    _coverGradualStartPoint = CGPointMake(0, 0);
    _coverGradualEndPoint = CGPointMake(1, 0);
    _coverGradualColors = @[ UIColor.whiteColor ];
    
    return self;
}

@end

@interface FYPayModeScrollTabCell : UICollectionViewCell

@property (nonatomic, strong) NSString *title;

@property (nonatomic, strong) NSString *normalImage;

@property (nonatomic, strong) NSString *selectedImage;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, strong) UIView *containerView;

@property (nonatomic, strong) UIView *underLineView;

@property (nonatomic, strong) UIView *coverView;

@property (nonatomic, strong) FYPayModeScrollTabConfig *config;

@end

@implementation FYPayModeScrollTabCell

- (instancetype)initWithFrame:(CGRect)frame;
{
    self = [super initWithFrame:frame];
    if (!self)
        return nil;
    
    self.titleLabel = [[UILabel alloc] init];
    self.imageView = [[UIImageView alloc] init];
    self.containerView = [[UIView alloc] init];
    self.underLineView = [[UIView alloc] init];
    self.coverView = [[UIView alloc] init];
    
    [self setup];
    
    return self;
}

- (void)setSelected:(BOOL)selected;
{
    [super setSelected:selected];
    [self render];
}

- (void)setTitle:(NSString *)title;
{
    _title = title;
    [self render];
}

- (void)setNormalImage:(NSString *)normalImage
{
    _normalImage = normalImage;
    [self render];
}

- (void)setSelectedImage:(NSString *)selectedImage
{
    _selectedImage = selectedImage;
    [self render];
}

- (void)setTitle:(NSString *)title normalImage:(NSString *)normalImage selectedImage:(NSString *)selectedImage
{
    _title = title;
    _normalImage = normalImage;
    _selectedImage = selectedImage;
    [self render];
}

- (NSString *)findItemMaxLength:(NSArray<NSString *> *)items
{
    __block NSString *maxLengthItem = @"";
    [items enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.length > maxLengthItem.length) {
            maxLengthItem = obj;
        }
    }];
    return maxLengthItem;
}

- (void)render;
{
    CGFloat margin = CFC_AUTOSIZING_MARGIN(MARGIN);
    
    self.containerView.backgroundColor = self.selected ?
    self.config.selectedBackgroundColor:
    self.config.unselectedBackgroundColor;
    
    [self.titleLabel setText:self.title];
    [self.titleLabel setFont:self.config.font];
    [self.titleLabel setTextColor:({
        self.selected ? self.config.selectedTextColor : self.config.unselectedTextColor;
    })];
    
    if (self.normalImage.length > 0
        && self.selectedImage.length > 0) {
        NSString *imageUrl = self.selected ? self.selectedImage : self.normalImage;
        if ([CFCSysUtil validateStringUrl:imageUrl]) {
            __block UIActivityIndicatorView *activityIndicator = nil;
            [self.imageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:nil options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    if (!activityIndicator) {
                        [self.imageView addSubview:activityIndicator = [UIActivityIndicatorView.alloc initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite]];
                        [activityIndicator setColor:COLOR_ACTIVITY_INDICATOR_BACKGROUND];
                        [activityIndicator setCenter:self.imageView.center];
                        [activityIndicator startAnimating];
                    }
                }];
            } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                [activityIndicator removeFromSuperview];
                activityIndicator = nil;
            }];
        } else {
            [self.imageView setImage:[UIImage imageNamed:imageUrl]];
        }
    }
    
    if (self.config.showUnderlineIndicator) {
        self.underLineView.hidden = !self.selected;
        self.underLineView.backgroundColor = self.config.underlineIndicatorColor;
    } else{
        self.underLineView.hidden = YES;
        [self.underLineView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self.containerView);
            make.height.mas_equalTo(0.0f);
        }];
    }
    
    if (!self.config.showCover) {
        self.coverView.backgroundColor = self.selected ?
        self.config.selectedBackgroundColor:
        self.config.unselectedBackgroundColor;
        
        if (self.title.length > 0
            && self.normalImage.length > 0
            && self.selectedImage.length > 0) {
            // 遮盖
            [self.coverView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(self.config.coverHeight);
            }];
            // 图标
            NSString *imageUrl = self.selected ? self.selectedImage : self.normalImage;
            CGFloat percent = [CFCSysUtil validateStringUrl:imageUrl] ? 0.53f :0.6f;
            [self.imageView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.coverView.mas_left).offset(margin*1.0f);
                make.width.height.equalTo(self.containerView.mas_height).multipliedBy(percent);
            }];
            // 标题
            NSString *maxItem = [self findItemMaxLength:self.config.items];
            CGFloat maxItemLength = [maxItem widthWithFont:self.config.font constrainedToHeight:CGFLOAT_MAX];
            CGFloat titleLength = [self.title widthWithFont:self.config.font constrainedToHeight:CGFLOAT_MAX];
            CGFloat gap = fabs(maxItemLength-titleLength) * 0.5f;
            [self.titleLabel setTextAlignment:NSTextAlignmentLeft];
            [self.titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.imageView.mas_right).offset(margin*0.5f+gap);
                make.right.equalTo(self.coverView.mas_right).offset(-margin*1.0f-gap);
                make.height.mas_equalTo(self.config.coverHeight);
            }];
        } else if (self.title.length > 0) {
            // 遮盖
            [self.coverView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self.containerView);
            }];
            // 图标
            [self.imageView setHidden:YES];
            [self.imageView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self.coverView.mas_centerX);
                make.width.height.equalTo(@0);
            }];
            // 标题
            [self.titleLabel setTextAlignment:NSTextAlignmentCenter];
            [self.titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self.coverView);
            }];
        }
    } else {
        [self.coverView addCornerRadius:self.config.coverCornerRadius];
        [self.coverView addBorderWithColor:self.config.coverBorderColor cornerRadius:self.config.coverCornerRadius andWidth:self.config.coverBorder];
        [self.coverView setBackgroundColor:({
            self.selected ? self.config.coverBackgroundColor: self.config.unselectedBackgroundColor;
        })];
        if (self.config.isCoverGradualChangeColor) {
            if (self.selected) {
                [self.coverView az_setGradientBackgroundWithColors:self.config.coverGradualColors locations:nil startPoint:self.config.coverGradualStartPoint endPoint:self.config.coverGradualEndPoint];
            } else {
                NSArray<UIColor *> *colors = @[self.config.unselectedBackgroundColor, self.config.unselectedBackgroundColor];
                [self.coverView az_setGradientBackgroundWithColors:colors locations:nil startPoint:self.config.coverGradualStartPoint endPoint:self.config.coverGradualEndPoint];
            }
        }
        
        if (self.title.length > 0
            && self.normalImage.length > 0
            && self.selectedImage.length > 0) {
            // 遮盖
            CGFloat cover_left_right_gap = margin * 1.25f;
            [self.coverView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(self.config.coverHeight);
            }];
            // 图标
            NSString *imageUrl = self.selected ? self.selectedImage : self.normalImage;
            CGFloat percent = [CFCSysUtil validateStringUrl:imageUrl] ? 0.4f :0.42f;
            [self.imageView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.coverView.mas_left).offset(cover_left_right_gap);
                make.width.height.equalTo(self.containerView.mas_height).multipliedBy(percent);
            }];
            // 标题
            NSString *maxItem = [self findItemMaxLength:self.config.items];
            CGFloat maxItemLength = [maxItem widthWithFont:self.config.font constrainedToHeight:CGFLOAT_MAX];
            CGFloat titleLength = [self.title widthWithFont:self.config.font constrainedToHeight:CGFLOAT_MAX];
            CGFloat gap = fabs(maxItemLength-titleLength);
            [self.titleLabel setTextAlignment:NSTextAlignmentLeft];
            [self.titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.imageView.mas_right).offset(margin*0.25f+gap*0.5f);
                make.right.equalTo(self.coverView.mas_right).offset(-cover_left_right_gap-gap*0.5f);
                make.height.mas_equalTo(self.config.coverHeight);
            }];
        } else if (self.title.length > 0) {
            // 遮盖
            [self.coverView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.containerView.mas_right).multipliedBy(0.1f);
                make.right.equalTo(self.containerView.mas_right).multipliedBy(0.9f);
                make.height.mas_equalTo(self.config.coverHeight);
            }];
            // 图标
            [self.imageView setHidden:YES];
            [self.imageView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self.coverView.mas_centerX);
                make.width.height.equalTo(@0);
            }];
            // 标题
            [self.titleLabel setTextAlignment:NSTextAlignmentCenter];
            [self.titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self.coverView);
            }];
        }
    }
}

- (void)setup;
{
    self.titleLabel.numberOfLines = 0;
    
    [self.contentView addSubview:self.containerView];
    [self.containerView addSubview:self.coverView];
    [self.containerView addSubview:self.underLineView];
    [self.coverView addSubview:self.imageView];
    [self.coverView addSubview:self.titleLabel];
    
    self.containerView.translatesAutoresizingMaskIntoConstraints = NO;
    self.underLineView.translatesAutoresizingMaskIntoConstraints = NO;
    self.coverView.translatesAutoresizingMaskIntoConstraints = NO;
    self.imageView.translatesAutoresizingMaskIntoConstraints = NO;
    self.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    
    [self.coverView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.containerView.mas_centerY);
        make.centerX.equalTo(self.containerView.mas_centerX);
    }];
    
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.coverView.mas_centerY);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.coverView);
    }];
    
    [self.underLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.containerView);
        make.height.mas_equalTo(4);
    }];
}

@end


@interface FYPayModeScrollTab () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) UICollectionViewFlowLayout *layout;
@property (nonatomic , strong) UIButton *leftBtn;
@property (nonatomic , strong) UIButton *rightBtn;
@end

@implementation FYPayModeScrollTab

static NSString * const kCollectionViewCellId = @"kPayModeCollectionViewCellId";

- (instancetype)initWithFrame:(CGRect)frame;
{
    self = [super initWithFrame:frame];
    if (!self)
        return nil;
    
    self.layout = [[UICollectionViewFlowLayout alloc] init];
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.layout];
    
    [self setup];
    
    return self;
}

- (void)setConfig:(FYPayModeScrollTabConfig *)config;
{
    _config = config;
    [self render];
}

- (void)setIndex:(NSInteger)index;
{
    [self setIndex:index animated:YES];
    if (index == 0) {
        [UIView animateWithDuration:0.25 animations:^{
             self.leftBtn.hidden = YES;
            [self.collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(@(10));
            }];
        }];
    }else{
        [UIView animateWithDuration:0.25 animations:^{
            self.leftBtn.hidden = NO;
            [self.collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(@(30));
            }];
        }];
    }
    
    if (index+1 == self.config.items.count && index != 0) {
        [UIView animateWithDuration:0.25 animations:^{
            self.rightBtn.hidden = YES;
            [self.collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(@(-10));
            }];
        }];
    }else{
        [UIView animateWithDuration:0.25 animations:^{
            self.rightBtn.hidden = NO;
            [self.collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(@(-30));
            }];
        }];
    }
}

- (void)setIndex:(NSInteger)index animated:(BOOL)animated
{
    _index = index;
    [self render];
    if (self.config.items) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
        if (self.config.layoutIsVertical) {
            [self.collectionView selectItemAtIndexPath:indexPath animated:animated scrollPosition:UICollectionViewScrollPositionCenteredVertically];
        } else {
            [self.collectionView selectItemAtIndexPath:indexPath animated:animated scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
        }
    }
}
- (void)moveGoToLeft:(UIButton*)sender{
    if (self.index > 0) {
        self.index--;
    }
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.index inSection:0];
    [self.collectionView.delegate collectionView:self.collectionView didSelectItemAtIndexPath:indexPath];
}
- (void)moveGoToRight:(UIButton*)sender{
    if (self.index+1 <= self.config.items.count) {
        self.index++;
    }
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.index inSection:0];
    [self.collectionView.delegate collectionView:self.collectionView didSelectItemAtIndexPath:indexPath];
    
}
#pragma mark Private

- (void)render;
{
    self.backgroundColor = self.config.unselectedBackgroundColor;
    
    self.layout.minimumLineSpacing = self.config.itemPad;
    self.layout.minimumInteritemSpacing = self.layout.minimumLineSpacing;
    self.layout.scrollDirection = self.config.layoutIsVertical ? UICollectionViewScrollDirectionVertical: UICollectionViewScrollDirectionHorizontal;
    
    self.collectionView.showsHorizontalScrollIndicator = self.config.showScrollIndicator;
    self.collectionView.showsVerticalScrollIndicator = self.collectionView.showsHorizontalScrollIndicator;
    self.collectionView.backgroundColor = self.backgroundColor;
    
    [self.collectionView reloadData];
}

- (void)setup;
{
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    [self.collectionView registerClass:[FYPayModeScrollTabCell class] forCellWithReuseIdentifier:kCollectionViewCellId];
    
    [self addSubview:self.collectionView];
    [self addSubview:self.leftBtn];
    [self addSubview:self.rightBtn];
    self.collectionView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.centerY.equalTo(self);
        make.left.mas_equalTo(30);
        make.right.mas_equalTo(-30);
    }];
    [self.leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.centerY.equalTo(self);
        make.width.height.equalTo(@(30));
    }];
    [self.rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.centerY.equalTo(self);
        make.width.height.equalTo(@(30));
    }];
    self.index = 0;
}

#pragma mark Collection view

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section;
{
    return self.config.items.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath;
{
    FYPayModeScrollTabCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCollectionViewCellId forIndexPath:indexPath];
    
    cell.config = self.config;
    
    cell.selected = indexPath.row == self.index;
    
    if (self.config.items.count > indexPath.row
        && self.config.itemNormalImages.count > indexPath.row
        && self.config.itemSelectedImages.count > indexPath.row) {
        [cell setTitle:self.config.items[indexPath.row] normalImage:self.config.itemNormalImages[indexPath.row] selectedImage:self.config.itemSelectedImages[indexPath.row]];
    } if (self.config.items.count > indexPath.row) {
        [cell setTitle:self.config.items[indexPath.row]];
    }
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath;
{
    CGSize size = self.config.layoutIsVertical ?
    CGSizeMake(self.bounds.size.width, self.config.itemWidth):
    CGSizeMake(self.config.itemWidth, self.bounds.size.height);
    return size;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath;
{
    NSInteger index = indexPath.row;
    self.index = index;
    
    if (self.selected) {
        NSString *item = self.config.items[index];
        self.selected(item, index);
    }
}
- (UIButton *)leftBtn{
    if (!_leftBtn) {
        _leftBtn = [[UIButton alloc]init];
        [_leftBtn setBackgroundImage:[UIImage imageNamed:@"payLeftBtnIcon"] forState:UIControlStateNormal];
        [_leftBtn addTarget:self action:@selector(moveGoToLeft:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _leftBtn;
}
- (UIButton *)rightBtn{
    if (!_rightBtn) {
        _rightBtn = [[UIButton alloc]init];
        [_rightBtn setBackgroundImage:[UIImage imageNamed:@"payRightBtnIcon"] forState:UIControlStateNormal];
        [_rightBtn addTarget:self action:@selector(moveGoToRight:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightBtn;
}
@end
