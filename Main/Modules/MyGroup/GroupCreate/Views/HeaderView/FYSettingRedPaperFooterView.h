//
//  FYSettingRedPaperFooterView.h
//  ProjectCSHB
//
//  Created by fangyuan on 2019/10/20.
//  Copyright © 2019 Fangyuan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^DidSaveFinishedBlock)(void);

NS_ASSUME_NONNULL_BEGIN

@interface FYSettingRedPaperFooterView : UICollectionReusableView
/// 保存红包设置
@property (nonatomic, copy) DidSaveFinishedBlock didSaveBlock;

@end

NS_ASSUME_NONNULL_END
