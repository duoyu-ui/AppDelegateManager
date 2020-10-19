//
//  FYGameReportViewController.h
//  ProjectCSHB
//
//  Created by fangyuan on 2020/6/25.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "CFCTableRefreshViewController.h"
@class FYGameReportStatisticsModel;

NS_ASSUME_NONNULL_BEGIN

@protocol FYGameReportViewControllerDelegate <NSObject>
@optional
//
- (void)doRefreshSectionHeaderGameReportStatisticsModel:(FYGameReportStatisticsModel *)gameReportStatisticsModel;

@end

@interface FYGameReportViewController : CFCTableRefreshViewController

@property (nonatomic, weak) id<FYGameReportViewControllerDelegate> delegate_header;

@property (nonatomic, copy) NSNumber *gameType; // 一级分类（1:红包游戏,2:电子游戏,3:棋牌游戏,4:彩票,5:电竞,6:体育,7:真人）

@property (nonatomic, copy) NSNumber *gameSubType; // 二级分类（0:福利,1:扫雷,2:牛牛,3:禁枪...1:水果机,2:幸运大转盘,3:奔驰宝马）

- (instancetype)initWithGameType:(NSNumber *)gameType gameSubType:(NSNumber *)gameSubType;

@end

NS_ASSUME_NONNULL_END
