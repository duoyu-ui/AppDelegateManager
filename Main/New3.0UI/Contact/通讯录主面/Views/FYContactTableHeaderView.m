//
//  FYContactTableHeaderView.m
//  ProjectCSHB
//
//  Created by fangyuan on 2020/6/15.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "FYContactMainViewController.h"
#import "FYContactTableHeaderView.h"


@interface FYContactTableHeaderView ()
//
@property (nonatomic, strong) UIView *searchContainer;
@property (nonatomic, strong) UIButton *searchButton;
//
@property (nonatomic, weak) FYContactMainViewController *parentViewController;
@property (nonatomic, assign) CGFloat headerHeight;

@end

@implementation FYContactTableHeaderView

#pragma mark - Actions

- (void)pressButtonActionOfSearch:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSearchActionFromContactTableHeaderView)]) {
        [self.delegate didSearchActionFromContactTableHeaderView];
    }
}


#pragma mark - Life Cycle

- (instancetype)initWithFrame:(CGRect)frame headerHeight:(CGFloat)headerHeight delegate:(id<FYContactTableHeaderViewDelegate>)delegate parentViewController:(FYContactMainViewController *)parentViewController
{
    self = [super initWithFrame:frame];
    if (self) {
        _delegate = delegate;
        _parentViewController = parentViewController;
        _headerHeight = headerHeight;
        [self createViewAtuoLayout];
    }
    return self;
}

- (void)createViewAtuoLayout
{
    [self viewDidAddSearchView];
    [self viewDidAddBottomLineView];
    [self setBackgroundColor:[UIColor whiteColor]];
}

- (void)viewDidAddSearchView
{
    CGFloat margin = CFC_AUTOSIZING_MARGIN(MARGIN);
    CGFloat searchContainerHeight = TABLEVIEW_HEADER_HEIGHT_FOR_CONTACTS_SEARCH; // 搜索 10 + searchHeight + 10
    CGFloat search_button_top_bottom_gap = 10.0f;
    
    // 容器
    [self addSubview:self.searchContainer];
    [self.searchContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top);
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.height.mas_equalTo(searchContainerHeight);
    }];
    
    // 搜索
    [self.searchContainer addSubview:self.searchButton];
    [self.searchButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.searchContainer.mas_top).offset(search_button_top_bottom_gap);
        make.left.equalTo(self.searchContainer.mas_left).offset(margin);
        make.right.equalTo(self.searchContainer.mas_right).offset(-margin);
        make.bottom.equalTo(self.searchContainer.mas_bottom).offset(-search_button_top_bottom_gap);
    }];
    
    // 图片
    UIImageView *iconImageView = ({
        UIImageView *imageView = [[UIImageView alloc] init];
        [self.searchButton addSubview:imageView];
        [imageView setImage:[UIImage imageNamed:@"icon_search"]];
        
        CGFloat imageSize = searchContainerHeight * 0.264f;
        CGFloat offset = imageSize*0.5f + margin*0.5f;
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.searchButton.mas_centerX).offset(-offset);
            make.centerY.equalTo(self.searchButton.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(imageSize, imageSize));
        }];
        
        imageView;
    });
    iconImageView.mas_key = @"iconImageView";
    
    // 标题
    UILabel *titleLabel = ({
        UILabel *titleLabel = [UILabel new];
        [self.searchButton addSubview:titleLabel];
        [titleLabel setText:NSLocalizedString(@"搜索", nil)];
        [titleLabel setFont:[UIFont boldSystemFontOfSize:CFC_AUTOSIZING_FONT(15.0f)]];
        [titleLabel setTextColor:COLOR_HEXSTRING(@"#B3B3B3")];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.searchButton.mas_centerX);
            make.centerY.equalTo(self.searchButton.mas_centerY);
        }];
        
        titleLabel;
    });
    titleLabel.mas_key = @"titleLabel";
}

- (void)viewDidAddBottomLineView
{
    CGFloat lineHeight = self.headerHeight - TABLEVIEW_HEADER_HEIGHT_FOR_CONTACTS_SEARCH;
    lineHeight = lineHeight > SEPARTOR_MARGIN_HEIGHT ? SEPARTOR_MARGIN_HEIGHT : lineHeight;
    UIView *separatorLineView = ({
        UIView *view = [[UIView alloc] init];
        [view setBackgroundColor:COLOR_TABLEVIEW_SEPARATOR_LINE_DEFAULT];
        [self addSubview:view];
        
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self);
            make.height.mas_equalTo(lineHeight);
        }];
        
        view;
    });
    separatorLineView.mas_key = @"separatorLineView";
}


#pragma mark - Getter/Setter

- (UIView *)searchContainer
{
    if(!_searchContainer)
    {
        _searchContainer= [[UIView alloc] init];
        [_searchButton setBackgroundColor:[UIColor whiteColor]];
    }
    return _searchContainer;
}

- (UIButton *)searchButton
{
    if(!_searchButton)
    {
        _searchButton= [UIButton buttonWithType:UIButtonTypeCustom];
        [_searchButton setBackgroundColor:COLOR_TABLEVIEW_BACK_VIEW_BACKGROUND_DEFAULT];
        [_searchButton addCornerRadius:5.0f];
        [_searchButton addTarget:self action:@selector(pressButtonActionOfSearch:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _searchButton;
}


@end

