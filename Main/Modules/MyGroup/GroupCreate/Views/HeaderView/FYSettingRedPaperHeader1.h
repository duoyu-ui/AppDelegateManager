//
//  FYSettingRedPaperHeader1.h
//  ProjectCSHB
//
//  Created by fangyuan on 2019/10/20.
//  Copyright © 2019 Fangyuan. All rights reserved.
//  抢庄牛牛&二八杠

#import <UIKit/UIKit.h>
#import "FYCreateGroupModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface FYSettingRedPaperHeader1 : UICollectionReusableView

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UILabel *subtitleLab;

@property (nonatomic, strong) FYCreateGroupModel *model;

@end

NS_ASSUME_NONNULL_END
