//
//  FYGamesClassContent2QPTableViewCell.h
//  ProjectCSHB
//
//  Created by fangyuan on 2020/5/20.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FYGamesClassContent2QPModel;

NS_ASSUME_NONNULL_BEGIN

UIKIT_EXTERN NSString * const CELL_IDENTIFIER_GAMES_CLASS_CONTENT_2_QIPAI;

@protocol FYGamesClassContent2QPTableViewCellDelegate <NSObject>
@optional
- (void)didSelectRowAtGamesClassContent2QPModel:(FYGamesClassContent2QPModel *)model indexPath:(NSIndexPath *)indexPath;
@end

@interface FYGamesClassContent2QPTableViewCell : UITableViewCell

@property (nonatomic, strong) NSIndexPath *indexPath;

@property (nonatomic, strong) FYGamesClassContent2QPModel *model;

@property (nonatomic, weak) id<FYGamesClassContent2QPTableViewCellDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
