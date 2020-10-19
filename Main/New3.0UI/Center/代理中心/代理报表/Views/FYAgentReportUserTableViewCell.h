//
//  FYAgentReportUserTableViewCell.h
//  ProjectCSHB
//
//  Created by fangyuan on 2020/7/7.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FYAgentReportUserModel;

NS_ASSUME_NONNULL_BEGIN

@protocol FYAgentReportUserTableViewCellDelegate <NSObject>
@optional
- (void)didSelectRowAtAgentReportUserModel:(FYAgentReportUserModel *)model indexPath:(NSIndexPath *)indexPath;
@end

@interface FYAgentReportUserTableViewCell : UITableViewCell

@property (nonatomic, strong) NSIndexPath *indexPath;

@property (nonatomic, strong) FYAgentReportUserModel *model;

@property (nonatomic, weak) id<FYAgentReportUserTableViewCellDelegate> delegate;

+ (NSString *)reuseIdentifier;

- (void)setModel:(FYAgentReportUserModel *)model;

@end

NS_ASSUME_NONNULL_END

