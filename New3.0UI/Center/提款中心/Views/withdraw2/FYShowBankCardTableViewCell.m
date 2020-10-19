//
//  FYShowBankCardTableViewCell.m
//  ProjectCSHB
//
//  Created by fangyuan on 2020/6/10.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "FYShowBankCardTableViewCell.h"
#import "FYMyBankCardModel.h"

// Cell Identifier
NSString * const CELL_IDENTIFIER_SHOW_BANKCARD_TABLEVIEW_CELL = @"FYShowBankCardTableViewCellIdentifier";

@interface FYShowBankCardTableViewCell ()
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
 * 银行名称
 */
@property (nonatomic, strong) UILabel *bankNameLabel;
/**
 * 提示信息
 */
@property (nonatomic, strong) UILabel *contentLabel;
/**
 * 银行卡号
 */
@property (nonatomic, strong) UILabel *bankNumLabel;
/**
 * 箭头控件
 */
@property (nonatomic, strong) UIImageView *selectedImageView;
/**
 * 分割线控件
 */
@property (nonatomic, strong) UIView *separatorLineView;

@end


@implementation FYShowBankCardTableViewCell

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
    
    // 选中标识
    UIImageView *selectedImageView = ({
        CGSize imageSize = CGSizeMake(CFC_AUTOSIZING_WIDTH(20.0f), CFC_AUTOSIZING_WIDTH(20.0f));
        UIImageView *imageView = [[UIImageView alloc] init];
        [publicContainerView addSubview:imageView];
        [imageView.layer setMasksToBounds:YES];
        [imageView setUserInteractionEnabled:YES];
        [imageView setContentMode:UIViewContentModeScaleAspectFit];
        [imageView setImage:[[UIImage imageNamed:@"icon_select"] imageByScalingProportionallyToSize:imageSize]];

        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(publicContainerView.mas_centerY);
            make.right.equalTo(publicContainerView.mas_right).offset(-margin*1.5f);
            make.size.mas_equalTo(imageSize);
        }];
        
        imageView;
    });
    self.selectedImageView = selectedImageView;
    self.selectedImageView.mas_key = @"selectedImageView";
    
    // 图标控件
    UIImageView *iconImageView = ({
        CGFloat imageSize = 40.0f;
        UIImageView *imageView = [[UIImageView alloc] init];
        [publicContainerView addSubview:imageView];
        [imageView setUserInteractionEnabled:YES];
        [imageView setContentMode:UIViewContentModeScaleAspectFit];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(imageSize, imageSize));
            make.centerY.equalTo(publicContainerView.mas_centerY);
            make.top.equalTo(publicContainerView.mas_top).offset(margin*1.0f);
            make.left.equalTo(publicContainerView.mas_left).offset(margin*0.5f);
        }];
        
        imageView;
    });
    self.iconImageView = iconImageView;
    self.iconImageView.mas_key = @"iconImageView";
    
    // 银行名称
    UILabel *bankNameLabel = ({
        UILabel *label = [UILabel new];
        [publicContainerView addSubview:label];
        [label setFont:[UIFont boldSystemFontOfSize:CFC_AUTOSIZING_FONT(14)]];
        [label setTextColor:COLOR_SYSTEM_MAIN_FONT_DEFAULT];
        [label setTextAlignment:NSTextAlignmentLeft];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(iconImageView.mas_centerY);
            make.left.equalTo(iconImageView.mas_right).offset(margin*0.7f);
        }];
        
        label;
    });
    self.bankNameLabel = bankNameLabel;
    self.bankNameLabel.mas_key = @"bankNameLabel";
    
    // 提示信息
    UILabel *contentLabel = ({
        UILabel *label = [UILabel new];
        [publicContainerView addSubview:label];
        [label setText:NSLocalizedString(@"2小时到账", nil)];
        [label setFont:[UIFont systemFontOfSize:CFC_AUTOSIZING_FONT(13)]];
        [label setTextColor:COLOR_SYSTEM_MAIN_FONT_ASSIST_DEFAULT];
        [label setTextAlignment:NSTextAlignmentLeft];

        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(bankNameLabel.mas_bottom).offset(margin*0.5f);
            make.left.equalTo(bankNameLabel.mas_left);
        }];
        
        label;
    });
    self.contentLabel = contentLabel;
    self.contentLabel.mas_key = @"contentLabel";
    
    // 银行卡号
    UILabel *bankNumLabel = ({
        UILabel *label = [UILabel new];
        [publicContainerView addSubview:label];
        [label setFont:[UIFont boldSystemFontOfSize:CFC_AUTOSIZING_FONT(14)]];
        [label setTextColor:COLOR_HEXSTRING(@"#F68B00")];
        [label setTextAlignment:NSTextAlignmentLeft];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(contentLabel.mas_centerY);
            make.left.equalTo(contentLabel.mas_right).offset(margin*4.0f);
        }];
        
        label;
    });
    self.bankNumLabel = bankNumLabel;
    self.bankNumLabel.mas_key = @"bankNumLabel";
    
    // 分割线
    UIView *separatorLineView = ({
        UIView *view = [[UIView alloc] init];
        [view setBackgroundColor:COLOR_TABLEVIEW_SEPARATOR_LINE_DEFAULT];
        [publicContainerView addSubview:view];
        
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(contentLabel.mas_bottom).offset(margin*1.3f);
            make.left.equalTo(publicContainerView.mas_left).offset(0.0f);
            make.right.equalTo(publicContainerView.mas_right).offset(0.0f);
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
- (void)setModel:(FYMyBankCardModel *)model
{
    if (![model isKindOfClass:[FYMyBankCardModel class]]) {
        return;
    }
    
    _model = model;

    [self.bankNameLabel setText:_model.bankName];
    [self.iconImageView setImage:_model.bankCardImage];
    [self.bankNumLabel setText:_model.upayNoHideStr];
    if (_model.isSelected) {
        [self.selectedImageView setHidden:NO];
    } else {
        [self.selectedImageView setHidden:YES];
    }
}

#pragma mark - 触发操作事件
- (void)pressPublicItemView:(UITapGestureRecognizer *)gesture
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectRowAtShowBankCardModel:indexPath:)]) {
        [self.delegate didSelectRowAtShowBankCardModel:self.model indexPath:self.indexPath];
    }
}


@end

