//
//  FYGroupTypeSettingViewController.h
//  ProjectCSHB
//
//  Created by fangyuan on 2020/5/30.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "CFCBaseCoreViewController.h"
@class FYRedPacketListModel;

NS_ASSUME_NONNULL_BEGIN

typedef void(^FYGroupTypeSettingSelectedBlock)(FYRedPacketListModel * _Nonnull result);

@interface FYGroupTypeSettingViewController : CFCBaseCoreViewController

- (instancetype)initWidthGroupTypeListModels:(NSArray<FYRedPacketListModel *> *)arrayOfGroupType
                               selectedModel:(FYRedPacketListModel *)selectedModel
                               completeBlock:(FYGroupTypeSettingSelectedBlock)confirmSelectedBlock;

@end

NS_ASSUME_NONNULL_END
