//
//  FYBindBankCardNullTableViewCell.m
//  ProjectCSHB
//
//  Created by fangyuan on 2020/6/9.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "FYBindBankCardNullTableViewCell.h"
#import "FYMyBankCardModel.h"

// Cell Identifier
NSString * const CELL_IDENTIFIER_BIND_BANKCARD_NULL_TABLEVIEW_CELL = @"FYBindBankCardNullTableViewCelldentifier";

@interface FYBindBankCardNullTableViewCell ()
/**
 * 根容器组件
 */
@property (nonatomic, strong) UIView *rootContainerView;
/**
 * 公共容器
 */
@property (nonatomic, strong) UIView *publicContainerView;

// 标题
@property (nonatomic, strong) UIView *titleHeadView;
@property (nonatomic, strong) UIImageView *markImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *tipInfoLabel;
@property (nonatomic, copy) NSString *title;

// 分割线
@property (nonatomic, strong) UIView *markLineView;
@property (nonatomic, strong) UIView *separatorLineBottomView;


@end


@implementation FYBindBankCardNullTableViewCell


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
    CGFloat separatorLineHeight = 2.0f;
    CGFloat bankLogoSize = CFC_AUTOSIZING_WIDTH(35.0);
    CGFloat titleHeaderHeight = CFC_AUTOSIZING_WIDTH(45.0);
    CGFloat imageSize = titleHeaderHeight * 0.35f;
    
    [self.contentView setBackgroundColor:COLOR_TABLEVIEW_BACK_VIEW_BACKGROUND_DEFAULT];
    
    // 根容器
    UIView *rootContainerView = ({
        UIView *view = [[UIView alloc] init];
        [view setBackgroundColor:[UIColor whiteColor]];
        [self.contentView insertSubview:view atIndex:0];
        
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).offset(margin*1.5f);
            make.top.equalTo(self.contentView.mas_top).offset(margin*1.5f);
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
            make.left.equalTo(rootContainerView.mas_left);
            make.top.equalTo(rootContainerView.mas_top);
            make.right.equalTo(rootContainerView.mas_right);
            make.bottom.equalTo(rootContainerView.mas_bottom);
        }];
        
        view;
    });
    self.publicContainerView = publicContainerView;
    self.publicContainerView.mas_key = @"publicContainerView";
    
    // 标题
    self.titleHeadView = [[UIView alloc] init];
    [self.titleHeadView setBackgroundColor:[UIColor whiteColor]];
    [self.publicContainerView addSubview:self.titleHeadView];
    [self.titleHeadView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.publicContainerView);
        make.top.equalTo(self.publicContainerView.mas_top);
        make.height.mas_equalTo(titleHeaderHeight);
    }];
    
    // 图标
    self.markImageView = [[UIImageView alloc] init];
    [self.titleHeadView addSubview:self.markImageView];
    [self.markImageView setImage:[UIImage imageNamed:@"wh-gantanhao"]];
    [self.markImageView setContentMode:UIViewContentModeScaleAspectFit];
    [self.markImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.titleHeadView.mas_centerY);
        make.left.equalTo(self.titleHeadView.mas_left).offset(margin*0.8f);
        make.size.mas_equalTo(imageSize);
    }];
    
    // 标题
    self.titleLabel = [[UILabel alloc] init];
    [self.titleLabel setText:NSLocalizedString(@"温馨提示", nil)];
    [self.titleLabel setTextColor:COLOR_BANK_CARD_NORMAL];
    [self.titleLabel setFont:[UIFont systemFontOfSize:CFC_AUTOSIZING_FONT(16.0f)]];
    [self.titleHeadView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.markImageView.mas_right);
        make.centerY.equalTo(self.titleHeadView.mas_centerY);
    }];
    
    // 提示
    self.tipInfoLabel = [[UILabel alloc] init];
    [self.tipInfoLabel setText:NSLocalizedString(@"(第一次绑定银行卡,请输入持卡人真实姓名)", nil)];
    [self.tipInfoLabel setTextColor:COLOR_HEXSTRING(@"#A5A5A5") ];
    [self.tipInfoLabel setFont:[UIFont systemFontOfSize:CFC_AUTOSIZING_FONT(14.0f)]];
    [self.titleHeadView addSubview:self.tipInfoLabel];
    [self.tipInfoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel.mas_right);
        make.centerY.equalTo(self.titleHeadView.mas_centerY);
    }];
    
    // 分割线 - 下
    self.separatorLineBottomView = [[UIView alloc] init];
    [self.separatorLineBottomView setBackgroundColor:COLOR_TABLEVIEW_SEPARATOR_LINE_DEFAULT];
    [self.publicContainerView addSubview:self.separatorLineBottomView];
    [self.separatorLineBottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleHeadView.mas_bottom);
        make.left.right.equalTo(self.publicContainerView);
        make.height.mas_equalTo(separatorLineHeight);
    }];
    
    // 分割线 - 标记
    self.markLineView = [[UIView alloc] init];
    [self.markLineView setBackgroundColor:COLOR_SYSTEM_MAIN_UI_THEME_DEFAULT];
    [self.separatorLineBottomView addSubview:self.markLineView];
    [self.markLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.separatorLineBottomView);
        make.left.equalTo(self.separatorLineBottomView.mas_left).offset(margin*1.5f);
        make.right.equalTo(self.titleLabel.mas_right);
    }];

    // 银行图标
    UIImageView *bankImageView = ({
        CGSize imageSize = CGSizeMake(bankLogoSize, bankLogoSize);
        UIImageView *imageView = [[UIImageView alloc] init];
        [publicContainerView addSubview:imageView];
        [imageView setImage:[UIImage imageNamed:@"wh-packet-gray"]];
        [imageView setContentMode:UIViewContentModeScaleAspectFit];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.separatorLineBottomView.mas_bottom).offset(margin*5.0f);
            make.centerX.equalTo(publicContainerView.mas_centerX);
            make.size.mas_equalTo(imageSize);
        }];
        
        imageView;
    });
    bankImageView.mas_key = @"iconImageView";
    
    //
    UILabel *bankNameLabel = ({
        UILabel *label = [UILabel new];
        [publicContainerView addSubview:label];
        [label setText:NSLocalizedString(@"暂无银行卡", nil)];
        [label setFont:[UIFont boldSystemFontOfSize:CFC_AUTOSIZING_FONT(16)]];
        [label setTextColor:COLOR_SYSTEM_MAIN_UI_THEME_DEFAULT];
        [label setTextAlignment:NSTextAlignmentCenter];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(publicContainerView.mas_centerX);
            make.top.equalTo(bankImageView.mas_bottom).offset(margin*0.5f);
        }];
        
        label;
    });
    bankNameLabel.mas_key = @"bankNameLabel";
    
    UILabel *tipInfoLabel = ({
        UILabel *label = [UILabel new];
        [publicContainerView addSubview:label];
        [label setText:NSLocalizedString(@"请尽快绑定银行卡,以便您的提款及时到账", nil)];
        [label setFont:[UIFont boldSystemFontOfSize:CFC_AUTOSIZING_FONT(16)]];
        [label setTextColor:COLOR_HEXSTRING(@"#A5A5A5")];
        [label setTextAlignment:NSTextAlignmentCenter];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(publicContainerView.mas_centerX);
            make.top.equalTo(bankNameLabel.mas_bottom).offset(margin*0.5f);
            make.left.equalTo(publicContainerView.mas_left).offset(margin*1.0f);
            make.right.equalTo(publicContainerView.mas_right).with.offset(-margin*1.0f);
        }];
        
        label;
    });
    tipInfoLabel.mas_key = @"tipInfoLabel";
    
    //立即绑定银行卡
    UIButton *bingCardButton = ({
        UIFont *titleFont = [UIFont boldSystemFontOfSize:CFC_AUTOSIZING_FONT(18.0f)];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [publicContainerView addSubview:button];
        [button defaultStyleButton];
        [button.titleLabel setFont:titleFont];
        [button setUserInteractionEnabled:NO];
        [button setTitle:NSLocalizedString(@"立即绑定银行卡", nil) forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(tipInfoLabel.mas_bottom).offset(margin*1.0f);
            make.left.equalTo(publicContainerView.mas_left).offset(margin*3.0f);
            make.right.equalTo(publicContainerView.mas_right).with.offset(-margin*3.0f);
            make.height.equalTo(@(SYSTEM_GLOBAL_BUTTON_HEIGHT));
        }];
        
        button;
    });
    bingCardButton.mas_key = @"bingCardButton";
    
    // 约束的完整性
    [publicContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(bingCardButton.mas_bottom).offset(margin*1.5f).priority(749);
    }];
}

#pragma mark - 设置数据模型
- (void)setModel:(FYMyBankCardModel *)model
{
    if (![model isKindOfClass:[FYMyBankCardModel class]]) {
        return;
    }
    
    _model = model;

}

#pragma mark - 触发操作事件

// 点击银行卡
- (void)pressPublicItemView:(UITapGestureRecognizer *)gesture
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didBindAddCardAtBankCardModel:indexPath:)]) {
        [self.delegate didBindAddCardAtBankCardModel:self.model indexPath:self.indexPath];
    }
}


@end

