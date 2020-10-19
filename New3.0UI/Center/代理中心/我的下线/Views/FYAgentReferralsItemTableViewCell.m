//
//  FYAgentReferralsItemTableViewCell.m
//  ProjectCSHB
//
//  Created by fangyuan on 2020/6/27.
//  Copyright © 2020 Fangyuan. All rights reserved.
//
// 我的下线 - 下线信息
//

#import "FYAgentReferralsItemTableViewCell.h"
#import "FYAgentReferralsItemModel.h"

#define COLOR_AGENT_CLASS_DAILI         COLOR_HEXSTRING(@"#E75E58")
#define COLOR_AGENT_CLASS_HUIYUAN       COLOR_HEXSTRING(@"#589BE7")
#define COLOR_NEW_REGISTER_USER         COLOR_HEXSTRING(@"#60D26B")

#define AGENT_REFERRALS_ITEM_TITLE_BETTING       NSLocalizedString(@"投注", nil)
#define AGENT_REFERRALS_ITEM_TITLE_PROFITLOSS    NSLocalizedString(@"游戏报表", nil)
#define AGENT_REFERRALS_ITEM_TITLE_BACKWATER     NSLocalizedString(@"返水", nil)
#define AGENT_REFERRALS_ITEM_TITLE_BALANCE       NSLocalizedString(@"余额", nil)

@interface FYAgentReferralsItemTableViewCell ()
/**
 * 根容器组件
 */
@property (nonatomic, strong) UIView *rootContainerView;
/**
 * 公共容器
 */
@property (nonatomic, strong) UIView *publicContainerView;
/**
 * 会员头像
 */
@property (nonatomic, strong) UIImageView *userImageView;
/**
 * 会员ID
 */
@property (nonatomic, strong) UILabel *userIdLabel;
/**
 * 会员分类
*/
@property (nonatomic, strong) UILabel *classLabel;
/**
 * 新的会员
*/
@property (nonatomic, strong) UILabel *isNewRegLabel;
/**
 * 用户详情
 */
@property (nonatomic, strong) UIImageView *detailImageView;
/**
 * 项目列表
 */
@property (nonatomic, strong) NSMutableArray<NSString *> *itemTitles;
@property (nonatomic, strong) NSMutableArray<UILabel *> *itemValueLabels;

@end


@implementation FYAgentReferralsItemTableViewCell

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
    UIFont *itemIdFont = FONT_PINGFANG_REGULAR(13);
    UIColor *itemIdColor = COLOR_SYSTEM_MAIN_FONT_ASSIST_DEFAULT;
    UIFont *itemValueFont = FONT_PINGFANG_REGULAR(14);
    UIColor *itemValueColor = COLOR_SYSTEM_MAIN_FONT_DEFAULT;
    UIFont *itemTitleFont = FONT_PINGFANG_REGULAR(13);
    UIColor *itemTitleColor = COLOR_SYSTEM_MAIN_FONT_ASSIST_DEFAULT;
    //
    NSInteger column = 4;
    CGFloat public_left_right_margin = margin;
    CGFloat item_left_right_margin = 0.0f;
    CGFloat item_top_bottom_margin = margin*1.5f;
    CGFloat item_margin = margin*0.2f;
    CGFloat item_title_value_margin = margin*0.25f;
    CGFloat item_width = (SCREEN_WIDTH-public_left_right_margin*2.0f-item_left_right_margin*2.0f-item_margin*(column-1)) / column;
    
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
    
    // 头像
    UIImageView *userImageView = ({
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
    self.userImageView = userImageView;
    self.userImageView.mas_key = @"userImageView";
    
    // 会员ID
    UILabel *userIdLabel = ({
        UILabel *label = [UILabel new];
        [publicContainerView addSubview:label];
        [label setText:STR_APP_TEXT_PLACEHOLDER];
        [label setFont:itemIdFont];
        [label setTextColor:itemIdColor];
        [label setTextAlignment:NSTextAlignmentLeft];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(userImageView.mas_centerY);
            make.left.equalTo(userImageView.mas_right).offset(margin*0.5f);
        }];
        
        label;
    });
    self.userIdLabel = userIdLabel;
    self.userIdLabel.mas_key = @"userIdLabel";
    
    // 类别[代理][会员]
    UILabel *classLabel = ({
        UIFont *font = FONT_PINGFANG_REGULAR(11);
        CGFloat width = [NSLocalizedString(@"占位", nil) widthWithFont:font constrainedToHeight:CGFLOAT_MAX]+margin*1.5f;
        CGFloat height = [NSLocalizedString(@"占位", nil) heightWithFont:font constrainedToWidth:CGFLOAT_MAX]+margin*0.15f;
        
        UILabel *label = [UILabel new];
        [publicContainerView addSubview:label];
        [label setFont:font];
        [label addCornerRadius:height*0.2f];
        [label setTextColor:[UIColor whiteColor]];
        [label setTextAlignment:NSTextAlignmentCenter];
        [label setBackgroundColor:COLOR_AGENT_CLASS_DAILI];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(userImageView.mas_centerY);
            make.left.equalTo(userIdLabel.mas_right).offset(margin*0.75f);
            make.size.mas_equalTo(CGSizeMake(width, height));
        }];
        
        label;
    });
    self.classLabel = classLabel;
    self.classLabel.mas_key = @"classLabel";
    
    // 新注册
    UILabel *isNewRegLabel = ({
        NSString *text = NSLocalizedString(@"新注册", nil);
        UIFont *font = FONT_PINGFANG_REGULAR(11);
        CGFloat width = [text widthWithFont:font constrainedToHeight:CGFLOAT_MAX]+margin*0.75f;
        CGFloat height = [text heightWithFont:font constrainedToWidth:CGFLOAT_MAX]+margin*0.15f;
        
        UILabel *label = [UILabel new];
        [publicContainerView addSubview:label];
        [label setText:text];
        [label setFont:font];
        [label setHidden:YES];
        [label addCornerRadius:height*0.2f];
        [label setTextColor:[UIColor whiteColor]];
        [label setTextAlignment:NSTextAlignmentCenter];
        [label setBackgroundColor:COLOR_NEW_REGISTER_USER];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(classLabel.mas_centerY);
            make.left.equalTo(classLabel.mas_right).offset(margin*0.3f);
            make.size.mas_equalTo(CGSizeMake(width, height));
        }];
        
        label;
    });
    self.isNewRegLabel = isNewRegLabel;
    self.isNewRegLabel.mas_key = @"newRegLabel";
    
    // 详情
    UIImageView *detailImageView = ({
        UIImageView *imageView = [[UIImageView alloc] init];
        [publicContainerView addSubview:imageView];
        [imageView addCornerRadius:margin*0.5f];
        [imageView setUserInteractionEnabled:YES];
        [imageView setImage:[UIImage imageNamed:@"icon_agent_share"]];
        [imageView setContentMode:UIViewContentModeScaleAspectFit];
        
        CGFloat imageSize = CFC_AUTOSIZING_WIDTH(15.0f);
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(userImageView.mas_centerY);
            make.right.equalTo(publicContainerView.mas_right).offset(-margin*1.5f);
            make.size.mas_equalTo(imageSize);
        }];
        
        imageView;
    });
    self.detailImageView = detailImageView;
    self.detailImageView.mas_key = @"detailImageView";
    
    // 分割线
    UIView *topSplitLineH = ({
        UIView *view = [[UIView alloc] init];
        [view setBackgroundColor:COLOR_TABLEVIEW_SEPARATOR_LINE_DEFAULT];
        [publicContainerView addSubview:view];
        
        CGFloat height = SEPARATOR_LINE_HEIGHT;
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(userImageView.mas_bottom).offset(margin*0.5f);
            make.left.right.equalTo(publicContainerView);
            make.height.mas_equalTo(height);
        }];
        
        view;
    });
    topSplitLineH.mas_key = @"topSplitLineH";
    
    // 项目列表
    UILabel *lastItemLabel = nil;
    {
        
        _itemValueLabels = @[].mutableCopy;
        _itemTitles = @[ AGENT_REFERRALS_ITEM_TITLE_BETTING,
                         AGENT_REFERRALS_ITEM_TITLE_PROFITLOSS,
                         AGENT_REFERRALS_ITEM_TITLE_BALANCE,
                         AGENT_REFERRALS_ITEM_TITLE_BACKWATER ].mutableCopy;
        for (NSInteger index = 0; index < self.itemTitles.count; index ++) {
            
            NSString *itemString = [self.itemTitles objectAtIndex:index];
            
            // 内容
            UILabel *itemValueLabel = ({
                UILabel *label = [UILabel new];
                [publicContainerView addSubview:label];
                [label setText:@"0.00"];
                [label setFont:itemValueFont];
                [label setTextColor:itemValueColor];
                [label setTextAlignment:NSTextAlignmentCenter];
                
                [label mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.width.equalTo(@(item_width));

                    if (!lastItemLabel) {
                        make.top.equalTo(topSplitLineH.mas_bottom).offset(item_top_bottom_margin);
                        make.left.equalTo(publicContainerView.mas_left).offset(item_left_right_margin);
                    } else {
                        make.bottom.equalTo(lastItemLabel.mas_top).offset(-item_title_value_margin);
                        make.left.equalTo(lastItemLabel.mas_right).offset(item_margin);
                    }
                }];
                
                label;
            });
            itemValueLabel.mas_key = @"itemValueLabel";
            
            // 标题
            UILabel *itemTitleLabel = ({
                UILabel *label = [UILabel new];
                [publicContainerView addSubview:label];
                [label setText:itemString];
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
            if (index + 1 < self.itemTitles.count) {
                UIView *itemSplitLineV = ({
                    UIView *view = [[UIView alloc] init];
                    [view setBackgroundColor:COLOR_TABLEVIEW_SEPARATOR_LINE_DEFAULT];
                    [publicContainerView addSubview:view];
                    
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
            
            [_itemValueLabels addObj:itemValueLabel];
            
            lastItemLabel = itemTitleLabel;
        }
    }
    
    // 约束的完整性
    [publicContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(lastItemLabel.mas_bottom).offset(margin*1.5f).priority(749);
    }];
}


#pragma mark - 设置数据模型
- (void)setModel:(FYAgentReferralsItemModel *)model isLastIndexRow:(BOOL)isLastIndexRow
{
    if (![model isKindOfClass:[FYAgentReferralsItemModel class]]) {
        return;
    }
    
    _model = model;

    // 最后一个表格
    CGFloat margin = CFC_AUTOSIZING_MARGIN(MARGIN);
    if (isLastIndexRow) {
        [self.publicContainerView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.rootContainerView.mas_bottom).offset(-margin*1.0f);
        }];
    } else {
        [self.publicContainerView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.rootContainerView.mas_bottom).offset(-margin*0.5f);
        }];
    }
    
    // 会员头像
    if ([CFCSysUtil validateStringUrl:model.imageUrl]) {
        UIImage *placeholderImage = [UIImage imageNamed:ICON_MESSAGE_USER_AVATAR_PLACEHOLDER];
        [self.userImageView sd_setImageWithURL:[NSURL URLWithString:model.imageUrl] placeholderImage:placeholderImage options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {

        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {

        }];
    } else if (!VALIDATE_STRING_EMPTY(model.imageUrl) && [UIImage imageNamed:model.imageUrl]) {
        [self.userImageView setImage:[UIImage imageNamed:model.imageUrl]];
    } else {
        [self.userImageView setImage:[UIImage imageNamed:ICON_MESSAGE_USER_AVATAR_PLACEHOLDER]];
    }
    
    // 会员ID
    [self.userIdLabel setText:[NSString stringWithFormat:@"ID:%ld", (long)self.model.userId.integerValue]];
    
    // 分类
    if (self.model.proxy.boolValue) {
        [self.classLabel setText:NSLocalizedString(@"代理", nil)];
        [self.classLabel setBackgroundColor:COLOR_AGENT_CLASS_DAILI];
    } else {
        [self.classLabel setText:NSLocalizedString(@"会员", nil)];
        [self.classLabel setBackgroundColor:COLOR_AGENT_CLASS_HUIYUAN];
    }
    
    // 新注册
    [self.isNewRegLabel setHidden:!self.model.isNewReg.boolValue];
    
    // 用户详情
    [self.detailImageView setHidden:!self.model.isLookSubUser.boolValue];
    
    // 项目列表
    for (NSInteger index = 0; index < self.itemTitles.count; index ++) {
        NSString *itemTitle = [self.itemTitles objectAtIndex:index];
        UILabel *itemLabel = [self.itemValueLabels objectAtIndex:index];
        if ([AGENT_REFERRALS_ITEM_TITLE_BETTING isEqualToString:itemTitle]) {
            [itemLabel setText:[NSString stringWithFormat:@"%.2f", self.model.bett.floatValue]];
        } else if ([AGENT_REFERRALS_ITEM_TITLE_PROFITLOSS isEqualToString:itemTitle]) {
            [itemLabel setText:[NSString stringWithFormat:@"%.2f", self.model.profitLoss.floatValue]];
        } else if ([AGENT_REFERRALS_ITEM_TITLE_BALANCE isEqualToString:itemTitle]) {
            [itemLabel setText:[NSString stringWithFormat:@"%.2f", self.model.banlance.floatValue]];
        } else if ([AGENT_REFERRALS_ITEM_TITLE_BACKWATER isEqualToString:itemTitle]) {
            [itemLabel setText:[NSString stringWithFormat:@"%.2f", self.model.backWater.floatValue]];
        }
    }
}


#pragma mark - 触发操作事件
- (void)pressPublicItemView:(UITapGestureRecognizer *)gesture
{
    if (!self.model.isLookSubUser.boolValue) {
        return;
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectRowAtAgentReferralsItemModel:indexPath:)]) {
        [self.delegate didSelectRowAtAgentReferralsItemModel:self.model indexPath:self.indexPath];
    }
}


@end

