//
//  FYPayModeTableViewCell.m
//  ProjectCSHB
//
//  Created by fangyuan on 2020/5/18.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "FYPayModeTableViewCell.h"
#import "FYPayModeModel.h"

// Cell Identifier
NSString * const CELL_IDENTIFIER_PAY_MODE_TABLEVIEW_CELL = @"FYPayModeTableViewCellIdentifier";

@interface FYPayModeTableViewCell ()
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
 * 箭头控件
 */
@property (nonatomic, strong) UIImageView *arrowImageView;
/**
 * 分割线控件
 */
@property (nonatomic, strong) UIView *separatorLineView;

@end


@implementation FYPayModeTableViewCell

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
            make.left.equalTo(rootContainerView.mas_left).offset(0.0f);
            make.top.equalTo(rootContainerView.mas_top).offset(0.0f);
            make.right.equalTo(rootContainerView.mas_right).offset(0.0f);
            make.bottom.equalTo(rootContainerView.mas_bottom).offset(0.0f);
        }];
        
        view;
    });
    self.publicContainerView = publicContainerView;
    self.publicContainerView.mas_key = @"publicContainerView";
    
    // 箭头控件
    UIImageView *arrowImageView = ({
        CGSize imageSize = CGSizeMake(CFC_AUTOSIZING_WIDTH(25.0f), CFC_AUTOSIZING_WIDTH(25.0f));
        UIImageView *imageView = [[UIImageView alloc] init];
        [publicContainerView addSubview:imageView];
        [imageView.layer setMasksToBounds:YES];
        [imageView setUserInteractionEnabled:YES];
        [imageView setContentMode:UIViewContentModeScaleAspectFit];
        [imageView setImage:[[UIImage imageNamed:ICON_TABLEVIEW_CELL_ARROW] imageByScalingProportionallyToSize:imageSize]];

        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(publicContainerView.mas_centerY);
            make.right.equalTo(publicContainerView.mas_right).offset(-margin*1.5f);
            make.size.mas_equalTo(imageSize);
        }];
        
        imageView;
    });
    self.arrowImageView = arrowImageView;
    self.arrowImageView.mas_key = @"arrowImageView";
    
    // 图标控件
    UIImageView *iconImageView = ({
        UIImageView *imageView = [[UIImageView alloc] init];
        [publicContainerView addSubview:imageView];
        [imageView setUserInteractionEnabled:YES];
        [imageView setContentMode:UIViewContentModeScaleAspectFit];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(publicContainerView.mas_top).offset(margin*1.3f);
            make.left.equalTo(publicContainerView.mas_left).offset(margin*1.5f);
        }];
        
        imageView;
    });
    self.iconImageView = iconImageView;
    self.iconImageView.mas_key = @"iconImageView";
    
    // 标题控件
    UILabel *titleLabel = ({
        UILabel *label = [UILabel new];
        [publicContainerView addSubview:label];
        [label setNumberOfLines:1];
        [label setUserInteractionEnabled:YES];
        [label setText:STR_APP_TEXT_PLACEHOLDER];
        [label setFont:FONT_PINGFANG_SEMI_BOLD(15)];
        [label setTextColor:COLOR_SYSTEM_MAIN_FONT_DEFAULT];
        [label setTextAlignment:NSTextAlignmentLeft];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(iconImageView.mas_centerY);
            make.left.equalTo(iconImageView.mas_right).offset(margin*0.7f);
            make.right.equalTo(arrowImageView.mas_left).offset(-margin*0.5f);
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
        [label setTextColor:COLOR_SYSTEM_MAIN_FONT_ASSIST_DEFAULT];
        [label setTextAlignment:NSTextAlignmentLeft];

        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(titleLabel.mas_bottom).offset(margin*0.5f);
            make.left.equalTo(titleLabel.mas_left);
            make.right.equalTo(titleLabel.mas_right);
        }];
        
        label;
    });
    self.contentLabel = contentLabel;
    self.contentLabel.mas_key = @"contentLabel";
    
    // 分割线
    UIView *separatorLineView = ({
        UIView *view = [[UIView alloc] init];
        [view setBackgroundColor:COLOR_TABLEVIEW_SEPARATOR_LINE_DEFAULT];
        [publicContainerView addSubview:view];
        
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(contentLabel.mas_bottom).offset(margin*1.3f);
            make.left.equalTo(publicContainerView.mas_left).offset(margin*1.5f);
            make.right.equalTo(publicContainerView.mas_right).offset(-margin*1.5f);
            make.height.mas_equalTo(SEPARATOR_LINE_HEIGHT);
        }];
        
        view;
    });
    self.separatorLineView = separatorLineView;
    self.separatorLineView.mas_key = @"separatorLineView";
    
    // 约束的完整性
    [publicContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(separatorLineView.mas_bottom).offset(0.0f).priority(749);
    }];
}

#pragma mark - 设置数据模型
- (void)setModel:(FYPayModeModel *)model
{
    if (![model isKindOfClass:[FYPayModeModel class]]) {
        return;
    }
    
    _model = model;

    [self.titleLabel setText:model.title];
    if (self.indexPath.section > 0) {
        [self.titleLabel setFont:FONT_PINGFANG_REGULAR(15)];
    } else {
        [self.titleLabel setFont:FONT_PINGFANG_SEMI_BOLD(15)];
    }
    
    if (model.maxAmount.floatValue <= 0 || model.maxAmount.floatValue < model.minAmount.floatValue) {
        UIFont *textRemarksFont = FONT_PINGFANG_REGULAR(14);
        NSDictionary *attributesRemarks = @{ NSFontAttributeName:textRemarksFont,
                                             NSForegroundColorAttributeName:COLOR_SYSTEM_MAIN_FONT_DEFAULT};
        NSAttributedString *attributedString = [CFCSysUtil attributedString:@[model.chanelRemarks] attributeArray:@[attributesRemarks]];
        [self.contentLabel setAttributedText:attributedString];
    } else {
        UIFont *textFont = FONT_PINGFANG_REGULAR(14);
        NSDictionary *attributesText = @{ NSFontAttributeName:textFont,
                                           NSForegroundColorAttributeName:COLOR_SYSTEM_MAIN_FONT_ASSIST_DEFAULT};
        NSDictionary *attributesRemarks = @{ NSFontAttributeName:textFont,
                                             NSForegroundColorAttributeName:COLOR_SYSTEM_MAIN_FONT_DEFAULT};
        
        NSString *moeny = [NSString stringWithFormat:NSLocalizedString(@"单笔限额%@~%@元  ", nil), model.minAmount.stringValue, model.maxAmount.stringValue];
        NSArray<NSString *> *stringArray = @[moeny, model.chanelRemarks];
        NSArray *attributeArray = @[attributesText, attributesRemarks];
        NSAttributedString *attributedString = [CFCSysUtil attributedString:stringArray attributeArray:attributeArray];
        [self.contentLabel setAttributedText:attributedString];
    }
    
    if ([CFCSysUtil validateStringUrl:model.imageUrl]) {
        CGFloat margin = CFC_AUTOSIZING_MARGIN(MARGIN);
        CGFloat imageSize = CFC_AUTOSIZING_WIDTH(20.0f);
        CGFloat offset = (CFC_AUTOSIZING_WIDTH(27.0f) - imageSize) * 0.5f;
        [self.iconImageView addCornerRadius:imageSize*0.5f];
        [self.iconImageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.publicContainerView.mas_left).offset(margin*1.5f+offset);
            make.size.mas_equalTo(CGSizeMake(imageSize, imageSize));
        }];
        
        [self.titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.iconImageView.mas_right).offset(margin*0.7f+offset);
        }];
        
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
        CGFloat margin = CFC_AUTOSIZING_MARGIN(MARGIN);
        CGFloat imageSize = CFC_AUTOSIZING_WIDTH(27.0f);
        [self.iconImageView addCornerRadius:imageSize*0.5f];
        [self.iconImageView setImage:[UIImage imageNamed:model.imageUrl]];
        [self.iconImageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.publicContainerView.mas_left).offset(margin*1.5f);
            make.size.mas_equalTo(CGSizeMake(imageSize, imageSize));
        }];
        
        [self.titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.iconImageView.mas_right).offset(margin*0.7f);
        }];
    }
}

#pragma mark - 触发操作事件
- (void)pressPublicItemView:(UITapGestureRecognizer *)gesture
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectRowAtPayModeModel:indexPath:)]) {
        [self.delegate didSelectRowAtPayModeModel:self.model indexPath:self.indexPath];
    }
}


@end

