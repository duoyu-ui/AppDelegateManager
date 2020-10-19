//
//  FYBankcardUnBindViewController.h
//  ProjectCSHB
//
//  Created by fangyuan on 2020/6/19.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "CFCTableRefreshViewController.h"
@class FYMyBankCardModel;

NS_ASSUME_NONNULL_BEGIN

@interface FYBankcardUnBindViewController : CFCTableRefreshViewController

@property (nonatomic, strong) FYMyBankCardModel * __nullable currentBankCardModel;

@property (nonatomic, copy) void(^finishUnBindMyBankCardBlock)(FYMyBankCardModel * __nullable bankCardModel, NSMutableArray<FYMyBankCardModel *> * __nullable bankCardModels);

- (instancetype)initWithBankCardModel:(FYMyBankCardModel *)bankCardModel;

@end

NS_ASSUME_NONNULL_END
