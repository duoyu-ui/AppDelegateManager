//
//  FYGamesClassMenuTableViewCell.h
//  ProjectCSHB
//
//  Created by fangyuan on 2020/5/16.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FYGamesClassMenuModel;

NS_ASSUME_NONNULL_BEGIN

UIKIT_EXTERN NSString * const CELL_IDENTIFIER_GAMES_CLASS_MENU;

@protocol FYGamesClassMenuTableViewCellDelegate <NSObject>
@optional
- (void)didSelectRowAtGamesClassMenuModel:(FYGamesClassMenuModel *)model indexPath:(NSIndexPath *)indexPath;
@end

@interface FYGamesClassMenuTableViewCell : UITableViewCell

@property (nonatomic, strong) NSIndexPath *indexPath;

@property (nonatomic, strong) FYGamesClassMenuModel *model;

@property (nonatomic, weak) id<FYGamesClassMenuTableViewCellDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
