//
//  FYAgentReportAllTableViewCell.h
//  ProjectCSHB
//
//  Created by fangyuan on 2020/6/29.
//  Copyright © 2020 Fangyuan. All rights reserved.
//
// 代理报表 - 汇总信息
//

#import <UIKit/UIKit.h>
@class FYAgentReportAllModel;

NS_ASSUME_NONNULL_BEGIN

@protocol FYAgentReportAllTableViewCellDelegate <NSObject>
@optional
/// 协议
@end

@interface FYAgentReportAllTableViewCell : UITableViewCell

@property (nonatomic, strong) NSIndexPath *indexPath;

@property (nonatomic, strong) FYAgentReportAllModel *model;

@property (nonatomic, weak) id<FYAgentReportAllTableViewCellDelegate> delegate;

+ (NSString *)reuseIdentifier;

@end

NS_ASSUME_NONNULL_END

