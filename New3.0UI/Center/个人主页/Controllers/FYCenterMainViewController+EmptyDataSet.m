//
//  FYCenterMainViewController+EmptyDataSet.m
//  ProjectCSHB
//
//  Created by fangyuan on 2020/7/8.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "FYCenterMainViewController+EmptyDataSet.h"

@implementation FYCenterMainViewController (EmptyDataSet)

- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView
{
    return CFC_AUTOSIZING_WIDTH(140.0f);
}

@end
