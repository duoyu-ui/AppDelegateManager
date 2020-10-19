//
//  FYAddBankcardViewController.h
//  ProjectCSHB
//
//  Created by fangyuan on 2020/6/9.
//  Copyright © 2020 Fangyuan. All rights reserved.
//

#import "CFCBaseCoreViewController.h"
@class FYBankItemModel;

typedef NS_ENUM(NSInteger, FYAddBankCardResType){
    FYAddBankCardResMyCenterToWithdraw = 1,  // 个人中心 -> 添加银行卡 -> 提现页面
    FYAddBankCardResSelectBankCardToWithdraw = 2, // 选择银行卡 -> 添加银行卡 -> 提现页面
    FYAddBankCardResSelectBankCardToBackSelf = 3, // 选择银行卡 -> 添加银行卡 -> 选择银行卡
    FYAddBankCardResUnBindBankCardToBackSelf = 4, // 解绑银行卡 -> 添加银行卡 -> 解绑银行卡
};

NS_ASSUME_NONNULL_BEGIN

@interface FYAddBankcardViewController : CFCBaseCoreViewController

@property (nonatomic, assign) BOOL isFromPersonSetting;

@property (nonatomic, copy) FYAddBankCardResType(^finishAddBankItemModelBlock)(FYBankItemModel * __nullable bankCardModel);

@end

NS_ASSUME_NONNULL_END
