
#import "CFCTableRefreshViewController.h"

@interface CFCTableRefreshViewController (EmptyDataSet) <DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

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

