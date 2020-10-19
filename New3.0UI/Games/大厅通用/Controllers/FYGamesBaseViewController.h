//
//  FYGamesBaseViewController.h
//  ProjectCSHB
//
//  Created by fangyuan on 2020/7/27.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "CFCBaseCoreViewController.h"
#import "ZJScrollPageView.h"
@class FYGamesBannerModel, FYGamesNoticeModel;
@class FYGamesErrorView, ZJContentView, ZJScrollSegmentView, FYGamesCustomTableView, FYGamesBannerNoticeView;

NS_ASSUME_NONNULL_BEGIN

@protocol FYGamesBaseViewControllerProtocol <NSObject>
@optional
- (void)doRefreshBannerNoticeViewWithBannerModels:(NSMutableArray<FYGamesBannerModel *> *)bannerModels noticeModels:(NSMutableArray<FYGamesNoticeModel *> *)noticeModels;
@end

@interface FYGamesCustomTableView : UITableView
@end

@interface FYGamesBaseViewController : CFCBaseCoreViewController <ZJScrollPageViewDelegate>

@property (nonatomic, assign) CGFloat tableHeaderHeight;
@property (nonatomic, assign) CGFloat tableSectionHeaderHeight;
@property (nonatomic, assign) CGFloat tableSectionSegmentHeight;

@property (nonatomic, strong) ZJContentView *contentView;
@property (nonatomic, strong) ZJScrollSegmentView *segmentView;
@property (nonatomic, strong) FYGamesCustomTableView *tableView;
@property (nonatomic, strong) FYGamesBannerNoticeView *tableSectionHeaderView;

@property (nonatomic, assign) BOOL isLoadingSuccess; // 是否成功加载数据
@property (nonatomic, assign) NSInteger segmentSelectedIndex; // 当前选中的一级菜单下标
@property (nonatomic, strong) NSMutableArray<NSString *> *tabTitles; // 一级菜单标题
@property (nonatomic, strong) NSMutableArray<NSString *> *tabTitleCodes; // 一级菜单代号

@property (nonatomic, strong) NSMutableArray<FYGamesBannerModel *> *arrayOfBannerModels;
@property (nonatomic, strong) NSMutableArray<FYGamesNoticeModel *> *arrayOfNoticeModels;

@property (nonatomic, weak) id<FYGamesBaseViewControllerProtocol> delegate_header;

/// 头部高度
+ (CGFloat)heightOfHeaderBanner;
+ (CGFloat)heightOfHeaderNotice;
+ (CGFloat)heightOfHeaderSpline;
+ (CGFloat)heightOfHeaderSegment;

/// 加载错误提示页面
- (void)setInsertErrorView;
/// 删除错误提示页面
- (void)setDeleteErrorView;
/// 错误提示刷新操作
- (void)pressReloadErrorViewAction;
/// 开始加载菊花动画 - 开始
- (void)setActivityStartAnimating;
/// 开始加载菊花动画 - 结束
- (void)setActivityStopAnimating;

/// 游戏大厅广告
- (void)doNotifiGamesMallSdShowHide:(NSNotification *)notification;
/// 刷新游戏大厅
- (void)doNotifiReloadGamesMallData:(NSNotification *)notification;
/// 刷新群组信息（显示、隐藏、维护）
- (void)doNotifiRefreshGamesGroupInfo:(NSNotification *)notification;
/// 系统消息或通知公告
- (void)doNotifiRefreshSysMsgOrNotice:(NSNotification *)notification;

/// 通知弹出框
- (void)doToShowSystemNoticeAlterView:(NSMutableArray<FYGamesNoticeModel *> *)noticeModels;

/// 网络数据
- (void)loadData;
- (void)loadRequestDataBannersThen:(void (^)(BOOL success, NSMutableArray<FYGamesBannerModel *> *itemBannerModels))then;
- (void)loadRequestDataNoticesThen:(void (^)(BOOL success, NSMutableArray<FYGamesNoticeModel *> *itemNoticeModels))then;

/// ZJScrollPageViewDelegate
- (NSInteger)numberOfChildViewControllers;
- (UIViewController<ZJScrollPageViewChildVcDelegate> *)childViewController:(UIViewController<ZJScrollPageViewChildVcDelegate> *)reuseViewController forIndex:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END
