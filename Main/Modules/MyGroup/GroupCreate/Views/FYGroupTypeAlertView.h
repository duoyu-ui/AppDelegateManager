//
//  FYGroupTypeAlertView.h
//  ProjectCSHB
//
//  Created by fangyuan on 2019/10/19.
//  Copyright © 2019 Fangyuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FYRedPacketListModel;

typedef void(^DidSelectedInfoBlock)(FYRedPacketListModel * _Nonnull result);

NS_ASSUME_NONNULL_BEGIN

@interface FYGroupTypeAlertView : UIView

- (instancetype)initGroupTypeWithData:(NSArray *)dataSource
                        selectedBlock:(DidSelectedInfoBlock)block;

- (void)show;
- (void)dismiss;
- (void)remover;

/// 已选中类型
@property (nonatomic, strong) FYRedPacketListModel *selectedModel;

@end

NS_ASSUME_NONNULL_END
