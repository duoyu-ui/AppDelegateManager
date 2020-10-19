//
//  FYChatRobKeyboardCell.h
//  ProjectCSHB
//
//  Created by 汤姆 on 2019/10/8.
//  Copyright © 2019 Jetter. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FYChatRobKeyboardModel.h"
static NSString * _Nullable const FYChatRobKeyboardCellID = @"FYChatRobKeyboardCellID";
NS_ASSUME_NONNULL_BEGIN

@interface FYChatRobKeyboardCell : UICollectionViewCell
@property (nonatomic, strong) UILabel *titleLab;
/** 背景*/
@property (nonatomic, strong) UIImageView *bgView;
/** 删除*/
@property (nonatomic, strong) UIImageView *deleteImge;

@end

NS_ASSUME_NONNULL_END
