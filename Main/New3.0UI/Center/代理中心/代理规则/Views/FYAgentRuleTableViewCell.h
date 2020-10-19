//
//  FYAgentRuleTableViewCell.h
//  ProjectCSHB
//
//  Created by fangyuan on 2020/7/29.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FYAgentRuleModel;

NS_ASSUME_NONNULL_BEGIN

@interface FYAgentRuleTableViewCell : UITableViewCell

@property (nonatomic, strong) NSIndexPath *indexPath;

@property (nonatomic, strong) FYAgentRuleModel *model;

+ (NSString *)reuseIdentifier;

+ (CGFloat)height;

@end

NS_ASSUME_NONNULL_END
