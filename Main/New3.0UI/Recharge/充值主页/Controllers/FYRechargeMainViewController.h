//
//  FYRechargeMainViewController.h
//  ProjectCSHB
//
//  Created by fangyuan on 2020/5/17.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "CFCBaseCoreViewController.h"

NS_ASSUME_NONNULL_BEGIN

UIKIT_EXTERN CGFloat const TABLEVIEW_HEADER_HEIGHT_FOR_RECHARGE_USERINFO;
UIKIT_EXTERN CGFloat const TABLEVIEW_HEADER_HEIGHT_FOR_RECHARGE_SPLITVIEW;
UIKIT_EXTERN CGFloat const TABLEVIEW_HEADER_HEIGHT_FOR_RECHARGE_SEGMENT;

typedef NS_ENUM(NSInteger, FYRechargeMainProtocolFuncType) {
    FYRechargeMainProtocolFuncTypeRefreshHeaderData, // 用户数据
    FYRechargeMainProtocolFuncTypeRefreshPayModeData, // 刷新数据
};

@protocol FYRechargeMainViewControllerProtocol <NSObject>
@optional
- (void)doAnyThingForPayModeHeaderView:(FYRechargeMainProtocolFuncType)type;
- (void)doAnyThingForPayModeViewController:(FYRechargeMainProtocolFuncType)type;
@end

@interface FYRechargeMainViewController : CFCBaseCoreViewController

@property (nonatomic, assign) BOOL isPush;

@property (nonatomic, weak) id<FYRechargeMainViewControllerProtocol> delegate_header;

@property (nonatomic, weak) id<FYRechargeMainViewControllerProtocol> delegate_paymode;

- (instancetype)initWithIsPush:(BOOL)isPush;

@end

NS_ASSUME_NONNULL_END
