//
//  FYBankCardFuncTableViewCell.m
//  ProjectCSHB
//
//  Created by fangyuan on 2020/6/19.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "FYBankCardFuncTableViewCell.h"
#import "FYMyBankCardModel.h"

@interface FYBankCardFuncTableViewCell ()
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
 * 分割线控件
 */
@property (nonatomic, strong) UIView *separatorLineView;

@end


@implementation FYBankCardFuncTableViewCell


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
    CGFloat bankLogoSize = CFC_AUTOSIZING_WIDTH(35.0);

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
    
    // 银行图标
    UIImageView *bankImageView = ({
        CGSize imageSize = CGSizeMake(bankLogoSize, bankLogoSize);
        UIImageView *imageView = [[UIImageView alloc] init];
        [publicContainerView addSubview:imageView];
        [imageView setContentMode:UIViewContentModeScaleAspectFit];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(publicContainerView.mas_left).offset(margin*1.5f);
            make.centerY.equalTo(publicContainerView.mas_centerY);
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
        [label setFont:FONT_PINGFANG_SEMI_BOLD(16)];
        [label setTextColor:COLOR_SYSTEM_MAIN_FONT_DEFAULT];
        [label setTextAlignment:NSTextAlignmentLeft];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(bankImageView.mas_centerY);
            make.left.equalTo(bankImageView.mas_right).offset(margin*1.0f);
            make.right.equalTo(publicContainerView.mas_right).offset(-margin);
        }];
        
        label;
    });
    self.bankNameLabel = bankNameLabel;
    self.bankNameLabel.mas_key = @"bankNameLabel";
    
    // 分割线
    UIView *separatorLineView = ({
        UIView *view = [[UIView alloc] init];
        [view setBackgroundColor:COLOR_TABLEVIEW_SEPARATOR_LINE_DEFAULT];
        [publicContainerView addSubview:view];
        
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(bankImageView.mas_bottom).offset(margin*1.0f);
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

- (void)setModel:(FYMyBankCardModel *)model
{
    if (![model isKindOfClass:[FYMyBankCardModel class]]) {
        return;
    }
    
    _model = model;

    [self.bankNameLabel setText:model.bankName];
    [self.bankImageView setImage:[UIImage imageNamed:@"icon_bankcard_break"]];
}


#pragma mark - 触发操作事件

/// 点击银行卡
- (void)pressPublicItemView:(UITapGestureRecognizer *)gesture
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectRowAtFunctionBankCardModel:indexPath:)]) {
        [self.delegate didSelectRowAtFunctionBankCardModel:self.model indexPath:self.indexPath];
    }
}


@end


