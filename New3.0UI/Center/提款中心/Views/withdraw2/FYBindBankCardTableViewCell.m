//
//  FYBindBankCardTableViewCell.m
//  ProjectCSHB
//
//  Created by fangyuan on 2020/6/8.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "FYBindBankCardTableViewCell.h"
#import "FYMyBankCardModel.h"


// Cell Identifier
NSString * const CELL_IDENTIFIER_BIND_BANKCARD_TABLEVIEW_CELL = @"FYBindBankCardTableViewCelldentifier";

@interface FYBindBankCardTableViewCell ()
/**
 * 根容器组件
 */
@property (nonatomic, strong) UIView *rootContainerView;
/**
 * 公共容器
 */
@property (nonatomic, strong) UIView *publicContainerView;
/**
 * 银行图标
 */
@property (nonatomic, strong) UIImageView *bankImageView;
/**
 * 银行名称
 */
@property (nonatomic, strong) UILabel *bankNameLabel;
/**
 * 银行卡号
 */
@property (nonatomic, strong) UIView *bankCardNumberView;
/**
 * 银行卡号
 */
@property (nonatomic, strong) UILabel *bankCardNumberLabel;
/**
 * 用户姓名
 */
@property (nonatomic, strong) UILabel *bankUserNameLabel;
/**
 * 解除绑定
 */
@property (nonatomic, strong) UIButton *unBingCardButton;
/**
 * 选中标识
 */
@property (nonatomic, strong) UIImageView *selectedImageView;

@end


@implementation FYBindBankCardTableViewCell

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
    CGFloat bankLogoSize = CFC_AUTOSIZING_WIDTH(35.0);
    CGFloat bankMarkSize = CFC_AUTOSIZING_WIDTH(30.0);
    CGFloat bankNumberHeight = CFC_AUTOSIZING_WIDTH(30.0);
    CGFloat bankUserHeight = CFC_AUTOSIZING_WIDTH(40.0);
    
    [self.contentView setBackgroundColor:COLOR_TABLEVIEW_BACK_VIEW_BACKGROUND_DEFAULT];
    
    // 根容器
    UIView *rootContainerView = ({
        UIView *view = [[UIView alloc] init];
        [view setBackgroundColor:[UIColor whiteColor]];
        [self.contentView insertSubview:view atIndex:0];
        
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).offset(margin*1.5f);
            make.top.equalTo(@0.0f);
            make.right.equalTo(self.contentView.mas_right).offset(-margin*1.5f);
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
            make.left.equalTo(rootContainerView.mas_left).offset(margin*2.0f);
            make.top.equalTo(rootContainerView.mas_top).offset(margin*1.5f);
            make.right.equalTo(rootContainerView.mas_right).offset(-margin*2.0f);
            make.bottom.equalTo(rootContainerView.mas_bottom).offset(-margin*0.5f);
        }];
        
        view;
    });
    self.publicContainerView = publicContainerView;
    self.publicContainerView.mas_key = @"publicContainerView";
    
    // 选中标识
    UIImageView *selectedImageView = ({
        CGSize imageSize = CGSizeMake(bankMarkSize, bankMarkSize);
        UIImageView *imageView = [[UIImageView alloc] init];
        [publicContainerView addSubview:imageView];
        [imageView setHidden:YES];
        [imageView setImage:[UIImage imageNamed:@"bank-selected"]];
        [imageView setContentMode:UIViewContentModeScaleAspectFit];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.right.equalTo(publicContainerView);
            make.size.mas_equalTo(imageSize);
        }];
        
        imageView;
    });
    self.selectedImageView = selectedImageView;
    self.selectedImageView.mas_key = @"selectedImageView";
    
    // 银行图标
    UIImageView *bankImageView = ({
        CGSize imageSize = CGSizeMake(bankLogoSize, bankLogoSize);
        UIImageView *imageView = [[UIImageView alloc] init];
        [publicContainerView addSubview:imageView];
        [imageView setContentMode:UIViewContentModeScaleAspectFit];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(publicContainerView.mas_top).offset(margin*0.5f);
            make.left.equalTo(publicContainerView.mas_left).offset(margin*1.0f);
            make.size.mas_equalTo(imageSize);
        }];
        
        imageView;
    });
    self.bankImageView = bankImageView;
    self.bankImageView.mas_key = @"iconImageView";
    
    // 银行名称
    UILabel *bankNameLabel = ({
        UILabel *label = [UILabel new];
        [publicContainerView addSubview:label];
        [label setFont:[UIFont boldSystemFontOfSize:CFC_AUTOSIZING_FONT(16)]];
        [label setTextColor:COLOR_BANK_CARD_NORMAL];
        [label setTextAlignment:NSTextAlignmentLeft];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(bankImageView.mas_centerY);
            make.left.equalTo(bankImageView.mas_right).offset(margin*0.5f);
            make.right.equalTo(publicContainerView.mas_right).offset(-margin);
        }];
        
        label;
    });
    self.bankNameLabel = bankNameLabel;
    self.bankNameLabel.mas_key = @"bankNameLabel";
    
    // 银行卡号
    UIView *bankCardNumberView = ({
        UIView *view = [[UIView alloc] init];
        [view setBackgroundColor:COLOR_BANK_CARD_NORMAL];
        [publicContainerView addSubview:view];

        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(bankImageView.mas_bottom).offset(margin*0.5f);
            make.left.right.equalTo(publicContainerView);
            make.height.mas_equalTo(bankNumberHeight);
        }];
        
        view;
    });
    self.bankCardNumberView = bankCardNumberView;
    self.bankCardNumberView.mas_key = @"bankCardNumberView";
    
    // 银行卡号
    UILabel *bankCardNumberLabel = ({
        UILabel *label = [UILabel new];
        [bankCardNumberView addSubview:label];
        [label setText:@"**** **** **** **** ****"];
        [label setTextColor:[UIColor whiteColor]];
        [label setTextAlignment:NSTextAlignmentLeft];
        [label setFont:[UIFont boldSystemFontOfSize:CFC_AUTOSIZING_FONT(16)]];

        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(bankCardNumberView);
            make.left.equalTo(bankCardNumberView.mas_left).offset(margin*1.0f);
            make.right.equalTo(bankCardNumberView.mas_right).offset(-margin*0.5f);
        }];
        
        label;
    });
    self.bankCardNumberLabel = bankCardNumberLabel;
    self.bankCardNumberLabel.mas_key = @"bankCardNumberLabel";
    
    // 用户姓名
    UILabel *bankUserNameLabel = ({
        UILabel *label = [UILabel new];
        [publicContainerView addSubview:label];
        [label setFont:[UIFont boldSystemFontOfSize:CFC_AUTOSIZING_FONT(14)]];
        [label setTextColor:COLOR_SYSTEM_MAIN_FONT_ASSIST_DEFAULT];
        [label setTextAlignment:NSTextAlignmentLeft];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(bankCardNumberView.mas_bottom);
            make.left.equalTo(publicContainerView.mas_left).offset(margin*1.0f);
            make.right.equalTo(publicContainerView.mas_right).offset(-margin);
            make.height.mas_equalTo(bankUserHeight);
        }];
        
        label;
    });
    self.bankUserNameLabel = bankUserNameLabel;
    self.bankUserNameLabel.mas_key = @"bankUserNameLabel";
    
    // 解除绑定
    UIButton *unBingCardButton = ({
        UIFont *titleFont = [UIFont boldSystemFontOfSize:CFC_AUTOSIZING_FONT(14.0f)];
        CGFloat width = [NSLocalizedString(@"解除绑定", nil) widthWithFont:titleFont constrainedToHeight:CGFLOAT_MAX]+margin*4.0f;
        CGFloat height = [NSLocalizedString(@"解除绑定", nil) heightWithFont:titleFont constrainedToWidth:CGFLOAT_MAX]+margin*0.8f;
        //
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [publicContainerView addSubview:button];
        [button defaultStyleButton];
        [button addCornerRadius:height*0.5f];
        [button.titleLabel setFont:titleFont];
        [button setTitle:NSLocalizedString(@"解除绑定", nil) forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(pressUnBindCardButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        //
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(bankUserNameLabel.mas_centerY);
            make.right.equalTo(publicContainerView.mas_right).offset(-margin*1.0f);
            make.size.mas_equalTo(CGSizeMake(width, height));
        }];
        
        button;
    });
    self.unBingCardButton = unBingCardButton;
    self.unBingCardButton.mas_key = @"unBingCardButton";
    
    // 约束的完整性
    [publicContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(bankUserNameLabel.mas_bottom).priority(749);
    }];
}

#pragma mark - 设置数据模型
- (void)setModel:(FYMyBankCardModel *)model
{
    if (![model isKindOfClass:[FYMyBankCardModel class]]) {
        return;
    }
    
    _model = model;

    CGFloat margin = CFC_AUTOSIZING_MARGIN(MARGIN);
    
    [self.bankImageView setImage:model.bankCardImage];
    [self.bankNameLabel setText:model.bankName];
    [self.bankCardNumberLabel setText:model.upayNoHideStr];
    [self.bankUserNameLabel setText:[NSString stringWithFormat:NSLocalizedString(@"持卡人：%@", nil), model.user]];
    if (!model.isSelected) {
        [self.selectedImageView setHidden:YES];
        [self.bankCardNumberView setBackgroundColor:COLOR_BANK_CARD_NORMAL];
        [self.publicContainerView addBorderWithColor:COLOR_BANK_CARD_NORMAL cornerRadius:margin*0.7f andWidth:1.5f];
    } else {
        [self.selectedImageView setHidden:NO];
        [self.bankCardNumberView setBackgroundColor:COLOR_BANK_CARD_SELECT];
        [self.publicContainerView addBorderWithColor:COLOR_BANK_CARD_SELECT cornerRadius:margin*0.7f andWidth:1.5f];
    }
    
}

#pragma mark - 触发操作事件

// 点击银行卡
- (void)pressPublicItemView:(UITapGestureRecognizer *)gesture
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectRowAtBankCardModel:indexPath:)]) {
        [self.delegate didSelectRowAtBankCardModel:self.model indexPath:self.indexPath];
    }
}


// 解除绑定
- (void)pressUnBindCardButtonAction:(UIButton *)button
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didUnBindCardAtBankCardModel:indexPath:)]) {
        [self.delegate didUnBindCardAtBankCardModel:self.model indexPath:self.indexPath];
    }
}


@end

