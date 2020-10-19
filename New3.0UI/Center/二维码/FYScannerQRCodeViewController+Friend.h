//
//  FYScannerQRCodeViewController+Friend.h
//  ProjectCSHB
//
//  Created by fangyuan on 2020/6/5.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "FYScannerQRCodeViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface FYScannerQRCodeViewController (Friend)

- (void)doQRCodeResultForAddFriends:(FYContactSimpleModel *)contactSimpleModel;
- (void)doQRCodeResultForAddFriendsToTransferMoney:(FYContactSimpleModel *)contactSimpleModel;

@end

NS_ASSUME_NONNULL_END
