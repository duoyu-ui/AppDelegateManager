//
//  FYBillingRecordTableViewCell.m
//  ProjectCSHB
//
//  Created by fangyuan on 2020/6/20.
//  Copyright © 2020 Fangyuan. All rights reserved.
//
// 账单
//

#import "FYBillingRecordTableViewCell.h"
#import "FYBillingRecordModel.h"


@interface FYBillingRecordTableViewCell ()
/**
 * 根容器组件
 */
@property (nonatomic, strong) UIView *rootContainerView;
/**
 * 公共容器
 */
@property (nonatomic, strong) UIView *publicContainerView;
/**
 * 图片控件
 */
@property (nonatomic, strong) UIImageView *iconImageView;
/**
 * 标题控件
 */
@property (nonatomic, strong) UILabel *titleLabel;
/**
 * 内容控件
 */
@property (nonatomic, strong) UILabel *contentLabel;
/**
 * 金额控件
 */
@property (nonatomic, strong) UILabel *moneyLabel;
/**
 * 时间控件
 */
@property (nonatomic, strong) UILabel *datetimeLabel;
/**
 * 分割线控件
 */
@property (nonatomic, strong) UIView *separatorLineView;

@end


@implementation FYBillingRecordTableViewCell

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
    
    // 根容器
    UIView *rootContainerView = ({
        UIView *view = [[UIView alloc] init];
        [view setBackgroundColor:[UIColor whiteColor]];
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
        [rootContainerView addSubview:view];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pressPublicItemView:)];
        [view addGestureRecognizer:tapGesture];
        
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
    
    // 图标控件
    UIImageView *iconImageView = ({
        CGFloat imageSize = CFC_AUTOSIZING_WIDTH(35.0f);
        UIImageView *imageView = [[UIImageView alloc] init];
        [publicContainerView addSubview:imageView];
        [imageView setUserInteractionEnabled:YES];
        [imageView addCornerRadius:imageSize*0.5f];
        [imageView setContentMode:UIViewContentModeScaleAspectFit];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(publicContainerView.mas_left).offset(margin*1.5f);
            make.centerY.equalTo(publicContainerView.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(imageSize, imageSize));
        }];
        
        imageView;
    });
    self.iconImageView = iconImageView;
    self.iconImageView.mas_key = @"iconImageView";
    
    // 金额控件
    UILabel *moneyLabel = ({
        UILabel *label = [UILabel new];
        [publicContainerView addSubview:label];
        [label setText:STR_APP_TEXT_PLACEHOLDER];
        [label setFont:FONT_PINGFANG_SEMI_BOLD(16)];
        [label setTextColor:COLOR_SYSTEM_MAIN_FONT_DEFAULT];
        [label setTextAlignment:NSTextAlignmentRight];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(iconImageView.mas_top);
            make.right.equalTo(publicContainerView.mas_right).offset(-margin*1.5f);
        }];
        
        label;
    });
    self.moneyLabel = moneyLabel;
    self.moneyLabel.mas_key = @"moneyLabel";
    
    // 标题控件
    UILabel *titleLabel = ({
        UILabel *label = [UILabel new];
        [publicContainerView addSubview:label];
        [label setText:STR_APP_TEXT_PLACEHOLDER];
        [label setFont:FONT_PINGFANG_REGULAR(15)];
        [label setTextColor:COLOR_SYSTEM_MAIN_FONT_DEFAULT];
        [label setTextAlignment:NSTextAlignmentLeft];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(iconImageView.mas_top);
            make.left.equalTo(iconImageView.mas_right).offset(margin*1.0f);
            make.right.equalTo(moneyLabel.mas_left).offset(-margin*1.0f);
        }];
        
        label;
    });
    self.titleLabel = titleLabel;
    self.titleLabel.mas_key = @"titleLabel";
    
    // 内容控件
    UILabel *contentLabel = ({
        UILabel *label = [UILabel new];
        [publicContainerView addSubview:label];
        [label setNumberOfLines:1];
        [label setUserInteractionEnabled:YES];
        [label setText:STR_APP_TEXT_PLACEHOLDER];
        [label setFont:FONT_PINGFANG_REGULAR(13)];
        [label setTextColor:COLOR_SYSTEM_MAIN_FONT_ASSIST_DEFAULT];
        [label setTextAlignment:NSTextAlignmentLeft];

        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(titleLabel.mas_bottom).offset(margin*0.25f);
            make.left.equalTo(titleLabel.mas_left);
            make.right.equalTo(titleLabel.mas_right);
        }];
        
        label;
    });
    self.contentLabel = contentLabel;
    self.contentLabel.mas_key = @"contentLabel";
    
    // 时间控件
    UILabel *datetimeLabel = ({
        UILabel *label = [UILabel new];
        [publicContainerView addSubview:label];
        [label setText:STR_APP_TEXT_PLACEHOLDER];
        [label setFont:FONT_PINGFANG_REGULAR(13)];
        [label setTextColor:COLOR_HEXSTRING(@"#C5C5C5")];
        [label setTextAlignment:NSTextAlignmentRight];

        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(titleLabel.mas_bottom).offset(margin*0.25f);
            make.right.equalTo(moneyLabel.mas_right);
        }];
        
        label;
    });
    self.datetimeLabel = datetimeLabel;
    self.datetimeLabel.mas_key = @"datetimeLabel";
    
    // 分割线
    UIView *separatorLineView = ({
        UIView *view = [[UIView alloc] init];
        [view setBackgroundColor:COLOR_TABLEVIEW_SEPARATOR_LINE_DEFAULT];
        [publicContainerView addSubview:view];
        
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(iconImageView.mas_bottom).offset(margin*1.5f);
            make.left.equalTo(publicContainerView.mas_left);
            make.right.equalTo(publicContainerView.mas_right);
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
}

#pragma mark - 设置数据模型
- (void)setModel:(FYBillingRecordModel *)model
{
    if (![model isKindOfClass:[FYBillingRecordModel class]]) {
        return;
    }
    
    _model = model;

    // 标题
    [self.titleLabel setText:model.title];
    
    // 详情
    [self.contentLabel setText:model.content];
    
    // 时间
    [self.datetimeLabel setText:model.createTime];
    
    // 金额
    if ([self.model.money containsString:@"-"]) {
        UIFont *textFont = FONT_PINGFANG_SEMI_BOLD(16);
        NSDictionary *attrText = @{ NSFontAttributeName:textFont,
                                    NSForegroundColorAttributeName:COLOR_SYSTEM_MAIN_FONT_DEFAULT};
        NSString *content = [NSString stringWithFormat:@"%@", self.model.money];
        NSAttributedString *attrString = [CFCSysUtil attributedString:@[content] attributeArray:@[attrText]];
        [self.moneyLabel setAttributedText:attrString];
    } else if ([self.model.money containsString:@"+"]) {
        UIFont *textFont = FONT_PINGFANG_SEMI_BOLD(16);
        NSDictionary *attrText = @{ NSFontAttributeName:textFont,
                                    NSForegroundColorAttributeName:COLOR_SYSTEM_MAIN_UI_THEME_DEFAULT};
        NSString *content = [NSString stringWithFormat:@"%@", self.model.money];
        NSAttributedString *attrString = [CFCSysUtil attributedString:@[content] attributeArray:@[attrText]];
        [self.moneyLabel setAttributedText:attrString];
    } else {
        UIFont *textFont = FONT_PINGFANG_SEMI_BOLD(16);
        NSDictionary *attrText = @{ NSFontAttributeName:textFont,
                                    NSForegroundColorAttributeName:COLOR_HEXSTRING(@"#6B6B6B")};
        NSString *content = [NSString stringWithFormat:@"%@", self.model.money];
        NSAttributedString *attrString = [CFCSysUtil attributedString:@[content] attributeArray:@[attrText]];
        [self.moneyLabel setAttributedText:attrString];
    }

    // 图标
    if ([CFCSysUtil validateStringUrl:model.imageUrl]) {
        __block UIActivityIndicatorView *activityIndicator = nil;
        UIImage *placeholderImage = [UIImage imageNamed:@"icon_commonpay"];
        [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:model.imageUrl] placeholderImage:placeholderImage options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                if (!activityIndicator) {
                    [self.iconImageView addSubview:activityIndicator = [UIActivityIndicatorView.alloc initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite]];
                    [activityIndicator setColor:COLOR_ACTIVITY_INDICATOR_BACKGROUND];
                    [activityIndicator setCenter:self.iconImageView.center];
                    [activityIndicator startAnimating];
                    [activityIndicator mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.centerX.equalTo(self.iconImageView.mas_centerX);
                        make.centerY.equalTo(self.iconImageView.mas_centerY);
                    }];
                }
            }];
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            [activityIndicator removeFromSuperview];
            activityIndicator = nil;
        }];
    } else {
        [self.iconImageView setImage:[UIImage imageNamed:model.imageUrl]];
    }
}


#pragma mark - 触发操作事件
- (void)pressPublicItemView:(UITapGestureRecognizer *)gesture
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectRowAtBillingRecordModel:indexPath:)]) {
        [self.delegate didSelectRowAtBillingRecordModel:self.model indexPath:self.indexPath];
    }
}


@end

