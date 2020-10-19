//
//  FYBindBankcardViewController.h
//  ProjectCSHB
//
//  Created by fangyuan on 2020/6/8.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "CFCTableRefreshViewController.h"
@class FYMyBankCardModel;

NS_ASSUME_NONNULL_BEGIN

@interface FYBindBankcardViewController : CFCTableRefreshViewController

@property (nonatomic, strong) FYMyBankCardModel * __nullable currentBankCardModel;

@property (nonatomic, copy) void(^selectedMyBankCardBlock)(FYMyBankCardModel * __nullable bankCardModel, BOOL isNeedRequest);

- (instancetype)initWithBankCardModel:(FYMyBankCardModel *)bankCardModel;

@end

NS_ASSUME_NONNULL_END
