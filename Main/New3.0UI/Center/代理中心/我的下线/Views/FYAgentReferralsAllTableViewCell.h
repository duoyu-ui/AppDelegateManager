//
//  FYAgentReferralsAllTableViewCell.h
//  ProjectCSHB
//
//  Created by fangyuan on 2020/6/27.
//  Copyright © 2020 Fangyuan. All rights reserved.
//
// 我的下线 - 汇总信息
//

#import <UIKit/UIKit.h>
@class FYAgentReferralsAllModel;

NS_ASSUME_NONNULL_BEGIN

@protocol FYAgentReferralsAllTableViewCellDelegate <NSObject>
@optional
/// 协议
@end


@interface FYAgentReferralsAllTableViewCell : UITableViewCell

@property (nonatomic, strong) NSIndexPath *indexPath;

@property (nonatomic, strong) FYAgentReferralsAllModel *model;

@property (nonatomic, weak) id<FYAgentReferralsAllTableViewCellDelegate> delegate;

+ (NSString *)reuseIdentifier;

@end

NS_ASSUME_NONNULL_END

