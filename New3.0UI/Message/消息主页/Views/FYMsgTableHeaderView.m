//
//  FYMsgTableHeaderView.m
//  ProjectCSHB
//
//  Created by fangyuan on 2020/5/28.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "FYMessageMainViewController.h"
#import "FYMsgTableHeaderView.h"
#import "FYMsgNoticeModel.h"
#import "UUMarqueeView.h"

@interface FYMsgTableHeaderView () <UUMarqueeViewDelegate>
//
@property (nonatomic, strong) UIView *searchContainer;
@property (nonatomic, strong) UIButton *searchButton;
//
@property (nonatomic, strong) UIView *noticeMarqueeContainer;
@property (nonatomic, strong) UUMarqueeView *noticeMarqueeView;
@property (nonatomic, strong) NSMutableArray<FYMsgNoticeModel *> *arrayOfNoticeModels;
//
@property (nonatomic, weak) FYMessageMainViewController *parentViewController;
@property (nonatomic, assign) CGFloat headerHeight;

@end

@implementation FYMsgTableHeaderView

#pragma mark - Actions

- (void)pressButtonActionOfSearch:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSearchActionFromMsgTableHeaderView)]) {
        [self.delegate didSearchActionFromMsgTableHeaderView];
    }
}


#pragma mark - Life Cycle

- (instancetype)initWithFrame:(CGRect)frame headerHeight:(CGFloat)headerHeight delegate:(id<FYMsgTableHeaderViewDelegate>)delegate parentViewController:(FYMessageMainViewController *)parentViewController
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
    [self viewDidAddNoticeView];
    [self viewDidAddBottomLineView];
    [self setBackgroundColor:[UIColor whiteColor]];
}

- (void)viewDidAddSearchView
{
    CGFloat margin = CFC_AUTOSIZING_MARGIN(MARGIN);
    CGFloat searchContainerHeight = TABLEVIEW_HEADER_HEIGHT_FOR_MSG_SEARCH; // 搜索 10 + searchHeight + 10
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

- (void)viewDidAddNoticeView
{
    CGFloat margin = CFC_AUTOSIZING_MARGIN(MARGIN);
    CGFloat noticeMarqueeHeight = TABLEVIEW_HEADER_HEIGHT_FOR_MSG_NOTICE;
    
    // 通知容器
    [self addSubview:self.noticeMarqueeContainer];
    [self.noticeMarqueeContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.searchContainer.mas_bottom);
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.height.mas_equalTo(noticeMarqueeHeight);
    }];
    
    // 闹钟图片
    UIImageView *trumpetImageView = ({
        UIImageView *imageView = [[UIImageView alloc] init];
        [self.noticeMarqueeContainer addSubview:imageView];
        [imageView setImage:[UIImage imageNamed:ICON_GAMES_TRUMPET]];
        
        CGFloat imageSize = noticeMarqueeHeight > 25 ? 25 : noticeMarqueeHeight * 0.75f;
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.noticeMarqueeContainer.mas_left).offset(margin*0.9f);
            make.centerY.equalTo(self.noticeMarqueeContainer.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(imageSize, imageSize));
        }];

        imageView;
    });
    trumpetImageView.mas_key = @"trumpetImageView";
    
    // 通知信息
    [self.noticeMarqueeContainer addSubview:self.noticeMarqueeView];
    [self.noticeMarqueeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(trumpetImageView.mas_right).offset(margin*0.25f);
        make.right.equalTo(self.noticeMarqueeContainer.mas_right).offset(-margin*1.2f);
        make.top.equalTo(self.noticeMarqueeContainer.mas_top);
        make.bottom.equalTo(self.noticeMarqueeContainer.mas_bottom);
    }];
    
    // 通知数据
    if (!self.arrayOfNoticeModels || self.arrayOfNoticeModels.count == 0) {
        [self.noticeMarqueeContainer mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.searchContainer.mas_bottom);
            make.left.equalTo(self.mas_left);
            make.right.equalTo(self.mas_right);
            make.height.mas_equalTo(noticeMarqueeHeight);
        }];
    } else {
        [self.noticeMarqueeView reloadData];
    }
}

- (void)viewDidAddBottomLineView
{
    CGFloat lineHeight = self.headerHeight - TABLEVIEW_HEADER_HEIGHT_FOR_MSG_SEARCH - TABLEVIEW_HEADER_HEIGHT_FOR_MSG_NOTICE;
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


#pragma mark - FYMessageMainViewControllerProtocol

- (void)doRefreshForMsgHeaderWithNoticeModels:(NSMutableArray<FYMsgNoticeModel *> *)noticeModels
{
    if (!self.arrayOfNoticeModels || self.arrayOfNoticeModels.count <= 0) {
        [self setArrayOfNoticeModels:noticeModels];
        [self.noticeMarqueeView reloadData];
        [self.noticeMarqueeView start];
    } else {
        WEAKSELF(weakSelf)
        if (noticeModels.count >= self.arrayOfNoticeModels.count) {
            [noticeModels enumerateObjectsWithIndex:^(FYMsgNoticeModel *itemNoticeModel, NSUInteger index) {
                if (index < weakSelf.arrayOfNoticeModels.count) {
                    FYMsgNoticeModel *originModel = [weakSelf.arrayOfNoticeModels objectAtIndex:index];
                    if (itemNoticeModel.uuid.integerValue != originModel.uuid.integerValue) {
                        [weakSelf.arrayOfNoticeModels replaceObjectAtIndex:index withObject:itemNoticeModel];
                    }
                } else {
                    [weakSelf.arrayOfNoticeModels addObj:itemNoticeModel];
                }
            }];
        } else {
            [self.arrayOfNoticeModels enumerateObjectsWithIndex:^(FYMsgNoticeModel *originModel, NSUInteger index) {
                if (index < noticeModels.count) {
                    FYMsgNoticeModel *itemNoticeModel = [noticeModels objectAtIndex:index];
                    if (itemNoticeModel.uuid.integerValue != originModel.uuid.integerValue) {
                        [weakSelf.arrayOfNoticeModels replaceObjectAtIndex:index withObject:itemNoticeModel];
                    }
                } else {
                    NSInteger idx = index % noticeModels.count;
                    FYMsgNoticeModel *itemNoticeModel = [noticeModels objectAtIndex:idx];
                    [weakSelf.arrayOfNoticeModels replaceObjectAtIndex:index withObject:itemNoticeModel];
                }
            }];
        }
    }
}


#pragma mark - UUMarqueeViewDelegate

- (NSUInteger)numberOfVisibleItemsForMarqueeView:(UUMarqueeView*)marqueeView
{
    return 1;
}

- (NSUInteger)numberOfDataForMarqueeView:(UUMarqueeView*)marqueeView
{
    return self.arrayOfNoticeModels ? self.arrayOfNoticeModels.count : 0;
}

- (void)createItemView:(UIView*)itemView forMarqueeView:(UUMarqueeView*)marqueeView
{
    UILabel *contentLabel = [[UILabel alloc] initWithFrame:itemView.bounds];
    contentLabel.tag = 1001;
    contentLabel.font = FONT_PINGFANG_REGULAR(14);
    contentLabel.textColor = COLOR_SYSTEM_MAIN_FONT_ASSIST_DEFAULT;
    contentLabel.textAlignment = NSTextAlignmentLeft;
    [itemView addSubview:contentLabel];
}

- (CGFloat)itemViewWidthAtIndex:(NSUInteger)index forMarqueeView:(UUMarqueeView*)marqueeView
{
    FYMsgNoticeModel *model = [self.arrayOfNoticeModels objectAtIndex:index];
    UILabel *contentLabel = [[UILabel alloc] init];
    contentLabel.textAlignment = NSTextAlignmentLeft;
    contentLabel.font = FONT_PINGFANG_REGULAR(14);
    contentLabel.textColor = COLOR_SYSTEM_MAIN_FONT_ASSIST_DEFAULT;
    contentLabel.text = [NSString stringWithFormat:@"%@", [CFCSysUtil stringByTrimmingWhitespaceAndNewline:model.content]];
    return contentLabel.intrinsicContentSize.width;
}

- (void)updateItemView:(UIView*)itemView atIndex:(NSUInteger)index forMarqueeView:(UUMarqueeView*)marqueeView
{
    FYMsgNoticeModel *model = [self.arrayOfNoticeModels objectAtIndex:index];
    UILabel *contentLabel = [itemView viewWithTag:1001];
    contentLabel.text = [NSString stringWithFormat:@"%@", [CFCSysUtil stringByTrimmingWhitespaceAndNewline:model.content]];
}

- (void)didTouchItemViewAtIndex:(NSUInteger)index forMarqueeView:(UUMarqueeView*)marqueeView
{
    FYMsgNoticeModel *model = [self.arrayOfNoticeModels objectAtIndex:index];
    if (model.isLoacl.boolValue) {
        ALTER_INFO_MESSAGE(NSLocalizedString(@"没有公告信息", nil))
        return;
    }
    NSString *sessionId = [FYSysMsgNoticeEntity reuseChatSysMsgNoticeSessionId];
    FYSystemNewMessageController *viewController = [[FYSystemNewMessageController alloc] initWithSessionId:sessionId];
    [self.parentViewController.navigationController pushViewController:viewController animated:YES];
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

- (UIView *)noticeMarqueeContainer
{
    if(!_noticeMarqueeContainer)
    {
        _noticeMarqueeContainer= [[UIView alloc] init];
        [_noticeMarqueeContainer setBackgroundColor:[UIColor whiteColor]];
    }
    return _noticeMarqueeContainer;
}

- (UUMarqueeView *)noticeMarqueeView
{
    if(!_noticeMarqueeView)
    {
        _noticeMarqueeView= [[UUMarqueeView alloc] initWithFrame:CGRectZero direction:UUMarqueeViewDirectionLeftward];
        _noticeMarqueeView.delegate = self;
        _noticeMarqueeView.timeIntervalPerScroll = 0.0f;
        _noticeMarqueeView.scrollSpeed = 40.0f;
        _noticeMarqueeView.itemSpacing = 30.0f;
        _noticeMarqueeView.touchEnabled = YES;
    }
    return _noticeMarqueeView;
}

- (NSMutableArray<FYMsgNoticeModel *> *)arrayOfNoticeModels
{
    if (!_arrayOfNoticeModels) {
        _arrayOfNoticeModels = [NSMutableArray<FYMsgNoticeModel *> array];
    }
    return _arrayOfNoticeModels;
}


@end

