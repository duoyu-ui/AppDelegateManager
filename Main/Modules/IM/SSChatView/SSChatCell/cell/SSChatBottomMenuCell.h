//
//  SSChatBottomMenuCell.h
//  ProjectCSHB
//
//  Created by fangyuan on 2020/1/8.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SSChatMenuConfig;

NS_ASSUME_NONNULL_BEGIN

@interface SSChatBottomMenuCell : UICollectionViewCell

@property (nonatomic, strong) SSChatMenuConfig *model;

@end

NS_ASSUME_NONNULL_END
