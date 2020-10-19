//
//  FYSuperBombHeaderSectionView.h
//  ProjectCSHB
//
//  Created by fangyuan on 2019/11/7.
//  Copyright © 2019 Fangyuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FYSuperBombAttrModel;

NS_ASSUME_NONNULL_BEGIN

typedef void(^DidEditFinishedBlock)(NSString *money);
typedef void(^DidEditingChangedFinishedBlock)(NSString *money);
@interface FYSuperBombHeaderSectionView : UITableViewHeaderFooterView

@property (nonatomic, strong) FYSuperBombAttrModel *model;

@property (nonatomic, copy) DidEditFinishedBlock didEditBlock;
@property (nonatomic, copy) DidEditingChangedFinishedBlock didEditChangeBlock;
@end

NS_ASSUME_NONNULL_END
