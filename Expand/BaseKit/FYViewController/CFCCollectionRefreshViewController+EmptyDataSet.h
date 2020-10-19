
#import "CFCCollectionRefreshViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface CFCCollectionRefreshViewController (EmptyDataSet) <DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

#pragma mark - DZNEmptyDataSetSource Methods
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView;
- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView;
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView;
- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView;
- (UIColor *)backgroundColorForEmptyDataSet:(UIScrollView *)scrollView;

#pragma mark - DZNEmptyDataSetDelegate Methods
- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView;
- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView;
- (BOOL)emptyDataSetShouldAllowImageViewAnimate:(UIScrollView *)scrollView;

@end

NS_ASSUME_NONNULL_END
