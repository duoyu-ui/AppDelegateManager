//
//  FYTransferMoneyInputViewController.h
//  ProjectCSHB
//
//  Created by Tom on 2020/5/29.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "FYBaseCoreViewController.h"
#import "FYMobileContactInformation.h"

NS_ASSUME_NONNULL_BEGIN

@interface FYTransferMoneyInputViewController : FYBaseCoreViewController
@property (nonatomic, strong) FYContactSimpleModel *toUser;
@property (nonatomic, assign) NSInteger maxCount;
@property (nonatomic, assign) NSInteger minMoney;
@property (nonatomic, assign) NSInteger maxMoney;
@end

NS_ASSUME_NONNULL_END
