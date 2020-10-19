//
//  GroupHeadView.h
//  Project
//
//  Created by mini on 2018/8/16.
//  Copyright © 2018年 CDJay. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GroupNet, MessageItem;

typedef void (^DidHeaderInfoBlock)(id index);

@interface GroupHeadView : UIView

/// 是否是群主
@property (nonatomic, assign) BOOL isGroupLord;
/// 点击回调
@property (nonatomic, copy) DidHeaderInfoBlock didHeaderBlock;

/// 加载群成员信息
+ (GroupHeadView *)headViewWithModel:(GroupNet *)model
                                item:(MessageItem *)item
                         isGroupLord:(BOOL)isGroupLord;

@end
