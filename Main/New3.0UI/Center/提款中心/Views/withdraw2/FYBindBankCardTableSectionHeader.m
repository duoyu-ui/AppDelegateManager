//
//  FYBindBankCardTableSectionHeader.m
//  ProjectCSHB
//
//  Created by fangyuan on 2020/6/9.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "FYBindBankCardTableSectionHeader.h"
#import "FYMyBankCardModel.h"

@interface FYBindBankCardTableSectionHeader ()

// 根容器组件
@property (nonnull, nonatomic, strong) UIView *rootContainerView;

// 标题
@property (nonatomic, strong) UIView *titleHeadView;
@property (nonatomic, strong) UIImageView *markImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *tipInfoLabel;
@property (nonatomic, copy) NSString *title;

// 分割线
@property (nonatomic, strong) UIView *markLineView;
@property (nonatomic, strong) UIView *separatorLineTopView;
@property (nonatomic, strong) UIView *separatorLineBottomView;

// 高度
@property (nonatomic, assign) CGFloat headerHeight;

@end


@implementation FYBindBankCardTableSectionHeader

- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title headerHeight:(CGFloat)headerHeight
{
    self = [super initWithFrame:frame];
    if (self) {
        _title = title;
        _headerHeight = headerHeight;
        [self createView];
        [self setViewAtuoLayout];
    }
    return self;
}

- (void)createView
{
    [self setBackgroundColor:COLOR_TABLEVIEW_BACK_VIEW_BACKGROUND_DEFAULT];
    
    // 根容器
    self.rootContainerView = [[UIView alloc] init];
    [self.rootContainerView setBackgroundColor:[UIColor whiteColor]];
    [self addSubview:self.rootContainerView];
    
    // 分割线 - 上
    self.separatorLineTopView = [[UIView alloc] init];
    [self.separatorLineTopView setBackgroundColor:COLOR_TABLEVIEW_SEPARATOR_LINE_DEFAULT];
    [self.rootContainerView addSubview:self.separatorLineTopView];
    
    // 标题
    self.titleHeadView = [[UIView alloc] init];
    [self.titleHeadView setBackgroundColor:[UIColor whiteColor]];
    [self.rootContainerView addSubview:self.titleHeadView];
    
    // 图标
    self.markImageView = [[UIImageView alloc] init];
    [self.titleHeadView addSubview:self.markImageView];
    [self.markImageView setImage:[UIImage imageNamed:@"wh-packet-gray"]];
    [self.markImageView setContentMode:UIViewContentModeScaleAspectFit];
    
    // 标题
    self.titleLabel = [[UILabel alloc] init];
    [self.titleLabel setText:NSLocalizedString(@"已绑定银行卡", nil)];
    [self.titleLabel setTextColor:COLOR_BANK_CARD_NORMAL];
    [self.titleLabel setFont:[UIFont boldSystemFontOfSize:CFC_AUTOSIZING_FONT(16.0f)]];
    [self.titleHeadView addSubview:self.titleLabel];
    
    // 提示
    self.tipInfoLabel = [[UILabel alloc] init];
    [self.tipInfoLabel setText:NSLocalizedString(@"（最多可绑定3张银行卡）", nil)];
    [self.tipInfoLabel setTextColor:COLOR_HEXSTRING(@"#A5A5A5") ];
    [self.tipInfoLabel setFont:[UIFont boldSystemFontOfSize:CFC_AUTOSIZING_FONT(14.0f)]];
    [self.titleHeadView addSubview:self.tipInfoLabel];
    
    // 分割线 - 下
    self.separatorLineBottomView = [[UIView alloc] init];
    [self.separatorLineBottomView setBackgroundColor:COLOR_TABLEVIEW_SEPARATOR_LINE_DEFAULT];
    [self.rootContainerView addSubview:self.separatorLineBottomView];
    
    // 分割线 - 标记
    self.markLineView = [[UIView alloc] init];
    [self.markLineView setBackgroundColor:COLOR_SYSTEM_MAIN_UI_THEME_DEFAULT];
    [self.separatorLineBottomView addSubview:self.markLineView];
}

- (void)setViewAtuoLayout
{
    // 间距
    CGFloat margin = CFC_AUTOSIZING_MARGIN(MARGIN);
    CGFloat separatorLineHeight = 2.0f;
    CGFloat titleHeaderHeight = self.headerHeight - margin*1.5f - separatorLineHeight;
    CGFloat imageSize = titleHeaderHeight * 0.6f;
    
    // 根容器
    [self.rootContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self);
        make.left.equalTo(self.mas_left).offset(margin*1.5f);
        make.right.equalTo(self.mas_right).offset(-margin*1.5f);
    }];
    
    // 分割线 - 上
    [self.separatorLineTopView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.rootContainerView);
        make.height.mas_equalTo(margin*1.5f);
    }];
    
    // 标题
    [self.titleHeadView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.rootContainerView);
        make.top.equalTo(self.separatorLineTopView.mas_bottom);
        make.height.mas_equalTo(titleHeaderHeight);
    }];
    
    // 图标
    [self.markImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.titleHeadView.mas_centerY);
        make.left.equalTo(self.titleHeadView.mas_left).offset(margin*1.5f);
        make.size.mas_equalTo(imageSize);
    }];
    
    // 标题
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.markImageView.mas_right).offset(margin*0.5f);
        make.centerY.equalTo(self.titleHeadView.mas_centerY);
    }];
    
    // 提示
    [self.tipInfoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel.mas_right);
        make.centerY.equalTo(self.titleHeadView.mas_centerY);
    }];
    
    // 分割线
    [self.separatorLineBottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.rootContainerView);
        make.height.mas_equalTo(separatorLineHeight);
    }];
    
    // 标记
    [self.markLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.separatorLineBottomView);
        make.left.equalTo(self.separatorLineBottomView.mas_left).offset(margin*1.5f);
        make.right.equalTo(self.titleLabel.mas_right);
    }];
}


@end

