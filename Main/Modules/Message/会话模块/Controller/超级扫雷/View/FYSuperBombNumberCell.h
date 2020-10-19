//
//  FYSuperBombNumberCell.h
//  ProjectCSHB
//
//  Created by fangyuan on 2019/11/7.
//  Copyright © 2019 Fangyuan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FYSuperBombNumberCell : UICollectionViewCell

/// 雷号&红包个数
@property (nonatomic, strong) UILabel *numberLabel;
@property (nonatomic , assign) CGFloat cornerRadius;

@end

NS_ASSUME_NONNULL_END
