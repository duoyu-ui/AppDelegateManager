//
//  FYScrollPageViewController.h
//  ProjectCSHB
//
//  Created by fangyuan on 2020/5/18.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "CFCTableRefreshViewController.h"
#import "ZJScrollPageViewDelegate.h"

NS_ASSUME_NONNULL_BEGIN

UIKIT_EXTERN NSString * const FYScrollPageTableViewDidLeaveFromTopNotification;

typedef NS_ENUM(NSInteger, FYScrollPageForSuperViewType) {
    FYScrollPageForSuperViewTypeTableStartRefresh = 10000, // 开始刷新
    FYScrollPageForSuperViewTypeTableEndRefresh = 10001, // 结束刷新
};

@protocol FYScrollPageViewControllerDelegate <NSObject>

- (void)scrollViewIsScrolling:(UIScrollView *)scrollView;

- (void)doAnyThingForSuperViewController:(FYScrollPageForSuperViewType)type;

@end

@interface FYScrollPageViewController : CFCTableRefreshViewController <ZJScrollPageViewChildVcDelegate>

@property (nonatomic, weak) id<FYScrollPageViewControllerDelegate> delegate;

@property (nonatomic, strong) UIScrollView *scrollView;

- (void)resetSubScrollViewSize:(CGSize)size;

@end

NS_ASSUME_NONNULL_END
