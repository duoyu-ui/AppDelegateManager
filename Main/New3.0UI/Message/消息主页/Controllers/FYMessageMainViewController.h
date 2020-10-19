//
//  FYMessageMainViewController.h
//  ProjectCSHB
//
//  Created by fangyuan on 2020/5/14.
//  Copyright © 2020 Fangyuan. All rights reserved.
//
// 消息
//

#import "CFCTableRefreshViewController.h"
@class FYMsgNoticeModel;

NS_ASSUME_NONNULL_BEGIN

UIKIT_EXTERN CGFloat const TABLEVIEW_HEADER_HEIGHT_FOR_MSG_SEARCH;
UIKIT_EXTERN CGFloat const TABLEVIEW_HEADER_HEIGHT_FOR_MSG_NOTICE;
UIKIT_EXTERN CGFloat const TABLEVIEW_HEADER_HEIGHT_FOR_MSG_SPLINE;

typedef NS_ENUM(NSInteger, FYMsgMainProtocolFuncType) {
    FYMsgMainProtocolFuncTypeRefreshHeader, // 刷新通知
};

@protocol FYMessageMainViewControllerProtocol <NSObject>
@optional
- (void)doRefreshForMsgHeaderWithNoticeModels:(NSMutableArray<FYMsgNoticeModel *> *)noticeModels;
@end

@interface FYMessageMainViewController : CFCTableRefreshViewController

@property (nonatomic, weak) id<FYMessageMainViewControllerProtocol> delegate_header;

@end

NS_ASSUME_NONNULL_END
