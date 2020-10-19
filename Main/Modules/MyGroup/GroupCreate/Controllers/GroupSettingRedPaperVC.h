//
//  GroupSettingRedPaperVC.h
//  ProjectCSHB
//
//  Created by fangyuan on 2019/10/20.
//  Copyright © 2019 Fangyuan. All rights reserved.
//

#import "BaseVC.h"

@class FYCreateRequest;

typedef void(^DidSetedFinishedBlock)(FYCreateRequest * _Nullable result);

NS_ASSUME_NONNULL_BEGIN

@interface GroupSettingRedPaperVC : BaseVC

/// 红包游戏群类型
@property (nonatomic, assign) GroupTemplateType groupType;

/// 设置模型后回调
@property (nonatomic, copy) DidSetedFinishedBlock didSetedBlock;

/// 记录保存样式
@property (nonatomic, strong) FYCreateRequest *packetModel;

/// 是否修改红包设置
@property (nonatomic, assign) BOOL isUpdate;

@end

NS_ASSUME_NONNULL_END
