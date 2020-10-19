//
//  FYCenterTableHeaderView.h
//  ProjectCSHB
//
//  Created by fangyuan on 2020/5/19.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol FYCenterMainViewControllerProtocol;

NS_ASSUME_NONNULL_BEGIN

@protocol FYCenterTableHeaderViewDelegate <NSObject>
@optional
- (void)pressNavBarButtonActionSetting:(id)sender;
- (void)pressNavBarButtonActionCustomer:(id)sender;
- (void)pressNavBarButtonActionMyQRCode:(id)sender;
- (void)pressNavBarButtonActionVersion:(id)sender;
- (void)pressNavBarButtonActionUserHeader;
- (void)pressNavBarButtonActionUserVIP;
@end

@interface FYCenterTableHeaderView : UIView <FYCenterMainViewControllerProtocol>

@property (nonatomic, weak) id<FYCenterTableHeaderViewDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame headerHeight:(CGFloat)headerViewHeight parentViewController:(CFCNavBarViewController *)parentViewController;

@end

NS_ASSUME_NONNULL_END
