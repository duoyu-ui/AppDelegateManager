//
//  FYGamesBannerNoticeView.m
//  ProjectCSHB
//
//  Created by fangyuan on 2020/5/16.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "FYGamesBannerNoticeView.h"
#import "FYGamesBannerModel.h"
#import "FYGamesNoticeModel.h"
#import "ZJScrollSegmentView.h"
#import "SDCycleScrollView.h"
#import "UUMarqueeView.h"

@interface FYGamesBannerNoticeView () <SDCycleScrollViewDelegate, UUMarqueeViewDelegate>
// 广告
@property (nonatomic, strong) SDCycleScrollView *bannerScrollView;
@property (nonatomic, strong) NSMutableArray<FYGamesBannerModel *> *arrayOfBannerModels;
// 通知
@property (nonatomic, strong) UIView *noticeMarqueeContainer;
@property (nonatomic, strong) UUMarqueeView *noticeMarqueeView;
@property (nonatomic, strong) NSMutableArray<FYGamesNoticeModel *> *arrayOfNoticeModels;
// 
@property (nonatomic, weak) FYGamesBaseViewController *parentViewController;
@property (nonatomic, assign) CGFloat headerViewHeight;
@property (nonatomic, assign) CGFloat scrollBannerHeight;
@property (nonatomic, assign) CGFloat noticeMarqueeHeight;
@property (nonatomic, assign) CGFloat splineHeight;
@property (nonatomic, assign) CGFloat segmentViewHeight;
//
@property (nonatomic, weak) ZJScrollSegmentView *segmentView; // 主页菜单（隐藏）

@end


@implementation FYGamesBannerNoticeView

#pragma mark - Life Cycle

- (instancetype)initWithFrame:(CGRect)frame
             headerViewHeight:(CGFloat)headerViewHeight
         parentViewController:(FYGamesBaseViewController *)parentViewController
                  segmentView:(ZJScrollSegmentView *)segmentView
                 bannerModels:(NSMutableArray<FYGamesBannerModel *> *)bannerModels
                 noticeModels:(NSMutableArray<FYGamesNoticeModel *> *)noticeModels
{
    self = [super initWithFrame:frame];
    if (self) {
        _segmentView = segmentView;
        _headerViewHeight = headerViewHeight;
        _parentViewController = parentViewController;
        _splineHeight = [FYGamesBaseViewController heightOfHeaderSpline];
        if (!bannerModels || bannerModels.count <= 0) {
            _scrollBannerHeight = 0.0f;
        } else {
            _arrayOfBannerModels = bannerModels;
            _scrollBannerHeight = [FYGamesBaseViewController heightOfHeaderBanner];
        }
        if (!noticeModels || noticeModels.count <= 0) {
            _noticeMarqueeHeight = 0.0f;
        } else {
            // 注意：在这里不能赋值 arrayOfNoticeModels ，需要在下面代理中 doRefreshBannerNoticeViewWithBannerModels 赋值
            _noticeMarqueeHeight = [FYGamesBaseViewController heightOfHeaderNotice];
        }
        _segmentViewHeight = headerViewHeight - _scrollBannerHeight - _noticeMarqueeHeight - _splineHeight;
        
        //
        [self createViewAtuoLayout];
    }
    return self;
}

- (void)createViewAtuoLayout
{
    [self viewDidAddBannerView];
    [self viewDidAddNoticeView];
    [self viewDidAddSplitLineView];
    [self viewDidAddSegmentMenuView];
    [self setBackgroundColor:[UIColor whiteColor]];
}

- (void)viewDidAddBannerView
{
    CGFloat margin = CFC_AUTOSIZING_MARGIN(MARGIN);
    CGFloat margin_top = 5.0f;
    CGFloat scrollBannerHeight = self.scrollBannerHeight - margin_top;
    
    // 广告控件
    [self addSubview:self.bannerScrollView];
    [self.bannerScrollView addCornerRadius:margin*0.7f];
    [self.bannerScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset(margin_top);
        make.left.equalTo(self.mas_left).offset(margin*0.5f);
        make.right.equalTo(self.mas_right).offset(-margin*0.5f);
    }];
    
    // 广告数据
    if (!self.arrayOfBannerModels || self.arrayOfBannerModels.count == 0) {
        [self.bannerScrollView setHidden:YES];
        [self.bannerScrollView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(0.0f);
        }];
    } else {
        [self.bannerScrollView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(scrollBannerHeight);
        }];
        NSMutableArray<NSString *> *imageUrls = [NSMutableArray<NSString *> array];
        [self.arrayOfBannerModels enumerateObjectsUsingBlock:^(FYGamesBannerModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [imageUrls addObj:obj.imageUrl];
        }];
        [self.bannerScrollView setImageURLStringsGroup:imageUrls];
    }
}

- (void)viewDidAddNoticeView
{
    CGFloat margin = CFC_AUTOSIZING_MARGIN(MARGIN);
    CGFloat margin_top = 5.0f;
    CGFloat noticeMarqueeHeight = self.noticeMarqueeHeight - margin_top;
    
    // 通知容器
    [self addSubview:self.noticeMarqueeContainer];
    [self.noticeMarqueeContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.bannerScrollView.mas_bottom).offset(margin_top);
        make.left.equalTo(self.mas_left).offset(margin*0.5f);
        make.right.equalTo(self.mas_right).offset(-margin*0.5f);
        make.height.mas_equalTo(noticeMarqueeHeight);
    }];
    
    // 闹钟图片
    UIImageView *trumpetImageView = ({
        UIImageView *imageView = [[UIImageView alloc] init];
        [self.noticeMarqueeContainer addSubview:imageView];
        [imageView setImage:[UIImage imageNamed:ICON_GAMES_TRUMPET]];
        
        CGFloat imageSize = noticeMarqueeHeight > 25 ? 25 : noticeMarqueeHeight * 0.75f;
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.noticeMarqueeContainer.mas_left);
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
        make.right.equalTo(self.noticeMarqueeContainer.mas_right).offset(-margin*0.3f);
        make.top.equalTo(self.noticeMarqueeContainer.mas_top);
        make.bottom.equalTo(self.noticeMarqueeContainer.mas_bottom);
    }];
    
    // 通知数据
    if (0 >= self.noticeMarqueeHeight) {
        [self.noticeMarqueeContainer setHidden:YES];
        [self.noticeMarqueeContainer mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(0.0f);
        }];
    } else {
        [self.noticeMarqueeContainer mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(noticeMarqueeHeight);
        }];
        [self.noticeMarqueeView reloadData];
    }
}

- (void)viewDidAddSplitLineView
{
    UIView *separatorLineView = ({
        UIView *view = [[UIView alloc] init];
        [view setBackgroundColor:COLOR_TABLEVIEW_SEPARATOR_LINE_DEFAULT];
        [self addSubview:view];
        
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.noticeMarqueeContainer.mas_bottom);
            make.left.right.equalTo(self);
            make.height.mas_equalTo(self.splineHeight);
        }];
        
        view;
    });
    separatorLineView.mas_key = @"separatorLineView";
}

- (void)viewDidAddSegmentMenuView
{
    [self addSubview:self.segmentView];
    [self.segmentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.height.mas_equalTo(self.segmentViewHeight);
    }];
}

- (void)adjustWhenControllerViewWillAppera
{
    // 解决 viewWillAppear 时出现时轮播图卡在一半的问题
    [self.bannerScrollView adjustWhenControllerViewWillAppera];
}


#pragma mark - FYGamesBaseViewControllerProtocol

- (void)doRefreshBannerNoticeViewWithBannerModels:(NSMutableArray<FYGamesBannerModel *> *)bannerModels noticeModels:(NSMutableArray<FYGamesNoticeModel *> *)noticeModels
{
    // 广告数据
    {
        [self setArrayOfBannerModels:bannerModels];
        NSMutableArray<NSString *> *imageUrls = [NSMutableArray<NSString *> array];
        [bannerModels enumerateObjectsUsingBlock:^(FYGamesBannerModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [imageUrls addObj:obj.imageUrl];
        }];
        [self.bannerScrollView setImageURLStringsGroup:imageUrls];
    }
    
    // 通知公告
    {
        if (!self.arrayOfNoticeModels || self.arrayOfNoticeModels.count <= 0) {
            [self setArrayOfNoticeModels:noticeModels];
            [self.noticeMarqueeView reloadData];
            [self.noticeMarqueeView start];
        }
        
        WEAKSELF(weakSelf)
        if (noticeModels.count >= self.arrayOfNoticeModels.count) {
            [noticeModels enumerateObjectsWithIndex:^(FYGamesNoticeModel *itemNoticeModel, NSUInteger index) {
                if (index < weakSelf.arrayOfNoticeModels.count) {
                    FYGamesNoticeModel *originModel = [weakSelf.arrayOfNoticeModels objectAtIndex:index];
                    if (itemNoticeModel.uuid.integerValue != originModel.uuid.integerValue) {
                        [weakSelf.arrayOfNoticeModels replaceObjectAtIndex:index withObject:itemNoticeModel];
                    }
                } else {
                    [weakSelf.arrayOfNoticeModels addObj:itemNoticeModel];
                }
            }];
        } else {
            [self.arrayOfNoticeModels enumerateObjectsWithIndex:^(FYGamesNoticeModel *originModel, NSUInteger index) {
                if (index < noticeModels.count) {
                    FYGamesNoticeModel *itemNoticeModel = [noticeModels objectAtIndex:index];
                    if (itemNoticeModel.uuid.integerValue != originModel.uuid.integerValue) {
                        [weakSelf.arrayOfNoticeModels replaceObjectAtIndex:index withObject:itemNoticeModel];
                    }
                } else {
                    NSInteger idx = index % noticeModels.count;
                    FYGamesNoticeModel *itemNoticeModel = [noticeModels objectAtIndex:idx];
                    [weakSelf.arrayOfNoticeModels replaceObjectAtIndex:index withObject:itemNoticeModel];
                }
            }];
        }
    }
}


#pragma mark - Network

- (void)loadRequestDataBannersThen:(void (^)(NSArray<FYGamesBannerModel *> *bannerItemModels))then
{
    PROGRESS_HUD_SHOW
    [NET_REQUEST_MANAGER requestMsgBannerWithId:OccurBannerAdsTypeGroup WithPictureSpe:OccurBannerAdsPictureTypeNormal success:^(id response) {
        PROGRESS_HUD_DISMISS
        FYLog(NSLocalizedString(@"广告数据 => \n%@", nil), response);
        if (!NET_REQUEST_SUCCESS(response)) {
           !then ?: then(nil);
        } else {
            NSDictionary *data = NET_REQUEST_DATA(response);
            NSMutableArray<FYGamesBannerModel *> *itemBannerModels = [NSMutableArray array];
            [data[@"skAdvDetailList"] enumerateObjectsUsingBlock:^(NSDictionary *  _Nonnull dict, NSUInteger idx, BOOL * _Nonnull stop) {
                FYGamesBannerModel *model = [FYGamesBannerModel mj_objectWithKeyValues:dict];
                [itemBannerModels addObj:model];
            }];
            !then ?: then(itemBannerModels);
        }
    } fail:^(id error) {
        PROGRESS_HUD_DISMISS
        ALTER_HTTP_ERROR_MESSAGE(error)
        FYLog(NSLocalizedString(@"获取广告数据出错 => \n%@", nil), error);
        !then ?: then(nil);
    }];
}

- (void)loadRequestDataNoticesThen:(void (^)(NSArray<FYGamesNoticeModel *> *noticeItemModels))then
{
    PROGRESS_HUD_SHOW
    [NET_REQUEST_MANAGER requestSystemNoticeWithType:@"" success:^(id response) {
        PROGRESS_HUD_DISMISS
        FYLog(NSLocalizedString(@"通知公告 => \n%@", nil), response);
        if (!NET_REQUEST_SUCCESS(response)) {
           !then ?: then([FYGamesNoticeModel buildingDataModles]);
        } else {
            NSDictionary *data = NET_REQUEST_DATA(response);
            NSMutableArray<FYGamesNoticeModel *> *itemNoticeModels = [NSMutableArray array];
            [data[@"records"] enumerateObjectsUsingBlock:^(NSDictionary *  _Nonnull dict, NSUInteger idx, BOOL * _Nonnull stop) {
                FYGamesNoticeModel *model = [FYGamesNoticeModel mj_objectWithKeyValues:dict];
                [itemNoticeModels addObj:model];
            }];
            !then ?: then(itemNoticeModels);
        }
    } fail:^(id error) {
        PROGRESS_HUD_DISMISS
        ALTER_HTTP_ERROR_MESSAGE(error)
        FYLog(NSLocalizedString(@"获取通知公告出错 => \n%@", nil), error);
        !then ?: then([FYGamesNoticeModel buildingDataModles]);
    }];
}


#pragma mark - SDCycleScrollViewDelegate

/** 图片滚动回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didScrollToIndex:(NSInteger)index
{
    
}

/** 点击图片回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    if (index < 0 || index >= self.arrayOfBannerModels.count) {
        return;
    }
    
    if ([APPINFORMATION isGuest]) {
        return;
    }
    
    FYGamesBannerModel *itemModel = [self.arrayOfBannerModels objectAtIndex:index];
    BannerItem *bannerItem = [[BannerItem alloc] init];
    [bannerItem setAdvLinkUrl:itemModel.advLinkUrl];
    [bannerItem setLinkType:itemModel.linkType.stringValue];
    [self.parentViewController fromBannerPushToVCWithBannerItem:bannerItem isFromLaunchBanner:NO];
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
    contentLabel.textColor = COLOR_SYSTEM_MAIN_FONT_DEFAULT;
    contentLabel.textAlignment = NSTextAlignmentLeft;
    [itemView addSubview:contentLabel];
}

- (CGFloat)itemViewWidthAtIndex:(NSUInteger)index forMarqueeView:(UUMarqueeView*)marqueeView
{
    FYGamesNoticeModel *model = [self.arrayOfNoticeModels objectAtIndex:index];
    UILabel *contentLabel = [[UILabel alloc] init];
    contentLabel.textAlignment = NSTextAlignmentLeft;
    contentLabel.font = FONT_PINGFANG_REGULAR(14);
    contentLabel.textColor = COLOR_SYSTEM_MAIN_FONT_DEFAULT;
    contentLabel.text = [NSString stringWithFormat:@"%@", [CFCSysUtil stringByTrimmingWhitespaceAndNewline:model.content]];
    return contentLabel.intrinsicContentSize.width;
}

- (void)updateItemView:(UIView*)itemView atIndex:(NSUInteger)index forMarqueeView:(UUMarqueeView*)marqueeView
{
    FYGamesNoticeModel *model = [self.arrayOfNoticeModels objectAtIndex:index];
    UILabel *contentLabel = [itemView viewWithTag:1001];
    contentLabel.text = [NSString stringWithFormat:@"%@", [CFCSysUtil stringByTrimmingWhitespaceAndNewline:model.content]];
}

- (void)didTouchItemViewAtIndex:(NSUInteger)index forMarqueeView:(UUMarqueeView*)marqueeView
{
    FYGamesNoticeModel *model = [self.arrayOfNoticeModels objectAtIndex:index];
    if (model.isLoacl.boolValue) {
        ALTER_INFO_MESSAGE(NSLocalizedString(@"没有公告信息", nil))
        return;
    }
    NSString *sessionId = [FYSysMsgNoticeEntity reuseChatSysMsgNoticeSessionId];
    FYSystemNewMessageController *viewController = [[FYSystemNewMessageController alloc] initWithSessionId:sessionId];
    [self.parentViewController.navigationController pushViewController:viewController animated:YES];
}


#pragma mark - Getter/Setter

- (SDCycleScrollView *)bannerScrollView
{
    if(!_bannerScrollView)
    {
        _bannerScrollView= [[SDCycleScrollView alloc] init];
        _bannerScrollView.delegate = self;
        _bannerScrollView.showPageControl = YES;
        _bannerScrollView.autoScrollTimeInterval = 3.0f;
        _bannerScrollView.pageControlStyle = SDCycleScrollViewPageContolStyleClassic;
        _bannerScrollView.pageDotColor = [UIColor colorWithRed:0.54 green:0.54 blue:0.55 alpha:1.0];
        _bannerScrollView.currentPageDotColor = COLOR_SYSTEM_MAIN_BUTTON_BACKGROUND_SELECT_DEFAULT;
        _bannerScrollView.backgroundColor = [UIColor whiteColor];
        _bannerScrollView.pageControlDotSize = CGSizeMake(5.0f, 5.0f);
        _bannerScrollView.pageControlBottomOffset = -5.0f;
        _bannerScrollView.placeholderImage = [UIImage imageNamed:@"icon_loading_1010_260"];
        _bannerScrollView.currentPageDotImage = [UIImage imageNamed:@"pageControlCurrentDot"];
        _bannerScrollView.pageDotImage = [UIImage imageNamed:@"pageControlDot"];
    }
    return _bannerScrollView;
}

- (UIView *)noticeMarqueeContainer
{
    if(!_noticeMarqueeContainer)
    {
        _noticeMarqueeContainer= [[UIView alloc] init];
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

- (NSMutableArray<FYGamesBannerModel *> *)arrayOfBannerModels
{
    if (!_arrayOfBannerModels) {
        _arrayOfBannerModels = [NSMutableArray<FYGamesBannerModel *> array];
    }
    return _arrayOfBannerModels;
}

- (NSMutableArray<FYGamesNoticeModel *> *)arrayOfNoticeModels
{
    if (!_arrayOfNoticeModels) {
        _arrayOfNoticeModels = [NSMutableArray<FYGamesNoticeModel *> array];
    }
    return _arrayOfNoticeModels;
}


@end

