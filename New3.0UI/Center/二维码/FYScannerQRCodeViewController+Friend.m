//
//  FYScannerQRCodeViewController+Friend.m
//  ProjectCSHB
//
//  Created by fangyuan on 2020/6/5.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "FYScannerQRCodeViewController+Friend.h"
#import "FYAdddFriendInformationViewController.h"
#import "FYMobileContactInformation.h"

@implementation FYScannerQRCodeViewController (Friend)

- (void)doQRCodeResultForAddFriends:(FYContactSimpleModel *)contactSimpleModel
{
    FYAdddFriendInformationViewController *VC = [FYAdddFriendInformationViewController new];
    VC.sourceString = NSLocalizedString(@"来自扫一扫", nil);
    VC.avatarString = contactSimpleModel.avatar;
    VC.userID = contactSimpleModel.userId;
    VC.nickString = contactSimpleModel.nick;
    [self.navigationController pushViewController:VC removeViewController:self];
}

- (void)doQRCodeResultForAddFriendsToTransferMoney:(FYContactSimpleModel *)contactSimpleModel
{
    FYAdddFriendInformationViewController *VC = [FYAdddFriendInformationViewController new];
    VC.isToTransferMoney = YES;
    VC.sourceString = NSLocalizedString(@"来自扫一扫", nil);
    VC.avatarString = contactSimpleModel.avatar;
    VC.userID = contactSimpleModel.userId;
    VC.nickString = contactSimpleModel.nick;
    [self.navigationController pushViewController:VC removeViewController:self];
}

@end
