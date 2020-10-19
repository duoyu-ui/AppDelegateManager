//
//  FYGamesMode1QPGroupSubTableViewCell.h
//  ProjectCSHB
//
//  Created by fangyuan on 2020/7/31.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FYGamesMode1QPGroupSubModel;

NS_ASSUME_NONNULL_BEGIN

@protocol FYGamesMode1QPGroupSubTableViewCellDelegate <NSObject>
@optional
- (void)didSelectRowAtGamesMode1QPGroupSubModel:(FYGamesMode1QPGroupSubModel *)model indexPath:(NSIndexPath *)indexPath;
@end

@interface FYGamesMode1QPGroupSubTableViewCell : UITableViewCell

@property (nonatomic, strong) NSIndexPath *indexPath;

@property (nonatomic, strong) FYGamesMode1QPGroupSubModel *model;

@property (nonatomic, weak) id<FYGamesMode1QPGroupSubTableViewCellDelegate> delegate;

+ (NSString *)reuseIdentifier;

+ (CGFloat)height;

@end

NS_ASSUME_NONNULL_END
