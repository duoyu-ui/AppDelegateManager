//
//  FYScannerQRCodeViewController+Transfer.m
//  ProjectCSHB
//
//  Created by fangyuan on 2020/6/5.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "FYScannerQRCodeViewController+Transfer.h"
#import "FYTransferMoneyInputViewController.h"
#import "FYHTTPResponseModel.h"

@implementation FYScannerQRCodeViewController (Transfer)

- (void)doQRCodeResultForTransferMoney:(FYContactSimpleModel *)contactSimpleModel
{
    [self requestDataThen:^(NSInteger maxCount, CGFloat minMoney, CGFloat maxMoney) {
        [self toTransferVCWithMaxCount:maxCount minMoney:minMoney maxMoney:maxMoney user:contactSimpleModel];
    }];
}

- (void)toTransferVCWithMaxCount:(NSInteger)maxCount minMoney:(CGFloat)minMoney maxMoney:(CGFloat)maxMoney user:(FYContactSimpleModel *)toUser
{
    FYTransferMoneyInputViewController *VC=[FYTransferMoneyInputViewController new];
    VC.toUser=toUser;
    VC.maxCount = maxCount;
    VC.maxMoney = maxMoney;
    VC.minMoney = minMoney;
    [self.navigationController pushViewController:VC removeViewController:self];
}

- (void)requestDataThen:(void (^)(NSInteger maxCount, CGFloat minMoney, CGFloat maxMoney))then
{
    PROGRESS_HUD_SHOW
    NSString *userId = APPINFORMATION.userInfo.userId;
    [NET_REQUEST_MANAGER requestWithAct:ActRequestTransferMoneyNearRecord parameters:@{ @"userId":userId } success:^(id object) {
        PROGRESS_HUD_DISMISS
        FYLog(@"Transfer History:%@", object);
        FYHTTPResponseModel *response=[FYHTTPResponseModel mj_objectWithKeyValues:object];
        if (response.data) {
            NSDictionary *ruleDict=[response.data valueForKey:@"transferSettingDTO"];
            if (ruleDict) {
                NSInteger maxCount = [ruleDict integerForKey:@"numberTimes"];
                CGFloat minMoney = [ruleDict floatForKey:@"singleTransferMin"];
                CGFloat maxMoney = [ruleDict floatForKey:@"singleTransferMax"];
                !then?:then(maxCount,minMoney,maxMoney);
            }
        }
    } failure:^(id error) {
        PROGRESS_HUD_DISMISS
        ALTER_HTTP_ERROR_MESSAGE(error)
    }];
}

@end

