//
//  FYSettingRedPaperHeader3.h
//  ProjectCSHB
//
//  Created by fangyuan on 2019/10/20.
//  Copyright © 2019 Fangyuan. All rights reserved.
//  扫雷红包

#import <UIKit/UIKit.h>

typedef void(^DidSlectedPacketCountBlock)(NSString * _Nullable amount);

NS_ASSUME_NONNULL_BEGIN

@interface FYSettingRedPaperHeader3 : UICollectionReusableView

/// 发包数量
@property (nonatomic, strong) NSArray *packetList;
/// 上次选中包数
@property (nonatomic, strong) NSString *selectedNum;
/// 选择发包数
@property (nonatomic, copy) DidSlectedPacketCountBlock didPacketBlock;

@end

NS_ASSUME_NONNULL_END
