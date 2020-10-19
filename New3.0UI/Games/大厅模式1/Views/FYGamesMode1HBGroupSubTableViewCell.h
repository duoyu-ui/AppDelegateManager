//
//  FYGamesMode1HBGroupSubTableViewCell.h
//  ProjectCSHB
//
//  Created by fangyuan on 2020/7/28.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FYGamesMode1HBGroupSubModel, FYGamesMode1ClassModel;

NS_ASSUME_NONNULL_BEGIN

@protocol FYGamesMode1HBGroupSubTableViewCellDelegate <NSObject>
@optional
- (void)didSelectRowAtGamesMode1HBGroupSubModel:(FYGamesMode1HBGroupSubModel *)model indexPath:(NSIndexPath *)indexPath;
@end

@interface FYGamesMode1HBGroupSubTableViewCell : UITableViewCell

@property (nonatomic, strong) NSIndexPath *indexPath;

@property (nonatomic, strong) FYGamesMode1HBGroupSubModel *model;

@property (nonatomic, weak) id<FYGamesMode1HBGroupSubTableViewCellDelegate> delegate;

- (void)setModel:(FYGamesMode1HBGroupSubModel *)model typeModel:(FYGamesMode1ClassModel *)tabTypeModel;

+ (NSString *)reuseIdentifier;

+ (CGFloat)height;

@end

NS_ASSUME_NONNULL_END
