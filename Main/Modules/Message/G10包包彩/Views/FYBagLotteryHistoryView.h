//
//  FYBagLotteryHistoryView.h
//  ProjectCSHB
//
//  Created by Tom on 2020/7/22.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FYBegLotteryHistoryModel.h"
#import "FYBagBagCowRecordObject.h"
NS_ASSUME_NONNULL_BEGIN

/// 包包彩历史记录
@interface FYBagLotteryHistoryView : UIView
+ (void)showHistoryViewWithList:(NSArray<FYBegLotteryHistoryData*>*)lists;
+ (void)showBagBagCowHistoryViewWith:(NSArray<FYBagBagCowRecordData*>*)lists type:(NSInteger)type;

@end

NS_ASSUME_NONNULL_END
