//
//  FYSearchBarView.m
//  ProjectCSHB
//
//  Created by fangyuan on 2020/7/8.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "FYSearchBarView.h"

@interface FYSearchBarView ()
@property (nonatomic, strong) UIView *searchContainer;
@property (nonatomic, strong) UIButton *searchButton;

@end

@implementation FYSearchBarView

#pragma mark - Actions

- (void)pressButtonActionOfSearch:(id)sender
{
    if (self.searchActionBlock) {
        self.searchActionBlock();
    }
}


#pragma mark - Height

+ (CGFloat)heightOfSearchBar
{
    return [[self class] heightOfSearchBarButton] + [[self class] heightOfSearchBarSpline];
}

+ (CGFloat)heightOfSearchBarButton
{
    return 58.0; // 搜索
}

+ (CGFloat)heightOfSearchBarSpline
{
    return 0.6f; // 间隔
}


#pragma mark - Life Cycle

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [self initWithFrame:frame searchPlaceholder:NSLocalizedString(@"搜索", nil)];
    if (self) {
        [self createViewAtuoLayout];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame searchPlaceholder:(NSString *)searchPlaceholder
{
    self = [super initWithFrame:frame];
    if (self) {
        _searchPlaceholder = searchPlaceholder;
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
    UIFont *searchTextFont = [UIFont boldSystemFontOfSize:CFC_AUTOSIZING_FONT(15.0f)];
    CGFloat searchContainerHeight = [[self class] heightOfSearchBarButton]; // 搜索 10 + searchHeight + 10
    CGFloat search_button_top_bottom_gap = 10.0f;
    CGFloat imageSize = searchContainerHeight * 0.264f;
    CGFloat imagePlaceHolderMargin = margin*0.5f;
    CGFloat searchPlaceHolderWidth = [self.searchPlaceholder widthWithFont:searchTextFont constrainedToHeight:CGFLOAT_MAX];
    CGFloat searchTotalWidth = imageSize + imagePlaceHolderMargin+ searchPlaceHolderWidth;
    
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
        
        CGFloat offset = searchTotalWidth*0.5f;
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.searchButton.mas_centerX).offset(-offset);
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
        [titleLabel setText:self.searchPlaceholder];
        [titleLabel setFont:searchTextFont];
        [titleLabel setTextColor:COLOR_HEXSTRING(@"#B3B3B3")];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(iconImageView.mas_right).offset(imagePlaceHolderMargin);
            make.centerY.equalTo(self.searchButton.mas_centerY);
        }];
        
        titleLabel;
    });
    titleLabel.mas_key = @"titleLabel";
}

- (void)viewDidAddBottomLineView
{
    CGFloat lineHeight = [[self class] heightOfSearchBarSpline];
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

