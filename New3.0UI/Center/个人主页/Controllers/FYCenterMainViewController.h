//
//  FYCenterMainViewController.h
//  ProjectCSHB
//
//  Created by fangyuan on 2020/5/14.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "CFCTableRefreshViewController.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, FYCenterMainProtocolFuncType) {
    FYCenterMainProtocolFuncTypeRefreshHeaderData, // 用户数据
};

typedef NS_ENUM(NSInteger, FYCenterMainTableSection) {
    FYCenterMainTableSectionMyService = 0, // 我的服务
    FYCenterMainTableSectionMyAgentCenter = 1, // 代理中心
    FYCenterMainTableSectionMyGameReport = 2, // 游戏报表
};

@protocol FYCenterMainViewControllerProtocol <NSObject>
@optional
- (void)doAnyThingForCenterTableHeaderView:(FYCenterMainProtocolFuncType)type;
@end

@interface FYCenterMainViewController : CFCTableRefreshViewController <UITableViewDelegate, UITableViewDataSource, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property (nonatomic, weak) id<FYCenterMainViewControllerProtocol> delegate_header;

@end

NS_ASSUME_NONNULL_END
