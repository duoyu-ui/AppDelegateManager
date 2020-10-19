//
//  FYSearchViewController.h
//  ProjectCSHB
//
//  Created by fangyuan on 2020/7/8.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "CFCBaseCoreViewController.h"

#define CELL_IDENTIFIER_FOR_SEARCH(cellClassName) ([NSString stringWithFormat:@"%@CellIdentifier",cellClassName])

NS_ASSUME_NONNULL_BEGIN

@protocol FYSearchViewControllerDelegate <NSObject>
@optional

@required
/// 输入关键字搜索
- (void)fySearchResultByKeyword:(NSString *)searchText isSearch:(BOOL)isSeach;
/// 搜索结果展示 Cell
- (UITableViewCell *)fySearchTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath dataSource:(NSMutableArray *)dataSource cellIdentifier:(NSString *)cellIdentifier;
- (CGFloat)fySearchTableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath dataSource:(NSMutableArray *)dataSource;
- (void)fySearchTableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath dataSource:(NSMutableArray *)dataSource;

@end

@interface FYSearchViewController : CFCBaseCoreViewController

@property (nonatomic, copy) void(^closeActionBlock)(UIViewController *fromViewController);

@property (nonatomic, weak) id<FYSearchViewControllerDelegate> delegate;

@property (nonatomic, assign) BOOL hasSearchButtonCell; // 是否有搜索Cell按钮，点击搜索Cell后才执行搜索操作，默认NO

+ (instancetype)alertSearchController:(NSString *)searchTextPlaceholder delegate:(id<FYSearchViewControllerDelegate>)delegate cellClass:(NSArray<NSString *> *)cellClassNames;

- (void)reloadSearchTableWithDataSource:(NSMutableArray *)dataSource;

@end

NS_ASSUME_NONNULL_END

