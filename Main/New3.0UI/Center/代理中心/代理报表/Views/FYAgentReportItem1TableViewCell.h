//
//  FYAgentReportItem1TableViewCell.h
//  ProjectCSHB
//
//  Created by fangyuan on 2020/6/29.
//  Copyright © 2020 Fangyuan. All rights reserved.
//
// 代理报表 - 样式一
//

#import <UIKit/UIKit.h>
@class FYAgentReportItem1Model;

NS_ASSUME_NONNULL_BEGIN

@protocol FYAgentReportItem1TableViewCellDelegate <NSObject>
@optional
- (void)didSelectRowAtAgentReportItem1Model:(FYAgentReportItem1Model *)model indexPath:(NSIndexPath *)indexPath;
@end

@interface FYAgentReportItem1TableViewCell : UITableViewCell

@property (nonatomic, strong) NSIndexPath *indexPath;

@property (nonatomic, strong) FYAgentReportItem1Model *model;

@property (nonatomic, weak) id<FYAgentReportItem1TableViewCellDelegate> delegate;

+ (NSString *)reuseIdentifier;

- (void)setModel:(FYAgentReportItem1Model *)model isLastIndexRow:(BOOL)isLastIndexRow;

@end

NS_ASSUME_NONNULL_END

