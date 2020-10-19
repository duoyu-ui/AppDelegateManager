//
//  FYAgentReportItem2TableViewCell.m
//  ProjectCSHB
//
//  Created by fangyuan on 2020/6/29.
//  Copyright © 2020 Fangyuan. All rights reserved.
//
// 代理报表 - 样式二
//

#import "FYAgentReportItem2TableViewCell.h"
#import "FYAgentReportItem2Model.h"

@interface FYAgentReportItem2TableViewCell ()
/**
 * 根容器组件
 */
@property (nonatomic, strong) UIView *rootContainerView;
/**
 * 公共容器
 */
@property (nonatomic, strong) UIView *publicContainerView;
/**
 * 游戏图标
 */
@property (nonatomic, strong) UIImageView *gameImageView;
/**
 * 游戏名称
 */
@property (nonatomic, strong) UILabel *gameNameLabel;
/**
 * 分割线
 */
@property (nonatomic, strong) UIView *topSplitLineH;

@end


@implementation FYAgentReportItem2TableViewCell

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

#pragma mark - 创建子控件
- (void)createViewAtuoLayout
{
    CGFloat margin = CFC_AUTOSIZING_MARGIN(MARGIN);
    CGFloat public_left_right_margin = margin;
    UIFont *itemNameFont = FONT_PINGFANG_REGULAR(14);
    UIColor *itemNameColor = COLOR_SYSTEM_MAIN_FONT_DEFAULT;

    // 根容器
    UIView *rootContainerView = ({
        UIView *view = [[UIView alloc] init];
        [view setBackgroundColor:COLOR_TABLEVIEW_SEPARATOR_LINE_DEFAULT];
        [self.contentView insertSubview:view atIndex:0];
        
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
        [view addCornerRadius:margin];
        [view setBackgroundColor:[UIColor whiteColor]];
        [rootContainerView addSubview:view];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pressPublicItemView:)];
        [view addGestureRecognizer:tapGesture];
        
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(rootContainerView.mas_left).offset(public_left_right_margin);
            make.top.equalTo(rootContainerView.mas_top);
            make.right.equalTo(rootContainerView.mas_right).offset(-public_left_right_margin);
            make.bottom.equalTo(rootContainerView.mas_bottom).offset(-margin*0.5f);
        }];
        
        view;
    });
    self.publicContainerView = publicContainerView;
    self.publicContainerView.mas_key = @"publicContainerView";
    
    // 图标
    UIImageView *gameImageView = ({
        UIImageView *imageView = [[UIImageView alloc] init];
        [publicContainerView addSubview:imageView];
        [imageView addCornerRadius:margin*0.5f];
        [imageView setUserInteractionEnabled:YES];
        [imageView setContentMode:UIViewContentModeScaleAspectFit];
        
        CGFloat imageSize = CFC_AUTOSIZING_WIDTH(28.0f);
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(publicContainerView.mas_top).offset(margin*0.5f);
            make.left.equalTo(publicContainerView.mas_left).offset(margin*1.0f);
            make.size.mas_equalTo(imageSize);
        }];
        
        imageView;
    });
    self.gameImageView = gameImageView;
    self.gameImageView.mas_key = @"gameImageView";
    
    // 名称
    UILabel *gameNameLabel = ({
        UILabel *label = [UILabel new];
        [publicContainerView addSubview:label];
        [label setText:STR_APP_TEXT_PLACEHOLDER];
        [label setFont:itemNameFont];
        [label setTextColor:itemNameColor];
        [label setTextAlignment:NSTextAlignmentLeft];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(gameImageView.mas_centerY);
            make.left.equalTo(gameImageView.mas_right).offset(margin*0.5f);
        }];
        
        label;
    });
    self.gameNameLabel = gameNameLabel;
    self.gameNameLabel.mas_key = @"gameNameLabel";
    
    // 分割线
    UIView *topSplitLineH = ({
        UIView *view = [[UIView alloc] init];
        [view setBackgroundColor:COLOR_TABLEVIEW_SEPARATOR_LINE_DEFAULT];
        [publicContainerView addSubview:view];
        
        CGFloat height = SEPARATOR_LINE_HEIGHT;
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(gameImageView.mas_bottom).offset(margin*0.5f);
            make.left.right.equalTo(publicContainerView);
            make.height.mas_equalTo(height);
        }];
        
        view;
    });
    self.topSplitLineH = topSplitLineH;
    self.topSplitLineH.mas_key = @"topSplitLineH";
}


#pragma mark - 设置数据模型
- (void)setModel:(FYAgentReportItem2Model *)model isLastIndexRow:(BOOL)isLastIndexRow
{
    if (![model isKindOfClass:[FYAgentReportItem2Model class]]) {
        return;
    }
    
    _model = model;
    
    // 图标
    if ([CFCSysUtil validateStringUrl:self.model.gameIco]) {
        UIImage *placeholderImage = [UIImage imageNamed:ICON_COMMON_PLACEHOLDER];
        [self.gameImageView sd_setImageWithURL:[NSURL URLWithString:self.model.gameIco] placeholderImage:placeholderImage options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {

        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {

        }];
    } else if (!VALIDATE_STRING_EMPTY(self.model.gameIco) && [UIImage imageNamed:self.model.gameIco]) {
        [self.gameImageView setImage:[UIImage imageNamed:self.model.gameIco]];
    } else {
        [self.gameImageView setImage:[UIImage imageNamed:ICON_COMMON_PLACEHOLDER]];
    }
    
    // 名称
    [self.gameNameLabel setText:self.model.gameName];
    
    // 项目列表
    {
        // 删除控件
        [self.publicContainerView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj.tag > 1000) {
                [obj removeFromSuperview];
            }
        }];
        
        // 重建控件
        NSInteger count = self.model.subitems ? self.model.subitems.count : 0;
        CGFloat margin = CFC_AUTOSIZING_MARGIN(MARGIN);
        if (count <= 0) {

            [self.publicContainerView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(self.topSplitLineH.mas_bottom).offset(margin*1.5f).priority(749);
            }];
        
        } else {
            
            UIFont *itemValueFont = FONT_PINGFANG_REGULAR(14);
            UIColor *itemValueColor = COLOR_SYSTEM_MAIN_FONT_DEFAULT;
            UIFont *itemTitleFont = FONT_PINGFANG_REGULAR(13);
            UIColor *itemTitleColor = COLOR_SYSTEM_MAIN_FONT_ASSIST_DEFAULT;
            //
            NSInteger column = count;
            CGFloat public_left_right_margin = margin;
            CGFloat item_left_right_margin = 0.0f;
            CGFloat item_top_bottom_margin = margin*1.5f;
            CGFloat item_margin = margin*0.2f;
            CGFloat item_title_value_margin = margin*0.25f;
            CGFloat item_width = (SCREEN_WIDTH-public_left_right_margin*2.0f-item_left_right_margin*2.0f-item_margin*(column-1)) / column;

            // 项目列表
            UILabel *lastItemLabel = nil;
            {
                for (NSInteger index = 0; index < count; index ++) {
                    
                    FYAgentReportItem2SubModel *itemModel = [self.model.subitems objectAtIndex:index];

                    // 内容
                    UILabel *itemValueLabel = ({
                        UILabel *label = [UILabel new];
                        [self.publicContainerView addSubview:label];
                        [label setText:itemModel.value];
                        [label setTag:1001+index];
                        [label setFont:itemValueFont];
                        [label setTextColor:itemValueColor];
                        [label setTextAlignment:NSTextAlignmentCenter];
                        
                        [label mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.width.equalTo(@(item_width));
                            if (!lastItemLabel) {
                                make.top.equalTo(self.topSplitLineH.mas_bottom).offset(item_top_bottom_margin);
                                make.left.equalTo(self.publicContainerView.mas_left).offset(item_left_right_margin);
                            } else {
                                if (index % column == 0) {
                                    make.top.equalTo(lastItemLabel.mas_bottom).offset(item_top_bottom_margin);
                                    make.left.equalTo(self.publicContainerView.mas_left).offset(item_left_right_margin);
                                } else {
                                    make.bottom.equalTo(lastItemLabel.mas_top).offset(-item_title_value_margin);
                                    make.left.equalTo(lastItemLabel.mas_right).offset(item_margin);
                                }
                            }
                        }];
                        
                        label;
                    });
                    itemValueLabel.mas_key = @"itemValueLabel";
                    
                    // 标题
                    UILabel *itemTitleLabel = ({
                        UILabel *label = [UILabel new];
                        [self.publicContainerView addSubview:label];
                        [label setText:itemModel.title];
                        [label setTag:2001+index];
                        [label setFont:itemTitleFont];
                        [label setTextColor:itemTitleColor];
                        [label setTextAlignment:NSTextAlignmentCenter];
                        
                        [label mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.width.equalTo(@(item_width));
                            make.top.equalTo(itemValueLabel.mas_bottom).offset(item_title_value_margin);
                            make.centerX.equalTo(itemValueLabel.mas_centerX);
                        }];
                        
                        label;
                    });
                    itemTitleLabel.mas_key = @"itemTitleLabel";
                    
                    // 分割线
                    if (index + 1 < count) {
                        UIView *itemSplitLineV = ({
                            UIView *view = [[UIView alloc] init];
                            [view setTag:3001+index];
                            [view setBackgroundColor:COLOR_TABLEVIEW_SEPARATOR_LINE_DEFAULT];
                            [self.publicContainerView addSubview:view];
                            
                            CGFloat width = SEPARATOR_LINE_HEIGHT;
                            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                                make.top.equalTo(itemValueLabel.mas_top).offset(-margin*0.5f);
                                make.bottom.equalTo(itemTitleLabel.mas_bottom).offset(margin*0.5f);
                                make.centerX.equalTo(itemTitleLabel.mas_right);
                                make.width.mas_equalTo(width);
                            }];
                            
                            view;
                        });
                        itemSplitLineV.mas_key = @"itemSplitLineV";
                    }
                    
                    lastItemLabel = itemTitleLabel;
                }
            }
            
            // 约束的完整性
            if (isLastIndexRow) {
                [self.publicContainerView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.bottom.equalTo(self.rootContainerView.mas_bottom).offset(-margin*1.0f);
                    make.bottom.equalTo(lastItemLabel.mas_bottom).offset(margin*1.5f).priority(749);
                }];
            } else {
                [self.publicContainerView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.bottom.equalTo(self.rootContainerView.mas_bottom).offset(-margin*0.5f);
                    make.bottom.equalTo(lastItemLabel.mas_bottom).offset(margin*1.5f).priority(749);
                }];
            }
        }
    }
    
}


#pragma mark - 触发操作事件
- (void)pressPublicItemView:(UITapGestureRecognizer *)gesture
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectRowAtAgentReportItem2Model:indexPath:)]) {
        [self.delegate didSelectRowAtAgentReportItem2Model:self.model indexPath:self.indexPath];
    }
}


@end

