//
//  FYBankSearchViewController+EmptyDataSet.m
//  ProjectCSHB
//
//  Created by fangyuan on 2020/6/9.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "FYBankSearchViewController+EmptyDataSet.h"

@implementation FYBankSearchViewController (EmptyDataSet)

#pragma mark - DZNEmptyDataSetSource

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = NSLocalizedString(@"暂无消息", nil);
    NSDictionary *attributes = @{ NSFontAttributeName : [UIFont systemFontOfSize:CFC_AUTOSIZING_FONT(16.0f)],
                                  NSForegroundColorAttributeName : [UIColor colorWithRed:0.78 green:0.78 blue:0.78 alpha:1.00]};
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    return [UIImage imageNamed:ICON_SCROLLVIEW_EMPTY_DATASET_MESSAGE];
}

- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView
{
    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    paragraph.alignment = NSTextAlignmentCenter;
    
    NSString *text = @"";
    NSDictionary *attributes = @{ NSFontAttributeName: [UIFont systemFontOfSize:CFC_AUTOSIZING_FONT(16.0f)],
                                  NSForegroundColorAttributeName:[UIColor colorWithRed:0.78 green:0.78 blue:0.78 alpha:1.00],
                                  NSParagraphStyleAttributeName: paragraph};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView
{
    return - CFC_AUTOSIZING_WIDTH(90.0f);
}

- (UIColor *)backgroundColorForEmptyDataSet:(UIScrollView *)scrollView
{
    return COLOR_TABLEVIEW_BACK_VIEW_BACKGROUND_DEFAULT;
}


#pragma mark - DZNEmptyDataSetDelegate

#pragma mark 是否显示空白页
- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView
{
    return YES;
}

#pragma mark 是否允许滚动
- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView
{
    return YES;
}

#pragma mark 图片是否要动画效果
- (BOOL) emptyDataSetShouldAllowImageViewAnimate:(UIScrollView *)scrollView
{
    return YES;
}


@end

