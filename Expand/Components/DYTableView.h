//
//  DYTableView.h
//  ID贷
//
//  Created by apple on 2019/6/20.
//  Copyright © 2019 hansen. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <MJExtension.h>
NS_ASSUME_NONNULL_BEGIN

@interface DYTableViewModel : NSObject

/**
 * 子类实现具体计算的高度
 */
- (CGFloat)calculateCellheight;

@end


@interface DYTableViewCell : UITableViewCell
///不限制模型必须继承自DYTableViewModel
@property (nonatomic,weak) id model;

/**自己定义flag 表示点击的是哪个按钮
 最终通过tableView 的点击cell的回调 进行传递*/
@property (nonatomic,copy) void(^ _Nullable OtherClickFlag)(id model,NSInteger flag);


@end

typedef void (^DYTableView_Result)(NSArray<id> *sources);

/**
 *如果要当前view处理datasource 需要cell和model都继承DY...
 */
@interface DYTableView : UITableView

/**
 * 如果是翻页(必须设置)
 */
@property (nonatomic,assign) NSUInteger pageSize;
@property (nonatomic,assign) NSUInteger pageIndex;
@property (nonatomic,strong) NSMutableArray<id> *dy_dataSource;
@property (nonatomic,copy) NSString *noDataText;
@property (nonatomic,copy) NSString *noDataImage;

/**
 * 是否开启cell删除模式 默认 NO
 */
@property (nonatomic, assign) BOOL canDeleteCell;

/**是否显示 无数据的图标  默认显示*/
@property (nonatomic,assign) BOOL isShowNoData;
/**缓存行高 不设置rowheight 就会使用缓存行高的方式*/
@property (nonatomic,strong) NSMutableDictionary *heightCache;
/**获取网络请求，并接收请求的数据*/
@property (nonatomic,copy) void(^loadDataCallback)(NSUInteger pageIndex, DYTableView_Result result);

/*
 * cell 的点击回调 otherClickFlag 自定义cell中 某个事件定义的flag
*/
@property (nonatomic,copy) void(^didSelectedCellCallback)(id model, NSNumber * _Nullable otherClickFlag);

/**
 * 点击cell 回调模型
 */
@property (nonatomic,copy) void(^didSelectedCellModelCallback)(id _Nullable model);

/**
 * 左滑删除block
 */
@property (nonatomic, copy) void(^deleteCellCallback)(void);

/**
 * 主动调用  不经过下拉加载
 */
@property (nonatomic, copy) void(^loadLocalDataCallback)(DYTableView_Result result);

@property (nonatomic, assign) UIEdgeInsets dy_separateInsets;


/**
* 执行下拉加载最新
*/
- (void)begainRefreshData;


- (void)loadData;
- (void)loadLocalData;
- (void)loadMoreData;


/**
 * 根据dy_datasource 的count 显示隐藏
 */
- (void)updateNoDataView;

- (void)manualUpdateNoDataView:(BOOL)isShow;

@end



NS_ASSUME_NONNULL_END
