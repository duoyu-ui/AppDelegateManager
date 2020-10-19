//
//  FYBillingSearchClassCell.m
//  ProjectCSHB
//
//  Created by fangyuan on 2020/6/21.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "FYBillingSearchClassCell.h"
#import "FYBillingSearchClassModel.h"

@interface FYBillingSearchClassCell ()
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
 * 标题控件
 */
@property (nonatomic, strong) UILabel *titleLabel;
/**
 * 图片 - 标题
 */
@property (nonnull, nonatomic, strong) NSMutableArray<UILabel *> *titleLabelArray;
@property (nonnull, nonatomic, strong) NSMutableArray<UIImageView *> *pictureImageArray;

@end

@implementation FYBillingSearchClassCell

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
    // 根容器
    UIView *rootContainerView = ({
        UIView *view = [[UIView alloc] init];
        [self.contentView addSubview:view];

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
        [view setBackgroundColor:[UIColor whiteColor]];
        [rootContainerView addSubview:view];
        
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(rootContainerView.mas_left);
            make.top.equalTo(rootContainerView.mas_top);
            make.right.equalTo(rootContainerView.mas_right);
            make.bottom.equalTo(rootContainerView.mas_bottom);
        }];
        
        view;
    });
    self.publicContainerView = publicContainerView;
    self.publicContainerView.mas_key = @"publicContainerView";
}


#pragma mark - 设置数据模型
- (void)setMenuModel:(id)menuModel
{
    // 类型安全检查
    if (![menuModel isKindOfClass:[FYBillingSearchClassModel class]]) {
        return;
    }
    
    _menuModel = menuModel;
    
    FYBillingSearchClassModel *realModel = (FYBillingSearchClassModel *)menuModel;
    
    // 删除控件
    [self.publicContainerView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    if (realModel.items.count > 0) {
        
        // 图片 - 标题 - 详情
        CGFloat margin = CFC_AUTOSIZING_MARGIN(MARGIN);
        int colum = 2;
        CGFloat top_gap = margin * 0.5f;
        CGFloat bottom_gap = margin * 1.5f;
        CGFloat left_right_gap = margin * 3.0f;
        CGFloat itemWidth = SCREEN_WIDTH / colum;
        CGFloat itemHeight = 40.0f;
        CGFloat imageSize = itemHeight * 0.6f;
        CGFloat titleHeight = realModel.isShowTitle ? CFC_AUTOSIZING_WIDTH(45.0f) : 0.0f;
        
        // 分割线
        UIView *separatorLineView = ({
            UIView *view = [[UIView alloc] init];
            [view setBackgroundColor:COLOR_TABLEVIEW_SEPARATOR_LINE_DEFAULT];
            [self.publicContainerView addSubview:view];
            
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.publicContainerView.mas_top);
                make.left.right.equalTo(self.publicContainerView);
                make.height.mas_equalTo(SEPARATOR_LINE_HEIGHT);
            }];
            
            view;
        });
        self.separatorLineView = separatorLineView;
        self.separatorLineView.mas_key = @"separatorLineView";
        
        // 标题
        UIView *titleContainer = ({
            // 容器
            UIView *view = [UIView new];
            [view setBackgroundColor:[UIColor whiteColor]];
            [self.publicContainerView addSubview:view];
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.separatorLineView.mas_bottom);
                make.left.right.equalTo(self.publicContainerView);
                make.height.mas_equalTo(titleHeight);
            }];
            
            // 标题
            UILabel *titleLabel = ({
                UILabel *label = [UILabel new];
                [view addSubview:label];
                [label setText:realModel.title];
                [label setHidden:!realModel.isShowTitle];
                [label setFont:FONT_PINGFANG_SEMI_BOLD(16)];
                [label setTextColor:COLOR_SYSTEM_MAIN_FONT_DEFAULT];
                [label setTextAlignment:NSTextAlignmentLeft];
                [label mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(view.mas_left).offset(left_right_gap);
                    make.right.equalTo(view.mas_right).offset(-margin*2.5f);
                    make.centerY.equalTo(view.mas_centerY);
                }];
                
                label;
            });
            self.titleLabel = titleLabel;
            self.titleLabel.mas_key = @"titleLabel";
            
            view;
        });
        titleContainer.mas_key = @"titleContainer";
        
        // 选项
        UIView *lastItemView = nil;
        self.titleLabelArray = [NSMutableArray array];
        self.pictureImageArray = [NSMutableArray array];
        for (int index = 0; index < realModel.items.count; index ++) {
            
            FYBillingClassModel *classModel = [realModel.items objectAtIndex:index];
            
            UIFont *textFont = classModel.isSelected ? FONT_PINGFANG_SEMI_BOLD(15) : FONT_PINGFANG_REGULAR(15);
            UIColor *textColor = classModel.isSelected ? COLOR_SYSTEM_MAIN_UI_THEME_DEFAULT : COLOR_SYSTEM_MAIN_FONT_DEFAULT;
            
            // 容器
            UIView *itemView = ({
                UIView *itemContainerView = [[UIView alloc] init];
                [itemContainerView setTag:8000+index];
                [self.publicContainerView addSubview:itemContainerView];
                
                UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pressItemView:)];
                [itemContainerView addGestureRecognizer:tapGesture];
                
                [itemContainerView mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.width.equalTo(@(itemWidth));
                    make.height.equalTo(@(itemHeight));
                    
                    if (!lastItemView) {
                        make.top.equalTo(titleContainer.mas_bottom).offset(top_gap);
                        make.left.equalTo(self.publicContainerView.mas_left);
                    } else {
                        if (index % colum == 0) {
                            make.top.equalTo(lastItemView.mas_bottom);
                            make.left.equalTo(self.publicContainerView.mas_left);
                        } else {
                            make.top.equalTo(lastItemView.mas_top);
                            make.left.equalTo(lastItemView.mas_right);
                        }
                    }
                }];
                itemContainerView.mas_key = [NSString stringWithFormat:@"itemContainerView%d",index];
                
                // 图片
                UIImageView *iconImageView = ({
                    UIImageView *imageView = [UIImageView new];
                    [itemContainerView addSubview:imageView];
                    [imageView setContentMode:UIViewContentModeScaleAspectFit];
                    
                    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.left.equalTo(itemContainerView.mas_left).offset(left_right_gap);
                        make.centerY.equalTo(itemContainerView.mas_centerY);
                        make.height.equalTo(@(imageSize));
                        make.width.equalTo(@(imageSize));
                    }];
                    
                    //
                    if (VALIDATE_STRING_HTTP_URL(classModel.imageUrl)) {
                        UIImage *placeholderImage = [UIImage imageNamed:ICON_COMMON_PLACEHOLDER];
                        [imageView sd_setImageWithURL:[NSURL URLWithString:classModel.imageUrl] placeholderImage:placeholderImage options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {

                        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                            UIImage *iconImage = [image imageWithChangeColor:textColor];
                            [imageView setImage:iconImage];
                        }];
                    } else {
                        UIImage *iconImage = [[UIImage imageNamed:classModel.imageUrl] imageWithChangeColor:textColor];
                        [imageView setImage:iconImage];
                    }
                    
                    imageView;
                });
                iconImageView.mas_key = [NSString stringWithFormat:@"iconImageView%d",index];
                
                // 标题
                UILabel *titleLabel = ({
                    UILabel *label = [UILabel new];
                    [itemContainerView addSubview:label];
                    [label setFont:textFont];
                    [label setTextColor:textColor];
                    [label setText:classModel.title];
                    [label setTextAlignment:NSTextAlignmentLeft];
                    
                    [label mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.left.equalTo(iconImageView.mas_right).offset(margin);
                        make.centerY.equalTo(itemContainerView.mas_centerY);
                        make.right.equalTo(itemContainerView.mas_right).offset(-margin);
                    }];
                    
                    label;
                });
                titleLabel.mas_key = [NSString stringWithFormat:@"titleLabel%d",index];
                
                //
                [_titleLabelArray addObject:titleLabel];
                [_pictureImageArray addObject:iconImageView];
                
                itemContainerView;
            });
            
            lastItemView = itemView;
        }
        
        // 约束的完整性
        [self.publicContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(lastItemView.mas_bottom).offset(bottom_gap).priority(749);
        }];
        
    } else {

        // 分割线
        UIView *separatorLineView = ({
            UIView *view = [[UIView alloc] init];
            [view setBackgroundColor:COLOR_TABLEVIEW_SEPARATOR_LINE_DEFAULT];
            [self.publicContainerView addSubview:view];
            
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.publicContainerView.mas_top);
                make.left.right.equalTo(self.publicContainerView);
                make.height.mas_equalTo(0.0f);
            }];
            
            view;
        });
        self.separatorLineView = separatorLineView;
        self.separatorLineView.mas_key = @"separatorLineView";
        
        // 约束的完整性
        [self.publicContainerView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(separatorLineView.mas_bottom).priority(749);
        }];
    }
    
}

#pragma mark - 触发操作事件
- (void)pressItemView:(UITapGestureRecognizer *)gesture
{
    UIView *itemView = (UIView*)gesture.view;
    
    NSUInteger index = itemView.tag - 8000;
    
    FYBillingSearchClassModel *realModel = (FYBillingSearchClassModel *)self.menuModel;
    if (index >= realModel.items.count) {
        FYLog(NSLocalizedString(@"数组越界，请检测代码。", nil));
        return;
    }

    FYBillingClassModel *classModel = [realModel.items objectAtIndex:index];
    [classModel setIsSelected:YES];
    if (classModel.didSelectedBlock) {
        classModel.didSelectedBlock(classModel);
    }
}


@end

