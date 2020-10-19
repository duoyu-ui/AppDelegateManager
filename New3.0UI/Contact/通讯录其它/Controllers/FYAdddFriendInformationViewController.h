//
//  FYAdddFriendInformationViewController.h
//  ProjectCSHB
//
//  Created by Tom on 2020/6/1.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "FYBaseCoreViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface FYAdddFriendInformationViewController : FYBaseCoreViewController

@property (nonatomic, copy) NSString *sourceString;
@property (nonatomic, copy) NSString *avatarString;
@property (nonatomic, copy) NSString *nickString;
@property (nonatomic, copy) NSString *userID;
@property (nonatomic, assign) BOOL isToTransferMoney;

@end

NS_ASSUME_NONNULL_END
