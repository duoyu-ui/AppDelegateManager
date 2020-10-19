//
//  FYCenterMenuAgentTableViewCell.m
//  ProjectCSHB
//
//  Created by fangyuan on 2020/5/19.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "FYCenterMenuAgentTableViewCell.h"
#import "FYCenterMenuSectionModel.h"

@interface FYCenterMenuAgentTableViewCell ()
/**
 * 根容器组件
 */
@property (nonnull, nonatomic, strong) UIView *rootContainerView;
/**
 * 公共容器组件
 */
@property (nonnull, nonatomic, strong) UIView *publicContainerView;
/**
 * 分割线控件
 */
@property (nonatomic, strong) UIView *separatorLineView;
/**
 * 图片 - 标题
 */
@property (nonnull, nonatomic, strong) NSMutableArray<UILabel *> *titleLabelArray;
@property (nonnull, nonatomic, strong) NSMutableArray<UIImageView *> *pictureImageArray;

@end

@implementation FYCenterMenuAgentTableViewCell

+ (NSString *)reuseIdentifier
{
    return NSStringFromClass(self);
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createViewAtuoLayout];
    }
    return self;
}

#pragma make 创建子控件
- (void)createViewAtuoLayout
{
    CGFloat margin = CFC_AUTOSIZING_MARGIN(MARGIN);
    
    // 根容器
    UIView *rootContainerView = ({
        UIView *view = [[UIView alloc] init];
        [self.contentView addSubview:view];
        [view setBackgroundColor:COLOR_TABLEVIEW_BACK_VIEW_BACKGROUND_DEFAULT];
        
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@0.0f);
            make.top.equalTo(@0.0f);
            make.right.equalTo(@0.0f);
            make.bottom.equalTo(self.contentView.mas_bottom);
        }];
        
        view;
    });
    self.rootContainerView = rootContainerView;
    self.rootContainerView.mas_key = @"rootContainerView";
    
    // 公共容器
    UIView *publicContainerView = ({
        UIView *view = [[UIView alloc] init];
        [view.layer setMasksToBounds:YES];
        [view setBackgroundColor:COLOR_HEXSTRING(@"#FFFFFF")];
        [rootContainerView addSubview:view];
        
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(rootContainerView.mas_left).offset(margin);
            make.top.equalTo(rootContainerView.mas_top);
            make.right.equalTo(rootContainerView.mas_right).offset(-margin);
            make.bottom.equalTo(rootContainerView.mas_bottom);
        }];
        
        view;
    });
    self.publicContainerView = publicContainerView;
    self.publicContainerView.mas_key = @"publicContainerView";
    
    // 图片 - 标题 - 详情
    int count = 8;
    int colum = 4;
    CGFloat top_bottom_gap = margin * 1.5f;
    CGFloat left_right_gap = margin * 0.0f;
    CGFloat itemWidth = (SCREEN_WIDTH - left_right_gap*2.0f-margin*2.0f) /colum;
    CGFloat itemHeight = itemWidth * 0.60f;
    CGFloat imageSize = itemWidth * 0.28;
    __block CGFloat publicContainerViewHeight = 0.0f;
    
    _titleLabelArray = [NSMutableArray array];
    _pictureImageArray = [NSMutableArray array];
    
    UIView *lastItemView = nil;
    for (int i = 0; i < count; i ++) {
        
        // 容器
        UIView *itemView = ({
            UIView *itemContainerView = [[UIView alloc] init];
            [itemContainerView setTag:8000+i];
            [publicContainerView addSubview:itemContainerView];
            UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pressItemView:)];
            [itemContainerView addGestureRecognizer:tapGesture];
            [itemContainerView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(@(itemWidth));
                make.height.equalTo(@(itemHeight));
                
                if (!lastItemView) {
                    publicContainerViewHeight += itemHeight + top_bottom_gap;
                    make.top.equalTo(publicContainerView.mas_top).offset(top_bottom_gap);
                    make.left.equalTo(publicContainerView.mas_left).offset(left_right_gap);
                } else {
                    if (i % colum == 0) {
                        publicContainerViewHeight += itemHeight + top_bottom_gap;
                        make.top.equalTo(lastItemView.mas_bottom).offset(top_bottom_gap);
                        make.left.equalTo(publicContainerView.mas_left).offset(left_right_gap);
                    } else {
                        make.top.equalTo(lastItemView.mas_top).offset(0);
                        make.left.equalTo(lastItemView.mas_right).offset(0);
                    }
                }
            }];
            itemContainerView.mas_key = [NSString stringWithFormat:@"itemContainerView%d",i];
            
            // 图片
            UIImageView *iconImageView = ({
                UIImageView *imageView = [UIImageView new];
                [itemContainerView addSubview:imageView];
                [imageView setUserInteractionEnabled:YES];
                [imageView setContentMode:UIViewContentModeScaleAspectFit];
                
                [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerX.equalTo(itemContainerView.mas_centerX);
                    make.centerY.equalTo(itemContainerView.mas_bottom).multipliedBy(0.3f);
                    make.height.equalTo(@(imageSize));
                    make.width.equalTo(@(imageSize));
                }];
                
                imageView;
            });
            iconImageView.mas_key = [NSString stringWithFormat:@"iconImageView%d",i];
            
            // 标题
            UILabel *titleLabel = ({
                UILabel *label = [UILabel new];
                [itemContainerView addSubview:label];
                [label setText:STR_APP_TEXT_PLACEHOLDER];
                [label setFont:FONT_PINGFANG_REGULAR(14)];
                [label setTextColor:COLOR_SYSTEM_MAIN_FONT_DEFAULT];
                [label setTextAlignment:NSTextAlignmentCenter];
                
                [label mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(itemContainerView.mas_left);
                    make.right.equalTo(itemContainerView.mas_right);
                    make.top.equalTo(iconImageView.mas_bottom).offset(margin*0.5f);
                }];
                
                label;
            });
            titleLabel.mas_key = [NSString stringWithFormat:@"titleLabel%d",i];
            
            //
            [_titleLabelArray addObject:titleLabel];
            [_pictureImageArray addObject:iconImageView];
            
            itemContainerView;
        });
        
        lastItemView = itemView;
    }
    
    // 分割线
    UIView *separatorLineView = ({
        UIView *view = [[UIView alloc] init];
        [view setBackgroundColor:COLOR_TABLEVIEW_SEPARATOR_LINE_DEFAULT];
        [publicContainerView addSubview:view];
        
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            CGFloat gap = margin*2.0f;
            publicContainerViewHeight += gap;
            make.top.equalTo(lastItemView.mas_bottom).offset(gap);
            make.left.right.equalTo(publicContainerView);
            make.height.mas_equalTo(SEPARATOR_LINE_HEIGHT);
        }];
        
        view;
    });
    self.separatorLineView = separatorLineView;
    self.separatorLineView.mas_key = @"separatorLineView";
    
    // 约束的完整性
    [publicContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(separatorLineView.mas_bottom).priority(749);
    }];
    
    // 底部左右圆角
    {
        CGFloat cornerRadius = margin*1.0f;
        CGRect frame = CGRectMake(0, 0, SCREEN_MIN_LENGTH-margin*2.0f, publicContainerViewHeight);
        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:frame byRoundingCorners:UIRectCornerBottomLeft|UIRectCornerBottomRight cornerRadii:CGSizeMake(cornerRadius,cornerRadius)];
        CAShapeLayer *mask = [[CAShapeLayer alloc] init];
        mask.frame = frame;
        mask.path = path.CGPath;
        publicContainerView.layer.mask = mask;
    }
}


#pragma mark - 设置数据模型
- (void)setModel:(FYCenterMenuSectionModel *)model
{
    // 类型安全检查
    if (![model isKindOfClass:[FYCenterMenuSectionModel class]]) {
        return;
    }
    
    _model = model;
    
    for (int idx = 0; idx < self.pictureImageArray.count; idx ++) {
        
        UILabel *titleLable = self.titleLabelArray[idx];
        UIImageView *imageView = self.pictureImageArray[idx];
        
        if (idx < self.model.list.count) {
            [imageView setHidden:NO];
            [titleLable setHidden:NO];
            
            FYCenterMenuItemModel *classModel = self.model.list[idx];
            // 标题
            [titleLable setText:[CFCSysUtil stringByTrimmingWhitespaceAndNewline:classModel.title]];
            // 图片
            if ([CFCSysUtil validateStringUrl:classModel.imageUrl]) {
                __block UIActivityIndicatorView *activityIndicator = nil;
                [imageView sd_setImageWithURL:[NSURL URLWithString:classModel.imageUrl] placeholderImage:nil options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
                    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                        if (!activityIndicator) {
                            [imageView addSubview:activityIndicator = [UIActivityIndicatorView.alloc initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite]];
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
                [imageView setImage:[UIImage imageNamed:classModel.imageUrl]];
            }
            
        } else {
            [imageView setHidden:YES];
            [titleLable setHidden:YES];
        }
        
    }
}

#pragma mark - 触发操作事件
- (void)pressItemView:(UITapGestureRecognizer *)gesture
{
    UIView *itemView = (UIView*)gesture.view;
    
    NSUInteger index = itemView.tag - 8000;
    
    if (index >= self.model.list.count) {
        FYLog(NSLocalizedString(@"数组越界，请检测代码。", nil));
        return;
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectRowAtMyAgentMenuItemModel:indexPath:)]) {
        [self.delegate didSelectRowAtMyAgentMenuItemModel:self.model.list[index] indexPath:self.indexPath];
    }
}


@end

