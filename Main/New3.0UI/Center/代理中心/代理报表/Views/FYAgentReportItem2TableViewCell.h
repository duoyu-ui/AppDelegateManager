//
//  FYAgentReportItem2TableViewCell.h
//  ProjectCSHB
//
//  Created by fangyuan on 2020/6/29.
//  Copyright © 2020 Fangyuan. All rights reserved.
//
// 代理报表 - 样式二
//

#import <UIKit/UIKit.h>
@class FYAgentReportItem2Model;

NS_ASSUME_NONNULL_BEGIN

@protocol FYAgentReportItem2TableViewCellDelegate <NSObject>
@optional
- (void)didSelectRowAtAgentReportItem2Model:(FYAgentReportItem2Model *)model indexPath:(NSIndexPath *)indexPath;
@end

@interface FYAgentReportItem2TableViewCell : UITableViewCell

@property (nonatomic, strong) NSIndexPath *indexPath;

@property (nonatomic, strong) FYAgentReportItem2Model *model;

@property (nonatomic, weak) id<FYAgentReportItem2TableViewCellDelegate> delegate;

+ (NSString *)reuseIdentifier;

- (void)setModel:(FYAgentReportItem2Model *)model isLastIndexRow:(BOOL)isLastIndexRow;

@end

NS_ASSUME_NONNULL_END
