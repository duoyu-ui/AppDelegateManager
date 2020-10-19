
#import "CFCCollectionRefreshViewController+EmptyDataSet.h"

@implementation CFCCollectionRefreshViewController (EmptyDataSet)

#pragma mark - DZNEmptyDataSetSource Methods

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = STR_SCROLL_EMPTY_DATASET_TITLE;
    NSDictionary *attributes = @{ NSFontAttributeName : [UIFont systemFontOfSize:CFC_AUTOSIZING_FONT(16.0f)],
                                  NSForegroundColorAttributeName : [UIColor colorWithRed:0.78 green:0.78 blue:0.78 alpha:1.00]};
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView
{
    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    paragraph.alignment = NSTextAlignmentCenter;
    
    NSString *text = STR_SCROLL_EMPTY_DATASET_TIPINFO;
    NSDictionary *attributes = @{ NSFontAttributeName: [UIFont systemFontOfSize:CFC_AUTOSIZING_FONT(13.0f)],
                                  NSForegroundColorAttributeName:[UIColor colorWithRed:0.78 green:0.78 blue:0.78 alpha:1.00],
                                  NSParagraphStyleAttributeName: paragraph};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    CGSize imageSize = CGSizeMake(SCREEN_WIDTH*SCROLL_EMPTY_DATASET_SCALE, SCREEN_WIDTH*SCROLL_EMPTY_DATASET_SCALE);
    return [[UIImage imageNamed:ICON_SCROLLVIEW_EMPTY_DATASET_MESSAGE] imageByScalingProportionallyToSize:imageSize];
}

- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView
{
    return CFC_AUTOSIZING_HEIGTH(0.0f);
}

- (UIColor *)backgroundColorForEmptyDataSet:(UIScrollView *)scrollView
{
    return COLOR_TABLEVIEW_BACK_VIEW_BACKGROUND_DEFAULT;
}


#pragma mark - DZNEmptyDataSetDelegate Methods

#pragma mark 是否显示空白页
- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView
{
  return self.isEmptyDataSetShouldDisplay;
}

#pragma mark 是否允许滚动
- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView
{
  return self.isEmptyDataSetShouldAllowScroll;
}

#pragma mark 图片是否要动画效果
- (BOOL)emptyDataSetShouldAllowImageViewAnimate:(UIScrollView *)scrollView
{
  return self.isEmptyDataSetShouldAllowImageViewAnimate;
}

@end
