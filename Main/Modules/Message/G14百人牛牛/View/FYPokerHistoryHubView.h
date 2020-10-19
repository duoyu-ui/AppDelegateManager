//
//  FYPokerHistoryHubView.h
//  ProjectCSHB
//
//  Created by Tom on 2020/8/25.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FYBestNiuNiuHistoryModel.h"
NS_ASSUME_NONNULL_BEGIN
typedef void(^pokerHistoryBlock)(void);
///百人牛牛弹框历史记录
@interface FYPokerHistoryHubView : UIView
+ (void)showWithDataSource:(NSArray<FYBestNiuNiuHistoryData*>*)dataSource Block:(pokerHistoryBlock)block;
@end

NS_ASSUME_NONNULL_END
