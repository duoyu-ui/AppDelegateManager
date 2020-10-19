//
//  FYCenterMenuReportTableViewCell.m
//  ProjectCSHB
//
//  Created by fangyuan on 2020/5/25.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "FYCenterMenuReportTableViewCell.h"
#import "FYCenterMenuReportTableViewItem.h"
#import "FYScrollPageViewController.h"
#import "FYCenterMenuSectionModel.h"
#import "ZJScrollSegmentView.h"
#import "ZJContentView.h"

@interface FYCenterMenuReportTableViewCell () <ZJScrollPageViewDelegate, FYCenterMenuReportTableViewItemDelegate>
//
@property (nonatomic, strong) UIView *rootContainerView;
@property (nonatomic, strong) UIView *publicContainerView;
@property (nonatomic, strong) UIView *separatorLineView;
//
@property (nonatomic, assign) CGFloat tableCellHeight;
//
@property (nonatomic, assign) CGFloat segmetViewHeight;
@property (nonatomic, strong) ZJScrollSegmentView *segmentView;
@property (nonatomic, strong) NSMutableArray<NSString *> *tabTitles;
//
@property (nonatomic, assign) CGFloat tabContentHeight;
@property (nonatomic, strong) ZJContentView *tabContentView;
@property (nonatomic, strong) NSMutableArray<FYCenterMenuReportModel *> *dataSources;
@property (nonatomic, strong) NSArray<FYCenterMenuReportTableViewItem<ZJScrollPageViewChildVcDelegate> *> *childScrollViewControllers;

@end

@implementation FYCenterMenuReportTableViewCell

+ (NSString *)reuseIdentifier
{
    return NSStringFromClass(self);
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _segmetViewHeight = CFC_AUTOSIZING_WIDTH(50);
        //
        [self createViewAtuoLayout];
    }
    return self;
}

- (void)createViewAtuoLayout
{
    CGFloat margin = CFC_AUTOSIZING_MARGIN(MARGIN);

    UIView *rootContainerView = ({
        UIView *view = [[UIView alloc] init];
        [self.contentView addSubview:view];
        [view setBackgroundColor:COLOR_TABLEVIEW_BACK_VIEW_BACKGROUND_DEFAULT];
        
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

    UIView *publicContainerView = ({
        UIView *view = [[UIView alloc] init];
        [view.layer setMasksToBounds:YES];
        [view setBackgroundColor:COLOR_HEXSTRING(@"#FFFFFF")];
        [rootContainerView addSubview:view];
        
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(rootContainerView.mas_left).offset(margin);
            make.top.equalTo(rootContainerView.mas_top);
            make.right.equalTo(rootContainerView.mas_right).offset(-margin);
            make.bottom.equalTo(rootContainerView.mas_bottom);
        }];
        
        view;
    });
    self.publicContainerView = publicContainerView;
    self.publicContainerView.mas_key = @"publicContainerView";
}

- (void)setModel:(FYCenterMenuSectionModel *)model
{
    if (![model isKindOfClass:[FYCenterMenuSectionModel class]]) {
        return;
    }
    
    _model = model;

    // 重围高度
    self.tableCellHeight = 0.0f;
    
    // 删除控件
    [self.publicContainerView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    CGFloat margin = CFC_AUTOSIZING_MARGIN(MARGIN);
    
    if (self.model.list.count <= 0) {
        // 分割线
        UIView *separatorLineView = ({
            UIView *view = [[UIView alloc] init];
            [self.publicContainerView addSubview:view];
            
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                self.tableCellHeight += margin*4.0f;
                make.top.equalTo(self.publicContainerView.mas_top);
                make.left.right.equalTo(self.publicContainerView);
                make.height.mas_equalTo(self.tableCellHeight);
            }];
            
            view;
        });
        self.separatorLineView = separatorLineView;
        self.separatorLineView.mas_key = @"separatorLineView";
        
        // 约束的完整性
        [self.publicContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(separatorLineView.mas_bottom).priority(749);
        }];
        
        // 底部左右圆角
        {
            CGFloat cornerRadius = margin*1.0f;
            CGRect frame = CGRectMake(0, 0, SCREEN_MIN_LENGTH-margin*2.0f, self.tableCellHeight);
            UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:frame byRoundingCorners:UIRectCornerBottomLeft|UIRectCornerBottomRight cornerRadii:CGSizeMake(cornerRadius,cornerRadius)];
            CAShapeLayer *mask = [[CAShapeLayer alloc] init];
            mask.frame = frame;
            mask.path = path.CGPath;
            self.publicContainerView.layer.mask = mask;
        }
        //
        return;
    }
    
    // 创建Cell内容
    {
        // 数据准备
        WEAKSELF(weakSelf)
        __block NSInteger tabSubItemMaxCount = 0;
        self.tabTitles = [NSMutableArray<NSString *> array];
        self.dataSources = [NSMutableArray<FYCenterMenuReportModel *> array];
        [self.model.list enumerateObjectsUsingBlock:^(FYCenterMenuReportModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString *title = STR_TRI_WHITE_SPACE(obj.title);
            if (!VALIDATE_STRING_EMPTY(title)) {
                [weakSelf.tabTitles addObj:title];
                [weakSelf.dataSources addObj:obj];
            }
            if (obj.childList.count > tabSubItemMaxCount) {
                tabSubItemMaxCount = obj.childList.count;
            }
        }];
                
        // 标签选择器
        {
            ZJScrollSegmentView *segmentView = ({
                CGRect frame = CGRectMake(0, 0, SCREEN_MIN_LENGTH - margin*2.0f, self.segmetViewHeight);
                ZJScrollSegmentView *segmentView = [self createSegmentViewWithFrame:frame tabTitles:self.tabTitles];
                [self.publicContainerView addSubview:segmentView];
                //
                [segmentView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.left.right.equalTo(self.publicContainerView);
                    make.height.mas_equalTo(self.segmetViewHeight);
                }];
                
                segmentView;
            });
            self.segmentView = segmentView;
            self.segmentView.mas_key = @"segmentView";
            //
            self.tableCellHeight += self.segmetViewHeight;
        }
        
        // 展示内容
        {
            // 计算高度
            int colum = 4;
            CGFloat left_right_gap = margin * 0.0f;
            CGFloat itemWidth = (SCREEN_WIDTH - left_right_gap*2.0f - margin*2.0f) /colum;
            CGFloat itemHeight = itemWidth * 0.85f;
            NSInteger row = tabSubItemMaxCount % colum ? tabSubItemMaxCount / colum + 1 : tabSubItemMaxCount / colum;
            self.tabContentHeight = itemHeight * row;
            self.tableCellHeight += self.tabContentHeight;
            CGRect frameOfCollection = CGRectMake(0, 0, SCREEN_MIN_LENGTH-margin*2.0f, self.tabContentHeight);
            
            [self setupChildScrollViewControllers:self.dataSources];
            ZJContentView *tabContentView = ({
                //
                ZJContentView *contentView = [self createTabContentViewWithFrame:frameOfCollection];
                [self.publicContainerView addSubview:contentView];
                //
                [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(self.segmentView.mas_bottom);
                    make.left.right.equalTo(self.publicContainerView);
                    make.height.mas_equalTo(self.tabContentHeight);
                }];
                
                contentView;
            });
            self.tabContentView = tabContentView;
            self.tabContentView.mas_key = @"tabContentView";
        }
        
        // 分割线
        UIView *separatorLineView = ({
            UIView *view = [[UIView alloc] init];
            [view setBackgroundColor:COLOR_TABLEVIEW_SEPARATOR_LINE_DEFAULT];
            [self.publicContainerView addSubview:view];
            
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                self.tableCellHeight += margin*0.5f;
                make.top.equalTo(self.tabContentView.mas_bottom).offset(margin*0.5f);
                make.left.right.equalTo(self.publicContainerView);
                make.height.mas_equalTo(SEPARATOR_LINE_HEIGHT);
            }];
            
            view;
        });
        self.separatorLineView = separatorLineView;
        self.separatorLineView.mas_key = @"separatorLineView";
        
        // 约束的完整性
        [self.publicContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(separatorLineView.mas_bottom).priority(749);
        }];
        
        // 底部左右圆角
        {
            CGFloat cornerRadius = margin*1.0f;
            CGRect frame = CGRectMake(0, 0, SCREEN_MIN_LENGTH-margin*2.0f, self.tableCellHeight);
            UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:frame byRoundingCorners:UIRectCornerBottomLeft|UIRectCornerBottomRight cornerRadii:CGSizeMake(cornerRadius,cornerRadius)];
            CAShapeLayer *mask = [[CAShapeLayer alloc] init];
            mask.frame = frame;
            mask.path = path.CGPath;
            self.publicContainerView.layer.mask = mask;
        }
    }
}

- (NSArray *)setupChildScrollViewControllers:(NSMutableArray<FYCenterMenuReportModel *> *)itemReportModels
{
    __block NSMutableArray<FYCenterMenuReportTableViewItem *> *childScrollVCArr = [NSMutableArray array];
    [itemReportModels enumerateObjectsUsingBlock:^(FYCenterMenuReportModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        FYCenterMenuReportTableViewItem *viewController = [[FYCenterMenuReportTableViewItem alloc] initWithTabMenuReportModel:obj];
        [viewController setDelegateOfReportCell:self];
        [childScrollVCArr addObj:viewController];
    }];
    self.childScrollViewControllers = [NSArray<FYCenterMenuReportTableViewItem *> arrayWithArray:childScrollVCArr];
    return self.childScrollViewControllers;
}


#pragma mark - ZJScrollPageViewDelegate

- (NSInteger)numberOfChildViewControllers
{
    return self.dataSources.count;
}

- (UIViewController<ZJScrollPageViewChildVcDelegate> *)childViewController:(UIViewController<ZJScrollPageViewChildVcDelegate> *)reuseViewController forIndex:(NSInteger)index;
{
    FYCenterMenuReportTableViewItem<ZJScrollPageViewChildVcDelegate> *childVc =  (FYCenterMenuReportTableViewItem *)reuseViewController;
    if (!childVc) {
        childVc = self.childScrollViewControllers[index];
    }
    return childVc;
}


#pragma mark - FYCenterMenuReportTableViewItemDelegate

- (void)didSelectRowAtReportModel:(FYCenterMenuReportModel *)reportModel itemModel:(FYCenterMenuItemModel *)model
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectRowAtReportModel:itemModel:)]) {
        [self.delegate didSelectRowAtReportModel:reportModel itemModel:model];
    }
}


#pragma mark - Private

- (ZJContentView *)createTabContentViewWithFrame:(CGRect)frame
{
    if (_tabContentView == nil) {
        ZJContentView *content = [[ZJContentView alloc] initWithFrame:frame segmentView:self.segmentView parentViewController:[FunctionManager getTopViewController] delegate:self];
        _tabContentView = content;
    }
    return _tabContentView;
}

- (ZJScrollSegmentView *)createSegmentViewWithFrame:(CGRect)frame tabTitles:(NSArray<NSString *> *)tabTitles
{
    if (_segmentView == nil) {
        CGFloat margin = CFC_AUTOSIZING_MARGIN(MARGIN);
        CGFloat left_right_gap = margin*1.5f;
        CGFloat titleMargin = 2.5f;
        CGFloat titleHeight = frame.size.height * 0.58f;
        UIFont *titleFont = FONT_PINGFANG_SEMI_BOLD(15);
        NSInteger titleCount = 5; // 默认显示5个【self.tabTitles.count】
        NSString *maxString = [CFCSysUtil getMaxLengthItemString:self.tabTitles];
        CGFloat itemMinWith = [maxString widthWithFont:titleFont constrainedToHeight:CGFLOAT_MAX];
        CGFloat itemWidth = (frame.size.width-(titleMargin)*(titleCount-1)-left_right_gap*2.0f)/titleCount;
        if (itemMinWith < itemWidth) {
            itemMinWith = itemWidth;
        }
        //
        ZJSegmentStyle *style = [[ZJSegmentStyle alloc] init];
        style.scrollContentView = YES;
        style.contentViewBounces = NO;
        style.segmentViewBounces = YES;
        style.gradualChangeTitleColor = YES;
        style.animatedContentViewWhenTitleClicked = NO;
        style.itemWidth = itemMinWith;
        style.titleMargin = titleMargin;
        style.titleEdgetMargin = left_right_gap;
        style.titleFont = titleFont;
        style.showCover = YES;
        style.coverHeight = titleHeight;
        style.coverCornerRadius = titleHeight * 0.5f;
        style.coverGradualChangeColor = YES;
        style.coverGradualColors = @[ COLOR_HEXSTRING(@"#DF5E43"), COLOR_HEXSTRING(@"#CD3224")];
        style.scrollLineHeight = 0.0f;
        style.coverBackgroundColor = [UIColor colorWithRed:205.0/255.0 green:50.0/255.0 blue:36.0/255.0 alpha:1.0];
        style.normalTitleColor = [UIColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:1.0];
        style.selectedTitleColor = [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0];

        WEAKSELF(weakSelf)
        ZJScrollSegmentView *segment = [[ZJScrollSegmentView alloc] initWithFrame:frame segmentStyle:style delegate:self titles:tabTitles titleDidClick:^(ZJTitleView *titleView, NSInteger index) {
            CGFloat width = SCREEN_MIN_LENGTH - margin *2.0f;
             [weakSelf.tabContentView setContentOffSet:CGPointMake(width * index, 0.0) animated:YES];
        }];
        [segment setBackgroundColor:[UIColor whiteColor]];
        //
        _segmentView = segment;
    }
    return _segmentView;
}


@end

