//
//  SendRedCheckBalanceHelper.m
//  ProjectCSHB
//
//  Created by fangyuan on 2020/6/4.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "SendRedCheckBalanceHelper.h"
#import "FYBalanceInfoModel.h"
#import "FYBalanceInfoView.h"

@implementation SendRedCheckBalanceHelper

/// 获取余额
+ (void)checkShowBalanceView:(NSString *)title navigation:(UINavigationController *)navigationController
{
    PROGRESS_HUD_SHOW
    [NET_REQUEST_MANAGER getRobFinanceSuccess:^(id response) {
        PROGRESS_HUD_DISMISS
        if (NET_REQUEST_SUCCESS(response)) {
            NSDictionary *dict = NET_REQUEST_DATA(response);
            FYBalanceInfoModel *model = [FYBalanceInfoModel mj_objectWithKeyValues:dict];
            [FYBalanceInfoView showTitle:title balanceInfo:model block:^{
                FYRechargeMainViewController *VC = [[FYRechargeMainViewController alloc] initWithIsPush:YES];
                [navigationController pushViewController:VC animated:YES];
            }];
        } else {
            ALTER_HTTP_MESSAGE(response)
        }
    } fail:^(id error) {
        PROGRESS_HUD_DISMISS
        ALTER_HTTP_ERROR_MESSAGE(error)
    }];
}


@end

