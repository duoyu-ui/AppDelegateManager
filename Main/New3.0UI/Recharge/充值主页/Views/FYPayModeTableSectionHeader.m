//
//  FYPayModeTableSectionHeader.m
//  ProjectCSHB
//
//  Created by fangyuan on 2020/5/18.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "FYPayModeTableSectionHeader.h"

@interface FYPayModeTableSectionHeader ()

// 根容器组件
@property (nonnull, nonatomic, strong) UIView *rootContainerView;

// 标题
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, copy) NSString *title;

// 详情
@property (nonatomic, assign) BOOL isShowMoreBtn;
@property (nonatomic, strong) UILabel *moreInfoLabel;
@property (nonatomic, strong) UIView *moreContainerView;

// 分割线
@property (nonatomic, strong) UIView *topSeparatorLineView;
@property (nonatomic, strong) UIView *bottomSeparatorLineView;

// 高度
@property (nonatomic, assign) CGFloat headerViewHeight;

// 第N个Section
@property (nonatomic, assign) NSInteger tableSection;

@end


@implementation FYPayModeTableSectionHeader

- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title headerViewHeight:(CGFloat)headerViewHeight showMoreButton:(BOOL)isShowMoreButton tableSecion:(NSInteger)tableSection
{
    self = [super initWithFrame:frame];
    if (self) {
        _title = title;
        _tableSection = tableSection;
        _isShowMoreBtn = isShowMoreButton;
        _headerViewHeight = headerViewHeight;
        [self createView];
        [self setViewAtuoLayout];
    }
    return self;
}

- (void)createView
{
    // 根容器
    self.rootContainerView = [[UIView alloc] init];
    [self.rootContainerView setBackgroundColor:[UIColor whiteColor]];
    [self addSubview:self.rootContainerView];
    
    // 标题
    self.titleLabel = [[UILabel alloc] init];
    NSDictionary *titleDict = @{ NSFontAttributeName:FONT_COMMON_TABLE_SECTION_TITLE,
                                 NSForegroundColorAttributeName:COLOR_SYSTEM_MAIN_FONT_DEFAULT };
    NSAttributedString *attributedTitle = [[NSAttributedString alloc] initWithString:_title attributes:titleDict];
    self.titleLabel.attributedText = attributedTitle;
    [self.rootContainerView addSubview:self.titleLabel];
    
    // 更多
    {
        self.moreContainerView = [[UIView alloc] init];
        [self.moreContainerView setClipsToBounds:YES];
        [self.rootContainerView addSubview:self.self.moreContainerView];
        
        self.moreInfoLabel = [[UILabel alloc] init];
        NSDictionary *titleDict = @{ NSFontAttributeName:[UIFont systemFontOfSize:CFC_AUTOSIZING_FONT(14.0)],
                                     NSForegroundColorAttributeName:COLOR_SYSTEM_MAIN_FONT_ASSIST_DEFAULT };
        NSAttributedString *attributedTitle = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"查看更多", nil) attributes:titleDict];
        [self.moreInfoLabel setAttributedText:attributedTitle];
        [self.moreInfoLabel setUserInteractionEnabled:YES];
        [self.moreContainerView addSubview:self.moreInfoLabel];

        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pressHeaderAction:)];
        [self.moreContainerView addGestureRecognizer:tapGesture];
    }
    
    // 分割线
    self.topSeparatorLineView = [[UIView alloc] init];
    [self.topSeparatorLineView setBackgroundColor:COLOR_TABLEVIEW_SEPARATOR_LINE_DEFAULT];
    [self.rootContainerView addSubview:self.self.topSeparatorLineView];
    //
    self.bottomSeparatorLineView = [[UIView alloc] init];
    [self.bottomSeparatorLineView setBackgroundColor:COLOR_TABLEVIEW_SEPARATOR_LINE_DEFAULT];
    [self.rootContainerView addSubview:self.self.bottomSeparatorLineView];
}

- (void)setViewAtuoLayout
{
    // 间距
    CGFloat margin = CFC_AUTOSIZING_MARGIN(MARGIN);
    
    // 根容器组件
    [self.rootContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(@0);
    }];
    
    // 标题
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.rootContainerView.mas_left).offset(margin*1.5f);
        make.right.equalTo(self.rootContainerView.mas_right).offset(-margin*1.5f);
        make.centerY.equalTo(self.mas_centerY).offset(margin*0.2f);
    }];
    
    // 更多
    {
        [self.moreContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.rootContainerView.mas_top);
            make.right.equalTo(self.rootContainerView.mas_right);
            make.bottom.equalTo(self.rootContainerView.mas_bottom);
            if (_isShowMoreBtn) {
                make.width.equalTo(@(100));
            } else {
                make.width.equalTo(@(0.0));
            }
            
        }];

        [self.moreInfoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.moreContainerView.mas_right).with.offset(-margin*1.0f);
            make.centerY.equalTo(self.moreContainerView.mas_centerY);
        }];
    }
    
    // 分割线
    [self.topSeparatorLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.rootContainerView);
        make.height.mas_equalTo(0);
    }];
    [self.bottomSeparatorLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.rootContainerView);
        make.left.right.equalTo(self.titleLabel);
        make.height.mas_equalTo(SEPARATOR_LINE_HEIGHT);
    }];
}

#pragma mark - 触发操作事件
- (void)pressHeaderAction:(UITapGestureRecognizer *)gesture
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectAtPayModeTableSecionHeader:)]) {
        [self.delegate didSelectAtPayModeTableSecionHeader:self.tableSection];
    }
}


@end
