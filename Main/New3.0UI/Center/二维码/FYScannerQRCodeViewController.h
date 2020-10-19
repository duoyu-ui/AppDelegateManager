//
//  FYScannerQRCodeViewController.h
//  ProjectCSHB
//
//  Created by Tom on 2020/5/30.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "FYBaseCoreViewController.h"
@class FYContactSimpleModel;

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, FYQRCodeType) {
    FYQRCodeTypeDefault = 1,   // 无
    FYQRCodeTypeAddFriends,
    FYQRCodeTypeTransferMoney,
    FYQRCodeTypeAddFriendsTransferMoney,
};

@interface FYScannerQRCodeViewController : FYBaseCoreViewController

- (instancetype)initWithType:(FYQRCodeType)type;

@end

NS_ASSUME_NONNULL_END
