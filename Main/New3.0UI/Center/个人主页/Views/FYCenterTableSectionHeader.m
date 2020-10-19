//
//  FYCenterTableSectionHeader.m
//  ProjectCSHB
//
//  Created by fangyuan on 2020/5/19.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "FYCenterTableSectionHeader.h"

@interface FYCenterTableSectionHeader ()

// 根容器组件
@property (nonnull, nonatomic, strong) UIView *rootContainerView;

// 标题
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, copy) NSString *title;

// 分割线
@property (nonatomic, strong) UIView *separatorLineView;

// 高度
@property (nonatomic, assign) CGFloat headerHeight;

@end


@implementation FYCenterTableSectionHeader

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
    
    // 标题
    self.titleLabel = [[UILabel alloc] init];
    NSDictionary *titleDict = @{ NSFontAttributeName:FONT_COMMON_TABLE_SECTION_TITLE,
                                 NSForegroundColorAttributeName:COLOR_SYSTEM_MAIN_FONT_DEFAULT };
    NSAttributedString *attributedTitle = [[NSAttributedString alloc] initWithString:_title attributes:titleDict];
    self.titleLabel.attributedText = attributedTitle;
    [self.rootContainerView addSubview:self.titleLabel];
    
    // 分割线
    self.separatorLineView = [[UIView alloc] init];
    [self.separatorLineView setBackgroundColor:COLOR_TABLEVIEW_SEPARATOR_LINE_DEFAULT];
    [self.rootContainerView addSubview:self.self.separatorLineView];
}

- (void)setViewAtuoLayout
{
    // 间距
    CGFloat margin = CFC_AUTOSIZING_MARGIN(MARGIN);
    
    // 根容器
    [self.rootContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self);
        make.left.equalTo(self.mas_left).offset(margin);
        make.right.equalTo(self.mas_right).offset(-margin);
    }];
    
    // 标题
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.rootContainerView.mas_left).offset(margin*1.5f);
        make.right.equalTo(self.rootContainerView.mas_right).offset(-margin*1.5f);
        make.centerY.equalTo(self.mas_centerY);
    }];
    
    // 分割线
    [self.separatorLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.rootContainerView);
        make.height.mas_equalTo(SEPARATOR_LINE_HEIGHT);
    }];
    
    // 圆角
    {
        CGFloat cornerRadius = margin*1.0f;
        CGRect frame = CGRectMake(0, 0, SCREEN_MIN_LENGTH-margin*2.0f, self.headerHeight);
        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:frame byRoundingCorners:UIRectCornerTopLeft|UIRectCornerTopRight cornerRadii:CGSizeMake(cornerRadius,cornerRadius)];
        CAShapeLayer *mask = [[CAShapeLayer alloc] init];
        mask.frame = frame;
        mask.path = path.CGPath;
        self.rootContainerView.layer.mask = mask;
    }
}


@end

