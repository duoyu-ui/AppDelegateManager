//
//  FYGamesClassContent1HBTableViewCell.h
//  ProjectCSHB
//
//  Created by fangyuan on 2020/5/16.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FYGamesClassContent1HBModel;

NS_ASSUME_NONNULL_BEGIN

UIKIT_EXTERN NSString * const CELL_IDENTIFIER_GAMES_CLASS_CONTENT_1_HONGBAO;

@protocol FYGamesClassContent1HBTableViewCellDelegate <NSObject>
@optional
- (void)didSelectRowAtGamesClassContent1HBModel:(FYGamesClassContent1HBModel *)model indexPath:(NSIndexPath *)indexPath;
@end

@interface FYGamesClassContent1HBTableViewCell : UITableViewCell

@property (nonatomic, strong) NSIndexPath *indexPath;

@property (nonatomic, strong) FYGamesClassContent1HBModel *model;

@property (nonatomic, weak) id<FYGamesClassContent1HBTableViewCellDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
