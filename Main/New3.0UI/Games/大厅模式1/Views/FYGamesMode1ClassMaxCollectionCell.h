//
//  FYGamesMode1ClassMaxCollectionCell.h
//  ProjectCSHB
//
//  Created by fangyuan on 2020/7/27.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FYGamesMode1ClassModel;

NS_ASSUME_NONNULL_BEGIN

@interface FYGamesMode1ClassMaxCollectionCell : UICollectionViewCell

@property (nonatomic, strong) FYGamesMode1ClassModel *model;

+ (NSString *)reuseIdentifier;

@end

NS_ASSUME_NONNULL_END
