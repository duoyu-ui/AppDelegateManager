//
//  FYNperHaederView.h
//  ProjectCSHB
//
//  Created by Tom on 2020/7/20.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// 期数view
@interface FYNperHaederView : UIView

/// 游戏类型
@property (nonatomic , assign) NSInteger itemType;

@property (nonatomic , strong) NSDictionary *dict;

@end

NS_ASSUME_NONNULL_END
