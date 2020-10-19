//
//  FYAgentReferralsItemTableViewCell.h
//  ProjectCSHB
//
//  Created by fangyuan on 2020/6/27.
//  Copyright © 2020 Fangyuan. All rights reserved.
//
// 我的下线 - 下线信息
//

#import <UIKit/UIKit.h>
@class FYAgentReferralsItemModel;

NS_ASSUME_NONNULL_BEGIN

@protocol FYAgentReferralsItemTableViewCellDelegate <NSObject>
@optional
- (void)didSelectRowAtAgentReferralsItemModel:(FYAgentReferralsItemModel *)model indexPath:(NSIndexPath *)indexPath;
@end

@interface FYAgentReferralsItemTableViewCell : UITableViewCell

@property (nonatomic, strong) NSIndexPath *indexPath;

@property (nonatomic, strong) FYAgentReferralsItemModel *model;

@property (nonatomic, weak) id<FYAgentReferralsItemTableViewCellDelegate> delegate;

+ (NSString *)reuseIdentifier;

- (void)setModel:(FYAgentReferralsItemModel *)model isLastIndexRow:(BOOL)isLastIndexRow;

@end

NS_ASSUME_NONNULL_END

